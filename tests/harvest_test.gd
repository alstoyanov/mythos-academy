extends Node
## Demeter's Harvest: its rules (HarvestRules) on every level over many problems (the equations and
## their ranges, one answer that balances, the choices with the likely mistakes, nothing taken away,
## the help, the stars), then the screen: a tablet dropped away from the scale goes back, a wrong one
## tips the scale and comes back dimmed (the wheat and grapes appear, to count alone), the second
## brings Demeter's help (counting all, counting on, taking away) and the answer glows, the right one solves the problem, and the end of a level.
##   godot --headless --path . res://tests/harvest_test.tscn
## Exits with 0 on success, 1 on failure.

const WRONG_TIME := 0.45 + 1.0 + 2.2 + 0.2  ## a tablet flies, the scale swings, Demeter speaks, it comes back

var _failures := 0


func _ready() -> void:
	var stand_in := Node.new()  # this node stays while the screens change
	get_tree().root.add_child.call_deferred(stand_in)
	await get_tree().process_frame
	get_tree().current_scene = stand_in
	App.language = "en"
	TranslationServer.set_locale("en")
	App.voice_on = false
	var scores := "user://test_progress.cfg"  # (the player's own best scores are left alone)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(scores))
	App.use_progress_file(scores)
	_test_rules()
	await _test_screen()
	App.use_progress_file("user://progress.cfg")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(scores))
	print("FAILED: %d" % _failures if _failures > 0 else "ALL PASSED")
	get_tree().quit(1 if _failures > 0 else 0)


func _test_rules() -> void:
	print("rules")
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	for level in 5:
		var seen := {}
		for game in 20:
			var r := HarvestRules.new(level, rng)
			var last := ""
			while not r.level_done():
				r.new_round()
				var text := "%s = %s" % [str(r.left), str(r.right)]
				seen[text] = true
				_check(text != last, "level %d: a new problem each time" % (level + 1))
				last = text
				_check(r.answer >= 1 and absi(r.terms(r.unknown_side)[r.unknown_index]) == r.answer, "%s: the answer %d" % [text, r.answer])
				_check(r.difference(r.answer) == 0, "%s: the answer balances" % text)
				_check(r.difference(r.answer + 1) != 0 and r.difference(r.answer - 1) != 0, "%s: only the answer balances" % text)
				for side in [-1, 1]:
					var terms := r.terms(side)
					_check(terms[0] > 0, "%s: a side starts with a number" % text)
					var running := 0
					for t in terms:
						running += t
						_check(running >= 0 and absi(t) <= HarvestRules.MAX and running <= HarvestRules.MAX, "%s: within 0..20" % text)
				match r.kind:
					HarvestRules.Kind.ADD:
						_check(r.left.size() == 2 and r.left[1] > 0 and r.unknown_side == 1 and r.right[0] >= 3 and r.right[0] <= 10, "%s: adding to 10" % text)
					HarvestRules.Kind.TAKE:
						_check(r.left.size() == 2 and r.left[1] < 0 and r.unknown_side == 1 and r.left[0] <= 10, "%s: taking away within 10" % text)
					HarvestRules.Kind.MISSING:
						_check(r.unknown_side == -1 and r.unknown_index == 1 and r.right.size() == 1, "%s: a missing number" % text)
					HarvestRules.Kind.TO20:
						_check(r.unknown_side == 1 and (r.right[0] > 10 or r.left[0] > 10), "%s: past ten" % text)
					HarvestRules.Kind.EQUAL:
						_check(r.left.size() == 2 and r.right.size() == 2 and r.unknown_index == 1, "%s: both sides sums" % text)
				var distinct := {}
				for c in r.choices:
					distinct[c] = true
				_check(r.choices.size() == HarvestRules.CHOICES and distinct.size() == HarvestRules.CHOICES and r.choices.has(r.answer)
					and r.choices.min() >= 0 and r.choices.max() <= HarvestRules.MAX, "%s: four choices %s" % [text, str(r.choices)])
				if r.kind == HarvestRules.Kind.TAKE:
					_check(r.choices.has(r.left[0] - r.left[1]), "%s: adding instead of taking away is a choice" % text)
				if r.kind == HarvestRules.Kind.EQUAL:
					_check(r.choices.has(r.value(-r.unknown_side)), "%s: the other side's sum is a choice" % text)
				var done := r.round_index
				if game % 3 == 0:
					_check(not r.check(r.answer + 1) and r.round_index == done, "a wrong answer is not right")
				_check(r.check(r.answer) and r.round_index == done + 1, "the right answer solves it")
			var expected := 3 if r.first_try >= 7 else (2 if r.first_try >= 4 else 1)
			_check(r.stars() == expected and r.first_try == (0 if game % 3 == 0 else HarvestRules.ROUNDS), "stars for the first tries")
		_check(seen.size() >= 15, "level %d: many different problems (%d)" % [level + 1, seen.size()])
	var h := HarvestRules.new(0, rng)
	h.new_round()
	h.check(h.answer + 1)
	_check(not h.hint_due(), "no help after one wrong answer")
	h.check(h.answer + 1)
	_check(h.hint_due(), "help after two")


func _test_screen() -> void:
	print("screen")
	get_tree().change_scene_to_file("res://scenes/games/demeter_harvest.tscn")
	await _wait(0.3)
	var game := get_tree().current_scene
	_check(_button(game, "1 · Adding") != null and _button(game, "5 · Both sides equal") != null, "the five levels")
	# Level 1: a + b = ?
	_button(game, "1 · Adding").pressed.emit()
	await _wait(0.3)
	var rules: HarvestRules = game.get("_rules")
	var scale: HarvestScale = game.get("_scale")
	var tablets: Array[DragTablet] = game.get("_tablets")
	_check(scale.left_terms == rules.left and scale.right_terms == rules.right and scale.guess == -1, "the problem on the scale")
	_check(tablets.size() == 4 and _values(tablets) == rules.choices, "four tablets with the choices")
	_check(_has_text(game, "equals how many?"), "Demeter says the problem (%s)" % _spoken(game))
	var wrong := _tablets(tablets, rules.answer, false)
	# dropped away from the scale: back to its place
	wrong[0].global_position = Vector2(30, 200)
	wrong[0].dropped.emit(wrong[0])
	await _wait(0.5)
	_check(wrong[0].position.distance_to(wrong[0].home) < 1.0 and rules.mistakes == 0, "dropped elsewhere: back to its place")
	# dropped on the scale, wrong: the scale tips, Demeter says too big / too small, it comes back dimmed
	wrong[0].global_position = scale.slot_rect().get_center() - wrong[0].size / 2.0
	wrong[0].dropped.emit(wrong[0])
	await _wait(0.6)
	_check(scale.guess == wrong[0].value and not scale.balanced, "the scale weighs the wrong number")
	await _wait(1.2)
	_check(rules.mistakes == 1 and (_has_text(game, "is too big") or _has_text(game, "is too small")), "too big or too small")
	await _wait(WRONG_TIME - 1.8)
	_check(wrong[0].tried and wrong[0].visible and scale.guess == -1 and not game.get("_busy"), "it comes back, dimmed")
	_check(scale.left_items.size() == rules.value(-1) and scale.marked_side == 0, "the wheat and grapes appear, to count alone")
	_check(_has_text(game, "if you want to count") and not _tablets(tablets, rules.answer, true)[0].glowing, "but nothing is given away")
	wrong[0].tapped.emit(wrong[0])
	await _wait(0.2)
	_check(not game.get("_busy"), "a dimmed tablet cannot be given again")
	# the second wrong one: Demeter helps, counting the other side, and the answer glows
	wrong[1].tapped.emit(wrong[1])
	await _wait(WRONG_TIME + 1.6 + rules.answer * 0.7 + 0.5)
	_check(scale.left_items.size() == rules.value(-1), "help: the wheat and grapes (%d)" % scale.left_items.size())
	_check(_has_text(game, "That makes %d." % rules.answer), "counted together")
	_check(_tablets(tablets, rules.answer, true)[0].glowing and not game.get("_busy"), "the answer glows")
	var right := _tablets(tablets, rules.answer, true)[0]
	right.tapped.emit(right)
	await _wait(1.6)
	_check(rules.round_index == 1 and rules.first_try == 0 and scale.balanced, "the right answer balances the scale")
	_check(_has_text(game, "equals %d!" % rules.answer), "and the equation is read")
	await _wait(4.0)
	_check(game.get("_scale") != scale, "a new problem")

	# Level 3: the missing number; the help counts on or takes away
	game.call("_start", 2)
	await _wait(0.3)
	rules = game.get("_rules")
	scale = game.get("_scale")
	tablets = game.get("_tablets")
	_check(scale.unknown_side == -1, "the missing number is on the left (%s)" % _spoken(game))
	wrong = _tablets(tablets, rules.answer, false)
	wrong[0].tapped.emit(wrong[0])
	await _wait(WRONG_TIME)
	wrong[1].tapped.emit(wrong[1])
	await _wait(WRONG_TIME + 1.6 + (rules.answer + 1) * 0.7 + 0.5)
	var styles := {}
	for it in scale.left_items:
		styles[it["style"]] = styles.get(it["style"], 0) + 1
	if rules.left[1] > 0:
		_check(styles.get(HarvestScale.GHOST, 0) == rules.answer and _has_text(game, "We need %d more." % rules.answer), "counted on")
	else:
		_check(styles.get(HarvestScale.EATEN, 0) == rules.answer and _has_text(game, "We take away %d." % rules.answer), "taken away")
	_check(scale.balanced, "and the sides match")

	# Level 5: both sides; the end of the level
	game.call("_start", 4)
	await _wait(0.3)
	rules = game.get("_rules")
	tablets = game.get("_tablets")
	_check(rules.left.size() == 2 and rules.right.size() == 2, "both sides are sums")
	rules.round_index = HarvestRules.ROUNDS - 1  # (the last problem) ...
	rules.first_try = 7
	right = _tablets(tablets, rules.answer, true)[0]
	right.tapped.emit(right)
	await _wait(1.6 + 3.9)
	_check(_has_text(game, "The harvest is ready!"), "eight problems: the level is done")
	_check(App.best_score("demeter_harvest", 5) == 3, "its stars are kept (%d)" % App.best_score("demeter_harvest", 5))
	_check(_button(game, "Play again") != null and _button(game, "Choose a level") != null, "and what next")


func _values(tablets: Array[DragTablet]) -> Array[int]:
	var out: Array[int] = []
	for t in tablets:
		out.append(t.value)
	return out


## The tablets with the answer (`is_answer`) or without it.
func _tablets(tablets: Array[DragTablet], answer: int, is_answer: bool) -> Array[DragTablet]:
	var out: Array[DragTablet] = []
	for t in tablets:
		if (t.value == answer) == is_answer:
			out.append(t)
	return out


func _spoken(game: Node) -> String:
	return game.call("_spoken", false)


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _button(root: Node, text: String) -> Button:
	for b in root.find_children("*", "Button", true, false):
		if (b as Button).text == text and not b.is_queued_for_deletion():
			return b
	return null


func _has_text(root: Node, part: String) -> bool:
	for l in root.find_children("*", "Label", true, false):
		if (l as Label).text.contains(part) and not l.is_queued_for_deletion():
			return true
	return false


func _check(ok: bool, what: String) -> void:
	if not ok:
		_failures += 1
		print("  FAIL: " + what)
