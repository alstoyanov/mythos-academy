extends Control
## Demeter's Harvest — Arithmetic, the Agora of Numbers, Grade 1 (see docs/SPECIFICATION.md §5.2a).
## Demeter's harvest scale holds a problem: each basket carries one side of an equation on clay tablets
## (3 + 4 = ?, 9 − 3 = ?, 5 + ? = 8, 4 + 3 = 5 + ?), and one number is missing. Four number tablets lie
## in the field below; the child drags the one that balances the scale onto the "?" (or taps it). The
## scale weighs it: level is right; tipped, Demeter says whether the number was too big or too small,
## and the tablet goes back (dimmed). After two wrong answers she helps: wheat and grapes appear in the
## baskets, one for each unit, and she counts with the child (counting all, counting on to the other
## side, or taking away until it matches); then the answer glows.
## Five levels (HarvestRules.Kind): adding to 10, taking away to 10, the missing number, adding and
## taking away to 20, and both sides equal. Each problem solved: sparkles, the equation read aloud, a
## goat bounds across, and a harvest basket flies to the counter; eight finish the level, with stars for
## the problems right at the first try (the best kept per level, App.best_score).
## The rules are in HarvestRules, the scale in HarvestScale, the answers are DragTablets, the wheat and
## grapes HarvestItem; pictures in assets/images/greek/demeter_harvest/ (each has a stand-in).

const ART := "greek/demeter_harvest/"
const GAME_ID := "demeter_harvest"
const LEVEL_NAMES := ["Adding", "Taking away", "The missing number", "Up to 20", "Both sides equal"]
const PRAISE := ["Great!", "Well done!", "Yes, that's it!", "Super!", "Brilliant!"]
const DEMETER_SIZE := Vector2(440, 300)  ## (the poses are 1024 x 700, heads lined up)
const TABLET_SIDE := 112.0
const FLY_TIME := 0.45
const WEIGH_TIME := 1.0  ## seconds the scale swings before the answer is judged
const COUNT_STEP := 0.7  ## seconds per item when counting together
const NEXT_AFTER := 3.8  ## seconds from a solved problem to the next
const GOAT_TIME := 2.6
const CONFETTI := [Color("e4572e"), Color("f2b632"), Color("3f7fc4"), Color("5aa05a"), Color("b060b0")]
const BASKET := -1  ## a harvest basket flying to the counter (in _flying, in place of a tablet's number)

var _rules := HarvestRules.new()
var _demeter: TextureRect
var _poses := {}  # pose -> Texture2D
var _bubble: PanelContainer
var _bubble_label: Label
var _bubble_tween: Tween
var _order_panel: PanelContainer
var _order_row: HBoxContainer
var _progress_label: Label
var _progress_box: Control
var _play: Control  ## the pieces of the problem being played: the scale and the answer tablets
var _scale: HarvestScale
var _tablets: Array[DragTablet] = []
var _overlay: Control  ## on top: tablets flying, sparkles, the goat
var _menu: Control
var _flying: Array[Dictionary] = []  # {number, from, to, t, s0, s1, done}
var _sparks: Array[Dictionary] = []  # {p, v, t, life, star, color, spin, size}
var _goat_t := -1.0  ## the goat bounding across, 0..1 (-1: not there)
var _sky: Texture2D
var _basket_tex: Texture2D
var _sparkle_tex: Texture2D
var _goat_tex: Texture2D
var _busy := false  ## while something plays out (a tablet weighed, Demeter helping, a problem solved)
var _round_id := 0  ## counts the problems, so what plays out for one stops when the next begins
var _playing := false
var _first_problem := false  ## the level's first problem: Demeter says what to do


func _ready() -> void:
	Ui.setup_screen(self)
	_sky = Ui.picture(ART + "background.png")
	_basket_tex = Ui.picture(ART + "harvest_basket.png")
	_sparkle_tex = Ui.picture(ART + "sparkle.png")
	_goat_tex = Ui.picture(ART + "goat_leap.png")
	for pose in ["neutral", "happy", "shake"]:
		var tex := Ui.picture(ART + "demeter_%s.png" % pose)
		if tex != null:
			_poses[pose] = tex

	_play = Control.new()
	_play.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_play.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_play)

	_demeter = TextureRect.new()
	_demeter.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_demeter.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_demeter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_demeter.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_demeter.offset_right = DEMETER_SIZE.x
	_demeter.offset_top = -DEMETER_SIZE.y
	_demeter.pivot_offset = Vector2(DEMETER_SIZE.x * 0.45, DEMETER_SIZE.y)  # (she sways about her waist)
	add_child(_demeter)
	_set_pose("neutral")

	_bubble = PanelContainer.new()  # what Demeter says, above her
	_bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bubble.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_bubble.offset_left = 20
	_bubble.offset_top = -DEMETER_SIZE.y - 10  # (its bottom just above her head; it grows upwards)
	_bubble.offset_bottom = -DEMETER_SIZE.y - 10
	_bubble.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(_bubble)
	_bubble_label = Ui.label(_bubble, "", 28, Ui.INK, 380.0)
	_bubble.visible = false

	_build_order_panel()
	_build_progress()
	Ui.back_button(self)
	_overlay = Control.new()
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.draw.connect(_draw_overlay)
	add_child(_overlay)
	resized.connect(_layout)
	_choose_level()


## Along the top: the problem, big, on tablets ("3 + 4 = ?"); the answer fills the "?" once it is found.
func _build_order_panel() -> void:
	var holder := CenterContainer.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	holder.offset_top = 14
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	_order_panel = PanelContainer.new()
	_order_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(_order_panel)
	_order_row = HBoxContainer.new()
	_order_row.add_theme_constant_override("separation", 10)
	_order_panel.add_child(_order_row)
	_order_panel.visible = false


## The problems solved in this level, top right: a harvest basket and "3 / 8".
func _build_progress() -> void:
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
	var icon := TextureRect.new()
	icon.texture = _basket_tex
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(64, 64)
	row.add_child(icon)
	var done := "0 / %d" % HarvestRules.ROUNDS
	_progress_label = Ui.label(row, done, 40)
	_progress_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_progress_box = panel
	panel.visible = false


# ---------- levels ----------

## Before playing: the five levels, each with its best stars. All are open.
func _choose_level() -> void:
	_playing = false
	_round_id += 1
	_clear_play()
	_order_panel.visible = false
	_progress_box.visible = false
	_hide_bubble()
	_set_pose("neutral")
	var col := _open_menu(tr("Demeter's Harvest"))
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
		row.add_child(StarRow.new(App.best_score(GAME_ID, i + 1)))
		if first == null:
			first = b
	first.call_deferred("grab_focus")


func _start(level: int) -> void:
	_round_id += 1
	_close_menu()
	_rules = HarvestRules.new(level)
	_progress_label.text = "0 / %d" % HarvestRules.ROUNDS
	_progress_box.visible = true
	_order_panel.visible = true
	_playing = true
	_first_problem = true
	_sparks.clear()
	_goat_t = -1.0
	_overlay.queue_redraw()  # (nothing left on it to draw)
	_next_round()


## Eight problems: the level is done. Stars, the best kept, and what next.
func _level_done() -> void:
	_playing = false
	_clear_play()
	_order_panel.visible = false
	var stars := _rules.stars()
	var new_best := App.record_score(GAME_ID, _rules.level + 1, stars)
	_hide_bubble()
	_set_pose("happy")
	_goat_t = 0.0
	Sound.play("fanfare")
	var col := _open_menu(tr("The harvest is ready!"))
	var row := CenterContainer.new()
	col.add_child(row)
	row.add_child(StarRow.new(stars, 64.0))
	if new_best:
		Ui.label(col, tr("New best!"), 36, Color("b8860b"))
	App.say(tr("The harvest is ready!"))
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


# ---------- problems ----------

func _next_round() -> void:
	if not _playing:
		return
	if _rules.level_done():
		_level_done()
		return
	_rules.new_round()
	_round_id += 1
	_clear_play()
	_hide_bubble()
	_busy = false
	_set_pose("neutral")
	var r := _rules
	_scale = HarvestScale.new()
	_scale.left_terms = r.left
	_scale.right_terms = r.right
	_scale.unknown_side = r.unknown_side
	_scale.unknown_index = r.unknown_index
	_scale.weigh(r.difference())
	_scale.settle()
	_play.add_child(_scale)
	for n in r.choices:
		var t := DragTablet.new(n, TABLET_SIDE)
		t.tapped.connect(_send)
		t.dropped.connect(_on_dropped)
		_play.add_child(t)
		_tablets.append(t)
	_show_problem(-1)
	_layout()
	var words := _spoken(false)
	if _first_problem:  # the level's first problem: what to do, then the problem
		_first_problem = false
		words = "%s %s" % [tr("Which number balances the scale?"), words]
	_say(words)
	Sound.play("whoosh")


## The problem on tablets along the top, the missing number as "?" (or `found`, once it is found).
func _show_problem(found: int) -> void:
	for c in _order_row.get_children():
		_order_row.remove_child(c)
		c.queue_free()
	for side in [-1, 1]:
		if side > 0:
			_row_sign("=")
		var terms := _rules.terms(side)
		for i in terms.size():
			if i > 0:
				_row_sign("+" if terms[i] > 0 else "−")
			var t := NumberTablet.new(found if _rules.is_unknown(side, i) else absi(terms[i]), 84.0)
			t.disabled = true
			t.mouse_filter = Control.MOUSE_FILTER_IGNORE
			t.focus_mode = Control.FOCUS_NONE
			t.glowing = _rules.is_unknown(side, i) and found >= 0
			_order_row.add_child(t)


func _row_sign(text: String) -> void:
	var l := Ui.label(_order_row, text, 60, Color("5a2a14"))
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER


## The problem in words, to read aloud: "3 plus 4 equals how many?", or with the answer: "3 plus 4
## equals 7!".
func _spoken(with_answer: bool) -> String:
	var words: Array[String] = []
	for side in [-1, 1]:
		if side > 0:
			words.append(tr("equals"))
		var terms := _rules.terms(side)
		for i in terms.size():
			if i > 0:
				words.append(tr("plus") if terms[i] > 0 else tr("minus"))
			if _rules.is_unknown(side, i) and not with_answer:
				words.append(tr("how many"))
			else:
				words.append(str(absi(terms[i])))
	return " ".join(PackedStringArray(words)) + ("!" if with_answer else "?")


func _clear_play() -> void:
	for c in _play.get_children():
		c.queue_free()
	_tablets.clear()
	_flying.clear()
	_scale = null


## Places the pieces: Demeter keeps the lower left; to her right the scale, and the answers below it.
func _layout() -> void:
	var left := DEMETER_SIZE.x + 10.0
	var right := size.x - 20.0
	var row := size.y - 16.0 - TABLET_SIDE
	var gap := minf(60.0, (right - left - _tablets.size() * TABLET_SIDE) / maxf(1.0, _tablets.size() - 1))
	var width := _tablets.size() * TABLET_SIDE + (_tablets.size() - 1) * gap
	for i in _tablets.size():
		var t := _tablets[i]
		t.home = Vector2((left + right) / 2.0 - width / 2.0 + i * (TABLET_SIDE + gap), row)
		if not t.dragging and t.visible:
			t.position = t.home
	if _scale != null:
		var top := 150.0  # (below the problem along the top)
		_scale.position = Vector2(left, top)
		_scale.size = Vector2(right - left, maxf(260.0, row - top - 10.0))
	queue_redraw()


# ---------- playing ----------

## A tablet onto the "?": it flies there, the scale weighs it, and Demeter judges.
func _send(tablet: DragTablet) -> void:
	if _busy or not _playing or _scale == null or tablet.tried or not tablet.visible:
		return
	_busy = true
	var number := tablet.value
	tablet.visible = false
	var from := tablet.position + tablet.size / 2.0
	var to := _scale.position + _scale.slot_center()
	var on_scale := _scale
	_fly(number, from, to, TABLET_SIDE, _scale.pan_side() * 0.24, func() -> void:
		if on_scale == _scale:  # (not if a new problem came meanwhile)
			_weigh(tablet))


## Dropped on the basket with the "?": the tablet goes in; anywhere else it slides back to its place.
func _on_dropped(tablet: DragTablet) -> void:
	var centre := tablet.global_position + tablet.size / 2.0
	if not _busy and _playing and _scale != null and _scale.slot_rect().has_point(centre):
		_send(tablet)
	else:
		var tw := tablet.create_tween()
		tw.tween_property(tablet, "position", tablet.home, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## The number is in the "?": the scale swings, then it is right (level) or not (tipped).
func _weigh(tablet: DragTablet) -> void:
	var basket := _round_id
	var number := tablet.value
	_scale.guess = number
	_scale.weigh(_rules.difference(number))
	Sound.play("drop")
	await get_tree().create_timer(WEIGH_TIME).timeout
	if basket != _round_id:
		return
	if _rules.check(number):
		_solved()
	else:
		_wrong(tablet)


## A wrong number: Demeter gently shakes her head and says whether it was too big or too small; the
## tablet goes back, dimmed. After the first, the wheat and grapes appear in the baskets for the child
## to count alone if they like; after the second, she counts with them.
func _wrong(tablet: DragTablet) -> void:
	var basket := _round_id
	var number := tablet.value
	_set_pose("shake")
	_shake_head()
	Sound.play("oops")
	if number > _rules.answer:
		_say(tr("%d is too big. Try a smaller number.") % number)
	else:
		_say(tr("%d is too small. Try a bigger number.") % number)
	await get_tree().create_timer(2.2).timeout
	if basket != _round_id:
		return
	# the tablet goes back to its place, dimmed; the scale is as before
	_scale.guess = -1
	_scale.weigh(_rules.difference())
	tablet.tried = true
	tablet.visible = true
	tablet.position = tablet.home
	tablet.wobble()
	Sound.play("pop")
	_set_pose("neutral")
	if _rules.hint_due():
		await _help()
		if basket != _round_id:
			return
	else:
		_show_heaps()
		Sound.play("whoosh")
		_say(tr("Here are wheat and grapes, if you want to count."))
	_busy = false


## Demeter helps: wheat and grapes in the baskets, one for each unit, and she counts with the child —
## all of them (3 + 4 = ?, 9 − 3 = ?), on from her side to the other (5 + ? = 8), or taking away until
## both sides match (8 − ? = 5). Then the right tablet glows.
func _help() -> void:
	var basket := _round_id
	var u := _rules.unknown_side
	var mine := _rules.terms(u)
	_show_heaps()
	_say(tr("Let's count together!"))
	await get_tree().create_timer(1.6).timeout
	var words := ""
	if mine.size() == 1:  # the result is missing: count the other side's items (not those eaten)
		var heap := _scale.items(-u)
		var n := 0
		for i in heap.size():
			if heap[i]["style"] != HarvestScale.SOLID:
				continue
			n += 1
			var going: bool = await _mark(basket, -u, i, n)
			if not going:
				return
		var taken := _rules.terms(-u)[1] < 0
		words = (tr("%d are left.") if taken else tr("That makes %d.")) % n
	elif mine[_rules.unknown_index] > 0:  # a part to add: count on from this side to the other side
		var heap := _scale.items(u)
		var have := _rules.value(u)
		var going: bool = await _mark(basket, u, heap.size() - 1, have)  # (this side's number at once)
		if not going:
			return
		for k in _rules.answer:
			heap.append({"kind": HarvestItem.GRAPES, "style": HarvestScale.GHOST})
			_scale.weigh(_rules.difference(k + 1))
			going = await _mark(basket, u, heap.size() - 1, have + k + 1)
			if not going:
				return
		words = tr("We need %d more.") % _rules.answer
	else:  # a part to take away: take them away one by one until both sides match
		var heap := _scale.items(u)
		for k in _rules.answer:
			var i := heap.size() - 1 - k
			heap[i]["style"] = HarvestScale.EATEN
			_scale.weigh(_rules.difference(k + 1))
			Sound.play("munch")
			var going: bool = await _mark(basket, u, i, k + 1)
			if not going:
				return
		words = tr("We take away %d.") % _rules.answer
	_scale.marked_side = 0
	_say(words)
	for t in _tablets:
		t.glowing = t.value == _rules.answer


## The wheat and grapes in both baskets, one for each unit of their numbers.
func _show_heaps() -> void:
	for side in [-1, 1]:
		_heap(side)


## The items for a side: a bundle of wheat for each of its first number, grapes for each added, and the
## last ones faded for each taken away; nothing yet for the missing number.
func _heap(side: int) -> void:
	var heap := _scale.items(side)
	heap.clear()
	var terms := _rules.terms(side)
	for i in terms.size():
		if _rules.is_unknown(side, i):
			continue
		if terms[i] > 0:
			for k in terms[i]:
				heap.append({"kind": HarvestItem.WHEAT if i == 0 else HarvestItem.GRAPES, "style": HarvestScale.SOLID})
		else:
			var eaten := 0
			for k in range(heap.size() - 1, -1, -1):
				if eaten < -terms[i] and heap[k]["style"] == HarvestScale.SOLID:
					heap[k]["style"] = HarvestScale.EATEN
					eaten += 1


## Marks item `i` of a side's heap with `n`, read aloud; false if the problem is over meanwhile.
func _mark(basket: int, side: int, i: int, n: int) -> bool:
	_scale.marked_side = side
	_scale.marked = i
	_scale.mark_text = str(n)
	Sound.play("tick")
	App.say(str(n))
	await get_tree().create_timer(COUNT_STEP).timeout
	return basket == _round_id


## Solved: the scale is level. Sparkles, the equation read aloud, the goat, and a harvest basket flies
## to the counter.
func _solved() -> void:
	var again := _rules.mistakes > 0
	_set_pose("happy")
	Sound.play("burst")
	Sound.play("coin")
	_burst(_scale.position + _scale.rim(1))
	_burst(_scale.position + _scale.rim(-1))
	_goat_t = 0.0
	_show_problem(_rules.answer)
	for t in _tablets:
		t.glowing = false
	var praise: String = tr(PRAISE[randi() % PRAISE.size()]) if not again else tr("Now it balances!")
	_say("%s %s" % [praise, _spoken(true)])
	var to := _progress_box.position + Vector2(48, 44)
	_fly(BASKET, _scale.position + _scale.rim(1), to, 90.0, 64.0, func() -> void:
		_progress_label.text = "%d / %d" % [_rules.round_index, HarvestRules.ROUNDS]
		Sound.play("coin"))
	var basket := _round_id
	get_tree().create_timer(NEXT_AFTER).timeout.connect(func() -> void:
		if basket == _round_id:
			_next_round())


## A burst of golden sparkles and confetti from `at`.
func _burst(at: Vector2) -> void:
	for k in 26:
		var a := randf_range(-PI * 0.92, -PI * 0.08)  # (upwards)
		_sparks.append({"p": at, "v": Vector2(cos(a), sin(a)) * randf_range(220.0, 520.0), "t": 0.0,
			"life": randf_range(1.0, 1.6), "star": k % 2 == 0, "color": CONFETTI[k % CONFETTI.size()],
			"spin": randf_range(-8.0, 8.0), "size": randf_range(16.0, 28.0)})


## A tablet with `number` (or BASKET) flies along an arc from `from` to `to`, its size from `s0` to
## `s1`; `done` when it lands.
func _fly(number: int, from: Vector2, to: Vector2, s0: float, s1: float, done: Callable) -> void:
	_flying.append({"number": number, "from": from, "to": to, "t": 0.0, "s0": s0, "s1": s1, "done": done})


## Demeter says something (shown in her bubble, read aloud).
func _say(words: String) -> void:
	_hide_bubble()
	_bubble_label.text = words
	_bubble.visible = true
	_bubble.modulate.a = 1.0
	App.say(words)
	_bubble_tween = _bubble.create_tween()
	_bubble_tween.tween_interval(3.2)
	_bubble_tween.tween_property(_bubble, "modulate:a", 0.0, 0.4)
	_bubble_tween.tween_callback(func() -> void: _bubble.visible = false)


func _hide_bubble() -> void:
	if _bubble_tween != null and _bubble_tween.is_valid():
		_bubble_tween.kill()
	_bubble.visible = false


func _set_pose(pose: String) -> void:
	_demeter.texture = _poses.get(pose, _poses.get("neutral", null))


## A gentle "not quite": Demeter sways from side to side.
func _shake_head() -> void:
	var tw := _demeter.create_tween()
	for k in 3:
		tw.tween_property(_demeter, "rotation", 0.035, 0.12)
		tw.tween_property(_demeter, "rotation", -0.035, 0.12)
	tw.tween_property(_demeter, "rotation", 0.0, 0.1)


func _process(delta: float) -> void:
	if _flying.is_empty() and _sparks.is_empty() and _goat_t < 0.0:
		return
	var i := _flying.size() - 1
	while i >= 0:
		var f: Dictionary = _flying[i]
		f["t"] += delta / FLY_TIME
		if f["t"] >= 1.0:
			_flying.remove_at(i)
			(f["done"] as Callable).call()
		i -= 1
	i = _sparks.size() - 1
	while i >= 0:
		var s: Dictionary = _sparks[i]
		s["t"] += delta
		s["v"] += Vector2(0.0, 700.0 * delta)
		s["p"] += (s["v"] as Vector2) * delta
		if s["t"] >= s["life"]:
			_sparks.remove_at(i)
		i -= 1
	if _goat_t >= 0.0:
		_goat_t += delta / GOAT_TIME
		if _goat_t >= 1.0:
			_goat_t = -1.0
	_overlay.queue_redraw()


func _draw_overlay() -> void:
	for f in _flying:
		var t: float = minf(1.0, f["t"])
		var p: Vector2 = (f["from"] as Vector2).lerp(f["to"], t) + Vector2(0.0, -sin(t * PI) * 90.0)
		var s: float = lerpf(f["s0"], f["s1"], t)
		var rect := Rect2(p - Vector2(s, s) / 2.0, Vector2(s, s))
		if f["number"] != BASKET:
			NumberTablet.draw_tablet(_overlay, rect, f["number"])
		elif _basket_tex != null:
			_overlay.draw_texture_rect(_basket_tex, rect, false)
		else:
			_overlay.draw_circle(p, s * 0.4, Color("c89a52"))
	for sp in _sparks:
		var fade: float = clampf((sp["life"] - sp["t"]) / 0.4, 0.0, 1.0)
		var p: Vector2 = sp["p"]
		var s: float = sp["size"]
		_overlay.draw_set_transform(p, sp["spin"] * sp["t"])
		if not sp["star"]:
			var c: Color = sp["color"]
			_overlay.draw_rect(Rect2(-s / 2.0, -s / 4.0, s, s / 2.0), Color(c, fade))
		elif _sparkle_tex != null:
			_overlay.draw_texture_rect(_sparkle_tex, Rect2(-s, -s, s * 2.0, s * 2.0), false, Color(1, 1, 1, fade))
		else:  # a four-pointed golden sparkle
			_overlay.draw_colored_polygon(PackedVector2Array([Vector2(0, -s), Vector2(s * 0.22, -s * 0.22),
				Vector2(s, 0), Vector2(s * 0.22, s * 0.22), Vector2(0, s), Vector2(-s * 0.22, s * 0.22),
				Vector2(-s, 0), Vector2(-s * 0.22, -s * 0.22)]), Color(1.0, 0.85, 0.3, fade))
	_overlay.draw_set_transform(Vector2.ZERO)
	if _goat_t >= 0.0:  # the goat bounds across the bottom of the screen, left to right
		var g := 220.0
		var at := Vector2(lerpf(-g, size.x + 20.0, _goat_t), size.y - g - 10.0 - absf(sin(_goat_t * PI * 5.0)) * 80.0)
		if _goat_tex != null:
			_overlay.draw_texture_rect(_goat_tex, Rect2(at, Vector2(g, g)), false)
		else:
			_overlay.draw_circle(at + Vector2(g * 0.45, g * 0.6), g * 0.25, Color.WHITE)
			_overlay.draw_circle(at + Vector2(g * 0.78, g * 0.38), g * 0.13, Color.WHITE)
			for x in [0.3, 0.6]:
				_overlay.draw_line(at + Vector2(g * x, g * 0.75), at + Vector2(g * x, g * 0.95), Color("7a6a5a"), 6.0)


func _draw() -> void:
	if _sky != null:
		var ts := _sky.get_size()
		var s := maxf(size.x / ts.x, size.y / ts.y)
		draw_texture_rect(_sky, Rect2((size - ts * s) / 2.0, ts * s), false)
	else:  # a sunny sky, green hills, the field
		draw_rect(Rect2(Vector2.ZERO, size), Color("bfe3f2"))
		draw_circle(Vector2(size.x * 0.3, size.y * 0.75), size.x * 0.45, Color("9cc76a"))
		draw_circle(Vector2(size.x * 0.85, size.y * 0.8), size.x * 0.4, Color("8bbb5c"))
		draw_rect(Rect2(0, size.y * 0.7, size.x, size.y * 0.3), Color("c9a86a"))
	if _demeter.texture == null:  # a drawn Demeter: a pastel robe, a head and a golden crown
		var base := Vector2(DEMETER_SIZE.x * 0.45, size.y)
		draw_rect(Rect2(base + Vector2(-120, -200), Vector2(240, 200)), Color("cfe3c8"))
		draw_circle(base + Vector2(0, -250), 60.0, Color("f0c8a0"))
		draw_arc(base + Vector2(0, -262), 58.0, PI * 1.1, PI * 1.9, 16, Color("e8b84a"), 14.0)
