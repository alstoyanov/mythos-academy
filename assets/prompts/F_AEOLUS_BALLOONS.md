# Image prompts — Part F: Aeolus' Balloons

The fourth arithmetic mini game (specification §5.2b): a row of numbered balloons on Aeolus' rope, put in order by swapping neighbours. The balloons, the rope and the plain sky gradient are drawn by the game, so it needs only **two** pictures, both optional: the game works without them and uses each as soon as it exists. Save the background in `assets/images/greek/aeolus_balloons/` and the game card in `assets/images/greek/`.

[All image prompts](IMAGE_PROMPTS.md)

- Copy the **Prompt** as it is: it is complete, nothing needs to be filled in.
- Save the picture under the file name given; the game uses it as soon as it exists.
- Sizes are what the game expects. A larger picture of the same shape (aspect ratio) is fine; the game scales it down.

| Picture | Step (`python tools/prepare_art.py KIND SOURCE TARGET …`) |
|---|---|
| F.1 background | `cover … 1920 1080` (save as .jpg or .png) |
| F.2 game card | `cover … 1024 512` (save as .jpg) |

---

### F.1 Background — Aeolus' windy sky

`assets/images/greek/aeolus_balloons/background.png` — 1920 × 1080, PNG or JPG

**Prompt:**

```text
Create image of a bright, friendly, windy sky high above ancient Greece, as the backdrop of a children's counting game, in a wide 16:9 landscape format, 1920 x 1080. A clear light-blue sky that gets paler toward the bottom, with soft white swirling clouds drawn as gentle curls and spirals, as if a kind wind were blowing through them, and a few tiny white birds far away; at the very bottom edge a thin strip of distant green hills and a little white marble temple with a terracotta roof, seen from afar, very small. The picture must be calm and empty in its middle: the top 20 percent is a plain soft sky with almost no clouds, because a title banner will lie there; the whole middle band, from 25 to 75 percent of the height, is open, quiet sky with only very faint, pale clouds, because a row of coloured balloons on a rope will hang there and must stand out clearly; the lowest 25 percent is calm too, because buttons will lie over it. Style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, bright but not neon colours, soft daylight from the top left, a touch of ancient Greek decoration only as a faint meander pattern in the clouds. Do not include any balloons, ropes, people, gods, animals other than the tiny distant birds, text, letters, numbers, logos, watermarks or signatures. Do not make it dark, gloomy, scary, photorealistic, 3D, busy or cluttered, and avoid harsh shadows and neon colours.
```

### F.2 Game card — Aeolus' Balloons

`assets/images/greek/game_aeolus_balloons.jpg` — 1024 × 512, JPG

The picture on the game's card in the list of the Agora of Numbers (like the cards of the other games).

**Prompt:**

```text
Create image of the game card picture for "Aeolus' Balloons", a children's number-ordering game set in ancient Greece, in a wide 2:1 format, 1024 x 512. Aeolus, the keeper of the winds, drawn as a kind, cheerful, grandfatherly figure with a curly white beard, rosy puffed cheeks and a friendly smile, in a pastel blue tunic with a golden belt, floating among soft white clouds on the left and blowing a gentle breeze with his cheeks puffed out. On the right, a neat row of eight round, glossy balloons of different sizes, from small to big, in bright colours (red, orange, yellow, green, teal, blue, purple, pink), tied with thin strings to a brown rope that sways in the wind; the balloons are plain, with no numbers or letters on them. A clear light-blue sky with swirling white clouds behind, and a tiny white marble temple on a distant hill at the bottom. Cheerful, simple composition with clear silhouettes that read well at small size. Style: hand-painted children's storybook illustration, soft gouache and watercolour texture, warm and friendly, gentle rounded shapes, bright but not neon colours, soft daylight from the top left. Do not include any text, letters, numbers, logos, watermarks or signatures. Do not make it dark, scary, photorealistic, 3D, busy or cluttered, and avoid harsh shadows and neon colours.
```
