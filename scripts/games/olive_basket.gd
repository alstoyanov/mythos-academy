class_name OliveBasket
extends BaseButton
## A wicker basket with `count` olives heaped in it, in rows of `row` (5, or 10 for counting to 20), so
## the olives can be counted. It can glow (the hint), mark one olive with its number (counting
## together), wobble (a wrong pick) and hop. Pictures: greek/olive_harvest/basket_empty.png and the
## olives; without them a drawn basket.

const ART := "greek/olive_harvest/"

var count := 0:
	set(v):
		count = maxi(0, v)
		queue_redraw()
var row := 5
var glowing := false
var counted := -1  ## the olive being counted (its number is shown over it), -1 none
var _basket: Texture2D
var _olives: Array[Texture2D] = []
var _time := randf() * TAU
var _wobble := 0.0
var _hop := 0.0


func _init(p_size: Vector2, p_count: int = 0, p_row: int = 5) -> void:
	custom_minimum_size = p_size
	size = p_size
	pivot_offset = p_size / 2.0
	count = p_count
	row = p_row
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_to_group("silent")  # (the game plays its own sounds)
	_basket = Ui.picture(ART + "basket_empty.png")
	for name in ["olive_green.png", "olive_black.png"]:
		var tex := Ui.picture(ART + name)
		if tex != null:
			_olives.append(tex)


func wobble() -> void:
	_wobble = 0.5


func hop() -> void:
	_hop = 0.25


## The olive's size, and where olive `i` sits (in this control): rows from the bottom of the heap up.
func olive_size() -> float:
	return size.x * (0.15 if row <= 5 else 0.085)


func olive_position(i: int) -> Vector2:
	var s := olive_size()
	var r := i / row
	var c := i % row
	var across := size.x * (0.76 if row <= 5 else 0.8)
	var gap := across / row
	var x := size.x / 2.0 - across / 2.0 + gap * (c + 0.5) + (gap * 0.5 if r % 2 == 1 and row <= 5 else 0.0)
	var y := size.y * 0.4 - r * s * 0.8
	return Vector2(x, y)


func _process(delta: float) -> void:
	_time += delta
	_wobble = maxf(0.0, _wobble - delta)
	_hop = maxf(0.0, _hop - delta)
	var grow := 1.04 if (is_hovered() or has_focus()) and not disabled else 1.0
	scale = Vector2.ONE * grow
	queue_redraw()


func _draw() -> void:
	var shift := Vector2(sin(_wobble * 40.0) * 10.0 * _wobble, -sin(_hop / 0.25 * PI) * 16.0)
	var rect := Rect2(shift, size)
	if glowing:
		var pulse := 0.5 + 0.5 * sin(_time * 5.0)
		draw_circle(rect.get_center(), size.x * 0.52, Color(1.0, 0.97, 0.86, 0.45 + 0.2 * pulse))
		draw_arc(rect.get_center(), size.x * (0.53 + 0.03 * pulse), 0.0, TAU, 48, Color(1.0, 0.8, 0.2, 0.9), 5.0, true)
	# the basket, then the olives heaped on it (all in view, so they can be counted)
	if _basket != null:
		draw_texture_rect(_basket, Rect2(shift + Vector2(0, size.y * 0.1), size * Vector2(1.0, 0.9)), false)
	else:
		var c := rect.get_center() + Vector2(0, size.y * 0.15)
		draw_colored_polygon(PackedVector2Array([c + Vector2(-size.x * 0.42, -size.y * 0.15),
			c + Vector2(size.x * 0.42, -size.y * 0.15), c + Vector2(size.x * 0.32, size.y * 0.3),
			c + Vector2(-size.x * 0.32, size.y * 0.3)]), Color("c89a52"))
	for i in count:
		_draw_olive(shift + olive_position(i), olive_size(), i)
	if counted >= 0 and counted < count:  # the olive being counted: a ring and its number
		var p := shift + olive_position(counted)
		draw_arc(p, olive_size() * 0.75, 0.0, TAU, 32, Color.WHITE, 5.0, true)
		var font := get_theme_default_font()
		var text := str(counted + 1)
		var fs := 54
		var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var at := p + Vector2(-w / 2.0, -olive_size() * 0.9)
		draw_string_outline(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 10, Color.WHITE)
		draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("3d5a1e"))


func _draw_olive(at: Vector2, s: float, i: int) -> void:
	if _olives.is_empty():
		draw_circle(at, s * 0.45, Color("6b8e23") if i % 3 != 1 else Color("3b2a4a"))
		return
	var tex := _olives[(i * 7 + 3) % 5 % _olives.size()]
	draw_texture_rect(tex, Rect2(at - Vector2(s, s) / 2.0, Vector2(s, s)), false)
