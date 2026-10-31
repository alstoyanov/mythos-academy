extends Control
## Zeus' Thunderbolts — Arithmetic, the Agora of Numbers, Grade 1 (see docs/SPECIFICATION.md §5.1).
## Clouds with numbers float over Mount Olympus; the child taps the cloud with the biggest number (or,
## every other three rounds, the smallest) and Zeus strikes it with a thunderbolt. A right pick scores
## a point; a wrong one only makes the cloud wobble and Zeus encourage, and after two the right cloud
## glows. The rules are in ThunderboltRules; this is the screen.
## Three games (ThunderboltRules.Mode): plain numbers; two clouds, one with a sum (3 + 4, 9 − 2) to work
## out; two clouds, both with sums. A wrong sum cloud shows what it makes ("= 7") and Zeus says it; a
## wrong number next to a sum makes Zeus ask to work out the sum first.
## A game is a timed round: the child picks the game and 1, 2 or 3 minutes (DURATIONS), each pair with
## its own best score (App.best_score, under MODE_IDS); the clock stops while a new goal is announced,
## ticks in the last seconds, and at the end the score is shown, with a fanfare for a new best. Nothing
## is ever taken away.
## Pictures: assets/images/greek/zeus_thunderbolts/ (see assets/prompts/B_ZEUS_THUNDERBOLTS.md); each
## has a drawn stand-in.

const ART := "greek/zeus_thunderbolts/"
const PRAISE := ["Great!", "Well done!", "Yes, that's it!", "Super!", "Brilliant!", "You got it!"]
const BOLT_TIME := 0.3
## Where the thunderbolt leaves Zeus's raised hand in zeus_throw.png (fractions of the picture; the poses
## are square, made by tools/prepare_art.py "figure" with matching heads, standing on the bottom edge).
const HAND := Vector2(0.888, 0.28)
const ZEUS_SIZE := 420.0
const GAME_ID := "zeus_thunderbolts"  ## the key of its best scores
const DURATIONS := [60, 120, 180]  ## the lengths of a round to choose from, in seconds
const DURATION_NAMES := ["1 minute", "2 minutes", "3 minutes"]
const HURRY := 10  ## the last seconds: the clock turns orange and ticks
const MODE_NAMES := ["Numbers", "A sum in one cloud", "Sums in both clouds"]  ## by ThunderboltRules.Mode
const MODE_EXAMPLES := ["7      4", "3 + 4      6", "9 − 2      2 + 5"]
## The key of each game's best scores (the first is the plain numbers' key from before the sum games).
const MODE_IDS := [GAME_ID, GAME_ID + "_one_sum", GAME_ID + "_two_sums"]

var _rules := ThunderboltRules.new()
var _clouds: Array[NumberCloud] = []
var _cloud_layer: Control
var _zeus: TextureRect
var _zeus_pose := "idle"
var _zeus_poses := {}  # pose -> Texture2D (those that exist)
var _goal_label: Label
var _goal_icon: TextureRect
var _goal_panel: PanelContainer
var _score_label: Label
var _bubble: PanelContainer
var _bubble_label: Label
var _announce: PanelContainer
var _announce_label: Label
var _bolt := {}  # {from, to, t} while a thunderbolt flies
var _bolt_texture: Texture2D
var _busy := false  # between a right pick and the next round
var _sky: Texture2D
var _overlay: Control  ## on top of everything: the thunderbolt
var _seconds := 60  ## the length of the round being played
var _mode: ThunderboltRules.Mode = ThunderboltRules.Mode.NUMBERS
var _time_left := 0.0
var _running := false  ## a round is being played (the clock runs)
var _clock: Label
var _clock_panel: PanelContainer
var _menu: Control  ## the choice of time, or the results of the round


func _ready() -> void:
	Ui.setup_screen(self)
	_sky = Ui.picture(ART + "background.png")
	_bolt_texture = Ui.picture(ART + "lightning_bolt.png")
	for pose in ["idle", "throw", "happy", "encourage"]:
		var tex := Ui.picture(ART + "zeus_%s.png" % pose)
		if tex != null:
			_zeus_poses[pose] = tex

	_cloud_layer = Control.new()
	_cloud_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_cloud_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(_cloud_layer)

	_zeus = TextureRect.new()
	_zeus.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_zeus.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_zeus.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_zeus.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_zeus.offset_left = 0
	_zeus.offset_right = ZEUS_SIZE
	_zeus.offset_top = -ZEUS_SIZE
	_zeus.offset_bottom = 0
	add_child(_zeus)
	_set_pose("idle")

	_bubble = PanelContainer.new()  # what Zeus says, above him (left of the clouds)
	_bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bubble.position = Vector2(24, 150)
	add_child(_bubble)
	_bubble_label = Ui.label(_bubble, "", 28, Ui.INK, 300.0)
	_bubble.visible = false

	_build_goal_panel()
	_build_score_badge()
	_build_clock()
	Ui.back_button(self)

	_announce = PanelContainer.new()  # "Now: the smallest number!" when the goal changes
	_announce.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)
	center.add_child(_announce)
	_announce_label = Ui.label(_announce, "", 52)
	_announce.visible = false

	_overlay = Control.new()
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.draw.connect(_draw_bolt)
	add_child(_overlay)

	resized.connect(_layout)
	_choose_time()


## The instruction along the top: the goal's picture (a tall stack of coins for "biggest", one coin
## for "smallest") and its words.
func _build_goal_panel() -> void:
	var holder := CenterContainer.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	holder.offset_top = 16
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	_goal_panel = PanelContainer.new()
	_goal_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(_goal_panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	_goal_panel.add_child(row)
	_goal_icon = TextureRect.new()
	_goal_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_goal_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_goal_icon.custom_minimum_size = Vector2(72, 72)
	row.add_child(_goal_icon)
	_goal_label = Ui.label(row, "", 40)
	_goal_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER


## The score in the top right corner, on a laurel badge (or a panel until there is a picture).
func _build_score_badge() -> void:
	var badge := Ui.picture(ART + "score_laurel.png")
	var holder: Control
	if badge != null:
		var pic := TextureRect.new()
		pic.texture = badge
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		holder = pic
	else:
		holder = PanelContainer.new()
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	holder.offset_left = -170
	holder.offset_right = -20
	holder.offset_top = 16
	holder.offset_bottom = 136
	add_child(holder)
	_score_label = Ui.label(holder, "0", 54)
	_score_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER


## The time left, under the score.
func _build_clock() -> void:
	_clock_panel = PanelContainer.new()
	_clock_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_clock_panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_clock_panel.offset_left = -170
	_clock_panel.offset_right = -20
	_clock_panel.offset_top = 144
	_clock_panel.offset_bottom = 214
	add_child(_clock_panel)
	_clock = Ui.label(_clock_panel, "", 40)


## Before a round: the game and how long to play, a row for each game, each length with its best score.
func _choose_time() -> void:
	_running = false
	_goal_panel.visible = false
	_clock_panel.visible = false
	var col := _open_menu(tr("Zeus' Thunderbolts"))
	Ui.label(col, tr("Choose a game and how long to play"), 28, Ui.INK.lightened(0.15))
	var first: Button = null
	for m in MODE_NAMES.size():
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 16)
		col.add_child(row)
		var about := VBoxContainer.new()
		about.custom_minimum_size.x = 300
		about.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_child(about)
		Ui.label(about, tr(MODE_NAMES[m]), 28, Ui.INK, 300.0)
		Ui.label(about, MODE_EXAMPLES[m], 26, Color("1f4e8c"))
		for i in DURATIONS.size():
			var seconds: int = DURATIONS[i]
			var option := VBoxContainer.new()
			option.add_theme_constant_override("separation", 2)
			row.add_child(option)
			var b := Ui.button(option, tr(DURATION_NAMES[i]), _start.bind(seconds, m), 26)
			b.custom_minimum_size = Vector2(190, 76)
			b.set_meta("sound", "start")
			var best := App.best_score(MODE_IDS[m], seconds)
			Ui.label(option, tr("Best: %d") % best if best > 0 else " ", 22)
			if first == null:
				first = b
	first.call_deferred("grab_focus")


## After a round: the score, and the best for this length (a fanfare if it is a new best).
func _finish() -> void:
	_running = false
	_busy = true
	for c in _clouds:
		if not c.is_gone():
			c.leave()
	_bubble.visible = false
	_announce.visible = false
	var score := _rules.score
	var previous := App.best_score(MODE_IDS[_mode], _seconds)
	var new_best := App.record_score(MODE_IDS[_mode], _seconds, score)
	_set_pose("happy")
	Sound.play("fanfare")
	var col := _open_menu(tr("Time's up!"))
	Ui.label(col, tr("Score: %d") % score, 44)
	var line: Label
	if new_best:
		line = Ui.label(col, tr("New best!"), 40, Color("b8860b"))
	else:
		line = Ui.label(col, tr("Best: %d") % previous, 30, Ui.INK.lightened(0.2))
	App.say("%s %s %s" % [tr("Time's up!"), tr("Score: %d") % score, line.text])
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_child(row)
	var again := Ui.button(row, tr("Play again"), _start.bind(_seconds, _mode), 32)
	again.set_meta("sound", "start")
	Ui.button(row, tr("Change game"), _choose_time, 32)
	again.call_deferred("grab_focus")


## A panel in the middle of the screen with a title; returns its column for the rest.
func _open_menu(title: String) -> VBoxContainer:
	if _menu != null:
		_menu.queue_free()
	_menu = CenterContainer.new()
	_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE  # (the Back button stays usable around the panel)
	add_child(_menu)
	move_child(_menu, _overlay.get_index())  # (under the thunderbolt layer, over the rest)
	var panel := PanelContainer.new()
	_menu.add_child(panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	panel.add_child(col)
	Ui.label(col, title, 48)
	return col


## A round of `seconds` of game `mode` starts.
func _start(seconds: int, mode: ThunderboltRules.Mode = ThunderboltRules.Mode.NUMBERS) -> void:
	if _menu != null:
		_menu.queue_free()
		_menu = null
	_seconds = seconds
	_mode = mode
	_time_left = seconds
	_rules = ThunderboltRules.new(null, mode)
	_score_label.text = "0"
	_goal_panel.visible = true
	_clock_panel.visible = true
	_update_clock()
	_running = true
	_busy = false
	_next_round(true)


func _update_clock() -> void:
	var left := ceili(maxf(0.0, _time_left))
	_clock.text = "%d:%02d" % [left / 60, left % 60]
	_clock.add_theme_color_override("font_color", Color("d9631e") if left <= HURRY else Ui.INK)


func _next_round(first: bool = false) -> void:
	if not _running:
		return
	for c in _clouds:
		if not c.is_gone():
			c.leave()
	var changes := first or _rules.goal_changes_next()
	var numbers := _rules.new_round()
	_update_goal()
	if changes:  # announce what to look for now, then bring the clouds
		var words := "Find the BIGGEST number!" if _rules.goal == ThunderboltRules.Goal.BIGGEST else "Now find the SMALLEST number!"
		if first:
			words = "Zeus needs your help! Find the BIGGEST number!"
			if _mode != ThunderboltRules.Mode.NUMBERS:
				words = "Work out the clouds! Find the BIGGEST number!"
		words = tr(words)
		_announce_label.text = words
		_announce.visible = true
		_announce.modulate.a = 1.0
		App.say(words)
		var tw := create_tween()
		tw.tween_interval(1.6)
		tw.tween_property(_announce, "modulate:a", 0.0, 0.4)
		tw.tween_callback(func() -> void:
			_announce.visible = false
			_spawn(numbers))
	else:
		_spawn(numbers)


func _update_goal() -> void:
	var biggest := _rules.goal == ThunderboltRules.Goal.BIGGEST
	_goal_label.text = tr("Hit the BIGGEST number!" if biggest else "Hit the SMALLEST number!")
	var icon := Ui.picture(ART + ("icon_biggest.png" if biggest else "icon_smallest.png"))
	_goal_icon.texture = icon if icon != null else _coin_stack_texture(5 if biggest else 1)


func _spawn(numbers: Array[int]) -> void:
	if not _running:
		return
	Sound.play("whoosh")
	for c in _clouds:
		c.queue_free()
	_clouds.clear()
	var sums := _mode != ThunderboltRules.Mode.NUMBERS
	for i in numbers.size():
		var cloud := NumberCloud.new(numbers[i], i + _rules.round_index, _rules.label(i), sums)
		cloud.pressed.connect(_on_pick.bind(cloud))
		_cloud_layer.add_child(cloud)
		_clouds.append(cloud)
	_layout()
	_busy = false
	_set_pose("idle")
	if not _clouds.is_empty():
		_clouds[0].grab_focus()


## Places the clouds in the sky right of Zeus: in a row, a little up and down, or two by two for four.
func _layout() -> void:
	var left := 400.0
	var top := 170.0
	var area := Rect2(left, top, maxf(300.0, size.x - left - 30.0), maxf(240.0, size.y - top - 60.0))
	var n := _clouds.size()
	for i in n:
		var cell: Vector2
		if n == 4:
			cell = Vector2((i % 2 + 0.5) / 2.0, (i / 2 + 0.5) / 2.0)
		else:
			cell = Vector2((i + 0.5) / n, 0.35 + (0.3 if i % 2 == 1 else 0.0))
		_clouds[i].position = area.position + cell * area.size - _clouds[i].size / 2.0


func _on_pick(cloud: NumberCloud) -> void:
	if _busy or not _running:
		return
	var right := _rules.pick(cloud.value)
	_throw(cloud.target())
	Sound.play("zap")
	if right:
		_busy = true
		cloud.burst()
		get_tree().create_timer(BOLT_TIME * 0.8).timeout.connect(Sound.play.bind("burst"))
		_score_label.text = str(_rules.score)
		var pop := _score_label.create_tween()
		_score_label.pivot_offset = _score_label.size / 2.0
		pop.tween_property(_score_label, "scale", Vector2.ONE * 1.4, 0.12)
		pop.tween_property(_score_label, "scale", Vector2.ONE, 0.2)
		var words: String = tr(PRAISE[randi() % PRAISE.size()])
		if _rules.score % 10 == 0:
			words = tr("%d thunderbolts! You are amazing!") % _rules.score
		_say(words, "happy")
		for c in _clouds:
			c.glowing = false
		var tw := create_tween()
		tw.tween_interval(1.2)
		tw.tween_callback(_next_round)
	else:
		cloud.wobble()
		get_tree().create_timer(BOLT_TIME * 0.8).timeout.connect(Sound.play.bind("oops"))
		var biggest := _rules.goal == ThunderboltRules.Goal.BIGGEST
		var words := tr("Almost! Look for the biggest number." if biggest else "Almost! Look for the smallest number.")
		var i := _clouds.find(cloud)
		if _rules.sums[i] != ThunderboltRules.PLAIN:  # a sum: what it makes, shown and said
			cloud.reveal = true
			words = "%s %s" % [tr("%s makes %d.") % [_spoken_sum(i), cloud.value], words]
		elif _clouds.size() == 2 and _rules.sums[1 - i] != ThunderboltRules.PLAIN and not _clouds[1 - i].reveal:
			words = tr("First work out %s!") % _spoken_sum(1 - i)  # (a number next to a sum)
		_say(words, "encourage")
		if _rules.hint_due():
			for c in _clouds:
				c.glowing = c.value == _rules.answer()


## Cloud `i`'s sum in words, to say: "3 plus 4".
func _spoken_sum(i: int) -> String:
	var s: Vector2i = _rules.sums[i]
	return "%d %s %d" % [s.x, tr("plus") if s.y > 0 else tr("minus"), absi(s.y)]


## Zeus says something (already translated: shown in his bubble, read aloud) and shows how he feels.
func _say(words: String, pose: String) -> void:
	_bubble_label.text = words
	_bubble.visible = true
	_bubble.modulate.a = 1.0
	App.say(words)
	var tw := _bubble.create_tween()
	tw.tween_interval(BOLT_TIME)
	tw.tween_callback(_set_pose.bind(pose))
	tw.tween_interval(1.6)
	tw.tween_property(_bubble, "modulate:a", 0.0, 0.4)
	tw.tween_callback(func() -> void:
		_bubble.visible = false
		if not _busy:
			_set_pose("idle"))


## A thunderbolt from Zeus's raised hand to `to`.
func _throw(to: Vector2) -> void:
	_set_pose("throw")
	var hand := _zeus.position + _zeus.size * HAND
	if _zeus_poses.is_empty():  # the drawn Zeus's hand
		hand = _zeus.position + Vector2(_zeus.size.x * 0.68, _zeus.size.y * 0.2)
	_bolt = {"from": hand, "to": to, "t": 0.0, "seed": randi()}


func _set_pose(pose: String) -> void:
	_zeus_pose = pose
	_zeus.texture = _zeus_poses.get(pose, _zeus_poses.get("idle", null))
	queue_redraw()  # (the drawn Zeus, while there is no picture)


func _process(delta: float) -> void:
	if _running and not _announce.visible:  # (the clock waits while a new goal is announced)
		var before := ceili(_time_left)
		_time_left -= delta
		var now := ceili(_time_left)
		if now != before:
			_update_clock()
			if now <= HURRY and now > 0:
				Sound.play("tick")
		if _time_left <= 0.0:
			_finish()
	if not _bolt.is_empty():
		_bolt["t"] += delta
		if _bolt["t"] > BOLT_TIME:
			_bolt = {}
		_overlay.queue_redraw()


func _draw() -> void:
	# the sky (under everything: this control draws first, its children on top)
	if _sky != null:
		var tex_size := _sky.get_size()
		var s := maxf(size.x / tex_size.x, size.y / tex_size.y)
		draw_texture_rect(_sky, Rect2((size - tex_size * s) / 2.0, tex_size * s), false)
	else:
		_draw_placeholder_sky()
	if _zeus.texture == null:
		_draw_placeholder_zeus()


## The thunderbolt, drawn on the overlay (over the clouds).
func _draw_bolt() -> void:
	var overlay := _overlay
	if _bolt.is_empty():
		return
	var from: Vector2 = _bolt["from"]
	var to: Vector2 = _bolt["to"]
	var p := clampf(_bolt["t"] / BOLT_TIME, 0.0, 1.0)
	var alpha := 1.0 - maxf(0.0, (p - 0.6) / 0.4)
	if _bolt_texture != null:  # the picture, from the hand to the cloud
		var d := to - from
		overlay.draw_set_transform(from, d.angle(), Vector2.ONE)
		var h := 90.0
		overlay.draw_texture_rect(_bolt_texture, Rect2(0.0, -h / 2.0, d.length() * minf(1.0, p * 2.0), h), false,
			Color(1, 1, 1, alpha))
		overlay.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:  # a zigzag of light
		var rng := RandomNumberGenerator.new()
		rng.seed = _bolt["seed"]
		var pts := PackedVector2Array([from])
		var steps := 7
		var reach := minf(1.0, p * 2.0)
		var side := (to - from).normalized().orthogonal()
		for k in range(1, steps):
			var f := float(k) / steps * reach
			pts.append(from.lerp(to, f) + side * rng.randf_range(-26.0, 26.0))
		pts.append(from.lerp(to, reach))
		overlay.draw_polyline(pts, Color(1.0, 0.85, 0.2, 0.45 * alpha), 18.0, true)
		overlay.draw_polyline(pts, Color(1.0, 0.97, 0.7, alpha), 6.0, true)
	if p > 0.45:  # the flash where it strikes
		overlay.draw_circle(to, 70.0 * (p - 0.3), Color(1.0, 0.95, 0.6, 0.5 * alpha))


func _draw_placeholder_sky() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("7fb8e6"))
	draw_rect(Rect2(0, size.y * 0.55, size.x, size.y * 0.45), Color("a6d0ef"))
	var peak := PackedVector2Array([Vector2(0, size.y), Vector2(size.x * 0.12, size.y * 0.62),
		Vector2(size.x * 0.24, size.y * 0.72), Vector2(size.x * 0.36, size.y * 0.58), Vector2(size.x * 0.5, size.y)])
	draw_colored_polygon(peak, Color("9aa7b8"))
	draw_circle(Vector2(size.x * 0.9, size.y * 0.2), 60.0, Color(1.0, 0.95, 0.7, 0.8))


## Zeus without a picture: a robed figure with a white beard and a golden crown.
func _draw_placeholder_zeus() -> void:
	var r := Rect2(_zeus.position, _zeus.size)
	var base := Vector2(r.get_center().x, r.end.y)
	var robe := PackedVector2Array([base + Vector2(-110, 0), base + Vector2(-70, -230), base + Vector2(70, -230),
		base + Vector2(110, 0)])
	draw_colored_polygon(robe, Color("f4f1ea"))
	draw_polyline(robe, Color("c9b98f"), 4.0, true)
	var head := base + Vector2(0, -280)
	draw_circle(head, 50.0, Color("f2c9a0"))
	draw_colored_polygon(PackedVector2Array([head + Vector2(-48, 4), head + Vector2(48, 4), head + Vector2(0, 92)]),
		Color.WHITE)
	draw_colored_polygon(PackedVector2Array([head + Vector2(-40, -36), head + Vector2(-24, -70), head + Vector2(0, -46),
		head + Vector2(24, -70), head + Vector2(40, -36)]), Ui.GOLD)
	var arm_up := _zeus_pose == "throw" or _zeus_pose == "happy"
	var shoulder := base + Vector2(60, -200)
	var hand := shoulder + (Vector2(60, -110) if arm_up else Vector2(40, 60))
	draw_line(shoulder, hand, Color("f2c9a0"), 22.0, true)
	if not arm_up:
		draw_polyline(PackedVector2Array([hand + Vector2(-6, -40), hand + Vector2(10, -10), hand + Vector2(-4, -8),
			hand + Vector2(12, 26)]), Ui.GOLD, 8.0, true)


## Gold coins seen from the front (the goal's picture until there is art): a pile of five for
## "biggest", a single one for "smallest".
static func _coin_stack_texture(n: int) -> Texture2D:
	var img := Image.create_empty(96, 96, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var centres: Array[Vector2i] = [Vector2i(48, 48)]
	var r := 26
	if n > 1:  # three below, two on top
		centres = [Vector2i(18, 72), Vector2i(48, 72), Vector2i(78, 72), Vector2i(33, 44), Vector2i(63, 44)]
		r = 15
	for c in centres:
		for y in range(-r, r + 1):
			for x in range(-r, r + 1):
				var d := sqrt(float(x * x + y * y))
				if d <= r:
					img.set_pixel(c.x + x, c.y + y, Color("a8741a") if d > r - 3 else Color("e9bb45"))
	return ImageTexture.create_from_image(img)

