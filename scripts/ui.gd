class_name Ui
extends RefCounted
## The look of the menus, made for young children on a phone or a PC: big text, big round buttons
## (every touch target at least TOUCH_MIN pixels), warm parchment and Aegean colours. Pictures come
## from assets/images/ when they exist (see assets/prompts/IMAGE_PROMPTS.md); until then the screens
## draw simple placeholders.

const TOUCH_MIN := 88.0  ## the smallest button, in pixels of the 1280 x 720 layout
const INK := Color("3b2a1a")  ## text on parchment
const PARCHMENT := Color("f3e6c4")
const PANEL := Color("fbf3df")
const GOLD := Color("d9a441")
const SEA := Color("8ec5dc")
const BUTTON := Color("3f7fc4")  ## Greek blue
const BUTTON_HOVER := Color("5592d6")
const BUTTON_PRESSED := Color("2f6aa8")

static var _theme: Theme


## The theme every screen uses (set on its root Control).
static func theme() -> Theme:
	if _theme != null:
		return _theme
	var t := Theme.new()
	t.default_font_size = 30
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		var box := StyleBoxFlat.new()
		box.bg_color = {"normal": BUTTON, "hover": BUTTON_HOVER, "pressed": BUTTON_PRESSED, "focus": BUTTON_HOVER,
			"disabled": BUTTON.lerp(Color.GRAY, 0.6)}[state]
		box.set_corner_radius_all(28)
		box.set_border_width_all(4)
		box.border_color = GOLD if state != "focus" else Color.WHITE
		box.content_margin_left = 34
		box.content_margin_right = 34
		box.content_margin_top = 16
		box.content_margin_bottom = 16
		box.shadow_color = Color(0, 0, 0, 0.25)
		box.shadow_size = 6
		box.shadow_offset = Vector2(0, 4)
		t.set_stylebox(state, "Button", box)
	t.set_color("font_color", "Button", Color.WHITE)
	t.set_color("font_hover_color", "Button", Color.WHITE)
	t.set_color("font_pressed_color", "Button", Color(1, 1, 1, 0.85))
	t.set_color("font_focus_color", "Button", Color.WHITE)
	t.set_color("font_color", "Label", INK)
	var panel := StyleBoxFlat.new()
	panel.bg_color = PANEL
	panel.set_corner_radius_all(24)
	panel.set_border_width_all(4)
	panel.border_color = GOLD
	panel.set_content_margin_all(24)
	panel.shadow_color = Color(0, 0, 0, 0.3)
	panel.shadow_size = 10
	t.set_stylebox("panel", "PanelContainer", panel)
	_theme = t
	return t


## Sets up a screen's root: full window, the theme.
static func setup_screen(root: Control) -> void:
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.theme = theme()


## A centred label; with `wrap_width` it wraps its words at that width (a wrapping label in a
## container that sizes it to its content would otherwise be squeezed to one letter).
static func label(parent: Node, text: String, size: int = 30, color: Color = INK, wrap_width: float = 0.0) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if wrap_width > 0.0:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size.x = wrap_width
	parent.add_child(l)
	return l


static func button(parent: Node, text: String, on_press: Callable, size: int = 34) -> Button:
	var b := Button.new()
	b.text = text
	b.add_theme_font_size_override("font_size", size)
	b.custom_minimum_size = Vector2(TOUCH_MIN * 3.0, TOUCH_MIN)
	b.pressed.connect(on_press)
	parent.add_child(b)
	return b


## The round "back" button in the top left corner of a screen.
static func back_button(root: Control) -> Button:
	var b := Button.new()
	b.text = "‹"
	b.set_meta("sound", "back")
	b.add_theme_font_size_override("font_size", 54)
	b.custom_minimum_size = Vector2(TOUCH_MIN, TOUCH_MIN)
	b.position = Vector2(20, 20)
	b.pressed.connect(func() -> void: App.back())
	root.add_child(b)
	return b


## A title on a parchment banner along the top of a screen (or, `at_bottom`, along its bottom).
static func banner(root: Control, title: String, subtitle: String = "", at_bottom: bool = false) -> PanelContainer:
	var holder := CenterContainer.new()
	if at_bottom:
		holder.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
		holder.offset_top = -16
		holder.offset_bottom = -16
		holder.grow_vertical = Control.GROW_DIRECTION_BEGIN
	else:
		holder.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
		holder.offset_top = 16
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(holder)
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 0)
	panel.add_child(col)
	label(col, title, 40)
	if subtitle != "":
		label(col, subtitle, 22, INK.lightened(0.25))
	return panel


## A picture from assets/images/ (e.g. "greek/realm_map.png"; a .jpg of the same name will do), or null
## while there is none.
static func picture(file: String) -> Texture2D:
	var path := "res://assets/images/" + file
	for candidate in [path, path.get_basename() + ".jpg", path.get_basename() + ".png"]:
		if ResourceLoader.exists(candidate):
			return load(candidate)
	return null


## A short message near the bottom of the screen that fades away (e.g. "Coming soon!").
static func toast(root: Control, text: String) -> void:
	for old in root.get_children():
		if old.has_meta("toast"):
			old.queue_free()
	var holder := CenterContainer.new()
	holder.set_meta("toast", true)
	holder.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	holder.offset_top = -270  # (above a banner along the bottom)
	holder.offset_bottom = -150
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(holder)
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(panel)
	label(panel, text, 30)
	var tw := holder.create_tween()
	tw.tween_interval(2.2)
	tw.tween_property(holder, "modulate:a", 0.0, 0.5)
	tw.tween_callback(holder.queue_free)
