extends Node
## Every text a player can see has its Bulgarian translation (Translations.BG): the names and lines of
## data/ (the lands, areas, places and games), and the texts of the scripts (those given to tr(), to
## Ui.label / Ui.button, to Settings' switches, Zeus' praise, the game cards' buttons). Then the menus
## in Bulgarian, the game's first language.
##   godot --headless --path . res://tests/translations_test.tscn
## Exits with 0 on success, 1 on failure.

var _failures := 0


func _ready() -> void:
	var keys := _texts()
	var missing: Array[String] = []
	for k in keys:
		if not Translations.BG.has(k):
			missing.append(k)
	print("%d texts, %d without a Bulgarian translation" % [keys.size(), missing.size()])
	for k in missing:
		print("  missing: " + k)
	_check(missing.is_empty(), "every text has its Bulgarian translation")
	_check(Translations.DEFAULT == "bg" and Translations.LANGUAGES[0][0] == "bg", "Bulgarian is the first language")
	for key: String in Translations.BG:
		var bg: String = Translations.BG[key]
		_check(bg.count("%") == key.count("%"), "the same %%d / %%s in \"%s\"" % key)

	TranslationServer.set_locale("bg")
	App.language = "bg"
	var stand_in := Node.new()
	get_tree().root.add_child.call_deferred(stand_in)
	await get_tree().process_frame
	get_tree().current_scene = stand_in
	get_tree().change_scene_to_file(App.MAIN_MENU)
	for i in 3:
		await get_tree().process_frame
	var menu := get_tree().current_scene
	var play: Button = null
	for b in menu.find_children("*", "Button", true, false):
		if (b as Button).text == "Play":
			play = b
	_check(play != null and play.tr(play.text) == "Играй", "the menu is in Bulgarian")
	print("FAILED: %d" % _failures if _failures > 0 else "ALL PASSED")
	get_tree().quit(1 if _failures > 0 else 0)


## The texts: from the content data and from the scripts' source.
func _texts() -> Array[String]:
	var out: Array[String] = []
	for m in Catalog.mythologies():
		_add(out, m.get("name", ""))
		var realm := Catalog.realm(m["id"])
		_add(out, realm.get("name", ""))
		_add(out, realm.get("guide", ""))
		for a: Dictionary in realm.get("areas", []):
			for field in ["subject", "name", "place"]:
				_add(out, a.get(field, ""))
			for g: Dictionary in a.get("games", []):
				for field in ["title", "skill", "blurb"]:
					_add(out, g.get(field, ""))
	var patterns := [
		'tr\\("((?:[^"\\\\]|\\\\.)*)"',  # tr("...")
		'Ui\\.(?:label|button)\\([^,"]+, "((?:[^"\\\\]|\\\\.)*)"',  # Ui.label(parent, "...") / Ui.button
		'_switch\\(col, "([^"]+)"',  # Settings' switches
		'tr\\("(?:[^"\\\\]|\\\\.)*" if [^\\n]*? else "((?:[^"\\\\]|\\\\.)*)"\\)',  # the second of tr("..." if ... else "...")
	]
	for file in _scripts("res://scripts"):
		var source := FileAccess.get_file_as_string(file)
		for p: String in patterns:
			var re := RegEx.create_from_string(p)
			for m in re.search_all(source):
				_add(out, m.get_string(1).replace("\\\"", "\""))
	var zeus: GDScript = load("res://scripts/games/zeus_thunderbolts.gd")
	for line: String in zeus.get_script_constant_map()["PRAISE"]:
		_add(out, line)
	var area: GDScript = load("res://scripts/area.gd")
	for line: String in (area.get_script_constant_map()["STATUS"] as Dictionary).values():
		_add(out, line)
	return out


func _add(out: Array[String], text: String) -> void:
	if text != "" and not out.has(text) and text.strip_edges() != "" and not text.is_valid_int():
		out.append(text)


func _scripts(dir: String) -> Array[String]:
	var out: Array[String] = []
	for f in DirAccess.get_files_at(dir):
		if f.ends_with(".gd"):
			out.append(dir.path_join(f))
	for d in DirAccess.get_directories_at(dir):
		out.append_array(_scripts(dir.path_join(d)))
	return out


func _check(ok: bool, what: String) -> void:
	if not ok:
		_failures += 1
		print("  FAIL: " + what)
