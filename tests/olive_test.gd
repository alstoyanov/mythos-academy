extends Node
## Olive Harvest: its rules (OliveRules) on every level over many orders, then the screen: fill the
## basket from the tree, take one out, a wrong "Done" (counting together), the goat and the tablets,
## the baskets to choose from, and the end of a level with its stars.
##   godot --headless --path . res://tests/olive_test.tscn
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
	rng.seed = 7
	for level in 5:
		for game in 20:
			var r := OliveRules.new(level, rng)
			var last := -1
			while not r.level_done():
				r.new_order()
				_check(r.target != last, "level %d: a new answer each order" % (level + 1))
				last = r.target
				match r.kind:
					OliveRules.Kind.COUNT:
						_check(r.target >= 1 and r.target <= (5 if r.order_index < 5 else 10), "count to 5, then 10 (%d)" % r.target)
					OliveRules.Kind.MATCH:
						_check(r.baskets.size() == 3 and r.baskets.has(r.target) and _distinct(r.baskets)
							and r.baskets.min() >= 1 and r.baskets.max() <= 10, "three different baskets %s" % str(r.baskets))
					OliveRules.Kind.ADD:
						_check(r.a >= 1 and r.b >= 1 and r.target == r.a + r.b and r.target <= 10, "adding within 10")
						_check(r.choices.size() == 3 and r.choices.has(r.target) and _distinct(r.choices), "three choices")
					OliveRules.Kind.TAKE:
						_check(r.target == r.a - r.b and r.b >= 1 and r.target >= 2 and r.a <= 10, "taking away, two left at least")
						_check(r.choices.size() == 3 and r.choices.has(r.target) and _distinct(r.choices), "three choices")
					OliveRules.Kind.TENS:
						_check(r.target >= 11 and r.target <= 20, "11 to 20 (%d)" % r.target)
				var coins := r.coins
				if game % 3 == 0:
					_check(not r.answer(r.target + 1), "a wrong answer is not right")
					_check(r.coins == coins, "a wrong answer takes nothing away")
				_check(r.answer(r.target) and r.coins == coins + 1, "a right answer pays a coin")
			_check(r.coins == OliveRules.ORDERS, "ten coins finish a level")
			var expected := 3 if r.first_try >= 8 else (2 if r.first_try >= 5 else 1)
			_check(r.stars() == expected and r.stars() >= 1, "stars for the orders right at the first try")
	var h := OliveRules.new(1, rng)
	h.new_order()
	h.answer(h.target + 1)
	_check(not h.hint_due(), "no hint after one wrong answer")
	h.answer(h.target + 1)
	_check(h.hint_due(), "a hint after two")


func _test_screen() -> void:
	print("screen")
	get_tree().change_scene_to_file("res://scenes/games/olive_harvest.tscn")
	await _wait(0.3)
	var game := get_tree().current_scene
	_check(_button(game, "1 · Count the olives") != null and _button(game, "5 · Up to 20") != null, "the five levels")
	# Level 1: count
	_button(game, "1 · Count the olives").pressed.emit()
	await _wait(0.3)
	var rules: OliveRules = game.get("_rules")
	var basket: OliveBasket = game.get("_basket")
	var tree := _role(game, "tree") as BaseButton
	_check(basket != null and tree != null and basket.count == 0, "an empty basket and the tree")
	for i in rules.target + 1:  # one too many...
		tree.pressed.emit()
	await _wait(0.8)
	_check(basket.count == rules.target + 1, "the tree drops olives into the basket (%d)" % basket.count)
	_button(game, "Done").pressed.emit()
	await _wait(0.2)
	_check(rules.coins == 0 and rules.mistakes == 1, "one too many: no coin, nothing taken away")
	await _wait(1.2 + OliveHarvestTiming.count_time(basket.count))
	_check(not game.get("_busy"), "after counting together the child goes on")
	basket.pressed.emit()  # ...so one out
	await _wait(0.1)
	_check(basket.count == rules.target, "tapping the basket takes one out")
	_button(game, "Done").pressed.emit()
	await _wait(0.1)
	_check(rules.coins == 1, "the right number: a coin")
	await _wait(2.2)
	_check(game.get("_basket") != basket, "a new order")

	# Level 4: the goat, then the tablets
	game.call("_start", 3)
	await _wait(4.5)
	rules = game.get("_rules")
	basket = game.get("_basket")
	var answers: Array = game.get("_answers")
	_check(basket.count == rules.target, "the goat ate %d (%d left)" % [rules.b, basket.count])
	_check(answers.size() == 3, "then three tablets to choose from")
	for t: NumberTablet in answers:
		if t.value != rules.target:
			t.pressed.emit()
			break
	await _wait(1.2 + OliveHarvestTiming.count_time(basket.count))
	for t: NumberTablet in answers:
		if t.value == rules.target:
			t.pressed.emit()
	await _wait(0.1)
	_check(rules.coins == 1, "the tablet with the olives left: a coin")

	# Level 2: the baskets; the end of a level
	game.call("_start", 1)
	await _wait(0.3)
	rules = game.get("_rules")
	rules.order_index = OliveRules.ORDERS - 1  # (the last order)
	rules.coins = OliveRules.ORDERS - 1
	rules.first_try = 9
	for b: OliveBasket in game.get("_answers"):
		if b.count == rules.target:
			b.pressed.emit()
	await _wait(2.2)
	_check(_has_text(game, "All the baskets are full!"), "ten coins: the level is done")
	_check(App.best_score("olive_harvest", 2) == 3, "its stars are kept (%d)" % App.best_score("olive_harvest", 2))
	_check(_button(game, "Next level") != null and _button(game, "Choose a level") != null, "and what next")


func _distinct(a: Array[int]) -> bool:
	var seen := {}
	for v in a:
		seen[v] = true
	return seen.size() == a.size()


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _role(root: Node, role: String) -> Node:
	for c in root.find_children("*", "", true, false):
		if c.get_meta("role", "") == role and not c.is_queued_for_deletion():
			return c
	return null


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


## How long counting together takes (OliveHarvest.COUNT_STEP per olive), for the waits above.
class OliveHarvestTiming:
	static func count_time(n: int) -> float:
		return n * 0.75 + 0.3
