# Mythos Academy — Specification

Version 0.3 · 2026-10-31 · Status: the menus (mythology and area selection) and the three arithmetic mini
games (Zeus' Thunderbolts, Olive Harvest, Demeter's Harvest) are built; the other mini games are proposals.

## 1. Vision

Mythos Academy is an educational game of short mini games for primary school children, set in the
world of myths. **Each school grade has its own mythology**, and inside it the children practise the
subjects of that grade (numbers, shapes, maps, letters) in mini games told as small adventures of
that mythology's heroes and places.

The child starts on a map of the ancient world, picks a land (a mythology), and in that land's own
map picks a place where a subject lives — the Agora of Athens for numbers, the temple builders of
Olympia for shapes, and so on. Each place holds a few mini games.

The first release is **Grade 1, in Ancient Greece**.

Goals:

- Learning first: every mini game practises one skill of the grade's curriculum, with a clear goal
  and immediate, kind feedback.
- No reading needed to play: a first grader may not read yet. Every instruction is also spoken, and
  every button also has a picture.
- Short and calm: a round lasts 2–4 minutes; there is no timer pressure and no losing — mistakes get
  a hint and another try.
- Myth as the setting, friendly: gods, heroes and creatures appear as kind guides and helpers. No
  frightening scenes for the young grades.
- Safe: offline, no ads, no in-app purchases, no accounts, no data leaving the device.

## 2. Audience and platforms

| | |
|---|---|
| Players | Children of 6–7 (Grade 1) first; later grades up to 11–12. A parent or teacher sets up the game. |
| Platforms | PC (Windows first; macOS and Linux need no extra work in Godot) and mobile (Android first, then iOS). Tablets and phones. |
| Orientation | Landscape. On phones and tablets the game turns with the device between the two landscape sides; on a PC the window can have any size and shape. |
| Input | Touch, mouse, and keyboard or gamepad focus (arrows/Tab to move, Enter to choose, Esc or Android Back to go back). |
| Engine | Godot 4.7, GDScript, the Compatibility renderer (runs on the widest range of phones and older PCs). |

## 3. Structure of the game

### 3.1 Grades and mythologies

One mythology per grade. The world map shows them all from the start; only the grades that are
built can be opened, the others are shown locked with "coming soon". The proposed order goes from
the most familiar myths to the less familiar, and roughly east across the old world:

| Grade | Mythology | Guide (proposal) | State |
|---|---|---|---|
| 1 | Ancient Greece | Glaux, the little owl of Athena | **this release** |
| 2 | Ancient Egypt | a young scribe and Thoth's ibis | locked |
| 3 | The Norse Lands | Huginn and Muninn, Odin's ravens | locked |
| 4 | Mesopotamia | a scribe of Uruk with a clay tablet | locked |
| 5 | Ancient India | a young elephant (Ganesha's helper) | locked |
| 6 | Ancient China | a jade rabbit from the Moon | locked |

The list is data (`data/mythologies.json`): adding a grade or changing the order needs no code.

### 3.2 Learning areas

Every mythology's map has the same four areas, each at a place of its myths:

| Area | Subject | In Ancient Greece (Grade 1) | Symbol |
|---|---|---|---|
| Arithmetic | numbers, counting, adding and taking away | **The Agora of Numbers** — the market of Athens | 1+2 |
| Geometry | shapes, sizes, patterns, positions | **The Temple Builders** — Olympia | Δ |
| Geography | directions, maps, land and water | **The Islands of Odysseus** — the Aegean Sea | N |
| Language | letters, sounds, words, reading | **The Grove of the Muses** — Mount Helicon | Aa |

More areas (e.g. science, music) can be added later per grade; an area is an entry in the realm's
data file.

### 3.3 Screens

```
Title screen ──Play──▶ World map ──open land──▶ Realm map ──area──▶ Area ──game──▶ Mini game (later)
     │                    │  locked land: "Grade N. Coming soon!"        │
     └─Settings (panel)   └──────────────◀── Back ◀────────────── Back ◀─┘
```

- **Back** is always the round "‹" button at the top left, Android's Back, or Esc. It goes to the
  screen before; on the title screen, Android's Back leaves the app.
- Every screen works at any window size: the maps keep their shape and fit inside the screen, the
  sea fills the rest; markers stay on their places.

## 4. The menus (built)

### 4.1 Title screen (`scenes/main_menu.tscn`)

- Background: the title picture (`assets/images/ui/title_background.png`); until it exists, the world
  map placeholder, faded.
- The logo (`ui/logo.png`) or, until it exists, the name "Mythos Academy" and the line "Learn and play
  with the heroes of myth" on a parchment panel. Glaux the owl (`ui/mascot_owl.png`) above it when
  the picture exists.
- **Play** — the largest button, focused at start — opens the world map.
- **Settings** opens a panel over the menu: Music (on/off; kept for when there is music), Sounds,
  Read aloud (instructions spoken with the device's text to speech, where it has a voice for the
  language), Full screen (PC only), and Language (Български, English). Done or Back closes it. The
  choices are saved (`user://settings.cfg`).
- **Quit** — PC only (a phone app is left with Home or Back).

Later (see §8): a **Parents** button behind a parental gate (hold for 3 seconds), with child
profiles, progress, and the language.

### 4.2 World map (`scenes/world_map.tscn`)

- The map of the ancient world (`world/world_map.png`, 16:9) with a marker for each mythology at its
  place (`map_pos` in the data, 0–1 across the map).
- A marker is a round badge in the mythology's colour with its emblem (`world/marker_<id>.png`; until
  then the grade number), and a plate under it with the land's name and "Grade N".
- An open land bobs gently and grows when pointed at or focused; tapping it opens its realm map.
- A locked land is grey with a padlock; tapping it shows "Ancient Egypt opens in Grade 2. Coming
  soon!" for a few seconds (later also spoken by the guide).
- The banner at the top says "Choose a land to explore".

### 4.3 Realm map (`scenes/realm_map.tscn`) — Ancient Greece

- The map of the land (`greek/realm_map.png`): the Greek mainland, the Peloponnese and the Aegean
  islands, with a marker for each area at its place (Helicon, Athens, Olympia, the islands).
- Area markers: the area's colour, its emblem (`greek/area_<id>.png`; until then its symbol), the
  subject and the place's name.
- Banner: "Ancient Greece — Grade 1 · Choose a place to learn".
- Later: Glaux flies to the chosen place before the area opens, and greets the child on first visit.

### 4.4 Area (`scenes/area.tscn`)

- The area's background picture (`greek/area_<id>_background.png`; until then a wash of its colour).
- Banner: the subject and the place ("Arithmetic — The Agora of Numbers · The market of Athens").
- A card per mini game: its picture (`greek/game_<id>.png`; until then a tile of the area's colour with
  its symbol), its name, the skill it practises, one line about it, and a button: "Play" for a built
  game (status `ready`, with its `scene`), which opens it; otherwise "Coming soon" (or "Coming later"),
  which only shows a message.
- Later: the stars won so far on each card.

## 5. Grade 1 mini games

The three arithmetic games are built (§5.1, §5.2, §5.2a). The others are proposals: two more mini
games, then one for geography. They will share one frame (§6): a few levels, a spoken
instruction, no timer, a hint after a mistake, up to 3 laurel stars per level.

The skills follow the usual Grade 1 goals (e.g. the Common Core and most European curricula):
numbers to 20, comparing numbers, adding and taking away to 20, naming flat shapes, letter sounds.

### 5.1 Zeus' Thunderbolts — Arithmetic, the Agora of Numbers (built)

*Clouds are gathering over Mount Olympus. Help Zeus strike the cloud with the biggest number — or
the smallest!*

- **Skill:** comparing numbers: which is the biggest, which is the smallest, of 2 to 4 numbers.
- **Play:** Zeus stands on Olympus at the lower left. Each round, 2–4 clouds float in, each with a
  different number. The instruction at the top says (and reads aloud) "Hit the BIGGEST number!" or
  "Hit the SMALLEST number!", with a picture: a pile of five coins for biggest, one coin for
  smallest. The child taps a cloud; Zeus throws a thunderbolt at it.
  - The right cloud bursts into sparks, the score goes up by one, Zeus cheers ("Great!", "Well
    done!", …) and new clouds come.
  - A wrong cloud only wobbles; Zeus encourages ("Almost! Look for the biggest number."). Nothing is
    taken away, and after two wrong taps in a round the right cloud glows.
- **Changing the goal:** every 3 rounds the goal switches between biggest and smallest; a big
  message announces it ("Now find the SMALLEST number!") before the clouds come.
- **Growing gently** with the score: 2 clouds and numbers 1–10 to start; up to 3 clouds from 3
  points, up to 4 from 8; numbers up to 20 from 15 points. Every 10 points Zeus celebrates.
- **Timed rounds:** the game starts with a choice of 1, 2 or 3 minutes, each showing its best score
  ("Рекорд"). The clock is under the score; it stops while a new goal is announced, and in the last 10
  seconds it turns orange and ticks. When the time is up the score is shown, with a fanfare, and
  "New best!" if it beats the best for that length; then Play again or Change time.
- **Score:** a laurel badge in the top right corner; it only ever goes up. The best score of each
  length is kept on the device (`user://progress.cfg`). Back returns to the area.
- **Sounds:** a zap as Zeus throws, a sparkle as the right cloud bursts, a soft knock for a wrong one
  (never a "wrong" buzz), a whoosh as new clouds come, ticks in the last seconds, a fanfare at the end.
- **Built:** `scenes/games/zeus_thunderbolts.tscn` (`scripts/games/zeus_thunderbolts.gd`, the clouds in
  `number_cloud.gd`, the rules in `thunderbolt_rules.gd`). Its pictures are in
  `assets/prompts/B_ZEUS_THUNDERBOLTS.md`; until they exist, Zeus, the sky, the clouds and the thunderbolt
  are drawn.
- **Later:** recorded voice, a real thunder sound, stars for the game card.

### 5.2 Olive Harvest — Arithmetic, the Agora of Numbers (built)

*A merchant at his stall in the Agora of Athens needs olives. Fill his baskets with exactly the
olives he asks for.*

- **Skill:** counting objects to 20; matching a number and a quantity; adding and taking away within
  10; tens and ones to 20.
- **Levels** (chosen at the start; all open, each with its best stars). A level is 10 orders:
  1. **Count the olives** (1–5, then up to 10): the order is a number on a clay tablet and in words
     ("5 маслини, моля!"). Tap the olive tree to drop an olive into the basket (it is counted aloud as
     it lands), tap the basket to take one out, then **Done**.
  2. **Find the basket:** three baskets with different numbers of olives; tap the one asked for.
  3. **Add the olives:** "3 olives and 2 more. How many altogether?" — two baskets with a big +
     between them, three number tablets to choose from (sums up to 10).
  4. **The hungry goat:** a basket of 4–10 olives; the goat walks in and eats 1–5 of them, one by
     one; how many are left? (three tablets; at least two are left).
  5. **Up to 20:** orders of 11–20; the olives sit in rows of ten; a **10 olives** button drops a whole
     row, the tree one at a time.
- **Forgiving:** nothing is ever taken away. A wrong answer makes the piece wobble and the merchant
  think: "Let's count together!" — each olive is marked with its number and read aloud (at level 5 a
  full row counts as "10" at once), then "We have 6. The merchant wants 7." (or "This basket has…",
  "That makes…", "… are left"), and the child tries again. After two wrong answers in an order the
  right one glows.
- **Coins and stars:** each order done pays a coin (it flies from the merchant to the counter,
  "3 / 10"). Ten coins finish the level: "All the baskets are full!" with stars for the orders right
  at the first try (8 or more: 3 stars, 5 or more: 2, else 1 — never none), a fanfare, "New best!"
  when it beats the level's best, and Play again / Next level / Choose a level.
- **Sounds:** an olive landing, one taken out, a tick per olive counted, the goat munching, a coin.
- **Built:** `scenes/games/olive_harvest.tscn` (`scripts/games/olive_harvest.gd`; the rules in
  `olive_rules.gd`, the basket in `olive_basket.gd`, the tablets in `number_tablet.gd`). Its pictures
  (`assets/images/greek/olive_harvest/`) are part C1 of the prompts; the three merchant moods are cut
  so that his head is in the same place in each (`tools/prepare_art.py figure … TOP`).

### 5.2a Demeter's Harvest — Arithmetic, the Agora of Numbers (built)

*Demeter, the goddess of the harvest, weighs the harvest for the festival on her great scale. Each
basket carries a number puzzle, and the scale only balances when both sides are equal.*

- **Skill:** adding and taking away within 10, then within 20; the missing number (5 + ? = 8,
  8 − ? = 5); the meaning of the equal sign (both sides the same: 4 + 3 = 5 + ?). (Common Core
  1.OA.1, 1.OA.6, 1.OA.7, 1.OA.8.)
- **Guide and place:** Demeter (a warm, motherly goddess with a crown of wheat and poppies, a pastel
  tunic) on a sunny farm with olive trees and green hills. She stands at the lower left, in three
  moods: calm, happy, and gently shaking her head.
- **Play:** a big balance scale stands in the middle. Each basket carries one side of an equation on
  clay tablets on its front (left "3 + 4", right "?"); the whole problem is also shown big along the
  top ("3 + 4 = ?") and read aloud ("3 plus 4 equals how many?"; at a level's start first "Which
  number balances the scale?"). Four number tablets lie in the field below; the child drags the one
  that balances the scale onto the "?" (or taps it; Enter on a focused one, for the keyboard). One
  dropped anywhere else slides back. The empty "?" weighs nothing, so before an answer the scale
  leans towards the side with the numbers.
- **No counting your way out:** the problem shows only numbers. The choices are the answer, the
  mistakes first graders make most (adding instead of taking away: 12 for 9 − 3; the other side's
  number: 8 for 5 + ? = 8, 7 for 4 + 3 = 5 + ?; all the numbers added: 13 for 5 + ? = 8) and numbers
  close to it.
- **Weighing:** the tablet goes into the "?" and the scale swings with it. Right: level, glowing,
  sparkles and confetti, the "?" along the top filled in and the equation read ("Well done! 3 plus 4
  equals 7!"), a goat bounds across, a harvest basket flies to the counter ("3 / 8"). Wrong: the
  scale tips clearly, Demeter gently shakes her head and says "8 is too big. Try a smaller number."
  (or "too small … bigger"); the tablet goes back, dimmed, and cannot be chosen again in this
  problem.
- **After one wrong answer:** wheat and grapes appear in the baskets, one for each unit (wheat for the
  first number, grapes for the added one, the last ones faded for those taken away; nothing yet for
  the missing number), and Demeter says "Here are wheat and grapes, if you want to count." The child
  can count them alone; nothing is counted for them and no answer glows.
- **Help after two wrong answers:** Demeter counts the wheat and grapes with the child, each item
  marked with its number and read aloud:
  - the result missing (3 + 4 = ?, 9 − 3 = ?): she counts the other side: "That makes 7." /
    "6 are left.";
  - a part to add (5 + ? = 8, 4 + 3 = 5 + ?): she starts from this side's number and counts on,
    adding a ghost bunch of grapes for each, until the scale is level: "We need 3 more.";
  - a part to take away (8 − ? = 5): she fades one item at a time until the scale is level:
    "We take away 3.".
  Then the right tablet glows. Nothing is ever taken away from the child.
- **Levels** (chosen at the start; all open, each with its best stars). A level is 8 problems; the
  first four use smaller numbers:
  1. **Adding:** a + b = ?, sums 3–7, then 5–10.
  2. **Taking away:** a − b = ?, from 4–7, then from 6–10.
  3. **The missing number:** a + ? = c or a − ? = c, within 10.
  4. **Up to 20:** a + b = ? and a − b = ? past ten (8 + 5, 15 − 7), up to 15, then up to 20.
  5. **Both sides equal:** a + b = c + ? (or c + ? = a + b), sums 5–8, then 6–10.
- **Stars:** for the problems right at the first try (7 or more: 3 stars, 4 or more: 2, else 1 —
  never none), a fanfare and "The harvest is ready!", "New best!", and Play again / Next level /
  Choose a level.
- **Sounds:** a tablet landing in the scale, a soft knock for a wrong answer, a tick per item counted
  together, a munch for one taken away, the sparkle burst and a chime, a fanfare (the sounds of §9.4a,
  no new ones).
- **Built:** `scenes/games/demeter_harvest.tscn` (`scripts/games/demeter_harvest.gd`; the problems in
  `harvest_rules.gd`, the scale in `harvest_scale.gd`, the answer tablets in `drag_tablet.gd`, the
  wheat and grapes in `harvest_item.gd`; the tablets are drawn with Olive Harvest's picture). Its
  pictures (`assets/images/greek/demeter_harvest/`) are part D of the prompts
  (`assets/prompts/D_DEMETER_HARVEST.md`); until they exist, all of it is drawn. The scale is three
  pictures put together by the game (the stand, the beam that tips, the basket hanging from each end).

### 5.3 Temple Builder — Geometry, the Temple Builders of Olympia

*The builders of Olympia are raising a temple for Zeus. Find the stone that fits each gap.*

- **Skill:** recognising and naming circle, square, triangle, rectangle (later oval, half circle);
  matching a shape whatever its size, colour or turn; simple patterns.
- **Play:** a temple is drawn in outline, with gaps of different shapes (a triangle roof, square
  blocks, round shields, rectangle steps). Stones of different shapes lie on a cart; the child drags
  each into a gap of the same shape. A builder names the shape as it clicks in ("A triangle!"). A
  stone that does not fit wobbles and slides back to the cart.
- **Levels:**
  1. Shapes in the same colour and size as their gaps.
  2. Same shape, different size or turned (a turned square is still a square).
  3. "Bring me a triangle": pick the named shape among others, with no outline to match.
  4. Patterns: finish a frieze (circle, square, circle, square, …).
  5. Count the sides and corners: "Which stone has 3 corners?".
- **Feedback:** the temple grows, columns rise, at the end the temple is finished and lit up (a star
  per temple).
- **Assets:** Olympia background, temple outlines (3 temples), stones in 4–6 shapes and 3 colours,
  cart, builder (3 moods), frieze tiles.

### 5.4 The Muses' Letters — Language, the Grove of the Muses

*A wind has scattered the Muses' letters. Help them find the letter each picture starts with.*

- **Skill:** letter sounds (phonics); the first sound of a word; matching capital and small letters;
  later building short words (3 letters).
- **Play:** a Muse shows a picture card and says the word ("Owl"). Three letter tablets hang on a
  laurel branch; the child taps the one the word starts with ("O"). Right: the tablet flies into the
  Muse's lyre and plays a note; wrong: the Muse says the word slowly, stretching its first sound.
- **Levels:**
  1. The first sound, 3 letters to choose from (a set of 8 letters at a time, taught in order).
  2. Capital to small letter: match "A" with "a".
  3. The last sound of a word.
  4. Build a word: drag 3 tablets in order under a picture (C-A-T).
- **Language:** the letters, words and voice depend on the language the child learns to read in, so
  each language has its own word list and recordings: Bulgarian first (the Cyrillic alphabet, with
  Bulgarian words for the pictures), then English (§9.5).
- **Feedback:** the lyre fills with notes; a full lyre plays a little tune (a star).
- **Assets:** grove background, the nine Muses (or 3 to start), lyre, laurel branch, letter tablets
  (an alphabet in clay), picture cards for the word list (owl, apple, sun, …).

### 5.5 Next: Odysseus' Voyage — Geography, the Islands of Odysseus

*Odysseus is lost at sea. Give him the directions home, one step at a time.*

- **Skill:** left, right, up, down (forwards, back); reading a simple grid map; land and water.
- **Play:** a grid of sea and islands seen from above; arrows to tap to move the ship one square;
  later, plan a route of 3–5 arrows and press "Sail".
- Shown in the menus as "Coming later".

## 6. Mini game frame (for when the games are built)

Every mini game is a scene that follows one contract, so the menus can open any of them:

- `start(level: int)` begins a level; the game says its instruction (text and voice).
- It emits `finished(stars: int)` (0–3) at the end of a level and `quit()` when the child goes back.
- Back (button, Esc, Android Back) pauses it and asks "Leave the game?" with two picture buttons.
- Common pieces: the guide (Glaux) with a speech bubble and voice line, a hint after two mistakes,
  the star screen, a "next level" button, drag and drop that works the same with a finger and a
  mouse.
- Progress per child (later: per profile): the levels done and the stars per game, saved in
  `user://progress.json`; the area cards show the stars.
- Difficulty adapts gently: three right answers in a row move on to harder items within a level;
  two mistakes in a row bring easier ones.

## 7. Design rules for young children

- **Touch targets** at least 88 px of the 1280 × 720 layout (about 9 mm on a phone); main actions
  bigger. Nothing important near the screen's edges, where hands rest.
- **No reading needed:** every instruction is spoken; every button has a picture or symbol; text is
  for parents and early readers.
- **Colour is never the only clue:** areas and choices also differ by symbol and shape (colour
  blindness).
- **No time pressure, no losing, no lives.** Mistakes get a gentle hint and another try.
- **Short rounds** (2–4 minutes) with a clear end; praise is specific ("You counted seven!").
- Calm motion: no flashing, no sudden loud sounds; music can be turned off.
- Kind myths: the guides and creatures are friendly; no scary monsters in Grades 1–2.

## 8. Later features

- Parents area behind a parental gate: child profiles (name, picture, grade), progress per game, the
  language, sound, a "how to play" page.
- Voice for every instruction (recorded or high-quality text to speech) in each language.
- Music per mythology, sounds for taps, drops, right and wrong answers.
- Rewards: a collection of myth cards (gods, heroes, creatures) earned with stars, each with a short
  child-friendly story read aloud.
- More grades and mythologies, opened one at a time.

## 9. Technical design

### 9.1 Project

| | |
|---|---|
| Layout | 1280 × 720, stretch mode `canvas_items`, aspect `expand` (wider or taller screens get more room, nothing is cut off) |
| Renderer | Compatibility (OpenGL ES 3 / WebGL 2 class) |
| Orientation | sensor landscape on phones and tablets |
| Input | touch emulates the mouse; every menu control also takes keyboard and gamepad focus |
| Android Back | handled by the game (`quit_on_go_back` off): Back goes one screen back |

```
mythos-academy/
  project.godot
  data/
    mythologies.json        the world map: one mythology per grade
    realms/greek.json       Ancient Greece: its areas and their mini games
  scripts/
    app.gd                  autoload "App": the screen being shown, Back, the settings
    catalog.gd              reads data/
    ui.gd                   the theme, buttons, banner, messages, pictures from assets/images
  tools/
    prepare_art.py          generated pictures to the game's files (crop, cut out, paint out labels)
    art_fixes.json          what to paint out of which picture
    map_view.gd             a map that fits the screen, with markers (and placeholder maps)
    map_marker.gd           a round marker: badge, emblem, label, locked state
    main_menu.gd, world_map.gd, realm_map.gd, area.gd   the screens
  scenes/                   one scene per screen
  assets/
    images/                 the art (see assets/prompts/IMAGE_PROMPTS.md for every file)
    prompts/                IMAGE_PROMPTS.md (the index), A_MENUS.md, B_ZEUS_THUNDERBOLTS.md, C_LATER_GAMES.md,
                            D_DEMETER_HARVEST.md
  tests/                    navigation test, screenshots
  docs/SPECIFICATION.md     this document
```

### 9.2 Content data

`data/mythologies.json`:

```json
{"format_version": 1, "mythologies": [
  {"id": "greek", "name": "Ancient Greece", "grade": 1, "available": true, "color": "#3f7fc4",
   "map_pos": [0.43, 0.38], "realm": "res://data/realms/greek.json"}
]}
```

- `map_pos`: the marker's place on the world map, 0–1 from the left and from the top. Change it to
  match the painted map.
- `available`: whether the land can be opened (it also needs a `realm` file).

`data/realms/<id>.json`:

```json
{"format_version": 1, "id": "greek", "name": "Ancient Greece", "grade": 1, "guide": "Glaux, the little owl of Athena",
 "areas": [
   {"id": "arithmetic", "glyph": "1+2", "subject": "Arithmetic", "name": "The Agora of Numbers",
    "place": "The market of Athens", "color": "#e0a030", "map_pos": [0.56, 0.52],
    "games": [{"id": "olive_harvest", "title": "Olive Harvest", "skill": "...", "blurb": "...",
               "status": "planned"}]}
 ]}
```

- A game's `status`: `planned` ("Coming soon"), `later` ("Coming later"), `ready` (playable; the
  game's scene will be named by a `scene` field then).

### 9.3 Art

The screens look for their pictures under `assets/images/` by fixed names (listed with their prompts
in `assets/prompts/IMAGE_PROMPTS.md`). A missing picture is never an error: the screen draws a
placeholder (a simple map, a coloured badge with a symbol, a coloured tile), so art can be added one
file at a time. Pictures are imported with mipmaps off and VRAM compression for mobile (ETC2/ASTC).
A `.jpg` of the same name is found too (opaque pictures are kept as JPG to keep the project small).

Generated pictures are turned into the game's files with `tools/prepare_art.py`: backgrounds and cards
cropped to shape, maps resized whole, medallions cut out as clean circles, characters and the logo cut
out of their white background (only the white joined to the edges, so white inside a picture stays).
Its `erase` step paints out what a generator added against the prompt, such as names written on a map
or its own marker discs; the boxes for each picture are listed in `tools/art_fixes.json`.

### 9.4 Saving

- `user://settings.cfg`: music, sounds, read aloud, full screen, language.
- `user://progress.cfg`: the best score of each timed game and length.
- Later `user://progress.json`: profiles, stars per game and level.

Nothing is sent anywhere.

### 9.4a Sound

`scripts/sound.gd` (autoload `Sound`) plays the sound effects; Settings' "Sounds" turns them off. Every
button clicks by itself (Back plays its own sound, switches a toggle sound); the games call
`Sound.play("name")`. The sounds are in `assets/audio/sfx/`, taken from Chasm of Knights: Kenney's
Interface Sounds (CC0) and sounds made for that game; sources and licences in
`assets/audio/sfx/CREDITS.txt`. There are no hover labels (tooltips) anywhere: a child on a phone never
sees them, and on a PC they only got in the way.

### 9.5 Languages

The game is in **Bulgarian first** (the language it starts in) and English. The language is chosen in
Settings and saved.

- The text in the code and in the content files (`data/`) is English and is the key of each text;
  `scripts/translations.gd` (`Translations`) has the Bulgarian for every key and makes it a Godot
  translation at start. Labels and buttons translate themselves; text drawn by hand (map markers) or
  put together with numbers ("%d клас") goes through `tr()`.
- To add a language: a table like `Translations.BG`, an entry in `Translations.LANGUAGES`.
- `tests/translations_test.tscn` fails if any text of the data or the scripts has no Bulgarian.
- Pictures carry no words, except the logo: `ui/logo.png` (English) and `ui/logo_<language>.png`
  (`logo_bg.png`); without the language's logo the title screen writes the name in the language.
- Read aloud speaks with a voice of the chosen language only; a device without a Bulgarian voice stays
  silent in Bulgarian rather than reading it with an English voice. (Recorded voices later.)
- Bulgarian wording: grades as "1 клас"; "най‑голямото" and "най‑малкото" are written with a
  non-breaking hyphen so they never break across lines.
- Language mini games need their own content per language (see §5.4).

### 9.6 Tests

- `tests/navigation_test.tscn` (headless): the content loads; Play → world map; a locked land only
  shows a message; Greece → each area → back.
- `tests/translations_test.tscn` (headless): every text has its Bulgarian; the menus come up in
  Bulgarian.
- `tests/olive_test.tscn` (headless): Olive Harvest's rules on every level over many orders (the
  ranges, three different choices with the answer among them, a coin per order, nothing taken away,
  the stars, the hint), then the screen (filling the basket, taking one out, a wrong Done and counting
  together, the goat and the tablets, the baskets, the end of a level and its stars kept).
- `tests/harvest_test.tscn` (headless): Demeter's Harvest's problems on every level over many rounds
  (the equations in range, one answer that balances, four choices with the likely mistakes, nothing
  taken away, the help, the stars), then the screen (a tablet dropped away from the scale, a wrong
  one tipping the scale and coming back dimmed, the help counting all, counting on or taking away,
  the right one, the end of a level and its stars kept).
- `tests/thunderbolt_test.tscn` (headless): Zeus' Thunderbolts' rules over many rounds (2–4 different
  numbers in range, the goal switching every 3 rounds, nothing taken away, the hint after two wrong
  picks), then the screen (wrong taps, the hint, a right tap, new clouds).
- `tests/screenshots.tscn` (window): every screen at a given size (PC 1280×720, phone 915×412,
  tablet 1024×768) and language (`--lang=bg` or `en`), and Zeus' Thunderbolts while it is played, for
  a visual check.

## 10. Milestones

1. **Menus** (done): title, settings, world map, Greek map, areas with game cards, placeholders, PC
   and mobile layout.
2. **Art for the menus** (done): the pictures of `assets/prompts/A_MENUS.md`; markers placed on them.
3. **Zeus' Thunderbolts** (built; its art: part B). **Olive Harvest** (built; its art: part C1).
   **Demeter's Harvest** (built; its art: part D).
4. **Mini game frame**: the contract of §6, the guide, stars, progress saving, sound.
5. **Temple Builder**, then **The Muses' Letters** (with voice).
6. Android and Windows builds; testing with first graders; then Odysseus' Voyage.

## 11. Open questions

- Which curriculum to follow exactly (country), so each grade's skills match the school year?
- The order of mythologies per grade (§3.1) is a proposal.
- Recorded voices or text to speech?
- Child profiles from the first release, or later?
