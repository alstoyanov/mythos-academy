"""Writes assets/prompts/E_MUSES_WORDS.md: the image prompts of The Muses' Words (the 100 word pictures on
7 sheets, the Muse, the background, the game card), from data/words.json and SHEETS below (what each
picture shows). After changing the words: python tools/make_prompts_e.py ."""
import os
import sys

os.chdir(sys.argv[1])

STYLE_SHEET = ("Every picture in the same style: hand-painted children's storybook illustration, soft gouache and "
               "watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft "
               "darker outline all around it (so that white things stand out from the white page), bright but not neon "
               "colours, soft daylight from the top left; each thing alone, whole, in its most familiar view, with no "
               "scenery and no ground shadow. No text, no letters, no numbers, no labels, no grid lines, no borders, "
               "no frames, no watermark, no signature.")
NEG_SHEET = ("text, letters, words, numbers, labels, captions, grid lines, borders, frames, boxes, overlapping "
             "pictures, touching pictures, cut-off pictures, extra objects, scenery, background, ground shadows, "
             "watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, angry faces, weapons, blood, "
             "harsh shadows, neon colours, blurry")
STYLE_FIG = ("Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's "
             "storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, "
             "a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the "
             "top left. No text, no letters, no numbers, no watermark, no signature.")
STYLE_SCENE = ("Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and "
               "friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon "
               "colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white "
               "marble, terracotta). No text, no letters, no numbers, no watermark, no signature.")
NEG = ("text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, "
       "violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry")

# (title, [(id, what to draw)])
SHEETS = [
    ("Farm animals and pets", [
        ("cat", "a cute orange tabby cat sitting"), ("dog", "a friendly brown puppy dog sitting"),
        ("fish", "a round orange fish swimming sideways"), ("horse", "a brown horse standing, side view"),
        ("cow", "a black and white cow standing, side view"), ("sheep", "a fluffy white sheep with a grey face"),
        ("goat", "a little white goat with small horns, side view"), ("pig", "a pink pig standing, side view"),
        ("hen", "a brown hen with a red comb"), ("duck", "a white duck with an orange beak, side view"),
        ("rabbit", "a grey rabbit with long ears, sitting"), ("mouse", "a small grey mouse with round ears and a long tail"),
        ("frog", "a green frog sitting"), ("owl", "a brown owl with big round eyes, sitting"),
        ("bee", "a yellow and black striped bee with small wings"), ("snail", "a snail with a brown spiral shell"),
    ]),
    ("Wild animals and nature", [
        ("bear", "a big brown bear standing on four legs, side view"), ("fox", "an orange fox with a white-tipped tail, side view"),
        ("wolf", "a grey wolf standing, side view, friendly"), ("lion", "a lion with a golden mane, sitting, friendly"),
        ("elephant", "a grey elephant with a long trunk, side view"), ("monkey", "a brown monkey sitting, waving"),
        ("giraffe", "a whole giraffe with a long neck and brown patches, side view"), ("zebra", "a black and white striped zebra, side view"),
        ("butterfly", "a butterfly with blue and orange wings spread open"), ("turtle", "a green turtle with a patterned shell, side view"),
        ("nest", "an empty round bird's nest made of twigs, with no eggs and no bird"),
        ("mushroom", "a mushroom with a red cap and white spots"), ("leaf", "one single green leaf"),
        ("flower", "one red flower with a green stem and two leaves"), ("tree", "a whole round green tree with a brown trunk"),
        ("cloud", "one fluffy white cloud with soft blue-grey shading"),
    ]),
    ("Food and tableware", [
        ("apple", "a shiny red apple with a leaf"), ("pear", "a green-yellow pear with a stem"),
        ("banana", "one yellow banana"), ("grapes", "a bunch of purple grapes with a leaf"),
        ("lemon", "a yellow lemon"), ("strawberry", "a red strawberry with green leaves on top"),
        ("carrot", "an orange carrot with green leaves"), ("tomato", "a round red tomato with a green stem"),
        ("bread", "a round loaf of golden-brown bread"), ("cheese", "a wedge of yellow cheese with holes"),
        ("milk", "a glass bottle full of white milk with a blue cap"), ("egg", "one whole white egg, standing"),
        ("cake", "a round birthday cake with pink icing and one candle"), ("cup", "a blue cup with a handle, empty"),
        ("spoon", "one silver spoon"), ("fork", "one silver fork"),
    ]),
    ("Home", [
        ("plate", "an empty round white plate with a blue rim, seen slightly from above"),
        ("table", "a wooden table with four legs"), ("chair", "a wooden chair, side view"),
        ("bed", "a small bed with a blue blanket and a white pillow"), ("door", "a closed wooden door with a round handle"),
        ("window", "a window with a wooden frame, four glass panes and open curtains"), ("lamp", "a table lamp with a yellow lampshade"),
        ("clock", "a round wall clock with two hands and small dots instead of numbers"),
        ("candle", "a white candle with a small flame"), ("soap", "a pink bar of soap with a few bubbles"),
        ("brush", "a toothbrush with blue handle and white bristles"),
        ("bucket", "a red plastic bucket with a handle"), ("shovel", "a small garden spade with a wooden handle"),
        ("basket", "an empty woven basket with a handle"), ("key", "one golden key"),
        ("house", "a small house with a red roof, a door and two windows"),
    ]),
    ("School, clothes and toys", [
        ("book", "a closed book with a plain green cover"), ("pencil", "a yellow pencil with a pink eraser"),
        ("notebook", "an open notebook with blank lined pages and a spiral"), ("bag", "a red school backpack"),
        ("hat", "a straw sun hat with a ribbon"), ("shoe", "one red children's shoe"),
        ("sock", "one striped sock"), ("dress", "a yellow girl's dress"),
        ("glove", "one blue woollen mitten"), ("glasses", "a pair of round glasses"),
        ("umbrella", "an open red umbrella"), ("ball", "a red and white ball"),
        ("balloon", "one blue balloon on a string"), ("doll", "a rag doll with yellow hair and a blue dress"),
        ("kite", "a diamond-shaped kite with a tail of bows"), ("drum", "a small red drum with two drumsticks"),
    ]),
    ("Music, travel and places", [
        ("guitar", "an acoustic guitar"), ("bell", "a golden bell"),
        ("robot", "a friendly toy robot with a square head"), ("car", "a small red car, side view"),
        ("train", "a green steam train engine, side view"), ("boat", "a small wooden rowing boat with a white sail, side view"),
        ("plane", "a small white aeroplane with blue stripes, side view"), ("bike", "a children's bicycle, side view"),
        ("bus", "a yellow bus, side view"), ("rocket", "a white and red rocket pointing up"),
        ("bridge", "a small stone arch bridge"), ("castle", "a small castle with towers and flags"),
        ("crown", "a golden crown with red jewels"), ("mountain", "one tall mountain with a snowy peak"),
        ("island", "a small round island with one palm tree, a little patch of blue sea around it"),
        ("sun", "a round yellow sun with short rays, no face"),
    ]),
    ("Moon, star, tooth and hand", [
        ("moon", "a yellow crescent moon, no face"), ("star", "one yellow five-pointed star"),
        ("tooth", "one shiny white tooth, no face"), ("hand", "an open waving child's hand, palm to the front"),
    ]),
]


HOLES = {"basket"}  ## cut with "+": the white inside the handle goes too


def sheet_section(k, title, items):
    n = len(items)
    cols = 4 if n > 4 else 2
    rows = (n + cols - 1) // cols
    names = ",".join(i + ("+" if i in HOLES else "") for i, _ in items)
    order = []  # (in words, not numbers: a number in the prompt may end up drawn on the sheet)
    for r in range(rows):
        row = [what for _, what in items[r * cols:(r + 1) * cols]]
        order.append("the %s row, from left to right: %s and %s" % (["first", "second", "third", "fourth"][r], "; ".join(row[:-1]), row[-1]))
    prompt = ("A sheet of %d separate small pictures for a children's picture dictionary, in a neat grid of %d rows and "
              "%d columns on a plain pure white background. Each picture shows one single thing, whole, centred in its "
              "own cell, with wide empty white space between the pictures; no picture touches, overlaps or is cut off "
              "by another or by the edge. In this order: %s. %s"
              % (n, rows, cols, ". Then ".join(order), STYLE_SHEET))
    files = ", ".join("`%s`" % i for i, _ in items)
    return """### E.%d Word pictures, sheet %d of 7 — %s (%d)

Cut into `assets/images/words/`: %s — each 384 × 384, PNG, transparent background. The sheet: 1:1, at least 2048 × 2048, PNG or JPG (another shape works too).

**Prompt:**

```text
%s
```

**Negative prompt:**

```text
%s
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 %s
```
""" % (k, k, title, n, files, prompt, NEG_SHEET, names)


MUSE = ("Calliope, the kind young Muse of words and stories of Greek myth, drawn for young children: a gentle round "
        "face with rosy cheeks and warm brown eyes, long wavy dark-blonde hair, a crown of green laurel leaves, a soft "
        "pink dress (chiton) with a thin golden belt, holding a rolled cream scroll. Shown from the waist up, facing "
        "the viewer, centred, the top of her crown close to the top edge of the picture, the same size and framing in "
        "every pose. Children's storybook character design, warm and gentle.")
POSES = [
    ("E.8", "calm", "muse_neutral", "A calm, warm smile, the scroll held in both hands in front of her, as if waiting to hear the child read."),
    ("E.9", "happy", "muse_happy", "Beaming with joy, eyes crinkled with laughter, holding the scroll up high in one hand and the other hand open in delight, a few tiny golden sparkles around her."),
    ("E.10", "thinking", "muse_thinking", "Thinking kindly, head a little to one side, one finger on her chin, the scroll under her other arm, a gentle encouraging smile."),
]

parts = ["""# Image prompts — Part E: The Muses' Words

The reading game of the Language area (specification §5.4a): Calliope shows a picture and five words, or a word and four pictures. It needs 100 word pictures, made as 7 sheets of many pictures that `tools/prepare_art.py sheet` cuts apart, and the Muse, the background and the game card. The game is built and uses each picture as soon as it exists; until then it shows a stand-in (a word picture as a pale tile with its name). **State:** done: all of them are in the game (2026-10-31; the generated sheets and pictures are kept in `Godot/assets/images/mythos-academy/words/`).

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** (and, if the tool has a field for it, the **Negative prompt**) as it is: nothing needs to be filled in.
- Every prompt already contains the shared style (hand-painted storybook, gouache and watercolour, warm Greek palette), so all pictures match.
- **The sheets (E.1–E.7):** each makes 16 pictures at once (the last one 4). Make the sheet as big as the tool allows; a square sheet suits a 4 × 4 grid best, but any shape works, because the cutter finds each picture by the white space around it, not by a fixed grid. It names them in reading order (rows from the top, each from the left), so check that the generator kept the order of the prompt; if it did not, change the order of the names in the **Cut it** line (or send me the sheets and I sort them). If it drew more or fewer pictures than asked, or two that touch, the cutter saves nothing and lists what it found: make that sheet again, or cut by hand.
- The pictures must show the thing a first grader names first, with nothing written on them: the game is about reading, and a letter in a picture would give the word away. The words themselves are in `data/words.json` (in Bulgarian and English; `tools/make_words.py` makes it).
- White things (the sheep, the egg, the cloud, the milk, the tooth, the plate) need the soft outline the prompts ask for, or the cutter cannot tell them from the page.
- Look for extras the generator adds: on sheet 7 it drew a small star beside the moon, which would make the moon and the star look alike in "Find the picture"; it was painted out before cutting (the cutter lists it as a fifth picture).

The 100 words, by sheet (picture name — Bulgarian / English):
"""]
import json
words = {w["id"]: w for w in json.load(open("data/words.json", encoding="utf-8"))["words"]}
for k, (title, items) in enumerate(SHEETS, 1):
    parts.append("- **Sheet %d — %s:** %s" % (k, title, ", ".join("%s (%s)" % (i, words[i]["bg"]) for i, _ in items)))
ids = [i for _, items in SHEETS for i, _ in items]
assert sorted(ids) == sorted(words), set(words) ^ set(ids)
parts.append("""
How to turn the other pictures into the game's files (`python tools/prepare_art.py KIND SOURCE TARGET …`):

| Picture | Step |
|---|---|
| E.8–E.10 Calliope | `figure … 900 768 SCALE CX - - TOP`, SCALE and CX chosen per pose so that her head is the same size and in the same place in all three (as for Demeter, D.2–D.4); 900 wide so that the happy pose's raised scroll fits. Used: calm `0.4775 1375 - - 83`, happy `0.4775 1375 - - 82`, thinking `0.4762 1375 - - 83` (her face 180 px wide) |
| E.11 background, E.12 game card | `cover … 1920 1080` / `cover … 1024 512` (save as .jpg) |

---
""")
for k, (title, items) in enumerate(SHEETS, 1):
    parts.append(sheet_section(k, title, items))
for num, mood, name, pose in POSES:
    parts.append("""### %s Calliope — %s

`assets/images/greek/muses_words/%s.png` — 768 × 1024 to make (900 × 768 in the game), PNG, transparent background

**Prompt:**

```text
%s %s %s
```

**Negative prompt:**

```text
%s
```
""" % (num, mood, name, MUSE, pose, STYLE_FIG, NEG))
parts.append("""### E.11 Background — a quiet corner of the Grove of the Muses

`assets/images/greek/muses_words/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A quiet, sunny corner of the laurel grove of the Muses on Mount Helicon in ancient Greece: soft green laurel trees along the left and right edges, a white marble column and a low marble bench at the lower left, where a figure will stand; far away a gentle blue mountain and a light sky. The middle and the right of the picture are a calm, pale, softly lit glade with very little detail and low contrast, because cards with pictures and written words will be placed there and must be easy to read. Wide 16:9 composition. """ + STYLE_SCENE + """
```

**Negative prompt:**

```text
""" + NEG + """
```

### E.12 Game card — The Muses' Words

`assets/images/greek/game_muses_words.png` — 1024 × 512, PNG or JPG

**Prompt:**

```text
Kind young Calliope, the Muse of words, with long wavy dark-blonde hair, a laurel crown and a soft pink dress, smiling and holding up an open blank cream scroll, beside three small picture cards floating in the air showing a red apple, an orange cat and a yellow sun, in a sunny laurel grove. The scroll and the cards have nothing written on them. One clear scene, big simple shapes, wide 2:1 composition. """ + STYLE_SCENE + """
```

**Negative prompt:**

```text
""" + NEG + """
```
""")
open("assets/prompts/E_MUSES_WORDS.md", "w", encoding="utf-8", newline="\n").write("\n".join(parts))
print("ok")
