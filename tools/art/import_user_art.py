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
    # (Doppelseite im Hochformat nicht mehr verwendet – nur noch als Quelle vorhanden)

    # 10 Wachssiegel (weiß): nur die historisch passenden (George III, Admiralität)
    a = load("wax_seals.webp")
    bg = flood_bg(a.min(axis=2) > 238)
    seals = objects(to_rgba(a, bg.astype(np.float32)))
    by_pos = sorted(seals, key=lambda p: 0)
    # Reihenfolge der Objekte: (Zeile, x) – oben: Victoria, George III, Admiralty; unten: Louis XV, Russland
    names = {0: "seal_victoria.png", 1: "seal_george_iii.png", 2: "seal_admiralty.png"}
    for k, piece in enumerate(seals):
        if k in names:
            save(piece, names[k], max_w=160)
    # Einzeln nachgelieferte Siegel (z. B. Victoria ohne Jahreszahl) ersetzen die aus dem Sammelbild
    for name in ("seal_victoria", "seal_george_iii", "seal_admiralty"):
        for ext in (".webp", ".png", ".jpg"):
            if os.path.exists(os.path.join(SRC, name + ext)):
                a = load(name + ext)
                bg = flood_bg(a.min(axis=2) > 238)
                save(to_rgba(a, bg.astype(np.float32)), name + ".png", max_w=160)
    # 11 Amboss und 14 Hämmer (Midjourney, weiß): assets/source/user_art/tools/ – vermessen nach scripts/user_tool_meta.gd
    tool_import()

    # 12/13 Essen in Frontalansicht (Midjourney, weiß): assets/source/user_art/forges/<forge_id>.png
    forge_import()
    # 16 Wasser-Schwanzhammer (weiß) als Bild im Laden
    a = load("water_helve.webp")
    sat = a.max(axis=2) - a.min(axis=2)
    save(to_rgba(a, flood_bg((a.min(axis=2) > 222) & (sat < 20)).astype(np.float32)), "machine_water_helve.png", max_w=360)

    # 17 Werkstücke: assets/source/user_art/items/<item_id>.(webp|png|jpg) → item_<item_id>.png
    items_dir = os.path.join(SRC, "items")
    if os.path.isdir(items_dir):
        for fn in sorted(os.listdir(items_dir)):
            base, ext = os.path.splitext(fn)
            if ext.lower() in (".webp", ".png", ".jpg", ".jpeg"):
                item_sprite(os.path.join(items_dir, fn), base)
    # 18 Werkstatt-Hintergründe → 1080×1920 (1:1 und breiter: mittlerer 3:4-Ausschnitt; Boden nach unten verlängern)
    bg_dir = os.path.join(SRC, "backgrounds")
    if os.path.isdir(bg_dir):
        for fn in sorted(os.listdir(bg_dir)):
            base, ext = os.path.splitext(fn)
            if ext.lower() in (".webp", ".png", ".jpg", ".jpeg") and base.startswith("background_"):
                im = Image.open(os.path.join(bg_dir, fn)).convert("RGB")
                # Quadratische Originale (1:1, für Hoch- und Querformat): im Hochformat nur der mittlere
                # 3:4-Ausschnitt – die äußeren Achtel sind fürs Querformat (Tablet) gedacht
                square = im.width > im.height * 0.78
                if square:
                    cw = int(round(im.height * 3 / 4))
                    x0 = (im.width - cw) // 2
                    im = im.crop((x0, 0, x0 + cw, im.height))
                # Liegt die Wand-Boden-Kante sehr tief, oben etwas Decke abschneiden (Kante rückt nach oben)
                top = BG_TOP_CROP.get(base, 0)
                if top:
                    im = im.crop((0, top, im.width, im.height))
                # Einfarbigen Balken am unteren Rand (Midjourney malt manchmal einen) abschneiden –
                # der Boden wird ohnehin nach unten verlängert
                g = np.asarray(im.convert("L")).astype(np.float32)
                cut = im.height
                while square and cut > im.height * 0.7 and g[cut - 1].std() < 4.0:
                    cut -= 1
                if cut < im.height - 4:
                    im = im.crop((0, 0, im.width, cut - 2))
                h = int(round(im.height * 1080 / im.width))
                im = im.resize((1080, h), Image.LANCZOS)
                if h >= 1920:
                    im = im.crop((0, 0, 1080, 1920))
                else:
                    # Kürzere Bilder (z. B. 3:4): Boden nach unten verlängern – die untersten Zeilen
                    # strecken und zum Rand hin abdunkeln (dort liegt im Spiel das Bedienfeld)
                    canvas = Image.new("RGB", (1080, 1920))
                    canvas.paste(im, (0, 0))
                    strip = im.crop((0, h - 24, 1080, h)).filter(ImageFilter.GaussianBlur(18)).resize((1080, 1920 - h), Image.BILINEAR)
                    arr = np.asarray(strip).astype(np.float32)
                    fade = np.linspace(1.0, 0.45, arr.shape[0])[:, None, None]
                    canvas.paste(Image.fromarray((arr * fade).astype(np.uint8)), (0, h))
                    # weicher Übergang an der Nahtstelle
                    blend = 40
                    top = np.asarray(canvas.crop((0, h - blend, 1080, h + blend)).filter(ImageFilter.GaussianBlur(6)))
                    canvas.paste(Image.fromarray(top), (0, h - blend))
                    im = canvas
                os.makedirs(OUT, exist_ok=True)
                im.save(os.path.join(OUT, base + ".jpg"), quality=88, optimize=True)
    # 19 Auftragsbuch-Einzelseite (weiß) für das Hochformat
    a = load("ledger_page.jpg")
    sat = a.max(axis=2) - a.min(axis=2)
    save(to_rgba(a, flood_bg((a.min(axis=2) > 225) & (sat < 22)).astype(np.float32)), "ledger_page.png", max_w=760)

    # 20 App-Icon: quadratisch, 1024 (iOS) und 512 (Google Play), 192 für Godot/Android
    icon = Image.open(os.path.join(SRC, "app_icon.jpg")).convert("RGB")
    side = min(icon.size)
    icon = icon.crop(((icon.width - side) // 2, (icon.height - side) // 2, (icon.width + side) // 2, (icon.height + side) // 2))
    store = os.path.join(ROOT, "store")
    os.makedirs(store, exist_ok=True)
    icon.resize((1024, 1024), Image.LANCZOS).save(os.path.join(store, "app_icon_1024.png"))
    icon.resize((512, 512), Image.LANCZOS).save(os.path.join(store, "app_icon_512.png"))
    icon.resize((256, 256), Image.LANCZOS).save(os.path.join(ROOT, "icon.png"))
    # Store-Banner (Google Play Feature Graphic 1024 × 500)
    banner_src = os.path.join(store, "store_banner_source.jpg")
    if os.path.exists(banner_src):
        b = Image.open(banner_src).convert("RGB")
        h = int(round(b.width * 500 / 1024))
        top = max(0, (b.height - h) // 2)
        b.crop((0, top, b.width, top + h)).resize((1024, 500), Image.LANCZOS).save(os.path.join(store, "feature_graphic_1024x500.png"))
    # 21 Maschinen in Einzelteilen (weiß): Löcher (Speichen, Gitter, Lager) freistellen
    mdir = os.path.join(SRC, "machines")
    if os.path.isdir(mdir):
        for fn in sorted(os.listdir(mdir)):
            base, ext = os.path.splitext(fn)
            if ext.lower() not in (".webp", ".png", ".jpg", ".jpeg"):
                continue
            a = np.asarray(Image.open(os.path.join(mdir, fn)).convert("RGB")).astype(np.float32)
            if base == "engine_body":
                # eingemalten Balancier entfernen (das Spiel lässt einen eigenen wippen)
                a[:115, 680:965] = 255.0
            sat = a.max(axis=2) - a.min(axis=2)
            white = (a.min(axis=2) > 222) & (sat < 22)
            bg = flood_bg(white) | enclosed(white, 150)
            img = to_rgba(a, bg.astype(np.float32))
            if base in ("water_wheel", "flywheel"):
                # Drehteile: quadratisch um die Nabe (Bildmitte des Originals), damit sie sauber rotieren
                c = img.width // 2
                r = int(max(abs(np.array(img.getbbox()) - np.array([c, c, c, c]))))
                img = img.crop((c - r, c - r, c + r, c + r))
                save(img.resize((400, 400), Image.LANCZOS), "machine_" + base + ".png")
            else:
                save(img, "machine_" + base + ".png", max_w=700)
    derived()
    print("fertig:", sorted(os.listdir(OUT)))


# Hintergründe mit sehr tiefer Wand-Boden-Kante: so viele Pixel (Original) oben abschneiden
BG_TOP_CROP = {"background_10": 300}

HAMMER_IDS = ["hammer_hand", "hammer_cross_peen", "hammer_steel_faced", "hammer_crucible"]
HAMMER_W = 360   # Breite der Hammergrafik (wird im Spiel mit 0.62 gezeichnet)
ANVIL_W = 457    # Breite des Ambosses im Spiel (Horn bis Ende der Bahn)
# Amboss: Horn muss nach rechts zeigen – Originale mit Horn links werden gespiegelt
ANVIL_HORN_LEFT = True


def _cutout(path):
    a = np.asarray(Image.open(path).convert("RGB")).astype(np.float32)
    sat = a.max(axis=2) - a.min(axis=2)
    white = (a.min(axis=2) > 215) & (sat < 28)
    bg = flood_bg(white)
    solid = ~bg
    lab, n = ndimage.label(solid)
    if n > 1:
        sizes = ndimage.sum(solid, lab, range(1, n + 1))
        solid = np.isin(lab, [k + 1 for k, sz in enumerate(sizes) if sz >= 0.05 * sizes.max()])
    img = to_rgba(a, (~solid).astype(np.float32))
    return img.crop(img.getbbox())


def tool_import():
    """Amboss und Hämmer freistellen, auf Spielgröße bringen und vermessen:
    Amboss – Mitte und Oberkante der Bahn; Hammer – Griffpunkt (Stielende) und Mitte der Bahn (unten am Kopf)."""
    tdir = os.path.join(SRC, "tools")
    if not os.path.isdir(tdir):
        return
    lines = ["## Automatisch erzeugt von tools/art/import_user_art.py – nicht von Hand ändern.",
             "## Amboss: Mitte (x) und Oberkante (y) der Bahn. Hämmer: Griffpunkt, Mitte der Bahn, Richtung Kopf→Bahn (90° = unten).", ""]
    p = os.path.join(tdir, "anvil.png")
    if os.path.exists(p):
        img = _cutout(p)
        if ANVIL_HORN_LEFT:
            img = img.transpose(Image.FLIP_LEFT_RIGHT)
        img = img.resize((ANVIL_W, int(round(img.height * ANVIL_W / img.width))), Image.LANCZOS)
        al = np.asarray(img)[..., 3] > 128
        # Mitte der Bahn = Mitte des Holzklotzes (unteres Viertel), Oberkante = oberste Zeile über der Mitte
        low = np.where(al[int(img.height * 0.8):].any(axis=0))[0]
        cx = int((low[0] + low[-1]) / 2)
        col = al[:, max(0, cx - 20):cx + 20].any(axis=1)
        top = int(np.where(col)[0][0])
        save(img, "anvil.png")
        lines.append(f"const ANVIL := {{\"face\": Vector2({cx}, {top})}}")
    else:
        lines.append("const ANVIL := {}")
    lines.append("const HAMMERS := {")
    for hid in HAMMER_IDS:
        p = os.path.join(tdir, hid + ".png")
        if not os.path.exists(p):
            continue
        img = _cutout(p)
        img = img.resize((HAMMER_W, int(round(img.height * HAMMER_W / img.width))), Image.LANCZOS)
        al = np.asarray(img)[..., 3] > 128
        hcol = al.sum(axis=0)
        head = np.where(hcol > 0.5 * hcol.max())[0]
        hx0, hx1 = head[0], head[-1]
        # zusammenhängender Kopf links
        gaps = np.where(np.diff(head) > 3)[0]
        if len(gaps):
            hx1 = head[gaps[0]]
        face_x = int((hx0 + hx1) / 2)
        face_y = int(np.where(al[:, hx0:hx1 + 1].any(axis=1))[0][-1])
        gx = int(np.where(al.any(axis=0))[0][-1]) - 6
        gy = int(np.mean(np.where(al[:, gx - 10:gx])[0]))
        save(img, hid + ".png")
        lines.append(f'\t"{hid}": [Vector2({gx}, {gy}), Vector2({face_x}, {face_y}), 90.0],')
    lines.append("}")
    open(os.path.join(ROOT, "scripts", "user_tool_meta.gd"), "w", encoding="utf-8").write("\n".join(lines) + "\n")


FORGE_IDS = ["forge_clay", "forge_brick", "forge_double_bellows", "forge_coke", "forge_welding_furnace", "forge_siemens"]
FORGE_W = 920          # Breite im Spiel (Bühnen-Pixel)
FORGE_CENTER_X = 420   # Mitte der Esse im Koordinatensystem der Essen-Ansicht (wie bisher)
FORGE_TOP_Y = 118


def forge_import():
    """Essen freistellen, auf Spielbreite bringen und vermessen: Glutbett (Mitte, Breite) und
    Schornsteinmündung. Die Maße schreibt das Skript nach scripts/user_forge_meta.gd."""
    fdir = os.path.join(SRC, "forges")
    meta = {}
    for tier, fid in enumerate(FORGE_IDS, start=1):
        path = next((os.path.join(fdir, fid + e) for e in (".png", ".webp", ".jpg") if os.path.exists(os.path.join(fdir, fid + e))), None)
        if path is None:
            continue
        a = np.asarray(Image.open(path).convert("RGB")).astype(np.float32)
        sat = a.max(axis=2) - a.min(axis=2)
        white = (a.min(axis=2) > 215) & (sat < 28)
        bg = flood_bg(white) | enclosed(white, 4000)
        # dünne waagerechte Bodenlinien und Bodenflecken unter der Esse entfernen: Zeilen unten,
        # die nur schmal oder sehr niedrig gefüllt sind, gelten als Boden
        solid = ~bg
        lab, n = ndimage.label(solid)
        if n > 1:
            sizes = ndimage.sum(solid, lab, range(1, n + 1))
            keep = [k + 1 for k, sz in enumerate(sizes) if sz >= 0.05 * sizes.max()]
            solid = np.isin(lab, keep)
        img = to_rgba(a, (~solid).astype(np.float32))
        box = img.getbbox()
        img = img.crop(box)
        s = FORGE_W / img.width
        img = img.resize((FORGE_W, int(round(img.height * s))), Image.LANCZOS)
        arr = np.asarray(img).astype(np.float32)
        r, g, b, al = arr[..., 0], arr[..., 1], arr[..., 2], arr[..., 3]
        glow = (al > 200) & (r > 225) & (g > 90) & (g < 225) & (b < 120) & (r - b > 120)
        rows = glow.sum(axis=1)
        # Glutbett = unterste Zeile mit kräftiger Glut (Flammen darüber zählen nicht)
        strong = np.where(rows >= 0.35 * rows.max())[0]
        bed_y = int(strong[-1]) - 6 if len(strong) else int(np.argmax(rows))
        band = glow[max(0, bed_y - 12):bed_y + 12]
        xs = np.where(band.any(axis=0))[0]
        if len(xs) == 0:
            xs = np.array([img.width * 0.3, img.width * 0.7])
        lo, hi = np.percentile(xs, 3), np.percentile(xs, 97)
        top_rows = np.where((al > 128).any(axis=1))[0]
        ty = int(top_rows[0])
        cx = np.where(al[ty:ty + max(4, img.height // 30)] > 128)[1]
        ox = FORGE_CENTER_X - img.width / 2.0
        meta[tier] = {"file": fid + ".png", "origin": (round(ox), FORGE_TOP_Y),
                      "bed": (round(ox + (lo + hi) / 2), FORGE_TOP_Y + bed_y), "bed_w": round(float(hi - lo)),
                      "chimney": (round(ox + float(np.median(cx))), FORGE_TOP_Y + ty + 4)}
        save(img, fid + ".png")
    lines = ["## Automatisch erzeugt von tools/art/import_user_art.py – nicht von Hand ändern.",
             "## Essen-Grafiken des Auftraggebers: Zeichenursprung, Glutbett (Mitte/Breite) und Schornsteinmündung, lokal.",
             "", "const META := {"]
    for t, m in sorted(meta.items()):
        lines.append(f'\t{t}: {{"file": "{m["file"]}", "origin": Vector2{m["origin"]}, "bed": Vector2{m["bed"]}, '
                     f'"bed_w": {float(m["bed_w"])}, "chimney": Vector2{m["chimney"]}}},')
    lines.append("}")
    open(os.path.join(ROOT, "scripts", "user_forge_meta.gd"), "w", encoding="utf-8").write("\n".join(lines) + "\n")
    return meta


def item_sprite(path, item_id):
    """Werkstück auf Weiß → 256×256-Graustufen-Sprite (Rotkanal = Helligkeit, Glow-Shader färbt ein).
    Längstes Maß 200 px (runde Teile 150 px), Löcher (Ringe, Kettenglieder, Nagellöcher) durchsichtig."""
    a = np.asarray(Image.open(path).convert("RGB")).astype(np.float32)
    sat = a.max(axis=2) - a.min(axis=2)
    white = (a.min(axis=2) > 215) & (sat < 25)
    bg = flood_bg(white) | enclosed(white, 20)
    # Nur das Werkstück behalten: freistehende Reste (z. B. Kontur eines Sticker-Rands) entfernen
    lab, n = ndimage.label(~bg)
    if n > 1:
        sizes = ndimage.sum(~bg, lab, range(1, n + 1))
        keep = [k + 1 for k, sz in enumerate(sizes) if sz >= 0.3 * sizes.max()]
        bg = bg | ~np.isin(lab, keep)
    img = to_rgba(a, bg.astype(np.float32))
    img = img.crop(img.getbbox())
    longest = 150.0 if 0.75 < img.width / img.height < 1.33 else 200.0
    s = longest / max(img.width, img.height)
    img = img.resize((max(1, int(img.width * s)), max(1, int(img.height * s))), Image.LANCZOS)
    arr = np.asarray(img).astype(np.float32)
    lum = arr[..., :3].mean(axis=2)
    vis = arr[..., 3] > 128
    lo, hi = np.percentile(lum[vis], 2), np.percentile(lum[vis], 98)
    g = np.clip(0.12 + 0.88 * (lum - lo) / max(hi - lo, 1.0), 0, 1) * 255
    piece = Image.fromarray(np.dstack([g, g, g, arr[..., 3]]).astype(np.uint8), "RGBA")
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    canvas.alpha_composite(piece, ((256 - piece.width) // 2, (256 - piece.height) // 2))
    os.makedirs(OUT, exist_ok=True)
    canvas.save(os.path.join(OUT, "item_%s.png" % item_id), optimize=True)


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
    # Pergament für schmale Hochformat-Fenster: 60 % (Rand ca. 66 px statt 110 px)
    pa = Image.open(os.path.join(OUT, "panel_parchment.png"))
    save(pa.resize((int(pa.width * 0.6), int(pa.height * 0.6)), Image.LANCZOS), "panel_parchment_m.png")


if __name__ == "__main__":
    main()
