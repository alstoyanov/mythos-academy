extends Node
## The Mosaic of Words: the words (each letter set has enough, none has a rude word in it), the rectangles
## the rules make for every size, direction and set of letters over many seeds (the number of words, only
## the letters chosen, straight words that do not cross or touch, each readable in one place only, nothing
## rude), the lines the child selects (found forwards or backwards, part of a word, wrong, the hint, the
## stars), then the screen: the choices, the cards out of the basket, a drag and two taps on the
## rectangle, a wrong line and the hint, all the words found, the mosaic and its stars kept.
##   godot --headless --path . res://tests/mosaic_test.tscn
## Exits with 0 on success, 1 on failure.

var _failures := 0


func _ready() -> void:
	var stand_in := Node.new()  # this node stays while the screens change
	get_tree().root.add_child.call_deferred(stand_in)
	await get_tree().process_frame
	get_tree().current_scene = stand_in
	App.language = "en"
	TranslationServer.set_locale("en")
	App.voice_on = false
	_test_words()
	_test_rectangles()
	_test_lines()
	await _test_screen()
	print("FAILED: %d" % _failures if _failures > 0 else "ALL PASSED")
	get_tree().quit(1 if _failures > 0 else 0)


func _test_words() -> void:
	print("words")
	for count: int in MosaicRules.LETTER_COUNTS:
		var allowed := MosaicRules.ALPHABET.substr(0, count)
		var pool := MosaicRules.pool(count)
		var starts := {}
		for w in pool:
			var word: String = w["word"]
			_check(word == (w["spoken"] as String).to_upper(), "capitals of the word %s" % word)
			for ch in word:
				_check(allowed.contains(ch), "%d letters: %s has only those" % [count, word])
			for bad: String in MosaicRules.AVOID:
				_check(not word.contains(bad), "%s has nothing rude in it" % word)
			starts[word.left(3)] = true
		_check(starts.size() >= MosaicRules.WORD_COUNTS[-1] + 2, "%d letters: enough different words (%d)" % [count, starts.size()])
		print("  %d letters: %d words" % [count, pool.size()])
	_check(MosaicRules.ALPHABET.length() == 30, "the Bulgarian alphabet has 30 letters")
	for w in MosaicRules.pool(10):
		if w["word"] == "ЖАБА":
			_check(w["picture"] == "frog", "a word of data/words.json keeps its picture")


func _test_rectangles() -> void:
	print("rectangles")
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	for size_index in MosaicRules.SIZES.size():
		for down in [false, true]:
			for letters_index in MosaicRules.LETTER_COUNTS.size():
				for n in 12:
					_check_rectangle(MosaicRules.new(size_index, down, letters_index, rng))


func _check_rectangle(r: MosaicRules) -> void:
	var what := "%s %s %d" % [MosaicRules.SIZE_NAMES[r.size_index], "down" if r.down else "across", r.letters.length()]
	_check(r.grid.size() == r.columns * r.rows, "%s: every cell" % what)
	_check(r.words.size() == MosaicRules.WORD_COUNTS[r.size_index], "%s: %d words (%d)" % [what, MosaicRules.WORD_COUNTS[r.size_index], r.words.size()])
	for ch in r.grid:
		_check(ch.length() == 1 and r.letters.contains(ch), "%s: only the letters chosen (%s)" % [what, ch])
	var owner := {}
	var across := 0
	var downward := 0
	for w in r.words:
		var word: String = w["word"]
		var cells: Array = w["cells"]
		_check(cells.size() == word.length(), "%s: a cell per letter of %s" % [what, word])
		var dir: Vector2i = cells[1] - cells[0] if cells.size() > 1 else Vector2i(1, 0)
		_check(dir == Vector2i(1, 0) or (r.down and dir == Vector2i(0, 1)), "%s: %s goes across%s" % [what, word, " or down" if r.down else ""])
		if dir == Vector2i(1, 0):
			across += 1
		else:
			downward += 1
		for k in cells.size():
			var c: Vector2i = cells[k]
			_check(r.inside(c) and (k == 0 or c - (cells[k - 1] as Vector2i) == dir), "%s: %s in a straight line" % [what, word])
			_check(r.letter(c) == word[k], "%s: %s written in its cells" % [what, word])
			_check(not owner.has(c), "%s: words do not cross (%s)" % [what, word])
			owner[c] = [word, dir]
	for w in r.words:  # (a word going the other way may pass by its ends: only one on the same line may not)
		var cells: Array = w["cells"]
		var dir: Vector2i = cells[1] - cells[0] if cells.size() > 1 else Vector2i(1, 0)
		for c in [(cells[0] as Vector2i) - dir, (cells[-1] as Vector2i) + dir]:
			_check(not owner.has(c) or owner[c][1] != dir, "%s: %s touches no word end to end" % [what, w["word"]])
		for o in r.words:
			if o != w:
				_check(not (w["word"] as String).contains(o["word"]), "%s: %s does not hide %s" % [what, w["word"], o["word"]])
	if r.down:
		_check(across > 0 and downward > 0, "%s: words across and down (%d, %d)" % [what, across, downward])
	var lines := r._lines()
	for w in r.words:
		var n := 0
		for l in lines:
			n += MosaicRules._count(l, w["word"])
		_check(n == 1, "%s: %s can be read in one place only (%d)" % [what, w["word"], n])
	for bad: String in MosaicRules.AVOID:
		for l in lines:
			_check(not l.contains(bad), "%s: nothing rude (%s)" % [what, l])


func _test_lines() -> void:
	print("lines")
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	var r := MosaicRules.new(1, false, 2, rng)
	_check(r.line(Vector2i(0, 0), Vector2i(0, 3)).is_empty(), "no line down when the words only go across")
	_check(r.line(Vector2i(0, 0), Vector2i(2, 2)).is_empty(), "no line across corners")
	_check(r.line(Vector2i(3, 1), Vector2i(0, 1)).size() == 4, "a line across, either way")
	var w: Dictionary = r.words[0]
	var cells: Array[Vector2i] = []
	cells.assign(w["cells"])
	var part: Array[Vector2i] = cells.slice(0, cells.size() - 1)
	_check(r.check(part)["result"] == MosaicRules.Result.PART and r.mistakes == 0, "part of a word: not a mistake")
	var single: Array[Vector2i] = [cells[0]]
	_check(r.check(single)["result"] == MosaicRules.Result.NONE, "one letter is no line")
	var wrong := _wrong_line(r)
	_check(r.check(wrong)["result"] == MosaicRules.Result.WRONG and r.mistakes == 1, "a wrong line")
	_check(not r.hint_due(), "no hint after one")
	r.check(wrong)
	_check(r.hint_due() and r.hint_cell() == cells[0], "after two the first letter of the first word")
	var backwards := cells.duplicate()
	backwards.reverse()
	var found := r.check(backwards)
	_check(found["result"] == MosaicRules.Result.FOUND and found["index"] == 0 and r.words[0]["found"], "a word found backwards")
	_check(not r.hint_due(), "the hint waits again after a word")
	_check(r.check(cells)["result"] == MosaicRules.Result.ALREADY, "a word found again")
	_check(r.stars() == 3, "two wrong lines: three stars")
	r.hint_cell(true)
	_check(r.stars() == 2 and r.hints == 1, "a hint asked for is help too")
	for k in 3:
		r.check(wrong)
	_check(r.stars() == 1, "more help: one star, never none")
	for i in r.words.size():
		var c: Array[Vector2i] = []
		c.assign(r.words[i]["cells"])
		r.check(c)
	_check(r.done() and r.hint_cell() == MosaicRules.NOWHERE, "all found")
	var d := MosaicRules.new(1, true, 2, rng)
	_check(d.line(Vector2i(2, 0), Vector2i(2, 3)).size() == 4, "a line down when the words go down")


## A line of two cells that is no word and not inside one.
func _wrong_line(r: MosaicRules) -> Array[Vector2i]:
	for y in r.rows:
		for x in r.columns - 1:
			var l := r.line(Vector2i(x, y), Vector2i(x + 1, y))
			if r.words.all(func(w: Dictionary) -> bool:
					return not (w["cells"] as Array).has(l[0]) and not (w["cells"] as Array).has(l[1])):
				return l
	return []


func _test_screen() -> void:
	print("screen")
	var scores := "user://test_progress.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path(scores))
	App.use_progress_file(scores)
	get_tree().change_scene_to_file("res://scenes/games/word_mosaic.tscn")
	await _wait(0.3)
	var game := get_tree().current_scene
	_check(not _buttons(game, "5 × 8").is_empty() and not _buttons(game, "8 × 12").is_empty(), "the sizes")
	_check(not _buttons(game, "Across  →").is_empty() and not _buttons(game, "Across and down  → ↓").is_empty(), "the directions")
	_check(not _buttons(game, "The first 10 letters").is_empty() and _has_text(game, "А – Й"), "the letters")
	_buttons(game, "6 × 9")[0].pressed.emit()
	_buttons(game, "Across  →")[0].pressed.emit()
	_buttons(game, "The first 20 letters")[0].pressed.emit()
	_buttons(game, "Play")[0].pressed.emit()
	await _wait(0.2)
	var rules: MosaicRules = game.get("_rules")
	var grid: MosaicGrid = game.get("_grid")
	var cards: Array = game.get("_cards")
	_check(rules.columns == 9 and rules.rows == 6 and not rules.down and rules.letters.length() == 20, "the choices played")
	_check(grid.visible and cards.size() == rules.words.size(), "the mosaic and a card per word")
	_check(_has_text(game, "Find the words from the basket in the mosaic!"), "the instruction")
	await _wait(rules.words.size() * 0.22 + 0.6)
	var c0: MosaicWordCard = cards[0]
	_check(c0.modulate.a == 1.0 and c0.position.x > grid.position.x + grid.size.x, "the cards are out of the basket, beside the mosaic")

	# a wrong line, twice: the hint
	var wrong := _wrong_line(rules)
	grid.selected.emit(wrong)
	await get_tree().process_frame
	_check(_has_text(game, "That is not one of the words. Look again!") and rules.mistakes == 1, "a wrong line: a gentle word")
	grid.selected.emit(wrong)
	await get_tree().process_frame
	var first: Array = rules.words[0]["cells"]
	_check(grid.get("_glow") == first[0] and c0.glowing, "after two the first letter and its card glow")

	# the first word with a drag, the second with two taps
	_drag(grid, first[0], first[-1])
	await get_tree().process_frame
	_check(rules.words[0]["found"] and c0.found and not c0.glowing, "a word found with a drag")
	_check(_has_text(game, rules.words[0]["word"]), "and read")
	var second: Array = rules.words[1]["cells"]
	grid.tap(second[-1])
	grid.tap(second[0])
	await get_tree().process_frame
	_check(rules.words[1]["found"], "a word found with two taps, last letter first")
	grid.tap(Vector2i(0, 0))
	grid.tap(Vector2i(0, rules.rows - 1))
	_check(grid.get("_anchor") == Vector2i(0, rules.rows - 1), "a tap off the line starts again there")
	grid.tap(Vector2i(0, rules.rows - 1))
	_check(grid.get("_anchor") == MosaicGrid.NOWHERE, "and tapped again is forgotten")

	# the rest: the mosaic opens, its name, the stars
	for i in range(2, rules.words.size()):
		var c: Array[Vector2i] = []
		c.assign(rules.words[i]["cells"])
		grid.selected.emit(c)
	_check(rules.done() and not grid.active, "all found")
	await _wait(1.2 + (rules.columns + rules.rows) * MosaicGrid.WAVE_STEP + 1.0)
	_check(_has_text(game, "The mosaic is finished!"), "the mosaic is finished")
	var index: int = game.get("_mosaic_index")
	if game.get("_has_picture"):
		_check(_has_text(game, "Look! It is %s!" % game.get_script().get_script_constant_map()["MOSAICS"][index][1]), "and named")
	else:
		_check(_has_text(game, "Look at the whole mosaic!"), "and shown (a stand-in is not named)")
	_check(App.best_score("word_mosaic", rules.key()) == 3, "two wrong lines: three stars kept")
	_check(App.best_score("word_mosaic", MosaicRules.key_of(1, true, 1)) == 0, "each choice keeps its own")
	_check(game.call("on_back") and not _buttons(game, "Play").is_empty(), "Back goes to the choices")
	_check(game.get("_size_choice") == 1 and game.get("_letters_choice") == 1, "which are kept")
	App.use_progress_file("user://progress.cfg")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(scores))


## A finger down on one cell, moved to another, and up.
func _drag(grid: MosaicGrid, from: Vector2i, to: Vector2i) -> void:
	var down := InputEventMouseButton.new()
	down.button_index = MOUSE_BUTTON_LEFT
	down.pressed = true
	down.position = (Vector2(from) + Vector2(0.5, 0.5)) * grid.cell
	grid._gui_input(down)
	var move := InputEventMouseMotion.new()
	move.position = (Vector2(to) + Vector2(0.5, 0.3)) * grid.cell
	grid._gui_input(move)
	var up := InputEventMouseButton.new()
	up.button_index = MOUSE_BUTTON_LEFT
	up.pressed = false
	up.position = move.position
	grid._gui_input(up)


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _buttons(root: Node, text: String) -> Array:
	return root.find_children("*", "Button", true, false).filter(func(b: Node) -> bool:
		return (b as Button).text == text and not b.is_queued_for_deletion())


func _has_text(root: Node, part: String) -> bool:
	for l in root.find_children("*", "Label", true, false):
		if (l as Label).text.contains(part) and not l.is_queued_for_deletion() and (l as Label).is_visible_in_tree():
			return true
	return false


func _check(ok: bool, what: String) -> void:
	if not ok:
		_failures += 1
		print("  FAIL: " + what)
