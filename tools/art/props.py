# -*- coding: utf-8 -*-
"""Werkstatt-Requisiten: Essen (4 Stufen), Blasebalg, Glut, Amboss, Hammer, Löschtrog, Schwanzhammer."""
import math
import numpy as np
from common import Canvas, INK, PAL, vgrad, hgrad, radial, mul, rect_pts, ellipse_pts, wobble, SS
from PIL import Image, ImageDraw

# Esse: Zeichenfläche 1000×820, lokaler Ursprung der Godot-ForgeView bei (160, 160)
FORGE_OFF = (160, 160)


def _o(pts, off=FORGE_OFF):
    return [(x + off[0], y + off[1]) for x, y in pts]


def bricks(c, x, y, w, h, bw, bh, base, seed, mortar=(70, 55, 45, 255)):
    c.shape(rect_pts(x, y, w, h), mortar[:3], outline=None, noise=0.15, seed=seed, wob=0)
    r = np.random.default_rng(seed)
    row = 0
    yy = y
    while yy < y + h - 2:
        xx = x - (bw / 2 if row % 2 else 0)
        while xx < x + w - 2:
            x0, x1 = max(x, xx + 2), min(x + w, xx + bw - 2)
            y1 = min(y + h, yy + bh - 2)
            if x1 - x0 > 6:
                tone = r.uniform(0.82, 1.12)
                col = tuple(int(min(255, v * tone)) for v in base)
                c.shape(rect_pts(x0, yy + 2, x1 - x0, y1 - yy - 2), col, outline=(50, 35, 28, 255), width=1.2,
                        light=vgrad(yy, y1, 1.08, 0.88), noise=0.18, seed=int(r.integers(1e6)), wob=0.8, cell=12)
            xx += bw
        yy += bh
        row += 1


def forge_body(tier):
    c = Canvas(1000, 820)
    seed = 100 + tier
    hood_col = {1: (96, 70, 48), 2: (128, 62, 44), 3: (112, 98, 86), 4: (58, 60, 66)}[tier]
    body_col = {1: PAL["clay"], 2: PAL["brick"], 3: (128, 116, 100), 4: (66, 68, 74)}[tier]
    # Schornstein und Rauchfang
    c.shape(_o(rect_pts(380, -150, 120, 200)), tuple(int(v * 0.8) for v in hood_col), light=hgrad(540, 660, 0.8, 1.1), seed=seed)
    hood = _o([(200, 40), (680, 40), (760, 250), (120, 250)])
    c.shape(hood, hood_col, light=mul(vgrad(200, 410, 0.75, 1.15), hgrad(280, 920, 0.95, 1.05)), seed=seed + 1, width=3.5)
    if tier in (2, 3):
        m = c.mask(pts=hood)
        tmp = Canvas(1000, 820)
        bricks(tmp, 270, 190, 650, 230, 54, 26, hood_col, seed + 2)
        a = tmp.img.getchannel("A")
        from PIL import ImageChops
        tmp.img.putalpha(ImageChops.multiply(a, m))
        c.img.alpha_composite(tmp.img)
        c.line(wobble(hood, 1.5, seed + 1) + [hood[0]], INK, 3.5)
    if tier == 4:
        for i in range(7):
            t = (i + 0.5) / 7
            for yy, x0, x1 in ((214, 362, 838), (398, 294, 906)):
                c.ellipse(x0 + (x1 - x0) * t, yy, 5, 5, (120, 124, 130), width=1.2, wob=0)
    # Rauchfang-Kante (Balken)
    c.shape(_o(rect_pts(110, 240, 660, 22)), (74, 52, 36), light=vgrad(400, 422, 1.2, 0.7), seed=seed + 3)
    # Herd
    body = _o([(100, 335), (780, 335), (785, 565), (95, 565)])
    if tier == 1:
        body = _o(wobble([(105, 345), (220, 330), (440, 326), (660, 330), (775, 345), (790, 565), (90, 565)], 5, seed))
    c.shape(body, body_col, light=mul(vgrad(490, 725, 1.1, 0.72), radial(600, 560, 520, 1.15, 0.85)), seed=seed + 4, cell=30, width=3.5)
    if tier in (2, 3):
        m = c.mask(pts=body)
        tmp = Canvas(1000, 820)
        bricks(tmp, 255, 495, 690, 230, 60, 28, body_col, seed + 5)
        from PIL import ImageChops
        tmp.img.putalpha(ImageChops.multiply(tmp.img.getchannel("A"), m))
        c.img.alpha_composite(tmp.img)
        c.line(wobble(body, 1.5, seed + 4) + [body[0]], INK, 3.5)
    if tier == 1:
        r = np.random.default_rng(seed)
        for k in range(40):
            x, y = r.uniform(280, 920), r.uniform(530, 715)
            c.line([(x, y), (x + r.uniform(8, 22), y + r.uniform(-3, 3))], (90, 62, 40, 120), 1.5)
    if tier == 4:
        for k in range(9):
            for yy in (512, 708):
                c.ellipse(285 + k * 78, yy, 6, 6, (130, 134, 140), width=1.2, wob=0)
        c.line(_o([(100, 450), (780, 450)]), (40, 42, 46, 255), 3)
    # Herdplatte und Glutmulde
    c.shape(_o(rect_pts(95, 325, 690, 24)), tuple(int(v * 0.85) for v in body_col), light=vgrad(485, 509, 1.25, 0.8), seed=seed + 6)
    c.shape(_o([(150, 352), (730, 352), (722, 438), (158, 438)]), (34, 18, 12), light=vgrad(512, 598, 0.6, 1.3), noise=0.2, seed=seed + 7)
    # Werkzeug: Zange und Schürhaken an der Seite
    c.line(_o([(760, 300), (830, 520)]), (70, 72, 78, 255), 7, wob=1, seed=seed)
    c.line(_o([(775, 300), (850, 515)]), (70, 72, 78, 255), 6, wob=1, seed=seed + 1)
    c.ellipse(_o([(762, 296)])[0][0], _o([(762, 296)])[0][1], 9, 9, (80, 82, 88), width=2)
    return c


def coals():
    """Glutbett mit Kohlen (wird im Spiel flackernd eingefärbt). 600×110."""
    c = Canvas(600, 110)
    r = np.random.default_rng(7)
    c.shape(wobble([(6, 40), (594, 40), (590, 100), (10, 100)], 4, 3), (52, 20, 10), outline=None, noise=0.35, seed=5, wob=0, cell=10)
    for k in range(110):
        x, y = r.uniform(18, 582), r.uniform(34, 92)
        rr = r.uniform(8, 17)
        hot = r.uniform(0.0, 1.0)
        col = (int(60 + 195 * hot), int(18 + 120 * hot ** 2), int(8 + 40 * hot ** 3))
        pts = wobble(ellipse_pts(x, y, rr, rr * 0.75, 12), 2.0, k)
        c.shape(pts, col, outline=(25, 10, 6, 255), width=1.6, light=radial(x - rr * 0.3, y - rr * 0.3, rr * 1.3, 1.35, 0.7), noise=0.25, seed=k, wob=0)
    return c


def fire_glow():
    c = Canvas(760, 420)
    c.glow(380, 230, 380, (255, 150, 60), 0.55)
    c.glow(380, 240, 220, (255, 200, 90), 0.45)
    return c


def bellows():
    """Lederblasebalg mit Holzbrettern, Düse nach rechts. 260×140 (Pivot links-mittig)."""
    c = Canvas(260, 140)
    c.shape([(12, 22), (150, 50), (150, 90), (12, 118)], PAL["leather"], light=vgrad(20, 120, 1.15, 0.7), seed=31, cell=14)
    for k in range(4):
        x = 40 + k * 28
        c.line([(x, 28 + k * 6), (x, 112 - k * 6)], (70, 46, 28, 255), 2.2, wob=0.6, seed=k)
    c.shape([(6, 14), (156, 44), (156, 52), (6, 28)], PAL["wood_light"], light=hgrad(0, 160, 1.1, 0.85), seed=32, width=2.5)
    c.shape([(6, 112), (156, 88), (156, 96), (6, 126)], PAL["wood_mid"], seed=33, width=2.5)
    c.shape([(150, 60), (250, 64), (250, 76), (150, 80)], (88, 90, 96), light=vgrad(60, 80, 1.3, 0.7), seed=34, width=2.5)
    c.line([(6, 20), (-0, 8)], PAL["wood"] + (255,), 6)
    return c


def blower():
    """Zylindergebläse der Koks-Esse. 220×260."""
    c = Canvas(220, 260)
    c.shape(rect_pts(30, 40, 120, 190), (70, 72, 78), light=hgrad(30, 150, 0.8, 1.2), seed=41)
    for y in (60, 130, 200):
        c.shape(rect_pts(24, y, 132, 14), (96, 100, 106), light=vgrad(y, y + 14, 1.3, 0.75), seed=42 + y, width=2)
    c.ellipse(90, 40, 60, 16, (110, 114, 120), seed=45)
    c.shape([(150, 150), (215, 120), (215, 140), (150, 172)], (80, 82, 88), seed=46)
    c.line([(90, 40), (90, 2)], (60, 62, 66, 255), 10)
    return c


def anvil():
    """Amboss auf Holzklotz, 560×450 (lokaler Ursprung der AnvilView bei (10, 10))."""
    c = Canvas(560, 450)
    o = (10, 10)
    cx = 270 + o[0]
    # Holzklotz mit Jahresringen
    stump = [(cx - 115, 262 + o[1]), (cx + 115, 262 + o[1]), (cx + 122, 425 + o[1]), (cx - 122, 425 + o[1])]
    c.shape(stump, (104, 72, 46), light=hgrad(cx - 120, cx + 120, 0.8, 1.15), seed=51, cell=10)
    for k in range(7):
        x = cx - 95 + k * 32
        c.line([(x, 268 + o[1]), (x + 4, 420 + o[1])], (70, 46, 28, 160), 1.6, wob=1.5, seed=k)
    c.ellipse(cx, 263 + o[1], 115, 12, (140, 102, 66), seed=52, width=2.5)
    iron = PAL["iron"]
    li = mul(vgrad(150, 270, 1.35, 0.75), hgrad(cx - 150, cx + 270, 0.9, 1.1))
    # Fuß
    c.shape([(cx - 125, 262 + o[1]), (cx + 125, 262 + o[1]), (cx + 82, 222 + o[1]), (cx - 82, 222 + o[1])], iron, light=li, seed=53)
    # Taille
    c.shape([(cx - 58, 226 + o[1]), (cx + 58, 226 + o[1]), (cx + 48, 196 + o[1]), (cx - 48, 196 + o[1])], iron, light=li, seed=54)
    # Körper mit Horn
    body = [(cx - 155, 158 + o[1]), (cx + 152, 158 + o[1]), (cx + 205, 163 + o[1]), (cx + 272, 172 + o[1]), (cx + 205, 186 + o[1]), (cx + 150, 200 + o[1]),
            (cx + 110, 206 + o[1]), (cx - 120, 206 + o[1]), (cx - 150, 190 + o[1])]
    c.shape(body, iron, light=li, seed=55, width=3.5)
    # Bahn (blank)
    c.shape([(cx - 152, 152 + o[1]), (cx + 150, 152 + o[1]), (cx + 150, 164 + o[1]), (cx - 152, 164 + o[1])], (150, 156, 164), light=hgrad(cx - 150, cx + 150, 0.85, 1.2), seed=56, width=2.5)
    c.shape(rect_pts(cx - 128, 168 + o[1], 14, 10), (20, 20, 24), outline=None, seed=57, wob=0)
    c.ellipse(cx - 92, 173 + o[1], 5, 5, (20, 20, 24), outline=None, wob=0)
    m = c.mask(pts=body)
    c.hatch(m, 9, 60, (0, 0, 0, 45), 1.0, 58)
    return c


def hand_hammer():
    """Handhammer, Stiel nach rechts, 220×90. Pivot am Stielende (rechts)."""
    c = Canvas(220, 90)
    c.shape([(50, 40), (214, 34), (216, 50), (50, 52)], (150, 108, 64), light=vgrad(34, 52, 1.2, 0.75), seed=61, width=2.5)
    c.shape([(10, 14), (70, 14), (74, 76), (6, 76)], PAL["iron"], light=mul(hgrad(6, 74, 1.3, 0.8), vgrad(14, 76, 1.1, 0.85)), seed=62, width=3)
    c.shape([(6, 66), (74, 66), (74, 78), (6, 78)], (150, 156, 164), seed=63, width=2)
    return c


def trough():
    """Löschtrog aus Holz mit Wasser, 340×190 (Ursprung (10,10))."""
    c = Canvas(340, 190)
    o = 10
    c.shape([(10 + o, 60 + o), (310 + o, 60 + o), (285 + o, 165 + o), (35 + o, 165 + o)], PAL["wood_mid"], light=vgrad(60, 175, 1.1, 0.7), seed=71, cell=12)
    for k in range(3):
        y = 92 + k * 28 + o
        c.line([(22 + o + k * 6, y), (298 + o - k * 6, y)], (62, 42, 28, 255), 2.2, wob=1, seed=k)
    for x in (50 + o, 270 + o):
        c.shape(rect_pts(x - 7, 58 + o, 14, 112), (78, 80, 86), light=hgrad(x - 7, x + 7, 1.3, 0.8), seed=72 + x, width=2)
    c.shape([(22 + o, 64 + o), (298 + o, 64 + o), (296 + o, 84 + o), (24 + o, 84 + o)], (60, 96, 112), light=hgrad(20, 300, 0.85, 1.2), noise=0.2, seed=73, width=2)
    c.line([(60 + o, 72 + o), (120 + o, 70 + o)], (200, 225, 235, 180), 2)
    c.line([(170 + o, 75 + o), (250 + o, 73 + o)], (200, 225, 235, 150), 2)
    c.shape([(4 + o, 54 + o), (316 + o, 54 + o), (312 + o, 64 + o), (8 + o, 64 + o)], PAL["wood_light"], seed=74, width=2.5)
    return c


def helve_post():
    c = Canvas(110, 340)
    c.shape(rect_pts(30, 10, 50, 320), PAL["wood_mid"], light=hgrad(30, 80, 0.8, 1.15), seed=81, cell=10)
    c.shape(rect_pts(10, 300, 90, 30), PAL["wood"], seed=82)
    for y in (40, 160, 280):
        c.shape(rect_pts(26, y, 58, 10), (80, 82, 88), seed=83 + y, width=2)
    c.ellipse(55, 20, 22, 22, (110, 114, 120), seed=84)
    return c


def helve_beam():
    """Helmbalken, 520×60, Pivot links bei (30,30), Kopf rechts."""
    c = Canvas(520, 60)
    c.shape([(10, 14), (510, 18), (510, 44), (10, 48)], (118, 84, 54), light=vgrad(14, 48, 1.2, 0.75), seed=91, cell=10)
    for x in (60, 200, 340, 470):
        c.shape(rect_pts(x, 10, 14, 40), (76, 78, 84), light=vgrad(10, 50, 1.3, 0.8), seed=92 + x, width=2)
    return c


def helve_head():
    c = Canvas(120, 100)
    c.shape([(10, 8), (110, 8), (104, 90), (16, 90)], PAL["iron"], light=mul(hgrad(10, 110, 1.25, 0.8), vgrad(8, 90, 1.1, 0.85)), seed=95, width=3)
    c.shape(rect_pts(14, 80, 92, 12), (150, 156, 164), seed=96, width=2)
    return c


def water_wheel():
    c = Canvas(280, 280)
    cx = cy = 140
    for k in range(8):
        a = k * math.tau / 8
        c.line([(cx, cy), (cx + math.cos(a) * 118, cy + math.sin(a) * 118)], (96, 66, 42, 255), 9, wob=0.8, seed=k)
    c.line(ellipse_pts(cx, cy, 118, 118, 64), (96, 66, 42, 255), 13)
    c.line(ellipse_pts(cx, cy, 104, 104, 64), (70, 48, 30, 255), 4)
    for k in range(16):
        a = k * math.tau / 16
        x, y = cx + math.cos(a) * 124, cy + math.sin(a) * 124
        pts = [(x + math.cos(a + 1.3) * 16, y + math.sin(a + 1.3) * 16), (x + math.cos(a - 1.3) * 16, y + math.sin(a - 1.3) * 16),
               (x + math.cos(a - 1.3) * 16 + math.cos(a) * 14, y + math.sin(a - 1.3) * 16 + math.sin(a) * 14),
               (x + math.cos(a + 1.3) * 16 + math.cos(a) * 14, y + math.sin(a + 1.3) * 16 + math.sin(a) * 14)]
        c.shape(pts, (118, 84, 54), seed=200 + k, width=2, wob=0.5)
    c.ellipse(cx, cy, 22, 22, (90, 92, 98), seed=99)
    return c


def flywheel():
    c = Canvas(180, 180)
    cx = cy = 90
    c.line(ellipse_pts(cx, cy, 78, 78, 64), (52, 54, 60, 255), 14)
    for k in range(6):
        a = k * math.tau / 6
        c.line([(cx, cy), (cx + math.cos(a) * 74, cy + math.sin(a) * 74)], (60, 62, 68, 255), 7)
    c.ellipse(cx, cy, 16, 16, (100, 104, 110), seed=101)
    return c


def engine():
    """Dampfmaschine (Zylinder, Gestell, Kessel-Andeutung), 300×330."""
    c = Canvas(300, 330)
    c.shape(rect_pts(150, 80, 26, 250), PAL["wood_mid"], seed=111)
    c.shape(rect_pts(20, 150, 80, 170), (66, 68, 74), light=hgrad(20, 100, 0.8, 1.25), seed=112)
    for y in (160, 230, 300):
        c.shape(rect_pts(14, y, 92, 12), (100, 104, 110), seed=113 + y, width=2)
    c.ellipse(60, 150, 40, 10, (110, 114, 120), seed=114)
    c.line([(60, 150), (60, 95)], (80, 82, 88, 255), 7)
    c.shape([(190, 220), (290, 220), (290, 330), (190, 330)], (120, 64, 44), light=vgrad(220, 330, 1.1, 0.8), seed=115)
    c.line([(240, 220), (240, 120)], (60, 62, 66, 255), 12)
    return c


def engine_beam():
    """Balancier, 260×40, Pivot Mitte."""
    c = Canvas(260, 40)
    c.shape([(6, 12), (254, 12), (254, 28), (6, 28)], (60, 62, 68), light=vgrad(12, 28, 1.3, 0.75), seed=121)
    c.ellipse(130, 20, 10, 10, (110, 114, 120), seed=122)
    return c


def render_all():
    for t in (1, 2, 3, 4):
        forge_body(t).save("assets", "sprites", "environment", f"forge_{t}.png")
    coals().save("assets", "sprites", "environment", "coals.png")
    fire_glow().save("assets", "sprites", "environment", "fire_glow.png")
    bellows().save("assets", "sprites", "tools", "bellows.png")
    blower().save("assets", "sprites", "tools", "blower.png")
    anvil().save("assets", "sprites", "tools", "anvil.png")
    hand_hammer().save("assets", "sprites", "tools", "hand_hammer.png")
    trough().save("assets", "sprites", "tools", "trough.png")
    helve_post().save("assets", "sprites", "tools", "helve_post.png")
    helve_beam().save("assets", "sprites", "tools", "helve_beam.png")
    helve_head().save("assets", "sprites", "tools", "helve_head.png")
    water_wheel().save("assets", "sprites", "tools", "water_wheel.png")
    flywheel().save("assets", "sprites", "tools", "flywheel.png")
    engine().save("assets", "sprites", "tools", "engine.png")
    engine_beam().save("assets", "sprites", "tools", "engine_beam.png")


if __name__ == "__main__":
    render_all()
