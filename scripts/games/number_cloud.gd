class_name NumberCloud
extends BaseButton
## A cloud with a number, to tap in Zeus' Thunderbolts. It floats in, bobs gently, wobbles when it is
## the wrong one, glows when it is the hint, and bursts when Zeus's thunderbolt hits it. Its picture is
## assets/images/greek/zeus_thunderbolts/cloud_<1..3>.png when it exists, else a drawn cloud.

const SIZE := Vector2(230, 150)

var value := 0
var glowing := false
var _picture: Texture2D
var _time := randf() * TAU
var _wobble := 0.0  ## seconds left of a wobble
var _burst := -1.0  ## seconds since it burst (negative: it has not)
var _leaving := -1.0  ## seconds since it began to float away (negative: it has not)
var _arrive := 0.0  ## 0 .. 1 while it floats in


func _init(p_value: int, variant: int) -> void:
	value = p_value
	_picture = Ui.picture("greek/zeus_thunderbolts/cloud_%d.png" % (variant % 3 + 1))
	custom_minimum_size = SIZE
	size = SIZE
	pivot_offset = SIZE / 2.0
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_to_group("silent")  # (the game plays its own sounds for the clouds)


func wobble() -> void:
	_wobble = 0.5


func burst() -> void:
	_burst = 0.0
	disabled = true


func leave() -> void:
	_leaving = 0.0
	disabled = true


func is_gone() -> bool:
	return _burst > 0.6 or _leaving > 0.7


## Where Zeus's thunderbolt strikes it, in its parent's coordinates.
func target() -> Vector2:
	return position + SIZE / 2.0


func _process(delta: float) -> void:
	_time += delta
	_arrive = minf(1.0, _arrive + delta * 2.5)
	_wobble = maxf(0.0, _wobble - delta)
	if _burst >= 0.0:
		_burst += delta
	if _leaving >= 0.0:
		_leaving += delta
	var grow := 1.0
	if _burst >= 0.0:
		grow = 1.0 + _burst * 0.8
	elif is_hovered() or has_focus():
		grow = 1.06
	scale = Vector2.ONE * grow * (0.6 + 0.4 * _arrive)
	modulate.a = _arrive * (1.0 - clampf(_burst / 0.6, 0.0, 1.0)) * (1.0 - clampf(_leaving / 0.7, 0.0, 1.0))
	queue_redraw()


func _draw() -> void:
	var offset := Vector2(sin(_wobble * 40.0) * 10.0 * _wobble, sin(_time * 1.6) * 6.0 - maxf(0.0, _leaving) * 220.0)
	var rect := Rect2(offset, SIZE)
	if glowing:  # the hint: a soft golden glow behind it
		var pulse := 0.5 + 0.5 * sin(_time * 5.0)
		draw_circle(rect.get_center(), SIZE.x * 0.55, Color(1.0, 0.97, 0.86, 0.45 + 0.2 * pulse))  # (warm white: yellow over the blue sky looks green)
		draw_arc(rect.get_center(), SIZE.x * (0.56 + 0.04 * pulse), 0.0, TAU, 48, Color(1.0, 0.8, 0.2, 0.9), 5.0, true)
	if _picture != null:
		draw_texture_rect(_picture, rect, false)
	else:  # a puffy cloud of circles
		var c := rect.get_center()
		var puffs := [[Vector2(-62, 18), 44.0], [Vector2(-22, -14), 54.0], [Vector2(30, -20), 50.0],
			[Vector2(68, 14), 42.0], [Vector2(0, 24), 50.0]]
		for p in puffs:
			draw_circle(c + p[0] + Vector2(0, 5), p[1], Color(0.55, 0.65, 0.8, 0.5))
		for p in puffs:
			draw_circle(c + p[0], p[1], Color(0.98, 0.99, 1.0))
	if _burst >= 0.0:  # sparks flying out
		for k in 10:
			var a := TAU * k / 10.0
			draw_circle(rect.get_center() + Vector2(cos(a), sin(a)) * (40.0 + _burst * 260.0), 6.0 * (1.0 - _burst),
				Color(1.0, 0.9, 0.3, 1.0 - clampf(_burst / 0.6, 0.0, 1.0)))
	var font := get_theme_default_font()
	var text := str(value)
	var fs := 76
	var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var at := rect.get_center() + Vector2(-w / 2.0, fs * 0.36)
	draw_string_outline(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 10, Color.WHITE)
	draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("1f4e8c"))
