# Image prompts — Part H: The Mosaic of Words

The word search of the Language area (specification §5.4b): Clio, the Muse of history, keeps the words in her scroll basket; they fly out onto cards, and the child finds them in an old floor mosaic covered with letter tiles. Each word found turns its tiles to glass and shows a piece of the picture underneath; at the end the whole mosaic is shown and named. The game is built and uses each picture as soon as it exists; until then it draws a stand-in (a drawn Clio and basket, simple mosaics of the sun over the sea, the moon, hills with a temple). **State:** done: all 14 are in the game (made 2026-11-09; the generated pictures are kept in `Godot/assets/images/mythos-academy/word_mosaic/`). Save them in `assets/images/greek/word_mosaic/` (the game card in `assets/images/greek/`, the word pictures in `assets/images/words/`).

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** as it is: it is complete, nothing needs to be filled in.
- Save the picture under the file name given; the game uses it as soon as it exists.
- Sizes are what the game expects. A larger picture of the same shape (aspect ratio) is fine; the game scales it down.
- No picture has letters of its own: the letters are written by the game on its tiles and cards. A letter in a picture would get in the way of the reading.
- **The mosaics (H.7–H.12)** are cut by the game to the shape of the rectangle chosen (from 8 : 5 to 10 : 7), so their edges may be trimmed a little: the prompts keep the subject in the middle. The game names a mosaic only when its picture exists ("Виж! Това е Пегас, крилатият кон!"); until then it shows a stand-in and only says "Виж цялата мозайка!".

How to turn each generated picture into the game's file (`python tools/prepare_art.py KIND SOURCE TARGET …`):

| Picture | Step |
|---|---|
| H.1 background | `cover … 1920 1080` (save as .jpg) |
| H.2–H.4 Clio | `figure … 600 800 SCALE CX - - TOP`, SCALE and CX chosen per pose so that her head is the same size and in the same place in all three and she reaches the bottom edge (CX: between her eyes). Used: calm `0.348 836 - - 9`, happy `0.348 836 - - 9` (the same framing), thinking `0.34 886 - - 39` (drawn about 7% bigger; her tilted head sits a little lower) |
| H.5 basket | `cutout … 600 500` |
| H.6 letter tile | `cutout … 256 256` (the generator drew it smaller than the picture, on white) |
| H.7–H.12 mosaics | `cover … 1536 1024` (save as .jpg) |
| H.13 game card | `cover … 1024 512` (save as .jpg) |
| H.14 word pictures | `sheet` (the **Cut it** line under the prompt) |

---

### H.1 Background — the mosaic terrace in the Grove of the Muses

`assets/images/greek/word_mosaic/background.png` — 1920 × 1080, PNG or JPG

The mosaic covers the left two thirds; the word cards are at the top right, and Clio with her basket stands at the bottom right.

**Prompt:**

```text
Create image of a sunny marble terrace in the laurel grove of the Muses on Mount Helicon in ancient Greece, as the backdrop of a children's word game, in a wide 16:9 landscape format, 1920 x 1080, seen from the front at a child's eye height. Soft green laurel trees frame the top corners and the left edge; far away a gentle blue mountain under a light sky. The left two thirds of the picture are a calm, pale, softly lit open space of warm cream stone with very little detail and low contrast, because a big rectangle of letter tiles will be placed over it and must stand out clearly. On the right side, in the lower half, a low white marble step with a little terracotta amphora and a small olive bush, where a figure will stand; the upper right is calm, pale sky and soft leaves, where word cards will be placed. Style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). Do not include any people, animals, mosaic, tiles, scrolls, text, letters, numbers, logos, watermarks or signatures. Do not make it dark, gloomy, photorealistic, 3D, busy or cluttered, and avoid harsh shadows and neon colours.
```

### H.2 Clio — calm

`assets/images/greek/word_mosaic/clio_neutral.png` — 768 × 1024 to make (600 × 800 in the game), on a plain white background

**Prompt:**

```text
Create image of Clio, the kind young Muse of history and stories of Greek myth, drawn for young children, in a tall 3:4 portrait format, 768 x 1024, shown from the waist up, facing the viewer, centred on a plain pure white background, the top of her laurel crown close to the top edge of the picture and her body cut off by the bottom edge at the waist. She has a gentle round face with rosy cheeks and warm dark-brown eyes, thick curly dark-brown hair tied up loosely with a sky-blue ribbon, a crown of green laurel leaves, small golden earrings, and a sky-blue dress (chiton) with a thin golden meander border at the neck and a golden belt. Pose: a calm, warm, encouraging smile, holding a small rolled cream scroll tied with a red ribbon in both hands in front of her, as if waiting for the child to find a word. Style: hand-painted children's storybook character design, soft gouache and watercolour texture, warm and gentle, rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not include any basket, ground, shadow, scenery, text, letters, numbers, writing on the scroll, logos, watermarks or signatures. Do not make her scary, photorealistic or 3D, and do not use white in her clothes.
```

### H.3 Clio — happy

`assets/images/greek/word_mosaic/clio_happy.png` — 768 × 1024 to make (600 × 800 in the game), on a plain white background

**Prompt:**

```text
Create image of Clio, the kind young Muse of history and stories of Greek myth, drawn for young children, in a tall 3:4 portrait format, 768 x 1024, shown from the waist up, facing the viewer, centred on a plain pure white background, the top of her laurel crown close to the top edge of the picture and her body cut off by the bottom edge at the waist. She has a gentle round face with rosy cheeks and warm dark-brown eyes, thick curly dark-brown hair tied up loosely with a sky-blue ribbon, a crown of green laurel leaves, small golden earrings, and a sky-blue dress (chiton) with a thin golden meander border at the neck and a golden belt. Pose: delighted, with a big open happy smile and bright eyes, holding a small rolled cream scroll tied with a red ribbon up beside her face in one hand and the other hand open in a little cheer, praising a child who found a word. Style: hand-painted children's storybook character design, soft gouache and watercolour texture, warm and gentle, rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not include any basket, ground, shadow, confetti, scenery, text, letters, numbers, writing on the scroll, logos, watermarks or signatures. Do not make her scary, photorealistic or 3D, and do not use white in her clothes.
```

### H.4 Clio — thinking

`assets/images/greek/word_mosaic/clio_thinking.png` — 768 × 1024 to make (600 × 800 in the game), on a plain white background

**Prompt:**

```text
Create image of Clio, the kind young Muse of history and stories of Greek myth, drawn for young children, in a tall 3:4 portrait format, 768 x 1024, shown from the waist up, facing the viewer, centred on a plain pure white background, the top of her laurel crown close to the top edge of the picture and her body cut off by the bottom edge at the waist. She has a gentle round face with rosy cheeks and warm dark-brown eyes, thick curly dark-brown hair tied up loosely with a sky-blue ribbon, a crown of green laurel leaves, small golden earrings, and a sky-blue dress (chiton) with a thin golden meander border at the neck and a golden belt. Pose: thoughtful and still hopeful, her head a little tilted, one finger on her chin, the other hand holding a small rolled cream scroll tied with a red ribbon against her chest, eyes looking to the side as if searching for something, with a small kind smile; she is not sad and not worried. Style: hand-painted children's storybook character design, soft gouache and watercolour texture, warm and gentle, rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not include any basket, ground, shadow, question marks, thought bubbles, scenery, text, letters, numbers, writing on the scroll, logos, watermarks or signatures. Do not make her scary, photorealistic or 3D, and do not use white in her clothes.
```

### H.5 Clio's scroll basket

`assets/images/greek/word_mosaic/basket.png` — 1024 × 1024 to make (600 × 500 in the game), on a plain white background

The word cards fly out of its open top at the start of each mosaic.

**Prompt:**

```text
Create image of a round woven wicker basket for scrolls, as used in ancient Greece, drawn for a children's game, in a square format, 1024 x 1024, seen slightly from above and from the front, standing alone in the middle of the picture on a plain pure white background, with a little room around it. The basket is a little wider than it is tall, of warm honey-brown woven wicker with a darker rim and a thin terracotta-red band with a simple meander pattern around its middle; its round lid leans against its side, so the top is open, and four or five rolled cream scrolls tied with red and sky-blue ribbons stick up out of it at friendly angles, with a sprig of green laurel tucked among them. Style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not include any people, hands, ground, shadow, scenery, text, letters, numbers, writing on the scrolls, logos, watermarks or signatures. Do not make it photorealistic or 3D, and do not use pure white anywhere on the basket or the scrolls.
```

### H.6 A letter tile (optional)

`assets/images/greek/word_mosaic/tile.png` — 256 × 256, PNG

One tile of the rectangle; the game writes a letter on it. Without it, the game draws plain cream tiles, which work well too.

**Prompt:**

```text
Create image of a single square tile of smooth cream-coloured marble, for a children's word game, in a square format, 1024 x 1024, seen straight from the front, filling the whole picture edge to edge. The tile is flat and calm, warm cream with very faint, soft pale-honey veins, gently bevelled edges that are a little darker and softly rounded at the corners, and a slight soft highlight at the top left, as if lit by the sun. The middle of the tile is plain and even, because a big dark letter will be written on it and must be very easy to read. Style: hand-painted children's storybook illustration, soft gouache texture, warm and friendly. Do not include any text, letters, numbers, carvings, patterns, cracks, dirt, logos, watermarks or signatures. Do not make it shiny, dark, grey, photorealistic or 3D.
```

### H.7 Mosaic — Pegasus, the winged horse

`assets/images/greek/word_mosaic/mosaic_pegasus.jpg` — 1536 × 1024, JPG

**Prompt:**

```text
Create image of an ancient Greek floor mosaic made of many small square stone tesserae with thin light grout lines between them, made for young children, in a 3:2 landscape format, 1536 x 1024, seen straight from above, the mosaic filling the whole picture edge to edge with no border and no frame. It shows Pegasus, the friendly white winged horse of Greek myth, flying joyfully toward the right with his wings spread wide and his mane flowing, with a soft grey outline so that he stands out, over a deep blue sea with curling waves at the bottom, in a light-blue sky with a few white clouds and a round golden sun in the upper left. Pegasus is big and in the middle of the picture, with some sky around him and nothing important close to the edges. Big, simple, bright shapes that are easy to recognise even when only part of the picture shows; every colour is made of small stones of a few close shades. Style: a cheerful children's storybook version of a Roman and Greek mosaic, warm and friendly, gentle rounded shapes, bright but not neon colours. Do not include any people, text, letters, numbers, logos, watermarks or signatures. Do not make it dark, scary, photorealistic, 3D, busy or cluttered.
```

### H.8 Mosaic — the owl of Athena

`assets/images/greek/word_mosaic/mosaic_owl.jpg` — 1536 × 1024, JPG

**Prompt:**

```text
Create image of an ancient Greek floor mosaic made of many small square stone tesserae with thin light grout lines between them, made for young children, in a 3:2 landscape format, 1536 x 1024, seen straight from above, the mosaic filling the whole picture edge to edge with no border and no frame. It shows the little owl of the goddess Athena, a sweet round brown owl with big round golden eyes, cream speckles and a small orange beak, sitting on a curved olive branch with silver-green leaves and a few dark olives, against a deep night-blue sky with a pale crescent moon in the upper right and a few small golden stars. The owl is big and in the middle of the picture, with some sky around it and nothing important close to the edges. Big, simple, bright shapes that are easy to recognise even when only part of the picture shows; every colour is made of small stones of a few close shades. Style: a cheerful children's storybook version of a Roman and Greek mosaic, warm and friendly, gentle rounded shapes, bright but not neon colours. Do not include any people, text, letters, numbers, logos, watermarks or signatures. Do not make it dark and gloomy, scary, photorealistic, 3D, busy or cluttered.
```

### H.9 Mosaic — the dolphin of Poseidon

`assets/images/greek/word_mosaic/mosaic_dolphin.jpg` — 1536 × 1024, JPG

**Prompt:**

```text
Create image of an ancient Greek floor mosaic made of many small square stone tesserae with thin light grout lines between them, made for young children, in a 3:2 landscape format, 1536 x 1024, seen straight from above, the mosaic filling the whole picture edge to edge with no border and no frame. It shows a happy blue-grey dolphin of the sea god Poseidon with a pale belly and a friendly smile, leaping in a high arc from left to right over turquoise and deep-blue waves with white curls of foam, with a golden three-pronged trident lying across the waves below it, a pink seashell and a small orange starfish at the bottom, and a light sky with a round golden sun in the upper right. The dolphin is big and in the middle of the picture, with some space around it and nothing important close to the edges. Big, simple, bright shapes that are easy to recognise even when only part of the picture shows; every colour is made of small stones of a few close shades. Style: a cheerful children's storybook version of a Roman and Greek mosaic, warm and friendly, gentle rounded shapes, bright but not neon colours. Do not include any people, text, letters, numbers, logos, watermarks or signatures. Do not make it dark, scary, photorealistic, 3D, busy or cluttered.
```

### H.10 Mosaic — the lyre of Apollo

`assets/images/greek/word_mosaic/mosaic_lyre.jpg` — 1536 × 1024, JPG

**Prompt:**

```text
Create image of an ancient Greek floor mosaic made of many small square stone tesserae with thin light grout lines between them, made for young children, in a 3:2 landscape format, 1536 x 1024, seen straight from above, the mosaic filling the whole picture edge to edge with no border and no frame. It shows the golden lyre of the god Apollo, standing upright in the middle, with two gracefully curved golden arms, a crossbar and seven strings, a ring of green laurel leaves around its base, and three small musical notes drawn as simple round dots with stems floating beside it, in front of a big soft sun with broad warm rays of orange, yellow and cream spreading out to the edges of the picture. The lyre is big and in the middle of the picture, with some space around it and nothing important close to the edges. Big, simple, bright shapes that are easy to recognise even when only part of the picture shows; every colour is made of small stones of a few close shades. Style: a cheerful children's storybook version of a Roman and Greek mosaic, warm and friendly, gentle rounded shapes, bright but not neon colours. Do not include any people, text, letters, numbers, logos, watermarks or signatures. Do not make it dark, scary, photorealistic, 3D, busy or cluttered.
```

### H.11 Mosaic — the ship Argo

`assets/images/greek/word_mosaic/mosaic_argo.jpg` — 1536 × 1024, JPG

**Prompt:**

```text
Create image of an ancient Greek floor mosaic made of many small square stone tesserae with thin light grout lines between them, made for young children, in a 3:2 landscape format, 1536 x 1024, seen straight from above, the mosaic filling the whole picture edge to edge with no border and no frame. It shows the Argo, the ship of the heroes of Greek myth, seen from the side and sailing toward the right on a deep-blue sea with rolling waves: a long, curved wooden ship in warm brown with a gently curling prow, a friendly painted eye at the front, a row of round shields in red, blue and gold along its side, a row of oars dipping into the water, and one big square sail with wide red and cream stripes, puffed out by the wind, under a light sky with a few white clouds and two white seagulls. The ship is big and in the middle of the picture, with some space around it and nothing important close to the edges. Big, simple, bright shapes that are easy to recognise even when only part of the picture shows; every colour is made of small stones of a few close shades. Style: a cheerful children's storybook version of a Roman and Greek mosaic, warm and friendly, gentle rounded shapes, bright but not neon colours. Do not include any people, text, letters, numbers, logos, watermarks or signatures. Do not make it dark, stormy, scary, photorealistic, 3D, busy or cluttered.
```

### H.12 Mosaic — Mount Olympus

`assets/images/greek/word_mosaic/mosaic_olympus.jpg` — 1536 × 1024, JPG

**Prompt:**

```text
Create image of an ancient Greek floor mosaic made of many small square stone tesserae with thin light grout lines between them, made for young children, in a 3:2 landscape format, 1536 x 1024, seen straight from above, the mosaic filling the whole picture edge to edge with no border and no frame. It shows Mount Olympus, the home of the Greek gods: a big friendly mountain with soft blue-grey slopes and snowy white peaks with a soft grey outline, a small shining white marble temple with columns and a terracotta roof on the highest peak, soft white clouds wrapped around the middle of the mountain, golden rays of sunlight shining down from behind the peak, a small rainbow on one side, and green hills with a few dark-green cypress trees at the bottom. The mountain is big and in the middle of the picture, with some sky around it and nothing important close to the edges. Big, simple, bright shapes that are easy to recognise even when only part of the picture shows; every colour is made of small stones of a few close shades. Style: a cheerful children's storybook version of a Roman and Greek mosaic, warm and friendly, gentle rounded shapes, bright but not neon colours. Do not include any people, gods, text, letters, numbers, logos, watermarks or signatures. Do not make it dark, stormy, scary, photorealistic, 3D, busy or cluttered.
```

### H.13 Game card — The Mosaic of Words

`assets/images/greek/game_word_mosaic.jpg` — 1024 × 512, JPG

The picture on the game's card in the list of the Grove of the Muses (like the cards of the other games).

**Prompt:**

```text
Create image of the game card picture for "The Mosaic of Words", a children's word game set in ancient Greece, in a wide 2:1 format, 1024 x 512. On the right, kind young Clio, the Muse of history, with a round rosy face, thick curly dark-brown hair tied with a sky-blue ribbon, a green laurel crown and a sky-blue dress with a golden meander border, smiles and holds open a round woven wicker basket from which a few small blank cream paper cards and rolled scrolls flutter up into the air like happy birds. On the left, filling most of the picture, an old floor mosaic seen at a gentle angle, covered with neat rows of blank square cream marble tiles; in the middle of it a few tiles are lifted away like little windows, showing part of a bright colourful mosaic of a white winged horse flying over a blue sea underneath. A sunny laurel grove behind. The cards, scrolls and tiles have nothing written on them. One clear scene, big simple shapes, clear silhouettes that read well at small size. Style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). Do not include any text, letters, numbers, logos, watermarks or signatures. Do not make it dark, scary, photorealistic, 3D, busy or cluttered.
```

### H.14 Word pictures — the new words (5)

Cut into `assets/images/words/`: `grandma`, `baby`, `vase`, `hedgehog`, `meringue` — each 384 × 384, PNG, transparent background. The sheet: 3:2, at least 1536 × 1024, PNG or JPG (another shape works too).

The pictures of the words added for the first 10 letters (`data/word_mosaic.json`: баба, бебе, ваза, еж, бизе; also used for баби, вази, ежи). A word's card shows its picture once it is found. They are drawn like the 100 word pictures of The Muses' Words (E.1–E.7).

**Prompt:**

```text
Create image of a sheet of 5 separate small pictures for a children's picture dictionary, in a 3:2 landscape format, 1536 x 1024, on a plain pure white background, in two rows: 3 pictures in the top row and 2 pictures in the bottom row, centred. Each picture shows one single thing, whole, centred in its own place, with wide empty white space between the pictures; no picture touches, overlaps or is cut off by another or by the edge. In this order: the top row, from left to right: a smiling kind grandmother with grey hair in a bun, round glasses and a soft red cardigan, shown from the waist up; a happy chubby baby with rosy cheeks sitting in a pale-blue onesie; a round terracotta vase with two small handles and a simple dark-red meander band, with three yellow flowers in it. Then the bottom row, from left to right: a cute round brown hedgehog with soft spines and a little black nose, walking, side view; a white meringue cookie in a swirly peak shape with a light golden-brown tip, on its own. Every picture in the same style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear simple silhouette with a soft darker outline all around it (so that white things stand out from the white page), bright but not neon colours, soft daylight from the top left; each thing alone, with no ground, no shadow and no scenery. Do not include any text, letters, numbers, labels, captions, borders, frames, grid lines, logos, watermarks or signatures. Do not make it photorealistic or 3D.
```

**Cut it:**

```text
python tools/prepare_art.py sheet SHEET.png assets/images/words 384 grandma,baby,vase,hedgehog,meringue
```
