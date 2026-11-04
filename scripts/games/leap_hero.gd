class_name LeapHero
extends Control
## Hercules in Hercules' Leaps, in one of his poses ("idle", "jump", "happy", "think"), his feet on the
## bottom edge and the middle of his body at FEET across (the framing of tools/prepare_art.py "figure").
## Pictures: greek/hercules_leaps/hercules_<pose>.png; each has a drawn stand-in.

const ART := "greek/hercules_leaps/hercules_%s.png"
const SIDE := 250.0
const FEET := 0.45
const SKIN := Color("e8b48a")
const HAIR := Color("5a3418")
const TUNIC := Color("c9502e")
const PELT := Color("d9a441")

var pose := "idle":
	set(v):
		pose = v
		queue_redraw()
var _pictures := {}


func _init() -> void:
	size = Vector2(SIDE, SIDE)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for p in ["idle", "jump", "happy", "think"]:
		var tex := Ui.picture(ART % p)
		if tex != null:
			_pictures[p] = tex


## Where his top left corner goes for his feet to be at `feet`.
static func corner_for(feet: Vector2) -> Vector2:
	return feet - Vector2(SIDE * FEET, SIDE)


func _draw() -> void:
	if _pictures.has(pose):
		draw_texture_rect(_pictures[pose], Rect2(Vector2.ZERO, size), false)
	else:
		_draw_stand_in()


## A simple figure: a tunic with a lion's pelt, the arms and legs telling the pose.
func _draw_stand_in() -> void:
	var c := SIDE * FEET
	var hip := Vector2(c, SIDE - 70.0)
	var neck := Vector2(c, SIDE - 150.0)
	var stride := 40.0 if pose == "jump" else 16.0
	var knee_up := 22.0 if pose == "jump" else 0.0
	draw_line(hip, Vector2(c - stride, SIDE - 4.0 - knee_up), SKIN, 15.0, true)
	draw_line(hip, Vector2(c + stride, SIDE - 4.0 - knee_up), SKIN, 15.0, true)
	var hand_left := neck + Vector2(-44.0, 56.0)
	var hand_right := neck + Vector2(44.0, 56.0)
	match pose:
		"jump":
			hand_left = neck + Vector2(-52.0, -6.0)
			hand_right = neck + Vector2(56.0, -24.0)
		"happy":
			hand_left = neck + Vector2(-42.0, -52.0)
			hand_right = neck + Vector2(42.0, -52.0)
		"think":
			hand_right = neck + Vector2(18.0, -14.0)
	draw_line(neck + Vector2(-20.0, 8.0), hand_left, SKIN, 13.0, true)
	draw_line(neck + Vector2(20.0, 8.0), hand_right, SKIN, 13.0, true)
	draw_colored_polygon(PackedVector2Array([
		neck + Vector2(-27.0, 0.0), neck + Vector2(27.0, 0.0), hip + Vector2(32.0, 16.0), hip + Vector2(-32.0, 16.0),
	]), TUNIC)
	draw_colored_polygon(PackedVector2Array([
		neck + Vector2(-27.0, 0.0), neck + Vector2(4.0, 0.0), hip + Vector2(-8.0, 0.0), hip + Vector2(-30.0, 0.0),
	]), PELT)
	var head := neck + Vector2(0.0, -30.0)
	draw_circle(head + Vector2(0.0, -6.0), 34.0, HAIR)
	draw_circle(head, 28.0, SKIN)
	draw_circle(head + Vector2(-9.0, -3.0), 3.5, HAIR)
	draw_circle(head + Vector2(11.0, -3.0), 3.5, HAIR)
	if pose == "think":
		draw_line(head + Vector2(-7.0, 13.0), head + Vector2(9.0, 13.0), HAIR, 3.0, true)
	else:
		draw_arc(head + Vector2(1.0, 7.0), 11.0, 0.3, PI - 0.3, 12, HAIR, 3.0, true)
