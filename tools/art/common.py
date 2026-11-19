# -*- coding: utf-8 -*-
"""Gemeinsame Zeichenwerkzeuge für den handgezeichneten Look (Lastenheft 6.1):
wackelnde Tuschekonturen, gemalte Verläufe, Papier-/Holz-/Steinstrukturen.
Alles wird mit 2-facher Überabtastung gezeichnet und danach verkleinert."""
import math
import os
import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageChops

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SS = 2  # Überabtastung

INK = (42, 29, 20, 255)
PAL = {
    "parchment": (233, 220, 192), "parchment_dark": (214, 195, 156),
    "brass": (176, 141, 87), "brass_light": (217, 183, 122),
    "wood": (59, 42, 30), "wood_mid": (98, 68, 44), "wood_light": (138, 100, 64),
    "leather": (107, 74, 47), "iron": (60, 63, 69), "iron_light": (109, 114, 123),
    "stone": (122, 112, 98), "brick": (150, 70, 48), "clay": (140, 98, 64),
}


def out_path(*parts):
    p = os.path.join(ROOT, *parts)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    return p


def rng(seed):
    return np.random.default_rng(seed)


# ------------------------------------------------------------------ Rauschen

def value_noise(w, h, cell, seed):
    r = rng(seed)
    gw, gh = int(w / cell) + 3, int(h / cell) + 3
    grid = r.random((gh, gw)).astype(np.float32)
    img = Image.fromarray((grid * 255).astype(np.uint8), "L").resize((int(gw * cell), int(gh * cell)), Image.BICUBIC)
    return np.asarray(img, dtype=np.float32)[:h, :w] / 255.0


def fbm(w, h, cell=64, octaves=4, seed=1, persistence=0.5):
    total = np.zeros((h, w), np.float32)
    amp, norm = 1.0, 0.0
    for o in range(octaves):
        total += value_noise(w, h, max(2, cell / (2 ** o)), seed + o * 101) * amp
        norm += amp
        amp *= persistence
    return total / norm


# ------------------------------------------------------------------ Geometrie

def wobble(points, amp=2.0, seed=0, step=12.0, closed=True):
    """Unterteilt einen Linienzug und verschiebt die Punkte leicht (Handzeichnung)."""
    r = rng(seed)
    pts = list(points)
    if closed:
        pts = pts + [pts[0]]
    out = []
    phase = r.random() * 10
    for i in range(len(pts) - 1):
        (x0, y0), (x1, y1) = pts[i], pts[i + 1]
        n = max(1, int(math.hypot(x1 - x0, y1 - y0) / step))
        for k in range(n):
            t = k / n
            x, y = x0 + (x1 - x0) * t, y0 + (y1 - y0) * t
            d = len(out) * 0.35 + phase
            out.append((x + amp * math.sin(d * 1.3) * r.uniform(0.6, 1.0), y + amp * math.cos(d * 0.9) * r.uniform(0.6, 1.0)))
    if not closed:
        out.append(pts[-1])
    return out


def ellipse_pts(cx, cy, rx, ry, n=48, a0=0.0, a1=math.tau):
    return [(cx + rx * math.cos(a0 + (a1 - a0) * i / n), cy + ry * math.sin(a0 + (a1 - a0) * i / n)) for i in range(n + 1)]


def rect_pts(x, y, w, h):
    return [(x, y), (x + w, y), (x + w, y + h), (x, y + h)]


def scale_pts(pts, s=SS):
    return [(x * s, y * s) for x, y in pts]


# ------------------------------------------------------------------ Zeichnen

class Canvas:
    """RGBA-Zeichenfläche in Zielgröße; intern SS-fach aufgelöst."""

    def __init__(self, w, h, bg=(0, 0, 0, 0)):
        self.w, self.h = w, h
        self.img = Image.new("RGBA", (w * SS, h * SS), bg)

    def mask(self, pts=None, ellipse=None, line=None, width=0):
        m = Image.new("L", self.img.size, 0)
        d = ImageDraw.Draw(m)
        if pts is not None:
            d.polygon(scale_pts(pts), fill=255)
        if ellipse is not None:
            x0, y0, x1, y1 = ellipse
            d.ellipse([x0 * SS, y0 * SS, x1 * SS, y1 * SS], fill=255)
        if line is not None:
            d.line(scale_pts(line), fill=255, width=int(width * SS), joint="curve")
        return m

    def paint(self, mask, color, light=None, noise=0.12, seed=0, cell=40, grain=0.0):
        """Füllt `mask` mit Farbe, optional Lichtverlauf (Funktion x,y→Faktor) und Malstruktur."""
        bbox = mask.getbbox()
        if bbox is None:
            return
        x0, y0, x1, y1 = bbox
        W, H = x1 - x0, y1 - y0
        base = np.zeros((H, W, 3), np.float32)
        base[:] = np.array(color[:3], np.float32)
        f = np.ones((H, W), np.float32)
        if light is not None:
            yy, xx = np.mgrid[y0:y1, x0:x1].astype(np.float32)
            f = np.broadcast_to(np.asarray(light(xx / SS, yy / SS), np.float32), (H, W)).copy()
        if noise > 0:
            f = f * (1.0 + (fbm(W, H, cell * SS, 4, seed) - 0.5) * 2 * noise)
        if grain > 0:
            f = f * (1.0 + (rng(seed + 7).random((H, W)).astype(np.float32) - 0.5) * grain)
        rgb = np.clip(base * f[..., None], 0, 255).astype(np.uint8)
        layer = Image.fromarray(rgb, "RGB").convert("RGBA")
        layer.putalpha(mask.crop(bbox))
        self.img.alpha_composite(layer, (x0, y0))

    def shape(self, pts, color, outline=INK, width=3.0, light=None, noise=0.12, seed=0, wob=1.6, cell=40, grain=0.0):
        p = wobble(pts, wob, seed) if wob > 0 else list(pts)
        self.paint(self.mask(pts=p), color, light, noise, seed, cell, grain)
        if outline is not None and width > 0:
            self.line(p + [p[0]], outline, width)
        return p

    def ellipse(self, cx, cy, rx, ry, color, outline=INK, width=3.0, light=None, noise=0.1, seed=0, wob=1.2):
        return self.shape(ellipse_pts(cx, cy, rx, ry), color, outline, width, light, noise, seed, wob)

    def line(self, pts, color=INK, width=3.0, wob=0.0, seed=0):
        if wob > 0:
            pts = wobble(pts, wob, seed, closed=False)
        d = ImageDraw.Draw(self.img)
        d.line(scale_pts(pts), fill=tuple(color), width=max(1, int(width * SS)), joint="curve")
        r = width * SS / 2
        for x, y in (pts[0], pts[-1]):
            d.ellipse([x * SS - r, y * SS - r, x * SS + r, y * SS + r], fill=tuple(color))

    def glow(self, cx, cy, radius, color, strength=0.6):
        W, H = self.img.size
        yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
        dist = np.sqrt((xx / SS - cx) ** 2 + (yy / SS - cy) ** 2) / radius
        a = np.clip(1 - dist, 0, 1) ** 2 * strength
        layer = np.zeros((H, W, 4), np.uint8)
        layer[..., :3] = color[:3]
        layer[..., 3] = (a * 255).astype(np.uint8)
        self.img = Image.alpha_composite(self.img, Image.fromarray(layer, "RGBA"))

    def hatch(self, mask, spacing=7, angle=45, color=(0, 0, 0, 60), width=1.2, seed=0):
        """Schraffur innerhalb einer Maske (Schatten im Kupferstich-Stil)."""
        W, H = self.img.size
        layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        d = ImageDraw.Draw(layer)
        r = rng(seed)
        a = math.radians(angle)
        dx, dy = math.cos(a), math.sin(a)
        L = W + H
        k = -L
        while k < L:
            ox, oy = -dy * k, dx * k
            j = r.uniform(-1, 1) * SS
            d.line([(ox - dx * L + j, oy - dy * L), (ox + dx * L + j, oy + dy * L)], fill=color, width=max(1, int(width * SS)))
            k += spacing * SS * r.uniform(0.85, 1.15)
        layer.putalpha(ImageChops.multiply(layer.getchannel("A"), mask))
        self.img = Image.alpha_composite(self.img, layer)

    def paste(self, other, x, y):
        self.img.alpha_composite(other.img, (int(x * SS), int(y * SS)))

    def result(self):
        return self.img.resize((self.w, self.h), Image.LANCZOS)

    def save(self, *parts):
        p = out_path(*parts)
        self.result().save(p, optimize=True)
        return p


# ------------------------------------------------------------------ Licht

def vgrad(y0, y1, a, b):
    return lambda x, y: a + (b - a) * np.clip((y - y0) / max(1e-6, y1 - y0), 0, 1)


def hgrad(x0, x1, a, b):
    return lambda x, y: a + (b - a) * np.clip((x - x0) / max(1e-6, x1 - x0), 0, 1)


def radial(cx, cy, r, a, b):
    return lambda x, y: a + (b - a) * np.clip(np.sqrt((x - cx) ** 2 + (y - cy) ** 2) / r, 0, 1)


def mul(*fs):
    def f(x, y):
        out = 1.0
        for g in fs:
            out = out * g(x, y)
        return out
    return f


def paper_texture(w, h, seed=3, base=(233, 220, 192)):
    n = fbm(w, h, 120, 5, seed)
    fine = rng(seed).random((h, w)).astype(np.float32)
    f = 0.9 + (n - 0.5) * 0.22 + (fine - 0.5) * 0.05
    yy, xx = np.mgrid[0:h, 0:w].astype(np.float32)
    edge = np.minimum(np.minimum(xx, w - 1 - xx), np.minimum(yy, h - 1 - yy))
    f *= 0.82 + 0.18 * np.clip(edge / 40.0, 0, 1)
    rgb = np.clip(np.array(base, np.float32) * f[..., None], 0, 255).astype(np.uint8)
    return Image.fromarray(rgb, "RGB").convert("RGBA")
