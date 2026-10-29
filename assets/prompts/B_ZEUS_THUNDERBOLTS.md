# Image prompts — Part B: Zeus' Thunderbolts

The first arithmetic mini game (specification §5.1): Zeus strikes the cloud with the biggest or the smallest number. The game is built and uses these pictures as soon as they exist; until then it draws stand-ins. Save them in `assets/images/greek/zeus_thunderbolts/` (the game card in `assets/images/greek/`).

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** (and, if the tool has a field for it, the **Negative prompt**) as it is: nothing needs to be filled in.
- Save the picture under the file name given, in the game's folder; the game uses it as soon as it exists (until then it draws a stand-in), so pictures can be made one at a time and in any order.
- Every prompt already contains the shared style (hand-painted storybook, gouache and watercolour, warm Greek palette), so all pictures match.
- Pictures marked *transparent background* need one. If the tool paints a plain white background instead, that is fine: `tools/prepare_art.py` cuts the subject out.
- Sizes are what the game expects. A larger picture of the same shape (aspect ratio) is fine; the game scales it down.

---

### B.1 Background — the sky over Mount Olympus

`assets/images/greek/zeus_thunderbolts/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
High above the world on Mount Olympus: a bright, clear, friendly blue sky that fills most of the picture; at the lower left the snowy rounded peak of Mount Olympus with a small white marble temple and a golden throne on top, where a figure will stand; soft blue-grey mountain tops and a sea of soft white clouds along the bottom edge; a warm golden sun glow in the upper right corner. The upper middle and right part of the picture is open, calm sky with no objects, because clouds with numbers will float there. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.2 Zeus — standing (idle)

`assets/images/greek/zeus_thunderbolts/zeus_idle.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
Zeus, king of the gods of Greek myth, drawn as a kind, cheerful, grandfatherly figure for young children: a big curly white beard and white hair, warm twinkling eyes, rosy cheeks, a golden laurel crown, a flowing white robe with a sky-blue cloak and a gold belt, bare friendly arms. Full body, standing, facing slightly to the right, centred. Children's storybook character design, warm and gentle, never scary. Standing relaxed with a warm smile, holding a small glowing golden thunderbolt loosely at his side in his right hand. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.3 Zeus — throwing a thunderbolt

`assets/images/greek/zeus_thunderbolts/zeus_throw.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
Zeus, king of the gods of Greek myth, drawn as a kind, cheerful, grandfatherly figure for young children: a big curly white beard and white hair, warm twinkling eyes, rosy cheeks, a golden laurel crown, a flowing white robe with a sky-blue cloak and a gold belt, bare friendly arms. Full body, standing, facing slightly to the right, centred. Children's storybook character design, warm and gentle, never scary. Playfully throwing: his right arm stretched up and forwards to the upper right, his hand open just after letting go, a little golden sparkle at his fingertips, a happy concentrated face. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.4 Zeus — cheering

`assets/images/greek/zeus_thunderbolts/zeus_happy.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
Zeus, king of the gods of Greek myth, drawn as a kind, cheerful, grandfatherly figure for young children: a big curly white beard and white hair, warm twinkling eyes, rosy cheeks, a golden laurel crown, a flowing white robe with a sky-blue cloak and a gold belt, bare friendly arms. Full body, standing, facing slightly to the right, centred. Children's storybook character design, warm and gentle, never scary. Laughing with joy, both arms raised in celebration, eyes crinkled in a big smile, a few small golden sparkles around him. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.5 Zeus — encouraging

`assets/images/greek/zeus_thunderbolts/zeus_encourage.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
Zeus, king of the gods of Greek myth, drawn as a kind, cheerful, grandfatherly figure for young children: a big curly white beard and white hair, warm twinkling eyes, rosy cheeks, a golden laurel crown, a flowing white robe with a sky-blue cloak and a gold belt, bare friendly arms. Full body, standing, facing slightly to the right, centred. Children's storybook character design, warm and gentle, never scary. Leaning forwards a little with a gentle, encouraging smile, one hand raised with the index finger up as if saying "let's try again", eyebrows raised kindly. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.6 Cloud 1

`assets/images/greek/zeus_thunderbolts/cloud_1.png` — 768 × 500, PNG, transparent background

**Prompt:**

```text
One single cartoon cloud seen flat from the front: a wide, round, puffy cloud made of four soft bumps on top and a flat soft bottom, bright white with soft pale-blue and lilac shading underneath, a thin soft outline, filling most of the image. The middle of the cloud is plain white and empty, because the game writes a big number on it. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.7 Cloud 2

`assets/images/greek/zeus_thunderbolts/cloud_2.png` — 768 × 500, PNG, transparent background

**Prompt:**

```text
One single cartoon cloud seen flat from the front: a plump cloud with one big round bump in the middle and two smaller bumps at the sides, bright white with soft pale-blue and lilac shading underneath, a thin soft outline, filling most of the image. The middle of the cloud is plain white and empty, because the game writes a big number on it. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.8 Cloud 3

`assets/images/greek/zeus_thunderbolts/cloud_3.png` — 768 × 500, PNG, transparent background

**Prompt:**

```text
One single cartoon cloud seen flat from the front: a fluffy cloud with three even round bumps on top, slightly taller on the left, bright white with soft pale-blue and lilac shading underneath, a thin soft outline, filling most of the image. The middle of the cloud is plain white and empty, because the game writes a big number on it. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.9 Thunderbolt

`assets/images/greek/zeus_thunderbolts/lightning_bolt.png` — 1024 × 256, PNG, transparent background

**Prompt:**

```text
One golden thunderbolt of Zeus lying horizontally across the whole image from the left edge to the right edge: a jagged zigzag lightning bolt, bright white-yellow core with a warm golden glow around it, its sharp point at the right end. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.10 Goal picture — biggest (many coins)

`assets/images/greek/zeus_thunderbolts/icon_biggest.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
A small pile of five shiny round gold coins of ancient Athens, each with a little owl on it: three coins in a row at the bottom and two on top of them, seen from the front, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.11 Goal picture — smallest (one coin)

`assets/images/greek/zeus_thunderbolts/icon_smallest.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One single shiny round gold coin of ancient Athens with a little owl on it, seen from the front, centred, about half the size of the image, with empty space around it. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.12 Score badge — laurel wreath

`assets/images/greek/zeus_thunderbolts/score_laurel.png` — 640 × 512, PNG, transparent background

**Prompt:**

```text
A golden laurel wreath in a horseshoe shape, open at the top, with leafy branches curving up on both sides and a small blue ribbon tied at the bottom; the inside of the wreath is a large empty round space, because the game writes the score there. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### B.13 Game card — Zeus' Thunderbolts

`assets/images/greek/game_zeus_thunderbolts.png` — 1024 × 512, PNG or JPG

**Prompt:**

```text
Kind cheerful Zeus with a big curly white beard and a golden laurel crown, standing on a white cloud at the left and playfully throwing a small golden thunderbolt at one of three fluffy white clouds floating in a bright blue sky on the right; the hit cloud bursts into golden sparkles. The clouds are plain white with nothing written on them. One clear scene, big simple shapes, wide 2:1 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```
