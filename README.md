# Mythos Academy

An educational game of mythology-themed mini games for primary school children, made with Godot 4.7.
Each school grade has its own mythology; the first is Grade 1 in Ancient Greece. For PC and mobile.
In Bulgarian (first) and English.

- `docs/SPECIFICATION.md`: what the game is, its screens, the proposed Grade 1 mini games, the
  technical design.
- `assets/prompts/IMAGE_PROMPTS.md`: the index of the image prompts — one file per part (the menus,
  Zeus' Thunderbolts, the later games), with the file names the game looks for under `assets/images/`.

Built so far: the title screen, settings, the world map (one land per grade), the map of Ancient Greece
with its four learning areas, and each area's list of planned mini games. The mini games themselves
are not built yet.

Run: open the folder in Godot 4.7 and press Play (F5).

Tests:

    godot --headless --path . res://tests/navigation_test.tscn
    godot --headless --path . res://tests/thunderbolt_test.tscn
    godot --headless --path . res://tests/olive_test.tscn
    godot --headless --path . res://tests/translations_test.tscn
    godot --path . res://tests/screenshots.tscn -- --out=C:/some/folder --size=1280x720 --lang=bg
