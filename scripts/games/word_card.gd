class_name WordCard
extends BaseButton
## A card in The Muses' Words: a word's picture (`id`, from assets/images/words/<id>.png), or a word
## written big (`text`). Tappable as a choice, or (disabled) the picture or word being asked about. It
## can glow (the hint), be tried (dimmed: it was not the answer), wobble and pop (the right one). A
## picture that is not made yet is a pale tile with its name in small grey letters.

const PAPER := Color("fbf3df")
const INK := Color("3b2a1a")

var id := ""  ## a picture's id, or "" for a word
var text := ""  ## the word
var glowing := false
var tried := false:
	set(v):
		tried = v
		modulate.a = 0.4 if v else 1.0
var _picture: Texture2D
var _time := randf() * TAU
var _wobble := 0.0
var _pop := 0.0
var _hovered := false


## A picture card (`p_id`) or a word card (`p_text`), `p_size` big.
func _init(p_id: String, p_text: String, p_size: Vector2) -> void:
	id = p_id
	text = p_text
	custom_minimum_size = p_size
	size = p_size
	pivot_offset = p_size / 2.0
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_to_group("silent")  # (the game plays its own sounds)
	if id != "":
		_picture = Ui.picture("words/%s.png" % id)
	mouse_entered.connect(func() -> void: _hovered = true)
	mouse_exited.connect(func() -> void: _hovered = false)


func wobble() -> void:
	_wobble = 0.5


func pop() -> void:
	_pop = 0.4


func _process(delta: float) -> void:
	_time += delta
	_wobble = maxf(0.0, _wobble - delta)
	_pop = maxf(0.0, _pop - delta)
	var grow := 1.0 + sin(_pop / 0.4 * PI) * 0.12
	if (_hovered or has_focus()) and not disabled and not tried:
		grow += 0.04
	scale = Vector2.ONE * grow
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2(sin(_wobble * 40.0) * 10.0 * _wobble, 0.0), size)
	if glowing:
		var pulse := 0.5 + 0.5 * sin(_time * 5.0)
		var halo := rect.grow(10.0 + 6.0 * pulse)
		draw_style_box(_box(Color(1.0, 0.92, 0.55, 0.55 + 0.25 * pulse), Color(1.0, 0.8, 0.2), 28), halo)
	var focus := has_focus() and not disabled and not tried
	draw_style_box(_box(PAPER, Color.WHITE if focus else Ui.GOLD, 22), rect)
	var font := get_theme_default_font()
	if id == "":  # a word, big
		var fs := int(minf(size.y * 0.62, size.x * 1.5 / maxf(4.0, text.length())))
		var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		draw_string(font, rect.get_center() + Vector2(-w / 2.0, fs * 0.35), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, INK)
	elif _picture != null:
		draw_texture_rect(_picture, rect.grow(-size.x * 0.06), false)
	else:  # not made yet: its name, small
		var fs := 22
		var w := font.get_string_size(id, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		draw_string(font, rect.get_center() + Vector2(-w / 2.0, fs * 0.35), id, HORIZONTAL_ALIGNMENT_LEFT, -1, fs,
			Color(0.5, 0.45, 0.4))


static var _boxes := {}


static func _box(fill: Color, border: Color, radius: int) -> StyleBoxFlat:
	var key := "%s/%s/%d" % [fill.to_html(), border.to_html(), radius]
	if not _boxes.has(key):
		var b := StyleBoxFlat.new()
		b.bg_color = fill
		b.border_color = border
		b.set_border_width_all(4)
		b.set_corner_radius_all(radius)
		b.shadow_color = Color(0, 0, 0, 0.18)
		b.shadow_size = 6
		b.shadow_offset = Vector2(0, 3)
		_boxes[key] = b
	return _boxes[key]
