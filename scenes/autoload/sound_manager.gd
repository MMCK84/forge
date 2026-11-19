extends Node
## SoundManager (Lastenheft 6.6, 8.2): Audio-Busse, Lautstärken, Pitch-Variation (±5 %),
## Ambiente und Musikwechsel je Epoche. Klänge sind prozedurale Platzhalter (scripts/sfx_synth.gd).

const Synth = preload("res://scripts/sfx_synth.gd")

const SFX_BUS := "SFX"
const MUSIC_BUS := "Music"
const POOL_SIZE := 10

var _sounds: Dictionary = {}
var _pool: Array = []
var _pool_idx: int = 0
var _music: AudioStreamPlayer
var _music_epoch: int = -1
var _music_cache: Dictionary = {}
var _amb_fire: AudioStreamPlayer
var _amb_water: AudioStreamPlayer
var _amb_steam: AudioStreamPlayer
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_rng.randomize()
	_setup_buses()
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.bus = SFX_BUS
		add_child(p)
		_pool.append(p)
	_music = AudioStreamPlayer.new()
	_music.bus = MUSIC_BUS
	add_child(_music)
	_amb_fire = _make_ambient()
	_amb_water = _make_ambient()
	_amb_steam = _make_ambient()
	_build_sounds()
	GameManager.sim_event.connect(_on_sim_event)
	GameManager.settings_changed.connect(apply_volumes)
	GameManager.state_changed.connect(update_ambience)
	GameManager.epoch_unlocked.connect(func(_e: int) -> void: play_music_for_epoch(GameManager.current_epoch))
	apply_volumes()


func _setup_buses() -> void:
	for bus_name in [SFX_BUS, MUSIC_BUS]:
		if AudioServer.get_bus_index(bus_name) == -1:
			AudioServer.add_bus()
			var idx := AudioServer.bus_count - 1
			AudioServer.set_bus_name(idx, bus_name)
			AudioServer.set_bus_send(idx, "Master")


func _make_ambient() -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.bus = SFX_BUS
	p.volume_db = -80.0
	add_child(p)
	return p


func _build_sounds() -> void:
	_sounds["hit_good"] = Synth.clang(620.0, 0.55, 1.0, 1)
	_sounds["hit_weak"] = Synth.clang(480.0, 0.35, 0.6, 2)
	_sounds["hit_overheat"] = Synth.clang(560.0, 0.4, 0.8, 3)
	_sounds["hit_cold"] = Synth.klonk()
	_sounds["hit_weld"] = Synth.clang(700.0, 0.5, 1.2, 4)
	_sounds["hit_weld_miss"] = Synth.clang(520.0, 0.3, 0.5, 5)
	_sounds["striker"] = Synth.clang(380.0, 0.6, 0.9, 6)
	_sounds["machine"] = Synth.thump(70.0, 0.35, 0.8)
	_sounds["sizzle"] = Synth.noise(0.35, 0.01, 0.25, 0.9, 0.35, 8)
	_sounds["sparks"] = Synth.crackle(0.6, 60.0, 0.8, false, 12)
	_sounds["quench"] = Synth.noise(1.6, 0.02, 1.2, 0.7, 0.55, 9)
	_sounds["ruin"] = Synth.clatter()
	_sounds["coins"] = Synth.coins()
	_sounds["page"] = Synth.noise(0.3, 0.05, 0.2, 0.25, 0.4, 10)
	_sounds["move"] = Synth.clang(1500.0, 0.12, 0.4, 13)
	_sounds["bellows"] = Synth.noise(0.9, 0.3, 0.5, 0.04, 0.9, 14)
	_sounds["click"] = Synth.click()
	_sounds["done"] = Synth.clang(990.0, 0.6, 0.5, 15)
	_amb_fire.stream = Synth.crackle(4.0, 18.0, 0.5, true, 16)
	_amb_water.stream = Synth.water_loop()
	_amb_steam.stream = Synth.steam_loop()


func apply_volumes() -> void:
	var s: Dictionary = GameManager.settings
	_set_bus_volume(SFX_BUS, float(s.get("sfx_volume", 0.8)))
	_set_bus_volume(MUSIC_BUS, float(s.get("music_volume", 0.6)))


func _set_bus_volume(bus_name: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0:
		return
	AudioServer.set_bus_mute(idx, linear <= 0.001)
	AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(linear, 0.001)))


## Spielt einen Klang mit ±5 % Pitch-Variation.
func play(id: String, volume_db: float = 0.0, vary: bool = true) -> void:
	var stream: AudioStream = _sounds.get(id, null)
	if stream == null:
		return
	var p: AudioStreamPlayer = _pool[_pool_idx]
	_pool_idx = (_pool_idx + 1) % _pool.size()
	p.stream = stream
	p.volume_db = volume_db
	p.pitch_scale = _rng.randf_range(0.95, 1.05) if vary else 1.0
	p.play()


func _on_sim_event(kind: String, _data: Dictionary) -> void:
	match kind:
		"hit_good":
			play("hit_good")
		"hit_weak":
			play("hit_weak", -3.0)
		"hit_overheat":
			play("hit_overheat")
			play("sizzle", -6.0)
		"hit_cold":
			play("hit_cold")
		"hit_weld":
			play("hit_weld")
			play("sparks", -2.0)
		"hit_weld_miss":
			play("hit_weld_miss", -4.0)
		"striker":
			play("striker", -4.0)
		"machine":
			play("machine", -2.0)
		"move":
			play("move", -10.0)
		"weld_done":
			play("sparks")
		"quench_good", "quench_uneven", "quench_soft", "quench_crack":
			play("quench")
		"ruin_burned":
			play("sparks")
			play("sizzle")
			play("ruin", -2.0)
		"ruin_damage":
			play("ruin")
		"coins":
			play("coins", -2.0)
		"page":
			play("page", -4.0)
		"piece_done":
			play("done", -8.0)
		"click":
			play("click", -6.0, false)


func ui_click() -> void:
	play("click", -6.0, false)


# ------------------------------------------------------------------ Ambiente & Musik

func update_ambience() -> void:
	if not GameManager.in_game:
		_fade(_amb_fire, -80.0)
		_fade(_amb_water, -80.0)
		_fade(_amb_steam, -80.0)
		return
	_fade(_amb_fire, -14.0)
	var m := GameManager.current_machine()
	_fade(_amb_water, -12.0 if (GameManager.current_epoch >= 5 and (m == null or m.water_powered)) else -80.0)
	_fade(_amb_steam, -14.0 if (m != null and not m.water_powered) else -80.0)


func _fade(p: AudioStreamPlayer, target_db: float) -> void:
	if target_db > -79.0 and not p.playing:
		p.volume_db = -60.0
		p.play()
	var tw := create_tween()
	tw.tween_property(p, "volume_db", target_db, 1.0)
	if target_db <= -79.0:
		tw.tween_callback(p.stop)


## epoch 0 = Menü-Thema
func play_music_for_epoch(epoch: int) -> void:
	if epoch == _music_epoch and _music.playing:
		return
	_music_epoch = epoch
	if not _music_cache.has(epoch):
		_music_cache[epoch] = Synth.music(epoch)
	var tw := create_tween()
	if _music.playing:
		tw.tween_property(_music, "volume_db", -40.0, 0.6)
	tw.tween_callback(_start_music.bind(epoch))


func _start_music(epoch: int) -> void:
	_music.stream = _music_cache[epoch]
	_music.volume_db = -8.0
	_music.play()


func stop_music() -> void:
	_music.stop()
	_music_epoch = -1
