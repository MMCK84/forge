"""Bildaufbau-Vorlage für die Werkstatt-Hintergründe (Bild-Prompt in Midjourney), Format 1:1.

Deckenbalken oben 15 %, Wand bis 55 %, darunter Boden. Fenster und alles Wichtige in den mittleren
drei Vierteln (= Hochformat-Ausschnitt 3:4), die äußeren Achtel nur Wand und Boden (Querformat).
Keine Hilfslinien – Midjourney würde sie abmalen.
    python tools/art/make_bg_template.py
"""
import os

from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, "assets", "source", "user_art", "vorlagen", "bildaufbau_hintergrund.png")
S = 1088
BEAMS, EDGE = int(S * 0.15), int(S * 0.55)


def main():
    im = Image.new("RGB", (S, S), (52, 38, 30))
    d = ImageDraw.Draw(im)
    # Deckenbalken
    d.rectangle((0, 0, S, BEAMS), fill=(52, 38, 30))
    for x in range(0, S, 136):
        d.rectangle((x, 0, x + 28, BEAMS), fill=(70, 52, 38))
    # Ziegelwand
    d.rectangle((0, BEAMS, S, EDGE), fill=(122, 74, 50))
    row = 0
    for y in range(BEAMS, EDGE, 26):
        off = 40 if row % 2 else 0
        d.line((0, y, S, y), fill=(104, 62, 42), width=2)
        for x in range(-off, S, 80):
            d.line((x, y, x, min(y + 26, EDGE)), fill=(104, 62, 42), width=2)
        row += 1
    # Feuerschein in der Wandmitte
    glow = Image.new("L", (S, S), 0)
    ImageDraw.Draw(glow).ellipse((S * 0.28, EDGE - S * 0.30, S * 0.72, EDGE + S * 0.08), fill=150)
    glow = glow.filter(ImageFilter.GaussianBlur(90))
    im = Image.composite(Image.new("RGB", (S, S), (205, 128, 64)), im, glow)
    d = ImageDraw.Draw(im)
    # Fenster: ein Viertel der Breite vom linken Rand, direkt unter den Balken
    wx0, wy0 = int(S * 0.17), BEAMS + int(S * 0.02)
    wx1, wy1 = wx0 + int(S * 0.20), wy0 + int(S * 0.23)
    d.rectangle((wx0, wy0, wx1, wy1), fill=(40, 30, 26))
    d.rectangle((wx0 + 8, wy0 + 8, wx1 - 8, wy1 - 8), fill=(150, 176, 192))
    d.line(((wx0 + wx1) // 2, wy0, (wx0 + wx1) // 2, wy1), fill=(40, 30, 26), width=7)
    d.line((wx0, (wy0 + wy1) // 2, wx1, (wy0 + wy1) // 2), fill=(40, 30, 26), width=7)
    # Wand-Boden-Kante und Boden mit Fluchtlinien, nach unten dunkler
    d.rectangle((0, EDGE, S, S), fill=(78, 60, 50))
    for i in range(S):
        if i > EDGE:
            t = (i - EDGE) / (S - EDGE)
            c = tuple(int(v * (1 - 0.45 * t)) for v in (84, 64, 54))
            d.line((0, i, S, i), fill=c)
    cx = S // 2
    for k in range(-9, 10):
        d.line((cx + k * 70, EDGE, cx + k * 260, S), fill=(58, 44, 38), width=2)
    y, step = EDGE, 18
    while y < S:
        d.line((0, y, S, y), fill=(58, 44, 38), width=2)
        y += step
        step = int(step * 1.35)
    d.line((0, EDGE, S, EDGE), fill=(40, 28, 22), width=4)
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    im.save(OUT)
    print(OUT, im.size)


if __name__ == "__main__":
    main()
