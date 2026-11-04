extends Control
## Aeolus' Balloons — Arithmetic, the Agora of Numbers, Grade 1 (see docs/SPECIFICATION.md §5.2b).
## A row of balloons with different numbers (and sizes) hangs on Aeolus' rope. The child puts them in
## order by swapping two neighbours at a time: tap one balloon, then the one next to it (or swipe a
## balloon sideways). Undo takes a swap back, Hint makes a pair that is in the wrong order glow, Restart
## starts the same row again. No timer, nothing is taken away. The rules are in BalloonRules; the balloons
## are drawn by Balloon; this is the screen. Three levels (BalloonRules.LEVELS), each with its best stars.
## No pictures are needed: the sky, the rope and the balloons are drawn.

const GAME_ID := "aeolus_balloons"  ## the key of its best scores (the level is the "seconds" of App.record_score)
const LEVEL_NAMES := ["Five balloons", "Eight balloons", "Biggest first"]
const GOAL_NAMES := ["From the smallest to the biggest", "From the biggest to the smallest"]  ## by BalloonRules.Direction
const SWAP_TIME := 0.18
const SIDE_MARGIN := 60.0
const MAX_PLACE := 150.0  ## the widest place of a balloon
const STRING_LENGTH := 70.0
const BOTTOM_ROOM := 210.0  ## from the rope to the bottom of the screen (message and buttons)

var _rules := BalloonRules.new()
var _balloons: Array[Balloon] = []  ## by place, left to right
var _selected: Balloon = null
var _board: Control
var _goal_panel: PanelContainer
var _goal_label: Label
var _swaps_label: Label
var _message: Label
var _bar: HBoxContainer
var _undo_button: Button
var _menu: Control
var _busy := false  ## while a swap moves or the balloons celebrate
var _playing := false
var _round := 0  ## counts the puzzles, so what waits for one is dropped when the next begins


func _ready() -> void:
	Ui.setup_screen(self)
	_add_sky()
	_board = Control.new()
	_board.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_board.mouse_filter = Control.MOUSE_FILTER_PASS
	_board.draw.connect(_draw_rope)
	add_child(_board)

	var holder := CenterContainer.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	holder.offset_top = 16
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	_goal_panel = PanelContainer.new()
	_goal_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(_goal_panel)
	_goal_label = Ui.label(_goal_panel, "", 38)

	_swaps_label = Ui.label(self, "", 30)
	_swaps_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_swaps_label.offset_left = -300
	_swaps_label.offset_right = -24
	_swaps_label.offset_top = 150
	_swaps_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_swaps_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_message = Ui.label(self, "", 30, Ui.INK, 900.0)
	_message.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_message.offset_top = -190
	_message.offset_bottom = -126
	_message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_message.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_bar = HBoxContainer.new()
	_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	_bar.add_theme_constant_override("separation", 20)
	_bar.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_bar.offset_top = -112
	_bar.offset_bottom = -20
	add_child(_bar)
	_undo_button = Ui.button(_bar, tr("Undo"), _undo, 30)
	_undo_button.custom_minimum_size = Vector2(230, Ui.TOUCH_MIN)
	var hint := Ui.button(_bar, tr("Hint"), _hint, 30)
	hint.custom_minimum_size = Vector2(230, Ui.TOUCH_MIN)
	var again := Ui.button(_bar, tr("Restart"), _restart, 30)
	again.custom_minimum_size = Vector2(230, Ui.TOUCH_MIN)

	Ui.back_button(self)
	resized.connect(_layout)
	_choose_level()


## Back from a puzzle goes to the choice of level (from there, out of the game).
func on_back() -> bool:
	if _playing:
		_choose_level()
		return true
	return false


func _add_sky() -> void:
	var bg := TextureRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	var picture := Ui.picture("greek/aeolus_balloons/background.png")
	if picture != null:
		bg.texture = picture
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	else:
		var grad := Gradient.new()
		grad.colors = PackedColorArray([Color("7fc0e8"), Color("d9efff")])
		var tex := GradientTexture2D.new()
		tex.gradient = grad
		tex.fill_from = Vector2(0.5, 0.0)
		tex.fill_to = Vector2(0.5, 1.0)
		bg.texture = tex
	add_child(bg)
	move_child(bg, 0)


# ---------- the levels ----------

## Before playing: the three levels, each with its best stars. All are open.
func _choose_level() -> void:
	_playing = false
	_busy = false
	_round += 1
	_clear_balloons()
	_set_play_ui(false)
	var col := _open_menu(tr("Aeolus' Balloons"))
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
	_rules = BalloonRules.new(level)
	_playing = true
	_busy = false
	_set_play_ui(true)
	_goal_label.text = tr(GOAL_NAMES[_rules.direction])
	_build_balloons()
	_after_change(tr("Swap two neighbouring balloons to put them in order."))
	App.say(_goal_label.text)


func _set_play_ui(on: bool) -> void:
	_goal_panel.visible = on
	_swaps_label.visible = on
	_message.visible = on
	_bar.visible = on


func _restart() -> void:
	if not _playing or _busy:
		return
	_rules.restart()
	_build_balloons()
	_after_change(tr("Swap two neighbouring balloons to put them in order."))


# ---------- the balloons ----------

func _clear_balloons() -> void:
	for b in _balloons:
		b.queue_free()
	_balloons = []
	_selected = null


func _build_balloons() -> void:
	_clear_balloons()
	for v in _rules.values:
		var b := Balloon.new(v)
		b.pressed.connect(_on_pressed.bind(b))
		b.swiped.connect(_on_swiped.bind(b))
		_board.add_child(b)
		_balloons.append(b)
	_layout()


func _rope_y() -> float:
	return size.y - BOTTOM_ROOM


func _place_width() -> float:
	return minf((size.x - SIDE_MARGIN * 2.0) / maxf(1.0, float(_balloons.size())), MAX_PLACE)


func _place_x(i: int) -> float:
	var w := _place_width()
	return (size.x - w * _balloons.size()) / 2.0 + i * w


## Puts every balloon in its place (the rope, and the room each one takes).
func _layout() -> void:
	if _board == null:
		return
	var w := _place_width()
	var h := Balloon.body_height(w, BalloonRules.MAX_NUMBER) + 6.0 + STRING_LENGTH
	for i in _balloons.size():
		_balloons[i].size = Vector2(w, h)
		_balloons[i].position = Vector2(_place_x(i), _rope_y() - h)
	_board.queue_redraw()


func _draw_rope() -> void:
	if _balloons.is_empty():
		return
	var y := _rope_y()
	var x0 := _place_x(0) - 24.0
	var x1 := _place_x(_balloons.size()) + 24.0
	_board.draw_line(Vector2(x0, y), Vector2(x1, y), Color("8a5a2b"), 8.0, true)
	_board.draw_line(Vector2(x0, y - 2.0), Vector2(x1, y - 2.0), Color("b98450"), 3.0, true)
	for x in [x0, x1]:
		_board.draw_circle(Vector2(x, y), 12.0, Color("5d3a1a"))


func _index_of(b: Balloon) -> int:
	return _balloons.find(b)


func _on_pressed(b: Balloon) -> void:
	if not _playing or _busy:
		return
	if _selected == null:
		_select(b)
	elif _selected == b:
		_select(null)
	elif absi(_index_of(_selected) - _index_of(b)) == 1:
		var left := mini(_index_of(_selected), _index_of(b))
		_select(null)
		_swap(left)
	else:
		_select(b)


func _on_swiped(direction: int, b: Balloon) -> void:
	if not _playing or _busy:
		return
	var i := _index_of(b)
	var j := i + direction
	if j < 0 or j >= _balloons.size():
		return
	_select(null)
	_swap(mini(i, j))


func _select(b: Balloon) -> void:
	if _selected != null:
		_selected.selected = false
	_selected = b
	if b != null:
		b.selected = true
		_clear_glow()


func _clear_glow() -> void:
	for b in _balloons:
		b.glow = false


## Swaps the balloons at `i` and `i + 1` for the child.
func _swap(i: int) -> void:
	if _rules.swap(i):
		_move_pair(i)
		Sound.play("drop")
		_after_change("")


func _undo() -> void:
	if not _playing or _busy or not _rules.can_undo():
		return
	_select(null)
	var i := _rules.undo()
	_move_pair(i)
	Sound.play("pop")
	_after_change("")


## The two balloons at `i` and `i + 1` trade places on the rope.
func _move_pair(i: int) -> void:
	var a := _balloons[i]
	var b := _balloons[i + 1]
	_balloons[i] = b
	_balloons[i + 1] = a
	_clear_glow()
	_busy = true
	var round_now := _round
	var tw := create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(b, "position:x", _place_x(i), SWAP_TIME)
	tw.tween_property(a, "position:x", _place_x(i + 1), SWAP_TIME)
	tw.chain().tween_callback(func() -> void:
		if round_now == _round:
			_busy = false
			if _playing and _rules.is_sorted():
				_celebrate())


## The swaps counted, the Undo button, and what Aeolus says; `text` "" clears the last words.
func _after_change(text: String) -> void:
	_swaps_label.text = tr("Swaps: %d") % _rules.swaps
	_undo_button.disabled = not _rules.can_undo()
	_message.text = text


func _hint() -> void:
	if not _playing or _busy:
		return
	var i := _rules.hint()
	if i < 0:
		return
	_select(null)
	_clear_glow()
	_balloons[i].glow = true
	_balloons[i + 1].glow = true
	Sound.play("whoosh")
	_message.text = tr("These two are in the wrong order. Swap them!")
	App.say(_message.text)


# ---------- the end of a puzzle ----------

## Every balloon hops in turn, then the stars.
func _celebrate() -> void:
	_playing = false
	_busy = true
	_select(null)
	_clear_glow()
	_message.text = tr("All the balloons are in order!")
	App.say(_message.text)
	Sound.play("fanfare")
	var round_now := _round
	for k in _balloons.size():
		var hop := create_tween()
		hop.tween_interval(k * 0.09)
		hop.tween_property(_balloons[k], "hop", 36.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		hop.tween_property(_balloons[k], "hop", 0.0, 0.22).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	var tw := create_tween()
	tw.tween_interval(1.6)
	tw.tween_callback(func() -> void:
		if round_now == _round:
			_level_done())


func _level_done() -> void:
	_busy = false
	var stars := _rules.stars()
	var new_best := App.record_score(GAME_ID, _rules.level + 1, stars)
	_set_play_ui(false)
	var col := _open_menu(tr("All the balloons are in order!"))
	var row := CenterContainer.new()
	col.add_child(row)
	row.add_child(StarRow.new(stars, 64.0))
	Ui.label(col, tr("Swaps: %d") % _rules.swaps, 28)
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
