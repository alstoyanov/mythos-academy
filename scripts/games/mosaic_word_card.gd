class_name MosaicWordCard
extends Control
## A word to find in The Mosaic of Words: a card that flies out of Clio's basket with the word written in
## capitals, as in the mosaic. Once the word is found, the card turns gold, gets a ring of the word's
## colour (the same as round the word in the mosaic), its picture if it has one, and a tick. It can glow
## (the hint) and pop.

const PAPER := Color("fbf3df")
const FOUND := Color("fff0bf")
const INK := Color("3b2a1a")

var word := ""  ## in capitals
var colour := Color.WHITE  ## the word's colour, once found
var found := false:
	set(v):
		found = v
		queue_redraw()
var glowing := false
var _picture: Texture2D
var _time := randf() * TAU
var _pop := 0.0


func _init(p_word: String, picture: String, p_size: Vector2) -> void:
	word = p_word
	custom_minimum_size = p_size
	size = p_size
	pivot_offset = p_size / 2.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if picture != "":
		_picture = Ui.picture("words/%s.png" % picture)


func pop() -> void:
	_pop = 0.4


func _process(delta: float) -> void:
	_time += delta
	if _pop > 0.0:  # (only while popping: the flight out of the basket tweens the scale too)
		_pop = maxf(0.0, _pop - delta)
		scale = Vector2.ONE * (1.0 + sin(_pop / 0.4 * PI) * 0.15)
		queue_redraw()
	elif glowing:
		queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	if glowing:
		var pulse := 0.5 + 0.5 * sin(_time * 5.0)
		draw_style_box(_box(Color(1.0, 0.92, 0.55, 0.55 + 0.25 * pulse), Color(1.0, 0.8, 0.2), 4), rect.grow(8.0 + 5.0 * pulse))
	draw_style_box(_box(FOUND if found else PAPER, colour if found else Ui.GOLD, 6 if found else 4), rect)
	var font := get_theme_default_font()
	var left := 14.0
	var right := size.x - 14.0
	if found:
		if _picture != null:
			var side := size.y - 12.0
			draw_texture_rect(_picture, Rect2(Vector2(8.0, 6.0), Vector2(side, side)), false)
			left = side + 14.0
		right -= 26.0
		var tick := Vector2(size.x - 34.0, size.y / 2.0)
		draw_polyline(PackedVector2Array([tick + Vector2(0, 0), tick + Vector2(7, 8), tick + Vector2(20, -9)]),
			Color("3f8f3f"), 5.0, true)
	var fs := int(size.y * 0.5)
	while fs > 14 and font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > right - left:
		fs -= 1
	var baseline := (size.y + font.get_ascent(fs) - font.get_descent(fs)) / 2.0
	draw_string(font, Vector2(left, baseline), word, HORIZONTAL_ALIGNMENT_CENTER, right - left, fs, INK)


static var _boxes := {}


static func _box(fill: Color, border: Color, width: int) -> StyleBoxFlat:
	var key := "%s/%s/%d" % [fill.to_html(), border.to_html(), width]
	if not _boxes.has(key):
		var b := StyleBoxFlat.new()
		b.bg_color = fill
		b.border_color = border
		b.set_border_width_all(width)
		b.set_corner_radius_all(16)
		b.shadow_color = Color(0, 0, 0, 0.18)
		b.shadow_size = 5
		b.shadow_offset = Vector2(0, 3)
		_boxes[key] = b
	return _boxes[key]
