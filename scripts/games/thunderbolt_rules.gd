class_name ThunderboltRules
extends RefCounted
## The rules of Zeus' Thunderbolts (Arithmetic, Grade 1), without the screen: each round shows 2–4
## different numbers, and the child picks the biggest or, in other rounds, the smallest. Which one is
## wanted changes every ROUNDS_PER_GOAL rounds. Nothing is ever taken away: a right pick scores a point
## and ends the round; a wrong pick only counts towards a hint (after HINT_AFTER wrong picks in a round
## the right number glows). The game starts with 2 numbers up to 10 and grows slowly (more numbers,
## up to 20) as the score climbs.
## Two harder games (Mode) have always two clouds, with values from 1 to SUM_MAX, and the child works
## out what is in a cloud before comparing: ONE_SUM, one cloud has a sum (3 + 4, 9 − 2) and the other a
## number; TWO_SUMS, both have sums. A sum never goes past SUM_MAX (nor below 1). The two values are
## close (CLOSE, closer once the score is SUM_CLOSER_FROM), so a guess by the look of the numbers does
## not do.

enum Goal { BIGGEST, SMALLEST }
enum Mode { NUMBERS, ONE_SUM, TWO_SUMS }

const ROUNDS_PER_GOAL := 3
const HINT_AFTER := 2
## Score from which each step starts: [score, highest count of numbers, largest number].
const STEPS := [[0, 2, 10], [3, 3, 10], [8, 4, 10], [15, 4, 20]]
const SUM_MAX := 10
const CLOSE := 4  ## the most the two values of a sum game differ by, at first
const SUM_CLOSER_FROM := 6  ## from this score, they differ by 1 to 2
const PLAIN := Vector2i.ZERO  ## (in sums: a cloud with just its number)

var mode: Mode = Mode.NUMBERS
var goal: Goal = Goal.BIGGEST
var round_index := 0  ## rounds finished so far
var score := 0
var numbers: Array[int] = []  ## this round's numbers: what each cloud is worth
var sums: Array[Vector2i] = []  ## what each cloud shows: a sum (a, b) is a + b, or a − (−b) when b < 0; PLAIN, its number
var mistakes := 0  ## wrong picks this round
var _rng: RandomNumberGenerator


func _init(rng: RandomNumberGenerator = null, p_mode: Mode = Mode.NUMBERS) -> void:
	mode = p_mode
	_rng = rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()


## Starts a round: picks its numbers (all different) for the current step, and in the sum games the
## sums that make them. Returns the numbers.
func new_round() -> Array[int]:
	goal = Goal.BIGGEST if (round_index / ROUNDS_PER_GOAL) % 2 == 0 else Goal.SMALLEST
	mistakes = 0
	if mode != Mode.NUMBERS:
		_sum_round()
		return numbers
	var step: Array = STEPS[0]
	for s: Array in STEPS:
		if score >= int(s[0]):
			step = s
	var count := _rng.randi_range(2, int(step[1]))
	var pool: Array[int] = []
	for v in range(1, int(step[2]) + 1):
		pool.append(v)
	_shuffle(pool)
	numbers = pool.slice(0, count)
	sums.clear()
	for v in numbers:
		sums.append(PLAIN)
	return numbers


## Two close values from 1 to SUM_MAX; one cloud (ONE_SUM) or both (TWO_SUMS) show a sum that makes it.
func _sum_round() -> void:
	var spread := CLOSE if score < SUM_CLOSER_FROM else 2
	var a := _rng.randi_range(1, SUM_MAX)
	var b := a
	while b == a or b < 1 or b > SUM_MAX:
		b = a + _rng.randi_range(1, spread) * (1 if _rng.randi() % 2 == 0 else -1)
	numbers = [a, b]
	var with_sum := _rng.randi_range(0, 1)  # (ONE_SUM: which cloud has the sum)
	sums.clear()
	for i in 2:
		sums.append(_sum_for(numbers[i]) if mode == Mode.TWO_SUMS or i == with_sum else PLAIN)


## A sum that makes `v`, within 1..SUM_MAX: a + b (both at least 1), or a − b.
func _sum_for(v: int) -> Vector2i:
	var plus := v == SUM_MAX or (v > 1 and _rng.randi() % 2 == 0)
	if plus:
		var a := _rng.randi_range(1, v - 1)
		return Vector2i(a, v - a)
	var a := _rng.randi_range(v + 1, SUM_MAX)
	return Vector2i(a, -(a - v))


## What cloud `i` shows: its number, or its sum ("3 + 4", "9 − 2").
func label(i: int) -> String:
	var s := sums[i] if i < sums.size() else PLAIN
	if s == PLAIN:
		return str(numbers[i])
	return "%d %s %d" % [s.x, "+" if s.y > 0 else "−", absi(s.y)]


## The number the child should pick this round.
func answer() -> int:
	return numbers.max() if goal == Goal.BIGGEST else numbers.min()


## The child picks `value`: true (a point, the round is over) if it is the answer.
func pick(value: int) -> bool:
	if value == answer():
		score += 1
		round_index += 1
		return true
	mistakes += 1
	return false


## Whether the answer should glow (the child has picked wrong a few times this round).
func hint_due() -> bool:
	return mistakes >= HINT_AFTER


## Whether the round about to start asks for the other end than the last one did.
func goal_changes_next() -> bool:
	return round_index > 0 and round_index % ROUNDS_PER_GOAL == 0


func _shuffle(a: Array[int]) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := _rng.randi_range(0, i)
		var t := a[i]
		a[i] = a[j]
		a[j] = t
