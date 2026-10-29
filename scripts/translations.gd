class_name Translations
extends RefCounted
## The game's languages. The text in the code and in data/ is English and is the key; the other
## languages have a table here, made into a Godot Translation at start (install). Bulgarian is the
## game's first language; English is the second.
## To add a language: a table like BG, an entry in LANGUAGES, and the table in TABLES.
## "най‑голямото" and "най‑малкото" are written with a non-breaking hyphen (U+2011), so a line never breaks
## inside them.

const DEFAULT := "bg"
## [code, name in that language], in the order Settings lists them.
const LANGUAGES := [["bg", "Български"], ["en", "English"]]

const BG := {
	# the menus
	"Mythos Academy": "Академия Митос",
	"Learn and play with the heroes of myth": "Учи и играй с героите на митовете",
	"Play": "Играй",
	"Settings": "Настройки",
	"Quit": "Изход",
	"Music": "Музика",
	"Sounds": "Звуци",
	"Read aloud": "Четене на глас",
	"Full screen": "Цял екран",
	"Language": "Език",
	"Done": "Готово",
	"Back": "Назад",
	"Choose a land to explore": "Избери земя, която да разгледаш",
	"Grade %d": "%d клас",
	"Grade %d · soon": "%d клас · скоро",
	"%s opens in Grade %d. Coming soon!": "%s се отваря в %d клас. Очаквайте скоро!",
	"Grade %d · Choose a place to learn": "%d клас · Избери къде да учиш",
	"Coming soon": "Очаквайте скоро",
	"Coming later": "Очаквайте по-късно",
	"%s is coming soon!": "„%s“ идва скоро!",
	# the mythologies (data/mythologies.json)
	"Ancient Greece": "Древна Гърция",
	"Ancient Egypt": "Древен Египет",
	"The Norse Lands": "Северните земи",
	"Mesopotamia": "Месопотамия",
	"Ancient India": "Древна Индия",
	"Ancient China": "Древен Китай",
	# Ancient Greece (data/realms/greek.json)
	"Glaux, the little owl of Athena": "Глаукс, малката сова на Атина",
	"Arithmetic": "Математика",
	"Geometry": "Геометрия",
	"Geography": "География",
	"The Agora of Numbers": "Агората на числата",
	"The market of Athens": "Пазарът на Атина",
	"The Temple Builders": "Строителите на храмове",
	"Olympia": "Олимпия",
	"The Islands of Odysseus": "Островите на Одисей",
	"The Aegean Sea": "Егейско море",
	"The Grove of the Muses": "Горичката на музите",
	"Mount Helicon": "Планината Хеликон",
	"Zeus' Thunderbolts": "Мълниите на Зевс",
	"Comparing numbers: the biggest and the smallest": "Сравняване на числа: най‑голямото и най‑малкото",
	"Help Zeus strike the cloud with the biggest number, or the smallest!":
		"Помогни на Зевс да удари облака с най‑голямото или с най‑малкото число!",
	"Olive Harvest": "Беритба на маслини",
	"Counting, adding and taking away within 20": "Броене, събиране и изваждане до 20",
	"Fill Athena's baskets with exactly the right number of olives.":
		"Напълни кошниците на Атина с точно толкова маслини, колкото трябва.",
	"Temple Builder": "Строителят на храма",
	"Naming and matching flat shapes": "Разпознаване на геометрични фигури",
	"Help the builders finish a temple with the right shaped stones.":
		"Помогни на строителите да довършат храма с камъни с точната форма.",
	"Odysseus' Voyage": "Пътешествието на Одисей",
	"Left, right, up and down; land and sea": "Ляво, дясно, горе и долу; суша и море",
	"Steer Odysseus' ship home, one direction at a time.":
		"Насочвай кораба на Одисей към дома, посока по посока.",
	"The Muses' Letters": "Буквите на музите",
	"Letter sounds and first letters of words": "Звуковете на буквите и първата буква на думите",
	"The Muses lost their letters: find the letter each picture starts with.":
		"Музите изгубиха буквите си: намери с коя буква започва всяка картинка.",
	# Zeus' Thunderbolts
	"Zeus needs your help! Find the BIGGEST number!": "Зевс има нужда от теб! Намери НАЙ-ГОЛЯМОТО число!",
	"Find the BIGGEST number!": "Намери НАЙ-ГОЛЯМОТО число!",
	"Now find the SMALLEST number!": "Сега намери НАЙ-МАЛКОТО число!",
	"Hit the BIGGEST number!": "Удари НАЙ-ГОЛЯМОТО число!",
	"Hit the SMALLEST number!": "Удари НАЙ-МАЛКОТО число!",
	"Almost! Look for the biggest number.": "Почти! Търси най‑голямото число.",
	"Almost! Look for the smallest number.": "Почти! Търси най‑малкото число.",
	"Great!": "Браво!",
	"Well done!": "Много добре!",
	"Yes, that's it!": "Да, точно така!",
	"Super!": "Супер!",
	"Brilliant!": "Чудесно!",
	"You got it!": "Позна!",
	"%d thunderbolts! You are amazing!": "%d мълнии! Страхотно се справяш!",
	"How long do you want to play?": "Колко време искаш да играеш?",
	"1 minute": "1 минута",
	"2 minutes": "2 минути",
	"3 minutes": "3 минути",
	"Best: %d": "Рекорд: %d",
	"Time's up!": "Времето изтече!",
	"Score: %d": "Точки: %d",
	"New best!": "Нов рекорд!",
	"Play again": "Играй отново",
	"Change time": "Друго време",
}

const TABLES := {"bg": BG}


## Makes the tables into Godot translations (once, at start).
static func install() -> void:
	for code: String in TABLES:
		var t := Translation.new()
		t.locale = code
		var table: Dictionary = TABLES[code]
		for key: String in table:
			t.add_message(key, table[key])
		TranslationServer.add_translation(t)


static func has_language(code: String) -> bool:
	for entry in LANGUAGES:
		if entry[0] == code:
			return true
	return false
