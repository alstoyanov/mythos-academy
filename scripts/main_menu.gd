extends Control
## The title screen: the game's name, Glaux the owl (the guide) waving from a corner, a big Play button
## that opens the world map, Settings, and Quit (on a PC only: a phone app is left with the Home or Back
## button).

var _settings: Control


func _ready() -> void:
	Ui.setup_screen(self)
	var scenery := Ui.picture("ui/title_background.png")
	if scenery != null:  # the picture covers the screen, whatever its shape
		var bg := TextureRect.new()
		bg.texture = scenery
		bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(bg)
	else:  # until there is one: the world map placeholder, faded
		var backdrop := MapView.new()
		backdrop.placeholder = "world"
		backdrop.modulate = Color(1, 1, 1, 0.55)
		backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(backdrop)
	var owl := Ui.picture("ui/mascot_owl.png")
	if owl != null:  # Glaux waves from the lower left corner
		var pic := TextureRect.new()
		pic.texture = owl
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
		pic.offset_left = 10
		pic.offset_top = -330
		pic.offset_right = 320
		pic.offset_bottom = -10
		add_child(pic)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 18)
	center.add_child(col)

	# The logo has the game's name written on it: ui/logo.png in English, ui/logo_<language>.png in the
	# others. Without the language's own, the name is written out instead.
	var logo := Ui.picture("ui/logo.png" if App.language == "en" else "ui/logo_%s.png" % App.language)
	if logo != null:
		var pic := TextureRect.new()
		pic.texture = logo
		pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pic.custom_minimum_size = Vector2(760, 238)
		col.add_child(pic)
	else:
		var title := PanelContainer.new()
		col.add_child(title)
		var tcol := VBoxContainer.new()
		title.add_child(tcol)
		Ui.label(tcol, "Mythos Academy", 72)
		Ui.label(tcol, "Learn and play with the heroes of myth", 26, Ui.INK.lightened(0.25))

	var play := Ui.button(col, "Play", func() -> void: App.go(App.WORLD_MAP), 48)
	play.custom_minimum_size = Vector2(360, 120)
	play.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 20)
	col.add_child(row)
	Ui.button(row, "Settings", _open_settings, 30).custom_minimum_size = Vector2(220, Ui.TOUCH_MIN)
	if App.can_fullscreen():
		Ui.button(row, "Quit", func() -> void: get_tree().quit(), 30).custom_minimum_size = Vector2(220, Ui.TOUCH_MIN)
	play.call_deferred("grab_focus")


## Settings: music, sounds and (on a PC) full screen. A panel over the menu; Back closes it.
func _open_settings() -> void:
	if _settings != null:
		return
	_settings = ColorRect.new()
	_settings.color = Color(0, 0, 0, 0.45)
	_settings.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_settings)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_settings.add_child(center)
	var panel := PanelContainer.new()
	center.add_child(panel)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 16)
	panel.add_child(col)
	Ui.label(col, "Settings", 44)
	_switch(col, "Music", App.music_on, func(on: bool) -> void:
		App.music_on = on
		App.save_settings())
	_switch(col, "Sounds", App.sounds_on, func(on: bool) -> void:
		App.sounds_on = on
		App.save_settings())
	_switch(col, "Read aloud", App.voice_on, func(on: bool) -> void:
		App.voice_on = on
		App.save_settings())
	if App.can_fullscreen():
		_switch(col, "Full screen", App.fullscreen, func(on: bool) -> void: App.set_fullscreen(on))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	col.add_child(row)
	var caption := Ui.label(row, "Language", 32)
	caption.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var pick := OptionButton.new()
	pick.add_theme_font_size_override("font_size", 28)
	pick.custom_minimum_size = Vector2(220, Ui.TOUCH_MIN * 0.8)
	pick.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED  # (each language by its own name)
	for i in Translations.LANGUAGES.size():
		pick.add_item(Translations.LANGUAGES[i][1])
		pick.set_item_metadata(i, Translations.LANGUAGES[i][0])
		if Translations.LANGUAGES[i][0] == App.language:
			pick.select(i)
	pick.item_selected.connect(func(i: int) -> void:
		App.set_language(pick.get_item_metadata(i))
		get_tree().reload_current_scene())  # the menu again, in the new language
	row.add_child(pick)
	var done := Ui.button(col, "Done", _close_settings, 32)
	done.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	done.grab_focus()


func _switch(parent: Node, text: String, on: bool, changed: Callable) -> void:
	var s := CheckButton.new()
	s.text = text
	s.button_pressed = on
	s.add_theme_font_size_override("font_size", 32)
	s.add_theme_color_override("font_color", Ui.INK)
	s.add_theme_color_override("font_hover_color", Ui.INK)
	s.add_theme_color_override("font_pressed_color", Ui.INK)
	s.add_theme_color_override("font_focus_color", Ui.INK)
	s.add_theme_color_override("font_hover_pressed_color", Ui.INK)
	var flat := StyleBoxEmpty.new()
	for state in ["normal", "hover", "pressed", "focus", "hover_pressed"]:
		s.add_theme_stylebox_override(state, flat)
	s.custom_minimum_size = Vector2(380, Ui.TOUCH_MIN * 0.8)
	s.toggled.connect(changed)
	parent.add_child(s)


func _close_settings() -> void:
	if _settings != null:
		_settings.queue_free()
		_settings = null


## Back (Esc, Android's Back) closes Settings first.
func on_back() -> bool:
	if _settings != null:
		_close_settings()
		return true
	return false
