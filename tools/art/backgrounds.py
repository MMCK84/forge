# -*- coding: utf-8 -*-
"""Sechs Werkstatt-Hintergründe (1920×1080), je Epoche eigener Standort (Lastenheft 6.1).
Freie Flächen für Esse (links), Amboss (Mitte), Löschtrog/Maschine (rechts) bleiben erhalten."""
import math
import numpy as np
from PIL import Image
from common import Canvas, INK, PAL, vgrad, hgrad, radial, mul, rect_pts, ellipse_pts, wobble, out_path, fbm
from props import bricks

W, H = 1920, 1080
FLOOR_Y = 700


def planks(c, x, y, w, h, base, seed, vertical=True, pw=70):
    r = np.random.default_rng(seed)
    k = 0
    pos = x
    while pos < x + w:
        tone = r.uniform(0.8, 1.15)
        col = tuple(int(min(255, v * tone)) for v in base)
        if vertical:
            c.shape(rect_pts(pos, y, min(pw, x + w - pos), h), col, outline=(30, 20, 14, 255), width=2,
                    light=vgrad(y, y + h, 1.05, 0.9), noise=0.2, seed=seed + k, cell=30, wob=1.0)
        pos += pw
        k += 1


def stones(c, x, y, w, h, base, seed, sw=150, sh=80):
    r = np.random.default_rng(seed)
    yy, row = y, 0
    while yy < y + h:
        xx = x - (sw * 0.5 if row % 2 else 0) - r.uniform(0, 30)
        while xx < x + w:
            ww = sw * r.uniform(0.75, 1.25)
            tone = r.uniform(0.78, 1.12)
            col = tuple(int(min(255, v * tone)) for v in base)
            c.shape(rect_pts(xx + 3, yy + 3, ww - 6, sh - 6), col, outline=(40, 34, 28, 255), width=2,
                    light=mul(vgrad(yy, yy + sh, 1.12, 0.85)), noise=0.22, seed=int(r.integers(1e6)), cell=25, wob=3.0)
            xx += ww
        yy += sh
        row += 1


def beams(c, color=(66, 46, 32)):
    c.shape(rect_pts(0, 70, W, 60), color, light=vgrad(70, 130, 1.1, 0.6), seed=901, cell=40)
    for x in range(80, W, 420):
        c.shape([(x, 130), (x + 50, 130), (x + 50, 160), (x, 150)], tuple(int(v * 0.85) for v in color), seed=902 + x)


def window(c, x, y, w, h, scene, arched=False):
    frame = (52, 36, 26)
    c.shape(rect_pts(x - 22, y - 22, w + 44, h + 44), (86, 76, 66), light=vgrad(y, y + h, 1.1, 0.8), seed=950, width=3)
    view = Canvas(w, h)
    scene(view, w, h)
    img = view.result()
    c.img.alpha_composite(img.resize((w * 2, h * 2), Image.LANCZOS), (x * 2, y * 2))
    # Glas-Schimmer (halbtransparent)
    shine = Image.new("RGBA", c.img.size, (0, 0, 0, 0))
    m = c.mask(pts=[(x + w * 0.05, y), (x + w * 0.3, y), (x + w * 0.12, y + h), (x - w * 0.05, y + h)])
    shine.paste((255, 255, 255, 38), mask=m)
    c.img.alpha_composite(shine)
    for k in range(1, 3):
        xx = x + w * k / 3
        c.line([(xx, y), (xx, y + h)], frame + (255,), 8)
    for k in range(1, 3):
        yy = y + h * k / 3
        c.line([(x, yy), (x + w, yy)], frame + (255,), 7)
    c.line([(x, y), (x + w, y), (x + w, y + h), (x, y + h), (x, y)], frame + (255,), 14)
    c.shape(rect_pts(x - 30, y + h + 10, w + 60, 18), (96, 80, 64), light=vgrad(y + h, y + h + 30, 1.2, 0.7), seed=951)


def sky(v, w, h, top=(150, 186, 210), bottom=(214, 222, 214)):
    H2, W2 = v.img.size[1], v.img.size[0]
    t = np.linspace(0, 1, H2, dtype=np.float32)[:, None, None]
    grad = np.array(top, np.float32) * (1 - t) + np.array(bottom, np.float32) * t
    arr = np.concatenate([np.broadcast_to(grad, (H2, W2, 3)), np.full((H2, W2, 1), 255, np.float32)], axis=2)
    v.img = Image.fromarray(arr.astype(np.uint8), "RGBA")
    for k in range(3):
        cx, cy = w * (0.2 + k * 0.3), h * (0.18 + 0.07 * (k % 2))
        for j in range(3):
            v.ellipse(cx + j * 22 - 22, cy - (j % 2) * 8, 26, 14, (240, 240, 236), outline=None, noise=0.04, seed=300 + k * 3 + j, wob=0.5)


def hills(v, w, y, col, seed, amp=25):
    r = np.random.default_rng(seed)
    pts = [(-10, y + 200)]
    for k in range(0, w + 40, 30):
        pts.append((k, y - amp * math.sin(k / 70 + seed) - r.uniform(0, amp * 0.4)))
    pts.append((w + 10, y + 200))
    v.shape(pts, col, outline=None, light=vgrad(y - amp, y + 120, 1.1, 0.8), seed=seed, wob=0)


def scene_village(v, w, h):
    sky(v, w, h)
    hills(v, w, h * 0.55, (110, 140, 86), 1)
    hills(v, w, h * 0.7, (92, 128, 70), 2, 14)
    v.shape([(w * 0.62, h * 0.55), (w * 0.66, h * 0.2), (w * 0.7, h * 0.55)], (160, 150, 136), width=2, seed=5)
    v.shape(rect_pts(w * 0.6, h * 0.5, w * 0.14, h * 0.18), (170, 160, 140), width=2, seed=6)
    for k in range(3):
        v.ellipse(w * (0.12 + k * 0.12), h * 0.66, 26, 22, (66, 96, 54), width=2, seed=7 + k)


def scene_road(v, w, h):
    sky(v, w, h)
    hills(v, w, h * 0.55, (120, 138, 92), 11)
    v.shape([(w * 0.2, h + 10), (w * 0.45, h * 0.6), (w * 0.55, h * 0.6), (w * 0.9, h + 10)], (170, 150, 112), outline=None, seed=12)
    cx, cy = w * 0.55, h * 0.66
    v.shape(rect_pts(cx - 40, cy - 34, 80, 40), (110, 40, 30), width=2, seed=13)
    for dx in (-26, 26):
        v.ellipse(cx + dx, cy + 12, 14, 14, (60, 40, 26), width=2, seed=14)
    v.shape(rect_pts(w * 0.25, h * 0.68, 16, 30), (200, 196, 186), width=2, seed=15)


def scene_harbour(v, w, h):
    sky(v, w, h, (160, 190, 210), (220, 226, 226))
    v.shape(rect_pts(-5, h * 0.6, w + 10, h * 0.5), (64, 104, 132), outline=None, light=vgrad(h * 0.6, h, 1.1, 0.75), seed=21, wob=0)
    for k, xx in enumerate((0.3, 0.68)):
        x = w * xx
        v.shape([(x - 60, h * 0.6), (x + 70, h * 0.6), (x + 50, h * 0.72), (x - 44, h * 0.72)], (80, 52, 34), width=2, seed=22 + k)
        v.line([(x, h * 0.6), (x, h * 0.1)], (50, 34, 24, 255), 4)
        v.shape([(x + 4, h * 0.14), (x + 52, h * 0.48), (x + 4, h * 0.5)], (236, 228, 208), width=2, seed=24 + k)
    for k in range(3):
        x0 = w * (0.1 + k * 0.3)
        v.line([(x0, h * 0.2), (x0 + 10, h * 0.17), (x0 + 20, h * 0.2)], (60, 60, 60, 255), 2)


def scene_town(v, w, h):
    sky(v, w, h, (150, 160, 170), (200, 196, 186))
    for k in range(6):
        x = k * w / 5.5
        hh = h * (0.3 + 0.15 * ((k * 7) % 3))
        v.shape(rect_pts(x, h - hh, w / 6.5, hh), (120, 80, 64), width=2, seed=31 + k)
        v.shape([(x - 6, h - hh), (x + w / 13, h - hh - 26), (x + w / 6.5 + 6, h - hh)], (80, 60, 56), width=2, seed=41 + k)
    v.shape(rect_pts(w * 0.72, h * 0.15, 18, h * 0.5), (110, 70, 56), width=2, seed=51)
    v.ellipse(w * 0.74, h * 0.1, 30, 16, (150, 150, 150), outline=None, seed=52)


def scene_river(v, w, h):
    sky(v, w, h, (170, 180, 186), (214, 214, 204))
    hills(v, w, h * 0.5, (92, 118, 80), 61, 30)
    v.shape(rect_pts(-5, h * 0.72, w + 10, h * 0.4), (82, 120, 138), outline=None, seed=62, wob=0)
    # Eisenbrücke bei Coalbrookdale (1779)
    cx, cy = w * 0.5, h * 0.72
    v.line(ellipse_pts(cx, cy, w * 0.32, h * 0.32, 40, math.pi, math.tau), (40, 40, 44, 255), 5)
    v.line(ellipse_pts(cx, cy, w * 0.26, h * 0.24, 40, math.pi, math.tau), (40, 40, 44, 255), 3)
    v.line([(cx - w * 0.36, cy - h * 0.32), (cx + w * 0.36, cy - h * 0.32)], (40, 40, 44, 255), 5)


def scene_ironworks(v, w, h):
    sky(v, w, h, (150, 140, 130), (190, 170, 150))
    for k in range(4):
        x = w * (0.1 + k * 0.24)
        v.shape(rect_pts(x, h * 0.25, 22, h * 0.6), (90, 60, 50), width=2, seed=71 + k)
        for j in range(3):
            v.ellipse(x + 11 + j * 14, h * 0.2 - j * 18, 18 + j * 6, 12 + j * 4, (110, 104, 100), outline=None, seed=75 + j)
    v.shape(rect_pts(-5, h * 0.78, w + 10, h * 0.3), (60, 52, 46), outline=None, seed=80, wob=0)
    v.line([(0, h * 0.8), (w, h * 0.8)], (30, 30, 30, 255), 4)
    for k in range(3):
        v.shape(rect_pts(w * (0.15 + k * 0.25), h * 0.68, 50, 26), (70, 50, 36), width=2, seed=81 + k)


def wall_tools(c, x, y):
    c.shape(rect_pts(x, y, 260, 14), (70, 50, 34), seed=990)
    cols = [(70, 72, 78), (70, 72, 78), (110, 80, 52)]
    for k in range(6):
        xx = x + 20 + k * 40
        c.line([(xx, y + 14), (xx, y + 120 + (k % 3) * 18)], (90, 66, 44, 255), 6)
        c.shape(rect_pts(xx - 14, y + 116 + (k % 3) * 18, 28, 18), cols[k % 3], width=2, seed=991 + k)


def horseshoe_deco(c, x, y, s=24):
    pts = ellipse_pts(x, y, s, s * 1.15, 28, -math.pi * 0.2, math.pi * 1.2)
    c.line(pts, (30, 24, 20, 255), 13)
    c.line(pts, (78, 80, 86, 255), 8)
    c.ellipse(x, y - s * 1.3, 3, 3, (30, 24, 20), outline=None, wob=0)


def spoked_wheel(c, x, y, r):
    c.line(ellipse_pts(x, y, r, r, 48), (92, 62, 40, 255), 14)
    c.line(ellipse_pts(x, y, r + 6, r + 6, 48), (70, 72, 78, 255), 5)
    for k in range(10):
        a = k * math.tau / 10
        c.line([(x, y), (x + math.cos(a) * r, y + math.sin(a) * r)], (110, 78, 50, 255), 6)
    c.ellipse(x, y, 18, 18, (90, 62, 40), seed=995)


def barrel(c, x, y, s=1.0, seed=0):
    w, h = 110 * s, 150 * s
    c.shape([(x, y), (x + w, y), (x + w * 1.06, y + h / 2), (x + w, y + h), (x, y + h), (x - w * 0.06, y + h / 2)], (120, 84, 52),
            light=hgrad(x, x + w, 0.75, 1.15), seed=seed, cell=12)
    for t in (0.18, 0.82):
        c.line([(x - 4, y + h * t), (x + w + 4, y + h * t)], (60, 62, 66, 255), 6)


def rope_coil(c, x, y):
    for k in range(5):
        c.line(ellipse_pts(x, y - k * 10, 70 - k * 6, 22 - k * 1.5, 40), (176, 146, 96, 255), 9)
        c.line(ellipse_pts(x, y - k * 10, 70 - k * 6, 22 - k * 1.5, 40), (120, 96, 60, 255), 2)


def lighting(img, epoch):
    a = np.asarray(img, np.float32)
    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)
    fx, fy = 600, 540
    d = np.sqrt((xx - fx) ** 2 + ((yy - fy) * 1.3) ** 2)
    warm = np.clip(1 - d / 1100, 0, 1) ** 1.6
    base = 0.55 + 0.5 * warm
    vign = 1 - 0.35 * np.clip((np.sqrt(((xx - W / 2) / W) ** 2 + ((yy - H / 2) / H) ** 2) - 0.3) / 0.5, 0, 1)
    f = base * vign
    floor = np.clip((yy - FLOOR_Y) / 40.0, 0, 1)
    depth = 0.62 + 0.18 * np.clip((yy - FLOOR_Y) / (H - FLOOR_Y), 0, 1)
    f = f * (1 - floor) + f * depth * floor
    shadow = np.clip(1 - (yy - FLOOR_Y) / 60.0, 0, 1) * floor  # Kontaktschatten an der Wand
    f = f * (1 - 0.35 * shadow)
    a[..., 0] = a[..., 0] * f + 60 * warm
    a[..., 1] = a[..., 1] * f + 26 * warm
    a[..., 2] = a[..., 2] * f * 0.92
    grain = fbm(W // 2, H // 2, 3, 2, 5 + epoch)
    grain = np.asarray(Image.fromarray((grain * 255).astype(np.uint8)).resize((W, H)), np.float32) / 255.0
    a[..., :3] *= (0.97 + grain[..., None] * 0.06)
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")


def background(epoch):
    c = Canvas(W, H, (40, 30, 22, 255))
    wall_col = {1: (150, 128, 100), 2: (128, 116, 100), 3: (116, 116, 112), 4: (150, 84, 62), 5: (140, 78, 58), 6: (120, 70, 56)}[epoch]
    if epoch == 1:
        c.shape(rect_pts(0, 0, W, FLOOR_Y), (196, 178, 146), outline=None, light=vgrad(0, FLOOR_Y, 0.9, 1.05), noise=0.12, seed=1, wob=0, cell=80)
        for x in range(0, W, 300):
            c.shape(rect_pts(x, 0, 34, FLOOR_Y), (86, 60, 40), seed=10 + x, cell=20)
        for y in (330,):
            c.shape(rect_pts(0, y, W, 30), (86, 60, 40), seed=20, cell=20)
        for x in range(0, W, 600):
            c.line([(x + 34, 360), (x + 300, FLOOR_Y)], (86, 60, 40, 255), 26)
    elif epoch == 2:
        stones(c, 0, 0, W, 360, wall_col, 2)
        planks(c, 0, 360, W, FLOOR_Y - 360, (104, 76, 52), 3)
    elif epoch == 3:
        stones(c, 0, 0, W, FLOOR_Y, wall_col, 4, 190, 96)
    elif epoch in (4, 5, 6):
        bricks(c, 0, 0, W, FLOOR_Y, 80 if epoch == 4 else 64, 34 if epoch == 4 else 28, wall_col, 5 + epoch)
        if epoch == 4:
            c.shape(rect_pts(0, 420, W, FLOOR_Y - 420), (200, 188, 160), outline=INK, width=2, light=vgrad(420, FLOOR_Y, 1.0, 0.85), seed=40, wob=0)
    beams(c, (70, 48, 32) if epoch < 6 else (54, 56, 62))
    # Boden
    if epoch == 1:
        c.shape(rect_pts(0, FLOOR_Y, W, H - FLOOR_Y), (92, 72, 52), outline=None, light=vgrad(FLOOR_Y, H, 1.0, 0.7), noise=0.25, seed=50, wob=0, cell=30)
    elif epoch in (2, 3):
        stones(c, 0, FLOOR_Y, W, H - FLOOR_Y, (110, 100, 88), 51, 220, 70)
    else:
        stones(c, 0, FLOOR_Y, W, H - FLOOR_Y, (96, 90, 84) if epoch == 6 else (112, 74, 58), 52, 260, 64)
    c.shape(rect_pts(0, FLOOR_Y - 6, W, 12), (50, 36, 26), outline=None, seed=53, wob=0)
    r = np.random.default_rng(epoch)
    for k in range(60):  # Zunder, Kohlenstaub, Späne
        x, y = r.uniform(0, W), r.uniform(FLOOR_Y + 20, H - 10)
        rr = r.uniform(2, 7)
        c.ellipse(x, y, rr * 1.6, rr, (34, 28, 24), outline=None, noise=0, wob=0)
    if epoch == 1:
        for k in range(40):
            x, y = r.uniform(1300, 1900), r.uniform(FLOOR_Y + 30, FLOOR_Y + 200)
            c.line([(x, y), (x + r.uniform(-30, 30), y + r.uniform(-6, 6))], (196, 170, 96, 200), 2)
    # Wassereimer und Schrottkiste
    c.shape([(70, 860), (150, 860), (140, 960), (80, 960)], (104, 74, 48), light=hgrad(70, 150, 0.8, 1.15), seed=55, cell=12)
    c.line([(68, 880), (152, 880)], (60, 62, 66, 255), 5)
    c.line([(72, 940), (148, 940)], (60, 62, 66, 255), 5)
    c.line(ellipse_pts(110, 860, 42, 40, 20, math.pi, math.tau), (60, 62, 66, 255), 3)
    # Fenster
    scenes = {1: scene_village, 2: scene_road, 3: scene_harbour, 4: scene_town, 5: scene_river, 6: scene_ironworks}
    window(c, 1100, 150, 300 if epoch < 5 else 340, 200, scenes[epoch])
    # Epochen-Details
    if epoch <= 4:
        wall_tools(c, 1580, 180)
    if epoch == 1:
        for k in range(4):
            horseshoe_deco(c, 1000, 200 + k * 70)
        barrel(c, 1790, 560, 1.0, 61)
    elif epoch == 2:
        spoked_wheel(c, 1800, 560, 120)
        for k in range(3):
            horseshoe_deco(c, 1010, 210 + k * 70)
        c.shape(rect_pts(1450, 120, 100, 60), (47, 79, 122), seed=62)
    elif epoch == 3:
        rope_coil(c, 1800, 760)
        c.line([(1020, 160), (1020, 420)], (60, 62, 68, 255), 14)
        c.line(ellipse_pts(1020, 330, 70, 70, 24, 0.2, math.pi - 0.2), (60, 62, 68, 255), 14)
        c.line([(980, 190), (1060, 190)], (60, 62, 68, 255), 10)
    elif epoch == 4:
        for k, col in enumerate([(120, 60, 80), (60, 90, 120), (140, 120, 60)]):
            c.shape(rect_pts(1600 + k * 90, 360, 80, 120), col, light=hgrad(1600 + k * 90, 1680 + k * 90, 0.8, 1.15), seed=70 + k)
        barrel(c, 1820, 560, 0.9, 72)
    elif epoch == 5:
        c.line(ellipse_pts(1000, 300, 80, 80, 40), (96, 66, 42, 255), 16)
        for k in range(12):
            a = k * math.tau / 12
            c.shape(rect_pts(1000 + math.cos(a) * 88 - 8, 300 + math.sin(a) * 88 - 8, 16, 16), (110, 78, 50), width=2, seed=80 + k)
    elif epoch == 6:
        for x in (60, 1000, 1880):
            c.shape(rect_pts(x - 22, 130, 44, FLOOR_Y - 130), (60, 62, 68), light=hgrad(x - 22, x + 22, 0.7, 1.25), seed=90 + x)
            c.shape(rect_pts(x - 34, FLOOR_Y - 40, 68, 40), (70, 72, 78), seed=91 + x)
        c.line([(1480, 140), (1480, 260), (1560, 260)], (80, 82, 88, 255), 18)
    img = c.result()
    return lighting(img, epoch).convert("RGB")


def render_all():
    paths = []
    for e in range(1, 7):
        p = out_path("assets", "sprites", "environment", f"background_{e}.jpg")
        background(e).save(p, quality=88)
        paths.append(p)
    return paths


if __name__ == "__main__":
    for p in render_all():
        print(p)
