extends Node
## The Muses' Words: the words (data/words.json: 100 words with pictures, in Bulgarian and English, each
## with enough wrong choices), the rules (WordRules) of both games in both languages over many rounds,
## then the screen: the choice of game and time, a wrong pick (dimmed, the word read back), the hint, a
## right pick, the other game, the end of a round and its best kept.
##   godot --headless --path . res://tests/words_test.tscn
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
	for language in ["bg", "en"]:
		_test_rules(language)
	await _test_screen()
	print("FAILED: %d" % _failures if _failures > 0 else "ALL PASSED")
	get_tree().quit(1 if _failures > 0 else 0)


func _test_words() -> void:
	print("words")
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(WordRules.DATA))
	var words: Array = data["words"]
	_check(words.size() == 100, "100 words (%d)" % words.size())
	var ids := {}
	for w: Dictionary in words:
		ids[w["id"]] = true
		_check(RegEx.create_from_string("^[a-z]+$").search(w["id"]) != null, "a picture name: %s" % w["id"])
	_check(ids.size() == words.size(), "every picture once")
	for language in ["bg", "en"]:
		var letters := "^[а-яѝ]+$" if language == "bg" else "^[a-z]+$"
		var seen := {}
		var data_l := WordRules.load_words(language)
		var pool: Array[String] = []
		for w: Dictionary in data_l["words"]:
			pool.append(w["word"])
		pool.append_array(data_l["extra"])
		for w: Dictionary in data_l["words"]:
			var word: String = w["word"]
			seen[word] = true
			_check(RegEx.create_from_string(letters).search(word) != null, "%s: small letters only (%s)" % [language, word])
			var near := pool.filter(func(o: String) -> bool:
				return o != word and o[0] == word[0] and absi(o.length() - word.length()) <= 2)
			_check(near.size() >= WordRules.WORD_CHOICES - 1, "%s: enough wrong choices for %s (%d)" % [language, word, near.size()])
		_check(seen.size() == words.size(), "%s: every word once" % language)


func _test_rules(language: String) -> void:
	print("rules " + language)
	var rng := RandomNumberGenerator.new()
	rng.seed = 3
	var r := WordRules.new(WordRules.Mode.FIND_WORD, language, rng)
	var recent: Array[String] = []
	for round in 300:
		r.new_round()
		var word: String = r.target["word"]
		_check(not recent.has(r.target["id"]), "%s: no word again within %d rounds" % [language, WordRules.RECENT])
		recent.append(r.target["id"])
		if recent.size() > WordRules.RECENT:
			recent.pop_front()
		_check(r.choices.size() == WordRules.WORD_CHOICES and r.choices.has(word), "%s: five words with the answer" % language)
		var distinct := {}
		for c in r.choices:
			distinct[c] = true
			_check(c[0] == word[0] and absi(c.length() - word.length()) <= 2, "%s: %s like %s" % [language, c, word])
		_check(distinct.size() == r.choices.size(), "%s: all different %s" % [language, str(r.choices)])
		if round % 7 == 0:
			var wrong := r.choices[0] if r.choices[0] != word else r.choices[1]
			_check(not r.pick(wrong), "a wrong word is not right")
			_check(not r.hint_due(), "no hint after one")
			r.pick(wrong)
			_check(r.hint_due(), "a hint after two")
		var score := r.score
		_check(r.pick(word) and r.score == score + 1, "the right word scores")
	var p := WordRules.new(WordRules.Mode.FIND_PICTURE, language, rng)
	for round in 300:
		p.new_round()
		var id: String = p.target["id"]
		_check(p.choices.size() == WordRules.PICTURE_CHOICES and p.choices.has(id), "%s: four pictures with the answer" % language)
		var distinct := {}
		var same := 0
		for c in p.choices:
			distinct[c] = true
			if c != id and p.word_of(c)[0] == (p.target["word"] as String)[0]:
				same += 1
		_check(distinct.size() == p.choices.size(), "%s: four different pictures" % language)
		var could := 0
		for w in WordRules.load_words(language)["words"]:
			if w["id"] != id and (w["word"] as String)[0] == (p.target["word"] as String)[0]:
				could += 1
		_check(same == mini(could, WordRules.PICTURE_CHOICES - 1), "%s: pictures with the same first letter first (%d of %d)" % [language, same, could])
		_check(p.pick(id), "the right picture scores")


func _test_screen() -> void:
	print("screen")
	var scores := "user://test_progress.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path(scores))
	App.use_progress_file(scores)
	get_tree().change_scene_to_file("res://scenes/games/muses_words.tscn")
	await _wait(0.3)
	var game := get_tree().current_scene
	_check(_has_text(game, "Find the word") and _has_text(game, "Find the picture"), "the two games")
	_check(_buttons(game, "1 minute").size() == 2 and _buttons(game, "3 minutes").size() == 2, "each with 1, 2 and 3 minutes")
	_buttons(game, "1 minute")[0].pressed.emit()
	await _wait(0.2)
	var rules: WordRules = game.get("_rules")
	var shown: WordCard = game.get("_shown")
	var cards: Array = game.get("_cards")
	_check(rules.mode == WordRules.Mode.FIND_WORD and shown.id == rules.target["id"], "a picture")
	_check(cards.size() == 5 and cards.all(func(c: WordCard) -> bool: return c.id == ""), "and five words")
	var wrong: Array = cards.filter(func(c: WordCard) -> bool: return c.text != rules.answer())
	wrong[0].pressed.emit()
	await get_tree().process_frame
	_check(wrong[0].tried and rules.score == 0 and _has_text(game, "That says \"%s\"." % wrong[0].text), "a wrong word: dimmed, read back")
	wrong[0].pressed.emit()
	_check(rules.mistakes == 1, "a dimmed word cannot be picked again")
	wrong[1].pressed.emit()
	var right: WordCard = cards.filter(func(c: WordCard) -> bool: return c.text == rules.answer())[0]
	_check(right.glowing, "after two the right word glows")
	right.pressed.emit()
	await get_tree().process_frame
	_check(rules.score == 1 and (game.get("_score_label") as Label).text == "1", "the right word scores")
	_check(_has_text(game, rules.target["word"]), "and is shown and read")
	await _wait(1.5)
	_check(game.get("_shown") != shown, "a new word")

	game.call("_start", 60, WordRules.Mode.FIND_PICTURE)
	await _wait(0.2)
	rules = game.get("_rules")
	shown = game.get("_shown")
	cards = game.get("_cards")
	_check(shown.text == rules.target["word"] and shown.id == "", "a word")
	_check(cards.size() == 4 and cards.all(func(c: WordCard) -> bool: return c.id != ""), "and four pictures")
	var other: WordCard = cards.filter(func(c: WordCard) -> bool: return c.id != rules.answer())[0]
	other.pressed.emit()
	await get_tree().process_frame
	_check(_has_text(game, "That is \"%s\"." % rules.word_of(other.id)), "a wrong picture: what it is")
	cards.filter(func(c: WordCard) -> bool: return c.id == rules.answer())[0].pressed.emit()
	await get_tree().process_frame
	_check(rules.score == 1, "the right picture scores")
	game.set("_time_left", 0.5)
	await _wait(0.8)
	_check(_has_text(game, "Time's up!") and _has_text(game, "New best!"), "the time is up: the score, a new best")
	_check(App.best_score("muses_words_find_picture", 60) == 1 and App.best_score("muses_words_find_word", 60) == 0,
		"each game keeps its own best")
	_check(not _buttons(game, "Change game").is_empty(), "and the choice of game again")
	App.use_progress_file("user://progress.cfg")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(scores))


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _buttons(root: Node, text: String) -> Array:
	return root.find_children("*", "Button", true, false).filter(func(b: Node) -> bool:
		return (b as Button).text == text and not b.is_queued_for_deletion())


func _has_text(root: Node, part: String) -> bool:
	for l in root.find_children("*", "Label", true, false):
		if (l as Label).text.contains(part) and not l.is_queued_for_deletion():
			return true
	return false


func _check(ok: bool, what: String) -> void:
	if not ok:
		_failures += 1
		print("  FAIL: " + what)
