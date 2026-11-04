extends Node
## What is read aloud has its numbers and signs in words (Spoken), and no text of the game keeps a digit or
## a sign when it is read; the text shown keeps them.
##   godot --headless --path . res://tests/spoken_test.tscn
## Exits with 0 on success, 1 on failure.

var _failures := 0


func _ready() -> void:
	_test_numbers()
	_test_sentences()
	_test_every_text()
	_test_only_app_speaks()
	print("FAILED: %d" % _failures if _failures > 0 else "ALL PASSED")
	get_tree().quit(1 if _failures > 0 else 0)


func _test_numbers() -> void:
	var bg := {
		0: "нула", 1: "едно", 2: "две", 5: "пет", 9: "девет", 10: "десет", 11: "единадесет", 12: "дванадесет",
		19: "деветнадесет", 20: "двадесет", 21: "двадесет и едно", 23: "двадесет и три", 40: "четиридесет",
		99: "деветдесет и девет", 100: "сто", 105: "сто и пет", 115: "сто и петнадесет", 120: "сто и двадесет",
		123: "сто двадесет и три", 200: "двеста", 999: "деветстотин деветдесет и девет",
	}
	for n: int in bg:
		_same(Spoken.number(n, "bg"), bg[n])
	var en := {
		0: "zero", 5: "five", 13: "thirteen", 20: "twenty", 34: "thirty-four", 100: "one hundred",
		107: "one hundred and seven", 342: "three hundred and forty-two",
	}
	for n: int in en:
		_same(Spoken.number(n, "en"), en[n])
	_same(Spoken.number(1, "bg", true), "една")
	_same(Spoken.number(21, "bg", true), "двадесет и една")
	_same(Spoken.number(11, "bg", true), "единадесет")
	_same(Spoken.number(1, "en", true), "one")


func _test_sentences() -> void:
	var bg := {
		"Избери + или −, а после число, за да стигне Херкулес до 5.": "Избери плюс или минус, а после число, за да стигне Херкулес до пет.",
		"Сега избери + или −.": "Сега избери плюс или минус.",
		"1 + 3 = 4. Трябва ни 5.": "едно плюс три е равно на четири. Трябва ни пет.",
		"5 − 2 = 3.": "пет минус две е равно на три.",
		"5 - 2 = 3.": "пет минус две е равно на три.",
		"5-2=3": "пет минус две е равно на три",
		"9 е твърде голямо. Опитай с по-малко число.": "девет е твърде голямо. Опитай с по-малко число.",
		"Удари най‑голямото число!": "Удари най-голямото число!",
		"10 маслини, моля!": "десет маслини, моля!",
		"Точки: 23 Рекорд: 40": "Точки: двадесет и три Рекорд: четиридесет",
		"Браво! 3 плюс 4 е равно на 7!": "Браво! три плюс четири е равно на седем!",
		"Без числа.": "Без числа.",
	}
	for shown: String in bg:
		_same(Spoken.text(shown, "bg"), bg[shown])
	_same(Spoken.text("Козата изяде 1. Колко останаха?", "bg", true), "Козата изяде една. Колко останаха?")
	_same(Spoken.text("Имаме 2. Търговецът иска 1.", "bg", true), "Имаме две. Търговецът иска една.")
	_same(Spoken.text("1 + 3 = 4. We need 5.", "en"), "one plus three equals four. We need five.")
	_same(Spoken.text("Now choose + or −.", "en"), "Now choose plus or minus.")
	_same(Spoken.text("Точки: 1000", "bg"), "Точки: 1000")  # (too big: stays in digits)
	_same(Spoken.text("1 + 1", "xx"), "1 + 1")  # (a language without a table)


## Every text of the game, with numbers put in, has neither a digit nor a sign left when it is read.
func _test_every_text() -> void:
	var left := RegEx.create_from_string("[0-9+−=‑]")
	for key: String in Translations.BG:
		for pair in [[Translations.BG[key], "bg"], [key, "en"]]:
			var shown: String = pair[0]
			shown = shown.replace("%d", "7").replace("%s", "3 + 4")
			var read := Spoken.text(shown, pair[1])
			_check(left.search(read) == null, "\"%s\" is read as \"%s\"" % [shown, read])


## The device's voice is called in one place only, which goes through Spoken.
func _test_only_app_speaks() -> void:
	for file in _scripts("res://scripts"):
		var source := FileAccess.get_file_as_string(file)
		if source.contains("tts_speak("):
			_check(file.ends_with("/app.gd"), "%s speaks past App.say" % file)
	_check(FileAccess.get_file_as_string("res://scripts/app.gd").contains("tts_speak(Spoken.text("), "App.say reads through Spoken")


func _scripts(dir: String) -> Array[String]:
	var out: Array[String] = []
	for f in DirAccess.get_files_at(dir):
		if f.ends_with(".gd"):
			out.append(dir.path_join(f))
	for d in DirAccess.get_directories_at(dir):
		out.append_array(_scripts(dir.path_join(d)))
	return out


func _same(got: String, expected: String) -> void:
	_check(got == expected, "got \"%s\", expected \"%s\"" % [got, expected])


func _check(ok: bool, what: String) -> void:
	if not ok:
		_failures += 1
		print("  FAIL: " + what)
