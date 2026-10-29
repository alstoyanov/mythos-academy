class_name MapMarker
extends BaseButton
## A place to tap on a map: a round badge in its colour with a short label under it. An open one
## gently bobs to invite a tap; a locked one is greyed, with a padlock. Its picture, when the art
## exists, is assets/images/<icon> (a round emblem, see assets/prompts/IMAGE_PROMPTS.md); otherwise
## the badge shows `glyph`.

const RADIUS := 50.0

var title := ""
var subtitle := ""
var color := Color.WHITE
var locked := false
var glyph := ""  ## a letter or number shown on the badge when there is no picture
var icon: Texture2D

var _time := randf() * TAU


func _init(p_title: String, p_subtitle: String, p_color: Color, p_locked: bool, p_glyph: String, p_icon: Texture2D) -> void:
	title = p_title
	subtitle = p_subtitle
	color = p_color
	locked = p_locked
	glyph = p_glyph
	icon = p_icon
	focus_mode = Control.FOCUS_ALL
	custom_minimum_size = Vector2(RADIUS * 4.4, RADIUS * 2.0 + 74.0)
	size = custom_minimum_size
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)


## Where the badge's centre is, in this control (the control is placed so this sits on the map point).
func anchor_point() -> Vector2:
	return Vector2(size.x / 2.0, RADIUS + 6.0)


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _draw() -> void:
	var font := get_theme_default_font()
	var hover := is_hovered() or has_focus()
	var bob := 0.0 if locked else sin(_time * 2.2) * 4.0
	var grow := 1.12 if hover and not locked else 1.0
	if get_draw_mode() == DRAW_PRESSED or get_draw_mode() == DRAW_HOVER_PRESSED:
		grow = 0.94
	var r := RADIUS * grow
	var c := anchor_point() + Vector2(0.0, bob)
	var fill := color if not locked else color.lerp(Color(0.55, 0.55, 0.55), 0.65)
	draw_circle(c + Vector2(0, 6), r, Color(0, 0, 0, 0.25))  # shadow
	draw_circle(c, r, fill)
	if icon != null:
		var side := r * 1.8
		draw_texture_rect(icon, Rect2(c - Vector2(side, side) / 2.0, Vector2(side, side)), false,
			Color(1, 1, 1, 1) if not locked else Color(0.6, 0.6, 0.6, 1))
	elif glyph != "":
		var gs := int(r * 0.9)
		var w := font.get_string_size(glyph, HORIZONTAL_ALIGNMENT_LEFT, -1, gs).x
		draw_string(font, c + Vector2(-w / 2.0, gs * 0.35), glyph, HORIZONTAL_ALIGNMENT_LEFT, -1, gs, Color.WHITE)
	draw_arc(c, r, 0.0, TAU, 48, Ui.GOLD if not locked else Color(0.75, 0.75, 0.75), 5.0, true)
	if hover and not locked:
		draw_arc(c, r + 9.0, 0.0, TAU, 48, Color(1, 1, 1, 0.8), 3.0, true)
	if locked:  # a padlock on the badge's lower right
		var p := c + Vector2(r * 0.62, r * 0.55)
		draw_rect(Rect2(p - Vector2(14, 6), Vector2(28, 22)), Color("5a4a3a"))
		draw_arc(p - Vector2(0, 6), 9.0, PI, TAU, 16, Color("5a4a3a"), 5.0, true)
	# the label under the badge, on a small parchment plate
	var ts := 24
	var tw := font.get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1, ts).x
	var ss := 18
	var sw := font.get_string_size(subtitle, HORIZONTAL_ALIGNMENT_LEFT, -1, ss).x if subtitle != "" else 0.0
	var plate_w := maxf(tw, sw) + 24.0
	var top := anchor_point().y + RADIUS + 10.0
	var plate := Rect2(Vector2((size.x - plate_w) / 2.0, top), Vector2(plate_w, 34.0 + (22.0 if subtitle != "" else 0.0)))
	draw_style_box(_plate_style(), plate)
	draw_string(font, Vector2((size.x - tw) / 2.0, top + 27.0), title, HORIZONTAL_ALIGNMENT_LEFT, -1, ts, Ui.INK)
	if subtitle != "":
		draw_string(font, Vector2((size.x - sw) / 2.0, top + 50.0), subtitle, HORIZONTAL_ALIGNMENT_LEFT, -1, ss,
			Ui.INK.lightened(0.3))


static var _plate: StyleBoxFlat


static func _plate_style() -> StyleBoxFlat:
	if _plate == null:
		_plate = StyleBoxFlat.new()
		_plate.bg_color = Color(Ui.PARCHMENT, 0.92)
		_plate.set_corner_radius_all(10)
		_plate.set_border_width_all(2)
		_plate.border_color = Ui.GOLD
	return _plate


## Only the badge and its label take taps, not the empty corners of the control.
func _has_point(point: Vector2) -> bool:
	if point.distance_to(anchor_point()) <= RADIUS * 1.15:
		return true
	return Rect2(Vector2(size.x * 0.1, anchor_point().y + RADIUS), Vector2(size.x * 0.8, 70.0)).has_point(point)
