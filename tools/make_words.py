"""Writes data/words.json (the 100 picture words in Bulgarian and English, and extra words for the
wrong choices) and checks that every word has enough wrong choices: other words with the same first
letter and a length within 2 (preferably within 1). To change the words, edit WORDS and EXTRA_* and run
    python tools/make_words.py data/words.json"""
import json
import sys

WORDS = [  # id (English, the picture's file name), Bulgarian, English
    ("cat", "котка", "cat"), ("dog", "куче", "dog"), ("fish", "риба", "fish"), ("house", "къща", "house"),
    ("ball", "топка", "ball"), ("sun", "слънце", "sun"), ("moon", "луна", "moon"), ("star", "звезда", "star"),
    ("tree", "дърво", "tree"), ("flower", "цвете", "flower"), ("apple", "ябълка", "apple"), ("pear", "круша", "pear"),
    ("banana", "банан", "banana"), ("grapes", "грозде", "grapes"), ("lemon", "лимон", "lemon"),
    ("strawberry", "ягода", "strawberry"), ("carrot", "морков", "carrot"), ("tomato", "домат", "tomato"),
    ("bread", "хляб", "bread"), ("cheese", "сирене", "cheese"), ("milk", "мляко", "milk"), ("egg", "яйце", "egg"),
    ("cake", "торта", "cake"), ("cup", "чаша", "cup"), ("spoon", "лъжица", "spoon"), ("fork", "вилица", "fork"),
    ("plate", "чиния", "plate"), ("table", "маса", "table"), ("chair", "стол", "chair"), ("bed", "легло", "bed"),
    ("door", "врата", "door"), ("window", "прозорец", "window"), ("lamp", "лампа", "lamp"),
    ("clock", "часовник", "clock"), ("book", "книга", "book"), ("pencil", "молив", "pencil"),
    ("notebook", "тетрадка", "notebook"), ("bag", "чанта", "bag"), ("hat", "шапка", "hat"), ("shoe", "обувка", "shoe"),
    ("sock", "чорап", "sock"), ("dress", "рокля", "dress"), ("key", "ключ", "key"), ("car", "кола", "car"),
    ("train", "влак", "train"), ("basket", "кошница", "basket"), ("boat", "лодка", "boat"),
    ("plane", "самолет", "plane"), ("bike", "колело", "bike"), ("bus", "автобус", "bus"), ("horse", "кон", "horse"),
    ("cow", "крава", "cow"), ("sheep", "овца", "sheep"), ("goat", "коза", "goat"), ("pig", "прасе", "pig"),
    ("hen", "кокошка", "hen"), ("duck", "патица", "duck"), ("rabbit", "заек", "rabbit"), ("bear", "мечка", "bear"),
    ("fox", "лисица", "fox"), ("wolf", "вълк", "wolf"), ("lion", "лъв", "lion"), ("elephant", "слон", "elephant"),
    ("monkey", "маймуна", "monkey"), ("giraffe", "жираф", "giraffe"), ("zebra", "зебра", "zebra"),
    ("mouse", "мишка", "mouse"), ("frog", "жаба", "frog"), ("bee", "пчела", "bee"),
    ("butterfly", "пеперуда", "butterfly"), ("snail", "охлюв", "snail"), ("turtle", "костенурка", "turtle"),
    ("owl", "сова", "owl"), ("nest", "гнездо", "nest"), ("mushroom", "гъба", "mushroom"), ("leaf", "лист", "leaf"),
    ("cloud", "облак", "cloud"), ("umbrella", "чадър", "umbrella"), ("glove", "ръкавица", "glove"),
    ("balloon", "балон", "balloon"), ("doll", "кукла", "doll"), ("kite", "хвърчило", "kite"), ("drum", "барабан", "drum"),
    ("guitar", "китара", "guitar"), ("bell", "камбана", "bell"), ("candle", "свещ", "candle"), ("crown", "корона", "crown"),
    ("castle", "замък", "castle"), ("mountain", "планина", "mountain"), ("island", "остров", "island"),
    ("bridge", "мост", "bridge"), ("rocket", "ракета", "rocket"), ("robot", "робот", "robot"), ("brush", "четка", "brush"),
    ("soap", "сапун", "soap"), ("bucket", "кофа", "bucket"), ("shovel", "лопата", "shovel"), ("tooth", "зъб", "tooth"),
    ("hand", "ръка", "hand"), ("glasses", "очила", "glasses"),
]

EXTRA_BG = """
аптека ангел ананас актьор адрес айсберг атлет асансьор
баба брат буря брада бебе бутон букет бобър бадем багер басейн бадеми бисквита бутилка браслет
вода вятър ваза вана венец вечер връх врабче вагон вафла вишна вратар вълна витрина вестник
град глава гора гъска гарван гараж герой гердан гълъб гърне геврек глобус гумичка
дом дъжд деца дама дядо диня дете длан дъска джоб дюля делфин дракон джудже дупка дъга
жълт жена жилетка жълъд жътва жезъл жерав живот
зима зеле злато звук зала зурла здраве зайче зелен змей зрял звънец звяр зар
кит коте кутия кифла камък кожа каска карта картоф краставица кенгуру калинка колиба кораб конец кърпа крило кактус
компютър кондуктор катеричка календар карамфил картичка кукумявка
лале лъч лед лък лято лебед ливада лагер лавица лапа
мама море мед мида маска мрежа магаре малина метла мотор мравка медал мелница мармалад
око орех оса огън обед олио орел ограда огледало одеяло опашка овен обица отбор оазис
пиле пате път пясък пица перо пирон палто пират полицай портокал пингвин подарък пуловер писмо папагал пощальон паяк пумпал
рак роза рог река раковина ръчичка рибар рисунка раница риза рамо ремък репичка радио рафт родина ряпа
сок сол сън сено сърце сестра син сняг скала стена сладолед салата свиня свирка снимка сандък сянка сокол сърна стълба семе сламка
тиква тигър трева трон тава тиган телефон трамвай трактор тапети тромпет тенджера тебешир точка тайна
хора хълм хамак храна хижа хотел хартия хамстер химикал хладилник хармоника химикалка хоро халат храст
цар цирк цвят цена цифра цигулка царица цвекло
чай чело час чесън черешка чистачка череша чучулига чайник чекмедже човек чичо чук червей чудо
шал шум шия шише шоколад шушулка шейна шофьор шега шипка шахмат шорти
яке ястреб яхта ясен язовир ягуар яхния
""".split()

EXTRA_EN = """
ant arm angel apron acorn actor
blueberry basketball bookshelf breakfast bumblebee birthday backpack bathtub bone bird
cap can cot cub corn coat comb card cave coin clown camel cookie cherry circus cactus carpet
dot den dad day dish deer desk dice dove drink dream daisy dragon dance
ear eel elf eye envelope elevator eggplant evening eyebrow
fan fig fin foot farm fire flag feather finger forest farmer flute
gate gift girl goal gold goose grass green garden garage gorilla grandma giant
ham hay hut hip hill hook honey heart helmet hammer
igloo insect iron ink ice inside indoor invent
kid kit king kiss kiwi kick
lake lamb leg lid lip log lock lily ladder lizard light lunch
map mop mat mug mask mint magnet muffin marble mermaid magician meatball milkshake motorbike
net nut nose nail neck nursery nutshell necklace noodles napkin neighbor
oak oil one oar ox
pan pen pot pie pin pea park pool pond puppy pizza piano paper pillow parrot pepper puzzle
ring rain road rose river radio raft ruler ribbon raisin raccoon
sea sky sand seed starfish snowflake ship sofa salt snow smile snake shell spider sister summer sandwich scissors snowball sunflower spaceship skateboard
toy tap tent toad tail tiger towel teapot tunnel turkey ticket
uncle unicorn uniform umpire upstairs universe
web wig wing wall worm wheel water whale walrus wizard winter wagon
zoo zero zip zigzag zipper
""".split()


def check(lang, index, extra):
    words = [w[index] for w in WORDS]
    pool = sorted(set(words + extra))
    assert len(set(words)) == len(words), lang + ": a word twice"
    bad = []
    for w in words:
        near = [o for o in pool if o != w and o[0] == w[0] and abs(len(o) - len(w)) <= 1]
        wide = [o for o in pool if o != w and o[0] == w[0] and abs(len(o) - len(w)) <= 2]
        if len(wide) < 4:
            bad.append((w, len(wide), wide))
        elif len(near) < 4:
            print("  %s %-10s within 1: %d, within 2: %d" % (lang, w, len(near), len(wide)))
    for b in bad:
        print("  MISSING %s %s only %d: %s" % (lang, b[0], b[1], b[2]))
    return not bad


ok = check("bg", 1, EXTRA_BG) & check("en", 2, EXTRA_EN)
assert len(WORDS) == 100 and len({w[0] for w in WORDS}) == 100
if not ok:
    sys.exit(1)
data = {
    "format_version": 1,
    "_about": "The words of the reading games: each has a picture (assets/images/words/<id>.png) and its word in "
              "each language. \"extra\": more simple words per language, only used as wrong choices (the same first "
              "letter and about the same length as the word asked for).",
    "words": [{"id": i, "bg": bg, "en": en} for i, bg, en in WORDS],
    "extra": {"bg": sorted(set(EXTRA_BG) - {w[1] for w in WORDS}), "en": sorted(set(EXTRA_EN) - {w[2] for w in WORDS})},
}
out = sys.argv[1] if len(sys.argv) > 1 else "words.json"
# one word to a line, so the list is easy to read and change
lines = ["{", ' "format_version": 1,', ' "_about": %s,' % json.dumps(data["_about"], ensure_ascii=False), ' "words": [']
for k, w in enumerate(data["words"]):
    lines.append("  %s%s" % (json.dumps(w, ensure_ascii=False), "," if k < len(data["words"]) - 1 else ""))
lines += [" ],", ' "extra": {']
for k, lang in enumerate(["bg", "en"]):
    lines.append('  "%s": %s%s' % (lang, json.dumps(data["extra"][lang], ensure_ascii=False), "," if k == 0 else ""))
lines += [" }", "}"]
text = "\n".join(lines)
json.loads(text)  # (still valid JSON)
open(out, "w", encoding="utf-8", newline="\n").write(text + "\n")
print("written", out, len(data["extra"]["bg"]), "+", len(data["extra"]["en"]), "extra words")
