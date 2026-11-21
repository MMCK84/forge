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


def find_src(name):
    """Pfad eines Originals; die Endung ist egal (eine neue Lieferung kann .png statt .webp/.jpg sein)."""
    p = os.path.join(SRC, name)
    if os.path.exists(p):
        return p
    base = os.path.splitext(p)[0]
    for e in (".png", ".webp", ".jpg", ".jpeg"):
        if os.path.exists(base + e):
            return base + e
    return p


def load(name):
    return np.asarray(Image.open(find_src(name)).convert("RGB")).astype(np.float32)


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
    # Midjourney (21.11.): schwarzer Grund mit leichtem Verlauf – dunkles Grau zählt mit
    bg = flood_bg(lum < 60)
    img = to_rgba(a, bg.astype(np.float32), 1.5)
    al = np.asarray(img).copy()
    al[..., 3] = np.where(bg, np.clip((lum - 8) / 30, 0, 1) * 255, al[..., 3])
    # Auf den deckenden Teil zuschneiden (sonst bleibt oben/seitlich ein halbdurchsichtiger Rand,
    # und die Fenstertitel säßen auf dem Messingrahmen)
    ys, xs = np.where(al[..., 3] > 128)
    al = al[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    save(Image.fromarray(al), "panel_parchment.png", max_w=900)

    # 2 Glut-Knopf (gemaltes Schachbrett)
    a = load("button_ember.webp")
    sat = a.max(axis=2) - a.min(axis=2)
    bg = flood_bg((sat < 16) & (a.mean(axis=2) > 95))
    save(to_rgba(a, bg.astype(np.float32)), "button_ember.png", max_w=700)

    # 3 Holzrahmen mit Eisenplatte (gemaltes Schachbrett)
    a = load("frame_wood_iron.webp")
    sat = a.max(axis=2) - a.min(axis=2)
    white = (sat < 14) & (a.mean(axis=2) > 150)
    # Midjourney-Rahmen (21.11.) ist innen offen: die weiße Innenfläche ebenfalls freistellen
    bg = flood_bg(white) | enclosed(white, 20000)
    save(to_rgba(a, bg.astype(np.float32)), "frame_wood_iron.png", max_w=700)

    # 4 Pyrometer (weiß); eingeschlossene weiße Flächen im Bogen ebenfalls entfernen
    a = load("pyrometer_dial.png" if os.path.exists(find_src("pyrometer_dial.png")) else "pyrometer.webp")
    white = a.min(axis=2) > 232
    bg = flood_bg(white) | enclosed(white, 400)
    save(to_rgba(a, bg.astype(np.float32)), "pyrometer_dial.png", max_w=700)

    # 5 Zeiger: einzelnen Zeiger aus dem Sheet (oben links), Durchbrüche freistellen
    a = load("pointer_sheet.webp")
    if a.shape[0] == a.shape[1]:
        # Midjourney (21.11.): einzelner Zeiger senkrecht, Zierkopf oben, Spitze unten → waagerecht drehen
        # (Spitze rechts) und so einpassen, dass die Nabe bei (100, 48) liegt wie bisher (glow_scale.gd)
        white = (a.min(axis=2) > 215) & ((a.max(axis=2) - a.min(axis=2)) < 28)
        nd = to_rgba(a, (flood_bg(white) | enclosed(white, 30)).astype(np.float32))
        nd = nd.crop(nd.getbbox()).rotate(90, expand=True)
        al = np.asarray(nd)[..., 3] > 100
        cols = al.sum(axis=0)
        left = cols[: int(len(cols) * 0.4)]
        hub = int(np.argmax(left))
        scale = 230.0 / max(1, nd.width - hub)
        nd = nd.resize((max(1, int(nd.width * scale)), max(1, int(nd.height * scale))), Image.LANCZOS)
        hub = int(hub * scale)
        rows = np.where((np.asarray(nd)[..., 3] > 100).any(axis=1))[0]
        cy = int((rows[0] + rows[-1]) / 2)
        canvas = Image.new("RGBA", (330, 96), (0, 0, 0, 0))
        canvas.alpha_composite(nd, (100 - hub, 48 - cy)) if 100 - hub >= 0 and 48 - cy >= 0 else canvas.paste(nd, (100 - hub, 48 - cy), nd)
        save(canvas, "pyrometer_needle.png")
    else:
        a = a[95:200, 30:360]
        white = a.min(axis=2) > 225
        bg = flood_bg(white) | enclosed(white, 30)
        save(to_rgba(a, bg.astype(np.float32)), "pyrometer_needle.png")

    # 6 Leder-Messing-Knöpfe (weiß): 4 Varianten
    a = load("buttons_leather_brass.webp")
    # Midjourney (21.11.): heller Schlagschatten um die Knöpfe – hellgrau zählt mit zum Hintergrund
    sat = a.max(axis=2) - a.min(axis=2)
    bg = flood_bg((a.min(axis=2) > 200) & (sat < 30))
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
    sat = a.max(axis=2) - a.min(axis=2)
    # Midjourney (21.11.): hellgrauer Grund mit Schatten – hellgrau zählt mit
    bg = flood_bg(((a.min(axis=2) > 238)) | ((a.min(axis=2) > 195) & (sat < 22)))
    seals = objects(to_rgba(a, bg.astype(np.float32)))
    # Reihenfolge der Objekte: (Zeile, x) – Gemini-Blatt oben: Victoria, George III, Admiralty; unten: Louis XV, Russland.
    # Midjourney-Blatt (21.11.): links George III, rechts Admiralität – das linke zeigt einen Doppeladler statt des
    # Monogramms GR und wird nicht übernommen (bisheriges Siegel bleibt, bis Ersatz kommt)
    names = {0: "seal_victoria.png", 1: "seal_george_iii.png", 2: "seal_admiralty.png"}
    if len(seals) == 2:
        names = {1: "seal_admiralty.png"}
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
    # Meisterschafts-Siegel Bronze/Silber/Gold (weiß): seal_mastery_<stufe>
    for k in (1, 2, 3):
        name = "seal_mastery_%d" % k
        if os.path.exists(find_src(name + ".png")):
            a = load(name + ".png")
            sat = a.max(axis=2) - a.min(axis=2)
            bg = flood_bg((a.min(axis=2) > 205) & (sat < 25))
            save(to_rgba(a, bg.astype(np.float32)), name + ".png", max_w=160)
    # Sterne (voll, leer), Sanduhr, Löschtrog, Victoria-Münzen (Midjourney, weiß)
    if os.path.exists(find_src("stars.png")):
        a = load("stars.png")
        sat = a.max(axis=2) - a.min(axis=2)
        white = (a.min(axis=2) > 215) & (sat < 28)
        pieces = objects(to_rgba(a, (flood_bg(white) | enclosed(white, 200)).astype(np.float32)))
        for piece, name in zip(pieces, ["star_full.png", "star_empty.png"]):
            save(piece, name, max_w=96)
    for src, name, mw in (("hourglass.png", "icon_hourglass.png", 96), ("trough.png", "trough.png", 420)):
        if os.path.exists(find_src(src)):
            save(_cutout(find_src(src)), name, max_w=mw)
    if os.path.exists(find_src("coins_victoria.png")):
        a = load("coins_victoria.png")
        sat = a.max(axis=2) - a.min(axis=2)
        pieces = [p for p in objects(to_rgba(a, flood_bg((a.min(axis=2) > 200) & (sat < 30)).astype(np.float32))) if p.height > 150]
        for piece, name in zip(pieces, ["coin_victoria_sovereign.png", "coin_victoria_shilling.png", "coin_victoria_penny.png"]):
            save(piece, name, max_w=128)
    # 11 Amboss und 14 Hämmer (Midjourney, weiß): assets/source/user_art/tools/ – vermessen nach scripts/user_tool_meta.gd
    tool_import()

    # 12/13 Essen in Frontalansicht (Midjourney, weiß): assets/source/user_art/forges/<forge_id>.png
    forge_import()
    # 22 Werkstatt-Einrichtung (weiß): assets/source/user_art/furnishings/furn_e<E>_<platz>.png
    fdir = os.path.join(SRC, "furnishings")
    if os.path.isdir(fdir):
        for fn in sorted(os.listdir(fdir)):
            base, ext = os.path.splitext(fn)
            if ext.lower() in (".png", ".webp", ".jpg", ".jpeg") and base.startswith("furn_"):
                save(_cutout(os.path.join(fdir, fn)), base + ".png", max_w=420, max_h=420)
    # 16 Wasser-Schwanzhammer (weiß) als Bild im Laden
    for mid in ("water_helve", "steam_helve", "nasmyth", "great_steam_hammer"):
        if os.path.exists(find_src(mid + ".png")):
            a = load(mid + ".png")
            sat = a.max(axis=2) - a.min(axis=2)
            save(to_rgba(a, flood_bg((a.min(axis=2) > 222) & (sat < 20)).astype(np.float32)), "machine_" + mid + ".png", max_w=360)
    # 23 Kundenporträts im ovalen Rahmen (weiß außen): assets/source/user_art/portraits/portrait_<kunde>.png
    pdir = os.path.join(SRC, "portraits")
    if os.path.isdir(pdir):
        for fn in sorted(os.listdir(pdir)):
            base, ext = os.path.splitext(fn)
            if ext.lower() in (".png", ".webp", ".jpg", ".jpeg") and base.startswith("portrait_"):
                img = _cutout(os.path.join(pdir, fn))
                save(img.resize((PORTRAIT_W, int(round(img.height * PORTRAIT_W / img.width))), Image.LANCZOS), base + ".png")

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
                # 3:4-Ausschnitt; zusätzlich eine breite Fassung (volle Bildbreite, gleicher Maßstab) für
                # breite Fenster/Querformat – background_N_wide.jpg
                square = im.width > im.height * 0.78
                cw = int(round(im.height * 3 / 4)) if square else im.width
                scale = 1080.0 / cw
                os.makedirs(OUT, exist_ok=True)
                if square:
                    x0 = (im.width - cw) // 2
                    bg_variant(im.crop((x0, 0, x0 + cw, im.height)), base, scale, True).save(os.path.join(OUT, base + ".jpg"), quality=88, optimize=True)
                    bg_variant(im, base, scale, True).save(os.path.join(OUT, base + "_wide.jpg"), quality=85, optimize=True)
                else:
                    bg_variant(im, base, scale, False).save(os.path.join(OUT, base + ".jpg"), quality=88, optimize=True)
    # 19 Auftragsbuch-Einzelseite (weiß) für das Hochformat
    a = load("ledger_page.jpg")
    sat = a.max(axis=2) - a.min(axis=2)
    save(to_rgba(a, flood_bg((a.min(axis=2) > 225) & (sat < 22)).astype(np.float32)), "ledger_page.png", max_w=760)

    # 20 App-Icon: quadratisch, 1024 (iOS) und 512 (Google Play), 192 für Godot/Android
    icon = Image.open(find_src("app_icon.jpg")).convert("RGB")
    side = min(icon.size)
    icon = icon.crop(((icon.width - side) // 2, (icon.height - side) // 2, (icon.width + side) // 2, (icon.height + side) // 2))
    store = os.path.join(ROOT, "store")
    os.makedirs(store, exist_ok=True)
    icon.resize((1024, 1024), Image.LANCZOS).save(os.path.join(store, "app_icon_1024.png"))
    icon.resize((512, 512), Image.LANCZOS).save(os.path.join(store, "app_icon_512.png"))
    icon.resize((256, 256), Image.LANCZOS).save(os.path.join(ROOT, "icon.png"))
    # Store-Banner (Google Play Feature Graphic 1024 × 500)
    banner_src = find_src("store_banner.png") if os.path.exists(find_src("store_banner.png")) else os.path.join(store, "store_banner_source.jpg")
    if os.path.exists(banner_src):
        b = Image.open(banner_src).convert("RGB")
        h = int(round(b.width * 500 / 1024))
        top = max(0, (b.height - h) // 2)
        b.crop((0, top, b.width, top + h)).resize((1024, 500), Image.LANCZOS).save(os.path.join(store, "feature_graphic_1024x500.png"))
    # 21 Maschinen in Einzelteilen (weiß): Löcher (Speichen, Gitter, Lager) freistellen;
    # Lager, Hammerkopf und Gestell-Lager werden vermessen (scripts/user_machine_meta.gd)
    mdir = os.path.join(SRC, "machines")
    mmeta = {}
    if os.path.isdir(mdir):
        for fn in sorted(os.listdir(mdir)):
            base, ext = os.path.splitext(fn)
            if ext.lower() not in (".webp", ".png", ".jpg", ".jpeg"):
                continue
            a = np.asarray(Image.open(os.path.join(mdir, fn)).convert("RGB")).astype(np.float32).copy()
            sat = a.max(axis=2) - a.min(axis=2)
            white = (a.min(axis=2) > 222) & (sat < 22)
            bg = flood_bg(white) | enclosed(white, 150)
            solid = ~bg
            lab, n = ndimage.label(solid)
            if n > 1:
                sizes = ndimage.sum(solid, lab, range(1, n + 1))
                solid = np.isin(lab, [k + 1 for k, sz in enumerate(sizes) if sz >= 0.02 * sizes.max()])
            img = to_rgba(a, (~solid).astype(np.float32))
            if base in ("water_wheel", "flywheel"):
                # Drehteile: quadratisch um die Nabe (Mitte des Umrisses), damit sie sauber rotieren
                x0, y0, x1, y1 = img.getbbox()
                cx, cy = (x0 + x1) // 2, (y0 + y1) // 2
                r = max(x1 - cx, cx - x0, y1 - cy, cy - y0)
                img = img.crop((cx - r, cy - r, cx + r, cy + r))
                save(img.resize((400, 400), Image.LANCZOS), "machine_" + base + ".png")
                continue
            img = save(img, "machine_" + base + ".png", max_w=700, max_h=1400)
            al = np.asarray(img)[..., 3] > 128
            if base == "helve_beam":
                cols = np.where(al.any(axis=0))[0]
                top = np.array([np.argmax(al[:, x]) if al[:, x].any() else 0 for x in range(img.width)])
                bot = np.array([img.height - 1 - np.argmax(al[::-1, x]) if al[:, x].any() else 0 for x in range(img.width)])
                thick = np.where(al.any(axis=0), bot - top, 0)
                med = np.median(thick[cols])
                head = [x for x in cols if thick[x] > 1.6 * med and x > img.width * 0.6]
                hx = int(np.mean(head)) if head else int(img.width * 0.92)
                hy = int(max(bot[x] for x in head)) if head else int(img.height * 0.9)
                body = [x for x in cols if x < img.width * 0.6]
                axis_y = int(np.median([(top[x] + bot[x]) / 2 for x in body]))
                boss = [x for x in body if thick[x] > 1.25 * med]
                px = int(np.mean(boss)) if boss else int(cols[0] + img.width * 0.06)
                mmeta["BEAM_PIVOT"] = (px, axis_y)
                mmeta["BEAM_HEAD"] = (hx, hy)
            elif base == "engine_body":
                # Kolbenstange (höchster Punkt links) und Säulenkopf (höchster Punkt rechts) – dort sitzt der Balancier
                top = np.array([np.argmax(al[:, x]) if al[:, x].any() else img.height for x in range(img.width)])
                half = img.width // 2
                rx = int(np.argmin(top[:half]))
                cols = np.where(top[half:] == top[half:].min())[0] + half
                mmeta["ENGINE_ROD"] = (rx, int(top[rx]))
                mmeta["ENGINE_PIVOT"] = (int(np.median(cols)), int(top[half:].min()) + 4)
                mmeta["ENGINE_SIZE"] = (img.width, img.height)
            elif base == "engine_beam":
                cols = np.where(al.any(axis=0))[0]
                rows = np.where(al.any(axis=1))[0]
                cx = int((cols[0] + cols[-1]) / 2)
                cy = int(np.mean(np.where(al[:, cx - 3:cx + 3].any(axis=1))[0]))
                end_h = int(al[:, cols[-1] - 4:cols[-1] + 1].any(axis=1).sum())
                mmeta["ENGINE_BEAM_PIVOT"] = (cx, cy)
                mmeta["ENGINE_BEAM_HALF"] = (float(cols[-1] - cx - end_h * 0.5), 0.0)
            elif base == "helve_frame":
                ys = np.where(al.any(axis=1))[0]
                ty = int(ys[0])
                xs = np.where(al[ty:ty + max(4, img.height // 40)].any(axis=0))[0]
                mmeta["FRAME_BEARING"] = (int(np.median(xs)), ty + 6)
                mmeta["FRAME_HEIGHT"] = (img.width, img.height)
    lines = ["## Automatisch erzeugt von tools/art/import_user_art.py – nicht von Hand ändern.",
             "## Schwanzhammer: Lagerloch und Hammerkopf (Unterkante) im Balken, Lager oben auf dem Gestell, Größe des Gestells.", "",
             "const META := {"]
    for k, v in mmeta.items():
        lines.append(f'\t"{k}": Vector2{v},')
    lines.append("}")
    open(os.path.join(ROOT, "scripts", "user_machine_meta.gd"), "w", encoding="utf-8").write("\n".join(lines) + "\n")
    derived()
    print("fertig:", sorted(os.listdir(OUT)))


def bg_variant(im, base, scale, square):
    """Hintergrund auf Bühnenhöhe 1920 bringen: zu tiefe Kante oben beschneiden (BG_TOP_CROP), einfarbigen
    Streifen unten entfernen, mit `scale` skalieren und den dunklen Boden nach unten verlängern."""
    top = BG_TOP_CROP.get(base, 0)
    if top:
        im = im.crop((0, top, im.width, im.height))
    # Einfarbigen Balken am unteren Rand (Midjourney malt manchmal einen) abschneiden – gemessen in der Bildmitte
    g = np.asarray(im.convert("L")).astype(np.float32)
    mid = g[:, int(im.width * 0.2):int(im.width * 0.8)]
    cut = im.height
    while square and cut > im.height * 0.7 and mid[cut - 1].std() < 4.0:
        cut -= 1
    if cut < im.height - 4:
        im = im.crop((0, 0, im.width, cut - 2))
    w = int(round(im.width * scale))
    h = int(round(im.height * scale))
    im = im.resize((w, h), Image.LANCZOS)
    if h >= 1920:
        return im.crop((0, 0, w, 1920))
    # Kürzere Bilder: Boden nach unten verlängern – die untersten Zeilen strecken und zum Rand hin
    # abdunkeln (dort liegt im Spiel das Bedienfeld)
    canvas = Image.new("RGB", (w, 1920))
    canvas.paste(im, (0, 0))
    strip = im.crop((0, h - 24, w, h)).filter(ImageFilter.GaussianBlur(18)).resize((w, 1920 - h), Image.BILINEAR)
    arr = np.asarray(strip).astype(np.float32)
    fade = np.linspace(1.0, 0.45, arr.shape[0])[:, None, None]
    canvas.paste(Image.fromarray((arr * fade).astype(np.uint8)), (0, h))
    blend = 40
    seam = np.asarray(canvas.crop((0, h - blend, w, h + blend)).filter(ImageFilter.GaussianBlur(6)))
    canvas.paste(Image.fromarray(seam), (0, h - blend))
    return canvas


# Hintergründe mit sehr tiefer Wand-Boden-Kante: so viele Pixel (Original) oben abschneiden
BG_TOP_CROP = {"background_10": 300}

PORTRAIT_W = 300   # Breite der Porträts (Auftragsbuch)

HAMMER_IDS = ["hammer_hand", "hammer_cross_peen", "hammer_steel_faced", "hammer_crucible"]
HAMMER_W = 360   # Breite der Hammergrafik (wird im Spiel mit 0.62 gezeichnet)
ANVIL_W = 457    # Breite des Ambosses im Spiel (Horn bis Ende der Bahn)
# Amboss: Horn muss nach rechts zeigen – Originale mit Horn links werden gespiegelt
ANVIL_HORN_LEFT = True


def _cutout(path):
    a = np.asarray(Image.open(path).convert("RGB")).astype(np.float32)
    sat = a.max(axis=2) - a.min(axis=2)
    white = (a.min(axis=2) > 215) & (sat < 28)
    # Eingeschlossene Flächen (Henkel, Aufhängung, zwischen Beinen) nur bei reinem Weiß freistellen,
    # damit helle Teile des Objekts (Schleifstein, Glas) bleiben
    pure = (a.min(axis=2) > 238) & (sat < 12)
    bg = flood_bg(white) | enclosed(pure, 1500)
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
# Rauch über dem Schornstein, den Midjourney trotz „no smoke“ malt: Rechtecke (x0, y0, x1, y1) im Original
# werden vor dem Freistellen weiß gefüllt (das Spiel erzeugt eigenen Rauch)
FORGE_SMOKE = {
    "forge_double_bellows": [(1950, 0, 3104, 140)],
    "forge_siemens": [(1950, 0, 2230, 118), (2230, 0, 3104, 232)],
}


def forge_import():
    """Essen freistellen, auf Spielbreite bringen und vermessen: Glutbett (Mitte, Breite) und
    Schornsteinmündung. Die Maße schreibt das Skript nach scripts/user_forge_meta.gd."""
    fdir = os.path.join(SRC, "forges")
    meta = {}
    for tier, fid in enumerate(FORGE_IDS, start=1):
        path = next((os.path.join(fdir, fid + e) for e in (".png", ".webp", ".jpg") if os.path.exists(os.path.join(fdir, fid + e))), None)
        if path is None:
            continue
        a = np.asarray(Image.open(path).convert("RGB")).astype(np.float32).copy()
        for x0, y0, x1, y1 in FORGE_SMOKE.get(fid, []):
            a[y0:y1, x0:x1] = 255.0
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
        # Gezeichnete Bodenlinie (dicke schwarze Tuschelinie unter der Esse) abschneiden: unterste Zeilen,
        # die fast schwarz sind und über die halbe Breite reichen
        arr0 = np.asarray(img).astype(np.float32)
        h0 = arr0.shape[0]
        cut = h0
        dark_rows = []
        for y in range(h0 - 1, int(h0 * 0.97), -1):
            op = arr0[y, :, 3] > 100
            if op.sum() > 0.5 * arr0.shape[1] and arr0[y, op, :3].mean() < 20:
                dark_rows.append(y)
        if len(dark_rows) >= 3:
            cut = min(dark_rows)
        if cut < arr0.shape[0]:
            img = img.crop((0, 0, img.width, cut))
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
    # Grauer Grund mit Verlauf (Midjourney, Ecken dunkler): helles Grau vom Rand aus ebenfalls Hintergrund
    grey = (a.mean(axis=2) > 175) & (sat < 18)
    bg = flood_bg(white | grey) | enclosed(white, 20)
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
    fr = fr.resize((int(fr.width * s), int(fr.height * s)), Image.LANCZOS)
    # Offene Mitte des Rahmens dunkel füllen (die Leiste trägt Text): durchsichtige Pixel, die nicht vom Rand
    # aus erreichbar sind, bekommen dunkles Holz
    al = np.asarray(fr)[..., 3]
    inside = ~flood_bg(al < 40) & (al < 250)
    if inside.sum() > 0.2 * al.size:
        fill = Image.new("RGBA", fr.size, (0, 0, 0, 0))
        fa = np.asarray(fill).copy()
        fa[inside] = (43, 30, 21, 240)
        fr = Image.alpha_composite(Image.fromarray(fa), fr)
    save(fr, "hud_bar.png")
    # Großer HAMMERN-Knopf: Glut-Knopf im Originalformat (Hammer im Zahnrad), 2x Anzeigegröße
    em = Image.open(os.path.join(OUT, "button_ember.png"))
    w = 440
    states(em.resize((w, int(em.height * w / em.width)), Image.LANCZOS), "ember")
    # Pergament für schmale Hochformat-Fenster: 60 % (Rand ca. 66 px statt 110 px)
    pa = Image.open(os.path.join(OUT, "panel_parchment.png"))
    save(pa.resize((int(pa.width * 0.6), int(pa.height * 0.6)), Image.LANCZOS), "panel_parchment_m.png")


if __name__ == "__main__":
    main()
