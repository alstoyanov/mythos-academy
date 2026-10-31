class_name HarvestRules
extends RefCounted
## The rules of Demeter's Harvest (Arithmetic, Grade 1), without the screen. Every basket is a problem:
## an equation with one number missing, one side in each basket of the scale, e.g.
##   3 + 4 = ?     9 − 3 = ?     5 + ? = 8     8 − ? = 5     4 + 3 = 5 + ?
## A side is a list of terms: the first is a number, each next one is added (positive) or taken away
## (negative). One term is unknown (unknown_side, unknown_index); the list holds its true value, whose
## size is the answer. The child picks the answer from CHOICES numbers: the answer, the numbers a
## first grader most often gives instead (adding instead of taking away, the other side's number), and
## numbers close to it.
## A level is ROUNDS problems of one kind (Kind, the levels of the specification §5.2a); the first half
## of a level keeps the numbers small. A wrong answer takes nothing away: it counts towards the help
## (after HINT_AFTER in a problem) and the stars, which count the problems right at the first try
## (always at least one star).

enum Kind { ADD, TAKE, MISSING, TO20, EQUAL }

const ROUNDS := 8  ## problems in a level
const CHOICES := 4
const HINT_AFTER := 2
const MAX := 20  ## no number above it
const KINDS := [Kind.ADD, Kind.TAKE, Kind.MISSING, Kind.TO20, Kind.EQUAL]  ## by level (0 .. 4)

var level := 0
var kind: Kind = Kind.ADD
var round_index := 0  ## problems solved
var first_try := 0  ## problems right at the first try
var mistakes := 0  ## wrong answers in this problem
var left: Array[int] = []  ## the left basket's terms
var right: Array[int] = []  ## the right basket's terms
var unknown_side := 1  ## -1 left, 1 right
var unknown_index := 0
var answer := 0
var choices: Array[int] = []  ## the numbers to choose from, the answer among them
var _rng: RandomNumberGenerator


func _init(p_level: int = 0, rng: RandomNumberGenerator = null) -> void:
	level = clampi(p_level, 0, KINDS.size() - 1)
	kind = KINDS[level]
	_rng = rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()


## Starts the next problem (never the same as the last one).
func new_round() -> void:
	mistakes = 0
	var last := str(left) + str(right)
	for attempt in 20:
		_make_round()
		if str(left) + str(right) != last:
			break
	choices = _choices()


func _make_round() -> void:
	var early := round_index * 2 < ROUNDS  # (the first half of a level keeps the numbers smaller)
	var plus := _rng.randi() % 2 == 0
	match kind:
		Kind.ADD:  # a + b = ?
			var s := _rng.randi_range(3, 7) if early else _rng.randi_range(5, 10)
			var a := _rng.randi_range(1, s - 1)
			_problem([a, s - a], [s], 1, 0)
		Kind.TAKE:  # a − b = ?
			var a := _rng.randi_range(4, 7) if early else _rng.randi_range(6, 10)
			var b := _rng.randi_range(1, a - 1)
			_problem([a, -b], [a - b], 1, 0)
		Kind.MISSING:  # a + ? = c, or a − ? = c
			if plus:
				var c := _rng.randi_range(4, 8) if early else _rng.randi_range(5, 10)
				var a := _rng.randi_range(1, c - 1)
				_problem([a, c - a], [c], -1, 1)
			else:
				var a := _rng.randi_range(4, 8) if early else _rng.randi_range(5, 10)
				var b := _rng.randi_range(1, a - 1)
				_problem([a, -b], [a - b], -1, 1)
		Kind.TO20:  # a + b = ? or a − b = ?, past ten
			if plus:
				var s := _rng.randi_range(11, 15 if early else 20)
				var a := _rng.randi_range(maxi(2, s - 9), mini(s - 2, 12))
				_problem([a, s - a], [s], 1, 0)
			else:
				var a := _rng.randi_range(11, 15 if early else 20)
				var b := _rng.randi_range(2, mini(9, a - 2))
				_problem([a, -b], [a - b], 1, 0)
		Kind.EQUAL:  # a + b = c + ?, the unknown on either side
			var s := _rng.randi_range(5, 8) if early else _rng.randi_range(6, 10)
			var a := _rng.randi_range(1, s - 1)
			var c := a
			for attempt in 10:
				c = _rng.randi_range(1, s - 1)
				if c != a and c != s - a:
					break
			if plus:
				_problem([a, s - a], [c, s - c], 1, 1)
			else:
				_problem([c, s - c], [a, s - a], -1, 1)


func _problem(l: Array[int], r: Array[int], side: int, index: int) -> void:
	left = l
	right = r
	unknown_side = side
	unknown_index = index
	answer = absi(terms(side)[index])


func terms(side: int) -> Array[int]:
	return left if side < 0 else right


func is_unknown(side: int, index: int) -> bool:
	return side == unknown_side and index == unknown_index


## What a side weighs with `guess` in the unknown's place (0: nothing there yet).
func value(side: int, guess: int = 0) -> int:
	var sum := 0
	var t := terms(side)
	for i in t.size():
		sum += (signi(t[i]) * guess) if is_unknown(side, i) else t[i]
	return sum


## How much heavier the right side is than the left with `guess` in the unknown's place.
func difference(guess: int = 0) -> int:
	return value(1, guess) - value(-1, guess)


## The child answers `number`: true if right (the problem is solved), else a mistake.
func check(number: int) -> bool:
	if number != answer:
		mistakes += 1
		return false
	if mistakes == 0:
		first_try += 1
	round_index += 1
	return true


func hint_due() -> bool:
	return mistakes >= HINT_AFTER


## The answer, the likely mistakes, and close numbers: CHOICES different numbers in 0..MAX, shuffled.
func _choices() -> Array[int]:
	var out: Array[int] = [answer]
	var known := terms(-unknown_side)
	var mine := terms(unknown_side)
	var likely: Array[int] = []
	if mine.size() == 1:  # the result is missing: the other operation (9 − 3 → 12, 3 + 4 → 1)
		likely.append(absi(known[0] - known[1]) if known[1] > 0 else known[0] - known[1])
	else:  # a missing part: the other side's number (5 + ? = 8 → 8), all the numbers added (→ 13)
		likely.append(value(-unknown_side))
		var all := 0
		for side in [-1, 1]:
			for i in terms(side).size():
				if not is_unknown(side, i):
					all += absi(terms(side)[i])
		likely.append(all)
	for v in likely:
		if v >= 0 and v <= MAX and not out.has(v):
			out.append(v)
	var spread := 1
	while out.size() < CHOICES:
		var v := answer + _rng.randi_range(-spread, spread)
		if v >= 0 and v <= MAX and not out.has(v):
			out.append(v)
		spread = mini(spread + 1, 4)
	for i in range(out.size() - 1, 0, -1):
		var j := _rng.randi_range(0, i)
		var t := out[i]
		out[i] = out[j]
		out[j] = t
	return out


func level_done() -> bool:
	return round_index >= ROUNDS


## 3 stars for 7 or more problems right at the first try, 2 for 4 or more, else 1.
func stars() -> int:
	if first_try >= 7:
		return 3
	return 2 if first_try >= 4 else 1
