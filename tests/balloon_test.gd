extends Node
## Aeolus' Balloons: its rules (BalloonRules) on every level over many puzzles, then the screen: tapping
## and swiping balloons, Undo, Hint, Restart, and the end of a puzzle with its stars.
##   godot --headless --path . res://tests/balloon_test.tscn
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
	for level in BalloonRules.LEVELS.size():
		for game in 40:
			var r := BalloonRules.new(level, rng)
			var spec: Array = BalloonRules.LEVELS[level]
			_check(r.values.size() == spec[0], "level %d: %d balloons" % [level + 1, spec[0]])
			_check(_distinct(r.values) and r.values.min() >= 1 and r.values.max() <= 9, "different numbers 1 to 9 %s" % str(r.values))
			_check(not r.is_sorted() and r.par >= spec[2] and r.par <= spec[3], "not in order, %d wrong pairs" % r.par)
			_check(r.swaps == 0 and not r.can_undo() and r.undo() == -1, "nothing to undo at the start")
			var start := r.values.duplicate()
			_check(not r.swap(-1) and not r.swap(r.count - 1), "no swap outside the row")
			# a swap, and undo
			r.swap(2)
			_check(r.swaps == 1 and r.can_undo() and r.values != start, "a swap changes the row")
			_check(r.undo() == 2 and r.values == start and r.swaps == 1, "undo puts it back; the swap stays counted")
			# the hint always helps: following it sorts the row in exactly par swaps
			r.restart()
			var steps := 0
			while not r.is_sorted():
				var before := r.wrong_pairs()
				var i := r.hint()
				_check(i >= 0, "a hint while it is not in order")
				r.swap(i)
				_check(r.wrong_pairs() == before - 1, "each hinted swap brings it one step closer")
				steps += 1
			_check(r.hint() == -1, "no hint once in order")
			_check(_in_order(r.values, r.direction), "sorted the right way")
			_check(r.swaps == r.par and steps == r.par, "par is the fewest swaps (%d)" % r.par)
			# stars
			_check(r.stars() == 3, "close to par: 3 stars")
			r.swaps = r.par + BalloonRules.PAR_SLACK + 1
			_check(r.stars() == (2 if r.swaps <= r.par * 2 else 1), "more swaps: fewer stars")
			r.swaps = 1000
			_check(r.stars() == 1, "always at least one star")
			r.restart()
			_check(r.values == start and r.swaps == 0 and not r.can_undo(), "restart: the same row again")


func _test_screen() -> void:
	print("screen")
	get_tree().change_scene_to_file("res://scenes/games/aeolus_balloons.tscn")
	await _wait(0.4)
	var game := get_tree().current_scene
	_check(game != null and _text(game, "Aeolus' Balloons"), "the choice of level")
	game.call("_start", 1)
	await _wait(0.3)
	var rules: BalloonRules = game.get("_rules")
	var balloons: Array = game.get("_balloons")
	_check(balloons.size() == 8, "eight balloons")
	for i in 8:
		_check(balloons[i].value == rules.values[i], "the balloon %d shows its number" % i)
	_check(balloons[0].size.x > 0.0 and balloons[7].position.x > balloons[0].position.x, "in a row")
	_check((_button(game, "Undo") as Button).disabled, "Undo is off at the start")
	# two that are not neighbours: the selection moves, nothing swaps
	balloons[0].pressed.emit()
	balloons[2].pressed.emit()
	await _wait(0.1)
	_check(rules.swaps == 0 and balloons[2].selected and not balloons[0].selected, "two apart: no swap, the selection moves")
	balloons[3].pressed.emit()  # a neighbour of the selected one: swap
	await _wait(0.4)
	_check(rules.swaps == 1, "tap a balloon then its neighbour: they swap")
	var after: Array = game.get("_balloons")
	for i in 8:
		_check(after[i].value == rules.values[i], "the balloons follow the rules after a swap")
	_check(after[2].position.x < after[3].position.x, "and sit in their places")
	_check(not (_button(game, "Undo") as Button).disabled, "Undo is on")
	_button(game, "Undo").pressed.emit()
	await _wait(0.4)
	_check(rules.values == rules.start_values, "Undo takes the swap back")
	# a swipe
	var b: Balloon = game.get("_balloons")[4]
	b.swiped.emit(-1)
	await _wait(0.4)
	_check(rules.swaps == 2 and game.get("_balloons")[3] == b, "a swipe left swaps with the left neighbour")
	game.get("_balloons")[0].swiped.emit(-1)  # (off the end: nothing)
	await _wait(0.1)
	_check(rules.swaps == 2, "a swipe off the end does nothing")
	# hint
	_button(game, "Hint").pressed.emit()
	var h := rules.hint()
	var current: Array = game.get("_balloons")
	_check(current[h].glow and current[h + 1].glow, "the hint makes the pair glow")
	# restart
	_button(game, "Restart").pressed.emit()
	await _wait(0.3)
	rules = game.get("_rules")
	_check(rules.swaps == 0 and rules.values == rules.start_values, "Restart: the same row again")
	# follow the hints until it is in order
	for step in 40:
		if rules.is_sorted():
			break
		var k := rules.hint()
		var row: Array = game.get("_balloons")
		row[k].pressed.emit()
		row[k + 1].pressed.emit()
		await _wait(0.3)
	_check(rules.is_sorted(), "sorted by tapping")
	await _wait(2.4)
	_check(_text(game, "All the balloons are in order!") and _button(game, "Next level") != null, "the end of a puzzle, and what next")
	_check(App.best_score("aeolus_balloons", 2) == 3, "its stars are kept (%d)" % App.best_score("aeolus_balloons", 2))
	# the biggest-first level is sorted downwards
	_button(game, "Next level").pressed.emit()
	await _wait(0.3)
	rules = game.get("_rules")
	_check(rules.level == 2 and rules.direction == BalloonRules.Direction.DOWN, "the third level goes biggest first")


func _in_order(row: Array[int], direction: BalloonRules.Direction) -> bool:
	for i in row.size() - 1:
		if (row[i] > row[i + 1]) if direction == BalloonRules.Direction.UP else (row[i] < row[i + 1]):
			return false
	return true


func _distinct(a: Array[int]) -> bool:
	var seen := {}
	for v in a:
		seen[v] = true
	return seen.size() == a.size()


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _button(root: Node, text: String) -> Button:
	for c in root.find_children("*", "Button", true, false):
		if (c as Button).text == text and (c as Button).is_visible_in_tree():
			return c
	return null


func _text(root: Node, text: String) -> bool:
	for c in root.find_children("*", "Label", true, false):
		if (c as Label).text == text and (c as Label).is_visible_in_tree():
			return true
	return false


func _check(ok: bool, what: String) -> void:
	if not ok:
		_failures += 1
		print("  FAIL: " + what)
