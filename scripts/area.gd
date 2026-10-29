extends Control
## A learning area of a realm (e.g. Arithmetic, the Agora of Numbers): a card for each of its mini
## games. The games are not made yet: a card says it is coming.

const STATUS := {"planned": "Coming soon", "later": "Coming later", "ready": "Play"}


func _ready() -> void:
	Ui.setup_screen(self)
	var area := Catalog.area(App.mythology_id, App.area_id)
	var tint := Color(area.get("color", "#888888"))
	var bg := TextureRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.texture = Ui.picture("%s/area_%s_background.png" % [App.mythology_id, App.area_id])
	if bg.texture == null:  # a soft wash of the area's colour over parchment
		var grad := Gradient.new()
		grad.colors = PackedColorArray([Ui.PARCHMENT, tint.lerp(Ui.PARCHMENT, 0.45)])
		var tex := GradientTexture2D.new()
		tex.gradient = grad
		tex.fill_from = Vector2(0.5, 0.0)
		tex.fill_to = Vector2(0.5, 1.0)
		bg.texture = tex
		bg.stretch_mode = TextureRect.STRETCH_SCALE
	add_child(bg)

	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.offset_top = 146
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(center)
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 28)
	flow.add_theme_constant_override("v_separation", 28)
	flow.alignment = FlowContainer.ALIGNMENT_CENTER
	center.add_child(flow)
	# As wide as the screen allows, so the cards sit side by side and wrap only when there is no room.
	var fit_width := func() -> void: flow.custom_minimum_size.x = maxf(380.0, size.x - 80.0)
	resized.connect(fit_width)
	fit_width.call_deferred()
	var first: Button = null
	for g: Dictionary in area.get("games", []):
		var b := _card(flow, g, tint, area.get("glyph", ""))
		if first == null:
			first = b
	Ui.banner(self, tr(area.get("subject", "")), "%s · %s" % [tr(area.get("name", "")), tr(area.get("place", ""))])
	Ui.back_button(self)
	if first != null:
		first.call_deferred("grab_focus")


## A game's card: its picture (or a tile of the area's colour with its symbol), name, what it teaches,
## a line about it.
func _card(parent: Node, game: Dictionary, tint: Color, glyph: String) -> Button:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(360, 0)
	parent.add_child(panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 6)
	panel.add_child(col)
	var art := Ui.picture("%s/game_%s.png" % [App.mythology_id, game["id"]])
	if art != null:
		var pic := TextureRect.new()
		pic.texture = art
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		pic.custom_minimum_size = Vector2(312, 150)
		col.add_child(pic)
	else:
		var tile := ColorRect.new()
		tile.color = tint
		tile.custom_minimum_size = Vector2(312, 150)
		col.add_child(tile)
		var initial := Ui.label(tile, glyph if glyph != "" else game["title"].substr(0, 1), 84, Color(1, 1, 1, 0.9))
		initial.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		initial.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	Ui.label(col, tr(game["title"]), 32)
	Ui.label(col, tr(game.get("skill", "")), 22, tint.darkened(0.35), 312.0)
	Ui.label(col, tr(game.get("blurb", "")), 22, Ui.INK.lightened(0.2), 312.0)
	var status: String = game.get("status", "planned")
	var playable := status == "ready" and game.has("scene")
	var text: String = "Play" if playable else STATUS.get(status, "Coming soon")
	if status == "ready" and not playable:  # (no scene yet)
		text = "Coming soon"
	var b := Ui.button(col, text,
		func() -> void:
			if playable:
				App.go(game["scene"])
			else:
				Ui.toast(self, tr("%s is coming soon!") % tr(game["title"])), 28)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	if not playable:
		b.modulate = Color(1, 1, 1, 0.75)
	return b
