# Image prompts — Part C: the later Grade 1 mini games

The art of the other mini games of the specification (§5.2 to §5.5), for when they are built.

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** (and, if the tool has a field for it, the **Negative prompt**) as it is: nothing needs to be filled in.
- Save the picture under the file name given, in the game's folder; the game uses it as soon as it exists (until then it draws a stand-in), so pictures can be made one at a time and in any order.
- Every prompt already contains the shared style (hand-painted storybook, gouache and watercolour, warm Greek palette), so all pictures match.
- Pictures marked *transparent background* need one. If the tool paints a plain white background instead, that is fine: `tools/prepare_art.py` cuts the subject out.
- Sizes are what the game expects. A larger picture of the same shape (aspect ratio) is fine; the game scales it down.

---

## C1. Olive Harvest (Arithmetic)

### C1.1 Background

`assets/images/greek/olive_harvest/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A cosy market stall in the Agora of ancient Athens under a red and cream striped awning, seen from the front; a plain wooden counter runs across the lower third of the picture; a silver-green olive tree stands at the left edge; the market square and the Acropolis are soft and blurred in the background. The counter and the space above it are calm and uncluttered, because baskets and olives will be placed there. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.2 Olive tree

`assets/images/greek/olive_harvest/olive_tree.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
A round, friendly olive tree full of shiny green and black olives, silver-green leaves, a short twisted trunk, whole tree visible, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.3 Green olive

`assets/images/greek/olive_harvest/olive_green.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One single shiny green olive with one small silver-green leaf on a tiny stem, simple, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.4 Black olive

`assets/images/greek/olive_harvest/olive_black.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One single shiny dark purple-black olive with one small silver-green leaf on a tiny stem, simple, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.5 Basket, empty

`assets/images/greek/olive_harvest/basket_empty.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
An empty round woven wicker basket with two small handles, seen from the front and slightly above so the inside is visible, light honey-brown, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.6 Basket, full

`assets/images/greek/olive_harvest/basket_full.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A round woven wicker basket with two small handles heaped full of shiny green and black olives, seen from the front and slightly above, light honey-brown, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.7 Merchant, calm

`assets/images/greek/olive_harvest/merchant_neutral.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A kind, round-faced market merchant of ancient Athens with a curly black beard, warm brown eyes, a simple cream tunic and a blue cloak, shown from the waist up, facing the viewer, centred. Calm friendly smile, hands resting on his belly. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.8 Merchant, happy

`assets/images/greek/olive_harvest/merchant_happy.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A kind, round-faced market merchant of ancient Athens with a curly black beard, warm brown eyes, a simple cream tunic and a blue cloak, shown from the waist up, facing the viewer, centred. Beaming with joy, eyes crinkled, both hands clapping. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.9 Merchant, thinking

`assets/images/greek/olive_harvest/merchant_thinking.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A kind, round-faced market merchant of ancient Athens with a curly black beard, warm brown eyes, a simple cream tunic and a blue cloak, shown from the waist up, facing the viewer, centred. Gently puzzled, scratching his head with one hand, kind expression. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.10 Goat

`assets/images/greek/olive_harvest/goat.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A cheeky, cute little white goat with small curved horns and a tiny beard, happily munching a mouthful of olive leaves, whole body, side view turned towards the viewer, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.11 Coin

`assets/images/greek/olive_harvest/coin.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One shiny round gold coin of ancient Athens with a simple owl embossed on it, seen from the front, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C1.12 Number tablet

`assets/images/greek/olive_harvest/number_tablet.png` — 384 × 384, PNG, transparent background

**Prompt:**

```text
One blank rounded square clay tablet, terracotta colour, with a slightly raised smooth edge, the flat face completely empty, seen from the front, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

## C2. Temple Builder (Geometry)

### C2.1 Background

`assets/images/greek/temple_builder/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A sunny building site at Olympia in ancient Greece: open flat sandy ground across most of the picture, tall cypress trees and soft green hills in the distance, a little wooden scaffolding at the far right edge, a blue sky with a few clouds. The middle of the picture is open and calm, because a temple will be built there. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.2 Temple outline 1 (easy)

`assets/images/greek/temple_builder/temple_outline_1.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
A very simple small Greek temple: one big triangle roof on top, below it two tall rectangle columns, and one long rectangle step at the bottom. Drawn only as a pale chalk-white outline with clear separate shapes and empty insides, seen straight from the front, centred, like a building plan for children. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.3 Temple outline 2 (medium)

`assets/images/greek/temple_builder/temple_outline_2.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
A Greek temple: a triangle roof with a round shield in its middle, below it four rectangle columns standing on a row of three square blocks, and two long rectangle steps at the bottom. Drawn only as a pale chalk-white outline with clear separate shapes and empty insides, seen straight from the front, centred, like a building plan for children. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.4 Temple outline 3 (harder)

`assets/images/greek/temple_builder/temple_outline_3.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
A grand Greek temple: a wide triangle roof with three round shields along it, a band of alternating circles and squares under the roof, six rectangle columns, a half-circle doorway in the middle, and three long rectangle steps at the bottom. Drawn only as a pale chalk-white outline with clear separate shapes and empty insides, seen straight from the front, centred, like a building plan for children. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.5 Stone — circle, white

`assets/images/greek/temple_builder/stone_circle_white.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a perfect flat round disc (a circle), made of white marble with faint grey veins, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.6 Stone — circle, terracotta

`assets/images/greek/temple_builder/stone_circle_terracotta.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a perfect flat round disc (a circle), made of warm terracotta orange clay, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.7 Stone — circle, blue

`assets/images/greek/temple_builder/stone_circle_blue.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a perfect flat round disc (a circle), made of Aegean-blue painted stone, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.8 Stone — square, white

`assets/images/greek/temple_builder/stone_square_white.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a perfect square block with four equal sides, made of white marble with faint grey veins, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.9 Stone — square, terracotta

`assets/images/greek/temple_builder/stone_square_terracotta.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a perfect square block with four equal sides, made of warm terracotta orange clay, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.10 Stone — square, blue

`assets/images/greek/temple_builder/stone_square_blue.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a perfect square block with four equal sides, made of Aegean-blue painted stone, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.11 Stone — triangle, white

`assets/images/greek/temple_builder/stone_triangle_white.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a triangle block with three equal sides, pointing up, made of white marble with faint grey veins, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.12 Stone — triangle, terracotta

`assets/images/greek/temple_builder/stone_triangle_terracotta.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a triangle block with three equal sides, pointing up, made of warm terracotta orange clay, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.13 Stone — triangle, blue

`assets/images/greek/temple_builder/stone_triangle_blue.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a triangle block with three equal sides, pointing up, made of Aegean-blue painted stone, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.14 Stone — rectangle, white

`assets/images/greek/temple_builder/stone_rectangle_white.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a rectangle block twice as wide as it is tall, made of white marble with faint grey veins, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.15 Stone — rectangle, terracotta

`assets/images/greek/temple_builder/stone_rectangle_terracotta.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a rectangle block twice as wide as it is tall, made of warm terracotta orange clay, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.16 Stone — rectangle, blue

`assets/images/greek/temple_builder/stone_rectangle_blue.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a rectangle block twice as wide as it is tall, made of Aegean-blue painted stone, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.17 Stone — oval, white

`assets/images/greek/temple_builder/stone_oval_white.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as an oval (egg-shaped ellipse) block, lying sideways, made of white marble with faint grey veins, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.18 Stone — oval, terracotta

`assets/images/greek/temple_builder/stone_oval_terracotta.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as an oval (egg-shaped ellipse) block, lying sideways, made of warm terracotta orange clay, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.19 Stone — oval, blue

`assets/images/greek/temple_builder/stone_oval_blue.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as an oval (egg-shaped ellipse) block, lying sideways, made of Aegean-blue painted stone, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.20 Stone — half circle, white

`assets/images/greek/temple_builder/stone_half_circle_white.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a half-circle block with the flat side at the bottom, made of white marble with faint grey veins, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.21 Stone — half circle, terracotta

`assets/images/greek/temple_builder/stone_half_circle_terracotta.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a half-circle block with the flat side at the bottom, made of warm terracotta orange clay, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.22 Stone — half circle, blue

`assets/images/greek/temple_builder/stone_half_circle_blue.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
One smooth carved building stone shaped as a half-circle block with the flat side at the bottom, made of Aegean-blue painted stone, seen straight from the front, soft shading and slightly rounded edges, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.23 Cart

`assets/images/greek/temple_builder/cart.png` — 768 × 512, PNG, transparent background

**Prompt:**

```text
A small empty wooden handcart with two wooden wheels and a long handle, side view, light warm wood, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.24 Builder, calm

`assets/images/greek/temple_builder/builder_neutral.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A friendly young builder of ancient Greece with short curly hair, a cloth headband and a simple tunic, holding a wooden measuring rod, shown from the waist up, facing the viewer, centred. Calm, encouraging smile. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.25 Builder, happy

`assets/images/greek/temple_builder/builder_happy.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A friendly young builder of ancient Greece with short curly hair, a cloth headband and a simple tunic, holding a wooden measuring rod, shown from the waist up, facing the viewer, centred. Cheering with the measuring rod raised high, big smile. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.26 Builder, thinking

`assets/images/greek/temple_builder/builder_thinking.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A friendly young builder of ancient Greece with short curly hair, a cloth headband and a simple tunic, holding a wooden measuring rod, shown from the waist up, facing the viewer, centred. Puzzled, head tilted, one hand on the chin, kind expression. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C2.27 Frieze strip

`assets/images/greek/temple_builder/frieze_tile.png` — 512 × 256, PNG, transparent background

**Prompt:**

```text
One blank horizontal strip of white marble frieze with a thin gold meander pattern along its top and bottom edges and an empty smooth middle, seen straight from the front, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

## C3. The Muses' Letters (Language)

### C3.1 Background

`assets/images/greek/muses_letters/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A sunny laurel grove on Mount Helicon in ancient Greece: one long leafy laurel branch stretches across the whole upper part of the picture from the left edge to the right edge; a white marble bench and a small spring with a little waterfall at the lower right; butterflies; soft green-golden light. The middle of the picture is an open grassy glade with little detail, because the game's pieces will be placed there. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.2 Muse with a lyre

`assets/images/greek/muses_letters/muse_1.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A kind young Muse of Greek myth, a gentle smile and warm eyes, long wavy hair, wearing a light sky-blue dress and a crown of white flowers, holding a small golden lyre, shown from the waist up, facing the viewer, centred. Children's storybook character design. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.3 Muse with a scroll

`assets/images/greek/muses_letters/muse_2.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A kind young Muse of Greek myth, a gentle smile and warm eyes, long wavy hair, wearing a soft pink dress and a crown of laurel leaves, holding an open cream scroll with nothing written on it, shown from the waist up, facing the viewer, centred. Children's storybook character design. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.4 Muse with a flute

`assets/images/greek/muses_letters/muse_3.png` — 768 × 1024, PNG, transparent background

**Prompt:**

```text
A kind young Muse of Greek myth, a gentle smile and warm eyes, long wavy hair, wearing a pale green dress and a crown of yellow flowers, holding a double wooden flute, shown from the waist up, facing the viewer, centred. Children's storybook character design. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.5 Lyre

`assets/images/greek/muses_letters/lyre.png` — 768 × 768, PNG, transparent background

**Prompt:**

```text
One golden ancient Greek lyre with seven strings and two gracefully curved arms, seen straight from the front, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.6 Letter tablet

`assets/images/greek/muses_letters/letter_tablet.png` — 384 × 384, PNG, transparent background

**Prompt:**

```text
One blank small square clay tablet, terracotta colour, hanging from a short knotted string at the top, the flat face completely empty, seen from the front, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.7 Picture card — apple

`assets/images/greek/muses_letters/picture_apple.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a shiny red apple with one green leaf, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.8 Picture card — ball

`assets/images/greek/muses_letters/picture_ball.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a round striped red and blue ball, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.9 Picture card — cat

`assets/images/greek/muses_letters/picture_cat.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a cute sitting orange cat, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.10 Picture card — dog

`assets/images/greek/muses_letters/picture_dog.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a friendly sitting brown puppy, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.11 Picture card — egg

`assets/images/greek/muses_letters/picture_egg.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a white egg, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.12 Picture card — fish

`assets/images/greek/muses_letters/picture_fish.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a cheerful little blue fish, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.13 Picture card — goat

`assets/images/greek/muses_letters/picture_goat.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a cute little white goat, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.14 Picture card — hat

`assets/images/greek/muses_letters/picture_hat.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a straw sun hat with a blue ribbon, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.15 Picture card — iguana

`assets/images/greek/muses_letters/picture_iguana.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a cute friendly green iguana, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.16 Picture card — jug

`assets/images/greek/muses_letters/picture_jug.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a terracotta water jug with one handle, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.17 Picture card — kite

`assets/images/greek/muses_letters/picture_kite.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a colourful diamond-shaped kite with a ribbon tail, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.18 Picture card — lion

`assets/images/greek/muses_letters/picture_lion.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a friendly cartoon lion with a fluffy mane, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.19 Picture card — moon

`assets/images/greek/muses_letters/picture_moon.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a smiling crescent moon, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.20 Picture card — nest

`assets/images/greek/muses_letters/picture_nest.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a bird's nest with three small blue eggs, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.21 Picture card — owl

`assets/images/greek/muses_letters/picture_owl.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a cute little brown owl with big golden eyes, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.22 Picture card — pig

`assets/images/greek/muses_letters/picture_pig.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a cute pink pig, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.23 Picture card — queen

`assets/images/greek/muses_letters/picture_queen.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a kind smiling queen wearing a golden crown, head and shoulders, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.24 Picture card — ring

`assets/images/greek/muses_letters/picture_ring.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a simple golden ring with one blue gem, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.25 Picture card — sun

`assets/images/greek/muses_letters/picture_sun.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a bright smiling yellow sun, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.26 Picture card — tree

`assets/images/greek/muses_letters/picture_tree.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a round green tree with a brown trunk, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.27 Picture card — umbrella

`assets/images/greek/muses_letters/picture_umbrella.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: an open red umbrella, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.28 Picture card — vase

`assets/images/greek/muses_letters/picture_vase.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a Greek terracotta vase with a black meander band, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.29 Picture card — whale

`assets/images/greek/muses_letters/picture_whale.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a friendly blue whale spouting water, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.30 Picture card — box (for the sound x at the end of a word)

`assets/images/greek/muses_letters/picture_box.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a closed wooden box, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.31 Picture card — yak

`assets/images/greek/muses_letters/picture_yak.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a cute shaggy brown yak, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C3.32 Picture card — zebra

`assets/images/greek/muses_letters/picture_zebra.png` — 512 × 512, PNG, transparent background

**Prompt:**

```text
A picture card object for a children's reading game: a cute zebra, one single object only, simple bold shapes, easy to recognise, centred, filling most of the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

## C4. Odysseus' Voyage (Geography, later)

### C4.1 Sea tile

`assets/images/greek/odysseus_voyage/sea_tile.png` — 256 × 256, PNG

**Prompt:**

```text
A square tile of calm turquoise sea seen from directly above, with a few small soft white wave marks, seamless so that it tiles perfectly on all four edges, no objects. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.2 Island tile 1 — sandy island

`assets/images/greek/odysseus_voyage/island_tile_1.png` — 256 × 256, PNG

**Prompt:**

```text
A square map tile seen from directly above: a small round sandy island with one palm-like shrub in the middle, surrounded by calm turquoise sea that reaches all four edges of the tile and matches a plain turquoise sea tile seamlessly. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.3 Island tile 2 — olive island

`assets/images/greek/odysseus_voyage/island_tile_2.png` — 256 × 256, PNG

**Prompt:**

```text
A square map tile seen from directly above: a small green island with one olive tree and a sandy edge in the middle, surrounded by calm turquoise sea that reaches all four edges of the tile and matches a plain turquoise sea tile seamlessly. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.4 Island tile 3 — rocky island

`assets/images/greek/odysseus_voyage/island_tile_3.png` — 256 × 256, PNG

**Prompt:**

```text
A square map tile seen from directly above: a small grey rocky island with a few seagulls in the middle, surrounded by calm turquoise sea that reaches all four edges of the tile and matches a plain turquoise sea tile seamlessly. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.5 Island tile 4 — temple island

`assets/images/greek/odysseus_voyage/island_tile_4.png` — 256 × 256, PNG

**Prompt:**

```text
A square map tile seen from directly above: a small green island with a tiny white temple in the middle, surrounded by calm turquoise sea that reaches all four edges of the tile and matches a plain turquoise sea tile seamlessly. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.6 Ship facing up

`assets/images/greek/odysseus_voyage/ship_up.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
A small ancient Greek wooden ship with a red and white striped sail and a few oars, seen from directly above, its bow pointing up, towards the top of the image, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.7 Ship facing down

`assets/images/greek/odysseus_voyage/ship_down.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
A small ancient Greek wooden ship with a red and white striped sail and a few oars, seen from directly above, its bow pointing down, towards the bottom of the image, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.8 Ship facing left

`assets/images/greek/odysseus_voyage/ship_left.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
A small ancient Greek wooden ship with a red and white striped sail and a few oars, seen from directly above, its bow pointing to the left, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.9 Ship facing right

`assets/images/greek/odysseus_voyage/ship_right.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
A small ancient Greek wooden ship with a red and white striped sail and a few oars, seen from directly above, its bow pointing to the right, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.10 Home island (Ithaca)

`assets/images/greek/odysseus_voyage/home_island.png` — 512 × 512, PNG

**Prompt:**

```text
A square map tile seen from directly above: the island of Ithaca with a small white palace with a red roof, a little harbour and olive trees in the middle, surrounded by calm turquoise sea that reaches all four edges. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### C4.11 Arrow button

`assets/images/greek/odysseus_voyage/arrow_button.png` — 256 × 256, PNG, transparent background

**Prompt:**

```text
A big round wooden button with a thick white arrow carved on it pointing up, a gold rim, seen from the front, centred. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```
