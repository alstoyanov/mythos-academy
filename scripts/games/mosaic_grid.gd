class_name MosaicGrid
extends Control
## The rectangle of letters of The Mosaic of Words: an old floor mosaic under letter tiles. Under the tiles
## is a picture (`mosaic`, or a drawn stand-in); the tiles of a word found turn to glass, so the picture
## shows through them, and at the end every tile opens in a wave from the top left corner, showing the
## whole mosaic.
## Choosing a line: drag from a word's first letter to its last (the line snaps to the row, or with
## MosaicRules.down to the row or the column), or tap the first letter and then the last. With a keyboard
## or gamepad: the arrows move a frame, Enter taps. A line chosen is sent (`selected`); the screen checks it
## with the rules and answers with mark_found, flash_wrong or glow.

signal selected(cells: Array[Vector2i])

const GROUT := Color("c9b48c")
const TILE := Color("f7f0e1")
const TILE_EDGE := Color("d2bd93")
const INK := Color("3b2a1a")
const FRAME := Color("8a6a3a")
const SELECT := Color(0.25, 0.5, 0.85)
const WRONG := Color("e07a3a")
const GOLD := Color(1.0, 0.8, 0.2)
const MAX_CELL := 100.0
const OPEN_FOUND := 0.8  ## how far the tiles of a word found open onto the mosaic
const OPEN_SPEED := 2.5
const WAVE_STEP := 0.05  ## seconds between one diagonal of tiles and the next as the mosaic opens
const NOWHERE := Vector2i(-1, -1)

var rules: MosaicRules
var mosaic: Texture2D
var cell := 64.0
var active := false  ## takes the child's lines
var _open := PackedFloat32Array()  ## per cell: 0 a tile, 1 open onto the mosaic
var _open_target := PackedFloat32Array()
var _ink := PackedFloat32Array()  ## per cell: how much of its letter shows
var _ink_target := PackedFloat32Array()
var _delay := PackedFloat32Array()  ## per cell: the wait before it opens (the wave at the end)
var _found: Array = []  ## [cells, colour] of each word found
var _rings := 1.0  ## the rings round the words found (they fade as the mosaic opens)
var _press := NOWHERE  ## where the finger went down
var _end := NOWHERE  ## where the line drawn ends
var _dragging := false
var _anchor := NOWHERE  ## a first letter tapped, waiting for the last
var _cursor := Vector2i.ZERO  ## the keyboard's frame
var _keyboard := false
var _glow := NOWHERE  ## the hint: a first letter
var _flash: Array[Vector2i] = []  ## a wrong line, fading
var _flash_time := 0.0
var _time := 0.0
var _tile_picture: Texture2D
var _boxes := {}


func _init() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	_tile_picture = Ui.picture("greek/word_mosaic/tile.png")


## A new rectangle of `p_rules`, over the picture `p_mosaic`.
func setup(p_rules: MosaicRules, p_mosaic: Texture2D) -> void:
	rules = p_rules
	mosaic = p_mosaic
	var n := rules.columns * rules.rows
	_open = _filled(n, 0.0)
	_open_target = _filled(n, 0.0)
	_delay = _filled(n, 0.0)
	_ink = _filled(n, 1.0)
	_ink_target = _filled(n, 1.0)
	_found.clear()
	_rings = 1.0
	_press = NOWHERE
	_end = NOWHERE
	_dragging = false
	_anchor = NOWHERE
	_glow = NOWHERE
	_flash.clear()
	_cursor = Vector2i.ZERO
	active = true
	queue_redraw()


## The biggest square cells that fit in `area` (at most MAX_CELL), the rectangle in its middle.
func fit(area: Rect2) -> void:
	if rules == null:
		return
	cell = floorf(minf(minf(area.size.x / rules.columns, area.size.y / rules.rows), MAX_CELL))
	size = Vector2(rules.columns, rules.rows) * cell
	position = (area.position + (area.size - size) / 2.0).floor()


func mark_found(cells: Array[Vector2i], colour: Color) -> void:
	_found.append([cells.duplicate(), colour])
	for c in cells:
		_open_target[_index(c)] = OPEN_FOUND
	if cells.has(_glow):
		_glow = NOWHERE


func flash_wrong(cells: Array[Vector2i]) -> void:
	_flash = cells.duplicate()
	_flash_time = 0.6


func glow(c: Vector2i) -> void:
	_glow = c


## Every tile opens, in a wave from the top left corner; returns how long it takes.
func reveal_all() -> float:
	active = false
	_anchor = NOWHERE
	_glow = NOWHERE
	for y in rules.rows:
		for x in rules.columns:
			var i := _index(Vector2i(x, y))
			_delay[i] = (x + y) * WAVE_STEP
			_open_target[i] = 1.0
			_ink_target[i] = 0.0
	return (rules.columns + rules.rows) * WAVE_STEP + 1.0 / OPEN_SPEED


static func _filled(n: int, value: float) -> PackedFloat32Array:
	var a := PackedFloat32Array()
	a.resize(n)
	a.fill(value)
	return a


func cell_rect(c: Vector2i) -> Rect2:
	return Rect2(Vector2(c) * cell, Vector2(cell, cell))


## The middle of `c`, in the screen's coordinates (for the tests and the flying cards).
func cell_center(c: Vector2i) -> Vector2:
	return global_position + (Vector2(c) + Vector2(0.5, 0.5)) * cell


func _index(c: Vector2i) -> int:
	return c.y * rules.columns + c.x


func _cell_at(p: Vector2) -> Vector2i:
	return Vector2i(floori(p.x / cell), floori(p.y / cell))


# ---------- choosing a line ----------

func _gui_input(event: InputEvent) -> void:
	if rules == null or not active:
		return
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		var mb := event as InputEventMouseButton
		var c := _cell_at(mb.position)
		_keyboard = false
		if mb.pressed:
			if rules.inside(c):
				_press = c
				_end = c
				_dragging = true
				_cursor = c
				grab_focus()
		elif _dragging:
			_dragging = false
			_release()
		accept_event()
	elif event is InputEventMouseMotion and _dragging:
		var p := _cell_at((event as InputEventMouseMotion).position)
		p = Vector2i(clampi(p.x, 0, rules.columns - 1), clampi(p.y, 0, rules.rows - 1))
		_end = _snap(_press, p)
		accept_event()
	elif event.is_action_pressed("ui_accept"):
		_keyboard = true
		tap(_cursor)
		accept_event()
	else:
		for action: String in ["ui_left", "ui_right", "ui_up", "ui_down"]:
			if event.is_action_pressed(action, true):
				_keyboard = true
				var step: Vector2i = {"ui_left": Vector2i(-1, 0), "ui_right": Vector2i(1, 0), "ui_up": Vector2i(0, -1),
					"ui_down": Vector2i(0, 1)}[action]
				var to := _cursor + step
				if rules.inside(to):
					_cursor = to
				accept_event()
				return


## The line from `from` towards `p`: along the row, or (with words going down) along the column if `p`
## is further that way.
func _snap(from: Vector2i, p: Vector2i) -> Vector2i:
	var d := p - from
	if rules.down and absi(d.y) > absi(d.x):
		return Vector2i(from.x, p.y)
	return Vector2i(p.x, from.y)


func _release() -> void:
	if _end == _press:
		tap(_press)
	else:
		_anchor = NOWHERE
		selected.emit(rules.line(_press, _end))
	_press = NOWHERE
	_end = NOWHERE


## A tap on `c`: the first letter of a line (tapped again: forgotten), or its last if it is on the same
## row (or column) as the first; on another, it becomes the first instead.
func tap(c: Vector2i) -> void:
	if not active or not rules.inside(c):
		return
	if _anchor == NOWHERE or _anchor == c:
		_anchor = NOWHERE if _anchor == c else c
		Sound.play("pop")
		return
	var l := rules.line(_anchor, c)
	if l.is_empty():
		_anchor = c
		Sound.play("pop")
		return
	_anchor = NOWHERE
	selected.emit(l)


# ---------- drawing ----------

func _process(delta: float) -> void:
	if rules == null:
		return
	_time += delta
	_flash_time = maxf(0.0, _flash_time - delta)
	var all_open := true
	for i in _open.size():
		if _delay[i] > 0.0:
			_delay[i] -= delta
			all_open = false
			continue
		_open[i] = move_toward(_open[i], _open_target[i], delta * OPEN_SPEED)
		_ink[i] = move_toward(_ink[i], _ink_target[i], delta * OPEN_SPEED)
		all_open = all_open and _open[i] >= 1.0
	if not active and _ink_target.size() > 0 and _ink_target[0] == 0.0:
		_rings = move_toward(_rings, 0.0, delta * 1.5)
	if not all_open or active:
		queue_redraw()


func _draw() -> void:
	if rules == null:
		return
	var full := Rect2(Vector2.ZERO, size)
	draw_rect(full.grow(cell * 0.08), FRAME, false, cell * 0.1)
	if mosaic != null:
		draw_texture_rect_region(mosaic, full, cover_region(mosaic.get_size(), size))
	var font := get_theme_default_font()
	var fs := int(cell * 0.56)
	var baseline := (cell + font.get_ascent(fs) - font.get_descent(fs)) / 2.0
	var pulse := 0.5 + 0.5 * sin(_time * 5.0)
	for y in rules.rows:
		for x in rules.columns:
			var c := Vector2i(x, y)
			var i := _index(c)
			var r := cell_rect(c)
			var cover := 1.0 - _open[i]
			if cover > 0.0:
				draw_rect(r, Color(GROUT, cover))
				var tile := r.grow(-cell * 0.05)
				if _tile_picture != null:
					draw_texture_rect(_tile_picture, tile, false, Color(1, 1, 1, cover))
				else:
					draw_style_box(_box(TILE, TILE_EDGE, cover, false), tile)
			if c == _glow:
				draw_style_box(_box(Color(GOLD, 0.35 + 0.3 * pulse), GOLD, 1.0, false), r.grow(-cell * 0.02 + 4.0 * pulse))
			if c == _anchor:
				draw_style_box(_box(Color(SELECT, 0.25 + 0.2 * pulse), SELECT, 1.0, false), r.grow(-cell * 0.04))
			var ink := _ink[i]
			if ink > 0.01:
				var at := r.position + Vector2(0.0, baseline)
				if _open[i] > 0.3:  # on glass: a white letter with a dark edge, readable on any picture
					draw_string_outline(font, at, rules.letter(c), HORIZONTAL_ALIGNMENT_CENTER, cell, fs,
						maxi(2, int(cell * 0.09)), Color(INK, ink))
					draw_string(font, at, rules.letter(c), HORIZONTAL_ALIGNMENT_CENTER, cell, fs, Color(1, 1, 1, ink))
				else:
					draw_string(font, at, rules.letter(c), HORIZONTAL_ALIGNMENT_CENTER, cell, fs, Color(INK, ink))
	if _rings > 0.0:
		for f: Array in _found:
			_ring(f[0], Color(f[1], _rings), false)
	if _dragging and _end != _press:
		_ring(rules.line(_press, _end), SELECT, true)
	if _flash_time > 0.0 and not _flash.is_empty():
		_ring(_flash, Color(WRONG, _flash_time / 0.6), true)
	if _keyboard and has_focus() and active:
		draw_rect(cell_rect(_cursor).grow(-2.0), Color.WHITE, false, 5.0)
		draw_rect(cell_rect(_cursor).grow(-6.0), SELECT, false, 3.0)


## A rounded ring round a line of cells (filled a little when `fill`).
func _ring(cells: Array, colour: Color, fill: bool) -> void:
	if cells.is_empty():
		return
	var r := cell_rect(cells[0]).merge(cell_rect(cells[cells.size() - 1])).grow(-cell * 0.06)
	draw_style_box(_box(Color(colour, colour.a * 0.3) if fill else Color(0, 0, 0, 0), colour, 1.0, true), r)


## The part of a picture of size `picture` that covers `target` (its middle, cut to that shape).
static func cover_region(picture: Vector2, target: Vector2) -> Rect2:
	var s := maxf(target.x / picture.x, target.y / picture.y)
	var part := target / s
	return Rect2((picture - part) / 2.0, part)


func _box(fill: Color, edge: Color, alpha: float, ring: bool) -> StyleBoxFlat:
	var a := snappedf(alpha, 0.05)
	var key := "%s/%s/%.2f/%s/%d" % [fill.to_html(), edge.to_html(), a, ring, int(cell)]
	if not _boxes.has(key):
		if _boxes.size() > 400:
			_boxes.clear()
		var b := StyleBoxFlat.new()
		b.bg_color = Color(fill, fill.a * a)
		b.border_color = Color(edge, edge.a * a)
		b.set_border_width_all(maxi(3, int(cell * 0.07)) if ring else 2)
		b.set_corner_radius_all(int(cell * (0.45 if ring else 0.16)))
		b.anti_aliasing = true
		_boxes[key] = b
	return _boxes[key]


# ---------- the stand-in mosaics ----------

## A mosaic drawn by the game while its picture is not made: small square stones in the shape of a
## simple scene (`kind`: the sun over the sea, the moon and stars, hills with a temple).
static func stand_in(kind: int) -> Texture2D:
	const ACROSS := 48
	const DOWN := 32
	const STONE := 6  ## pixels per stone, with its grout line
	var img := Image.create(ACROSS * STONE, DOWN * STONE, false, Image.FORMAT_RGB8)
	img.fill(Color("d8cbb0"))
	var rng := RandomNumberGenerator.new()
	rng.seed = 7 + kind
	for ty in DOWN:
		for tx in ACROSS:
			var u := (tx + 0.5) / ACROSS
			var v := (ty + 0.5) / DOWN
			var col := _scene(kind % 3, u, v, tx, ty)
			var shade := rng.randf_range(-0.07, 0.07)
			col = col.lightened(shade) if shade > 0.0 else col.darkened(-shade)
			img.fill_rect(Rect2i(tx * STONE, ty * STONE, STONE - 1, STONE - 1), col)
	return ImageTexture.create_from_image(img)


static func _scene(kind: int, u: float, v: float, tx: int, ty: int) -> Color:
	match kind:
		0:  # the sun over the sea
			if Vector2(u - 0.72, (v - 0.3) * 0.67).length() < 0.1:
				return Color("f2c03a")
			if v > 0.62 + 0.02 * sin(u * 18.0):
				return Color("5aa0c8") if int(v * 40.0 + sin(u * 12.0) * 2.0) % 3 == 0 else Color("2f6f9f")
			return Color("9fd0ea").lerp(Color("f6e7c1"), v / 0.62)
		1:  # the moon and the stars over dark hills
			if v > 0.75 + 0.06 * sin(u * 7.0):
				return Color("2f5a3a")
			if Vector2(u - 0.26, (v - 0.3) * 0.67).length() < 0.09:
				return Color("f4e9c8")
			if (tx * 73 + ty * 151) % 41 == 0:
				return Color("f6d36b")
			return Color("1f2f5a").lerp(Color("3b4f86"), v)
		_:  # green hills and a white temple
			var temple := u > 0.42 and u < 0.62 and v > 0.36 and v < 0.62
			var roof := v <= 0.36 and v > 0.24 and absf(u - 0.52) < (v - 0.24) * 0.9
			if roof:
				return Color("c8553d")
			if temple:
				return Color("8a7f70") if tx % 3 == 0 else Color("f4f1ea")
			if v > 0.62 + 0.08 * sin(u * 6.0):
				return Color("7fb069") if v < 0.8 else Color("5d8f4a")
			return Color("8ec5dc").lerp(Color("f2ead2"), v / 0.7)
