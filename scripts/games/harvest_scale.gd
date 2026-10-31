class_name HarvestScale
extends Control
## Demeter's harvest scale: a beam on a stand with a basket hanging from each end. Each basket carries
## one side of the problem on clay tablets on its front (left "3 + 4", right "?"); the "?" waits for
## the child's tablet (slot_rect, guess). The beam tips towards the heavier side and swings gently into
## place; level, the scale glows. When Demeter helps, wheat and grapes heap in the baskets, one for each
## unit (eaten ones faded, missing ones as ghosts), and one can be marked with a number (counting
## together). Pictures: greek/demeter_harvest/scale_stand.png, scale_beam.png, scale_pan.png; without
## them a drawn scale.

enum { SOLID, EATEN, GHOST }  ## how an item of a heap is drawn

const ART := "greek/demeter_harvest/"
const MAX_TILT := 0.16  ## the beam at its steepest (radians)
const TILT_FIRST := 0.06  ## the beam for one unit of difference: clearly tipped
const TILT_PER_UNIT := 0.015  ## and more for each unit more
const ROW := 5  ## items in a row of a basket's heap
const RIM := 0.65  ## the basket's rim, from the top of its picture (a share of its height)
const STAND_KNOB := 0.065  ## the middle of the knob on top of the stand, from the top of its picture (a share of its height)
const HOOK_DROP := 0.27  ## how far the beam's hooks hang below its middle (a share of the beam picture's height)
const INK := Color("5a2a14")

var left_terms: Array[int] = []  ## the left side: a number, then numbers added (+) or taken away (−)
var right_terms: Array[int] = []
var unknown_side := 1
var unknown_index := 0
var guess := -1  ## the number put in the "?" (-1: none yet)
var left_items: Array[Dictionary] = []  ## the left heap: {kind (HarvestItem), style (SOLID, EATEN, GHOST)}
var right_items: Array[Dictionary] = []
var balanced := false
var marked_side := 0  ## the heap with an item being counted (0: none)
var marked := -1
var mark_text := ""
var angle := 0.0  ## the beam (radians; > 0: the right side is down)
var _goal := 0.0
var _speed := 0.0
var _time := 0.0
var _stand: Texture2D
var _beam: Texture2D
var _pan: Texture2D


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_stand = Ui.picture(ART + "scale_stand.png")
	_beam = Ui.picture(ART + "scale_beam.png")
	_pan = Ui.picture(ART + "scale_pan.png")


## Tips the beam for a right side `diff` heavier than the left (negative: lighter); 0 balances.
func weigh(diff: int) -> void:
	_goal = signf(diff) * minf(TILT_FIRST + (absi(diff) - 1) * TILT_PER_UNIT, MAX_TILT) if diff != 0 else 0.0
	balanced = diff == 0


## The beam where weigh() sends it, at once (a new problem starts still).
func settle() -> void:
	angle = _goal
	_speed = 0.0


func items(side: int) -> Array[Dictionary]:
	return left_items if side < 0 else right_items


func pivot() -> Vector2:
	return Vector2(size.x / 2.0, maxf(30.0, size.y * 0.1))


func arm() -> float:
	return minf(size.x * 0.33, size.y * 0.85)


func pan_side() -> float:
	return minf(size.x * 0.3, size.y * 0.62)


## Where a basket hangs from the beam (side -1 left, 1 right).
func hook(side: int) -> Vector2:
	var drop := beam_height() * HOOK_DROP if _beam != null else 0.0  # (from the tip of the hook)
	return pivot() + Vector2(cos(angle), sin(angle)) * arm() * side + Vector2(0.0, drop)


## The beam picture as drawn: as wide as the arms and a little more, its height to its shape.
func beam_size() -> Vector2:
	var bw := arm() * 2.0 * 1.12
	return Vector2(bw, bw * _beam.get_size().y / _beam.get_size().x if _beam != null else 0.0)


func beam_height() -> float:
	return beam_size().y


## The basket's picture: the cords from the hook at its top middle, the basket in its lower half.
func pan_rect(side: int) -> Rect2:
	var p := pan_side()
	var h := hook(side)
	return Rect2(h.x - p / 2.0, h.y, p, p)


## The middle of the basket's rim, where the heap starts.
func rim(side: int) -> Vector2:
	var r := pan_rect(side)
	return Vector2(r.get_center().x, r.position.y + r.size.y * RIM)


## The tablets and signs on a basket's front: [{rect, text or value}] (value -1: the "?").
func expression(side: int) -> Array[Dictionary]:
	var terms := left_terms if side < 0 else right_terms
	var r := pan_rect(side)
	var t := r.size.x * 0.24
	var sign_w := t * 0.55
	var width := terms.size() * t + (terms.size() - 1) * sign_w
	var x := r.get_center().x - width / 2.0
	var y := r.position.y + r.size.y * 0.8 - t / 2.0
	var out: Array[Dictionary] = []
	for i in terms.size():
		if i > 0:
			out.append({"rect": Rect2(x, y, sign_w, t), "text": "+" if terms[i] > 0 else "−"})
			x += sign_w
		var unknown := side == unknown_side and i == unknown_index
		out.append({"rect": Rect2(x, y, t, t), "value": (guess if unknown else absi(terms[i])), "unknown": unknown})
		x += t
	return out


## Where the "?" takes a tablet (in the screen): the basket with it, a little bigger.
func slot_rect() -> Rect2:
	var r := pan_rect(unknown_side).grow(30.0)
	return Rect2(get_global_transform() * r.position, r.size)


## The middle of the "?" (in this control), where a tablet lands.
func slot_center() -> Vector2:
	for e in expression(unknown_side):
		if e.get("unknown", false):
			return (e["rect"] as Rect2).get_center()
	return rim(unknown_side)


func item_size(side: int) -> float:
	return pan_side() * (0.2 if items(side).size() <= 10 else 0.17)


## Where item `i` of a basket's heap sits (in this control): rows of ROW from the rim up.
func slot(side: int, i: int) -> Vector2:
	var s := item_size(side)
	var base := rim(side)
	var r := i / ROW
	var across := pan_side() * 0.8
	var gap := across / ROW
	var x := base.x - across / 2.0 + gap * (i % ROW + 0.5) + (gap * 0.3 if r % 2 == 1 else -gap * 0.1)
	return Vector2(x, base.y - s * 0.3 - r * s * 0.8)


func _process(delta: float) -> void:
	_time += delta
	# a damped spring: the beam swings past its place a little and settles
	_speed += ((_goal - angle) * 38.0 - _speed * 4.5) * delta
	angle += _speed * delta
	queue_redraw()


func _draw() -> void:
	var pv := pivot()
	var p := pan_side()
	if balanced and absf(angle) < 0.03:  # level: a warm glow behind the scale
		var pulse := 0.5 + 0.5 * sin(_time * 4.0)
		for side in [-1, 1]:
			draw_circle(rim(side), p * (0.55 + 0.04 * pulse), Color(1.0, 0.9, 0.5, 0.35))
		draw_circle(pv, p * 0.3, Color(1.0, 0.9, 0.5, 0.4))
	# the stand
	var top := pv.y - p * 0.12
	if _stand != null:  # down to the bottom, its knob behind the middle of the beam
		top = (pv.y - STAND_KNOB * size.y) / (1.0 - STAND_KNOB)
		var sh := size.y - top
		var sw := sh * _stand.get_size().x / _stand.get_size().y
		draw_texture_rect(_stand, Rect2(pv.x - sw / 2.0, top, sw, sh), false)
	else:
		draw_rect(Rect2(pv.x - 11.0, pv.y, 22.0, size.y - pv.y - 24.0), Color("a8743f"))
		draw_rect(Rect2(pv.x - p * 0.4, size.y - 30.0, p * 0.8, 30.0), Color("8a5a2e"))
		draw_circle(Vector2(pv.x, top + 8.0), 14.0, Ui.GOLD)
	for side in [-1, 1]:
		_draw_pan(side)
	# the beam, turned about its middle
	draw_set_transform(pv, angle)
	if _beam != null:
		var bs := beam_size()
		draw_texture_rect(_beam, Rect2(-bs / 2.0, bs), false)
	else:
		draw_line(Vector2(-arm(), 0.0), Vector2(arm(), 0.0), Color("8a5a2e"), 14.0, true)
		for side in [-1, 1]:
			draw_circle(Vector2(arm() * side, 0.0), 10.0, Ui.GOLD)
		draw_circle(Vector2.ZERO, 16.0, Ui.GOLD)
	draw_set_transform(Vector2.ZERO)


func _draw_pan(side: int) -> void:
	var r := pan_rect(side)
	var p := r.size.x
	if _pan != null:
		draw_texture_rect(_pan, r, false)
	else:  # three cords from the hook, a wicker bowl
		var h := hook(side)
		var rim_y := r.position.y + p * RIM
		for x in [-0.45, 0.0, 0.45]:
			draw_line(h, Vector2(h.x + p * x, rim_y), Color("6b4a2a"), 3.0, true)
		draw_colored_polygon(PackedVector2Array([Vector2(r.position.x, rim_y), Vector2(r.end.x, rim_y),
			Vector2(r.end.x - p * 0.12, r.end.y), Vector2(r.position.x + p * 0.12, r.end.y)]), Color("c89a52"))
		draw_line(Vector2(r.position.x, rim_y), Vector2(r.end.x, rim_y), Color("8a6a32"), 6.0, true)
	# the heap (when Demeter helps)
	var heap := items(side)
	var s := item_size(side)
	for i in heap.size():
		var at := slot(side, i)
		var style: int = heap[i]["style"]
		var rect := Rect2(at - Vector2(s, s) / 2.0, Vector2(s, s))
		HarvestItem.draw_item(self, heap[i]["kind"], rect, [1.0, 0.25, 0.4][style])
		if style == GHOST:  # still missing: a dotted ring
			for k in 12:
				var a := k * TAU / 12.0
				draw_arc(at, s * 0.48, a, a + TAU / 24.0, 3, Color(1, 1, 1, 0.9), 3.0, true)
	if marked_side == side and marked >= 0 and marked < heap.size():  # being counted: a ring and its number
		var at := slot(side, marked)
		draw_arc(at, s * 0.7, 0.0, TAU, 32, Color.WHITE, 5.0, true)
		var font := get_theme_default_font()
		var fs := 46
		var w := font.get_string_size(mark_text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var pos := at + Vector2(-w / 2.0, -s * 0.85)
		draw_string_outline(font, pos, mark_text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 10, Color.WHITE)
		draw_string(font, pos, mark_text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("6a4a12"))
	# the side of the problem, on the basket's front
	var font := get_theme_default_font()
	for e in expression(side):
		var rect: Rect2 = e["rect"]
		if e.has("text"):
			var fs := int(rect.size.y * 0.62)
			var text: String = e["text"]
			var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			var pos := rect.get_center() + Vector2(-w / 2.0, fs * 0.36)
			draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 8, Color.WHITE)
			draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, INK)
			continue
		if e["unknown"] and e["value"] < 0:  # the empty place, glowing gently: put a number here
			var pulse := 0.5 + 0.5 * sin(_time * 4.0)
			draw_circle(rect.get_center(), rect.size.x * (0.66 + 0.05 * pulse), Color(1.0, 0.95, 0.7, 0.55))
		NumberTablet.draw_tablet(self, rect, e["value"])
