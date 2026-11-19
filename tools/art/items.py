# -*- coding: utf-8 -*-
"""Gegenstands-Sprites (ein Sprite je Gegenstand, Lastenheft 6.5).
Graustufig mit Prägeschattierung und dunkler Kontur – der Glow-Shader färbt sie nach Temperatur ein.
Rotkanal = Helligkeit, Alpha = Deckkraft."""
import math
import numpy as np
from PIL import Image, ImageDraw, ImageFilter
from common import out_path

S = 256
SS = 3


def _p(pts):
    return [(x * SS, y * SS) for x, y in pts]


def arc_pts(cx, cy, r, a0, a1, n=40):
    return [(cx + r * math.cos(math.radians(a0 + (a1 - a0) * i / n)), cy + r * math.sin(math.radians(a0 + (a1 - a0) * i / n))) for i in range(n + 1)]


def build_mask(prims):
    m = Image.new("L", (S * SS, S * SS), 0)
    d = ImageDraw.Draw(m)
    for pr in prims:
        kind = pr[0]
        fill = 0 if kind.startswith("-") else 255
        k = kind.lstrip("-")
        if k == "poly":
            d.polygon(_p(pr[1]), fill=fill)
        elif k == "line":
            pts = _p(pr[1])
            w = int(pr[2] * SS)
            d.line(pts, fill=fill, width=w, joint="curve")
            for x, y in (pts[0], pts[-1]):
                d.ellipse([x - w / 2, y - w / 2, x + w / 2, y + w / 2], fill=fill)
        elif k == "ring":
            _, cx, cy, r, w, a0, a1 = pr
            if a1 - a0 >= 360:
                d.ellipse([(cx - r - w / 2) * SS, (cy - r - w / 2) * SS, (cx + r + w / 2) * SS, (cy + r + w / 2) * SS], fill=fill)
                d.ellipse([(cx - r + w / 2) * SS, (cy - r + w / 2) * SS, (cx + r - w / 2) * SS, (cy + r - w / 2) * SS], fill=0)
            else:
                outer = arc_pts(cx, cy, r + w / 2, a0, a1, 80)
                inner = arc_pts(cx, cy, r - w / 2, a0, a1, 80)[::-1]
                d.polygon(_p(outer + inner), fill=fill)
                for a in (a0, a1):
                    x, y = cx + r * math.cos(math.radians(a)), cy + r * math.sin(math.radians(a))
                    d.ellipse([(x - w / 2) * SS, (y - w / 2) * SS, (x + w / 2) * SS, (y + w / 2) * SS], fill=fill)
        elif k == "ellipse":
            _, cx, cy, rx, ry = pr
            d.ellipse([(cx - rx) * SS, (cy - ry) * SS, (cx + rx) * SS, (cy + ry) * SS], fill=fill)
        elif k == "rect":
            _, x, y, w, h = pr
            d.rectangle([x * SS, y * SS, (x + w) * SS, (y + h) * SS], fill=fill)
    return m


def shade(mask, detail_lines=(), seed=0):
    """Prägeschattierung aus der Maske, Kontur, Glanzlicht, Hammerschlag-Struktur."""
    a = np.asarray(mask, np.float32) / 255.0
    blur = np.asarray(mask.filter(ImageFilter.GaussianBlur(7 * SS)), np.float32) / 255.0
    gy, gx = np.gradient(blur)
    light = -(gx * -0.7 + gy * -0.7) * 9.0 * SS
    r = np.random.default_rng(seed)
    hammer = np.asarray(Image.fromarray((r.random((S // 8, S // 8)) * 255).astype(np.uint8)).resize((S * SS, S * SS), Image.BICUBIC), np.float32) / 255.0
    lum = 0.56 + np.clip(light, -0.35, 0.35) * 0.9 + (blur - 0.5) * 0.12 + (hammer - 0.5) * 0.07
    edge = np.asarray(mask.filter(ImageFilter.MinFilter(2 * int(2.6 * SS) + 1)), np.float32) / 255.0
    lum = np.where(edge < 0.5, 0.16, lum)
    lum = np.clip(lum, 0.08, 1.0)
    img = np.zeros((S * SS, S * SS, 4), np.float32)
    img[..., 0] = img[..., 1] = img[..., 2] = lum * 255
    img[..., 3] = a * 255
    out = Image.fromarray(img.astype(np.uint8), "RGBA")
    d = ImageDraw.Draw(out)
    for pts, w, l in detail_lines:
        d.line(_p(pts), fill=(int(l * 255),) * 3 + (255,), width=int(w * SS), joint="curve")
    out.putalpha(mask)
    return out.resize((S, S), Image.LANCZOS)


C = 128


def horseshoe(calkins=False, r=62, w=26):
    pr = [("ring", C, C + 6, r, w, 150, 390)]
    if calkins:
        for a in (150, 390):
            x, y = C + r * math.cos(math.radians(a)), C + 6 + r * math.sin(math.radians(a))
            pr.append(("rect", x - 15, y - 4, 30, 18))
    holes = []
    for a in range(170, 380, 30):
        x, y = C + r * math.cos(math.radians(a)), C + 6 + r * math.sin(math.radians(a))
        holes.append(("-ellipse", x, y, 3.2, 3.2))
    return pr + holes


def chain(n=3, horizontal=True):
    pr = []
    for k in range(n):
        x = C - (n - 1) * 34 + k * 68
        if k % 2 == 0:
            pr += [("ellipse", x, C, 44, 28), ("-ellipse", x, C, 30, 14)]
        else:
            pr += [("ellipse", x, C, 46, 11), ("-ellipse", x, C, 34, 3)]
    return pr


def ring(r=78, w=20):
    return [("ring", C, C, r, w, 0, 360)]


def bar(length=200, h=20, x0=None):
    x0 = C - length / 2 if x0 is None else x0
    return [("poly", [(x0, C - h / 2), (x0 + length, C - h / 2 + 1), (x0 + length, C + h / 2 - 1), (x0, C + h / 2)])]


ITEMS = {
    "blank": (bar(196, 22), []),
    "nail": ([("poly", [(40, C - 7), (196, C - 5), (226, C), (196, C + 5), (40, C + 7)]), ("rect", 30, C - 18, 14, 36)], []),
    "horseshoe": (horseshoe(), []),
    "post_horseshoe": (horseshoe(True, 58, 24), []),
    "hook": ([("line", [(34, C - 50), (150, C - 50)], 16), ("ring", 150, C, 50, 16, -90, 150), ("ellipse", 34, C - 50, 14, 14), ("-ellipse", 34, C - 50, 6, 6)], []),
    "door_hinge": ([("poly", [(36, C - 14), (190, C - 18), (190, C + 18), (36, C + 14)]), ("ellipse", 200, C, 24, 24), ("-ellipse", 200, C, 9, 9),
                    ("-ellipse", 70, C, 5, 5), ("-ellipse", 120, C, 5, 5), ("poly", [(36, C - 14), (20, C - 26), (20, C + 26), (36, C + 14)])], []),
    "sickle": ([("ring", 140, C + 20, 74, 14, 185, 345), ("poly", [(66, C + 20), (78, C + 20), (60, C + 90), (44, C + 88)])], []),
    "ploughshare": ([("poly", [(30, C + 40), (226, C + 40), (190, C + 20), (120, C - 40), (60, C - 34)])], [([(40, C + 34), (210, C + 34)], 2, 0.9)]),
    "fire_poker": ([("line", [(30, C), (200, C)], 12), ("poly", [(200, C - 6), (236, C - 20), (226, C + 2), (200, C + 6)]), ("ring", 30, C, 14, 8, 0, 360)], []),
    "gate_latch": ([("poly", [(30, C - 10), (200, C - 10), (200, C + 10), (30, C + 10)]), ("rect", 196, C - 30, 18, 60), ("ellipse", 40, C, 16, 16), ("-ellipse", 40, C, 6, 6)], []),
    "wheel_tyre": (ring(86, 18), [([(70, 60), (186, 60)], 1, 0.3)]),
    "coach_axle": ([("rect", 26, C - 12, 204, 24), ("rect", 20, C - 26, 22, 52), ("rect", 214, C - 26, 22, 52)], [([(46, C - 7), (210, C - 7)], 2, 0.9)]),
    "coach_fitting": ([("poly", [(40, C - 50), (60, C - 50), (60, C + 30), (210, C + 30), (210, C + 50), (40, C + 50)]), ("line", [(50, C - 20), (150, C + 40)], 10),
                       ("-ellipse", 50, C - 30, 5, 5), ("-ellipse", 190, C + 40, 5, 5)], []),
    "lantern_bracket": ([("line", [(40, C - 60), (40, C + 50)], 14), ("line", [(40, C - 40), (210, C - 40)], 12), ("line", [(40, C + 20), (160, C - 40)], 9),
                         ("ring", 205, C - 10, 18, 7, 0, 360)], []),
    "turnpike_fitting": ([("poly", [(30, C - 22), (180, C - 12), (180, C + 12), (30, C + 22)]), ("ring", 196, C, 22, 10, 0, 360), ("-ellipse", 60, C, 6, 6), ("-ellipse", 110, C, 6, 6)], []),
    "drag_shoe": ([("poly", [(40, C - 10), (220, C - 10), (230, C + 30), (36, C + 30)]), ("poly", [(40, C - 10), (60, C - 50), (80, C - 50), (70, C - 10)]),
                   ("ring", 70, C - 58, 14, 7, 0, 360)], []),
    "chain_link": (chain(3), []),
    "anchor_shank": ([("line", [(C, 30), (C, 200)], 18), ("ring", C, 130, 80, 16, 20, 160), ("poly", [(42, 152), (24, 132), (56, 140)]), ("poly", [(214, 152), (232, 132), (200, 140)]),
                      ("line", [(C - 50, 64), (C + 50, 64)], 12), ("ring", C, 24, 12, 7, 0, 360)], []),
    "boathook": ([("line", [(20, C + 20), (180, C + 20)], 14), ("line", [(180, C + 20), (232, C - 30)], 12), ("ring", 196, C + 46, 26, 11, -90, 110)], []),
    "mooring_ring": (ring(72, 24) + [("rect", C - 12, 20, 24, 40)], []),
    "ship_bolt": ([("rect", 40, C - 9, 180, 18), ("rect", 30, C - 24, 18, 48), ("poly", [(220, C - 9), (234, C), (220, C + 9)])], []),
    "carriage_fitting": ([("poly", [(30, C - 30), (226, C - 30), (226, C - 10), (130, C - 10), (130, C + 50), (110, C + 50), (110, C - 10), (30, C - 10)]),
                          ("-ellipse", 50, C - 20, 5, 5), ("-ellipse", 200, C - 20, 5, 5), ("ring", 120, C + 50, 14, 8, 0, 360)], []),
    "rudder_pintle": ([("poly", [(30, C - 26), (170, C - 26), (170, C + 26), (30, C + 26)]), ("rect", 168, C - 8, 40, 16), ("line", [(208, C), (208, C + 60)], 16),
                       ("-ellipse", 70, C, 6, 6), ("-ellipse", 120, C, 6, 6)], []),
    "spindle": ([("poly", [(20, C), (90, C - 7), (220, C - 4), (236, C), (220, C + 4), (90, C + 7)]), ("ellipse", 84, C, 16, 16)], []),
    "cloth_shears": ([("poly", [(30, C - 30), (220, C - 18), (226, C - 6), (40, C - 8)]), ("poly", [(30, C + 30), (220, C + 18), (226, C + 6), (40, C + 8)]),
                      ("ring", 34, C, 30, 10, 90, 270)], [([(60, C - 20), (210, C - 12)], 2, 0.95)]),
    "knife": ([("poly", [(100, C - 18), (220, C - 18), (236, C - 8), (200, C + 18), (100, C + 16)]), ("rect", 26, C - 7, 80, 14)], [([(104, C - 12), (222, C - 12)], 2, 0.95)]),
    "spring": ([("ring", C, C + 120, 140 - k * 14, 9, 235, 305) for k in range(4)], []),
    "chisel": ([("rect", 30, C - 14, 150, 28), ("poly", [(180, C - 14), (232, C - 4), (232, C + 4), (180, C + 14)]), ("rect", 26, C - 18, 10, 36)], []),
    "file": ([("poly", [(60, C - 16), (210, C - 10), (230, C), (210, C + 10), (60, C + 16)]), ("poly", [(20, C - 4), (60, C - 6), (60, C + 6), (20, C + 4)])],
             [([(70 + k * 12, C - 12), (76 + k * 12, C + 12)], 1.5, 0.3) for k in range(12)]),
    "cargo_chain": (chain(3) + [("ring", 220, C, 14, 8, 0, 360)], []),
    "barrel_hoop": ([("ellipse", C, C, 96, 60), ("-ellipse", C, C, 84, 48)], []),
    "piston_rod": ([("rect", 20, C - 10, 196, 20), ("ellipse", 222, C, 22, 22), ("-ellipse", 222, C, 8, 8), ("poly", [(20, C - 18), (40, C - 18), (40, C + 18), (20, C + 18)])], [([(26, C - 5), (210, C - 5)], 2, 0.95)]),
    "valve_part": ([("ellipse", C, C, 46, 46), ("-ellipse", C, C, 18, 18), ("rect", 26, C - 12, 60, 24), ("rect", 170, C - 12, 60, 24)], []),
    "beam_strap": ([("poly", [(30, C - 50), (226, C - 50), (226, C - 30), (50, C - 30), (50, C + 30), (226, C + 30), (226, C + 50), (30, C + 50)]),
                    ("-ellipse", 200, C - 40, 5, 5), ("-ellipse", 200, C + 40, 5, 5)], []),
    "lock_fitting": ([("poly", [(30, C - 20), (190, C - 20), (190, C + 20), (30, C + 20)]), ("ring", 206, C, 24, 12, 0, 360), ("-ellipse", 60, C, 7, 7), ("-ellipse", 110, C, 7, 7), ("-ellipse", 160, C, 7, 7)], []),
    "miners_pick": ([("poly", [(18, C - 20), (C, C - 50), (238, C - 20), (C, C - 30)]), ("rect", C - 9, C - 44, 18, 140)], []),
    "drill_steel": ([("rect", 24, C - 9, 190, 18), ("poly", [(214, C - 14), (238, C), (214, C + 14)]), ("rect", 18, C - 12, 12, 24)], []),
    "conveyor_chain": (chain(3), [([(40, C - 26), (220, C - 26)], 1, 0.2)]),
    "pump_rod": ([("rect", 16, C - 9, 224, 18), ("rect", 100, C - 15, 40, 30), ("ring", 16, C, 12, 7, 0, 360)], []),
    "boiler_rivet": ([("rect", C - 14, C - 30, 28, 90), ("ellipse", C, C - 30, 40, 22), ("rect", C - 40, C - 30, 80, 20)], []),
    "boiler_plate": ([("poly", [(30, C - 50), (226, C - 46), (226, C + 50), (30, C + 46)])] + [("-ellipse", 46 + k * 33, C - 34, 5, 5) for k in range(6)], []),
    "rabble": ([("line", [(20, C - 30), (200, C - 30)], 12), ("poly", [(196, C - 50), (236, C - 50), (236, C + 50), (196, C + 50)])], []),
    "tie_rod": ([("rect", 34, C - 7, 196, 14), ("ring", 30, C, 20, 10, 0, 360), ("poly", [(212, C - 14), (236, C - 14), (236, C + 14), (212, C + 14)])], []),
    "ship_chain": (chain(3) + [("rect", 94, C - 3, 68, 6)], []),
    "lathe_tool": ([("rect", 24, C - 14, 170, 28), ("poly", [(194, C - 14), (236, C + 4), (194, C + 14)])], [([(196, C - 8), (230, C + 2)], 2, 0.95)]),
    "leaf_spring": ([("ring", C, C + 150, 160 - k * 14, 10, 245, 295) for k in range(5)] + [("ring", 30, C - 2, 10, 6, 0, 360), ("ring", 226, C - 2, 10, 6, 0, 360)], []),
    "wagon_axle": ([("rect", 30, C - 16, 196, 32), ("rect", 16, C - 30, 26, 60), ("rect", 214, C - 30, 26, 60), ("rect", 50, C - 22, 10, 44), ("rect", 196, C - 22, 10, 44)], []),
    "large_shaft": ([("rect", 14, C - 24, 228, 48), ("rect", 60, C - 32, 26, 64), ("rect", 170, C - 32, 26, 64)], [([(20, C - 14), (236, C - 14)], 3, 0.95)]),
    "crankshaft": ([("line", [(14, C + 10), (70, C + 10), (70, C - 40), (130, C - 40), (130, C + 10), (186, C + 10), (186, C - 40), (242, C - 40)], 22)], []),
}


def render_all():
    for i, (iid, (prims, details)) in enumerate(ITEMS.items()):
        img = shade(build_mask(prims), details, seed=i + 1)
        img.save(out_path("assets", "sprites", "items", iid + ".png"), optimize=True)
    return list(ITEMS)


if __name__ == "__main__":
    print(len(render_all()), "Gegenstände")
