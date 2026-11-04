class_name BalloonRules
extends RefCounted
## The rules of Aeolus' Balloons (Arithmetic, Grade 1), without the screen: a row of balloons, each with
## a different number from 1 to 9 (and a size to match), that the child puts in order by swapping two
## neighbours at a time (bubble sort, played). A level is one puzzle:
##   level 1  five balloons, from the smallest to the biggest
##   level 2  eight balloons, from the smallest to the biggest
##   level 3  eight balloons, from the biggest to the smallest
## Any two neighbours can be swapped, right or wrong, and a swap can be undone; nothing is taken away.
## Each swap of a pair that is in the wrong order puts the row one step closer, so the fewest swaps
## possible (the "par") is the number of wrong pairs at the start (the inversions). Stars: 3 for at
## most PAR_SLACK swaps over the par, 2 for at most twice the par, else 1 (always at least one).

enum Direction { UP, DOWN }  ## UP: the smallest first

const MIN_NUMBER := 1
const MAX_NUMBER := 9
## Per level (0 .. 2): [balloons, direction, fewest wrong pairs at the start, most wrong pairs].
const LEVELS := [
	[5, Direction.UP, 3, 6],
	[8, Direction.UP, 8, 15],
	[8, Direction.DOWN, 8, 15],
]
const PAR_SLACK := 2

var level := 0
var count := 5
var direction: Direction = Direction.UP
var values: Array[int] = []  ## the numbers, left to right
var start_values: Array[int] = []  ## how this puzzle began (Restart)
var par := 0  ## the fewest swaps that put it in order
var swaps := 0  ## swaps made, undone ones included
var _history: Array[int] = []  ## the left place of each swap made and not undone
var _rng: RandomNumberGenerator


func _init(p_level: int = 0, rng: RandomNumberGenerator = null) -> void:
	level = clampi(p_level, 0, LEVELS.size() - 1)
	count = LEVELS[level][0]
	direction = LEVELS[level][1]
	_rng = rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()
	new_puzzle()


## A new row: `count` different numbers, not in order, with a fair number of wrong pairs.
func new_puzzle() -> void:
	var low: int = LEVELS[level][2]
	var high: int = LEVELS[level][3]
	for attempt in 500:
		var pool: Array[int] = []
		for n in range(MIN_NUMBER, MAX_NUMBER + 1):
			pool.append(n)
		var picked: Array[int] = []
		while picked.size() < count:
			picked.append(pool.pop_at(_rng.randi_range(0, pool.size() - 1)))
		var wrong := _wrong_pairs(picked)
		if wrong >= low and wrong <= high:
			values = picked
			break
	if values.is_empty() or _wrong_pairs(values) < low:  # (not reached in practice: a fixed fallback)
		values = [3, 1, 2, 5, 4, 7, 6, 8] if count == 8 else [2, 1, 4, 3, 5]
		if direction == Direction.DOWN:
			values.reverse()
	start_values = values.duplicate()
	_begin()


## The same row again from the start.
func restart() -> void:
	values = start_values.duplicate()
	_begin()


func _begin() -> void:
	swaps = 0
	_history = []
	par = _wrong_pairs(values)


## Pairs (not only neighbours) in the wrong order for the level's direction.
func _wrong_pairs(row: Array[int]) -> int:
	var n := 0
	for i in row.size():
		for j in range(i + 1, row.size()):
			if _out_of_order(row[i], row[j]):
				n += 1
	return n


func _out_of_order(left: int, right: int) -> bool:
	return left > right if direction == Direction.UP else left < right


func wrong_pairs() -> int:
	return _wrong_pairs(values)


func is_sorted() -> bool:
	return wrong_pairs() == 0


## Swaps the balloons at `i` and `i + 1`; false if there are no such places.
func swap(i: int) -> bool:
	if i < 0 or i + 1 >= values.size():
		return false
	_exchange(i)
	_history.append(i)
	swaps += 1
	return true


func can_undo() -> bool:
	return not _history.is_empty()


## Takes back the last swap and returns its left place (-1 if there is none). `swaps` keeps counting.
func undo() -> int:
	if _history.is_empty():
		return -1
	var i: int = _history.pop_back()
	_exchange(i)
	return i


func _exchange(i: int) -> void:
	var t := values[i]
	values[i] = values[i + 1]
	values[i + 1] = t


## The left place of a neighbouring pair in the wrong order (the first one), or -1 if it is in order.
## Swapping it always brings the row a step closer.
func hint() -> int:
	for i in values.size() - 1:
		if _out_of_order(values[i], values[i + 1]):
			return i
	return -1


func stars() -> int:
	if swaps <= par + PAR_SLACK:
		return 3
	return 2 if swaps <= par * 2 else 1
