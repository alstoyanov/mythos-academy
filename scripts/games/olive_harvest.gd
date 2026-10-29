extends Control
## Olive Harvest — Arithmetic, the Agora of Numbers, Grade 1 (see docs/SPECIFICATION.md §5.2).
## A merchant at his stall in the Agora orders olives; five levels (OliveRules.Kind):
##   1 Count: tap the olive tree to drop olives into the basket, tap the basket to take one out,
##     then "Done";  2 Match: tap the basket with the number asked for;  3 Add: two baskets, how many
##     altogether?;  4 Take away: the goat eats some, how many are left?;  5 To 20: count to 11–20,
##     a whole row of ten at a time or one by one.
## Nothing is taken away: a wrong answer makes the merchant count the olives together with the child
## (each olive marked with its number, read aloud), and after two the right answer glows. Each order
## done pays a coin; ten coins finish the level, with stars for the orders right at the first try
## (the best kept per level, App.best_score).
## The rules are in OliveRules; pictures in assets/images/greek/olive_harvest/ (each has a stand-in).

const ART := "greek/olive_harvest/"
const GAME_ID := "olive_harvest"
const LEVEL_NAMES := ["Count the olives", "Find the basket", "Add the olives", "The hungry goat", "Up to 20"]
const PRAISE := ["Great!", "Well done!", "Yes, that's it!", "Super!", "Brilliant!", "You got it!"]
const MERCHANT_SIZE := Vector2(440, 300)  ## (the poses are 1024 x 700, heads lined up)
const FLY_TIME := 0.45
const COUNT_STEP := 0.75  ## seconds per olive when counting together

var _rules := OliveRules.new()
var _merchant: TextureRect
var _poses := {}  # pose -> Texture2D
var _bubble: PanelContainer
var _bubble_label: Label
var _order_panel: PanelContainer
var _order_tablet: NumberTablet
var _order_label: Label
var _coin_label: Label
var _coin_box: Control
var _play: Control  ## the pieces of the order being played (baskets, tablets, tree, buttons)
var _overlay: Control  ## on top: olives and coins flying
var _flying: Array[Dictionary] = []  # {tex, from, to, t, size}
var _menu: Control
var _sky: Texture2D
var _tree_tex: Texture2D
var _olive_tex: Texture2D
var _coin_tex: Texture2D
var _goat_tex: Texture2D
var _basket: OliveBasket  ## the basket to fill (COUNT, TENS) or the one the goat eats from (TAKE)
var _answers: Array = []  ## the tappable answers: NumberTablet or OliveBasket
var _busy := false  ## while something plays out (olives counted, the goat eating, a coin flying)
var _pending := 0  ## olives on their way to the basket
var _order_id := 0  ## counts the orders, so what plays out for one stops when the next begins
var _bubble_tween: Tween
var _playing := false


func _ready() -> void:
	Ui.setup_screen(self)
	_sky = Ui.picture(ART + "background.png")
	_tree_tex = Ui.picture(ART + "olive_tree.png")
	_olive_tex = Ui.picture(ART + "olive_green.png")
	_coin_tex = Ui.picture(ART + "coin.png")
	_goat_tex = Ui.picture(ART + "goat.png")
	for pose in ["neutral", "happy", "thinking"]:
		var tex := Ui.picture(ART + "merchant_%s.png" % pose)
		if tex != null:
			_poses[pose] = tex

	_play = Control.new()
	_play.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_play.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_play)

	_merchant = TextureRect.new()
	_merchant.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_merchant.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_merchant.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_merchant.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_merchant.offset_right = MERCHANT_SIZE.x
	_merchant.offset_top = -MERCHANT_SIZE.y
	add_child(_merchant)
	_set_pose("neutral")

	_bubble = PanelContainer.new()  # what the merchant says, above him
	_bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bubble.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_bubble.offset_left = 20
	_bubble.offset_top = -MERCHANT_SIZE.y - 10  # (its bottom just above his head; it grows upwards)
	_bubble.offset_bottom = -MERCHANT_SIZE.y - 10
	_bubble.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(_bubble)
	_bubble_label = Ui.label(_bubble, "", 28, Ui.INK, 380.0)
	_bubble.visible = false

	_build_order_panel()
	_build_coins()
	Ui.back_button(self)
	_overlay = Control.new()
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.draw.connect(_draw_flying)
	add_child(_overlay)
	resized.connect(_layout)
	_choose_level()


## The order along the top: the number asked for on a tablet (for the counting levels) and the words.
func _build_order_panel() -> void:
	var holder := CenterContainer.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	holder.offset_top = 14
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	_order_panel = PanelContainer.new()
	_order_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(_order_panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	_order_panel.add_child(row)
	_order_tablet = NumberTablet.new(0, 84.0)
	_order_tablet.disabled = true
	_order_tablet.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_order_tablet.focus_mode = Control.FOCUS_NONE
	row.add_child(_order_tablet)
	_order_label = Ui.label(row, "", 34, Ui.INK, 0.0)
	_order_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_order_panel.visible = false


## The coins earned in this level, top right: a coin and "3 / 10".
func _build_coins() -> void:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	panel.offset_left = -230
	panel.offset_right = -20
	panel.offset_top = 16
	panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	add_child(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	panel.add_child(row)
	var coin := TextureRect.new()
	coin.texture = _coin_tex
	coin.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	coin.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	coin.custom_minimum_size = Vector2(64, 64)
	row.add_child(coin)
	var coins := "0 / %d" % OliveRules.ORDERS
	_coin_label = Ui.label(row, coins, 40)
	_coin_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_coin_box = panel
	panel.visible = false


# ---------- levels ----------

## Before playing: the five levels, each with its best stars. All are open.
func _choose_level() -> void:
	_playing = false
	_clear_play()
	_order_panel.visible = false
	_coin_box.visible = false
	_hide_bubble()
	_set_pose("neutral")
	var col := _open_menu(tr("Olive Harvest"))
	Ui.label(col, tr("Choose a level"), 28, Ui.INK.lightened(0.15))
	var first: Button = null
	for i in LEVEL_NAMES.size():
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 16)
		col.add_child(row)
		var caption := "%d · %s" % [i + 1, tr(LEVEL_NAMES[i])]
		var b := Ui.button(row, caption, _start.bind(i), 28)
		b.custom_minimum_size = Vector2(460, 66)
		b.set_meta("sound", "start")
		var stars := StarRow.new(App.best_score(GAME_ID, i + 1))
		row.add_child(stars)
		if first == null:
			first = b
	first.call_deferred("grab_focus")


func _start(level: int) -> void:
	_order_id += 1
	_close_menu()
	_rules = OliveRules.new(level)
	_coin_label.text = "0 / %d" % OliveRules.ORDERS
	_coin_box.visible = true
	_order_panel.visible = true
	_playing = true
	_next_order()


## Ten coins: the level is done. Stars, the best kept, and what next.
func _level_done() -> void:
	_playing = false
	_clear_play()
	_order_panel.visible = false
	var stars := _rules.stars()
	var new_best := App.record_score(GAME_ID, _rules.level + 1, stars)
	_hide_bubble()
	_set_pose("happy")
	Sound.play("fanfare")
	var col := _open_menu(tr("All the baskets are full!"))
	var row := CenterContainer.new()
	col.add_child(row)
	row.add_child(StarRow.new(stars, 64.0))
	if new_best:
		Ui.label(col, tr("New best!"), 36, Color("b8860b"))
	App.say(tr("All the baskets are full!"))
	var buttons := HBoxContainer.new()
	buttons.add_theme_constant_override("separation", 16)
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_child(buttons)
	var focus := Ui.button(buttons, tr("Play again"), _start.bind(_rules.level), 28)
	focus.set_meta("sound", "start")
	if _rules.level + 1 < LEVEL_NAMES.size():
		focus = Ui.button(buttons, tr("Next level"), _start.bind(_rules.level + 1), 28)
		focus.set_meta("sound", "start")
	Ui.button(buttons, tr("Choose a level"), _choose_level, 28)
	focus.call_deferred("grab_focus")


func _open_menu(title: String) -> VBoxContainer:
	_close_menu()
	_menu = CenterContainer.new()
	_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_menu)
	move_child(_menu, _overlay.get_index())
	var panel := PanelContainer.new()
	_menu.add_child(panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 12)
	panel.add_child(col)
	Ui.label(col, title, 44)
	return col


func _close_menu() -> void:
	if _menu != null:
		_menu.queue_free()
		_menu = null


# ---------- orders ----------

func _next_order() -> void:
	if not _playing:
		return
	if _rules.level_done():
		_level_done()
		return
	_rules.new_order()
	_order_id += 1
	_clear_play()
	_hide_bubble()
	_busy = false
	_pending = 0
	_set_pose("neutral")
	var r := _rules
	_order_tablet.visible = r.kind in [OliveRules.Kind.COUNT, OliveRules.Kind.MATCH, OliveRules.Kind.TENS]
	_order_tablet.value = r.target
	match r.kind:
		OliveRules.Kind.COUNT, OliveRules.Kind.TENS:
			_order_label.text = tr("%s, please!") % olives_text(r.target)
			var tens := r.kind == OliveRules.Kind.TENS
			_basket = _add_basket(0, 10 if tens else 5, 420.0 if tens else 340.0)
			_basket.pressed.connect(_take_one_out)
			_add_tree()
			if r.kind == OliveRules.Kind.TENS:
				_add_button("ten", tr("Ten olives"), _drop_ten)
			_add_button("done", tr("Done"), func() -> void: _check(_basket.count, _basket))
		OliveRules.Kind.MATCH:
			_order_label.text = tr("Which basket has %s?") % olives_text(r.target)
			for n in r.baskets:
				var b := _add_basket(n, 5, 250.0)
				b.pressed.connect(func() -> void: _check(b.count, b))
				_answers.append(b)
		OliveRules.Kind.ADD:
			_order_label.text = tr("%s and %d more. How many altogether?") % [olives_text(r.a), r.b]
			_add_basket(r.a, 5, 250.0).disabled = true
			var plus := Ui.label(_play, "+", 96, Color.WHITE)
			plus.add_theme_constant_override("outline_size", 14)
			plus.add_theme_color_override("font_outline_color", Color("5a3a1e"))
			plus.set_meta("role", "plus")
			_add_basket(r.b, 5, 250.0).disabled = true
			_add_tablets()
		OliveRules.Kind.TAKE:
			_order_label.text = tr("There are %s in the basket.") % olives_text(r.a)
			_basket = _add_basket(r.a, 5, 280.0)
			_basket.disabled = true
			_busy = true
			_goat_eats(r.b)
	_layout()
	App.say(_order_label.text)
	Sound.play("whoosh")


## "1 olive" / "3 olives" in the game's language (Bulgarian: "една маслина" / "3 маслини").
func olives_text(n: int) -> String:
	return tr("one olive") if n == 1 else tr("%d olives") % n


func _add_basket(n: int, row: int, side: float) -> OliveBasket:
	var b := OliveBasket.new(Vector2(side, side), n, row)
	b.set_meta("role", "basket")
	_play.add_child(b)
	return b


func _add_tree() -> void:
	var tree := TextureButton.new()
	tree.texture_normal = _tree_tex
	tree.ignore_texture_size = true
	tree.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	tree.custom_minimum_size = Vector2(380, 380)
	tree.size = tree.custom_minimum_size
	tree.pivot_offset = tree.size / 2.0
	tree.set_meta("role", "tree")
	tree.add_to_group("silent")
	tree.pressed.connect(_drop_one)
	_play.add_child(tree)


func _add_button(role: String, text: String, on_press: Callable) -> void:
	var b := Ui.button(_play, text, on_press, 32)
	b.custom_minimum_size = Vector2(230, 90)
	b.set_meta("role", role)


## Three tablets with numbers, the answer among them (ADD, TAKE).
func _add_tablets() -> void:
	for n in _rules.choices:
		var t := NumberTablet.new(n, 130.0)
		t.set_meta("role", "tablet")
		t.pressed.connect(func() -> void: _check(t.value, t))
		_play.add_child(t)
		_answers.append(t)


func _clear_play() -> void:
	for c in _play.get_children():
		c.queue_free()
	_answers.clear()
	_basket = null


## Places the pieces: the merchant keeps the lower left; the rest is the stall's counter to his right.
func _layout() -> void:
	var left := MERCHANT_SIZE.x + 10.0
	var w := maxf(400.0, size.x - left - 20.0)
	var bottom := size.y - 20.0
	var baskets: Array[Control] = []
	var tablets: Array[Control] = []
	for c in _play.get_children():
		if c.is_queued_for_deletion():
			continue
		match c.get_meta("role", ""):
			"basket":
				baskets.append(c)
			"tablet":
				tablets.append(c)
			"tree":
				c.position = Vector2(size.x - 400.0, bottom - 500.0)
			"ten":
				c.position = Vector2(size.x - 500.0, bottom - c.size.y)
			"done":
				c.position = Vector2(size.x - 250.0, bottom - c.size.y)
	var kind := _rules.kind
	if kind == OliveRules.Kind.COUNT or kind == OliveRules.Kind.TENS:
		for b in baskets:
			b.position = Vector2(left + (size.x - 420.0 - left) / 2.0 - b.size.x / 2.0, bottom - b.size.y - 20.0)
	else:
		var row_y := bottom - (170.0 if kind == OliveRules.Kind.ADD or kind == OliveRules.Kind.TAKE else 0.0)
		for i in baskets.size():
			var b := baskets[i]
			var cx := left + w * (i + 0.5) / baskets.size()
			if kind == OliveRules.Kind.TAKE:
				cx = left + w * 0.38
			b.position = Vector2(cx - b.size.x / 2.0, row_y - b.size.y)
		var plus := _role("plus")
		if plus != null and baskets.size() == 2:  # between the two baskets
			plus.position = (baskets[0].position + baskets[1].position + baskets[1].size) / 2.0 - plus.size / 2.0
		for i in tablets.size():
			var t := tablets[i]
			t.position = Vector2(left + w * (i + 0.5) / tablets.size() - t.size.x / 2.0, bottom - t.size.y)
	queue_redraw()


# ---------- playing ----------

func _drop_one() -> void:
	if _busy or _basket == null or _basket.count + _pending >= 20:
		return
	_fly_olive(_basket.count + _pending)


## A whole row of ten (To 20): if the basket can take it.
func _drop_ten() -> void:
	if _busy or _basket == null or _basket.count + _pending + 10 > 20:
		return
	_busy = true
	var start := _basket.count + _pending
	for k in 10:
		get_tree().create_timer(0.06 * k).timeout.connect(_fly_olive.bind(start + k, k == 9))


## An olive from the tree to place `index` in the basket; it is counted aloud as it lands.
func _fly_olive(index: int, last_of_ten: bool = false) -> void:
	var tree := _role("tree")
	if tree == null or _basket == null:
		return
	var from := tree.position + tree.size * Vector2(0.5, 0.35) + Vector2(randf_range(-80, 80), randf_range(-50, 50))
	var to := _basket.position + _basket.olive_position(index)
	_pending += 1
	var basket := _basket
	_flying.append({"tex": _olive_tex, "from": from, "to": to, "t": 0.0, "size": _basket.olive_size(),
		"done": func() -> void:
			_pending = maxi(0, _pending - 1)
			if basket != _basket or not is_instance_valid(basket):  # (a new order came meanwhile)
				return
			_basket.count += 1
			Sound.play("drop")
			if _rules.kind == OliveRules.Kind.COUNT or last_of_ten or _basket.count % 10 != 0:
				App.say(str(_basket.count))
			if last_of_ten:
				_busy = false})


func _take_one_out() -> void:
	if _busy or _pending > 0 or _basket == null or _basket.count == 0:
		return
	_basket.count -= 1
	_basket.hop()
	Sound.play("pop")


func _check(value: int, piece: Control) -> void:
	if _busy or _pending > 0 or not _playing:
		return
	if _rules.answer(value):
		_right(piece)
	else:
		_wrong(value, piece)


func _right(piece: Control) -> void:
	_busy = true
	for a in _answers:
		a.set("glowing", false)
	piece.set("glowing", true)
	_set_pose("happy")
	var words: String = tr(PRAISE[randi() % PRAISE.size()])
	_say("%s %s" % [words, tr("Here is a coin.")])
	Sound.play("burst")
	# a coin flies from the merchant to the coins
	var from := _merchant.position + _merchant.size * Vector2(0.45, 0.55)
	var to := _coin_box.position + Vector2(50, 48)
	_flying.append({"tex": _coin_tex, "from": from, "to": to, "t": 0.0, "size": 70.0, "done": func() -> void:
		_coin_label.text = "%d / %d" % [_rules.coins, OliveRules.ORDERS]
		Sound.play("coin")})
	get_tree().create_timer(1.8).timeout.connect(_next_order)


## A wrong answer: the piece wobbles, and the olives are counted together; then the child tries again.
func _wrong(value: int, piece: Control) -> void:
	_busy = true
	if piece.has_method("wobble"):
		piece.call("wobble")
	Sound.play("oops")
	_set_pose("thinking")
	_say(tr("Let's count together!"))
	var kind := _rules.kind
	var baskets: Array[OliveBasket] = []
	if kind == OliveRules.Kind.MATCH:
		baskets = [piece as OliveBasket]
	elif kind == OliveRules.Kind.ADD:
		for c in _play.get_children():
			if c is OliveBasket and not c.is_queued_for_deletion():
				baskets.append(c)
	else:
		baskets = [_basket]
	var order := _order_id
	await get_tree().create_timer(1.0).timeout
	var n := 0
	for b in baskets:
		var i := 0
		while i < b.count:
			if not is_inside_tree() or not _playing or order != _order_id or not is_instance_valid(b):
				return
			if kind == OliveRules.Kind.TENS and i == 0 and b.count >= 10:  # a full row of ten at once
				i = 9
			n = i + 1 if b == baskets[0] else n + 1
			b.counted = i
			Sound.play("tick")
			App.say(str(n))
			await get_tree().create_timer(COUNT_STEP).timeout
			if order != _order_id or not is_instance_valid(b):
				return
			i += 1
		b.counted = -1
	var words := ""
	match kind:
		OliveRules.Kind.COUNT, OliveRules.Kind.TENS:
			words = tr("The basket is empty.") if n == 0 else tr("We have %d. The merchant wants %d.") % [n, _rules.target]
		OliveRules.Kind.MATCH:
			words = tr("This basket has %s.") % olives_text(n)
		OliveRules.Kind.ADD:
			words = tr("That makes %d.") % n
		OliveRules.Kind.TAKE:
			words = tr("%d are left.") % n
	_say(words)
	if _rules.hint_due():
		for a in _answers:
			var v: int = a.get("count") if a is OliveBasket else a.get("value")
			a.set("glowing", v == _rules.target)
	_busy = false


## The goat walks in, eats `k` olives one by one, and the question is asked (TAKE).
func _goat_eats(k: int) -> void:
	var goat := TextureRect.new()
	goat.texture = _goat_tex
	goat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	goat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	goat.mouse_filter = Control.MOUSE_FILTER_IGNORE
	goat.size = Vector2(260, 260)
	goat.flip_h = true  # (it faces right in the picture: it comes from the right, looking left)
	goat.set_meta("role", "goat")
	_play.add_child(goat)
	_layout()
	var at := _basket.position + Vector2(_basket.size.x * 0.85, _basket.size.y - goat.size.y)
	goat.position = Vector2(size.x + 20.0, at.y)
	var tw := goat.create_tween()
	tw.tween_interval(1.2)
	tw.tween_property(goat, "position", at, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	for i in k:
		tw.tween_interval(0.35)
		tw.tween_callback(func() -> void:
			if _basket != null:
				_basket.count -= 1
				_basket.hop()
				Sound.play("munch"))
	tw.tween_interval(0.5)
	tw.tween_callback(func() -> void:
		_order_label.text = tr("The goat ate %d. How many are left?") % k
		App.say(_order_label.text)
		_add_tablets()
		_layout()
		_busy = false)


## The merchant says something (shown in his bubble, read aloud).
func _say(words: String) -> void:
	_hide_bubble()
	_bubble_label.text = words
	_bubble.visible = true
	_bubble.modulate.a = 1.0
	App.say(words)
	_bubble_tween = _bubble.create_tween()
	_bubble_tween.tween_interval(2.4)
	_bubble_tween.tween_property(_bubble, "modulate:a", 0.0, 0.4)
	_bubble_tween.tween_callback(func() -> void: _bubble.visible = false)


func _hide_bubble() -> void:
	if _bubble_tween != null and _bubble_tween.is_valid():
		_bubble_tween.kill()
	_bubble.visible = false


func _set_pose(pose: String) -> void:
	_merchant.texture = _poses.get(pose, _poses.get("neutral", null))


func _role(role: String) -> Control:
	for c in _play.get_children():
		if c.get_meta("role", "") == role and not c.is_queued_for_deletion():
			return c
	return null


func _process(delta: float) -> void:
	if _flying.is_empty():
		return
	var i := _flying.size() - 1
	while i >= 0:
		var f: Dictionary = _flying[i]
		f["t"] += delta / FLY_TIME
		if f["t"] >= 1.0:
			_flying.remove_at(i)
			(f["done"] as Callable).call()
		i -= 1
	_overlay.queue_redraw()


func _draw_flying() -> void:
	for f in _flying:
		var t: float = minf(1.0, f["t"])
		var p: Vector2 = (f["from"] as Vector2).lerp(f["to"], t) + Vector2(0.0, -sin(t * PI) * 90.0)
		var s: float = f["size"]
		if f["tex"] != null:
			_overlay.draw_texture_rect(f["tex"], Rect2(p - Vector2(s, s) / 2.0, Vector2(s, s)), false)
		else:
			_overlay.draw_circle(p, s * 0.45, Color("6b8e23"))


func _draw() -> void:
	if _sky != null:
		var ts := _sky.get_size()
		var s := maxf(size.x / ts.x, size.y / ts.y)
		draw_texture_rect(_sky, Rect2((size - ts * s) / 2.0, ts * s), false)
	else:
		draw_rect(Rect2(Vector2.ZERO, size), Color("f1dcb2"))
		draw_rect(Rect2(0, size.y * 0.7, size.x, size.y * 0.3), Color("b98a58"))
	if _merchant.texture == null:  # a drawn merchant: a robe and a head with a beard
		var base := Vector2(MERCHANT_SIZE.x * 0.5, size.y)
		draw_rect(Rect2(base + Vector2(-120, -200), Vector2(240, 200)), Color("f1e6cc"))
		draw_circle(base + Vector2(0, -250), 60.0, Color("e8b48a"))
		draw_circle(base + Vector2(0, -215), 45.0, Color("2b2320"))
