class_name NumberTablet
extends BaseButton
## A clay tablet with a big number: an answer to tap in Olive Harvest, or (not tappable) the number
## the merchant asks for. It can glow (the hint) and wobble (a wrong pick). Picture:
## greek/olive_harvest/number_tablet.png; without it a drawn tablet. Other pieces draw a tablet of
## their own with draw_tablet (Demeter's scale).

const PICTURE := "greek/olive_harvest/number_tablet.png"

var value := 0
var glowing := false
var _time := randf() * TAU
var _wobble := 0.0


func _init(p_value: int, side: float = 130.0) -> void:
	value = p_value
	custom_minimum_size = Vector2(side, side)
	size = custom_minimum_size
	pivot_offset = size / 2.0
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_to_group("silent")  # (the game plays its own sounds)


func wobble() -> void:
	_wobble = 0.5


func _process(delta: float) -> void:
	_time += delta
	_wobble = maxf(0.0, _wobble - delta)
	scale = Vector2.ONE * (1.06 if (is_hovered() or has_focus()) and not disabled else 1.0)
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2(sin(_wobble * 40.0) * 10.0 * _wobble, 0.0), size)
	if glowing:
		var pulse := 0.5 + 0.5 * sin(_time * 5.0)
		draw_circle(rect.get_center(), size.x * 0.62, Color(1.0, 0.97, 0.86, 0.45 + 0.2 * pulse))
		draw_arc(rect.get_center(), size.x * (0.63 + 0.04 * pulse), 0.0, TAU, 48, Color(1.0, 0.8, 0.2, 0.9), 5.0, true)
	draw_tablet(self, rect, value)


static var _style: StyleBoxFlat
static var _picture: Texture2D
static var _looked := false


## Draws a tablet with `value` filling `rect` on `ci` (in its _draw): the picture, or a drawn one. A
## negative value is a number still to be found: "?".
static func draw_tablet(ci: Control, rect: Rect2, value: int) -> void:
	if not _looked:
		_picture = Ui.picture(PICTURE)
		_looked = true
	if _picture != null:
		ci.draw_texture_rect(_picture, rect, false)
	else:
		ci.draw_style_box(_box(), rect.grow(-rect.size.x * 0.08))
	var font := ci.get_theme_default_font()
	var text := str(value) if value >= 0 else "?"
	var fs := int(rect.size.y * 0.5)
	var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	ci.draw_string(font, rect.get_center() + Vector2(-w / 2.0, fs * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs,
		Color("5a2a14"))


static func _box() -> StyleBoxFlat:
	if _style == null:
		_style = StyleBoxFlat.new()
		_style.bg_color = Color("d9794a")
		_style.set_corner_radius_all(18)
		_style.set_border_width_all(5)
		_style.border_color = Color("a8552d")
	return _style
