extends Node
## Autoload "Sound": the sound effects, on the "SFX" audio bus, off when Settings' "Sounds" is off.
## Every button clicks by itself (one with the meta "sound" plays that sound instead, e.g. "back");
## the games call Sound.play("name"). To change a sound, edit SOUNDS. Sources and licences:
## assets/audio/sfx/CREDITS.txt.

const SFX_DIR := "res://assets/audio/sfx/"
const VOICES := 8  ## sounds that can overlap

## name -> [file (without .ogg), volume in dB, random pitch variation]
const SOUNDS := {
	"click": ["click_003", -3.0, 0.0],  # a button
	"back": ["back_002", -3.0, 0.0],  # back, close
	"start": ["maximize_006", -2.0, 0.0],  # a game or a round starts
	"toggle": ["toggle_002", -4.0, 0.0],  # a setting switched
	"tick": ["tick_002", -6.0, 0.0],  # the last seconds of a timed round
	"zap": ["sniper", -6.0, 0.05],  # Zeus throws a thunderbolt
	"burst": ["special", -4.0, 0.06],  # the right cloud bursts into sparks
	"oops": ["pick", -9.0, 0.0],  # a wrong cloud wobbles: soft, never a "wrong" buzz
	"whoosh": ["feather", -10.0, 0.05],  # new clouds float in
	"fanfare": ["win", -5.0, 0.0],  # a round is over (a new best, the time is up)
}

var _voices: Array[AudioStreamPlayer] = []
var _next := 0
var _streams := {}
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	if AudioServer.get_bus_index("SFX") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, "SFX")
	for i in VOICES:
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_voices.append(p)
	get_tree().node_added.connect(_on_node_added)


func play(sound: String) -> void:
	if not App.sounds_on or not SOUNDS.has(sound) or DisplayServer.get_name() == "headless":
		return
	var spec: Array = SOUNDS[sound]
	var stream := _stream(spec[0])
	if stream == null:
		return
	var voice := _voices[_next]
	_next = (_next + 1) % VOICES
	voice.stream = stream
	voice.volume_db = spec[1]
	voice.pitch_scale = 1.0 + _rng.randf_range(-spec[2], spec[2])
	voice.play()


func _stream(file: String) -> AudioStream:
	if not _streams.has(file):
		var path := SFX_DIR + file + ".ogg"
		_streams[file] = load(path) if ResourceLoader.exists(path) else null
	return _streams[file]


## Every button (and switch) sounds when it is pressed.
func _on_node_added(node: Node) -> void:
	if node is BaseButton and not node.is_in_group("silent"):
		var b := node as BaseButton
		b.pressed.connect(func() -> void:
			play(b.get_meta("sound", "toggle" if b is CheckButton else "click")))
