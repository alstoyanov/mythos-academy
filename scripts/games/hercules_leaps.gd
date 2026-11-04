extends Control
## Hercules' Leaps — Arithmetic, the Agora of Numbers, Grade 1 (see docs/SPECIFICATION.md §5.2c).
## Hercules stands on a cliff with a number; across the chasm is a cliff with another. The child chooses
## + or − and a digit (0 to 9, all on tablets along the bottom) that make the sum true: 1 + 4 = 5. He
## leaps, the view moves on so that he is back on the left, and the next cliff is across the next chasm.
## A wrong answer never drops him: he stays on his cliff, and is told why (which way the number goes, or
## what his sum makes); after two in a leap the right sign and number glow. A level is ten leaps. No timer,
## nothing is taken away. The rules are in LeapRules; this is the screen.
## Pictures: assets/images/greek/hercules_leaps/ (see assets/prompts/G_HERCULES_LEAPS.md); each has a
## drawn stand-in.

const ART := "greek/hercules_leaps/"
const GAME_ID := "hercules_leaps"  ## the key of its best scores (the level is the "seconds" of App.record_score)
const LEVEL_NAMES := ["Up to 5", "Up to 10", "From 10 to 20", "Up to 20"]
const PRAISE := ["Great!", "Well done!", "Yes, that's it!", "Super!", "Brilliant!"]
const PLUS := "+"
const MINUS := "−"
const TILE := 88.0  ## the side of a sign or number tablet (Ui.TOUCH_MIN)
const BOTTOM_ROOM := 250.0  ## from the ground to the bottom of the screen
const LEAP_TIME := 0.8
const LEAP_HEIGHT := 130.0  ## (he stays below the sum along the top)
const PAUSE_AFTER_LANDING := 0.9
const SCROLL_TIME := 0.7

var _rules := LeapRules.new()
var _world: Control  ## the cliffs and Hercules: it moves, to keep him on the left
var _hero: LeapHero
var _stones: Array[LeapStone] = []  ## the cliffs still in use: the last is across the chasm
var _stone_index := 0  ## how many leaps he has made: the cliff he stands on (the world's x is by it)
var _equation_panel: PanelContainer
var _equation: Label
var _counter_panel: PanelContainer
var _counter: Label
var _bubble: PanelContainer
var _bubble_label: Label
var _bubble_tween: Tween
var _pad: HBoxContainer
var _plus: NumberTablet
var _minus: NumberTablet
var _digits: Array[NumberTablet] = []
var _sign := 0  ## the sign chosen: 1, -1, or 0 for none yet
var _amount := -1  ## the number chosen, -1 for none yet
var _menu: Control
var _busy := false  ## while he leaps and the view moves
var _playing := false
var _round := 0  ## counts the games, so what waits for one is dropped when the next begins


func _ready() -> void:
	Ui.setup_screen(self)
	_add_background()
	_world = Control.new()
	_world.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_world)
	_hero = LeapHero.new()
	_world.add_child(_hero)
	_build_pad()
	_build_equation()
	_build_counter()
	_build_bubble()
	Ui.back_button(self)
	resized.connect(_layout)
	_choose_level()


## Back from a game goes to the choice of level (from there, out of the game).
func on_back() -> bool:
	if _playing:
		_choose_level()
		return true
	return false


func _add_background() -> void:
	var bg := TextureRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	var picture := Ui.picture(ART + "background.png")
	if picture != null:
		bg.texture = picture
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	else:  # sky above a misty valley
		var grad := Gradient.new()
		grad.colors = PackedColorArray([Color("8ec5dc"), Color("e4eef0"), Color("b9b2c9")])
		grad.offsets = PackedFloat32Array([0.0, 0.6, 1.0])
		var tex := GradientTexture2D.new()
		tex.gradient = grad
		tex.fill_from = Vector2(0.5, 0.0)
		tex.fill_to = Vector2(0.5, 1.0)
		bg.texture = tex
		bg.stretch_mode = TextureRect.STRETCH_SCALE
	add_child(bg)


## Along the bottom: the two signs, then every one digit number.
func _build_pad() -> void:
	_pad = HBoxContainer.new()
	_pad.alignment = BoxContainer.ALIGNMENT_CENTER
	_pad.add_theme_constant_override("separation", 8)
	_pad.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_pad.offset_top = -TILE - 16.0
	_pad.offset_bottom = -16.0
	add_child(_pad)
	_plus = _add_tile(0, PLUS)
	_plus.pressed.connect(_choose_sign.bind(1))
	_minus = _add_tile(0, MINUS)
	_minus.pressed.connect(_choose_sign.bind(-1))
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(24, 0)
	_pad.add_child(gap)
	for d in 10:
		var tile := _add_tile(d, "")
		tile.pressed.connect(_choose_amount.bind(d))
		_digits.append(tile)


func _add_tile(value: int, caption: String) -> NumberTablet:
	var tile := NumberTablet.new(value, TILE)
	tile.caption = caption
	_pad.add_child(tile)
	return tile


## Along the top: the sum to complete.
func _build_equation() -> void:
	var holder := CenterContainer.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	holder.offset_top = 16
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	_equation_panel = PanelContainer.new()
	_equation_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(_equation_panel)
	_equation = Ui.label(_equation_panel, "", 54)
	_equation.custom_minimum_size.x = 380.0


func _build_counter() -> void:
	_counter_panel = PanelContainer.new()
	_counter_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_counter_panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_counter_panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	_counter_panel.offset_top = 20
	_counter_panel.offset_right = -20
	add_child(_counter_panel)
	_counter = Ui.label(_counter_panel, "", 32)


## What is said, under the sum (over the chasm, between the two cliffs' figures).
func _build_bubble() -> void:
	var holder := CenterContainer.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	holder.offset_top = 128
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	_bubble = PanelContainer.new()
	_bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(_bubble)
	_bubble_label = Ui.label(_bubble, "", 28, Ui.INK, 600.0)
	_bubble.visible = false


# ---------- the levels ----------

## Before playing: the levels, each with its best stars. All are open.
func _choose_level() -> void:
	_playing = false
	_busy = false
	_round += 1
	_clear_stones()
	_hero.visible = false
	_set_play_ui(false)
	_hide_bubble()
	var col := _open_menu(tr("Hercules' Leaps"))
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
	_round += 1
	_close_menu()
	_rules = LeapRules.new(level)
	_playing = true
	_busy = false
	_stone_index = 0
	_clear_stones()
	_add_stone(_rules.here, 0)
	_add_stone(_rules.there, 1)
	_hero.pose = "idle"
	_hero.visible = true
	_set_play_ui(true)
	_layout()
	_new_question()
	_say(tr("Choose + or −, then a number, to take Hercules to %d.") % _rules.there)


func _set_play_ui(on: bool) -> void:
	_equation_panel.visible = on
	_counter_panel.visible = on
	_pad.visible = on


# ---------- the cliffs ----------

func _clear_stones() -> void:
	for s in _stones:
		s.queue_free()
	_stones = []


## A cliff for the `index`-th place along the way.
func _add_stone(value: int, index: int) -> void:
	var stone := LeapStone.new(value)
	stone.set_meta("index", index)
	_world.add_child(stone)
	_world.move_child(_hero, -1)  # (he stands in front of the cliffs)
	_stones.append(stone)
	_place_stone(stone)


func _place_stone(stone: LeapStone) -> void:
	stone.position = Vector2(int(stone.get_meta("index")) * _gap() - LeapStone.WIDTH / 2.0, _ground_y())


func _ground_y() -> float:
	return size.y - BOTTOM_ROOM


## From one cliff's middle to the next: half the screen, so one is at a quarter of it and one at three.
func _gap() -> float:
	return maxf(600.0, size.x * 0.5)


## The world's x when he stands on the `index`-th cliff.
func _world_x(index: int) -> float:
	return size.x / 2.0 - _gap() / 2.0 - index * _gap()


func _feet(index: int) -> Vector2:
	return Vector2(index * _gap(), _ground_y())


func _layout() -> void:
	if _world == null:
		return
	_world.position.x = _world_x(_stone_index)
	for s in _stones:
		_place_stone(s)
	_hero.position = LeapHero.corner_for(_feet(_stone_index))


# ---------- the question ----------

func _new_question() -> void:
	_sign = 0
	_amount = -1
	_clear_glow()
	_show_choice()
	_counter.text = "%d / %d" % [_rules.jumps_done, LeapRules.JUMPS]


## The sum so far, with "?" for what is still to choose, and the sign marked on its tablet.
func _show_choice() -> void:
	var sign_text := "?"
	if _sign != 0:
		sign_text = PLUS if _sign > 0 else MINUS
	var amount_text := str(_amount) if _amount >= 0 else "?"
	_equation.text = "%d  %s  %s  =  %d" % [_rules.here, sign_text, amount_text, _rules.there]
	_plus.selected = _sign > 0
	_minus.selected = _sign < 0


func _choose_sign(chosen: int) -> void:
	if not _playing or _busy:
		return
	Sound.play("drop")
	_sign = chosen
	_show_choice()
	if _amount >= 0:
		_check()


func _choose_amount(chosen: int) -> void:
	if not _playing or _busy:
		return
	Sound.play("drop")
	_amount = chosen
	_show_choice()
	if _sign != 0:
		_check()
	else:
		_say(tr("Now choose + or −."))


func _check() -> void:
	match _rules.answer(_sign, _amount):
		LeapRules.Result.RIGHT:
			_leap()
		LeapRules.Result.WRONG_SIGN:
			_wrong_sign()
		LeapRules.Result.WRONG_AMOUNT:
			_wrong_amount()


## Which way the number goes: he never has to work out a sum that would fall below zero.
func _wrong_sign() -> void:
	var words: String
	if _sign < 0:
		words = tr("%d is bigger than %d, so we add.") % [_rules.there, _rules.here]
	else:
		words = tr("%d is smaller than %d, so we take away.") % [_rules.there, _rules.here]
	var tile := _minus if _sign < 0 else _plus
	_after_wrong(tile, words)
	_sign = 0
	_amount = -1
	_show_choice()


## What the child's sum makes, against what is needed.
func _wrong_amount() -> void:
	var made := _rules.result_of(_sign, _amount)
	var sum := "%d %s %d = %d." % [_rules.here, PLUS if _sign > 0 else MINUS, _amount, made]
	_after_wrong(_digits[_amount], "%s %s" % [sum, tr("We need %d.") % _rules.there])
	_amount = -1
	_show_choice()


func _after_wrong(tile: NumberTablet, words: String) -> void:
	tile.wobble()
	Sound.play("oops")
	_hero.pose = "think"
	_say(words)
	if _rules.hint_due():
		_clear_glow()
		(_plus if _rules.needed_sign() > 0 else _minus).glowing = true
		_digits[_rules.needed_amount()].glowing = true


func _clear_glow() -> void:
	_plus.glowing = false
	_minus.glowing = false
	for d in _digits:
		d.glowing = false


# ---------- the leap ----------

## Right: he flies across on an arc, lands, is praised; then the view moves on (or the level ends).
func _leap() -> void:
	_busy = true
	_clear_glow()
	_hide_bubble()
	_hero.pose = "jump"
	Sound.play("whoosh")
	var round_now := _round
	var from := LeapHero.corner_for(_feet(_stone_index))
	var to := LeapHero.corner_for(_feet(_stone_index + 1))
	var tw := create_tween()
	tw.tween_method(func(t: float) -> void:
		_hero.position = from.lerp(to, t) + Vector2(0.0, -LEAP_HEIGHT * 4.0 * t * (1.0 - t)),
		0.0, 1.0, LEAP_TIME)
	tw.tween_callback(func() -> void:
		if round_now == _round:
			_landed())


func _landed() -> void:
	_stone_index += 1
	_rules.land()
	_hero.pose = "happy"
	Sound.play("coin")
	_counter.text = "%d / %d" % [_rules.jumps_done, LeapRules.JUMPS]
	_say(tr(PRAISE[randi() % PRAISE.size()]))
	var round_now := _round
	var tw := create_tween()
	tw.tween_interval(PAUSE_AFTER_LANDING)
	tw.tween_callback(func() -> void:
		if round_now != _round:
			return
		if _rules.level_done():
			_level_done()
		else:
			_move_on())


## The next cliff comes in from the right, and the one he stands on goes back to the left.
func _move_on() -> void:
	_hide_bubble()
	_add_stone(_rules.there, _stone_index + 1)
	_new_question()
	_hero.pose = "idle"
	var round_now := _round
	var tw := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(_world, "position:x", _world_x(_stone_index), SCROLL_TIME)
	tw.tween_callback(func() -> void:
		if round_now != _round:
			return
		_drop_old_stones()
		_busy = false
		App.say(tr("Now to %d.") % _rules.there))


## Only the cliff he stands on and the next one are still on the screen.
func _drop_old_stones() -> void:
	while _stones.size() > 2:
		_stones.pop_front().queue_free()


# ---------- the end of a level ----------

func _level_done() -> void:
	_playing = false
	_busy = false
	_hide_bubble()
	_set_play_ui(false)
	var stars := _rules.stars()
	var new_best := App.record_score(GAME_ID, _rules.level + 1, stars)
	Sound.play("fanfare")
	var col := _open_menu(tr("Hercules crossed every chasm!"))
	App.say(tr("Hercules crossed every chasm!"))
	var row := CenterContainer.new()
	col.add_child(row)
	row.add_child(StarRow.new(stars, 64.0))
	if new_best:
		Ui.label(col, tr("New best!"), 36, Color("b8860b"))
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


# ---------- what is said ----------

func _say(words: String) -> void:
	_hide_bubble()
	_bubble_label.text = words
	_bubble.visible = true
	_bubble.modulate.a = 1.0
	App.say(words)
	_bubble_tween = _bubble.create_tween()
	_bubble_tween.tween_interval(3.0)
	_bubble_tween.tween_property(_bubble, "modulate:a", 0.0, 0.4)
	_bubble_tween.tween_callback(func() -> void: _bubble.visible = false)


func _hide_bubble() -> void:
	if _bubble_tween != null and _bubble_tween.is_valid():
		_bubble_tween.kill()
	_bubble.visible = false
