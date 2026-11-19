# -*- coding: utf-8 -*-
"""Porträts, UI-Texturen, Symbole, Partikel und Titel-Schriftzug."""
import math
import os
import re
import numpy as np
from PIL import Image, ImageDraw, ImageFont, ImageFilter
from common import Canvas, INK, PAL, vgrad, hgrad, radial, mul, rect_pts, ellipse_pts, wobble, out_path, paper_texture, ROOT, fbm

# ------------------------------------------------------------------ Porträts

# id -> (Kopfbedeckung, Haar, Geschlecht, Accessoire)
STYLE = {
    "squire": ("tricorn", "wig", "m", "cravat"), "vicar": ("none", "wig", "m", "bands"), "farmer_hollow": ("cap", "brown", "m", "none"),
    "miller_upton": ("cap", "grey", "m", "flour"), "landlady_red_lion": ("mobcap", "brown", "f", "shawl"), "carpenter": ("none", "brown", "m", "apron"),
    "postmaster_bath": ("tricorn", "wig", "m", "cravat"), "coachbuilder_york": ("none", "dark", "m", "apron"), "turnpike_trust": ("tricorn", "wig", "m", "cravat"),
    "innkeeper_coaching": ("none", "bald", "m", "apron"), "carrier_bennett": ("slouch", "brown", "m", "none"), "navy_board": ("bicorn", "wig", "m", "epaulette"),
    "shipwright_portsmouth": ("cap", "grey", "m", "none"), "merchant_bristol": ("tricorn", "wig", "m", "cravat"), "harbourmaster": ("tricorn", "grey", "m", "cravat"),
    "ropewalk_chatham": ("cap", "dark", "m", "none"), "clothier_leeds": ("none", "wig", "m", "cravat"), "cutlers_sheffield": ("none", "dark", "m", "apron"),
    "spinning_master": ("none", "grey", "m", "cravat"), "toolmaker_holt": ("cap", "brown", "m", "apron"), "dockyard_chatham": ("bicorn", "wig", "m", "epaulette"),
    "boulton_watt": ("none", "wig", "m", "cravat"), "mine_cornwall": ("miner", "dark", "m", "none"), "colliery_wednesbury": ("miner", "brown", "m", "none"),
    "canal_company": ("tophat", "dark", "m", "cravat"), "ironmaster_coalbrookdale": ("tricorn", "wig", "m", "cravat"), "wedgwood_etruria": ("none", "wig", "m", "cravat"),
    "mill_owner": ("tophat", "brown", "m", "cravat"), "plateway_company": ("tophat", "grey", "m", "cravat"), "engine_works": ("none", "dark", "m", "apron"),
    "ironworks_partners": ("tophat", "dark", "m", "cravat"), "east_india": ("bicorn", "wig", "m", "cravat"),
}
SKIN = [(236, 200, 168), (224, 184, 150), (210, 164, 128), (196, 150, 116), (240, 210, 182)]
HAIR = {"wig": (232, 228, 220), "brown": (104, 70, 42), "grey": (170, 166, 160), "dark": (52, 38, 30), "bald": (200, 160, 130)}


def read_customer_colors():
    cols = {}
    d = os.path.join(ROOT, "data", "customers")
    for f in os.listdir(d):
        t = open(os.path.join(d, f), encoding="utf-8").read()
        cid = re.search(r'id = "([^"]+)"', t).group(1)
        m = re.search(r"portrait_color = Color\(([\d.]+), ([\d.]+), ([\d.]+)", t)
        cols[cid] = tuple(int(float(v) * 255) for v in m.groups())
    return cols


def portrait(cid, coat, idx):
    hat, hair, sex, acc = STYLE.get(cid, ("none", "brown", "m", "none"))
    c = Canvas(180, 220)
    c.shape(rect_pts(0, 0, 180, 220), (200, 184, 150), outline=None, light=radial(90, 90, 160, 1.1, 0.75), noise=0.1, seed=idx, wob=0)
    skin = SKIN[idx % len(SKIN)]
    hcol = HAIR[hair]
    # Rumpf / Rock
    c.shape([(20, 230), (30, 170), (60, 150), (120, 150), (150, 170), (162, 230)], coat, light=hgrad(20, 160, 1.15, 0.75), seed=idx + 1)
    c.line([(90, 152), (90, 228)], tuple(int(v * 0.7) for v in coat) + (255,), 3)
    if acc == "cravat":
        c.shape([(76, 150), (104, 150), (98, 182), (90, 190), (82, 182)], (240, 236, 226), seed=idx + 2, width=2)
    elif acc == "bands":
        c.shape([(80, 150), (100, 150), (98, 178), (82, 178)], (245, 245, 240), seed=idx + 2, width=2)
    elif acc == "apron":
        c.shape([(56, 170), (124, 170), (130, 230), (50, 230)], (130, 104, 70), seed=idx + 2, width=2)
    elif acc == "epaulette":
        for x in (40, 140):
            c.ellipse(x, 166, 20, 9, (220, 180, 80), seed=idx + 3, width=2)
        c.shape([(80, 150), (100, 150), (96, 172), (84, 172)], (240, 236, 226), seed=idx + 2, width=2)
    elif acc == "shawl":
        c.shape([(26, 176), (90, 150), (154, 176), (130, 196), (90, 176), (50, 196)], (170, 60, 50), seed=idx + 2, width=2)
    # Hals, Kopf
    c.shape(rect_pts(78, 128, 24, 26), skin, seed=idx + 4, width=2)
    if hair == "wig":
        c.ellipse(90, 92, 50, 48, hcol, seed=idx + 5)
        for side in (-1, 1):
            for k in range(2):
                c.ellipse(90 + side * 46, 98 + k * 18, 11, 9, hcol, seed=idx + 6 + k, width=2)
    elif hair not in ("bald",):
        c.ellipse(90, 86, 46, 44, hcol, seed=idx + 5)
        if sex == "f":
            c.shape([(46, 90), (134, 90), (140, 150), (40, 150)], hcol, seed=idx + 6)
    c.ellipse(90, 100, 37, 44, skin, light=radial(78, 88, 60, 1.08, 0.86), seed=idx + 7)
    c.ellipse(76, 96, 3.5, 3, INK[:3], outline=None, wob=0)
    c.ellipse(104, 96, 3.5, 3, INK[:3], outline=None, wob=0)
    c.line([(70, 86), (82, 84)], INK, 2)
    c.line([(98, 84), (110, 86)], INK, 2)
    c.line([(90, 100), (86, 114), (92, 116)], (120, 80, 60, 255), 2)
    c.line([(80, 126), (90, 129), (100, 126)], (150, 70, 60, 255), 2.2)
    c.ellipse(70, 112, 8, 5, (230, 150, 130), outline=None, noise=0, wob=0)
    c.ellipse(110, 112, 8, 5, (230, 150, 130), outline=None, noise=0, wob=0)
    if acc == "flour":
        for k in range(12):
            r = np.random.default_rng(k)
            c.ellipse(r.uniform(40, 140), r.uniform(150, 210), 3, 3, (240, 236, 226), outline=None, noise=0, wob=0)
    # Kopfbedeckung
    dark = (40, 34, 30)
    if hat == "tricorn":
        c.shape([(34, 66), (90, 40), (146, 66), (124, 74), (90, 62), (56, 74)], dark, seed=idx + 8)
        c.line([(40, 66), (90, 46), (140, 66)], (200, 170, 90, 255), 2)
    elif hat == "bicorn":
        c.shape([(26, 70), (60, 36), (120, 36), (154, 70), (90, 62)], dark, seed=idx + 8)
        c.ellipse(118, 50, 7, 7, (220, 180, 80), seed=idx + 9, width=1.5)
    elif hat == "tophat":
        c.shape(rect_pts(60, 14, 60, 50), dark, light=hgrad(60, 120, 1.3, 0.8), seed=idx + 8)
        c.shape(rect_pts(44, 60, 92, 10), dark, seed=idx + 9)
    elif hat == "cap":
        c.shape([(50, 70), (56, 50), (90, 42), (124, 50), (134, 70)], (90, 80, 70), seed=idx + 8)
    elif hat == "slouch":
        c.shape([(30, 72), (60, 44), (120, 44), (150, 72), (90, 66)], (80, 64, 48), seed=idx + 8)
    elif hat == "mobcap":
        c.ellipse(90, 64, 52, 30, (245, 242, 232), seed=idx + 8)
    elif hat == "miner":
        c.shape([(48, 72), (56, 48), (90, 40), (124, 48), (132, 72)], (70, 60, 50), seed=idx + 8)
        c.ellipse(90, 50, 9, 9, (240, 200, 120), seed=idx + 9, width=2)
    img = c.result()
    # Ovalrahmen
    mask = Image.new("L", (180, 220), 0)
    ImageDraw.Draw(mask).ellipse([6, 6, 174, 214], fill=255)
    out = Image.new("RGBA", (180, 220), (0, 0, 0, 0))
    out.paste(img, (0, 0), mask)
    fr = Canvas(180, 220)
    fr.line(ellipse_pts(90, 110, 84, 104, 80), (120, 90, 50, 255), 9)
    fr.line(ellipse_pts(90, 110, 84, 104, 80), (217, 183, 122, 255), 5)
    out.alpha_composite(fr.result())
    return out


# ------------------------------------------------------------------ UI

def parchment(w=512, h=512, seed=3, base=(233, 220, 192)):
    img = paper_texture(w, h, seed, base)
    d = ImageDraw.Draw(img)
    for k, col in ((0, (176, 141, 87, 255)), (5, (120, 90, 50, 255))):
        d.rectangle([k, k, w - 1 - k, h - 1 - k], outline=col, width=4 if k == 0 else 2)
    return img


def button(state):
    w, h = 192, 72
    base = {"normal": (90, 64, 46), "hover": (112, 78, 52), "pressed": (60, 42, 30), "disabled": (74, 66, 58)}[state]
    border = {"normal": (176, 141, 87), "hover": (226, 196, 130), "pressed": (217, 183, 122), "disabled": (110, 100, 84)}[state]
    c = Canvas(w, h)
    c.shape(rect_pts(3, 3, w - 6, h - 6), base, outline=None, light=vgrad(0, h, 1.2 if state != "pressed" else 0.8, 0.8 if state != "pressed" else 1.1), noise=0.12, seed=7, wob=0, cell=10)
    r = np.random.default_rng(3)
    for k in range(6):
        y = 10 + k * 10 + r.uniform(-2, 2)
        c.line([(8, y), (w - 8, y + r.uniform(-3, 3))], tuple(int(v * 0.82) for v in base) + (255,), 1.2)
    img = c.result()
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([1, 1, w - 2, h - 2], 10, outline=(30, 20, 14, 255), width=2)
    d.rounded_rectangle([3, 3, w - 4, h - 4], 9, outline=border + (255,), width=3)
    for x, y in ((12, 12), (w - 12, 12), (12, h - 12), (w - 12, h - 12)):
        d.ellipse([x - 3, y - 3, x + 3, y + 3], fill=border + (255,))
    # abgerundete Ecken transparent
    m = Image.new("L", (w, h), 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, w - 1, h - 1], 11, fill=255)
    img.putalpha(m)
    return img


def leather_bar():
    w, h = 256, 88
    c = Canvas(w, h)
    c.shape(rect_pts(0, 0, w, h), (52, 36, 26), outline=None, light=vgrad(0, h, 1.15, 0.8), noise=0.18, seed=11, wob=0, cell=14)
    img = c.result()
    d = ImageDraw.Draw(img)
    for y in (6, h - 7):
        for x in range(4, w, 12):
            d.line([(x, y), (x + 6, y)], fill=(176, 141, 87, 255), width=2)
    d.line([(0, h - 2), (w, h - 2)], fill=(176, 141, 87, 255), width=3)
    return img


def icon_coin():
    c = Canvas(64, 64)
    c.ellipse(32, 34, 26, 26, (200, 160, 60), light=radial(24, 26, 34, 1.3, 0.8), seed=1)
    c.ellipse(32, 34, 18, 18, (226, 190, 90), outline=(150, 110, 40, 255), width=2, seed=2)
    return c.result()


def icon_star(filled):
    c = Canvas(64, 64)
    pts = []
    for k in range(10):
        r = 28 if k % 2 == 0 else 12
        a = -math.pi / 2 + k * math.pi / 5
        pts.append((32 + math.cos(a) * r, 34 + math.sin(a) * r))
    if filled:
        c.shape(pts, (232, 181, 74), light=radial(26, 24, 34, 1.25, 0.8), seed=3, wob=0.5)
    else:
        c.shape(pts, (90, 76, 62), outline=(70, 56, 44, 255), light=None, seed=3, wob=0.5)
    return c.result()


def icon_hourglass():
    c = Canvas(64, 64)
    c.shape(rect_pts(14, 4, 36, 6), PAL["wood_mid"], seed=1, width=2)
    c.shape(rect_pts(14, 54, 36, 6), PAL["wood_mid"], seed=2, width=2)
    c.shape([(18, 10), (46, 10), (34, 32), (46, 54), (18, 54), (30, 32)], (200, 220, 230), seed=3, width=2, noise=0)
    c.shape([(22, 46), (42, 46), (46, 54), (18, 54)], (220, 190, 120), outline=None, seed=4)
    c.shape([(24, 14), (40, 14), (32, 26)], (220, 190, 120), outline=None, seed=5)
    return c.result()


def particle_spark():
    s = 32
    yy, xx = np.mgrid[0:s, 0:s].astype(np.float32)
    d = np.sqrt((xx - s / 2 + 0.5) ** 2 + (yy - s / 2 + 0.5) ** 2) / (s / 2)
    a = np.clip(1 - d, 0, 1) ** 2.2
    img = np.zeros((s, s, 4), np.uint8)
    img[..., 0] = 255
    img[..., 1] = (200 + 55 * a).astype(np.uint8)
    img[..., 2] = (120 * a).astype(np.uint8)
    img[..., 3] = (a * 255).astype(np.uint8)
    return Image.fromarray(img, "RGBA")


def particle_smoke():
    s = 128
    n = fbm(s, s, 32, 4, 9)
    yy, xx = np.mgrid[0:s, 0:s].astype(np.float32)
    d = np.sqrt((xx - s / 2) ** 2 + (yy - s / 2) ** 2) / (s / 2)
    a = np.clip(1 - d, 0, 1) ** 1.5 * (0.5 + n)
    img = np.zeros((s, s, 4), np.uint8)
    img[..., :3] = 255
    img[..., 3] = np.clip(a * 200, 0, 255).astype(np.uint8)
    return Image.fromarray(img, "RGBA")


def title_logo():
    w, h = 1300, 300
    font = ImageFont.truetype(os.path.join(ROOT, "assets", "fonts", "IMFellEnglishSC.ttf"), 150)
    text = "Forge Workshop"
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    m = Image.new("L", (w, h), 0)
    d = ImageDraw.Draw(m)
    bbox = d.textbbox((0, 0), text, font=font)
    x = (w - (bbox[2] - bbox[0])) // 2 - bbox[0]
    y = 40 - bbox[1] + 30
    d.text((x, y), text, font=font, fill=255)
    shadow = m.filter(ImageFilter.GaussianBlur(8))
    sh = Image.new("RGBA", (w, h), (20, 10, 4, 0))
    sh.putalpha(shadow.point(lambda v: int(v * 0.9)))
    img.alpha_composite(sh, (6, 8))
    outline = m.filter(ImageFilter.MaxFilter(9))
    ol = Image.new("RGBA", (w, h), (42, 26, 14, 255))
    ol.putalpha(outline)
    img.alpha_composite(ol)
    yy = np.mgrid[0:h, 0:w][0].astype(np.float32)
    grad = np.clip((yy - y - bbox[1]) / 150.0, 0, 1)
    gold = np.zeros((h, w, 4), np.float32)
    gold[..., 0] = 255 - 40 * grad
    gold[..., 1] = 222 - 80 * grad
    gold[..., 2] = 140 - 90 * grad
    n = fbm(w, h, 20, 3, 4)
    gold[..., :3] *= (0.9 + 0.2 * n[..., None])
    gold[..., 3] = np.asarray(m, np.float32)
    img.alpha_composite(Image.fromarray(np.clip(gold, 0, 255).astype(np.uint8), "RGBA"))
    # Ornament: Hammer über Amboss
    c = Canvas(w, h)
    c.line([(w / 2 - 260, 268), (w / 2 + 260, 268)], (176, 141, 87, 255), 4)
    c.ellipse(w / 2, 268, 9, 9, (217, 183, 122), seed=1, width=2)
    img.alpha_composite(c.result())
    return img


def render_all():
    cols = read_customer_colors()
    for i, (cid, col) in enumerate(sorted(cols.items())):
        portrait(cid, col, i).save(out_path("assets", "sprites", "portraits", cid + ".png"), optimize=True)
    parchment().save(out_path("assets", "sprites", "ui", "parchment.png"))
    parchment(512, 256, 5, (214, 195, 156)).save(out_path("assets", "sprites", "ui", "parchment_dark.png"))
    for st in ("normal", "hover", "pressed", "disabled"):
        button(st).save(out_path("assets", "sprites", "ui", f"button_{st}.png"))
    leather_bar().save(out_path("assets", "sprites", "ui", "leather_bar.png"))
    icon_coin().save(out_path("assets", "sprites", "ui", "icon_coin.png"))
    icon_star(True).save(out_path("assets", "sprites", "ui", "star_full.png"))
    icon_star(False).save(out_path("assets", "sprites", "ui", "star_empty.png"))
    icon_hourglass().save(out_path("assets", "sprites", "ui", "icon_hourglass.png"))
    particle_spark().save(out_path("assets", "sprites", "ui", "particle_spark.png"))
    particle_smoke().save(out_path("assets", "sprites", "ui", "particle_smoke.png"))
    title_logo().save(out_path("assets", "sprites", "ui", "title.png"))


if __name__ == "__main__":
    render_all()
