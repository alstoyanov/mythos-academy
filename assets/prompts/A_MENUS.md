# Image prompts — Part A: the menus

Everything the menus use: the title screen, the world map and its markers, the map of Ancient Greece with its area emblems, the area backgrounds, the game cards, Glaux the owl and the app icon. (Done: these pictures are in the game.)

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** (and, if the tool has a field for it, the **Negative prompt**) as it is: nothing needs to be filled in.
- Save the picture under the file name given, in the game's folder; the game uses it as soon as it exists (until then it draws a stand-in), so pictures can be made one at a time and in any order.
- Every prompt already contains the shared style (hand-painted storybook, gouache and watercolour, warm Greek palette), so all pictures match.
- Pictures marked *transparent background* need one. If the tool paints a plain white background instead, that is fine: `tools/prepare_art.py` cuts the subject out.
- Sizes are what the game expects. A larger picture of the same shape (aspect ratio) is fine; the game scales it down.

---

- The two maps place their landmarks where the game puts its markers. If a generated map puts a landmark somewhere else, either generate again or move the marker: its `map_pos` in `data/mythologies.json` or `data/realms/greek.json` (0 to 1 across and down the map).
- Only the two logos contain words. Image generators often misspell, Cyrillic letters most of all; if they do, generate the logo again. Until there is a Bulgarian logo, the game writes its name in Bulgarian instead.

### A.1 Title screen background

`assets/images/ui/title_background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A wide sunny landscape of ancient Greece seen from a grassy hill: a calm turquoise sea with three small islands, a white marble temple with columns on a green hill to the right, silver-green olive trees in the foreground at the left and right edges, a few fluffy white clouds, a little owl flying far away in the sky. Keep a large area of soft, open, calm sky and sea in the middle and upper middle of the picture, because a title and buttons will be placed there. Warm morning light, wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.2 Logo

`assets/images/ui/logo.png` — 1280 × 400, PNG, transparent background

**Prompt:**

```text
Game logo for a children's educational game. The words "Mythos Academy" written once, spelled exactly M-Y-T-H-O-S A-C-A-D-E-M-Y, in friendly rounded classical Greek-style capital letters, gold with a dark brown outline, on a white marble banner with gently curled ends, a small green laurel wreath behind the banner, and a small cute owl with big golden eyes perched on the left end of the banner, a thin gold meander border along the banner. Wide horizontal composition, centred, nothing else in the image. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left.
```

**Negative prompt:**

```text
watermark, signature, misspelled words, extra letters, photorealistic, 3D render, dark, scary, clutter, harsh shadows, neon colours, blurry
```

### A.3 Logo — Bulgarian (new)

`assets/images/ui/logo_bg.png` — 1280 × 400, PNG, transparent background

**Prompt:**

```text
Game logo for a children's educational game, in Bulgarian. The words "АКАДЕМИЯ МИТОС" written once in Cyrillic capital letters, spelled exactly А-К-А-Д-Е-М-И-Я М-И-Т-О-С, in friendly rounded classical Greek-style letters, gold with a dark brown outline, on a white marble banner with gently curled ends, a small green laurel wreath behind the banner, and a small cute owl with big golden eyes perched on the left end of the banner, a thin gold meander border along the banner. Wide horizontal composition, centred, nothing else in the image. The same design as the English logo with the words "MYTHOS ACADEMY", only the words changed. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left.
```

**Negative prompt:**

```text
watermark, signature, misspelled words, extra letters, photorealistic, 3D render, dark, scary, clutter, harsh shadows, neon colours, blurry
```

### A.4 Glaux the owl — waving (main pose)

`assets/images/ui/mascot_owl.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
Glaux, a small cute owl who is the little owl of the goddess Athena: big round friendly golden eyes, soft brown and cream feathers, a tiny crown of olive leaves, a little Aegean-blue scarf around the neck. Standing and waving one wing hello, full body, facing the viewer, centred. Children's storybook character design, appealing and kind. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.5 Glaux the owl — cheering

`assets/images/ui/mascot_owl_happy.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
Glaux, a small cute owl who is the little owl of the goddess Athena: big round friendly golden eyes, soft brown and cream feathers, a tiny crown of olive leaves, a little Aegean-blue scarf around the neck. Jumping with joy with both wings raised high, eyes happily closed in a big smile, a few small golden sparkles around, full body, facing the viewer, centred. Children's storybook character design. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.6 Glaux the owl — pointing

`assets/images/ui/mascot_owl_point.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
Glaux, a small cute owl who is the little owl of the goddess Athena: big round friendly golden eyes, soft brown and cream feathers, a tiny crown of olive leaves, a little Aegean-blue scarf around the neck. Standing turned slightly to the right and pointing to the right with one outstretched wing, looking at the viewer with an encouraging smile, full body, centred. Children's storybook character design. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.7 Glaux the owl — thinking

`assets/images/ui/mascot_owl_think.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
Glaux, a small cute owl who is the little owl of the goddess Athena: big round friendly golden eyes, soft brown and cream feathers, a tiny crown of olive leaves, a little Aegean-blue scarf around the neck. Standing with the tip of one wing touching the chin, head tilted, looking up thoughtfully, full body, facing the viewer, centred. Children's storybook character design. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.8 Glaux the owl — flying

`assets/images/ui/mascot_owl_fly.png` — 1024 × 1024, PNG, transparent background

**Prompt:**

```text
Glaux, a small cute owl who is the little owl of the goddess Athena: big round friendly golden eyes, soft brown and cream feathers, a tiny crown of olive leaves, a little Aegean-blue scarf fluttering behind. Flying to the right, side view, both wings spread wide, happy face turned towards the viewer, whole bird visible, centred. Children's storybook character design. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.9 World map

`assets/images/world/world_map.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A charming illustrated storybook map of the ancient world from Europe to China, seen from directly above, painted on warm aged parchment, wide 16:9 composition. Layout, measured as fractions of the image width and height from the top left: Scandinavia with pine forests and a small Viking longship around 27% across and 22% down; the Greek peninsula with a tiny white temple around 43% across and 38% down; the Mediterranean Sea as a large soft blue sea in the middle left; North Africa below it with the river Nile and three small pyramids around 52% across and 62% down; Mesopotamia between two rivers with a small ziggurat around 64% across and 45% down; the Indian peninsula with a pink lotus and a small elephant around 79% across and 60% down; China at the far right with a small pagoda and a piece of the Great Wall around 92% across and 38% down. Simplified friendly coastlines with a soft brown outline, blue seas with little painted waves, a sea turtle and a dolphin, a compass rose in the lower left corner, a thin gold meander border around the edge. All landmarks small and simple so that round markers can be placed on top of them. No labels. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.10 World map marker — Ancient Greece

`assets/images/world/marker_greek.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a white owl's face with big golden eyes and a small green olive branch beneath it. The medallion's main colour is Aegean blue. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.11 World map marker — Ancient Egypt

`assets/images/world/marker_egyptian.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a golden ankh with a small red sun disc above it. The medallion's main colour is warm sand gold. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.12 World map marker — The Norse Lands

`assets/images/world/marker_norse.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a small wooden Viking longship with a striped sail riding a white wave. The medallion's main colour is steel blue-grey. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.13 World map marker — Mesopotamia

`assets/images/world/marker_mesopotamian.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a stepped clay ziggurat with a small golden eight-pointed star above it. The medallion's main colour is terracotta orange-brown. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.14 World map marker — Ancient India

`assets/images/world/marker_indian.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a pink lotus flower with green leaves. The medallion's main colour is saffron orange. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.15 World map marker — Ancient China

`assets/images/world/marker_chinese.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a friendly coiled golden dragon with a curly beard and a pearl. The medallion's main colour is lacquer red with gold. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.16 Map of Ancient Greece

`assets/images/greek/realm_map.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A charming illustrated storybook map of ancient Greece seen from directly above, painted on warm parchment, wide 16:9 composition. Layout, measured as fractions of the image width and height from the top left: the Greek mainland fills the upper left half; the Peloponnese peninsula is in the lower left, joined to the mainland by a narrow isthmus; the Aegean Sea with five or six small islands fills the right side. Small painted landmarks: Mount Helicon, a green mountain with a laurel grove and a little spring, around 42% across and 30% down; Athens with the Acropolis hill and a small market square with striped stalls around 56% across and 52% down, on the east coast of the mainland; Olympia on the Peloponnese with a white temple under construction and wooden scaffolding around 30% across and 70% down; an island with a small harbour and a sailing ship with a striped sail around 80% across and 42% down. Also olive groves, a few goats, dolphins and a little boat in the sea, a compass rose in the lower right corner, a thin gold meander border around the edge. All landmarks small and simple so that round markers can be placed on top of them. No labels. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.17 Area emblem — Arithmetic

`assets/images/greek/area_arithmetic.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a woven basket full of shiny green olives with three single olives lined up in front of it. The medallion's main colour is golden orange. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.18 Area emblem — Geometry

`assets/images/greek/area_geometry.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: the front of a small white Greek temple built from simple shapes: a triangle roof, rectangle columns and a square base. The medallion's main colour is olive green. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.19 Area emblem — Geography

`assets/images/greek/area_geography.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a small ancient Greek ship with a red and white striped sail and a small gold compass star above it. The medallion's main colour is sea blue. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.20 Area emblem — Language

`assets/images/greek/area_language.png` — 512 × 512, PNG, transparent background outside the circle

**Prompt:**

```text
A round medallion emblem seen flat from the front, centred, filling the whole square image edge to edge as a circle, with a thick soft painted rim in a slightly darker shade of the main colour, and one simple bold symbol in the middle that is easy to recognise even when very small: a golden lyre with a rolled cream scroll leaning against it. The medallion's main colour is violet purple. Flat, simple, bold, like a badge. Isolated on a fully transparent background, no ground shadow, no scenery. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.21 Area background — Arithmetic — the Agora of Numbers

`assets/images/greek/area_arithmetic_background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
The Agora, the market square of ancient Athens, on a sunny morning. Market stalls with red and cream striped awnings stand along the left and right edges of the picture, with amphorae, baskets of olives and figs and round loaves of bread; an olive tree at the far left; the Acropolis with its white temple small in the distance at the top. The middle of the picture is a calm, open, softly lit stone-paved square with little detail, because cards will be placed there. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.22 Area background — Geometry — the Temple Builders

`assets/images/greek/area_geometry_background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A sunny building site at Olympia in ancient Greece. At the left edge a half-built white marble temple with wooden scaffolding; at the right edge stacks of carved stone blocks in different simple shapes and a small wooden handcart; tall cypress trees and soft green hills in the distance under a blue sky. The middle of the picture is open sandy ground with little detail, because cards will be placed there. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.23 Area background — Geography — the Islands of Odysseus

`assets/images/greek/area_geography_background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
A sunny little harbour on a Greek island. At the right edge a wooden ancient Greek ship with a red and white striped sail moored at a stone pier; at the left edge small white houses with blue doors on rocks; white gulls; small islands on the horizon. The middle of the picture is calm turquoise water and soft sky with little detail, because cards will be placed there. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.24 Area background — Language — the Grove of the Muses

`assets/images/greek/area_language_background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
The Grove of the Muses on Mount Helicon: laurel trees along the left and right edges, a little spring with a small waterfall at the right, rolled scrolls and a golden lyre resting on a white marble bench at the left, butterflies, soft green-golden light through the leaves. The middle of the picture is an open sunny grassy glade with little detail, because cards will be placed there. Wide 16:9 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.25 Game card — Olive Harvest

`assets/images/greek/game_olive_harvest.png` — 1024 × 512, PNG or JPG

**Prompt:**

```text
A happy little owl with big golden eyes dropping shiny green and black olives into a woven wicker basket under a silver-green olive tree, a market stall with a striped awning softly in the background. One clear subject, big simple shapes, wide 2:1 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.26 Game card — Temple Builder

`assets/images/greek/game_temple_builder.png` — 1024 × 512, PNG or JPG

**Prompt:**

```text
A small white Greek temple, half finished, with big smooth building stones shaped like a triangle, a square, a circle and a rectangle lying in front of it ready to fit into the gaps, a sunny sky. One clear subject, big simple shapes, wide 2:1 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.27 Game card — The Muses' Letters

`assets/images/greek/game_muses_letters.png` — 1024 × 512, PNG or JPG

**Prompt:**

```text
A kind young Muse of Greek myth with a flower crown and a light pastel dress, smiling and holding a golden lyre, beside her a laurel branch with several small blank clay tablets hanging from it on strings, the tablets have nothing written on them. One clear subject, big simple shapes, wide 2:1 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.28 Game card — Odysseus' Voyage

`assets/images/greek/game_odysseus_voyage.png` — 1024 × 512, PNG or JPG

**Prompt:**

```text
A small ancient Greek ship with a red and white striped sail seen from above, sailing on a turquoise sea between three small sandy islands, a dotted white path line on the water behind the ship. One clear subject, big simple shapes, wide 2:1 composition. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```

### A.29 App icon

`assets/images/ui/app_icon.png` — 1024 × 1024, PNG, no transparency (full square)

**Prompt:**

```text
App icon: the face and shoulders of Glaux, a small cute owl with big round golden eyes, soft brown and cream feathers and a tiny crown of olive leaves, large and centred so that the owl fits inside the middle two thirds of the image, on a bright Aegean-blue background that fills the whole square, with a soft gold meander ring behind the owl. Very simple and bold, readable at 48 pixels. Hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, clear silhouettes that read well at small size, bright but not neon colours, soft daylight from the top left, ancient Greek motifs (meander borders, olive branches, white marble, terracotta). No text, no letters, no numbers, no watermark, no signature.
```

**Negative prompt:**

```text
text, letters, words, numbers, watermark, logo, signature, photorealistic, 3D render, dark, gloomy, scary, violent, blood, weapons, monster teeth, horror, clutter, busy background, harsh shadows, neon colours, blurry
```
