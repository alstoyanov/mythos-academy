class_name ThunderboltRules
extends RefCounted
## The rules of Zeus' Thunderbolts (Arithmetic, Grade 1), without the screen: each round shows 2–4
## different numbers, and the child picks the biggest or, in other rounds, the smallest. Which one is
## wanted changes every ROUNDS_PER_GOAL rounds. Nothing is ever taken away: a right pick scores a point
## and ends the round; a wrong pick only counts towards a hint (after HINT_AFTER wrong picks in a round
## the right number glows). The game starts with 2 numbers up to 10 and grows slowly (more numbers,
## up to 20) as the score climbs.

enum Goal { BIGGEST, SMALLEST }

const ROUNDS_PER_GOAL := 3
const HINT_AFTER := 2
## Score from which each step starts: [score, highest count of numbers, largest number].
const STEPS := [[0, 2, 10], [3, 3, 10], [8, 4, 10], [15, 4, 20]]

var goal: Goal = Goal.BIGGEST
var round_index := 0  ## rounds finished so far
var score := 0
var numbers: Array[int] = []  ## this round's numbers
var mistakes := 0  ## wrong picks this round
var _rng: RandomNumberGenerator


func _init(rng: RandomNumberGenerator = null) -> void:
	_rng = rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()


## Starts a round: picks its numbers (all different) for the current step. Returns them.
func new_round() -> Array[int]:
	goal = Goal.BIGGEST if (round_index / ROUNDS_PER_GOAL) % 2 == 0 else Goal.SMALLEST
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
	mistakes = 0
	return numbers


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
