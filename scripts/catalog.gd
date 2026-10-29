class_name Catalog
extends RefCounted
## The game's content, read from data/ (see docs/SPECIFICATION.md, "Content data"):
##   data/mythologies.json   the mythologies on the world map, one per school grade
##   data/realms/<id>.json   a mythology's realm: its learning areas and their mini games
## Loaded once and kept.

const MYTHOLOGIES_PATH := "res://data/mythologies.json"

static var _mythologies: Array[Dictionary] = []
static var _realms: Dictionary = {}


## Every mythology, in grade order: {id, name, grade, available, color, map_pos, realm}.
static func mythologies() -> Array[Dictionary]:
	if _mythologies.is_empty():
		var data := _read(MYTHOLOGIES_PATH)
		for m: Dictionary in data.get("mythologies", []):
			_mythologies.append(m)
		_mythologies.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["grade"]) < int(b["grade"]))
	return _mythologies


static func mythology(id: String) -> Dictionary:
	for m in mythologies():
		if m["id"] == id:
			return m
	return {}


## A mythology's realm: {id, name, grade, guide, areas: [{id, subject, name, place, color, map_pos,
## games: [{id, title, skill, blurb, status}]}]}, or {} if it has none yet.
static func realm(mythology_id: String) -> Dictionary:
	if not _realms.has(mythology_id):
		var path: String = mythology(mythology_id).get("realm", "")
		_realms[mythology_id] = _read(path) if path != "" else {}
	return _realms[mythology_id]


static func area(mythology_id: String, area_id: String) -> Dictionary:
	for a: Dictionary in realm(mythology_id).get("areas", []):
		if a["id"] == area_id:
			return a
	return {}


## A map position from the data ([x, y], 0..1 across the map) as a Vector2.
static func position_of(entry: Dictionary) -> Vector2:
	var p: Array = entry.get("map_pos", [0.5, 0.5])
	return Vector2(float(p[0]), float(p[1]))


static func _read(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("Missing content file " + path)
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if parsed is Dictionary:
		return parsed
	push_warning("Invalid content file " + path)
	return {}
