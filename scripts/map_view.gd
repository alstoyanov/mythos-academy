class_name MapView
extends Control
## A map filling the screen with markers on it. The map keeps its shape (ASPECT): it is fitted inside
## the screen whole, and the rest of the screen is the sea. Markers sit at positions given from 0 to 1
## across the map, so they stay on their places at any screen size, on a PC or a phone.
## The map is the picture at `picture_file` (assets/images/...) when there is one; until then a
## simple placeholder is drawn ("world": the lands around the Mediterranean and Asia; "greek": the
## Greek mainland and the Aegean islands).

signal marker_pressed(id: String)

const ASPECT := 16.0 / 9.0

var picture_file := ""
var placeholder := "world"
var _picture: Texture2D
var _markers: Array[Dictionary] = []  # {id, node: MapMarker, pos: Vector2}


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_picture = Ui.picture(picture_file) if picture_file != "" else null
	resized.connect(_place_markers)


func add_marker(id: String, pos: Vector2, marker: MapMarker) -> void:
	add_child(marker)
	marker.pressed.connect(func() -> void: marker_pressed.emit(id))
	_markers.append({"id": id, "node": marker, "pos": pos})
	_place_markers()


func marker(id: String) -> MapMarker:
	for m in _markers:
		if m["id"] == id:
			return m["node"]
	return null


## The rectangle the map is drawn in: as big as fits, centred.
func map_rect() -> Rect2:
	var w := size.x
	var h := size.x / ASPECT
	if h > size.y:
		h = size.y
		w = h * ASPECT
	return Rect2((size - Vector2(w, h)) / 2.0, Vector2(w, h))


func to_screen(pos: Vector2) -> Vector2:
	var r := map_rect()
	return r.position + pos * r.size


func _place_markers() -> void:
	for m in _markers:
		var node: MapMarker = m["node"]
		node.position = to_screen(m["pos"]) - node.anchor_point()
	queue_redraw()


func _draw() -> void:
	var r := map_rect()
	if _picture != null:  # around a painted map: its parchment
		draw_rect(Rect2(Vector2.ZERO, size), Color("ead9b0"))
		draw_texture_rect(_picture, r, false)
		return
	draw_rect(Rect2(Vector2.ZERO, size), Ui.SEA.darkened(0.08))
	draw_rect(r, Ui.SEA)
	for i in 6:  # a few waves
		var y := r.position.y + r.size.y * (0.12 + 0.15 * i)
		for k in 5:
			var x := r.position.x + r.size.x * (0.08 + 0.2 * k + 0.06 * (i % 2))
			draw_arc(Vector2(x, y), r.size.x * 0.012, PI * 1.1, PI * 1.9, 8, Color(1, 1, 1, 0.35), 2.0, true)
	for shape: PackedVector2Array in (_world_lands() if placeholder == "world" else _greek_lands()):
		var pts := PackedVector2Array()
		for p in shape:
			pts.append(r.position + p * r.size)
		draw_colored_polygon(pts, Ui.PARCHMENT)
		pts.append(pts[0])
		draw_polyline(pts, Color("b89a62"), 3.0, true)
	draw_rect(r, Ui.GOLD, false, 6.0)


## The placeholder world: Europe, Africa and Asia, very roughly, with Greece sticking out.
static func _world_lands() -> Array[PackedVector2Array]:
	return [
		PackedVector2Array([Vector2(0.16, 0.0), Vector2(0.56, 0.0), Vector2(0.60, 0.24), Vector2(0.50, 0.30),
			Vector2(0.47, 0.33), Vector2(0.40, 0.31), Vector2(0.33, 0.38), Vector2(0.24, 0.36), Vector2(0.14, 0.24)]),
		PackedVector2Array([Vector2(0.42, 0.30), Vector2(0.47, 0.32), Vector2(0.46, 0.44), Vector2(0.43, 0.46),
			Vector2(0.40, 0.40)]),
		PackedVector2Array([Vector2(0.16, 0.56), Vector2(0.38, 0.52), Vector2(0.47, 0.55), Vector2(0.58, 0.55),
			Vector2(0.63, 0.74), Vector2(0.56, 1.0), Vector2(0.26, 1.0), Vector2(0.13, 0.76)]),
		PackedVector2Array([Vector2(0.56, 0.0), Vector2(1.0, 0.0), Vector2(1.0, 0.78), Vector2(0.88, 0.70),
			Vector2(0.81, 0.86), Vector2(0.74, 0.64), Vector2(0.67, 0.62), Vector2(0.62, 0.53), Vector2(0.56, 0.44),
			Vector2(0.52, 0.38), Vector2(0.60, 0.24)]),
	]


## The placeholder Greece: the mainland and the Peloponnese on the left, islands in the Aegean.
static func _greek_lands() -> Array[PackedVector2Array]:
	var lands: Array[PackedVector2Array] = [
		PackedVector2Array([Vector2(0.0, 0.0), Vector2(0.64, 0.0), Vector2(0.60, 0.18), Vector2(0.64, 0.40),
			Vector2(0.68, 0.52), Vector2(0.58, 0.60), Vector2(0.46, 0.56), Vector2(0.34, 0.54), Vector2(0.22, 0.50),
			Vector2(0.10, 0.56), Vector2(0.0, 0.52)]),
		PackedVector2Array([Vector2(0.14, 0.60), Vector2(0.36, 0.58), Vector2(0.46, 0.64), Vector2(0.44, 0.80),
			Vector2(0.38, 0.96), Vector2(0.30, 0.84), Vector2(0.22, 0.94), Vector2(0.16, 0.80)]),
	]
	for island in [[Vector2(0.80, 0.42), 0.07], [Vector2(0.90, 0.24), 0.035], [Vector2(0.86, 0.64), 0.045],
			[Vector2(0.72, 0.80), 0.04], [Vector2(0.62, 0.90), 0.06]]:
		var c: Vector2 = island[0]
		var rad: float = island[1]
		var pts := PackedVector2Array()
		for k in 14:
			var a := TAU * k / 14.0
			var wobble := 1.0 + 0.18 * sin(a * 3.0 + c.x * 10.0)
			pts.append(c + Vector2(cos(a), sin(a) * ASPECT) * rad * wobble)
		lands.append(pts)
	return lands
