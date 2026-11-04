class_name Balloon
extends Control
## One balloon of Aeolus' Balloons, drawn in code (no picture): its size grows with its number, the number
## is written on it and a string hangs down to the rope. It bobs gently in the wind. A tap emits
## `pressed`; a swipe sideways (more than half its width) emits `swiped` with -1 (left) or 1 (right).
## `selected` lifts it, `glow` makes it pulse (the hint), `hop` is a jump (the celebration).

signal pressed
signal swiped(direction: int)

const COLORS := [
	Color("e5484d"), Color("f08c2e"), Color("f2c230"), Color("8cc63f"), Color("3fae6a"),
	Color("2fb5b0"), Color("3f7fc4"), Color("8a5cc7"), Color("e062a8"),
]  ## by number 1 .. 9
const SMALLEST := 0.52  ## the diameter of the number 1, and of 9 (1.0), as a part of the place's width
const LIFT := 20.0

var value := 1
var selected := false:
	set(v):
		selected = v
		queue_redraw()
var glow := false:
	set(v):
		glow = v
		queue_redraw()
var hop := 0.0:  ## pixels up
	set(v):
		hop = v
		queue_redraw()
var _phase := 0.0
var _press_x := 0.0
var _down := false


func _init(p_value: int = 1) -> void:
	value = p_value
	mouse_filter = Control.MOUSE_FILTER_STOP
	_phase = randf() * TAU


## The part of the place's width the balloon of `n` is across.
static func width_part(n: int) -> float:
	return lerpf(SMALLEST, 0.95, float(n - BalloonRules.MIN_NUMBER) / float(BalloonRules.MAX_NUMBER - BalloonRules.MIN_NUMBER))


## The height of the body of the biggest balloon in a place `w` wide (the room to leave above the knot).
static func body_height(w: float, n: int) -> float:
	return w * width_part(n) * 1.15


func _process(_delta: float) -> void:
	queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_down = true
			_press_x = (event as InputEventMouseButton).position.x
		elif _down:
			_down = false
			pressed.emit()
		accept_event()
	elif event is InputEventMouseMotion and _down:
		var dx: float = (event as InputEventMouseMotion).position.x - _press_x
		if absf(dx) > size.x * 0.5:
			_down = false
			swiped.emit(1 if dx > 0.0 else -1)
		accept_event()


func _draw() -> void:
	var t := Time.get_ticks_msec() / 1000.0
	var bob := sin(t * 1.6 + _phase) * 4.0
	var knot := Vector2(size.x / 2.0, body_height(size.x, BalloonRules.MAX_NUMBER) + 6.0)
	var lift := -hop - (LIFT if selected else 0.0) + bob
	var d := size.x * width_part(value)
	var h := d * 1.15
	var color: Color = COLORS[clampi(value, 1, 9) - 1]
	var center := knot + Vector2(0.0, lift - h * 0.5 + 4.0)
	var tip := knot + Vector2(0.0, lift + 4.0)
	# the string, down to the rope
	draw_polyline(PackedVector2Array([tip, tip.lerp(Vector2(knot.x + 6.0, size.y), 0.5) + Vector2(5.0, 0.0), Vector2(knot.x, size.y)]),
		Color(0.35, 0.28, 0.2, 0.85), 2.0, true)
	if glow:
		var pulse := 0.5 + 0.5 * sin(t * 6.0)
		_ellipse(center, d * 0.5 + 10.0 + pulse * 6.0, h * 0.5 + 10.0 + pulse * 6.0, Color(1.0, 0.95, 0.5, 0.35 + 0.3 * pulse))
	# the body: an egg, with a knot and a shine
	draw_colored_polygon(PackedVector2Array([tip, tip + Vector2(-9.0, 12.0), tip + Vector2(9.0, 12.0)]), color.darkened(0.2))
	_ellipse(center, d * 0.5, h * 0.5, color)
	if selected:
		_ring(center, d * 0.5, h * 0.5, Color("fff3b0"), 5.0)
	else:
		_ring(center, d * 0.5, h * 0.5, color.darkened(0.3), 2.5)
	_ellipse(center + Vector2(-d * 0.2, -h * 0.22), d * 0.1, h * 0.14, Color(1, 1, 1, 0.35))
	var font := get_theme_default_font()
	var font_size := int(d * 0.5)
	var text := str(value)
	var at := Vector2(center.x - size.x / 2.0, center.y + font_size * 0.36)
	draw_string_outline(font, at, text, HORIZONTAL_ALIGNMENT_CENTER, size.x, font_size, 8, Color(0.2, 0.12, 0.08, 0.85))
	draw_string(font, at, text, HORIZONTAL_ALIGNMENT_CENTER, size.x, font_size, Color.WHITE)


func _ellipse(c: Vector2, rx: float, ry: float, color: Color) -> void:
	draw_colored_polygon(_oval(c, rx, ry), color)


func _ring(c: Vector2, rx: float, ry: float, color: Color, width: float) -> void:
	var pts := _oval(c, rx, ry)
	pts.append(pts[0])
	draw_polyline(pts, color, width, true)


func _oval(c: Vector2, rx: float, ry: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 40:
		var a := i * TAU / 40.0
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts
