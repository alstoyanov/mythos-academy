extends Control
## The Mosaic of Words — Language, the Grove of the Muses, Grade 1 (see docs/SPECIFICATION.md §5.4b).
## A word search, in Bulgarian whatever the game's language: Clio, the Muse of history, keeps the words in
## her scroll basket, and they are hidden in an old floor mosaic covered with letter tiles. At the start
## the words fly out of the basket onto cards; the child finds each one in the rectangle (a drag from its
## first letter to its last, or a tap on each). A word found turns its tiles to glass, showing a piece of
## the picture underneath; when all are found, every tile opens in a wave and the whole mosaic is shown
## and named (Pegasus, Athena's owl, ...).
## Chosen before playing (kept while the game runs): the size (5 × 8 to 8 × 12), the directions (across,
## or across and down) and the letters (the first 10, the first 20 or all). Each choice keeps its best
## stars. A wrong line only gets a gentle word; part of a word is "Almost!"; after two wrong lines (or with
## the Hint button) the first letter of a word glows. Nothing is ever taken away; no timer.
## The rules are in MosaicRules, the rectangle in MosaicGrid, the cards MosaicWordCard. Pictures:
## assets/images/greek/word_mosaic/ (see assets/prompts/H_WORD_MOSAIC.md); each has a drawn stand-in.

const ART := "greek/word_mosaic/"
const GAME_ID := "word_mosaic"  ## the key of its best stars (with MosaicRules.key)
## The pictures under the tiles: [file name (mosaic_<name>.jpg), what Clio calls it].
const MOSAICS := [
	["pegasus", "Pegasus, the winged horse"],
	["owl", "the owl of Athena"],
	["dolphin", "the dolphin of Poseidon"],
	["lyre", "the lyre of Apollo"],
	["argo", "the ship Argo"],
	["olympus", "Mount Olympus"],
]
const PRAISE := ["Great!", "Well done!", "Yes, that's it!", "Super!", "Brilliant!", "You got it!"]
const DIRECTION_NAMES := ["Across", "Across and down"]
const DIRECTION_ARROWS := ["→", "→ ↓"]
const LETTER_NAMES := ["The first 10 letters", "The first 20 letters", "All the letters"]
const LETTER_RANGES := ["А – Й", "А – У", "А – Я"]
## The colour of each word found: its ring in the mosaic and its card.
const COLOURS := [Color("e0a030"), Color("3a9fb0"), Color("d9604c"), Color("8a5cc0"), Color("4f9a4f"),
	Color("4a7fd0"), Color("e07a3a"), Color("c0508a")]
const PANEL := 400.0  ## the right side: the cards, the Hint button, Clio and her basket
const CARD := Vector2(180, 58)
const CARD_GAP := Vector2(10, 10)
const MUSE_SIZE := Vector2(240, 320)  ## (the poses are 600 x 800, heads lined up)
const BASKET_SIZE := Vector2(180, 150)
const FLY_TIME := 0.45
const FLY_STEP := 0.22  ## seconds between one card leaving the basket and the next
const TALK_TIME := 3.0

static var _size_choice := 0
static var _down_choice := false
static var _letters_choice := 2

var _rules: MosaicRules
var _grid: MosaicGrid
var _card_layer: Control
var _cards: Array[MosaicWordCard] = []
var _fly: Tween
var _muse: TextureRect
var _poses := {}
var _basket: TextureRect
var _sky: Texture2D
var _talk: PanelContainer
var _talk_holder: CenterContainer
var _talk_label: Label
var _talk_tween: Tween
var _hint_button: Button
var _menu: Control
var _end_panel: PanelContainer
var _options := {}  ## "size" / "down" / "letters" -> its buttons
var _best: StarRow
var _picked := {}  ## the look of a chosen option: state -> StyleBoxFlat
var _playing := false
var _round := 0  ## counts the games, so what waits for one is dropped when the next begins
var _mosaic_index := -1
var _has_picture := false  ## the mosaic is its picture, not the drawn stand-in


func _ready() -> void:
	Ui.setup_screen(self)
	_sky = Ui.picture(ART + "background.png")
	if _sky == null:
		_sky = Ui.picture("greek/area_language_background.png")
	for pose in ["neutral", "happy", "thinking"]:
		var tex := Ui.picture(ART + "clio_%s.png" % pose)
		if tex != null:
			_poses[pose] = tex

	_grid = MosaicGrid.new()
	_grid.visible = false
	_grid.selected.connect(_on_selected)
	add_child(_grid)

	_muse = TextureRect.new()
	_muse.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_muse.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_muse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_muse.size = MUSE_SIZE
	add_child(_muse)
	_set_pose("neutral")

	_basket = TextureRect.new()  # (in front of Clio: the cards fly out of it)
	_basket.texture = Ui.picture(ART + "basket.png")
	_basket.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_basket.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_basket.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_basket.size = BASKET_SIZE
	add_child(_basket)

	_card_layer = Control.new()
	_card_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_card_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_card_layer)

	_hint_button = Ui.button(self, tr("Hint"), _on_hint, 28)
	_hint_button.custom_minimum_size = Vector2(220, Ui.TOUCH_MIN)
	_hint_button.visible = false

	_build_talk()
	Ui.back_button(self)
	resized.connect(_layout)
	_layout()
	_choose_options()


## Back from a game goes to the choice of mosaic (from there, out of the game).
func on_back() -> bool:
	if _menu == null:
		_choose_options()
		return true
	return false


## What Clio says, along the top over the mosaic (between it, the instruction).
func _build_talk() -> void:
	_talk_holder = CenterContainer.new()
	_talk_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_talk_holder)
	_talk = PanelContainer.new()
	_talk.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_talk_holder.add_child(_talk)
	_talk_label = Ui.label(_talk, "", 28)
	_talk.visible = false


# ---------- choosing the mosaic ----------

## Before playing: the size, the directions and the letters, the best stars of that choice, and Play.
func _choose_options() -> void:
	_playing = false
	_round += 1
	_grid.visible = false
	_grid.active = false
	_clear_cards()
	_hint_button.visible = false
	_close_end()
	_hide_talk()
	_set_pose("neutral")
	var col := _open_menu(tr("The Mosaic of Words"))
	_option_row(col, tr("Size"), "size", MosaicRules.SIZE_NAMES, 130.0)
	var names: Array[String] = []
	for i in DIRECTION_NAMES.size():
		names.append("%s  %s" % [tr(DIRECTION_NAMES[i]), DIRECTION_ARROWS[i]])
	_option_row(col, tr("Direction"), "down", names, 320.0)
	names = []
	for n: String in LETTER_NAMES:
		names.append(tr(n))
	_option_row(col, tr("Letters"), "letters", names, 260.0, LETTER_RANGES)
	var bottom := HBoxContainer.new()
	bottom.alignment = BoxContainer.ALIGNMENT_CENTER
	bottom.add_theme_constant_override("separation", 24)
	col.add_child(bottom)
	var best_label := Ui.label(bottom, tr("Best"), 28)
	best_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_best = StarRow.new(0, 44.0)
	_best.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bottom.add_child(_best)
	var play := Ui.button(bottom, tr("Play"), _start, 36)
	play.set_meta("sound", "start")
	for group in ["size", "down", "letters"]:
		_mark(group)
	_update_best()
	play.call_deferred("grab_focus")


## A row of choices: its title, then a button for each (`captions`: a small line under each).
func _option_row(col: VBoxContainer, title: String, group: String, names: Array, width: float,
		captions: Array = []) -> Array[Button]:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	col.add_child(row)
	var about := Ui.label(row, title, 28, Ui.INK, 170.0)
	about.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	about.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var buttons: Array[Button] = []
	for i in names.size():
		var holder := VBoxContainer.new()
		holder.add_theme_constant_override("separation", 0)
		row.add_child(holder)
		var b := Ui.button(holder, names[i], _choose.bind(group, i), 26)
		b.custom_minimum_size = Vector2(width, 72)
		b.set_meta("sound", "toggle")
		if i < captions.size():
			Ui.label(holder, captions[i], 22, Ui.INK.lightened(0.2))
		buttons.append(b)
	_options[group] = buttons
	return buttons


func _choose(group: String, i: int) -> void:
	match group:
		"size":
			_size_choice = i
		"down":
			_down_choice = i == 1
		"letters":
			_letters_choice = i
	_mark(group)
	_update_best()


func _chosen(group: String) -> int:
	match group:
		"size":
			return _size_choice
		"down":
			return 1 if _down_choice else 0
	return _letters_choice


## The chosen button of a row is gold with dark letters; the others are blue.
func _mark(group: String) -> void:
	if _picked.is_empty():
		for state in ["normal", "hover", "pressed", "focus"]:
			var box := (Ui.theme().get_stylebox(state, "Button") as StyleBoxFlat).duplicate() as StyleBoxFlat
			box.bg_color = Ui.GOLD.lightened(0.15 if state == "hover" or state == "focus" else 0.0)
			box.border_color = Color.WHITE if state == "focus" else Ui.INK.lightened(0.3)
			_picked[state] = box
	var buttons: Array = _options.get(group, [])
	for i in buttons.size():
		var b: Button = buttons[i]
		var on := i == _chosen(group)
		for state: String in _picked:
			if on:
				b.add_theme_stylebox_override(state, _picked[state])
			else:
				b.remove_theme_stylebox_override(state)
		for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
			if on:
				b.add_theme_color_override(c, Ui.INK)
			else:
				b.remove_theme_color_override(c)


func _update_best() -> void:
	if _best != null:
		_best.filled = App.best_score(GAME_ID, MosaicRules.key_of(_size_choice, _down_choice, _letters_choice))
		_best.queue_redraw()


# ---------- playing ----------

func _start() -> void:
	_round += 1
	_close_menu()
	_close_end()
	_rules = MosaicRules.new(_size_choice, _down_choice, _letters_choice)
	var next := randi() % MOSAICS.size()
	if next == _mosaic_index:
		next = (next + 1) % MOSAICS.size()
	_mosaic_index = next
	var picture := Ui.picture(ART + "mosaic_%s.png" % MOSAICS[next][0])
	_has_picture = picture != null
	_grid.setup(_rules, picture if picture != null else MosaicGrid.stand_in(next))
	_grid.visible = true
	_playing = true
	_set_pose("neutral")
	_clear_cards()
	for w in _rules.words:
		var card := MosaicWordCard.new(w["word"], w["picture"], CARD)
		_card_layer.add_child(card)
		_cards.append(card)
	_layout()
	_fly_out()
	_hint_button.visible = true
	_grid.grab_focus()
	_say(tr("Find the words from the basket in the mosaic!"))


## The cards fly out of the basket one after another to their places.
func _fly_out() -> void:
	var mouth := _basket.position + Vector2(BASKET_SIZE.x / 2.0, BASKET_SIZE.y * 0.25) - CARD / 2.0
	_fly = create_tween().set_parallel(true)
	for k in _cards.size():
		var card := _cards[k]
		card.position = mouth
		card.scale = Vector2.ONE * 0.2
		card.modulate.a = 0.0
		var at := k * FLY_STEP
		_fly.tween_callback(Sound.play.bind("whoosh")).set_delay(at)
		_fly.tween_property(card, "modulate:a", 1.0, 0.15).set_delay(at)
		_fly.tween_property(card, "position", _slot(k), FLY_TIME).set_delay(at) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		_fly.tween_property(card, "scale", Vector2.ONE, FLY_TIME).set_delay(at)


func _clear_cards() -> void:
	if _fly != null and _fly.is_valid():
		_fly.kill()
	for c in _cards:
		c.queue_free()
	_cards.clear()


## The place of the `k`-th card: two columns at the top of the right side.
func _slot(k: int) -> Vector2:
	var left := size.x - PANEL + (PANEL - 2.0 * CARD.x - CARD_GAP.x - 20.0) / 2.0
	return Vector2(left + (k % 2) * (CARD.x + CARD_GAP.x), 24.0 + (k / 2) * (CARD.y + CARD_GAP.y))


func _on_selected(cells: Array[Vector2i]) -> void:
	if not _playing:
		return
	var answer := _rules.check(cells)
	var i: int = answer["index"]
	match answer["result"]:
		MosaicRules.Result.FOUND:
			_found(i, cells)
		MosaicRules.Result.ALREADY:
			Sound.play("pop")
			_say(tr("You have found that one already!"))
		MosaicRules.Result.PART:
			Sound.play("oops")
			_set_pose("thinking")
			_say(tr("Almost! The word is longer."))
		MosaicRules.Result.WRONG:
			_grid.flash_wrong(cells)
			Sound.play("oops")
			_set_pose("thinking")
			if _rules.hint_due():
				_show_hint(false)
			else:
				_say(tr("That is not one of the words. Look again!"))


func _found(i: int, cells: Array[Vector2i]) -> void:
	var w: Dictionary = _rules.words[i]
	var colour: Color = COLOURS[i % COLOURS.size()]
	_grid.mark_found(cells, colour)
	for c in _cards:
		c.glowing = false
	var card := _cards[i]
	card.colour = colour
	card.found = true
	card.pop()
	Sound.play("burst")
	_set_pose("happy")
	var praise := tr(PRAISE[randi() % PRAISE.size()])
	_say("%s %s" % [praise, w["word"]], "%s %s" % [praise, w["spoken"]])
	if _rules.done():
		_all_found()


## The first letter of a word glows, and its card (`asked`: the Hint button, counted as help).
func _show_hint(asked: bool) -> void:
	var i := _rules.hint_word()
	if i < 0:
		return
	_grid.glow(_rules.hint_cell(asked))
	for k in _cards.size():
		_cards[k].glowing = k == i
	var w: Dictionary = _rules.words[i]
	_say(tr("Look! The word \"%s\" starts here.") % w["word"], tr("Look! The word \"%s\" starts here.") % w["spoken"])


func _on_hint() -> void:
	if _playing:
		_show_hint(true)


## Every word is found: the tiles open in a wave, the mosaic is named, and the stars.
func _all_found() -> void:
	_playing = false
	_grid.active = false
	_hint_button.visible = false
	var stars := _rules.stars()
	var new_best := App.record_score(GAME_ID, _rules.key(), stars)
	var round_now := _round
	var tw := create_tween()
	tw.tween_interval(1.2)
	tw.tween_callback(func() -> void:
		if round_now != _round:
			return
		_say(tr("You found all the words!"))
		Sound.play("whoosh")
		var open_time := _grid.reveal_all()
		var after := create_tween()
		after.tween_interval(open_time)
		after.tween_callback(func() -> void:
			if round_now == _round:
				_show_end(stars, new_best)))


func _show_end(stars: int, new_best: bool) -> void:
	Sound.play("fanfare")
	_set_pose("happy")
	_clear_cards()
	if _has_picture:
		_say(tr("Look! It is %s!") % tr(MOSAICS[_mosaic_index][1]), "", true)
	else:  # (a stand-in is no picture of anything to name)
		_say(tr("Look at the whole mosaic!"), "", true)
	_close_end()
	_end_panel = PanelContainer.new()
	add_child(_end_panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	_end_panel.add_child(col)
	Ui.label(col, tr("The mosaic is finished!"), 30, Ui.INK, PANEL - 80.0)
	var stars_row := CenterContainer.new()
	col.add_child(stars_row)
	stars_row.add_child(StarRow.new(stars, 56.0))
	if new_best:
		Ui.label(col, tr("New best!"), 32, Color("b8860b"))
	var again := Ui.button(col, tr("Play again"), _start, 28)
	again.set_meta("sound", "start")
	Ui.button(col, tr("Change game"), _choose_options, 28)
	_layout()
	again.call_deferred("grab_focus")


func _close_end() -> void:
	if _end_panel != null:
		_end_panel.queue_free()
		_end_panel = null


func _open_menu(title: String) -> VBoxContainer:
	_close_menu()
	_menu = CenterContainer.new()
	_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_menu)
	var panel := PanelContainer.new()
	_menu.add_child(panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 16)
	panel.add_child(col)
	Ui.label(col, title, 44)
	return col


func _close_menu() -> void:
	if _menu != null:
		_menu.queue_free()
		_menu = null
		_options.clear()
		_best = null


# ---------- the layout ----------

## The mosaic fills the left (under the instruction); the right side has the cards at the top, the Hint
## button under them, and Clio with her basket at the bottom.
func _layout() -> void:
	var w := size.x
	var h := size.y
	_grid.fit(Rect2(30.0, 124.0, w - PANEL - 50.0, h - 148.0))
	_talk_holder.position = Vector2(118.0, 14.0)
	_talk_holder.size = Vector2(maxf(300.0, w - PANEL - 128.0), 96.0)
	_talk_label.custom_minimum_size.x = 0.0
	_talk_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_talk_label.custom_minimum_size.x = minf(700.0, _talk_holder.size.x - 60.0)
	_muse.position = Vector2(w - MUSE_SIZE.x - 6.0, h - MUSE_SIZE.y)
	_basket.position = Vector2(w - PANEL + 4.0, h - BASKET_SIZE.y - 8.0)
	if _fly != null and _fly.is_valid():
		_fly.kill()
		for c in _cards:
			c.modulate.a = 1.0
			c.scale = Vector2.ONE
	for k in _cards.size():
		_cards[k].position = _slot(k)
	var rows := ceili(_cards.size() / 2.0)
	_hint_button.position = Vector2(w - PANEL + (PANEL - 20.0 - 220.0) / 2.0, 24.0 + rows * (CARD.y + CARD_GAP.y) + 4.0)
	if _end_panel != null:
		_end_panel.position = Vector2(w - PANEL + 6.0, 20.0)
		_end_panel.custom_minimum_size.x = PANEL - 32.0
	queue_redraw()


# ---------- Clio ----------

## Clio says something (shown along the top; `spoken`, or the same words, read aloud). Unless it is to
## `stay`, the instruction comes back after a while.
func _say(words: String, spoken: String = "", stay: bool = false) -> void:
	_hide_talk()
	_talk_label.text = words
	_talk.visible = true
	App.say(spoken if spoken != "" else words)
	if stay:
		return
	_talk_tween = _talk.create_tween()
	_talk_tween.tween_interval(TALK_TIME)
	_talk_tween.tween_callback(func() -> void:
		if _playing:
			_talk_label.text = tr("Find the words from the basket in the mosaic!")
			_set_pose("neutral")
		else:
			_talk.visible = false)


func _hide_talk() -> void:
	if _talk_tween != null and _talk_tween.is_valid():
		_talk_tween.kill()
	_talk.visible = false


func _set_pose(pose: String) -> void:
	_muse.texture = _poses.get(pose, _poses.get("neutral", null))
	queue_redraw()


func _draw() -> void:
	if _sky != null:
		var ts := _sky.get_size()
		var s := maxf(size.x / ts.x, size.y / ts.y)
		draw_texture_rect(_sky, Rect2((size - ts * s) / 2.0, ts * s), false)
	else:  # a soft grove: green below, a pale sky
		draw_rect(Rect2(Vector2.ZERO, size), Color("dcebd0"))
		draw_rect(Rect2(0, size.y * 0.65, size.x, size.y * 0.35), Color("a9c98a"))
	if _muse.texture == null:  # a drawn Clio: a sky-blue robe, a head and a laurel wreath
		var base := _muse.position + Vector2(MUSE_SIZE.x * 0.5, MUSE_SIZE.y)
		draw_rect(Rect2(base + Vector2(-90, -190), Vector2(180, 190)), Color("9cc6d8"))
		draw_circle(base + Vector2(0, -235), 50.0, Color("f0c8a0"))
		draw_arc(base + Vector2(0, -246), 48.0, PI * 1.1, PI * 1.9, 16, Color("7a9a4a"), 10.0)
	if _basket.texture == null:  # a drawn wicker basket with two scrolls
		var r := Rect2(_basket.position, BASKET_SIZE)
		var top := r.position.y + r.size.y * 0.35
		for k in 2:
			var sx := r.position.x + r.size.x * (0.35 + 0.22 * k)
			draw_rect(Rect2(sx - 12.0, top - 40.0 + k * 10.0, 24.0, 60.0), Color("f3e6c4"))
			draw_rect(Rect2(sx - 12.0, top - 40.0 + k * 10.0, 24.0, 60.0), Color("b8a27a"), false, 2.0)
		var body := PackedVector2Array([Vector2(r.position.x + 8.0, top), Vector2(r.end.x - 8.0, top),
			Vector2(r.end.x - 26.0, r.end.y), Vector2(r.position.x + 26.0, r.end.y)])
		draw_colored_polygon(body, Color("b07a3f"))
		for k in 4:
			var y := top + (k + 1) * (r.end.y - top) / 5.0
			draw_line(Vector2(r.position.x + 14.0 + k * 3.0, y), Vector2(r.end.x - 14.0 - k * 3.0, y), Color("8a5a2b"), 3.0)
		draw_rect(Rect2(r.position.x, top - 8.0, r.size.x, 16.0), Color("8a5a2b"))
