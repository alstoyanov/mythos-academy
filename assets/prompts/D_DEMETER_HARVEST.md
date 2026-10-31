# Image prompts — Part D: Demeter's Harvest

The third arithmetic mini game (specification §5.2a): Demeter's harvest scale carries a sum, one side in each basket, and the child finds the missing number that balances it. Done: all thirteen are in the game (made 2026-10-31). Save them in `assets/images/greek/demeter_harvest/` (the game card in `assets/images/greek/`).

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** (and, if the tool has a field for it, the **Negative prompt**) as it is: nothing needs to be filled in.
- Save the picture under the file name given, in the game's folder; the game uses it as soon as it exists (until then it draws a stand-in), so pictures can be made one at a time and in any order.
- Every prompt already contains the shared style (hand-painted storybook, gouache and watercolour, warm Greek palette), so all pictures match.
- Pictures marked *transparent background* need one. If the tool paints a plain white background instead, that is fine: `tools/prepare_art.py` cuts the subject out.
- Sizes are what the game expects. A larger picture of the same shape (aspect ratio) is fine; the game scales it down.
- The clay tablets with the numbers (the sums on the baskets, the answers to choose from) are the tablet of Olive Harvest (C1.12, `olive_harvest/number_tablet.png`), already made: the game writes the numbers and the "?" on them, and the + and − between them.
- The wheat and the grapes (D.8, D.9) appear only when Demeter helps, one for each unit of a number, heaped in the baskets so they can be counted: they are drawn small, so they need a clear, simple shape.

The scale is made of three pictures that the game puts together and moves: the stand (D.5) stays still, the beam (D.6) tips about its middle, and a basket (D.7) hangs from each end of the beam. For them to fit, each must be framed as its prompt says: the stand's knob at the very top centre, the beam level across the exact middle with its hooks near the edges, and the basket's ring at the very top centre.

How to turn each generated picture into the game's file (`python tools/prepare_art.py KIND SOURCE TARGET …`):

| Picture | Step |
|---|---|
| D.1 background, D.13 game card | `cover … 1920 1080` / `cover … 1024 512` (save as .jpg) |
| D.2–D.4 Demeter | `figure … 1024 700 SCALE CX - - TOP`, SCALE and CX chosen per pose so that her head is the same size and in the same place in all three (as for the merchant, C1.7–C1.9). Used: calm `0.4 912 - - 20`, happy `0.4734 1381 - - 25`, shaking her head `0.4720 1348 - - 18` (her face 160 px wide, its top 110 px down) |
| D.5 stand | `cutout … 512 768` (the game puts the knob's middle, 6.5% down the picture, behind the beam's middle: `HarvestScale.STAND_KNOB`) |
| D.6 beam | `cutout … 1024 256 holes` (the white inside its middle ring goes too) |
| D.7 basket | `cutout … 512 512 holes` (the white between the cords goes too). The game expects the ring at the top, the rim at 65% of the height (`HarvestScale.RIM`) |
| D.8–D.12 the rest | `cutout …` at the size given |

---

### D.1 Background — Demeter's farm

`assets/images/greek/demeter_harvest/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A sun-drenched, friendly ancient Greek farm in late summer, seen from the front: rolling green hills under a clear light-blue sky with a few soft white clouds; silver-green olive trees along the left and right edges; far away on a hill a small white farmhouse with a terracotta roof and a low dry-stone wall; golden wheat fields dotted with a few red poppies in the distance. A wide, flat, sunny strip of soft earth and short grass fills the bottom third of the picture, plain and empty, because clay number tablets will lie there. The middle and the upper middle of the picture are open and calm, with no objects, because a big harvest scale will stand there; the lower left corner is calm as well, where a figure will stand. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### D.2 Demeter — calm

`assets/images/greek/demeter_harvest/demeter_neutral.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
Demeter, the Greek goddess of the harvest, drawn as a warm, caring, motherly figure for young children: a kind round face with rosy cheeks and gentle smiling hazel eyes, long wavy chestnut-brown hair falling over her shoulders, a crown woven from golden wheat ears and small red poppies, a flowing pastel tunic (chiton) in soft sage green with a peach-coloured shawl and a thin golden belt, a few golden wheat ears tucked at her shoulder. Shown from the waist up, facing the viewer, centred, the top of her crown close to the top edge of the picture, the same size and framing in every pose. Children's storybook character design, warm and gentle, never scary. A calm, welcoming smile, both hands held together softly in front of her, as if waiting to see what the child will do. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### D.3 Demeter — happy

`assets/images/greek/demeter_harvest/demeter_happy.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
Demeter, the Greek goddess of the harvest, drawn as a warm, caring, motherly figure for young children: a kind round face with rosy cheeks and gentle smiling hazel eyes, long wavy chestnut-brown hair falling over her shoulders, a crown woven from golden wheat ears and small red poppies, a flowing pastel tunic (chiton) in soft sage green with a peach-coloured shawl and a thin golden belt, a few golden wheat ears tucked at her shoulder. Shown from the waist up, facing the viewer, centred, the top of her crown close to the top edge of the picture, the same size and framing in every pose. Children's storybook character design, warm and gentle, never scary. Beaming with joy, eyes crinkled with laughter, both hands raised and open beside her shoulders in delight, a few tiny golden sparkles around her hands. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### D.4 Demeter — gently shaking her head ("not quite!")

`assets/images/greek/demeter_harvest/demeter_shake.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
Demeter, the Greek goddess of the harvest, drawn as a warm, caring, motherly figure for young children: a kind round face with rosy cheeks and gentle smiling hazel eyes, long wavy chestnut-brown hair falling over her shoulders, a crown woven from golden wheat ears and small red poppies, a flowing pastel tunic (chiton) in soft sage green with a peach-coloured shawl and a thin golden belt, a few golden wheat ears tucked at her shoulder. Shown from the waist up, facing the viewer, centred, the top of her crown close to the top edge of the picture, the same size and framing in every pose. Children's storybook character design, warm and gentle, never scary. Gently shaking her head with a kind, amused smile, her head tilted a little to one side, eyebrows raised kindly, one hand raised with the index finger up in a playful "oops, not quite" gesture. Warm and encouraging, never cross or sad. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry, angry, frowning, sad
```

### D.5 Scale — the stand

`assets/images/greek/demeter_harvest/scale_stand.png` — 512 × 768, PNG, transparent background

**Prompt:**

```text
The stand of an ancient Greek harvest scale, without its beam and without any baskets: a single upright turned wooden post, honey-brown with a few thin golden bands, rising from a wide, heavy, round stone base with a carved meander border; at the very top of the post a small round golden knob, where a beam will rest. Seen straight from the front, perfectly upright and symmetrical, centred; the knob touches the top centre of the picture and the base stands on the bottom edge, so the stand fills the full height of the picture. Nothing across the top: no beam, no arms, no chains, no pans, no baskets. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry, beam, crossbar, chains, pans, baskets, tilted, perspective
```

### D.6 Scale — the beam

`assets/images/greek/demeter_harvest/scale_beam.png` — 1024 × 256, PNG, transparent background

**Prompt:**

```text
The beam of an ancient Greek balance scale on its own: one long, straight, perfectly level honey-brown wooden beam with small golden end caps, a round golden ring at its exact centre, and a small golden hook hanging down at each end. Seen straight from the front, perfectly horizontal and symmetrical, running across the exact middle of the picture from side to side, its two hooks just a little in from the left and right edges. Nothing else: no stand, no post, no chains, no pans, no baskets. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry, stand, post, chains, pans, baskets, tilted, curved, perspective
```

### D.7 Scale — a hanging basket

`assets/images/greek/demeter_harvest/scale_pan.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
One hanging basket of a balance scale on its own: a round, shallow woven wicker basket in light honey-brown, hanging from three thin brown cords that meet at a small golden ring at the very top centre of the picture. The cords fill the upper half of the picture; the basket fills the lower half, seen from the front and slightly above so its open, empty inside is just visible, its rim a little below the middle of the picture. The front of the basket is plain woven wicker with no decoration, because a row of number tablets will be placed across it. Symmetrical, centred, hanging straight down. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry, fruit, wheat, filled basket, beam, stand, handle
```

### D.8 Bundle of wheat (for counting, when Demeter helps)

`assets/images/greek/demeter_harvest/wheat.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One small upright bundle of ripe golden wheat stalks with plump ears at the top, tied in the middle with a red ribbon in a little bow, standing on its cut ends, simple, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### D.9 Bunch of grapes (for counting, when Demeter helps)

`assets/images/greek/demeter_harvest/grapes.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One bunch of sweet, shiny purple grapes with a soft highlight on each round grape, a short brown stem and one green vine leaf at the top, simple, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### D.10 Goat — leaping for joy

`assets/images/greek/demeter_harvest/goat_leap.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A cute little white goat with small curved horns, a tiny beard and a happy face, leaping joyfully through the air with all four legs off the ground, legs tucked in a bouncy jump, facing right, whole body, side view, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry, facing left, standing, grass
```

### D.11 Golden sparkle

`assets/images/greek/demeter_harvest/sparkle.png` — 128 × 128, PNG, transparent background

**Prompt:**

```text
One four-pointed golden sparkle star with slim, softly rounded points and a warm glowing yellow centre, simple, symmetrical, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry, five-pointed star, many stars
```

### D.12 Harvest basket (the counter of problems solved)

`assets/images/greek/demeter_harvest/harvest_basket.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One small round woven wicker basket with two small handles, heaped full of golden wheat ears and shiny purple grapes, seen from the front and slightly above, light honey-brown, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### D.13 Game card — Demeter's Harvest

`assets/images/greek/game_demeter_harvest.png` — 1024 × 512, PNG or JPG

**Prompt:**

```text
Kind, smiling Demeter, the Greek goddess of the harvest, with long wavy chestnut hair, a crown of golden wheat and red poppies and a pastel sage-green tunic, standing at the left beside a big wooden balance scale on a sunny farm with olive trees and rolling green hills; the two woven baskets of the scale hang perfectly level, one with bundles of golden wheat and the other with bunches of purple grapes, a few plain blank terracotta clay tablets lying on the grass in front, a few golden sparkles around the scale, and a little white goat leaping happily. Plain baskets and blank tablets with nothing written on them. One clear scene, big simple shapes, wide 2:1 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```
