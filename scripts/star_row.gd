class_name StarRow
extends Control
## Three stars, `filled` of them gold, the rest grey outlines (a level's stars; drawn, so they need no
## font glyph).

var filled := 0
var star_size := 40.0


func _init(p_filled: int, p_size: float = 40.0) -> void:
	filled = clampi(p_filled, 0, 3)
	star_size = p_size
	custom_minimum_size = Vector2(p_size * 3.3, p_size)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _draw() -> void:
	var r := star_size / 2.0
	for k in 3:
		var c := Vector2(r + k * star_size * 1.15, size.y / 2.0)
		var pts := PackedVector2Array()
		for p in 10:
			var a := -PI / 2.0 + p * TAU / 10.0
			pts.append(c + Vector2(cos(a), sin(a)) * (r if p % 2 == 0 else r * 0.45))
		if k < filled:
			draw_colored_polygon(pts, Color("f2b632"))
			pts.append(pts[0])
			draw_polyline(pts, Color("a8741a"), 2.5, true)
		else:
			pts.append(pts[0])
			draw_polyline(pts, Color(0.45, 0.4, 0.35, 0.6), 2.5, true)
