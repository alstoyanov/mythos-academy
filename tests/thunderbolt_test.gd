extends Node
## Zeus' Thunderbolts: its rules (ThunderboltRules) over many rounds, then the screen itself: a wrong
## tap leaves the score alone and brings the hint, a right tap scores and brings new clouds.
##   godot --headless --path . res://tests/thunderbolt_test.tscn
## Exits with 0 on success, 1 on failure.

var _failures := 0


func _ready() -> void:
	var stand_in := Node.new()  # this node stays while the screens change
	get_tree().root.add_child.call_deferred(stand_in)
	await get_tree().process_frame
	get_tree().current_scene = stand_in
	App.language = "en"  # (the checks look for the English texts; not saved)
	TranslationServer.set_locale("en")
	_test_rules()
	await _test_screen()
	print("FAILED: %d" % _failures if _failures > 0 else "ALL PASSED")
	get_tree().quit(1 if _failures > 0 else 0)


func _test_rules() -> void:
	print("rules")
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	var r := ThunderboltRules.new(rng)
	var goals: Array = []
	var last_score := 0
	for round in 60:
		var nums := r.new_round()
		goals.append(r.goal)
		_check(nums.size() >= 2 and nums.size() <= 4, "2 to 4 numbers (%d)" % nums.size())
		var distinct := {}
		for v in nums:
			distinct[v] = true
		_check(distinct.size() == nums.size(), "the numbers are all different %s" % str(nums))
		_check(nums.min() >= 1 and nums.max() <= (10 if r.score < 15 else 20), "numbers in range %s" % str(nums))
		if r.score < 3:
			_check(nums.size() == 2, "it starts with two numbers")
		var want: int = nums.max() if r.goal == ThunderboltRules.Goal.BIGGEST else nums.min()
		_check(r.answer() == want, "the answer is the %s" % ("biggest" if r.goal == ThunderboltRules.Goal.BIGGEST else "smallest"))
		if round % 4 == 1:  # a wrong pick or two first
			for v in nums:
				if v != want:
					_check(not r.pick(v), "a wrong pick is not right")
					_check(r.score == last_score, "a wrong pick takes nothing away")
					break
		_check(r.pick(want), "the right pick is right")
		_check(r.score == last_score + 1, "a right pick scores one")
		last_score = r.score
	for i in goals.size():
		var expected := ThunderboltRules.Goal.BIGGEST if (i / 3) % 2 == 0 else ThunderboltRules.Goal.SMALLEST
		_check(goals[i] == expected, "round %d asks for the %s" % [i, "biggest" if expected == 0 else "smallest"])
	var h := ThunderboltRules.new(rng)
	var nums := h.new_round()
	var wrong: int = nums.min() if h.goal == ThunderboltRules.Goal.BIGGEST else nums.max()
	h.pick(wrong)
	_check(not h.hint_due(), "no hint after one wrong pick")
	h.pick(wrong)
	_check(h.hint_due(), "a hint after two wrong picks")


func _test_screen() -> void:
	print("screen")
	App.voice_on = false
	var scores := "user://test_progress.cfg"  # (the player's own best scores are left alone)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(scores))
	App.use_progress_file(scores)
	get_tree().change_scene_to_file("res://scenes/games/zeus_thunderbolts.tscn")
	await get_tree().create_timer(0.3).timeout
	var game := get_tree().current_scene
	_check(game.get("_clouds").is_empty() and not game.get("_running"), "first the choice of time, no clouds yet")
	var one := _button(game, "1 minute")
	_check(one != null and _button(game, "2 minutes") != null and _button(game, "3 minutes") != null,
		"1, 2 and 3 minutes to choose from")
	one.pressed.emit()
	await get_tree().create_timer(2.6).timeout  # the first announcement, then the clouds
	_check(game.get("_running") and game.get("_seconds") == 60, "a round of one minute runs")
	var rules: ThunderboltRules = game.get("_rules")
	var clouds: Array = game.get("_clouds")
	_check(clouds.size() == 2, "two clouds to start (%d)" % clouds.size())
	var right: NumberCloud = null
	var wrong: NumberCloud = null
	for c: NumberCloud in clouds:
		if c.value == rules.answer():
			right = c
		else:
			wrong = c
	wrong.pressed.emit()
	wrong.pressed.emit()
	await get_tree().process_frame
	_check(rules.score == 0, "wrong taps do not cost points")
	_check(right.glowing, "after two wrong taps the right cloud glows")
	right.pressed.emit()
	await get_tree().process_frame
	_check(rules.score == 1 and (game.get("_score_label") as Label).text == "1", "a right tap scores")
	await get_tree().create_timer(1.6).timeout
	var next: Array = game.get("_clouds")
	_check(not next.is_empty() and next[0] != right, "new clouds come")
	var clock := game.get("_clock") as Label
	_check(clock.text == "1:00" or clock.text == "0:59" or clock.text == "0:58", "the clock counts down (%s)" % clock.text)

	# The time runs out: the results, and the best score kept for one minute.
	game.set("_time_left", 0.5)
	await get_tree().create_timer(0.8).timeout
	_check(not game.get("_running"), "the round ends when the time is up")
	_check(_has_text(game, "Time's up!") and _has_text(game, "Score: 1"), "the results show the score")
	_check(_has_text(game, "New best!") and App.best_score("zeus_thunderbolts", 60) == 1, "a first score is a new best, kept")
	_check(App.best_score("zeus_thunderbolts", 120) == 0, "each length has its own best")
	var again := _button(game, "Play again")
	again.pressed.emit()
	await get_tree().process_frame
	_check(game.get("_running") and (game.get("_rules") as ThunderboltRules).score == 0, "Play again starts a new round from 0")
	App.use_progress_file("user://progress.cfg")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(scores))


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
