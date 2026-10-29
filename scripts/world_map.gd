extends Control
## The map of the ancient world: a marker for each mythology, one per school grade. An open one leads
## to its realm map; a locked one says which grade it belongs to and that it is coming.

var _map: MapView


func _ready() -> void:
	Ui.setup_screen(self)
	_map = MapView.new()
	_map.picture_file = "world/world_map.png"
	_map.placeholder = "world"
	add_child(_map)
	for m in Catalog.mythologies():
		var open: bool = m.get("available", false)
		var marker := MapMarker.new(tr(m["name"]), tr("Grade %d" if open else "Grade %d · soon") % int(m["grade"]),
			Color(m["color"]), not open, str(int(m["grade"])), Ui.picture("world/marker_%s.png" % m["id"]))
		_map.add_marker(m["id"], Catalog.position_of(m), marker)
	_map.marker_pressed.connect(_on_marker)
	Ui.banner(self, tr("Choose a land to explore"), "", true)  # (at the bottom: the map's open sea)
	Ui.back_button(self)
	var first := _map.marker(App.mythology_id if App.mythology_id != "" else "greek")
	if first != null:
		first.call_deferred("grab_focus")


func _on_marker(id: String) -> void:
	var m := Catalog.mythology(id)
	if m.get("available", false) and not Catalog.realm(id).is_empty():
		App.open_mythology(id)
	else:
		Ui.toast(self, tr("%s opens in Grade %d. Coming soon!") % [tr(m["name"]), int(m["grade"])])
