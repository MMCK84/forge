"""Setzt eine Vorschau der Spielszene aus den gerenderten Assets zusammen (nur zur Sichtprüfung)."""
import sys
import numpy as np
from PIL import Image
from common import ROOT
A = ROOT + "/assets/sprites/"


def load(p):
    return Image.open(A + p).convert("RGBA")


def tint(img, temp):
    """Python-Nachbildung des Glow-Shaders (für die Vorschau)."""
    stops = [(20, (107, 107, 112)), (450, (92, 84, 84)), (500, (84, 26, 18)), (600, (133, 15, 10)), (700, (191, 20, 15)), (800, (235, 46, 26)),
             (900, (255, 92, 26)), (1000, (255, 133, 31)), (1100, (255, 173, 46)), (1200, (255, 224, 82)), (1300, (255, 247, 191)), (1450, (255, 255, 255))]
    for i in range(1, len(stops)):
        if temp <= stops[i][0]:
            t0, c0 = stops[i - 1]; t1, c1 = stops[i]
            k = (temp - t0) / (t1 - t0)
            glow = np.array(c0) + (np.array(c1) - np.array(c0)) * k
            break
    s = min(max((temp - 450) / 850, 0), 1)
    a = np.asarray(img, np.float32)
    lum = a[..., 0:1] / 255
    cold = (np.array([0.30, 0.31, 0.34]) + np.array([0.55, 0.55, 0.58]) * lum) * 255
    hot = glow * (0.15 + 1.1 * lum) + glow * s * 0.25
    out = cold * (1 - s) + hot * s
    a[..., :3] = np.clip(out, 0, 255)
    return Image.fromarray(a.astype(np.uint8), "RGBA")


def compose(epoch, forge_tier, item="horseshoe", temp=950, path=None):
    bg = Image.open(A + f"environment/background_{epoch}.jpg").convert("RGBA")
    bg.alpha_composite(load(f"environment/forge_{forge_tier}.png"), (150 - 160, 120 - 160))
    glow = load("environment/fire_glow.png")
    bg.alpha_composite(glow, (150 + 440 - 380, 120 + 395 - 230))
    bg.alpha_composite(load("environment/coals.png"), (150 + 140, 120 + 340))
    if forge_tier < 4:
        bg.alpha_composite(load("tools/bellows.png"), (150 - 130, 120 + 380))
    bg.alpha_composite(load("tools/anvil.png"), (960 - 10, 330 - 10))
    if epoch >= 4:
        bg.alpha_composite(load("tools/trough.png"), (1540 - 10, 560 - 10))
    it = tint(load(f"items/{item}.png"), temp).resize((200, 200), Image.LANCZOS)
    bg.alpha_composite(it, (1230 - 100, 468 - 100))
    it2 = tint(load(f"items/blank.png"), 1050).resize((160, 160), Image.LANCZOS)
    bg.alpha_composite(it2, (150 + 440 - 80, 120 + 395 - 80))
    bg.convert("RGB").save(path or f"/tmp/preview_{epoch}.png")


if __name__ == "__main__":
    compose(int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], float(sys.argv[4]), sys.argv[5])
