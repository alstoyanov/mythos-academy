extends Control
## The Muses' Words — Language, the Grove of the Muses, Grade 1 (see docs/SPECIFICATION.md §5.4a).
## Reading simple words in the game's language, with Calliope, the Muse of words. Two games
## (WordRules.Mode): a picture and five words to choose from (the others start with the same letter and
## are about as long), or a word and four pictures. Nothing is read aloud before the child answers (the
## reading is the game): a wrong word is read to them ("That says …"), the right one is read once found.
## A wrong pick dims the card; after two the right one glows. Nothing is ever taken away.
## A game is a timed round: the child picks the game and 1, 2 or 3 minutes (DURATIONS), each pair with
## its own best score (App.best_score, under MODE_IDS); the clock ticks in the last seconds, and at the
## end the score is shown, with a fanfare for a new best.
## The rules are in WordRules, the cards WordCard; the 100 pictures in assets/images/words/, the rest in
## assets/images/greek/muses_words/ (each has a stand-in).

const ART := "greek/muses_words/"
const MODE_NAMES := ["Find the word", "Find the picture"]  ## by WordRules.Mode
const MODE_IDS := ["muses_words_find_word", "muses_words_find_picture"]  ## the keys of their best scores
const INSTRUCTIONS := ["Which word is it?", "Which picture is it?"]
const PRAISE := ["Great!", "Well done!", "Yes, that's it!", "Super!", "Brilliant!", "You got it!"]
const DURATIONS := [60, 120, 180]
const DURATION_NAMES := ["1 minute", "2 minutes", "3 minutes"]
const HURRY := 10  ## the last seconds: the clock turns orange and ticks
const MUSE_SIZE := Vector2(400, 341)  ## (the poses are 900 x 768, heads lined up)
const NEXT_AFTER := 1.3  ## seconds from a right pick to the next word

var _rules: WordRules
var _mode: WordRules.Mode = WordRules.Mode.FIND_WORD
var _seconds := 60
var _time_left := 0.0
var _running := false
var _busy := false
var _cards: Array[WordCard] = []  ## the choices
var _shown: WordCard  ## the picture or word asked about
var _play: Control
var _muse: TextureRect
var _poses := {}
var _bubble: PanelContainer
var _bubble_label: Label
var _bubble_tween: Tween
var _goal_panel: PanelContainer
var _goal_label: Label
var _score_label: Label
var _clock_panel: PanelContainer
var _clock: Label
var _menu: Control
var _sky: Texture2D


func _ready() -> void:
	Ui.setup_screen(self)
	_sky = Ui.picture(ART + "background.png")
	if _sky == null:
		_sky = Ui.picture("greek/area_language_background.png")
	for pose in ["neutral", "happy", "thinking"]:
		var tex := Ui.picture(ART + "muse_%s.png" % pose)
		if tex != null:
			_poses[pose] = tex

	_play = Control.new()
	_play.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_play.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_play)

	_muse = TextureRect.new()
	_muse.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_muse.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_muse.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_muse.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_muse.offset_right = MUSE_SIZE.x
	_muse.offset_top = -MUSE_SIZE.y
	add_child(_muse)
	_set_pose("neutral")

	_bubble = PanelContainer.new()  # what the Muse says, above her
	_bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bubble.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_bubble.offset_left = 20
	_bubble.offset_top = -MUSE_SIZE.y - 6
	_bubble.offset_bottom = -MUSE_SIZE.y - 6
	_bubble.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(_bubble)
	_bubble_label = Ui.label(_bubble, "", 28, Ui.INK, 330.0)
	_bubble.visible = false

	_build_goal_panel()
	_build_score()
	Ui.back_button(self)
	resized.connect(_layout)
	_choose_game()


## The instruction along the top ("Which word is it?").
func _build_goal_panel() -> void:
	var holder := CenterContainer.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	holder.offset_top = 16
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	_goal_panel = PanelContainer.new()
	_goal_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(_goal_panel)
	_goal_label = Ui.label(_goal_panel, "", 36)
	_goal_panel.visible = false


## The score on a laurel (Zeus' Thunderbolts' badge) in the top right corner, the clock under it.
func _build_score() -> void:
	var badge := Ui.picture("greek/zeus_thunderbolts/score_laurel.png")
	var holder: Control
	if badge != null:
		var pic := TextureRect.new()
		pic.texture = badge
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		holder = pic
	else:
		holder = PanelContainer.new()
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	holder.offset_left = -170
	holder.offset_right = -20
	holder.offset_top = 16
	holder.offset_bottom = 136
	add_child(holder)
	_score_label = Ui.label(holder, "0", 54)
	_score_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_clock_panel = PanelContainer.new()
	_clock_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_clock_panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_clock_panel.offset_left = -170
	_clock_panel.offset_right = -20
	_clock_panel.offset_top = 144
	_clock_panel.offset_bottom = 214
	add_child(_clock_panel)
	_clock = Ui.label(_clock_panel, "", 40)
	_clock_panel.visible = false


# ---------- choosing, starting, finishing ----------

## Before a round: the game and how long to play, a row for each game, each length with its best score.
func _choose_game() -> void:
	_running = false
	_clear_play()
	_goal_panel.visible = false
	_clock_panel.visible = false
	_hide_bubble()
	_set_pose("neutral")
	var col := _open_menu(tr("The Muses' Words"))
	Ui.label(col, tr("Choose a game and how long to play"), 28, Ui.INK.lightened(0.15))
	var first: Button = null
	for m in MODE_NAMES.size():
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 16)
		col.add_child(row)
		var about := Ui.label(row, tr(MODE_NAMES[m]), 30, Ui.INK, 260.0)
		about.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		about.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		for i in DURATIONS.size():
			var seconds: int = DURATIONS[i]
			var option := VBoxContainer.new()
			option.add_theme_constant_override("separation", 2)
			row.add_child(option)
			var b := Ui.button(option, tr(DURATION_NAMES[i]), _start.bind(seconds, m), 26)
			b.custom_minimum_size = Vector2(190, 80)
			b.set_meta("sound", "start")
			var best := App.best_score(MODE_IDS[m], seconds)
			Ui.label(option, tr("Best: %d") % best if best > 0 else " ", 22)
			if first == null:
				first = b
	first.call_deferred("grab_focus")


func _start(seconds: int, mode: WordRules.Mode = WordRules.Mode.FIND_WORD) -> void:
	_close_menu()
	_seconds = seconds
	_mode = mode
	_time_left = seconds
	_rules = WordRules.new(mode, App.language)
	_score_label.text = "0"
	_goal_label.text = tr(INSTRUCTIONS[mode])
	_goal_panel.visible = true
	_clock_panel.visible = true
	_update_clock()
	_running = true
	_say(tr(INSTRUCTIONS[mode]))
	_next_round()


## The time is up: the score, and the best for this game and length (a fanfare if it is a new best).
func _finish() -> void:
	_running = false
	_busy = true
	_clear_play()
	_goal_panel.visible = false
	_hide_bubble()
	var score := _rules.score
	var previous := App.best_score(MODE_IDS[_mode], _seconds)
	var new_best := App.record_score(MODE_IDS[_mode], _seconds, score)
	_set_pose("happy")
	Sound.play("fanfare")
	var col := _open_menu(tr("Time's up!"))
	Ui.label(col, tr("Score: %d") % score, 44)
	var line: Label
	if new_best:
		line = Ui.label(col, tr("New best!"), 40, Color("b8860b"))
	else:
		line = Ui.label(col, tr("Best: %d") % previous, 30, Ui.INK.lightened(0.2))
	App.say("%s %s %s" % [tr("Time's up!"), tr("Score: %d") % score, line.text])
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_child(row)
	var again := Ui.button(row, tr("Play again"), _start.bind(_seconds, _mode), 32)
	again.set_meta("sound", "start")
	Ui.button(row, tr("Change game"), _choose_game, 32)
	again.call_deferred("grab_focus")


func _open_menu(title: String) -> VBoxContainer:
	_close_menu()
	_menu = CenterContainer.new()
	_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_menu)
	var panel := PanelContainer.new()
	_menu.add_child(panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	panel.add_child(col)
	Ui.label(col, title, 48)
	return col


func _close_menu() -> void:
	if _menu != null:
		_menu.queue_free()
		_menu = null


func _update_clock() -> void:
	var left := ceili(maxf(0.0, _time_left))
	_clock.text = "%d:%02d" % [left / 60, left % 60]
	_clock.add_theme_color_override("font_color", Color("d9631e") if left <= HURRY else Ui.INK)


# ---------- rounds ----------

func _next_round() -> void:
	if not _running:
		return
	_rules.new_round()
	_clear_play()
	_busy = false
	_set_pose("neutral")
	var find_word := _mode == WordRules.Mode.FIND_WORD
	# what is asked about: the picture, or the word
	_shown = WordCard.new(_rules.target["id"] if find_word else "", "" if find_word else _rules.target["word"],
		Vector2(300, 300) if find_word else Vector2(440, 100))
	_shown.disabled = true
	_shown.focus_mode = Control.FOCUS_NONE
	_shown.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_play.add_child(_shown)
	for c in _rules.choices:
		var card := WordCard.new("" if find_word else c, c if find_word else "",
			Vector2(330, 76) if find_word else Vector2(200, 200))
		card.pressed.connect(_on_pick.bind(card))
		_play.add_child(card)
		_cards.append(card)
	_layout()
	_cards[0].grab_focus()
	Sound.play("whoosh")


func _clear_play() -> void:
	for c in _play.get_children():
		c.queue_free()
	_cards.clear()
	_shown = null


## Places the cards right of the Muse, under the instruction and left of the score: the picture with the
## words in a column beside it, or the word with the four pictures two by two under it.
func _layout() -> void:
	var area := Rect2(MUSE_SIZE.x + 20.0, 140.0, maxf(500.0, size.x - MUSE_SIZE.x - 20.0 - 190.0), size.y - 160.0)
	if _shown == null:
		return
	if _mode == WordRules.Mode.FIND_WORD:
		var gap := 14.0
		var column := _cards.size() * _cards[0].size.y + (_cards.size() - 1) * gap
		var total := _shown.size.x + 30.0 + _cards[0].size.x
		var x := area.position.x + (area.size.x - total) / 2.0
		_shown.position = Vector2(x, area.get_center().y - _shown.size.y / 2.0)
		for i in _cards.size():
			_cards[i].position = Vector2(x + _shown.size.x + 30.0, area.get_center().y - column / 2.0 + i * (_cards[i].size.y + gap))
	else:
		_shown.position = Vector2(area.get_center().x - _shown.size.x / 2.0, area.position.y + 10.0)
		var side := _cards[0].size.x
		var gap := 24.0
		var top := _shown.position.y + _shown.size.y + 26.0
		var left := area.get_center().x - side - gap / 2.0
		for i in _cards.size():
			_cards[i].position = Vector2(left + (i % 2) * (side + gap), top + (i / 2) * (side + gap))


func _on_pick(card: WordCard) -> void:
	if _busy or not _running or card.tried:
		return
	var choice := card.text if _mode == WordRules.Mode.FIND_WORD else card.id
	if _rules.pick(choice):
		_busy = true
		card.pop()
		card.glowing = true
		Sound.play("burst")
		_set_pose("happy")
		_score_label.text = str(_rules.score)
		var pop := _score_label.create_tween()
		_score_label.pivot_offset = _score_label.size / 2.0
		pop.tween_property(_score_label, "scale", Vector2.ONE * 1.4, 0.12)
		pop.tween_property(_score_label, "scale", Vector2.ONE, 0.2)
		var word: String = _rules.target["word"]
		_say("%s %s" % [tr(PRAISE[randi() % PRAISE.size()]), word], word)  # (the word is read, now that it is found)
		get_tree().create_timer(NEXT_AFTER).timeout.connect(func() -> void:
			if _running and _busy:
				_next_round())
	else:
		card.wobble()
		card.tried = true
		Sound.play("oops")
		_set_pose("thinking")
		if _mode == WordRules.Mode.FIND_WORD:  # the word picked, read to them
			_say(tr("That says \"%s\".") % card.text)
		else:  # what the picture picked is
			_say(tr("That is \"%s\". Read the word again!") % _rules.word_of(card.id))
		if _rules.hint_due():
			for c in _cards:
				c.glowing = (c.text if _mode == WordRules.Mode.FIND_WORD else c.id) == _rules.answer()


## The Muse says something (shown in her bubble; `spoken`, or the same words, read aloud).
func _say(words: String, spoken: String = "") -> void:
	_hide_bubble()
	_bubble_label.text = words
	_bubble.visible = true
	_bubble.modulate.a = 1.0
	App.say(spoken if spoken != "" else words)
	_bubble_tween = _bubble.create_tween()
	_bubble_tween.tween_interval(2.2)
	_bubble_tween.tween_property(_bubble, "modulate:a", 0.0, 0.4)
	_bubble_tween.tween_callback(func() -> void: _bubble.visible = false)


func _hide_bubble() -> void:
	if _bubble_tween != null and _bubble_tween.is_valid():
		_bubble_tween.kill()
	_bubble.visible = false


func _set_pose(pose: String) -> void:
	_muse.texture = _poses.get(pose, _poses.get("neutral", null))
	queue_redraw()


func _process(delta: float) -> void:
	if not _running:
		return
	var before := ceili(_time_left)
	_time_left -= delta
	var now := ceili(_time_left)
	if now != before:
		_update_clock()
		if now <= HURRY and now > 0:
			Sound.play("tick")
	if _time_left <= 0.0:
		_finish()


func _draw() -> void:
	if _sky != null:
		var ts := _sky.get_size()
		var s := maxf(size.x / ts.x, size.y / ts.y)
		draw_texture_rect(_sky, Rect2((size - ts * s) / 2.0, ts * s), false)
	else:  # a soft grove: green below, a pale sky
		draw_rect(Rect2(Vector2.ZERO, size), Color("dcebd0"))
		draw_rect(Rect2(0, size.y * 0.65, size.x, size.y * 0.35), Color("a9c98a"))
	if _muse.texture == null:  # a drawn Muse: a lilac robe, a head and a laurel wreath
		var base := Vector2(MUSE_SIZE.x * 0.5, size.y)
		draw_rect(Rect2(base + Vector2(-110, -220), Vector2(220, 220)), Color("d8c4e8"))
		draw_circle(base + Vector2(0, -270), 58.0, Color("f0c8a0"))
		draw_arc(base + Vector2(0, -282), 56.0, PI * 1.1, PI * 1.9, 16, Color("7a9a4a"), 12.0)
