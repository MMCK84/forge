# -*- coding: utf-8 -*-
"""Offline-Synthese aller Klänge und der Musik (Lastenheft 6.6) als Ogg Vorbis.
Instrumente: Laute (Karplus-Strong + Korpus), Cello/Violine (gestrichen, additiv),
Flöte, Cembalo, Rahmentrommel. Musik je Epoche als nahtlose Schleife."""
import math
import numpy as np
import soundfile as sf
from scipy.signal import lfilter, butter, sosfilt, fftconvolve
from common import out_path

SR = 44100
R = np.random.default_rng(1234)


def t_axis(sec):
    return np.arange(int(sec * SR)) / SR


def env_exp(sec, decay):
    return np.exp(-t_axis(sec) / decay)


def bp(x, lo, hi, order=2):
    sos = butter(order, [lo / (SR / 2), min(hi / (SR / 2), 0.99)], "band", output="sos")
    return sosfilt(sos, x)


def lp(x, f, order=2):
    return sosfilt(butter(order, min(f / (SR / 2), 0.99), "low", output="sos"), x)


def hp(x, f, order=2):
    return sosfilt(butter(order, f / (SR / 2), "high", output="sos"), x)


def noise(sec, seed=0):
    return np.random.default_rng(seed).uniform(-1, 1, int(sec * SR))


def norm(x, peak=0.89):
    m = np.max(np.abs(x)) + 1e-9
    return x / m * peak


def fade(x, fi=0.002, fo=0.02):
    x = x.copy()
    n1, n2 = int(fi * SR), int(fo * SR)
    if n1:
        x[:n1] *= np.linspace(0, 1, n1)
    if n2:
        x[-n2:] *= np.linspace(1, 0, n2)
    return x


def write(x, *path, stereo=False, quality=4):
    """Schreibt Ogg Vorbis über ffmpeg/libvorbis (libsndfile stürzt bei langen Ogg-Dateien ab)."""
    import os
    import subprocess
    import tempfile
    p = out_path(*path)
    data = x.T if stereo else x
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        wav = tmp.name
    sf.write(wav, np.clip(data, -1, 1).astype(np.float32), SR, subtype="PCM_16")
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", wav, "-c:a", "libvorbis", "-q:a", str(quality), p], check=True)
    os.remove(wav)
    return p


# ================================================================== Effekte

def anvil_ring(base, sec, brightness=1.0, damp=1.0, seed=0):
    t = t_axis(sec)
    r = np.random.default_rng(seed)
    modes = [(1.0, 1.0, 1.4), (1.47, 0.6, 1.0), (2.31, 0.45 * brightness, 0.7), (3.62, 0.3 * brightness, 0.45),
             (5.18, 0.18 * brightness, 0.3), (7.01, 0.1 * brightness, 0.2)]
    out = np.zeros_like(t)
    for ratio, amp, dec in modes:
        f = base * ratio * r.uniform(0.995, 1.005)
        out += amp * np.sin(2 * np.pi * f * t + r.uniform(0, 6.28)) * np.exp(-t / (dec * 0.35 * damp))
    return out


def strike(base=900, ring=1.0, thud=0.6, click=0.5, sec=1.4, seed=0, brightness=1.0):
    t = t_axis(sec)
    x = anvil_ring(base, sec, brightness, ring, seed) * 0.6 * ring
    th = lp(noise(sec, seed + 1), 300) * np.exp(-t / 0.05) * 6 + np.sin(2 * np.pi * 95 * t) * np.exp(-t / 0.07)
    cl = hp(noise(sec, seed + 2), 2500) * np.exp(-t / 0.006)
    return fade(norm(x + th * thud + cl * click, 0.9), 0.0005, 0.05)


def sizzle(sec=0.6, seed=3):
    t = t_axis(sec)
    n = hp(noise(sec, seed), 3000) * (0.6 + 0.4 * np.random.default_rng(seed).random(len(t)) ** 8)
    return fade(norm(n * np.minimum(1, t / 0.01) * np.exp(-t / (sec * 0.45)), 0.6))


def sparks(sec=0.9, density=90, seed=5):
    t = t_axis(sec)
    x = hp(noise(sec, seed), 4000) * 0.05 * np.exp(-t / 0.4)
    r = np.random.default_rng(seed)
    for k in range(int(density * sec)):
        s = int(r.uniform(0, sec * 0.8) * SR)
        L = int(r.uniform(0.002, 0.008) * SR)
        if s + L < len(x):
            x[s:s + L] += hp(r.uniform(-1, 1, L), 3000) * r.uniform(0.2, 1) * np.exp(-np.arange(L) / (L * 0.3))
    return fade(norm(x, 0.7))


def quench(sec=2.4, seed=7):
    t = t_axis(sec)
    hiss = bp(noise(sec, seed), 2500, 9000) * (np.minimum(1, t / 0.02) * np.exp(-t / 0.9))
    r = np.random.default_rng(seed)
    bub = np.zeros_like(t)
    for k in range(70):
        s = int(r.uniform(0.05, sec * 0.8) * SR)
        f = r.uniform(300, 1200)
        L = int(0.03 * SR)
        if s + L < len(t):
            tt = np.arange(L) / SR
            bub[s:s + L] += np.sin(2 * np.pi * f * (1 + 4 * tt) * tt) * np.exp(-tt / 0.008) * r.uniform(0.1, 0.4)
    steam = lp(noise(sec, seed + 1), 900) * np.exp(-t / 1.2) * 0.6
    return fade(norm(hiss + bub * np.exp(-t / 0.8) + steam, 0.85), 0.002, 0.3)


def clatter(seed=9):
    sec = 1.3
    x = np.zeros(int(sec * SR))
    r = np.random.default_rng(seed)
    crack = hp(noise(0.05, seed), 1500) * np.exp(-t_axis(0.05) / 0.01)
    x[:len(crack)] += crack * 1.5
    for k in range(7):
        s = int(r.uniform(0.05, 0.7) * SR)
        part = anvil_ring(r.uniform(600, 1800), 0.5, 0.8, 0.4, seed + k) * r.uniform(0.3, 0.8)
        x[s:s + len(part)] += part[:len(x) - s]
    return fade(norm(x, 0.85))


def coins(seed=11):
    sec = 0.9
    x = np.zeros(int(sec * SR))
    r = np.random.default_rng(seed)
    for k in range(6):
        s = int((k * 0.075 + r.uniform(0, 0.03)) * SR)
        f = r.uniform(2400, 4200)
        tt = t_axis(0.35)
        c = (np.sin(2 * np.pi * f * tt) + 0.6 * np.sin(2 * np.pi * f * 2.76 * tt) + 0.3 * np.sin(2 * np.pi * f * 5.4 * tt)) * np.exp(-tt / 0.06)
        c += hp(noise(0.35, seed + k), 5000) * np.exp(-tt / 0.004)
        x[s:s + len(c)] += c[:len(x) - s] * r.uniform(0.4, 1.0)
    return fade(norm(x, 0.7))


def page(seed=13):
    sec = 0.45
    t = t_axis(sec)
    n = bp(noise(sec, seed), 800, 7000)
    am = np.abs(np.sin(np.pi * t / sec)) * (0.5 + 0.5 * np.random.default_rng(seed).random(len(t)) ** 3)
    return fade(norm(lp(n * am, 6000), 0.5))


def bellows(seed=15):
    sec = 1.1
    t = t_axis(sec)
    n = lp(noise(sec, seed), 500) * np.sin(np.pi * t / sec) ** 2
    creak = np.sin(2 * np.pi * (180 + 40 * t) * t) * np.exp(-((t - 0.1) / 0.05) ** 2) * 0.2
    return fade(norm(n + creak, 0.6))


def click(seed=17):
    t = t_axis(0.08)
    x = bp(noise(0.08, seed), 1500, 6000) * np.exp(-t / 0.004) + np.sin(2 * np.pi * 1200 * t) * np.exp(-t / 0.01) * 0.3
    return fade(norm(x, 0.5), 0.0002, 0.01)


def chime():
    t = t_axis(1.2)
    x = sum(a * np.sin(2 * np.pi * 1318.5 * r * t) * np.exp(-t / d) for r, a, d in ((1, 1, 0.5), (2.0, 0.4, 0.25), (3.0, 0.15, 0.15)))
    return fade(norm(x, 0.5))


def steam_puff(seed=19):
    sec = 0.7
    t = t_axis(sec)
    return fade(norm(bp(noise(sec, seed), 400, 5000) * np.minimum(1, t / 0.02) * np.exp(-t / 0.25), 0.6))


def machine_hit(steam=False, seed=21):
    sec = 1.2
    t = t_axis(sec)
    wood = lp(noise(sec, seed), 400) * np.exp(-t / 0.06) * 4 + np.sin(2 * np.pi * (70 if steam else 85) * t) * np.exp(-t / 0.18)
    x = wood + strike(500 if steam else 650, 0.6, 0.4, 0.3, sec, seed) * 0.6
    if steam:
        p = steam_puff(seed + 1)
        x[:len(p)] += p * 0.5
    return fade(norm(x, 0.9))


def ambience_fire(sec=8.0, seed=23):
    t = t_axis(sec)
    roar = lp(noise(sec, seed), 300) * (0.6 + 0.4 * lp(np.abs(noise(sec, seed + 1)), 3) * 20)
    x = roar * 0.6 + sparks(sec, 14, seed + 2) * 0.35
    return loopify(x, 0.5)


def ambience_water(sec=8.0, seed=29):
    t = t_axis(sec)
    flow = bp(noise(sec, seed), 300, 3000) * 0.5
    slosh = lp(noise(sec, seed + 1), 900) * (0.5 + 0.5 * np.sin(2 * np.pi * t / 2.0)) ** 3
    x = flow + slosh * 1.5
    r = np.random.default_rng(seed)
    for k in range(int(sec / 2)):  # Knarren der Welle
        s = int((k * 2.0 + 0.3) * SR)
        L = int(0.25 * SR)
        tt = np.arange(L) / SR
        cr = np.sin(2 * np.pi * (90 + 30 * tt) * tt + 3 * np.sin(2 * np.pi * 12 * tt)) * np.sin(np.pi * tt / 0.25) * 0.4
        x[s:s + L] += cr
    return loopify(x, 0.5)


def ambience_steam(sec=4.0, seed=31):
    t = t_axis(sec)
    x = np.zeros_like(t)
    for k in range(int(sec / 0.5)):
        s = int(k * 0.5 * SR)
        p = steam_puff(seed + k) * (0.8 if k % 2 == 0 else 0.5)
        x[s:s + len(p)] += p[:len(x) - s]
        if k % 2 == 0:
            c = strike(300, 0.3, 0.8, 0.2, 0.3, seed + k) * 0.3
            x[s:s + len(c)] += c[:len(x) - s]
    x += np.sin(2 * np.pi * 50 * t) * 0.05
    return loopify(x, 0.2)


def loopify(x, xf):
    """Nahtlose Schleife durch Überblenden des Endes in den Anfang."""
    n = int(xf * SR)
    head, body, tail = x[:n], x[n:-n] if n else x, x[-n:]
    ramp = np.linspace(0, 1, n)
    start = tail * (1 - ramp) + head * ramp
    return norm(np.concatenate([start, x[n:-n]]), 0.6)


# ================================================================== Instrumente

def midi_f(m):
    return 440.0 * 2 ** ((m - 69) / 12)


_PLUCK = {}


def pluck(m, sec, vel=0.8, bright=0.5, seed=0):
    key = (m, round(bright, 1), seed % 3)
    if key not in _PLUCK:
        f = midi_f(m)
        N = SR / f
        Ni = int(N)
        frac = N - Ni
        L = int(3.0 * SR)
        exc = np.zeros(L)
        burst = np.random.default_rng(m * 7 + seed % 3).uniform(-1, 1, Ni)
        burst = lp(burst, 1500 + 5000 * bright)
        pos = max(2, int(Ni * 0.18))  # Zupfposition (Kammfilter)
        burst[pos:] -= burst[:-pos] * 0.7
        exc[:Ni] = burst
        g = 0.996 - 0.0015 * max(0, (m - 60) / 12)
        a = np.zeros(Ni + 2)
        a[0] = 1
        a[Ni] = -g * (1 - frac)
        a[Ni + 1] = -g * frac
        y = lfilter([1.0], a, exc)
        body = bp(y, 90, 400) * 0.6 + bp(y, 1500, 3500) * 0.3 + y * 0.7
        _PLUCK[key] = body / (np.max(np.abs(body)) + 1e-9)
    y = _PLUCK[key][:int(sec * SR)].copy()
    return fade(y * vel, 0.0005, min(0.08, sec * 0.3))


def bowed(m, sec, vel=0.7, bright=0.6, vib=0.006, attack=0.12, seed=0):
    t = t_axis(sec)
    f0 = midi_f(m)
    r = np.random.default_rng(seed)
    vibr = 1 + vib * np.sin(2 * np.pi * 5.3 * t + r.uniform(0, 6)) * np.minimum(1, t / 0.35)
    phase = 2 * np.pi * np.cumsum(f0 * vibr) / SR
    x = np.zeros_like(t)
    nh = int(min(24, (SR / 2.2) / f0))
    for h in range(1, nh + 1):
        x += np.sin(h * phase) * (1 / h) ** (1.15 - 0.4 * bright)
    x += bp(noise(sec, seed), f0, min(f0 * 6, 12000)) * 0.03
    body = bp(x, 200, 350) * 0.8 + bp(x, 450, 800) * 0.6 + bp(x, 1800, 3200) * 0.35 * bright + x * 0.3
    envl = np.minimum(1, t / attack) * np.minimum(1, (sec - t) / 0.12)
    envl *= 0.85 + 0.15 * np.sin(np.pi * np.clip(t / sec, 0, 1))
    return body * envl * vel


def flute(m, sec, vel=0.6, seed=0):
    t = t_axis(sec)
    f0 = midi_f(m)
    vibr = 1 + 0.005 * np.sin(2 * np.pi * 5.0 * t) * np.minimum(1, t / 0.4)
    ph = 2 * np.pi * np.cumsum(f0 * vibr) / SR
    x = np.sin(ph) + 0.22 * np.sin(2 * ph) + 0.08 * np.sin(3 * ph)
    breath = bp(noise(sec, seed), f0 * 0.8, f0 * 3) * 0.12 + hp(noise(sec, seed + 1), 4000) * 0.02
    envl = np.minimum(1, t / 0.06) * np.minimum(1, (sec - t) / 0.08)
    return (x + breath) * envl * vel


def harpsichord(m, sec, vel=0.6, seed=0):
    t = t_axis(min(sec + 0.6, 2.5))
    f0 = midi_f(m)
    x = np.zeros_like(t)
    for h in range(1, 16):
        if f0 * h > SR / 2.3:
            break
        x += np.sin(2 * np.pi * f0 * h * t * (1 + 0.0004 * h)) * (0.9 ** h) * np.exp(-t / (1.2 / (1 + h * 0.25)))
    x += hp(np.random.default_rng(seed).uniform(-1, 1, len(t)), 3000) * np.exp(-t / 0.004) * 0.3
    return fade(x * vel * 0.5, 0.0003, 0.05)


def drum(sec=0.5, vel=0.6, seed=0):
    t = t_axis(sec)
    x = np.sin(2 * np.pi * (110 * np.exp(-t / 0.08) + 60) * t) * np.exp(-t / 0.18) + lp(noise(sec, seed), 800) * np.exp(-t / 0.03) * 0.5
    return fade(x * vel, 0.0005, 0.05)


# ================================================================== Komposition

SCALES = {"major": [0, 2, 4, 5, 7, 9, 11], "minor": [0, 2, 3, 5, 7, 8, 10], "dorian": [0, 2, 3, 5, 7, 9, 10]}


def degree_to_midi(tonic, mode, deg):
    sc = SCALES[mode]
    o, i = divmod(deg, 7)
    return tonic + 12 * o + sc[i]


# Akkordfolgen als Stufen (0 = I); je Takt ein Akkord, Phrase 8 Takte
PROG_A = [0, 3, 4, 0, 0, 3, 4, 0]
PROG_B = [5, 3, 0, 4, 5, 1, 4, 0]
PROG_MIN = [0, 6, 2, 4, 0, 5, 4, 0]

STYLES = {
    # name: (tonic, mode, beats/bar, beat sec, subdivision per beat, rhythm patterns (in subdivisions), instruments)
    0: dict(name="menu", tonic=62, mode="major", meter=3, beat=60 / 72, sub=2, prog=(PROG_A, PROG_B), parts=["lute", "cello", "flute"], drum=False, seed=10),
    1: dict(name="epoch1", tonic=67, mode="major", meter=2, beat=60 / 104, sub=3, prog=(PROG_A, PROG_B), parts=["lute"], drum=True, seed=11),
    2: dict(name="epoch2", tonic=62, mode="major", meter=4, beat=60 / 112, sub=2, prog=(PROG_A, PROG_B), parts=["lute", "cello"], drum=True, seed=12),
    3: dict(name="epoch3", tonic=57, mode="dorian", meter=2, beat=60 / 96, sub=3, prog=(PROG_MIN, PROG_MIN), parts=["lute", "cello", "flute"], drum=False, seed=13),
    4: dict(name="epoch4", tonic=60, mode="major", meter=3, beat=60 / 120, sub=2, prog=(PROG_A, PROG_B), parts=["lute", "cello", "flute", "violin"], drum=False, seed=14),
    5: dict(name="epoch5", tonic=64, mode="minor", meter=2, beat=60 / 88, sub=4, prog=(PROG_MIN, [2, 5, 3, 4, 0, 3, 4, 0]), parts=["harpsichord", "lute", "cello", "flute", "violin"], drum=False, seed=15),
    6: dict(name="epoch6", tonic=62, mode="major", meter=4, beat=60 / 100, sub=2, prog=(PROG_A, PROG_B), parts=["harpsichord", "lute", "cello", "flute", "violin"], drum=True, seed=16),
}


def chord_degrees(root):
    return [root, root + 2, root + 4]


def make_phrase(st, prog, rng, motif=None):
    """Melodie (Liste von (Grad, Start in Subdivisions, Länge)) über 8 Takte mit Motivwiederholung."""
    meter, sub = st["meter"], st["sub"]
    bar_len = meter * sub
    rhythms = {
        (3, 2): [[2, 2, 2], [3, 1, 2], [2, 1, 1, 2], [4, 2]],
        (2, 3): [[2, 1, 2, 1], [3, 3], [1, 1, 1, 2, 1], [2, 1, 3]],
        (4, 2): [[1, 1, 1, 1, 2, 2], [2, 2, 2, 2], [3, 1, 2, 2], [1, 1, 2, 1, 1, 2]],
        (2, 4): [[2, 2, 2, 2], [3, 1, 4], [1, 1, 2, 2, 2], [4, 4]],
    }[(meter, sub)]
    notes = []
    prev = 7 + 2
    if motif is None:
        motif = [rng.integers(len(rhythms)), rng.integers(len(rhythms))]
    for bar, root in enumerate(prog):
        cadence = bar in (3, 7)
        rh = rhythms[motif[bar % 2]] if not cadence else ([bar_len - sub, sub] if bar == 3 else [bar_len])
        pos = bar * bar_len
        ct = [d + 7 for d in chord_degrees(root)] + [d + 14 for d in chord_degrees(root)]
        for i, L in enumerate(rh):
            if bar == 7 and i == len(rh) - 1:
                deg = 7 + 7 * (prev > 10)  # Grundton am Schluss
            elif bar == 3 and i == len(rh) - 1:
                deg = 7 + 4 + (7 if prev > 12 else 0)  # Halbschluss auf der Dominante
            elif i == 0 or L >= sub:
                deg = min(ct, key=lambda d: abs(d - prev) + (0 if d != prev else 1.5) + rng.uniform(0, 1.5))
            else:
                deg = prev + int(rng.choice([-1, 1, -1, 1, 2, -2]))
            deg = int(np.clip(deg, 5, 17))
            notes.append((deg, pos, L))
            prev = deg
            pos += L
    return notes, motif


def render_track(epoch):
    st = STYLES[epoch]
    rng = np.random.default_rng(st["seed"])
    meter, sub, beat = st["meter"], st["sub"], st["beat"]
    step = beat / sub
    bar_len = meter * sub
    progA, progB = st["prog"]
    melA, motif = make_phrase(st, progA, rng)
    melB, _ = make_phrase(st, progB, rng)
    melA2, _ = make_phrase(st, progA, rng, motif)
    # Form: A A' B B, zweimal mit wechselnder Besetzung
    sections = [(melA, progA), (melA2, progA), (melB, progB), (melB, progB)]
    total_bars = 8 * len(sections) * 2
    total = total_bars * bar_len * step
    tail = 3.0
    L = int((total + tail) * SR)
    mix = {k: np.zeros(L) for k in ("lute", "cello", "flute", "violin", "harpsichord", "drum")}

    def add(name, sig, start):
        s = int(start * SR)
        e = min(L, s + len(sig))
        mix[name][s:e] += sig[:e - s]

    parts = st["parts"]
    for rep in range(2):
        for si, (mel, prog) in enumerate(sections):
            base_bar = (rep * len(sections) + si) * 8
            t0 = base_bar * bar_len * step
            lead = "flute" if ("flute" in parts and (rep == 1 or si >= 2)) else ("violin" if "violin" in parts and si % 2 == 1 else "lute")
            for deg, pos, ln in mel:
                m = degree_to_midi(st["tonic"], st["mode"], deg)
                start = t0 + pos * step
                dur = ln * step
                if lead == "lute":
                    add("lute", pluck(m, min(2.5, dur + 0.6), 0.75, 0.6, pos), start)
                elif lead == "flute":
                    add("flute", flute(m, dur * 0.95, 0.5, pos), start)
                else:
                    add("violin", bowed(m, dur * 0.97, 0.45, 0.85, 0.007, 0.05, pos), start)
            # Begleitung: Lautenakkorde (gebrochen) bzw. Cembalo
            for bar, root in enumerate(prog):
                bt = t0 + bar * bar_len * step
                chord = [degree_to_midi(st["tonic"], st["mode"], d) - 12 for d in chord_degrees(root)]
                if "harpsichord" in parts and (rep == 1 or epoch == 6):
                    for b in range(meter):
                        for k, n in enumerate(chord):
                            add("harpsichord", harpsichord(n + (12 if k == 2 else 0), beat * 0.9, 0.5, b), bt + b * beat + k * 0.012)
                elif lead != "lute" or len(parts) == 1:
                    pattern = [0, 2, 1, 2] if meter != 3 else [0, 1, 2]
                    n_ev = meter * (2 if sub >= 2 and meter != 3 else 1)
                    for k in range(n_ev):
                        n = chord[pattern[k % len(pattern)]]
                        add("lute", pluck(n, 1.4, 0.45 if k else 0.6, 0.4, k), bt + k * (bar_len * step / n_ev))
                if "cello" in parts:
                    bass = degree_to_midi(st["tonic"], st["mode"], root) - 24
                    if epoch in (2, 6, 4):
                        for b in range(meter):
                            add("cello", bowed(bass + (7 if b % 2 else 0), beat * 0.9, 0.5, 0.5, 0.004, 0.04, b), bt + b * beat)
                    else:
                        add("cello", bowed(bass, bar_len * step * 0.98, 0.55, 0.45, 0.005, 0.15, bar), bt)
                if st["drum"]:
                    for b in range(meter):
                        add("drum", drum(0.5, 0.7 if b == 0 else 0.35, b), bt + b * beat)
    pan = {"lute": -0.25, "cello": 0.15, "flute": 0.3, "violin": -0.35, "harpsichord": 0.4, "drum": 0.0}
    gain = {"lute": 0.9, "cello": 0.55, "flute": 0.6, "violin": 0.5, "harpsichord": 0.35, "drum": 0.35}
    left = np.zeros(L)
    right = np.zeros(L)
    for k, sig in mix.items():
        if not np.any(sig):
            continue
        g = gain[k]
        p = pan[k]
        left += sig * g * math.cos((p + 1) * math.pi / 4)
        right += sig * g * math.sin((p + 1) * math.pi / 4)
    # Raumhall (synthetische Impulsantwort)
    ir_len = int(1.6 * SR)
    tt = np.arange(ir_len) / SR
    irl = lp(np.random.default_rng(1).uniform(-1, 1, ir_len), 5000) * np.exp(-tt / 0.45)
    irr = lp(np.random.default_rng(2).uniform(-1, 1, ir_len), 5000) * np.exp(-tt / 0.45)
    irl[0] = irr[0] = 0
    wet_l = fftconvolve(left, irl)[:L] * 0.06
    wet_r = fftconvolve(right, irr)[:L] * 0.06
    left += wet_l
    right += wet_r
    # Schleife: Nachklang an den Anfang falten
    n_loop = int(total * SR)
    out = np.stack([left[:n_loop].copy(), right[:n_loop].copy()])
    rest = L - n_loop
    out[0, :rest] += left[n_loop:]
    out[1, :rest] += right[n_loop:]
    out = lp(out, 9000)
    return norm(out, 0.8), total


# ================================================================== Ausgabe

def render_all():
    S = ("assets", "audio", "sfx")
    write(strike(950, 1.0, 0.5, 0.5, 1.4, 1), *S, "hammer_good_1.ogg")
    write(strike(1010, 0.9, 0.55, 0.45, 1.4, 2), *S, "hammer_good_2.ogg")
    write(strike(900, 1.1, 0.45, 0.55, 1.4, 3), *S, "hammer_good_3.ogg")
    write(strike(780, 0.5, 0.8, 0.3, 1.0, 4, 0.7), *S, "hammer_weak.ogg")
    write(norm(strike(520, 0.25, 1.4, 0.2, 0.7, 5, 0.4) * np.exp(-t_axis(0.7) / 0.15)), *S, "hammer_cold.ogg")
    x = strike(880, 0.8, 0.6, 0.4, 1.2, 6)
    s = sizzle(0.6)
    x[:len(s)] += s * 0.6
    write(norm(x), *S, "hammer_overheat.ogg")
    x = strike(1100, 1.0, 0.3, 0.6, 1.2, 7)
    s = sparks(0.9)
    x[:len(s)] += s * 0.8
    write(norm(x), *S, "hammer_weld.ogg")
    write(strike(1050, 0.4, 0.5, 0.3, 0.8, 8), *S, "hammer_weld_miss.ogg")
    write(strike(700, 0.9, 1.0, 0.4, 1.4, 9), *S, "striker.ogg")
    write(machine_hit(False, 10), *S, "machine_water.ogg")
    write(machine_hit(True, 11), *S, "machine_steam.ogg")
    write(sizzle(0.7), *S, "sizzle.ogg")
    write(sparks(1.0), *S, "sparks.ogg")
    write(quench(), *S, "quench.ogg")
    write(clatter(), *S, "ruin.ogg")
    write(coins(), *S, "coins.ogg")
    write(page(), *S, "page.ogg")
    write(bellows(), *S, "bellows.ogg")
    write(click(), *S, "click.ogg")
    write(chime(), *S, "done.ogg")
    write(norm(anvil_ring(1600, 0.3, 0.6, 0.15, 12) + hp(noise(0.3, 12), 3000) * np.exp(-t_axis(0.3) / 0.005), 0.5), *S, "move.ogg")
    A = ("assets", "audio", "ambience")
    write(ambience_fire(), *A, "fire.ogg")
    write(ambience_water(), *A, "water_wheel.ogg")
    write(ambience_steam(), *A, "steam_engine.ogg")
    for e in range(0, 7):
        y, dur = render_track(e)
        name = "menu.ogg" if e == 0 else f"epoch_{e}.ogg"
        write(y, "assets", "audio", "music", name, stereo=True, quality=3)
        print(name, round(dur, 1), "s")


if __name__ == "__main__":
    render_all()
