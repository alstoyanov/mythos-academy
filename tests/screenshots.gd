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
