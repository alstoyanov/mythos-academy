extends Node
## Hercules' Leaps: its rules (LeapRules) on every level over many games, then the screen: choosing a sign
## and a number in either order, a wrong sign, a wrong number, the hint, the leap and the view moving on,
## and the end of a level with its stars.
##   godot --headless --path . res://tests/leaps_test.tscn
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
	rng.seed = 5
	for level in LeapRules.LEVELS.size():
		var low: int = LeapRules.LEVELS[level][0]
		var high: int = LeapRules.LEVELS[level][1]
		var signs := {}
		for game in 200:
			var r := LeapRules.new(level, rng)
			_check(r.here == low, "level %d starts at its lowest number" % (level + 1))
			var previous := -1
			while not r.level_done():
				_check(r.here >= low and r.here <= high and r.there >= low and r.there <= high, "level %d: %d to %d in range" % [level + 1, r.here, r.there])
				_check(r.there != r.here and r.there != previous, "a new cliff (%d to %d, from %d)" % [r.here, r.there, previous])
				_check(r.needed_amount() >= 1 and r.needed_amount() <= LeapRules.MAX_LEAP, "a single digit answer (%d)" % r.needed_amount())
				_check(r.here + r.needed_sign() * r.needed_amount() == r.there, "the answer makes the sum true")
				signs[r.needed_sign()] = true
				var done := r.jumps_done
				if game % 3 == 0:
					_check(r.answer(-r.needed_sign(), r.needed_amount()) == LeapRules.Result.WRONG_SIGN, "the other sign is wrong")
					_check(r.answer(r.needed_sign(), (r.needed_amount() + 1) % 10) == LeapRules.Result.WRONG_AMOUNT, "another number is wrong")
					_check(r.jumps_done == done and r.mistakes == 2 and r.hint_due(), "wrong answers take nothing away, and bring the hint")
				_check(r.answer(r.needed_sign(), r.needed_amount()) == LeapRules.Result.RIGHT, "the right answer")
				_check(r.jumps_done == done + 1, "a leap counted")
				var landing := r.there
				previous = r.here
				r.land()
				_check(r.here == landing and r.mistakes == 0, "he lands on the next number")
			_check(r.jumps_done == LeapRules.JUMPS, "ten leaps")
			_check(r.stars() == (3 if game % 3 != 0 else 1), "stars count the leaps right first (%d)" % r.stars())
		_check(signs.has(1) and signs.has(-1), "level %d adds and takes away" % (level + 1))


func _test_screen() -> void:
	print("screen")
	get_tree().change_scene_to_file("res://scenes/games/hercules_leaps.tscn")
	await _wait(0.4)
	var game := get_tree().current_scene
	_check(_has_text(game, "Hercules' Leaps"), "the choice of level")
	game.call("_start", 1)
	await _wait(0.3)
	var rules: LeapRules = game.get("_rules")
	var plus: NumberTablet = game.get("_plus")
	var minus: NumberTablet = game.get("_minus")
	var digits: Array = game.get("_digits")
	_check(digits.size() == 10, "every one digit number")
	for d in 10:
		_check(digits[d].value == d, "the tablet of %d" % d)
	_check(_equation(game) == "%d  ?  ?  =  %d" % [rules.here, rules.there], "the sum to complete (%s)" % _equation(game))

	# a wrong sign: nothing is lost, and the choice is cleared
	var right_sign := plus if rules.needed_sign() > 0 else minus
	var wrong_sign := minus if rules.needed_sign() > 0 else plus
	wrong_sign.pressed.emit()
	await _wait(0.1)
	_check(wrong_sign.selected, "the sign is marked")
	digits[rules.needed_amount()].pressed.emit()
	await _wait(0.1)
	_check(rules.mistakes == 1 and rules.jumps_done == 0, "a wrong sign is a mistake")
	_check(not wrong_sign.selected and game.get("_amount") == -1, "and the choice is cleared")
	_check(_bubble(game).find(str(rules.there)) >= 0 and _bubble(game).find(str(rules.here)) >= 0, "and he is told which way (%s)" % _bubble(game))
	var stones: Array = game.get("_stones")
	_check(stones.size() == 2 and stones[0].value == rules.here and stones[1].value == rules.there, "the two cliffs show their numbers")

	# a wrong number, with the number first: the second mistake brings the hint
	var wrong_amount: int = (rules.needed_amount() + 1) % 10
	digits[wrong_amount].pressed.emit()
	await _wait(0.1)
	_check(rules.mistakes == 1, "a number alone is not an answer yet")
	right_sign.pressed.emit()
	await _wait(0.1)
	_check(rules.mistakes == 2, "with the sign it is checked")
	_check(right_sign.selected and game.get("_amount") == -1, "the right sign stays, the number goes")
	_check(_bubble(game).find("%d." % rules.there) >= 0, "and he is told what his sum makes (%s)" % _bubble(game))
	_check(right_sign.glowing and digits[rules.needed_amount()].glowing, "after two the right answer glows")

	# the right answer: he leaps, and the view moves on
	var landing := rules.there
	var world: Control = game.get("_world")
	var x_before := world.position.x
	digits[rules.needed_amount()].pressed.emit()
	await _wait(0.1)
	_check(rules.jumps_done == 1 and game.get("_busy"), "the right answer: he leaps")
	digits[0].pressed.emit()  # (taps while he is in the air do nothing)
	_check(game.get("_amount") != 0 or rules.needed_amount() == 0, "no choosing in the air")
	await _wait(0.9 + 0.9 + 0.7 + 0.3)
	_check(rules.here == landing and not game.get("_busy"), "he has landed on %d" % landing)
	_check(world.position.x < x_before, "the view has moved on")
	_check(not right_sign.selected and not digits[rules.needed_amount()].glowing, "a fresh question")
	_check(game.get("_stones").size() == 2 and game.get("_stones")[1].value == rules.there, "with the next cliff across the chasm")
	var hero: LeapHero = game.get("_hero")
	var hero_x: float = hero.global_position.x
	_check(absf(hero_x + LeapHero.SIDE * LeapHero.FEET - game.size.x * 0.25) < 2.0, "and him back on the left (%f)" % hero_x)

	# the end of a level
	game.call("_start", 1)
	await _wait(0.2)
	rules = game.get("_rules")
	rules.jumps_done = LeapRules.JUMPS - 1
	rules.first_try = 8
	_answer(game, rules)
	await _wait(0.9 + 0.9 + 0.4)
	_check(_has_text(game, "Hercules crossed every chasm!"), "ten leaps: the level is done")
	_check(App.best_score("hercules_leaps", 2) == 3, "its stars are kept (%d)" % App.best_score("hercules_leaps", 2))
	_check(_button(game, "Next level") != null and _button(game, "Choose a level") != null, "and what next")
	_button(game, "Next level").pressed.emit()
	await _wait(0.2)
	_check(game.get("_rules").level == 2 and game.get("_stones").size() == 2, "the next level starts")


func _answer(game: Node, rules: LeapRules) -> void:
	(game.get("_plus") if rules.needed_sign() > 0 else game.get("_minus")).pressed.emit()
	game.get("_digits")[rules.needed_amount()].pressed.emit()


func _equation(game: Node) -> String:
	return (game.get("_equation") as Label).text


func _bubble(game: Node) -> String:
	return (game.get("_bubble_label") as Label).text


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _button(root: Node, text: String) -> Button:
	for c in root.find_children("*", "Button", true, false):
		if (c as Button).text == text and (c as Button).is_visible_in_tree():
			return c
	return null


func _has_text(root: Node, text: String) -> bool:
	for c in root.find_children("*", "Label", true, false):
		if (c as Label).text == text and (c as Label).is_visible_in_tree():
			return true
	return false


func _check(ok: bool, what: String) -> void:
	if not ok:
		_failures += 1
		print("  FAIL: " + what)
