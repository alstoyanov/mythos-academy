class_name OliveRules
extends RefCounted
## The rules of Olive Harvest (Arithmetic, Grade 1), without the screen. A level is ORDERS orders of
## one kind (Kind, the levels of the specification §5.2):
##   COUNT  put exactly `target` olives in the basket (1–5 at first, then up to 10)
##   MATCH  three baskets with olives: which one has `target`?
##   ADD    `a` olives and `b` more: how many? (three numbers to choose from; up to 10)
##   TAKE   `a` olives, the goat eats `b`: how many are left? (up to 10)
##   TENS   put exactly `target` olives in the basket, 11–20 (a whole row of ten at a time, or one)
## Nothing is ever taken away: every order ends with a coin once it is right; a wrong answer only
## counts towards the hint (after HINT_AFTER in an order the answer glows) and towards the stars,
## which count the orders right at the first try (always at least one star).

enum Kind { COUNT, MATCH, ADD, TAKE, TENS }

const ORDERS := 10  ## orders, and coins, in a level
const HINT_AFTER := 2
const KINDS := [Kind.COUNT, Kind.MATCH, Kind.ADD, Kind.TAKE, Kind.TENS]  ## by level (0 .. 4)

var level := 0
var kind: Kind = Kind.COUNT
var order_index := 0  ## orders done
var coins := 0
var first_try := 0  ## orders right at the first try
var mistakes := 0  ## wrong answers in this order
## The order: target (the answer), a and b (ADD, TAKE), choices (three numbers to choose from: ADD,
## TAKE), baskets (MATCH: the olives in each of three baskets).
var target := 0
var a := 0
var b := 0
var choices: Array[int] = []
var baskets: Array[int] = []
var _rng: RandomNumberGenerator


func _init(p_level: int = 0, rng: RandomNumberGenerator = null) -> void:
	level = clampi(p_level, 0, KINDS.size() - 1)
	kind = KINDS[level]
	_rng = rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()


## Starts the next order (a different answer from the last one).
func new_order() -> void:
	mistakes = 0
	choices = []
	baskets = []
	var last := target
	for attempt in 20:
		_make_order()
		if target != last:
			break


func _make_order() -> void:
	match kind:
		Kind.COUNT:
			target = _rng.randi_range(1, 5) if order_index < 5 else _rng.randi_range(3, 10)
		Kind.MATCH:
			target = _rng.randi_range(1, 10)
			baskets = _near(target, 1, 10)
		Kind.ADD:
			a = _rng.randi_range(1, 6)
			b = _rng.randi_range(1, mini(5, 10 - a))
			target = a + b
			choices = _near(target, 1, 10)
		Kind.TAKE:
			a = _rng.randi_range(4, 10)
			b = _rng.randi_range(1, mini(5, a - 2))  # (at least two left)
			target = a - b
			choices = _near(target, 1, 10)
		Kind.TENS:
			target = _rng.randi_range(11, 20)


## Three different numbers in [lo, hi], `answer` among them and the others close to it, shuffled.
func _near(answer: int, lo: int, hi: int) -> Array[int]:
	var out: Array[int] = [answer]
	var spread := 1
	while out.size() < 3:
		var v := answer + _rng.randi_range(-spread, spread)
		if v >= lo and v <= hi and not out.has(v):
			out.append(v)
		spread = mini(spread + 1, 3)
	for i in range(out.size() - 1, 0, -1):
		var j := _rng.randi_range(0, i)
		var t := out[i]
		out[i] = out[j]
		out[j] = t
	return out


## The child answers `value` (the olives in the basket, the basket's olives, the number chosen):
## true if right (a coin; the order is done).
func answer(value: int) -> bool:
	if value != target:
		mistakes += 1
		return false
	coins += 1
	if mistakes == 0:
		first_try += 1
	order_index += 1
	return true


func hint_due() -> bool:
	return mistakes >= HINT_AFTER


func level_done() -> bool:
	return order_index >= ORDERS


## 3 stars for 8 or more orders right at the first try, 2 for 5 or more, else 1.
func stars() -> int:
	if first_try >= 8:
		return 3
	return 2 if first_try >= 5 else 1
