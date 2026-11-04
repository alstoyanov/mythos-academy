# Image prompts — Part G: Hercules' Leaps

The fifth arithmetic mini game (specification §5.2c): Hercules leaps from cliff to numbered cliff, and the child finds the sign and the number that take him there. Done: all seven are in the game (made 2026-11-04). Save them in `assets/images/greek/hercules_leaps/` (the game card in `assets/images/greek/`).

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** as it is: it is complete, nothing needs to be filled in.
- Save the picture under the file name given; the game uses it as soon as it exists.
- Sizes are what the game expects. A larger picture of the same shape (aspect ratio) is fine; the game scales it down.
- The clay tablets with the numbers and the + and − are the tablet of Olive Harvest (C1.12, `olive_harvest/number_tablet.png`), already made: the game writes on them. No picture has numbers of its own.

How to turn each generated picture into the game's file (`python tools/prepare_art.py KIND SOURCE TARGET …`):

| Picture | Step |
|---|---|
| G.1 background | `cover … 1920 1080` (save as .jpg) |
| G.2–G.5 Hercules | `figure … 768 768 SCALE CX - - - GAPS`, SCALE and CX chosen per pose: CX is the middle of his feet, and SCALE balances the size of his head against his height (with equal heads he would grow as he lands, his body being drawn longer in the happy pose). Used: ready `0.378 1023 - - - 1261,1088` (the gap between arm and body), leaping `0.378 1020`, happy `0.3425 869`, thinking `0.3185 959 - - - 1027,859` (the gap between hand and neck) |
| G.6 cliff | `cutout … 556 1024` (the shape of the rock itself, so it fills the picture). The game puts the middle of the grass at 8.06% down the picture (`LeapStone.TOP_IN_PICTURE`): another picture needs that number measured again |
| G.7 game card | `cover … 1024 512` (save as .jpg) |

---

### G.1 Background — the sky above the chasms

`assets/images/greek/hercules_leaps/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
Create image of a bright, friendly mountain landscape in ancient Greece, as the backdrop of a children's number game, in a wide 16:9 landscape format, 1920 x 1080, with nothing in the foreground. A clear light-blue sky with a few soft white clouds fills the upper half; across the middle, far away and pale, a range of soft blue-green mountains with a tiny white marble temple on one distant peak; the lower third fades into a deep valley full of soft, pale, sunlit morning mist in lavender and cream, gentle and dreamy, with no visible bottom. The whole picture is calm and low in contrast, because rocky cliffs, a hero and number tablets will be placed in front of it and must stand out clearly: keep the top 20 percent almost empty sky, and do not paint any cliff, ledge, ground, path or bridge near the viewer. Style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, bright but not neon colours, soft daylight from the top left. Do not include any people, animals, text, letters, numbers, logos, watermarks or signatures. Do not make it dark, gloomy, scary, dizzying, photorealistic, 3D, busy or cluttered, and avoid harsh shadows and neon colours.
```

### G.2 Hercules — ready

`assets/images/greek/hercules_leaps/hercules_idle.png` — 1024 × 1024, on a plain white background

**Prompt:**

```text
Create image of young Hercules, the Greek hero, drawn as a cheerful, friendly boy-like hero for young children, in a square format, 1024 x 1024, shown full body from head to feet, standing in the middle of the picture on a plain pure white background, with his feet near the bottom edge and a little room above his head. He has a round kind face with rosy cheeks, big warm brown eyes, short curly dark-brown hair, sturdy rounded arms and legs, a short terracotta-red tunic with a thin golden belt, a golden-yellow lion's pelt worn like a soft little cape over one shoulder with a sweet, smiling lion's face on it, and simple brown leather sandals. Pose: standing ready and alert, turned three-quarters toward the right side of the picture, knees slightly bent and fists at his hips, looking to the right with a confident, happy smile, as if about to jump. Style: hand-painted children's storybook character design, soft gouache and watercolour texture, warm and gentle, rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not give him a club, a sword or any weapon. Do not include any ground, shadow, scenery, text, letters, numbers, logos, watermarks or signatures. Do not make him scary, muscular like an adult bodybuilder, photorealistic or 3D, and do not use white in his clothes.
```

### G.3 Hercules — leaping

`assets/images/greek/hercules_leaps/hercules_jump.png` — 1024 × 1024, on a plain white background

**Prompt:**

```text
Create image of young Hercules, the Greek hero, drawn as a cheerful, friendly boy-like hero for young children, in a square format, 1024 x 1024, shown full body in the middle of the picture on a plain pure white background, with a little room around him. He has a round kind face with rosy cheeks, big warm brown eyes, short curly dark-brown hair, sturdy rounded arms and legs, a short terracotta-red tunic with a thin golden belt, a golden-yellow lion's pelt worn like a soft little cape over one shoulder with a sweet, smiling lion's face on it, and simple brown leather sandals. Pose: in the middle of a great joyful leap toward the right side of the picture, seen from the side, front leg stretched forward and back leg bent behind him like a long jumper, both arms reaching forward and up, the lion's pelt flying out behind him, his mouth open in a delighted laugh, looking to the right. Style: hand-painted children's storybook character design, soft gouache and watercolour texture, warm and gentle, rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not give him a club, a sword or any weapon. Do not include any ground, shadow, motion lines, scenery, text, letters, numbers, logos, watermarks or signatures. Do not make him scary, muscular like an adult bodybuilder, photorealistic or 3D, and do not use white in his clothes.
```

### G.4 Hercules — happy

`assets/images/greek/hercules_leaps/hercules_happy.png` — 1024 × 1024, on a plain white background

**Prompt:**

```text
Create image of young Hercules, the Greek hero, drawn as a cheerful, friendly boy-like hero for young children, in a square format, 1024 x 1024, shown full body from head to feet, standing in the middle of the picture on a plain pure white background, with his feet near the bottom edge and a little room above his raised hands. He has a round kind face with rosy cheeks, big warm brown eyes, short curly dark-brown hair, sturdy rounded arms and legs, a short terracotta-red tunic with a thin golden belt, a golden-yellow lion's pelt worn like a soft little cape over one shoulder with a sweet, smiling lion's face on it, and simple brown leather sandals. Pose: facing the viewer, both feet on the ground, both fists raised high in the air in triumph, with a huge happy smile and his eyes bright, celebrating a landing. Style: hand-painted children's storybook character design, soft gouache and watercolour texture, warm and gentle, rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not give him a club, a sword or any weapon. Do not include any ground, shadow, confetti, scenery, text, letters, numbers, logos, watermarks or signatures. Do not make him scary, muscular like an adult bodybuilder, photorealistic or 3D, and do not use white in his clothes.
```

### G.5 Hercules — thinking

`assets/images/greek/hercules_leaps/hercules_think.png` — 1024 × 1024, on a plain white background

**Prompt:**

```text
Create image of young Hercules, the Greek hero, drawn as a cheerful, friendly boy-like hero for young children, in a square format, 1024 x 1024, shown full body from head to feet, standing in the middle of the picture on a plain pure white background, with his feet near the bottom edge and a little room above his head. He has a round kind face with rosy cheeks, big warm brown eyes, short curly dark-brown hair, sturdy rounded arms and legs, a short terracotta-red tunic with a thin golden belt, a golden-yellow lion's pelt worn like a soft little cape over one shoulder with a sweet, smiling lion's face on it, and simple brown leather sandals. Pose: turned three-quarters toward the right side of the picture, standing calmly with one finger on his chin and the other hand on his hip, his head a little tilted, eyes looking up and to the right, with a small thoughtful and still hopeful smile, working something out; he is not sad and not worried. Style: hand-painted children's storybook character design, soft gouache and watercolour texture, warm and gentle, rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not give him a club, a sword or any weapon. Do not include any ground, shadow, question marks, thought bubbles, scenery, text, letters, numbers, logos, watermarks or signatures. Do not make him scary, muscular like an adult bodybuilder, photorealistic or 3D, and do not use white in his clothes.
```

### G.6 A cliff

`assets/images/greek/hercules_leaps/cliff.png` — 768 × 1024, on a plain white background

The game uses this one picture for every cliff and writes the number on a clay tablet in its upper middle.

**Prompt:**

```text
Create image of a single tall pillar of rock, a friendly cliff for a children's game, in a tall 3:4 portrait format, 768 x 1024, seen straight from the front, standing alone in the middle of the picture on a plain pure white background. Its top is perfectly flat and level, a neat strip of bright green grass with a few tiny red and yellow flowers, very close to the top edge of the picture and reaching almost the full width of the picture. Below the grass is warm honey-coloured sandstone in big soft rounded blocks, with a few gentle cracks and small tufts of green; the rock is about as wide at the bottom as at the top, and it runs straight down and off the bottom edge of the picture, with no base and no ground. The front of the rock is smooth and calm in its upper middle, with no details there, because a clay tablet will be placed on it. Style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, a clear silhouette that reads well at small size, bright but not neon colours, soft daylight from the top left. Do not include any people, animals, trees, signs, tablets, carvings, text, letters, numbers, logos, watermarks or signatures. Do not include any sky, background scenery or shadow on the white. Do not make it dark, jagged, scary, photorealistic or 3D, and do not use pure white anywhere on the rock.
```

### G.7 Game card — Hercules' Leaps

`assets/images/greek/game_hercules_leaps.jpg` — 1024 × 512, JPG

The picture on the game's card in the list of the Agora of Numbers (like the cards of the other games).

**Prompt:**

```text
Create image of the game card picture for "Hercules' Leaps", a children's arithmetic game set in ancient Greece, in a wide 2:1 format, 1024 x 512. Young Hercules, drawn as a cheerful, friendly boy-like hero with a round kind face, rosy cheeks, short curly dark-brown hair, a short terracotta-red tunic with a thin golden belt, a golden-yellow lion's pelt flying behind him like a little cape with a sweet, smiling lion's face on it, and brown leather sandals, is caught in the middle of a great joyful leap from left to right, laughing, across a chasm between two tall pillars of honey-coloured sandstone with flat green grassy tops, one at the left edge and one at the right. Each pillar has a blank, plain terracotta clay tablet set into its front, with nothing written on it. Behind him a clear light-blue sky with soft white clouds, pale blue-green mountains far away with a tiny white marble temple on a peak, and a soft sunlit lavender mist deep in the valley below. Cheerful, simple composition with clear silhouettes that read well at small size. Style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, bright but not neon colours, soft daylight from the top left. Do not give him a club, a sword or any weapon. Do not include any text, letters, numbers, logos, watermarks or signatures. Do not make it dark, scary, dizzying, photorealistic, 3D, busy or cluttered, and avoid harsh shadows and neon colours.
```
