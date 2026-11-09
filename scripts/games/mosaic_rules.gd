class_name MosaicRules
extends RefCounted
## The rules of The Mosaic of Words (Language, Grade 1), without the screen: a word search in Bulgarian.
## A rectangle of letters (SIZES) hides a few words (WORD_COUNTS) that the child finds and marks by
## selecting a straight line of letters. Chosen before playing:
##   the size        5 × 8 up to 8 × 12 (rows × columns);
##   the directions  only across (left to right), or across and down (top to bottom); never backwards
##                   or diagonal, so a first grader always reads a word the usual way;
##   the letters     the first 10 (А to Й), the first 20 (А to У) or all 30 letters of the alphabet: the
##                   words and the letters around them use only those.
## The words come from data/words.json (the picture words and the extra words) and data/word_mosaic.json
## (more words, mostly of the first 10 letters). They do not cross or touch end to end, and each can be
## read in exactly one place of the rectangle (the random letters never spell it again, across or down,
## nor spell a rude word: AVOID). A line selected may be a word (FOUND), one found before (ALREADY), part
## of a word (PART: not a mistake), or none (WRONG). After HINT_AFTER wrong lines since the last word
## found, a hint is due: the first letter of a word glows. Stars: for the help needed (wrong lines and
## hints): at most 2 → 3 stars, at most 5 → 2, else 1. Nothing is ever taken away.

enum Result { NONE, FOUND, ALREADY, PART, WRONG }

const WORDS := "res://data/words.json"
const MORE_WORDS := "res://data/word_mosaic.json"
const ALPHABET := "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЮЯ"
const SIZES := [Vector2i(8, 5), Vector2i(9, 6), Vector2i(10, 7), Vector2i(12, 8)]  ## columns × rows
const SIZE_NAMES := ["5 × 8", "6 × 9", "7 × 10", "8 × 12"]  ## rows × columns, as a teacher says it
const WORD_COUNTS := [4, 5, 6, 8]  ## by size
const LETTER_COUNTS := [10, 20, 30]
const FILL_SHARE := 0.55  ## the words cover at most this share of the rectangle
const HINT_AFTER := 2
const NOWHERE := Vector2i(-1, -1)
## Rude words the random letters must never spell (across or down).
const AVOID := ["ХУЙ", "ПУТКА", "ЕБА", "ЕБИ", "ГЪЗ", "КУР", "КУРВА", "ЛАЙНО", "ПИШКА", "ДУПЕ"]

var columns := 8
var rows := 5
var down := false  ## words also go down
var letters := ""  ## the letters used, in capitals
var size_index := 0
var letters_index := 0
var grid: Array[String] = []  ## a capital letter per cell, row by row
## The hidden words: {word (capitals), spoken (small letters), picture (or ""), cells: Array[Vector2i],
## found: bool}, in the order their cards are shown.
var words: Array[Dictionary] = []
var mistakes := 0  ## wrong lines in all
var hints := 0
var misses := 0  ## wrong lines since the last word found
var _rng: RandomNumberGenerator


func _init(p_size_index: int = 0, p_down: bool = false, p_letters_index: int = 2,
		rng: RandomNumberGenerator = null) -> void:
	size_index = clampi(p_size_index, 0, SIZES.size() - 1)
	letters_index = clampi(p_letters_index, 0, LETTER_COUNTS.size() - 1)
	down = p_down
	columns = SIZES[size_index].x
	rows = SIZES[size_index].y
	letters = ALPHABET.substr(0, LETTER_COUNTS[letters_index])
	_rng = rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()
	_generate()


## The key of this choice's best stars (App.best_score / record_score).
func key() -> int:
	return key_of(size_index, down, letters_index)


static func key_of(p_size_index: int, p_down: bool, p_letters_index: int) -> int:
	return 1 + p_size_index * 100 + (10 if p_down else 0) + p_letters_index


## The words that can be hidden with `letter_count` letters: {word, spoken, picture}, each word once.
static func pool(letter_count: int) -> Array[Dictionary]:
	var allowed := ALPHABET.substr(0, letter_count).to_lower()
	var out: Array[Dictionary] = []
	var seen := {}
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(WORDS))
	var more: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(MORE_WORDS))
	var found: Array[Dictionary] = []
	for w: Dictionary in data["words"]:
		found.append({"word": w["bg"], "picture": w["id"]})
	for w: Dictionary in more["words"]:
		found.append({"word": w["word"], "picture": w.get("picture", "")})
	for e: String in (data["extra"] as Dictionary).get("bg", []):
		found.append({"word": e, "picture": ""})
	for w in found:
		var word: String = w["word"]
		if seen.has(word) or word.length() < 2 or not _only(word, allowed):
			continue
		seen[word] = true
		out.append({"word": word.to_upper(), "spoken": word, "picture": w["picture"]})
	return out


static func _only(word: String, allowed: String) -> bool:
	for ch in word:
		if not allowed.contains(ch):
			return false
	return true


## The letter in `cell` (column, row).
func letter(cell: Vector2i) -> String:
	return grid[cell.y * columns + cell.x]


func inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < columns and cell.y < rows


## The cells from `from` to `to` if they are on one row (or, with `down`, one column), else none.
func line(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	if not inside(from) or not inside(to):
		return out
	if from.y != to.y and not (down and from.x == to.x):
		return out
	var step := Vector2i(signi(to.x - from.x), signi(to.y - from.y))
	var c := from
	out.append(c)
	while c != to:
		c += step
		out.append(c)
	return out


## The child selects `cells` (a line, in either direction): what it is, and which word (or -1).
## A word found is marked; a wrong line counts towards the hint.
func check(cells: Array[Vector2i]) -> Dictionary:
	if cells.size() < 2:
		return {"result": Result.NONE, "index": -1}
	for i in words.size():
		var w: Dictionary = words[i]
		var at: Array = w["cells"]
		if _same(cells, at):
			if w["found"]:
				return {"result": Result.ALREADY, "index": i}
			w["found"] = true
			misses = 0
			return {"result": Result.FOUND, "index": i}
	for i in words.size():
		var w: Dictionary = words[i]
		if not w["found"] and cells.all(func(c: Vector2i) -> bool: return (w["cells"] as Array).has(c)):
			return {"result": Result.PART, "index": i}
	mistakes += 1
	misses += 1
	return {"result": Result.WRONG, "index": -1}


func _same(cells: Array[Vector2i], at: Array) -> bool:
	if cells.size() != at.size():
		return false
	var forward := true
	var backward := true
	for k in cells.size():
		forward = forward and cells[k] == at[k]
		backward = backward and cells[k] == at[at.size() - 1 - k]
	return forward or backward


func hint_due() -> bool:
	return misses >= HINT_AFTER


## The word a hint shows: the first one not found yet (-1 when all are found).
func hint_word() -> int:
	for i in words.size():
		if not words[i]["found"]:
			return i
	return -1


## The first letter of the hint's word (counted as help asked for when `asked`).
func hint_cell(asked: bool = false) -> Vector2i:
	var i := hint_word()
	if i < 0:
		return NOWHERE
	if asked:
		hints += 1
	return (words[i]["cells"] as Array)[0]


func found_count() -> int:
	return words.filter(func(w: Dictionary) -> bool: return w["found"]).size()


func done() -> bool:
	return found_count() == words.size()


func stars() -> int:
	var help := mistakes + hints
	if help <= 2:
		return 3
	if help <= 5:
		return 2
	return 1


# ---------- making the rectangle ----------

## Chooses the words and hides them, then fills the other cells; again (with one word fewer at worst)
## until no word can be read twice and nothing rude is spelled.
func _generate() -> void:
	var longest := maxi(columns, rows) if down else columns
	var candidates: Array[Dictionary] = []
	for w in pool(letters.length()):
		if (w["word"] as String).length() <= longest:
			candidates.append(w)
	var count: int = WORD_COUNTS[size_index]
	while count > 0:
		for attempt in 60:
			var chosen := _choose(candidates, count)
			if chosen.size() < count:
				break
			if not _place(chosen):
				continue
			for fill in 40:
				_fill()
				if _valid():
					return
		count -= 1
	push_warning("MosaicRules: no rectangle could be made")


## `count` words that do not hide in one another, nor start alike (жаба, жаби), and fit the rectangle;
## two of every three with a picture where there are enough.
func _choose(candidates: Array[Dictionary], count: int) -> Array[Dictionary]:
	var pictures: Array[Dictionary] = []
	var others: Array[Dictionary] = []
	for w in candidates:
		(pictures if w["picture"] != "" else others).append(w)
	_shuffle(pictures)
	_shuffle(others)
	var order: Array[Dictionary] = []
	while not pictures.is_empty() or not others.is_empty():
		for k in 2:
			if not pictures.is_empty():
				order.append(pictures.pop_back())
		if not others.is_empty():
			order.append(others.pop_back())
	var budget := int(columns * rows * FILL_SHARE)
	var out: Array[Dictionary] = []
	var used := 0
	for w in order:
		var word: String = w["word"]
		if used + word.length() > budget:
			continue
		var clash := false
		for o in out:
			var other: String = o["word"]
			if word.contains(other) or other.contains(word) or word.left(3) == other.left(3):
				clash = true
				break
		if clash:
			continue
		out.append(w)
		used += word.length()
		if out.size() == count:
			break
	return out


## Hides the words, the longest first, each where it fits without crossing another or touching one end
## to end. With `down`, at least one goes across and one down. False if they do not all fit.
func _place(chosen: Array[Dictionary]) -> bool:
	var sorted := chosen.duplicate()
	sorted.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return (a["word"] as String).length() > (b["word"] as String).length())
	var owner: Array[int] = []
	owner.resize(columns * rows)
	owner.fill(-1)
	var placed: Array[Dictionary] = []
	var across := 0
	var downward := 0
	for w in sorted:
		var length := (w["word"] as String).length()
		var options: Array = []
		for dir: Vector2i in ([Vector2i(1, 0), Vector2i(0, 1)] if down else [Vector2i(1, 0)]):
			for y in rows:
				for x in columns:
					if _fits(Vector2i(x, y), dir, length, owner):
						options.append([Vector2i(x, y), dir])
		if options.is_empty():
			return false
		# with `down`, the last word goes the way none has gone yet
		if down and placed.size() == sorted.size() - 1 and (across == 0 or downward == 0):
			var need := Vector2i(1, 0) if across == 0 else Vector2i(0, 1)
			options = options.filter(func(o: Array) -> bool: return o[1] == need)
			if options.is_empty():
				return false
		var pick: Array = options[_rng.randi_range(0, options.size() - 1)]
		var cells: Array[Vector2i] = []
		for k in length:
			var c: Vector2i = pick[0] + pick[1] * k
			cells.append(c)
			owner[c.y * columns + c.x] = placed.size()
		if pick[1] == Vector2i(1, 0):
			across += 1
		else:
			downward += 1
		placed.append({"word": w["word"], "spoken": w["spoken"], "picture": w["picture"], "cells": cells, "found": false})
	# the cards in the order of the rectangle (top to bottom, left to right), not by length
	placed.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ca: Vector2i = (a["cells"] as Array)[0]
		var cb: Vector2i = (b["cells"] as Array)[0]
		return ca.y < cb.y or (ca.y == cb.y and ca.x < cb.x))
	words = placed
	grid.resize(columns * rows)
	grid.fill("")
	for w in words:
		var word: String = w["word"]
		var cells: Array = w["cells"]
		for k in cells.size():
			var c: Vector2i = cells[k]
			grid[c.y * columns + c.x] = word[k]
	return true


func _fits(start: Vector2i, dir: Vector2i, length: int, owner: Array[int]) -> bool:
	var end := start + dir * (length - 1)
	if not inside(end):
		return false
	for k in length:
		var c := start + dir * k
		if owner[c.y * columns + c.x] != -1:
			return false
	for c in [start - dir, end + dir]:  # no word right before or after it on its line
		if inside(c) and owner[c.y * columns + c.x] != -1:
			return false
	return true


## The cells of no word get random letters of those chosen (never "Ь", which only comes before "О").
func _fill() -> void:
	var taken := {}
	for w in words:
		for c: Vector2i in w["cells"]:
			taken[c] = true
	var choice := letters.replace("Ь", "")
	for y in rows:
		for x in columns:
			if not taken.has(Vector2i(x, y)):
				grid[y * columns + x] = choice[_rng.randi_range(0, choice.length() - 1)]


## Every word can be read in one place only, and nothing rude can be read, across or down.
func _valid() -> bool:
	var lines := _lines()
	for w in words:
		var n := 0
		for l in lines:
			n += _count(l, w["word"])
		if n != 1:
			return false
	for bad: String in AVOID:
		for l in lines:
			if l.contains(bad):
				return false
	return true


## Every row from left to right and every column from top to bottom.
func _lines() -> Array[String]:
	var out: Array[String] = []
	for y in rows:
		var s := ""
		for x in columns:
			s += grid[y * columns + x]
		out.append(s)
	for x in columns:
		var s := ""
		for y in rows:
			s += grid[y * columns + x]
		out.append(s)
	return out


static func _count(text: String, part: String) -> int:
	var n := 0
	var at := text.find(part)
	while at != -1:
		n += 1
		at = text.find(part, at + 1)
	return n


func _shuffle(a: Array) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := _rng.randi_range(0, i)
		var t: Variant = a[i]
		a[i] = a[j]
		a[j] = t
