class_name HarvestItem
extends RefCounted
## A bundle of wheat or a bunch of grapes, drawn in Demeter's scale when she helps: one for each unit of
## a number, so it can be counted. Pictures: greek/demeter_harvest/wheat.png, grapes.png; without them
## drawn ones.

enum { WHEAT, GRAPES }

const ART := "greek/demeter_harvest/"
const FILES := ["wheat.png", "grapes.png"]

static var _textures := {}


static func texture(k: int) -> Texture2D:
	if not _textures.has(k):
		_textures[k] = Ui.picture(ART + FILES[k])
	return _textures[k]


## Draws an item of kind `k` filling `rect` on `ci` (in its _draw), `alpha` see-through.
static func draw_item(ci: CanvasItem, k: int, rect: Rect2, alpha: float = 1.0) -> void:
	var tex := texture(k)
	if tex != null:
		ci.draw_texture_rect(tex, rect, false, Color(1, 1, 1, alpha))
		return
	var c := rect.get_center()
	var s := rect.size
	match k:
		WHEAT:  # golden stalks tied in the middle, ears at the top
			for i in 5:
				var x := (i - 2) * s.x * 0.09
				ci.draw_line(c + Vector2(x * 0.4, s.y * 0.4), c + Vector2(x, -s.y * 0.15), Color("c99a2e", alpha), maxf(2.0, s.x * 0.04))
				ci.draw_circle(c + Vector2(x * 1.2, -s.y * 0.25), s.x * 0.08, Color("e8b84a", alpha))
			ci.draw_rect(Rect2(c + Vector2(-s.x * 0.12, s.y * 0.02), Vector2(s.x * 0.24, s.y * 0.08)), Color("b5482c", alpha))
		GRAPES:  # purple grapes in a bunch, a green leaf on top
			ci.draw_circle(c + Vector2(s.x * 0.12, -s.y * 0.36), s.x * 0.12, Color("6b9a3a", alpha))
			for row in 4:
				for i in 4 - row:
					var at := c + Vector2((i - (3 - row) / 2.0) * s.x * 0.17, (row - 1.3) * s.y * 0.16)
					ci.draw_circle(at, s.x * 0.1, Color("7a3f8f", alpha))
					ci.draw_circle(at + Vector2(-s.x * 0.03, -s.y * 0.03), s.x * 0.03, Color("b48ac6", alpha))
