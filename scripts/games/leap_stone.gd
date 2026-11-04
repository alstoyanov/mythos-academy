class_name LeapStone
extends Control
## A cliff of Hercules' Leaps with its number on a clay tablet. Its origin is its top left corner:
## y = 0 is where Hercules' feet touch the ground, and the rock goes down past the screen's
## bottom. Picture: greek/hercules_leaps/cliff.png; without it a drawn cliff.

const PICTURE := "greek/hercules_leaps/cliff.png"
const WIDTH := 380.0
const DEPTH := 480.0  ## how far down a drawn cliff goes
const TOP_IN_PICTURE := 0.0806  ## where the ground is in the picture, as a part of its height
const TABLET := 110.0
const TABLET_DOWN := 26.0  ## from the ground to the top of the tablet

static var _picture: Texture2D
static var _looked := false

var value := 0


func _init(p_value: int) -> void:
	value = p_value
	size = Vector2(WIDTH, DEPTH)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not _looked:
		_picture = Ui.picture(PICTURE)
		_looked = true


func _draw() -> void:
	if _picture != null:
		var h := WIDTH * float(_picture.get_height()) / float(_picture.get_width())
		draw_texture_rect(_picture, Rect2(0.0, -h * TOP_IN_PICTURE, WIDTH, h), false)
	else:
		_draw_stand_in()
	NumberTablet.draw_tablet(self, Rect2((WIDTH - TABLET) / 2.0, TABLET_DOWN, TABLET, TABLET), value)


func _draw_stand_in() -> void:
	var rock := PackedVector2Array([
		Vector2(14, 0), Vector2(WIDTH - 14, 0), Vector2(WIDTH - 4, 70), Vector2(WIDTH - 24, 160),
		Vector2(WIDTH - 8, 280), Vector2(WIDTH - 30, DEPTH), Vector2(30, DEPTH), Vector2(10, 300),
		Vector2(26, 150), Vector2(4, 66),
	])
	draw_colored_polygon(rock, Color("b5956f"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(WIDTH * 0.55, 0), Vector2(WIDTH - 14, 0), Vector2(WIDTH - 4, 70), Vector2(WIDTH - 24, 160),
		Vector2(WIDTH - 8, 280), Vector2(WIDTH - 30, DEPTH), Vector2(WIDTH * 0.68, DEPTH),
	]), Color("9a7b58"))
	draw_rect(Rect2(8, -6, WIDTH - 16, 18), Color("7fae55"))
