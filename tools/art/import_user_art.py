# -*- coding: utf-8 -*-
"""Bereitet die vom Auftraggeber gelieferten Grafiken (assets/source/user_art/) für das Spiel auf:
Hintergrund entfernen (gemaltes Schachbrett, Weiß, Schwarz, Dunkelgrau), Sammelbilder zerlegen,
auf Spielgröße skalieren, Zustände für Knöpfe ableiten. Ausgabe: assets/sprites/ui/user/.

    python tools/art/import_user_art.py
"""
import os
import numpy as np
from PIL import Image, ImageEnhance, ImageFilter
from scipy import ndimage

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC = os.path.join(ROOT, "assets", "source", "user_art")
OUT = os.path.join(ROOT, "assets", "sprites", "ui", "user")


def load(name):
    return np.asarray(Image.open(os.path.join(SRC, name)).convert("RGB")).astype(np.float32)


def flood_bg(is_bg):
    """Hintergrund = mit dem Bildrand verbundene Pixel, die is_bg erfüllen."""
    lab, _ = ndimage.label(is_bg)
    edge = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    return np.isin(lab, list(edge))


def enclosed(mask_fn_result, min_size):
    """Zusätzlich eingeschlossene Hintergrundflächen ab einer Mindestgröße."""
    lab, n = ndimage.label(mask_fn_result)
    if n == 0:
        return np.zeros_like(mask_fn_result)
    sizes = ndimage.sum(mask_fn_result, lab, range(1, n + 1))
    return np.isin(lab, [k + 1 for k, s in enumerate(sizes) if s >= min_size])


def to_rgba(arr, bg, feather=1.0):
    m = Image.fromarray((bg * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(feather))
    alpha = 1.0 - np.asarray(m, np.float32) / 255.0
    alpha = np.where(alpha < 0.04, 0.0, alpha)
    return Image.fromarray(np.dstack([arr, alpha * 255]).astype(np.uint8), "RGBA")


def objects(img, min_area=4000):
    """Zerlegt ein freigestelltes Sammelbild in Einzelobjekte (links→rechts, oben→unten)."""
    a = np.asarray(img)[..., 3] > 20
    lab, n = ndimage.label(ndimage.binary_closing(a, iterations=3))
    out = []
    for k, sl in enumerate(ndimage.find_objects(lab), start=1):
        if sl is None:
            continue
        h, w = sl[0].stop - sl[0].start, sl[1].stop - sl[1].start
        if h * w < min_area:
            continue
        piece = np.asarray(img).copy()
        piece[..., 3] = np.where(lab == k, piece[..., 3], 0)
        crop = Image.fromarray(piece).crop((sl[1].start, sl[0].start, sl[1].stop, sl[0].stop))
        out.append(((sl[0].start // 150, sl[1].start), crop))
    out.sort(key=lambda t: t[0])
    return [c for _, c in out]


def save(img, name, max_w=None, max_h=None):
    img = img.crop(img.getbbox())
    s = 1.0
    if max_w:
        s = min(s, max_w / img.width)
    if max_h:
        s = min(s, max_h / img.height)
    if s < 1.0:
        img = img.resize((max(1, int(img.width * s)), max(1, int(img.height * s))), Image.LANCZOS)
    os.makedirs(OUT, exist_ok=True)
    img.save(os.path.join(OUT, name), optimize=True)
    return img


def states(img, base):
    """Knopfzustände: normal, hover (heller), pressed (dunkler), disabled (entsättigt)."""
    save(img, base + "_normal.png")
    save(ImageEnhance.Brightness(img).enhance(1.18), base + "_hover.png")
    save(ImageEnhance.Brightness(img).enhance(0.8), base + "_pressed.png")
    dis = ImageEnhance.Color(img).enhance(0.25)
    save(ImageEnhance.Brightness(dis).enhance(0.75), base + "_disabled.png")


def main():
    # 1 Pergament mit Messingecken (schwarzer Hintergrund, verbrannte Ränder weich)
    a = load("panel_parchment.webp")
    lum = a.mean(axis=2)
    bg = flood_bg(lum < 28)
    img = to_rgba(a, bg.astype(np.float32), 1.5)
    al = np.asarray(img).copy()
    al[..., 3] = np.where(bg, np.clip((lum - 8) / 30, 0, 1) * 255, al[..., 3])
    save(Image.fromarray(al), "panel_parchment.png", max_w=900)

    # 2 Glut-Knopf (gemaltes Schachbrett)
    a = load("button_ember.webp")
    sat = a.max(axis=2) - a.min(axis=2)
    bg = flood_bg((sat < 16) & (a.mean(axis=2) > 95))
    save(to_rgba(a, bg.astype(np.float32)), "button_ember.png", max_w=700)

    # 3 Holzrahmen mit Eisenplatte (gemaltes Schachbrett)
    a = load("frame_wood_iron.webp")
    sat = a.max(axis=2) - a.min(axis=2)
    bg = flood_bg((sat < 14) & (a.mean(axis=2) > 150))
    save(to_rgba(a, bg.astype(np.float32)), "frame_wood_iron.png", max_w=700)

    # 4 Pyrometer (weiß); eingeschlossene weiße Flächen im Bogen ebenfalls entfernen
    a = load("pyrometer.webp")
    white = a.min(axis=2) > 232
    bg = flood_bg(white) | enclosed(white, 400)
    save(to_rgba(a, bg.astype(np.float32)), "pyrometer_dial.png", max_w=700)

    # 5 Zeiger: einzelnen Zeiger aus dem Sheet (oben links), Durchbrüche freistellen
    a = load("pointer_sheet.webp")[95:200, 30:360]
    white = a.min(axis=2) > 225
    bg = flood_bg(white) | enclosed(white, 30)
    save(to_rgba(a, bg.astype(np.float32)), "pyrometer_needle.png")

    # 6 Leder-Messing-Knöpfe (weiß): 4 Varianten
    a = load("buttons_leather_brass.webp")
    bg = flood_bg(a.min(axis=2) > 238)
    for k, piece in enumerate(objects(to_rgba(a, bg.astype(np.float32)))[:4], start=1):
        save(piece, f"card_{k}.png", max_h=520)

    # 7 Münzbeutel (weiß)
    a = load("coin_pouch.webp")
    bg = flood_bg(a.min(axis=2) > 236)
    save(to_rgba(a, bg.astype(np.float32)), "coin_pouch.png", max_w=256)

    # 8 Münzen (weiß, mit hellem Schatten darunter): Guinee, Shilling, Halfpenny
    a = load("coins.webp")
    sat = a.max(axis=2) - a.min(axis=2)
    bg = flood_bg((a.min(axis=2) > 200) & (sat < 40))
    pieces = [p for p in objects(to_rgba(a, bg.astype(np.float32))) if p.height > 200]
    for piece, name in zip(pieces, ["coin_guinea.png", "coin_shilling.png", "coin_halfpenny.png"]):
        save(piece, name, max_w=128)

    # 9 Auftragsbuch (dunkelgrau); Wasserzeichen fällt als Hintergrundobjekt weg
    a = load("ledger.webp")
    ref = np.array([31, 35, 36], np.float32)
    bg = flood_bg(np.abs(a - ref).max(axis=2) < 14)
    book = objects(to_rgba(a, bg.astype(np.float32)), min_area=200000)[0]
    save(book, "ledger.png")

    # 10 Wachssiegel (weiß): nur die historisch passenden (George III, Admiralität)
    a = load("wax_seals.webp")
    bg = flood_bg(a.min(axis=2) > 238)
    seals = objects(to_rgba(a, bg.astype(np.float32)))
    by_pos = sorted(seals, key=lambda p: 0)
    # Reihenfolge der Objekte: (Zeile, x) – oben: Victoria, George III, Admiralty; unten: Louis XV, Russland
    names = {1: "seal_george_iii.png", 2: "seal_admiralty.png"}
    for k, piece in enumerate(seals):
        if k in names:
            save(piece, names[k], max_w=160)
    # 11 Amboss auf Holzklotz (weiß), auf Spielgröße vorskaliert (wird 1:1 gezeichnet)
    a = load("anvil.webp")
    sat = a.max(axis=2) - a.min(axis=2)
    img = to_rgba(a, flood_bg((a.min(axis=2) > 222) & (sat < 20)).astype(np.float32))
    img = img.crop(img.getbbox())
    save(img.resize((457, int(img.height * 457 / img.width)), Image.LANCZOS), "anvil.png")

    # 12/13 Lehm- und Ziegelesse (weiß); Rauch über dem Schornstein abschneiden (Partikel übernehmen)
    for name, cut in [("forge_clay", 140), ("forge_brick", 142)]:
        a = load(name + ".webp")[cut:]
        sat = a.max(axis=2) - a.min(axis=2)
        img = to_rgba(a, flood_bg((a.min(axis=2) > 222) & (sat < 20)).astype(np.float32))
        arr = np.asarray(img).copy()
        top = arr[:20]
        rgb = top[..., :3].astype(int)
        smoke = (rgb.max(axis=2) - rgb.min(axis=2) < 25) & (rgb.mean(axis=2) > 120)
        top[..., 3] = np.where(smoke, 0, top[..., 3])
        img = Image.fromarray(arr)
        img = img.crop(img.getbbox())
        save(img.resize((int(img.width * 0.8), int(img.height * 0.8)), Image.LANCZOS), name + ".png")
    derived()
    print("fertig:", sorted(os.listdir(OUT)))


def derived():
    """Für Godot vorbereitete Varianten (StyleBoxTexture zeichnet Ränder 1:1, daher vorskalieren)."""
    # Standardknopf aus Lederkarte 1: verkleinert, Rand ca. 24 px
    card = Image.open(os.path.join(OUT, "card_1.png"))
    s = 0.3
    btn = card.resize((int(card.width * s), int(card.height * s)), Image.LANCZOS)
    states(btn, "btn")
    # HUD-Leiste aus dem Holz-Eisen-Rahmen, Rand ca. 25 px
    fr = Image.open(os.path.join(OUT, "frame_wood_iron.png"))
    s = 0.36
    save(fr.resize((int(fr.width * s), int(fr.height * s)), Image.LANCZOS), "hud_bar.png")
    # Großer HAMMERN-Knopf: Glut-Knopf im Originalformat (Hammer im Zahnrad), 2x Anzeigegröße
    em = Image.open(os.path.join(OUT, "button_ember.png"))
    w = 440
    states(em.resize((w, int(em.height * w / em.width)), Image.LANCZOS), "ember")


if __name__ == "__main__":
    main()
