# Image prompts — Part E: The Muses' Words

The reading game of the Language area (specification §5.4a): Calliope shows a picture and five words, or a word and four pictures. It needs 100 word pictures, made as 7 sheets of many pictures that `tools/prepare_art.py sheet` cuts apart, and the Muse, the background and the game card. The game is built and uses each picture as soon as it exists; until then it shows a stand-in (a word picture as a pale tile with its name). **State:** done: all of them are in the game (2026-10-31; the generated sheets and pictures are kept in `Godot/assets/images/mythos-academy/words/`).

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** (and, if the tool has a field for it, the **Negative prompt**) as it is: nothing needs to be filled in.
- Every prompt already contains the shared style (hand-painted storybook, gouache and watercolour, warm Greek palette), so all pictures match.
- **The sheets (E.1–E.7):** each makes 16 pictures at once (the last one 4). Make the sheet as big as the tool allows; a square sheet suits a 4 × 4 grid best, but any shape works, because the cutter finds each picture by the white space around it, not by a fixed grid. It names them in reading order (rows from the top, each from the left), so check that the generator kept the order of the prompt; if it did not, change the order of the names in the **Cut it** line (or send me the sheets and I sort them). If it drew more or fewer pictures than asked, or two that touch, the cutter saves nothing and lists what it found: make that sheet again, or cut by hand.
- The pictures must show the thing a first grader names first, with nothing written on them: the game is about reading, and a letter in a picture would give the word away. The words themselves are in `data/words.json` (in Bulgarian and English; `tools/make_words.py` makes it).
- White things (the sheep, the egg, the cloud, the milk, the tooth, the plate) need the soft outline the prompts ask for, or the cutter cannot tell them from the page.
- Look for extras the generator adds: on sheet 7 it drew a small star beside the moon, which would make the moon and the star look alike in "Find the picture"; it was painted out before cutting (the cutter lists it as a fifth picture).

The 100 words, by sheet (picture name — Bulgarian / English):

- **Sheet 1 — Farm animals and pets:** cat (котка), dog (куче), fish (риба), horse (кон), cow (крава), sheep (овца), goat (коза), pig (прасе), hen (кокошка), duck (патица), rabbit (заек), mouse (мишка), frog (жаба), owl (сова), bee (пчела), snail (охлюв)
- **Sheet 2 — Wild animals and nature:** bear (мечка), fox (лисица), wolf (вълк), lion (лъв), elephant (слон), monkey (маймуна), giraffe (жираф), zebra (зебра), butterfly (пеперуда), turtle (костенурка), nest (гнездо), mushroom (гъба), leaf (лист), flower (цвете), tree (дърво), cloud (облак)
- **Sheet 3 — Food and tableware:** apple (ябълка), pear (круша), banana (банан), grapes (грозде), lemon (лимон), strawberry (ягода), carrot (морков), tomato (домат), bread (хляб), cheese (сирене), milk (мляко), egg (яйце), cake (торта), cup (чаша), spoon (лъжица), fork (вилица)
- **Sheet 4 — Home:** plate (чиния), table (маса), chair (стол), bed (легло), door (врата), window (прозорец), lamp (лампа), clock (часовник), candle (свещ), soap (сапун), brush (четка), bucket (кофа), shovel (лопата), basket (кошница), key (ключ), house (къща)
- **Sheet 5 — School, clothes and toys:** book (книга), pencil (молив), notebook (тетрадка), bag (чанта), hat (шапка), shoe (обувка), sock (чорап), dress (рокля), glove (ръкавица), glasses (очила), umbrella (чадър), ball (топка), balloon (балон), doll (кукла), kite (хвърчило), drum (барабан)
- **Sheet 6 — Music, travel and places:** guitar (китара), bell (камбана), robot (робот), car (кола), train (влак), boat (лодка), plane (самолет), bike (колело), bus (автобус), rocket (ракета), bridge (мост), castle (замък), crown (корона), mountain (планина), island (остров), sun (слънце)
- **Sheet 7 — Moon, star, tooth and hand:** moon (луна), star (звезда), tooth (зъб), hand (ръка)

How to turn the other pictures into the game's files (`python tools/prepare_art.py KIND SOURCE TARGET …`):

| Picture | Step |
|---|---|
| E.8–E.10 Calliope | `figure … 900 768 SCALE CX - - TOP`, SCALE and CX chosen per pose so that her head is the same size and in the same place in all three (as for Demeter, D.2–D.4); 900 wide so that the happy pose's raised scroll fits. Used: calm `0.4775 1375 - - 83`, happy `0.4775 1375 - - 82`, thinking `0.4762 1375 - - 83` (her face 180 px wide) |
| E.11 background, E.12 game card | `cover … 1920 1080` / `cover … 1024 512` (save as .jpg) |

---

### E.1 Word pictures, sheet 1 of 7 — Farm animals and pets (16)

Cut into `assets/images/words/`: `cat`, `dog`, `fish`, `horse`, `cow`, `sheep`, `goat`, `pig`, `hen`, `duck`, `rabbit`, `mouse`, `frog`, `owl`, `bee`, `snail` — each 384 × 384, PNG, transparent background. The sheet: 1:1, at least 2048 × 2048, PNG or JPG (another shape works too).

**Prompt:**

```text
A sheet of 16 separate small pictures for a children's picture dictionary, in a neat grid of 4 rows and 4 columns on a plain pure white background. Each picture shows one single thing, whole, centred in its own cell, with wide empty white space between the pictures; no picture touches, overlaps or is cut off by another or by the edge. In this order: the first row, from left to right: a cute orange tabby cat sitting; a friendly brown puppy dog sitting; a round orange fish swimming sideways and a brown horse standing, side view. Then the second row, from left to right: a black and white cow standing, side view; a fluffy white sheep with a grey face; a little white goat with small horns, side view and a pink pig standing, side view. Then the third row, from left to right: a brown hen with a red comb; a white duck with an orange beak, side view; a grey rabbit with long ears, sitting and a small grey mouse with round ears and a long tail. Then the fourth row, from left to right: a green frog sitting; a brown owl with big round eyes, sitting; a yellow and black striped bee with small wings and a snail with a brown spiral shell. Every picture in the same style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft darker outline all around it (so that white things stand out from the white page), bright but not neon colours, soft daylight from the top left; each thing alone, whole, in its most familiar view, with no scenery and no ground shadow. No text, no letters, no numbers, no labels, no grid lines, no borders, no frames, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, labels, captions, grid lines, borders, frames, boxes, overlapping pictures, touching pictures, cut-off pictures, extra objects, scenery, background, ground shadows, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, angry faces, weapons, blood, harsh shadows, neon colours, blurry
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 cat,dog,fish,horse,cow,sheep,goat,pig,hen,duck,rabbit,mouse,frog,owl,bee,snail
```

### E.2 Word pictures, sheet 2 of 7 — Wild animals and nature (16)

Cut into `assets/images/words/`: `bear`, `fox`, `wolf`, `lion`, `elephant`, `monkey`, `giraffe`, `zebra`, `butterfly`, `turtle`, `nest`, `mushroom`, `leaf`, `flower`, `tree`, `cloud` — each 384 × 384, PNG, transparent background. The sheet: 1:1, at least 2048 × 2048, PNG or JPG (another shape works too).

**Prompt:**

```text
A sheet of 16 separate small pictures for a children's picture dictionary, in a neat grid of 4 rows and 4 columns on a plain pure white background. Each picture shows one single thing, whole, centred in its own cell, with wide empty white space between the pictures; no picture touches, overlaps or is cut off by another or by the edge. In this order: the first row, from left to right: a big brown bear standing on four legs, side view; an orange fox with a white-tipped tail, side view; a grey wolf standing, side view, friendly and a lion with a golden mane, sitting, friendly. Then the second row, from left to right: a grey elephant with a long trunk, side view; a brown monkey sitting, waving; a whole giraffe with a long neck and brown patches, side view and a black and white striped zebra, side view. Then the third row, from left to right: a butterfly with blue and orange wings spread open; a green turtle with a patterned shell, side view; an empty round bird's nest made of twigs, with no eggs and no bird and a mushroom with a red cap and white spots. Then the fourth row, from left to right: one single green leaf; one red flower with a green stem and two leaves; a whole round green tree with a brown trunk and one fluffy white cloud with soft blue-grey shading. Every picture in the same style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft darker outline all around it (so that white things stand out from the white page), bright but not neon colours, soft daylight from the top left; each thing alone, whole, in its most familiar view, with no scenery and no ground shadow. No text, no letters, no numbers, no labels, no grid lines, no borders, no frames, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, labels, captions, grid lines, borders, frames, boxes, overlapping pictures, touching pictures, cut-off pictures, extra objects, scenery, background, ground shadows, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, angry faces, weapons, blood, harsh shadows, neon colours, blurry
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 bear,fox,wolf,lion,elephant,monkey,giraffe,zebra,butterfly,turtle,nest,mushroom,leaf,flower,tree,cloud
```

### E.3 Word pictures, sheet 3 of 7 — Food and tableware (16)

Cut into `assets/images/words/`: `apple`, `pear`, `banana`, `grapes`, `lemon`, `strawberry`, `carrot`, `tomato`, `bread`, `cheese`, `milk`, `egg`, `cake`, `cup`, `spoon`, `fork` — each 384 × 384, PNG, transparent background. The sheet: 1:1, at least 2048 × 2048, PNG or JPG (another shape works too).

**Prompt:**

```text
A sheet of 16 separate small pictures for a children's picture dictionary, in a neat grid of 4 rows and 4 columns on a plain pure white background. Each picture shows one single thing, whole, centred in its own cell, with wide empty white space between the pictures; no picture touches, overlaps or is cut off by another or by the edge. In this order: the first row, from left to right: a shiny red apple with a leaf; a green-yellow pear with a stem; one yellow banana and a bunch of purple grapes with a leaf. Then the second row, from left to right: a yellow lemon; a red strawberry with green leaves on top; an orange carrot with green leaves and a round red tomato with a green stem. Then the third row, from left to right: a round loaf of golden-brown bread; a wedge of yellow cheese with holes; a glass bottle full of white milk with a blue cap and one whole white egg, standing. Then the fourth row, from left to right: a round birthday cake with pink icing and one candle; a blue cup with a handle, empty; one silver spoon and one silver fork. Every picture in the same style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft darker outline all around it (so that white things stand out from the white page), bright but not neon colours, soft daylight from the top left; each thing alone, whole, in its most familiar view, with no scenery and no ground shadow. No text, no letters, no numbers, no labels, no grid lines, no borders, no frames, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, labels, captions, grid lines, borders, frames, boxes, overlapping pictures, touching pictures, cut-off pictures, extra objects, scenery, background, ground shadows, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, angry faces, weapons, blood, harsh shadows, neon colours, blurry
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 apple,pear,banana,grapes,lemon,strawberry,carrot,tomato,bread,cheese,milk,egg,cake,cup,spoon,fork
```

### E.4 Word pictures, sheet 4 of 7 — Home (16)

Cut into `assets/images/words/`: `plate`, `table`, `chair`, `bed`, `door`, `window`, `lamp`, `clock`, `candle`, `soap`, `brush`, `bucket`, `shovel`, `basket`, `key`, `house` — each 384 × 384, PNG, transparent background. The sheet: 1:1, at least 2048 × 2048, PNG or JPG (another shape works too).

**Prompt:**

```text
A sheet of 16 separate small pictures for a children's picture dictionary, in a neat grid of 4 rows and 4 columns on a plain pure white background. Each picture shows one single thing, whole, centred in its own cell, with wide empty white space between the pictures; no picture touches, overlaps or is cut off by another or by the edge. In this order: the first row, from left to right: an empty round white plate with a blue rim, seen slightly from above; a wooden table with four legs; a wooden chair, side view and a small bed with a blue blanket and a white pillow. Then the second row, from left to right: a closed wooden door with a round handle; a window with a wooden frame, four glass panes and open curtains; a table lamp with a yellow lampshade and a round wall clock with two hands and small dots instead of numbers. Then the third row, from left to right: a white candle with a small flame; a pink bar of soap with a few bubbles; a toothbrush with blue handle and white bristles and a red plastic bucket with a handle. Then the fourth row, from left to right: a small garden spade with a wooden handle; an empty woven basket with a handle; one golden key and a small house with a red roof, a door and two windows. Every picture in the same style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft darker outline all around it (so that white things stand out from the white page), bright but not neon colours, soft daylight from the top left; each thing alone, whole, in its most familiar view, with no scenery and no ground shadow. No text, no letters, no numbers, no labels, no grid lines, no borders, no frames, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, labels, captions, grid lines, borders, frames, boxes, overlapping pictures, touching pictures, cut-off pictures, extra objects, scenery, background, ground shadows, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, angry faces, weapons, blood, harsh shadows, neon colours, blurry
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 plate,table,chair,bed,door,window,lamp,clock,candle,soap,brush,bucket,shovel,basket+,key,house
```

### E.5 Word pictures, sheet 5 of 7 — School, clothes and toys (16)

Cut into `assets/images/words/`: `book`, `pencil`, `notebook`, `bag`, `hat`, `shoe`, `sock`, `dress`, `glove`, `glasses`, `umbrella`, `ball`, `balloon`, `doll`, `kite`, `drum` — each 384 × 384, PNG, transparent background. The sheet: 1:1, at least 2048 × 2048, PNG or JPG (another shape works too).

**Prompt:**

```text
A sheet of 16 separate small pictures for a children's picture dictionary, in a neat grid of 4 rows and 4 columns on a plain pure white background. Each picture shows one single thing, whole, centred in its own cell, with wide empty white space between the pictures; no picture touches, overlaps or is cut off by another or by the edge. In this order: the first row, from left to right: a closed book with a plain green cover; a yellow pencil with a pink eraser; an open notebook with blank lined pages and a spiral and a red school backpack. Then the second row, from left to right: a straw sun hat with a ribbon; one red children's shoe; one striped sock and a yellow girl's dress. Then the third row, from left to right: one blue woollen mitten; a pair of round glasses; an open red umbrella and a red and white ball. Then the fourth row, from left to right: one blue balloon on a string; a rag doll with yellow hair and a blue dress; a diamond-shaped kite with a tail of bows and a small red drum with two drumsticks. Every picture in the same style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft darker outline all around it (so that white things stand out from the white page), bright but not neon colours, soft daylight from the top left; each thing alone, whole, in its most familiar view, with no scenery and no ground shadow. No text, no letters, no numbers, no labels, no grid lines, no borders, no frames, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, labels, captions, grid lines, borders, frames, boxes, overlapping pictures, touching pictures, cut-off pictures, extra objects, scenery, background, ground shadows, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, angry faces, weapons, blood, harsh shadows, neon colours, blurry
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 book,pencil,notebook,bag,hat,shoe,sock,dress,glove,glasses,umbrella,ball,balloon,doll,kite,drum
```

### E.6 Word pictures, sheet 6 of 7 — Music, travel and places (16)

Cut into `assets/images/words/`: `guitar`, `bell`, `robot`, `car`, `train`, `boat`, `plane`, `bike`, `bus`, `rocket`, `bridge`, `castle`, `crown`, `mountain`, `island`, `sun` — each 384 × 384, PNG, transparent background. The sheet: 1:1, at least 2048 × 2048, PNG or JPG (another shape works too).

**Prompt:**

```text
A sheet of 16 separate small pictures for a children's picture dictionary, in a neat grid of 4 rows and 4 columns on a plain pure white background. Each picture shows one single thing, whole, centred in its own cell, with wide empty white space between the pictures; no picture touches, overlaps or is cut off by another or by the edge. In this order: the first row, from left to right: an acoustic guitar; a golden bell; a friendly toy robot with a square head and a small red car, side view. Then the second row, from left to right: a green steam train engine, side view; a small wooden rowing boat with a white sail, side view; a small white aeroplane with blue stripes, side view and a children's bicycle, side view. Then the third row, from left to right: a yellow bus, side view; a white and red rocket pointing up; a small stone arch bridge and a small castle with towers and flags. Then the fourth row, from left to right: a golden crown with red jewels; one tall mountain with a snowy peak; a small round island with one palm tree, a little patch of blue sea around it and a round yellow sun with short rays, no face. Every picture in the same style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft darker outline all around it (so that white things stand out from the white page), bright but not neon colours, soft daylight from the top left; each thing alone, whole, in its most familiar view, with no scenery and no ground shadow. No text, no letters, no numbers, no labels, no grid lines, no borders, no frames, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, labels, captions, grid lines, borders, frames, boxes, overlapping pictures, touching pictures, cut-off pictures, extra objects, scenery, background, ground shadows, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, angry faces, weapons, blood, harsh shadows, neon colours, blurry
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 guitar,bell,robot,car,train,boat,plane,bike,bus,rocket,bridge,castle,crown,mountain,island,sun
```

### E.7 Word pictures, sheet 7 of 7 — Moon, star, tooth and hand (4)

Cut into `assets/images/words/`: `moon`, `star`, `tooth`, `hand` — each 384 × 384, PNG, transparent background. The sheet: 1:1, at least 2048 × 2048, PNG or JPG (another shape works too).

**Prompt:**

```text
A sheet of 4 separate small pictures for a children's picture dictionary, in a neat grid of 2 rows and 2 columns on a plain pure white background. Each picture shows one single thing, whole, centred in its own cell, with wide empty white space between the pictures; no picture touches, overlaps or is cut off by another or by the edge. In this order: the first row, from left to right: a yellow crescent moon, no face and one yellow five-pointed star. Then the second row, from left to right: one shiny white tooth, no face and an open waving child's hand, palm to the front. Every picture in the same style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft darker outline all around it (so that white things stand out from the white page), bright but not neon colours, soft daylight from the top left; each thing alone, whole, in its most familiar view, with no scenery and no ground shadow. No text, no letters, no numbers, no labels, no grid lines, no borders, no frames, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, labels, captions, grid lines, borders, frames, boxes, overlapping pictures, touching pictures, cut-off pictures, extra objects, scenery, background, ground shadows, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, angry faces, weapons, blood, harsh shadows, neon colours, blurry
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 moon,star,tooth,hand
```

### E.8 Calliope — calm

`assets/images/greek/muses_words/muse_neutral.png` — 768 × 1024 to make (900 × 768 in the game), PNG, transparent background

**Prompt:**

```text
Calliope, the kind young Muse of words and stories of Greek myth, drawn for young children: a gentle round face with rosy cheeks and warm brown eyes, long wavy dark-blonde hair, a crown of green laurel leaves, a soft pink dress (chiton) with a thin golden belt, holding a rolled cream scroll. Shown from the waist up, facing the viewer, centred, the top of her crown close to the top edge of the picture, the same size and framing in every pose. Children's storybook character design, warm and gentle. A calm, warm smile, the scroll held in both hands in front of her, as if waiting to hear the child read. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### E.9 Calliope — happy

`assets/images/greek/muses_words/muse_happy.png` — 768 × 1024 to make (900 × 768 in the game), PNG, transparent background

**Prompt:**

```text
Calliope, the kind young Muse of words and stories of Greek myth, drawn for young children: a gentle round face with rosy cheeks and warm brown eyes, long wavy dark-blonde hair, a crown of green laurel leaves, a soft pink dress (chiton) with a thin golden belt, holding a rolled cream scroll. Shown from the waist up, facing the viewer, centred, the top of her crown close to the top edge of the picture, the same size and framing in every pose. Children's storybook character design, warm and gentle. Beaming with joy, eyes crinkled with laughter, holding the scroll up high in one hand and the other hand open in delight, a few tiny golden sparkles around her. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### E.10 Calliope — thinking

`assets/images/greek/muses_words/muse_thinking.png` — 768 × 1024 to make (900 × 768 in the game), PNG, transparent background

**Prompt:**

```text
Calliope, the kind young Muse of words and stories of Greek myth, drawn for young children: a gentle round face with rosy cheeks and warm brown eyes, long wavy dark-blonde hair, a crown of green laurel leaves, a soft pink dress (chiton) with a thin golden belt, holding a rolled cream scroll. Shown from the waist up, facing the viewer, centred, the top of her crown close to the top edge of the picture, the same size and framing in every pose. Children's storybook character design, warm and gentle. Thinking kindly, head a little to one side, one finger on her chin, the scroll under her other arm, a gentle encouraging smile. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### E.11 Background — a quiet corner of the Grove of the Muses

`assets/images/greek/muses_words/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A quiet, sunny corner of the laurel grove of the Muses on Mount Helicon in ancient Greece: soft green laurel trees along the left and right edges, a white marble column and a low marble bench at the lower left, where a figure will stand; far away a gentle blue mountain and a light sky. The middle and the right of the picture are a calm, pale, softly lit glade with very little detail and low contrast, because cards with pictures and written words will be placed there and must be easy to read. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### E.12 Game card — The Muses' Words

`assets/images/greek/game_muses_words.png` — 1024 × 512, PNG or JPG

**Prompt:**

```text
Kind young Calliope, the Muse of words, with long wavy dark-blonde hair, a laurel crown and a soft pink dress, smiling and holding up an open blank cream scroll, beside three small picture cards floating in the air showing a red apple, an orange cat and a yellow sun, in a sunny laurel grove. The scroll and the cards have nothing written on them. One clear scene, big simple shapes, wide 2:1 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```
