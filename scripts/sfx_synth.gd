extends RefCounted
## Prozedural erzeugte Platzhalter-Klänge und -Musik (bis finale Audio-Assets vorliegen,
## siehe Lastenheft 12, Punkt 4). Alles wird zur Laufzeit als AudioStreamWAV erzeugt.

const RATE := 22050


static func _to_stream(samples: PackedFloat32Array, loop: bool = false) -> AudioStreamWAV:
	var bytes := PackedByteArray()
	bytes.resize(samples.size() * 2)
	for i in samples.size():
		bytes.encode_s16(i * 2, int(clampf(samples[i], -1.0, 1.0) * 32000.0))
	var s := AudioStreamWAV.new()
	s.format = AudioStreamWAV.FORMAT_16_BITS
	s.mix_rate = RATE
	s.stereo = false
	s.data = bytes
	if loop:
		s.loop_mode = AudioStreamWAV.LOOP_FORWARD
		s.loop_begin = 0
		s.loop_end = samples.size()
	return s


static func _buf(seconds: float) -> PackedFloat32Array:
	var b := PackedFloat32Array()
	b.resize(int(seconds * RATE))
	b.fill(0.0)
	return b


## Metallischer Ambossklang: unharmonische Teiltöne mit Abklingen und Anschlaggeräusch.
static func clang(base: float, decay: float, brightness: float, seed_value: int = 1) -> AudioStreamWAV:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var b := _buf(decay * 1.6)
	var partials := [[1.0, 1.0], [2.76, 0.6 * brightness], [5.40, 0.35 * brightness], [8.93, 0.2 * brightness], [1.51, 0.3]]
	for i in b.size():
		var t := float(i) / RATE
		var v := 0.0
		for p in partials:
			v += sin(TAU * base * float(p[0]) * t) * float(p[1]) * exp(-t * (3.0 + float(p[0]) * 1.5) / decay)
		if t < 0.012:
			v += rng.randf_range(-1.0, 1.0) * (1.0 - t / 0.012) * 0.8
		b[i] = v * 0.35
	return _to_stream(b)


## Dumpfes "Klonk" bei kaltem Metall.
static func klonk() -> AudioStreamWAV:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var b := _buf(0.35)
	var lp := 0.0
	for i in b.size():
		var t := float(i) / RATE
		lp += (rng.randf_range(-1.0, 1.0) - lp) * 0.08
		b[i] = (sin(TAU * 170.0 * t) * 0.7 + sin(TAU * 260.0 * t) * 0.3 + lp * 2.0) * exp(-t * 18.0) * 0.6
	return _to_stream(b)


## Rauschen mit Hüllkurve (Zischen, Dampf, Blasebalg, Pergament).
static func noise(seconds: float, attack: float, release: float, smooth: float, gain: float, seed_value: int = 3) -> AudioStreamWAV:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var b := _buf(seconds)
	var lp := 0.0
	var prev := 0.0
	for i in b.size():
		var t := float(i) / RATE
		var n := rng.randf_range(-1.0, 1.0)
		lp += (n - lp) * smooth
		var hp := lp - prev * 0.6
		prev = lp
		var env := minf(1.0, t / maxf(attack, 0.001)) * clampf((seconds - t) / maxf(release, 0.001), 0.0, 1.0)
		b[i] = hp * env * gain
	return _to_stream(b)


## Knistern (Funken, Kohle).
static func crackle(seconds: float, density: float, gain: float, loop: bool, seed_value: int = 11) -> AudioStreamWAV:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var b := _buf(seconds)
	var lp := 0.0
	for i in b.size():
		lp += (rng.randf_range(-1.0, 1.0) - lp) * 0.02
		b[i] = lp * 0.25 * gain
	var pops := int(seconds * density)
	for k in pops:
		var start := rng.randi_range(0, b.size() - 200)
		var amp := rng.randf_range(0.2, 1.0) * gain
		var length := rng.randi_range(30, 160)
		for j in length:
			b[start + j] += rng.randf_range(-1.0, 1.0) * amp * (1.0 - float(j) / length)
	return _to_stream(b, loop)


static func coins() -> AudioStreamWAV:
	var b := _buf(0.6)
	var hits := [[0.0, 2900.0], [0.07, 3400.0], [0.15, 3100.0], [0.24, 3800.0]]
	for h in hits:
		var start := int(float(h[0]) * RATE)
		for i in range(start, b.size()):
			var t := float(i - start) / RATE
			b[i] += (sin(TAU * float(h[1]) * t) + 0.5 * sin(TAU * float(h[1]) * 2.3 * t)) * exp(-t * 22.0) * 0.18
	return _to_stream(b)


static func thump(freq: float, decay: float, gain: float) -> AudioStreamWAV:
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	var b := _buf(decay * 1.5)
	var lp := 0.0
	for i in b.size():
		var t := float(i) / RATE
		lp += (rng.randf_range(-1.0, 1.0) - lp) * 0.05
		var f := freq * (1.0 + 0.6 * exp(-t * 30.0))
		b[i] = (sin(TAU * f * t) + lp * 1.5) * exp(-t * 4.0 / decay) * gain
	return _to_stream(b)


static func clatter() -> AudioStreamWAV:
	var rng := RandomNumberGenerator.new()
	rng.seed = 21
	var b := _buf(0.9)
	for k in 6:
		var start := int(rng.randf_range(0.0, 0.5) * RATE)
		var f := rng.randf_range(600.0, 1500.0)
		for i in range(start, b.size()):
			var t := float(i - start) / RATE
			b[i] += (sin(TAU * f * t) + 0.4 * sin(TAU * f * 2.7 * t)) * exp(-t * 14.0) * 0.12
	return _to_stream(b)


static func click() -> AudioStreamWAV:
	var b := _buf(0.05)
	for i in b.size():
		var t := float(i) / RATE
		b[i] = sin(TAU * 1800.0 * t) * exp(-t * 120.0) * 0.3
	return _to_stream(b)


## Wasserrad: rhythmisches Plätschern (Schleife).
static func water_loop() -> AudioStreamWAV:
	var rng := RandomNumberGenerator.new()
	rng.seed = 31
	var b := _buf(4.0)
	var lp := 0.0
	for i in b.size():
		var t := float(i) / RATE
		lp += (rng.randf_range(-1.0, 1.0) - lp) * 0.12
		var pulse := 0.5 + 0.5 * sin(TAU * 1.0 * t)
		b[i] = lp * (0.25 + 0.5 * pulse * pulse) * 0.5
	return _to_stream(b, true)


## Dampfmaschine: Schnaufen im Takt (Schleife).
static func steam_loop() -> AudioStreamWAV:
	var rng := RandomNumberGenerator.new()
	rng.seed = 41
	var b := _buf(2.0)
	var lp := 0.0
	for i in b.size():
		var t := float(i) / RATE
		lp += (rng.randf_range(-1.0, 1.0) - lp) * 0.3
		var ph := fmod(t, 0.5) / 0.5
		var env := exp(-ph * 6.0)
		b[i] = (lp * env * 0.5) + sin(TAU * 55.0 * t) * 0.08
	return _to_stream(b, true)


# ------------------------------------------------------------------ Musik

static var _pluck_cache: Dictionary = {}


static func _midi_freq(m: int) -> float:
	return 440.0 * pow(2.0, float(m - 69) / 12.0)


## Gezupfte Saite (Karplus-Strong), für Laute.
static func _pluck(midi: int, seconds: float) -> PackedFloat32Array:
	var key := "%d_%f" % [midi, seconds]
	if _pluck_cache.has(key):
		return _pluck_cache[key]
	var rng := RandomNumberGenerator.new()
	rng.seed = midi * 13
	var n := int(seconds * RATE)
	var period := maxi(2, int(RATE / _midi_freq(midi)))
	var ring := PackedFloat32Array()
	ring.resize(period)
	for i in period:
		ring[i] = rng.randf_range(-1.0, 1.0)
	var out := PackedFloat32Array()
	out.resize(n)
	var idx := 0
	for i in n:
		var a := ring[idx]
		var nxt := ring[(idx + 1) % period]
		ring[idx] = (a + nxt) * 0.4985
		out[i] = a
		idx = (idx + 1) % period
	_pluck_cache[key] = out
	return out


static func _mix(target: PackedFloat32Array, src: PackedFloat32Array, start: int, gain: float) -> PackedFloat32Array:
	var end := mini(target.size(), start + src.size())
	for i in range(start, end):
		target[i] += src[i - start] * gain
	return target


## Ruhige Folk-Schleife; die Besetzung wächst mit den Epochen (6.6). epoch 0 = Menü-Thema.
static func music(epoch: int) -> AudioStreamWAV:
	var bpm := 84.0 if epoch == 0 else 92.0 + float(epoch) * 2.0
	var beat := 60.0 / bpm
	var bars := 8
	var total := beat * 4.0 * bars
	var b := _buf(total)
	# D-Dur / h-Moll im Wechsel: Akkorde als MIDI-Grundtöne + Arpeggio-Töne
	var prog := [
		[50, [62, 66, 69, 74]], [55, [62, 67, 71, 74]], [57, [61, 64, 69, 73]], [50, [62, 66, 69, 74]],
		[47, [59, 62, 66, 71]], [55, [62, 67, 71, 74]], [57, [61, 64, 69, 76]], [50, [62, 66, 69, 74]],
	]
	var pattern := [0, 1, 2, 3, 2, 1, 2, 1]
	# Laute (immer)
	for bar in bars:
		var chord: Array = prog[bar % prog.size()][1]
		for k in 8:
			var note: int = chord[pattern[k]]
			var start := int((bar * 4.0 + k * 0.5) * beat * RATE)
			b = _mix(b, _pluck(note, 0.9), start, 0.16)
	# Cello-Bordun ab Epoche 2 (und im Menü)
	if epoch == 0 or epoch >= 2:
		for bar in bars:
			var root: int = prog[bar % prog.size()][0] - 12
			var f := _midi_freq(root)
			var start := int(bar * 4.0 * beat * RATE)
			var length := int(4.0 * beat * RATE)
			for i in length:
				var t := float(i) / RATE
				var env := minf(1.0, t / 0.25) * minf(1.0, (float(length - i) / RATE) / 0.3)
				var v := sin(TAU * f * t + 0.004 * sin(TAU * 5.0 * t) * 40.0) * 0.6 + sin(TAU * f * 2.0 * t) * 0.25 + sin(TAU * f * 3.0 * t) * 0.1
				if start + i < b.size():
					b[start + i] += v * env * 0.07
	# Flöte ab Epoche 3 (und im Menü)
	if epoch == 0 or epoch >= 3:
		var melody := [74, 76, 78, 76, 74, 71, 69, 71, 74, 73, 71, 69, 66, 69, 71, 74]
		for k in melody.size():
			var f2 := _midi_freq(melody[k])
			var start2 := int(k * 2.0 * beat * RATE)
			var length2 := int(1.8 * beat * RATE)
			for i in length2:
				var t := float(i) / RATE
				var env := minf(1.0, t / 0.08) * minf(1.0, (float(length2 - i) / RATE) / 0.15)
				var vib := 1.0 + 0.006 * sin(TAU * 5.5 * t) * minf(1.0, t / 0.4)
				if start2 + i < b.size():
					b[start2 + i] += sin(TAU * f2 * vib * t) * env * 0.06
	# Zweite Laute (Oktave) ab Epoche 5
	if epoch >= 5:
		for bar in bars:
			var chord2: Array = prog[bar % prog.size()][1]
			for k in 4:
				var start3 := int((bar * 4.0 + k + 0.25) * beat * RATE)
				b = _mix(b, _pluck(chord2[(k + 2) % 4] + 12, 0.6), start3, 0.07)
	return _to_stream(b, true)
