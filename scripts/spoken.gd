class_name Spoken
extends RefCounted
## Turns a text as it is shown into the text to read aloud: numbers and the signs + − = become words,
## because a device's voice can read them badly ("3 + 4 = 7" -> "три плюс четири е равно на седем"). Only
## App.say uses this, so what is shown on the screen keeps its digits and signs.
## A hyphen is a minus only between numbers or spaces: "по-малко" stays a word. Bulgarian's number 1 is
## "едно" when counting, and "една" with `feminine` (said of olives). A number over 999 stays in digits.

const NUMBERS := {
	"bg": {
		"ones": ["нула", "едно", "две", "три", "четири", "пет", "шест", "седем", "осем", "девет", "десет",
			"единадесет", "дванадесет", "тринадесет", "четиринадесет", "петнадесет", "шестнадесет",
			"седемнадесет", "осемнадесет", "деветнадесет"],
		"tens": ["двадесет", "тридесет", "четиридесет", "петдесет", "шестдесет", "седемдесет", "осемдесет", "деветдесет"],
		"hundreds": ["сто", "двеста", "триста", "четиристотин", "петстотин", "шестстотин", "седемстотин", "осемстотин", "деветстотин"],
		"plus": "плюс", "minus": "минус", "equals": "е равно на",
	},
	"en": {
		"ones": ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
			"eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"],
		"tens": ["twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"],
		"hundreds": ["one hundred", "two hundred", "three hundred", "four hundred", "five hundred", "six hundred",
			"seven hundred", "eight hundred", "nine hundred"],
		"plus": "plus", "minus": "minus", "equals": "equals",
	},
}
const ONE_FEMININE := "една"
const MAX_NUMBER := 999

static var _digits: RegEx
static var _hyphen_minus: RegEx
static var _space_before_mark: RegEx
static var _spaces: RegEx


## `shown` as it should be read aloud in `language` (a language without a table: unchanged).
static func text(shown: String, language: String, feminine: bool = false) -> String:
	if not NUMBERS.has(language):
		return shown
	_prepare()
	var table: Dictionary = NUMBERS[language]
	var out := shown.replace("‑", "-")  # (the non-breaking hyphen is for the lines on the screen only)
	out = _hyphen_minus.sub(out, "−", true)
	out = out.replace("−", " %s " % table["minus"]).replace("+", " %s " % table["plus"]).replace("=", " %s " % table["equals"])
	var found := _digits.search_all(out)
	found.reverse()  # (from the end, so the places found stay right)
	for m in found:
		var n := int(m.get_string())
		if n <= MAX_NUMBER:
			out = out.substr(0, m.get_start()) + number(n, language, feminine) + out.substr(m.get_end())
	out = _spaces.sub(out, " ", true)
	return _space_before_mark.sub(out, "$1", true).strip_edges()


## `n` (0 .. 999) in words.
static func number(n: int, language: String, feminine: bool = false) -> String:
	var table: Dictionary = NUMBERS[language]
	var ones: Array = table["ones"]
	if n == 1 and feminine and language == "bg":
		return ONE_FEMININE
	if n < ones.size():
		return ones[n]
	var tens: Array = table["tens"]
	if n < 100:
		var ten: String = tens[n / 10 - 2]
		if n % 10 == 0:
			return ten
		var unit := number(n % 10, language, feminine)
		return "%s и %s" % [ten, unit] if language == "bg" else "%s-%s" % [ten, unit]
	var hundreds: Array = table["hundreds"]
	var hundred: String = hundreds[n / 100 - 1]
	var rest := n % 100
	if rest == 0:
		return hundred
	var tail := number(rest, language, feminine)
	if language == "en":
		return "%s and %s" % [hundred, tail]
	# Bulgarian: "сто и пет", "сто и двадесет", but "сто двадесет и три" (one "и" only).
	return "%s и %s" % [hundred, tail] if rest < 20 or rest % 10 == 0 else "%s %s" % [hundred, tail]


static func _prepare() -> void:
	if _digits != null:
		return
	_digits = RegEx.create_from_string("[0-9]+")
	_hyphen_minus = RegEx.create_from_string("(?<=[0-9\\s])-(?=[0-9\\s])")
	_space_before_mark = RegEx.create_from_string("\\s+([,.!?;:])")
	_spaces = RegEx.create_from_string("[ ]{2,}")
