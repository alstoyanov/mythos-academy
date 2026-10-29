extends Control
## A mythology's own map (for now Ancient Greece, Grade 1): a marker for each learning area
## (arithmetic, geometry, geography, language), each at a place of the myths. A marker opens the area
## and its mini games.

var _map: MapView


func _ready() -> void:
	Ui.setup_screen(self)
	var realm := Catalog.realm(App.mythology_id)
	_map = MapView.new()
	_map.picture_file = "%s/realm_map.png" % App.mythology_id
	_map.placeholder = App.mythology_id
	add_child(_map)
	for a: Dictionary in realm.get("areas", []):
		var marker := MapMarker.new(tr(a["subject"]), tr(a["name"]), Color(a["color"]), false, a.get("glyph", ""),
			Ui.picture("%s/area_%s.png" % [App.mythology_id, a["id"]]))
		_map.add_marker(a["id"], Catalog.position_of(a), marker)
	_map.marker_pressed.connect(App.open_area)
	Ui.banner(self, tr(realm.get("name", "")), tr("Grade %d · Choose a place to learn") % int(realm.get("grade", 0)))
	Ui.back_button(self)
	var areas: Array = realm.get("areas", [])
	var first := _map.marker(App.area_id if App.area_id != "" else (areas[0]["id"] if not areas.is_empty() else ""))
	if first != null:
		first.call_deferred("grab_focus")
