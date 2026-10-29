extends Node
## The menus from the title screen to a learning area: the content loads, the Greek marker opens its
## realm, each area opens with its games, a locked land only shows a message, and Back goes back.
##   godot --headless --path . res://tests/navigation_test.tscn
## Exits with 0 on success, 1 on failure.

var _failures := 0


func _ready() -> void:
	# This node stays while the screens change: a stand-in is the scene the first change replaces.
	var stand_in := Node.new()
	get_tree().root.add_child.call_deferred(stand_in)
	await get_tree().process_frame
	get_tree().current_scene = stand_in
	App.language = "en"  # (the checks look for the English texts; not saved)
	TranslationServer.set_locale("en")
	var myths := Catalog.mythologies()
	_check(myths.size() >= 4, "mythologies on the world map (%d)" % myths.size())
	_check(myths[0]["id"] == "greek" and int(myths[0]["grade"]) == 1 and myths[0]["available"], "Greece is Grade 1 and open")
	_check(myths.filter(func(m: Dictionary) -> bool: return m["available"]).size() == 1, "only Greece is open for now")
	var realm := Catalog.realm("greek")
	var subjects: Array = realm.get("areas", []).map(func(a: Dictionary) -> String: return a["id"])
	_check(subjects == ["arithmetic", "geometry", "geography", "language"], "the four areas (%s)" % str(subjects))
	for a: Dictionary in realm["areas"]:
		var p := Catalog.position_of(a)
		_check(p.x > 0.0 and p.x < 1.0 and p.y > 0.0 and p.y < 1.0, "%s is on the map" % a["id"])
		_check(not (a["games"] as Array).is_empty(), "%s has a game" % a["id"])

	await _open(App.MAIN_MENU)
	_check(_button("Play") != null, "the title screen has Play")
	_button("Play").pressed.emit()
	await _settle()
	_check(_scene() == App.WORLD_MAP, "Play opens the world map")
	var world: MapView = _find(MapView)
	_check(world != null and world.marker("egyptian").locked, "Egypt is locked")
	world.marker("egyptian").pressed.emit()
	await get_tree().process_frame
	_check(_scene() == App.WORLD_MAP and _has_text("Coming soon"), "a locked land only says it is coming")
	world.marker("greek").pressed.emit()
	await _settle()
	_check(_scene() == App.REALM_MAP and App.mythology_id == "greek", "the Greek marker opens Greece")
	for id: String in subjects:
		var realm_map: MapView = _find(MapView)
		realm_map.marker(id).pressed.emit()
		await _settle()
		_check(_scene() == App.AREA and App.area_id == id, "the %s marker opens its area" % id)
		var card := _button("Coming soon")
		if card == null:
			card = _button("Coming later")
		if card == null:
			card = _button("Play")
		_check(card != null, "%s lists its game" % id)
		App.back()
		await _settle()
		_check(_scene() == App.REALM_MAP, "Back from %s returns to the map of Greece" % id)
	App.back()
	await _settle()
	_check(_scene() == App.WORLD_MAP, "Back returns to the world map")
	App.back()
	await _settle()
	_check(_scene() == App.MAIN_MENU, "and then to the title screen")
	print("FAILED: %d" % _failures if _failures > 0 else "ALL PASSED")
	get_tree().quit(1 if _failures > 0 else 0)


func _open(scene: String) -> void:
	get_tree().change_scene_to_file(scene)
	await _settle()


func _settle() -> void:
	for i in 3:
		await get_tree().process_frame


func _scene() -> String:
	return get_tree().current_scene.scene_file_path if get_tree().current_scene != null else ""


func _find(type: Variant) -> Node:
	for n in get_tree().current_scene.find_children("*", "", true, false):
		if is_instance_of(n, type):
			return n
	return null


func _button(text: String) -> Button:
	for b in get_tree().current_scene.find_children("*", "Button", true, false):
		if (b as Button).text == text:
			return b
	return null


func _has_text(part: String) -> bool:
	for l in get_tree().current_scene.find_children("*", "Label", true, false):
		if (l as Label).text.contains(part):
			return true
	return false


func _check(ok: bool, what: String) -> void:
	if not ok:
		_failures += 1
		print("  FAIL: " + what)
