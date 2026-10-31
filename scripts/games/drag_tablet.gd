class_name DragTablet
extends Control
## A clay tablet with a number: an answer to give Demeter. Drag it onto the "?" on her scale (with a
## finger or the mouse), or tap it (or press Enter on it). Released anywhere else, the game sends it
## back to its place. It can glow (the hint), be tried (dimmed: it was not the answer) and wobble.

signal tapped(tablet: DragTablet)
signal dropped(tablet: DragTablet)

const DRAG_FROM := 12.0  ## pixels the pointer moves before a press becomes a drag

var value := 0
var glowing := false
var tried := false:
	set(v):
		tried = v
		modulate.a = 0.45 if v else 1.0
var dragging := false
var home := Vector2.ZERO  ## its place in the field
var _held := false
var _grab := Vector2.ZERO  ## where the pointer holds it, from its corner
var _press_at := Vector2.ZERO
var _hovered := false
var _time := randf() * TAU
var _wobble := 0.0


func _init(p_value: int, side: float) -> void:
	value = p_value
	custom_minimum_size = Vector2(side, side)
	size = custom_minimum_size
	pivot_offset = size / 2.0
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(func() -> void: _hovered = true)
	mouse_exited.connect(func() -> void: _hovered = false)


func wobble() -> void:
	_wobble = 0.5


func _gui_input(event: InputEvent) -> void:
	if tried:
		return
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		var mb := event as InputEventMouseButton
		if mb.pressed:
			_held = true
			dragging = false
			_grab = mb.global_position - global_position
			_press_at = mb.global_position
		elif _held:
			_held = false
			if dragging:
				dragging = false
				z_index = 0
				dropped.emit(self)
			else:
				tapped.emit(self)
		accept_event()
	elif event is InputEventMouseMotion and _held:
		var mm := event as InputEventMouseMotion
		if not dragging and mm.global_position.distance_to(_press_at) > DRAG_FROM:
			dragging = true
			z_index = 10  # (over everything while it is carried)
		if dragging:
			global_position = mm.global_position - _grab
		accept_event()
	elif event.is_action_pressed("ui_accept"):
		tapped.emit(self)
		accept_event()


func _process(delta: float) -> void:
	_time += delta
	_wobble = maxf(0.0, _wobble - delta)
	var grow := 1.0
	if dragging:
		grow = 1.15
	elif (_hovered or has_focus()) and not tried:
		grow = 1.08
	scale = Vector2.ONE * grow
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2(sin(_wobble * 40.0) * 10.0 * _wobble, 0.0), size)
	if dragging:  # a soft shadow under it while it is carried
		draw_circle(size * Vector2(0.5, 0.95), size.x * 0.32, Color(0, 0, 0, 0.15))
	if glowing:
		var pulse := 0.5 + 0.5 * sin(_time * 5.0)
		draw_circle(rect.get_center(), size.x * 0.62, Color(1.0, 0.97, 0.86, 0.45 + 0.2 * pulse))
		draw_arc(rect.get_center(), size.x * (0.63 + 0.04 * pulse), 0.0, TAU, 48, Color(1.0, 0.8, 0.2, 0.9), 5.0, true)
	if has_focus() and not tried:
		draw_arc(rect.get_center(), size.x * 0.58, 0.0, TAU, 40, Color.WHITE, 4.0, true)
	NumberTablet.draw_tablet(self, rect, value)
