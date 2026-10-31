extends Node
## Renders the menus for a visual check: the title screen, Settings, the world map (and a locked land's
## message), the map of Greece and each of its areas. Needs a window (not --headless):
##   godot --path . res://tests/screenshots.tscn -- --out=C:/path/to/folder [--size=1280x720] [--lang=en]
## (A phone held sideways is about 915x412, a tablet 1024x768.)

var _out := "user://screens"
var _size := Vector2i(1280, 720)


func _ready() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			_out = arg.substr(6)
		elif arg.begins_with("--size="):
			var wh := arg.substr(7).split("x")
			_size = Vector2i(int(wh[0]), int(wh[1]))
	DirAccess.make_dir_recursive_absolute(_out)
	var stand_in := Node.new()  # this node stays while the screens change
	get_tree().root.add_child.call_deferred(stand_in)
	await get_tree().process_frame
	get_tree().current_scene = stand_in
	for arg in OS.get_cmdline_user_args():  # --lang=bg / en (default: the game's first language)
		if arg.begins_with("--lang="):
			App.language = arg.substr(7)
	TranslationServer.set_locale(App.language)
	get_window().min_size = Vector2i(200, 200)
	get_window().size = _size
	await _wait(0.4)
	var tag := "%dx%d_%s" % [_size.x, _size.y, App.language]

	get_tree().change_scene_to_file(App.MAIN_MENU)
	await _wait(0.6)
	await _shot("1_title_%s" % tag)
	get_tree().current_scene.call("_open_settings")
	await _wait(0.3)
	await _shot("2_settings_%s" % tag)
	App.go(App.WORLD_MAP)
	await _wait(0.6)
	await _shot("3_world_%s" % tag)
	(_find(MapView) as MapView).marker("egyptian").pressed.emit()
	await _wait(0.4)
	await _shot("4_world_locked_%s" % tag)
	App.open_mythology("greek")
	await _wait(0.6)
	await _shot("5_greece_%s" % tag)
	for a: Dictionary in Catalog.realm("greek")["areas"]:
		App.open_area(a["id"])
		await _wait(0.5)
		await _shot("6_area_%s_%s" % [a["id"], tag])
		App.back()
		await _wait(0.3)
	# Zeus' Thunderbolts: the clouds, two wrong taps (the hint glows), a right one (the thunderbolt)
	App.voice_on = false
	App.area_id = "arithmetic"
	App.use_progress_file("user://screenshot_progress.cfg")  # (the player's best scores are left alone)
	App.go("res://scenes/games/zeus_thunderbolts.tscn")
	await _wait(0.6)
	await _shot("7_thunderbolts_choose_%s" % tag)
	var game := get_tree().current_scene
	game.call("_start", 60)
	await _wait(0.8)
	await _shot("7_thunderbolts_announce_%s" % tag)
	await _wait(2.0)
	await _shot("7_thunderbolts_clouds_%s" % tag)
	var rules: ThunderboltRules = game.get("_rules")
	var right: NumberCloud = null
	for c: NumberCloud in game.get("_clouds"):
		if c.value == rules.answer():
			right = c
	for c: NumberCloud in game.get("_clouds"):
		if c != right:
			c.pressed.emit()
			c.pressed.emit()
			break
	await _wait(0.15)
	await _shot("7_thunderbolts_wrong_%s" % tag)
	await _wait(0.6)
	right.pressed.emit()
	await _wait(0.12)
	await _shot("7_thunderbolts_strike_%s" % tag)
	for k in 3:  # on to the rounds that ask for the smallest
		await _wait(1.5)
		for c: NumberCloud in game.get("_clouds"):
			if c.value == rules.answer() and not c.disabled:
				c.pressed.emit()
				break
	await _wait(3.2)
	await _shot("7_thunderbolts_smallest_%s" % tag)
	game.set("_time_left", 9.5)  # the last seconds (the clock turns orange), then the end
	await _wait(1.0)
	await _shot("7_thunderbolts_hurry_%s" % tag)
	game.set("_time_left", 0.3)
	await _wait(1.0)
	await _shot("7_thunderbolts_results_%s" % tag)
	# the sum games: one sum, then two sums with a wrong one showing what it makes
	game.call("_choose_time")
	await _wait(0.3)
	await _shot("7_thunderbolts_games_%s" % tag)
	for mode in [ThunderboltRules.Mode.ONE_SUM, ThunderboltRules.Mode.TWO_SUMS]:
		game.call("_start", 60, mode)
		await _wait(2.6)
		await _shot("7_thunderbolts_sums%d_%s" % [mode, tag])
	rules = game.get("_rules")
	for c: NumberCloud in game.get("_clouds"):
		if c.value != rules.answer():
			c.pressed.emit()
			break
	await _wait(0.5)
	await _shot("7_thunderbolts_sum_wrong_%s" % tag)
	# Olive Harvest: the levels, filling the basket, counting together, the goat, the baskets, to 20
	App.go("res://scenes/games/olive_harvest.tscn")
	await _wait(0.6)
	await _shot("8_olives_levels_%s" % tag)
	var olives := get_tree().current_scene
	olives.call("_start", 0)
	await _wait(0.5)
	var orules: OliveRules = olives.get("_rules")
	var tree: BaseButton = null
	for c in olives.find_children("*", "", true, false):
		if c.get_meta("role", "") == "tree":
			tree = c
	for k in orules.target + 1:
		tree.pressed.emit()
	await _wait(0.25)
	await _shot("8_olives_count_flying_%s" % tag)
	await _wait(0.8)
	await _shot("8_olives_count_%s" % tag)
	for c in olives.find_children("*", "Button", true, false):
		if (c as Button).text == tr("Done"):
			c.pressed.emit()
	await _wait(2.0)
	await _shot("8_olives_counting_together_%s" % tag)
	olives.call("_start", 1)
	await _wait(0.6)
	await _shot("8_olives_match_%s" % tag)
	olives.call("_start", 2)
	await _wait(0.6)
	await _shot("8_olives_add_%s" % tag)
	olives.call("_start", 3)
	await _wait(2.6)
	await _shot("8_olives_goat_eating_%s" % tag)
	await _wait(2.5)
	await _shot("8_olives_goat_%s" % tag)
	olives.call("_start", 4)
	await _wait(0.4)
	olives.call("_drop_ten")
	await _wait(1.3)
	tree = null
	for c in olives.find_children("*", "", true, false):
		if c.get_meta("role", "") == "tree" and not c.is_queued_for_deletion():
			tree = c
	for k in 3:
		tree.pressed.emit()
	await _wait(0.9)
	await _shot("8_olives_tens_%s" % tag)
	orules = olives.get("_rules")
	orules.order_index = OliveRules.ORDERS - 1
	orules.coins = OliveRules.ORDERS - 1
	orules.first_try = 6
	olives.call("_check", orules.target, olives.get("_basket"))
	await _wait(2.4)
	await _shot("8_olives_done_%s" % tag)
	# Demeter's Harvest: the levels, a problem, a tablet carried, a wrong one, Demeter's help, solved, each level
	App.go("res://scenes/games/demeter_harvest.tscn")
	await _wait(0.6)
	await _shot("9_harvest_levels_%s" % tag)
	var harvest := get_tree().current_scene
	harvest.call("_start", 0)
	await _wait(0.8)
	await _shot("9_harvest_problem_%s" % tag)
	var hrules: HarvestRules = harvest.get("_rules")
	var htablets: Array = (harvest.get("_tablets") as Array).filter(func(t: DragTablet) -> bool: return t.value != hrules.answer)
	var carried: DragTablet = htablets[0]
	carried.dragging = true
	carried.z_index = 10
	carried.position = (harvest.get("_scale") as HarvestScale).slot_rect().get_center() + Vector2(-80, -60)
	await _shot("9_harvest_carry_%s" % tag)
	carried.dragging = false
	carried.z_index = 0
	harvest.call("_send", carried)
	await _wait(1.6)
	await _shot("9_harvest_wrong_%s" % tag)
	await _wait(2.3)
	await _shot("9_harvest_count_alone_%s" % tag)
	harvest.call("_send", htablets[1])
	await _wait(3.9 + 1.6 + hrules.answer * 0.4)
	await _shot("9_harvest_help_%s" % tag)
	await _wait(hrules.answer * 0.3 + 1.0)
	await _shot("9_harvest_help_done_%s" % tag)
	for t: DragTablet in harvest.get("_tablets"):
		if t.value == hrules.answer:
			harvest.call("_send", t)
	await _wait(1.7)
	await _shot("9_harvest_solved_%s" % tag)
	for level in [1, 2, 3, 4]:
		harvest.call("_start", level)
		await _wait(0.8)
		await _shot("9_harvest_level%d_%s" % [level + 1, tag])
	harvest.call("_start", 2)  # the missing number, with Demeter's help
	await _wait(0.5)
	hrules = harvest.get("_rules")
	htablets = (harvest.get("_tablets") as Array).filter(func(t: DragTablet) -> bool: return t.value != hrules.answer)
	harvest.call("_send", htablets[0])
	await _wait(3.9)
	harvest.call("_send", htablets[1])
	await _wait(3.9 + 1.6 + (hrules.answer + 1) * 0.7 + 0.3)
	await _shot("9_harvest_help_missing_%s" % tag)
	hrules.round_index = HarvestRules.ROUNDS
	harvest.call("_next_round")
	await _wait(1.0)
	await _shot("9_harvest_done_%s" % tag)
	# The Muses' Words: the games, a picture and five words, a wrong word, a word and four pictures
	App.go("res://scenes/games/muses_words.tscn")
	await _wait(0.6)
	await _shot("10_words_games_%s" % tag)
	var words := get_tree().current_scene
	words.call("_start", 60, WordRules.Mode.FIND_WORD)
	await _wait(0.4)
	await _shot("10_words_find_word_%s" % tag)
	var wrules: WordRules = words.get("_rules")
	for c: WordCard in words.get("_cards"):
		if c.text != wrules.answer():
			c.pressed.emit()
			break
	await _wait(0.3)
	await _shot("10_words_wrong_%s" % tag)
	words.call("_start", 60, WordRules.Mode.FIND_PICTURE)
	await _wait(0.4)
	await _shot("10_words_find_picture_%s" % tag)
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://screenshot_progress.cfg"))
	get_tree().quit()


func _find(type: Variant) -> Node:
	for n in get_tree().current_scene.find_children("*", "", true, false):
		if is_instance_of(n, type):
			return n
	return null


func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(_out.path_join(name + ".png"))
