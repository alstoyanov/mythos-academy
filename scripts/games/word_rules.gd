class_name WordRules
extends RefCounted
## The rules of The Muses' Words (Language, Grade 1), without the screen: reading simple words, in the
## game's language. The words, each with a picture, are in data/words.json (made by
## tools/make_words.py), with extra words per language that are only used as wrong choices.
##   FIND_WORD     a picture and WORD_CHOICES words: the other words start with the same letter and are
##                 about as long (within 1 letter if there are enough, else 2), so the child must read
##                 the whole word, not guess from its first letter or its length;
##   FIND_PICTURE  a word and PICTURE_CHOICES pictures: the other pictures' words start with the same
##                 letter when there are such words.
## A word does not come again within RECENT rounds. Nothing is ever taken away: a right pick scores a
## point and ends the round; a wrong one only counts towards the hint (after HINT_AFTER the answer
## glows).

enum Mode { FIND_WORD, FIND_PICTURE }

const DATA := "res://data/words.json"
const WORD_CHOICES := 5
const PICTURE_CHOICES := 4
const RECENT := 20
const HINT_AFTER := 2

var mode: Mode = Mode.FIND_WORD
var score := 0
var round_index := 0
var mistakes := 0
var target := {}  ## {id, word}: this round's word and its picture
var choices: Array[String] = []  ## FIND_WORD: words; FIND_PICTURE: picture ids
var _words: Array[Dictionary] = []  ## {id, word} in the language played
var _pool: Array[String] = []  ## every word that can be a wrong choice: the picture words and the extra ones
var _recent: Array[String] = []
var _rng: RandomNumberGenerator


## The words of `language` ("bg", "en"): {"words": [{id, word}], "extra": [word]}.
static func load_words(language: String) -> Dictionary:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(DATA))
	var words: Array[Dictionary] = []
	var lang := language if (data["words"][0] as Dictionary).has(language) else "en"
	for w: Dictionary in data["words"]:
		words.append({"id": w["id"], "word": w[lang]})
	var extra: Array[String] = []
	for e: String in (data["extra"] as Dictionary).get(lang, []):
		extra.append(e)
	return {"words": words, "extra": extra}


func _init(p_mode: Mode = Mode.FIND_WORD, language: String = "bg", rng: RandomNumberGenerator = null) -> void:
	mode = p_mode
	_rng = rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()
	var data := load_words(language)
	_words = data["words"]
	for w in _words:
		_pool.append(w["word"])
	for e: String in data["extra"]:
		if not _pool.has(e):
			_pool.append(e)


func word_count() -> int:
	return _words.size()


## Starts a round: a word not seen lately, and its choices (shuffled, the answer among them).
func new_round() -> void:
	mistakes = 0
	var fresh: Array[Dictionary] = []
	for w in _words:
		if not _recent.has(w["id"]):
			fresh.append(w)
	target = fresh[_rng.randi_range(0, fresh.size() - 1)]
	_recent.append(target["id"])
	if _recent.size() > mini(RECENT, _words.size() - 1):
		_recent.pop_front()
	choices = wrong_words(target["word"]) if mode == Mode.FIND_WORD else _wrong_pictures()
	choices.append(answer())
	_shuffle(choices)


## The answer: the word (FIND_WORD) or the picture's id (FIND_PICTURE).
func answer() -> String:
	return target["word"] if mode == Mode.FIND_WORD else target["id"]


## WORD_CHOICES − 1 other words for `word`: the same first letter, the length as close as there are
## (within 1, then 2, then any), picked at random among the closest.
func wrong_words(word: String) -> Array[String]:
	var out: Array[String] = []
	for spread in [1, 2, 99]:
		var near: Array[String] = []
		for w in _pool:
			if w != word and not out.has(w) and w[0] == word[0] and absi(w.length() - word.length()) <= spread:
				near.append(w)
		_shuffle(near)
		for w in near:
			if out.size() < WORD_CHOICES - 1:
				out.append(w)
	return out


## PICTURE_CHOICES − 1 other pictures: those whose words start with the same letter first.
func _wrong_pictures() -> Array[String]:
	var same: Array[String] = []
	var other: Array[String] = []
	for w in _words:
		if w["id"] == target["id"]:
			continue
		if (w["word"] as String)[0] == (target["word"] as String)[0]:
			same.append(w["id"])
		else:
			other.append(w["id"])
	_shuffle(same)
	_shuffle(other)
	same.append_array(other)
	return same.slice(0, PICTURE_CHOICES - 1)


## The word of a picture.
func word_of(id: String) -> String:
	for w in _words:
		if w["id"] == id:
			return w["word"]
	return ""


## The child picks `choice` (a word or a picture id): true (a point, the round is over) if right.
func pick(choice: String) -> bool:
	if choice == answer():
		score += 1
		round_index += 1
		return true
	mistakes += 1
	return false


func hint_due() -> bool:
	return mistakes >= HINT_AFTER


func _shuffle(a: Array[String]) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := _rng.randi_range(0, i)
		var t := a[i]
		a[i] = a[j]
		a[j] = t
