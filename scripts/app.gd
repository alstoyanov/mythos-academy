extends Node
## Autoload "App": where the player is (the mythology and area chosen), moving between screens, and the
## player's settings, the language among them (Bulgarian first, see Translations). Android's Back button and Esc on a keyboard go back one screen; from the main
## menu, Back leaves the game on a phone.

const MAIN_MENU := "res://scenes/main_menu.tscn"
const WORLD_MAP := "res://scenes/world_map.tscn"
const REALM_MAP := "res://scenes/realm_map.tscn"
const AREA := "res://scenes/area.tscn"
const SETTINGS_PATH := "user://settings.cfg"
var progress_path := "user://progress.cfg"  ## the best scores (the tests use their own file)

var mythology_id := ""  ## the mythology opened on the world map
var area_id := ""  ## the learning area opened on the realm map
var music_on := true  ## (no music yet: kept for when there is)
var sounds_on := true
var voice_on := true  ## instructions read aloud (the device's text to speech)
var fullscreen := false
var language := Translations.DEFAULT  ## a code of Translations.LANGUAGES

var _history: Array[String] = []  ## the screens to go back to
var _best := {}  ## "<game>/<seconds>" -> the best score of a timed round


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Translations.install()
	_load_settings()
	TranslationServer.set_locale(language)
	_load_progress()
	if fullscreen and can_fullscreen():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


## Opens a screen; Back returns to the one shown now.
func go(scene: String) -> void:
	var current := get_tree().current_scene
	if current != null and current.scene_file_path != "":
		_history.append(current.scene_file_path)
	get_tree().change_scene_to_file(scene)


## Back to the screen before (the main menu if there is none).
func back() -> void:
	get_tree().change_scene_to_file(_history.pop_back() if not _history.is_empty() else MAIN_MENU)


func open_mythology(id: String) -> void:
	mythology_id = id
	go(REALM_MAP)


func open_area(id: String) -> void:
	area_id = id
	go(AREA)


## Phones and tablets are always full screen; a desktop window can switch.
static func can_fullscreen() -> bool:
	return not (OS.has_feature("mobile") or OS.has_feature("web"))


func set_fullscreen(on: bool) -> void:
	fullscreen = on
	if can_fullscreen():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if on else DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()


## Keeps the best scores in another file (the tests: the player's own are left alone).
func use_progress_file(path: String) -> void:
	progress_path = path
	_best.clear()
	_load_progress()


func _load_progress() -> void:
	var progress := ConfigFile.new()
	if progress.load(progress_path) == OK and progress.has_section("best"):
		for key in progress.get_section_keys("best"):
			_best[key] = int(progress.get_value("best", key, 0))


## The best score of `game` in a timed round of `seconds` (0 if it was never played).
func best_score(game: String, seconds: int) -> int:
	return _best.get("%s/%d" % [game, seconds], 0)


## Keeps `score` if it beats the best of `game` at `seconds`; true if it is a new best.
func record_score(game: String, seconds: int, score: int) -> bool:
	if score <= best_score(game, seconds):
		return false
	_best["%s/%d" % [game, seconds]] = score
	var progress := ConfigFile.new()
	for key: String in _best:
		progress.set_value("best", key, _best[key])
	progress.save(progress_path)
	return true


## Switches the language and keeps it (a screen shown must be built again to show it).
func set_language(code: String) -> void:
	if not Translations.has_language(code):
		return
	language = code
	_voice = ""
	TranslationServer.set_locale(code)
	save_settings()


func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "music", music_on)
	cfg.set_value("audio", "sounds", sounds_on)
	cfg.set_value("audio", "voice", voice_on)
	cfg.set_value("display", "fullscreen", fullscreen)
	cfg.set_value("display", "language", language)
	cfg.save(SETTINGS_PATH)


func _load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return
	music_on = bool(cfg.get_value("audio", "music", music_on))
	sounds_on = bool(cfg.get_value("audio", "sounds", sounds_on))
	voice_on = bool(cfg.get_value("audio", "voice", voice_on))
	fullscreen = bool(cfg.get_value("display", "fullscreen", fullscreen))
	var saved := str(cfg.get_value("display", "language", language))
	if Translations.has_language(saved):
		language = saved


## Reads `text` (already in the game's language) aloud with the device's text to speech (Windows,
## Android, ...), if "Read aloud" is on and the device has a voice for the language (never another
## language's voice: it would mangle the words); a new line stops the one being read. (Recorded voices
## come later.)
func say(text: String) -> void:
	if not voice_on or DisplayServer.get_name() == "headless":
		return
	if not ProjectSettings.get_setting("audio/general/text_to_speech", false):
		return
	if _voice == "":
		var voices := DisplayServer.tts_get_voices_for_language(language)
		if voices.is_empty():
			return
		_voice = voices[0]
	DisplayServer.tts_stop()
	DisplayServer.tts_speak(text, _voice)


var _voice := ""


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:  # Android's Back
		_on_back_requested()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Esc
		get_viewport().set_input_as_handled()
		_on_back_requested()


func _on_back_requested() -> void:
	var current := get_tree().current_scene
	if current != null and current.has_method("on_back") and current.call("on_back"):
		return  # the screen handled it (e.g. closed a panel)
	if current != null and current.scene_file_path == MAIN_MENU:
		if OS.has_feature("mobile"):
			get_tree().quit()
		return
	back()
