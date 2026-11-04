class_name LeapRules
extends RefCounted
## The rules of Hercules' Leaps (Arithmetic, Grade 1), without the screen. Hercules stands on the cliff
## numbered `here`; across the chasm is the cliff numbered `there`. The child chooses a sign and a one
## digit number that make the sum true (here + 4 = there), and he leaps. The cliff he lands on is the next
## `here`. A level is JUMPS leaps, with its numbers between the level's lowest and highest (LEVELS).
## Nothing is ever taken away: a wrong answer only counts towards the hint (after HINT_AFTER in a leap the
## answer glows) and towards the stars, which count the leaps right at the first try (always at least one).

enum Result { RIGHT, WRONG_SIGN, WRONG_AMOUNT }

const JUMPS := 10  ## leaps in a level
const HINT_AFTER := 2
const MAX_LEAP := 9  ## the answer is always a single digit
const LEVELS := [[1, 5], [1, 10], [10, 20], [1, 20]]  ## the lowest and highest number, by level (0 .. 3)

var level := 0
var low := 1
var high := 5
var here := 1  ## the number under Hercules
var there := 1  ## the number across the chasm
var jumps_done := 0
var first_try := 0  ## leaps right at the first try
var mistakes := 0  ## wrong answers in this leap
var _previous := -1  ## where he came from (he is not sent straight back)
var _rng: RandomNumberGenerator


func _init(p_level: int = 0, rng: RandomNumberGenerator = null) -> void:
	level = clampi(p_level, 0, LEVELS.size() - 1)
	low = LEVELS[level][0]
	high = LEVELS[level][1]
	_rng = rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		_rng.randomize()
	here = low
	_new_target()


## A different number within a single digit's reach, not the one he has just come from.
func _new_target() -> void:
	var options: Array[int] = []
	for n in range(low, high + 1):
		if n != here and n != _previous and absi(n - here) <= MAX_LEAP:
			options.append(n)
	there = options[_rng.randi_range(0, options.size() - 1)]


## 1 if the leap needs "+", -1 if it needs "−".
func needed_sign() -> int:
	return 1 if there > here else -1


func needed_amount() -> int:
	return absi(there - here)


## What `here`, the sign and the number make (for "1 + 3 = 4"); only asked of a sign that is right, so a
## child of this age never meets a number below zero.
func result_of(sign_chosen: int, amount: int) -> int:
	return here + sign_chosen * amount


## The child answers a sign (1 or -1) and a number. RIGHT: the leap can start, and `land` ends it.
func answer(sign_chosen: int, amount: int) -> Result:
	if sign_chosen != needed_sign():
		mistakes += 1
		return Result.WRONG_SIGN
	if amount != needed_amount():
		mistakes += 1
		return Result.WRONG_AMOUNT
	jumps_done += 1
	if mistakes == 0:
		first_try += 1
	return Result.RIGHT


## Hercules has landed: the cliff is the new `here`, and (unless the level is done) a new `there`.
func land() -> void:
	_previous = here
	here = there
	mistakes = 0
	if not level_done():
		_new_target()


func hint_due() -> bool:
	return mistakes >= HINT_AFTER


func level_done() -> bool:
	return jumps_done >= JUMPS


## 3 stars for 8 or more leaps right at the first try, 2 for 5 or more, else 1.
func stars() -> int:
	if first_try >= 8:
		return 3
	return 2 if first_try >= 5 else 1
