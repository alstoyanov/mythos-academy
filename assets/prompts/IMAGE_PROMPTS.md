# Mythos Academy — image prompts

One complete prompt for every picture of the game, ready to copy: nothing needs to be filled in. The prompts are in five files:

| Part | File | Pictures | State |
|---|---|---|---|
| A — the menus | [A_MENUS.md](A_MENUS.md) | 29 | done: in the game, except the new A.3 (the Bulgarian logo) |
| B — Zeus' Thunderbolts (Arithmetic) | [B_ZEUS_THUNDERBOLTS.md](B_ZEUS_THUNDERBOLTS.md) | 13 | **to make now**: the game is built and waits for them |
| C — the later Grade 1 mini games | [C_LATER_GAMES.md](C_LATER_GAMES.md) | 82 | C1 (Olive Harvest) done: in the game; the rest for later |
| D — Demeter's Harvest (Arithmetic) | [D_DEMETER_HARVEST.md](D_DEMETER_HARVEST.md) | 13 | done: in the game |
| E — The Muses' Words (Language) | [E_MUSES_WORDS.md](E_MUSES_WORDS.md) | 12 prompts: 100 word pictures on 7 sheets, and 5 more | done: in the game |

How to use them:

- Copy the **Prompt** (and, if the tool has a field for it, the **Negative prompt**) as it is: nothing needs to be filled in.
- Save the picture under the file name given, in the game's folder; the game uses it as soon as it exists (until then it draws a stand-in), so pictures can be made one at a time and in any order.
- Every prompt already contains the shared style (hand-painted storybook, gouache and watercolour, warm Greek palette), so all pictures match.
- Pictures marked *transparent background* need one. If the tool paints a plain white background instead, that is fine: `tools/prepare_art.py` cuts the subject out.
- Sizes are what the game expects. A larger picture of the same shape (aspect ratio) is fine; the game scales it down.
