# -*- coding: utf-8 -*-
"""Sortiert die Lieferungen im Eingang anhand des Kürzels im Dateinamen ein (Kürzel siehe Prompt-Heft):

    python tools/art/sort_inbox.py          # zeigt nur an, was passieren würde
    python tools/art/sort_inbox.py --move   # verschiebt (git mv) in den Zielordner mit der Bild-ID als Namen

Kürzel → (ID, Zielordner) aus assets/source/user_art/codes.json (erzeugt von gen_prompt_book.py).
Groß-/Kleinschreibung, „_“ statt „-“ und Vorsilben wie „WSE“ (statt „W“) werden toleriert.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SRC = os.path.join(ROOT, "assets", "source", "user_art")
INBOX = os.path.join(SRC, "eingang")
# Ziele, deren Dateiname nicht der ID entspricht
SPECIAL = {"backgrounds": lambda i: i}


def norm(code):
    c = code.upper().replace("_", "-").replace(" ", "")
    c = re.sub(r"^WSE", "W", c)
    c = re.sub(r"^BG-", "BG", c)
    return c


def main():
    codes = {norm(k): v for k, v in json.load(open(os.path.join(SRC, "codes.json"), encoding="utf-8")).items()}
    move = "--move" in sys.argv
    unknown = []
    for fn in sorted(os.listdir(INBOX)):
        base, ext = os.path.splitext(fn)
        if ext.lower() not in (".png", ".webp", ".jpg", ".jpeg"):
            continue
        c = norm(base)
        if c not in codes:
            unknown.append(fn)
            continue
        info = codes[c]
        dest_dir = os.path.join(SRC, info["dir"]) if info["dir"] else SRC
        dest = os.path.join(dest_dir, info["id"] + ext.lower())
        print(f"{fn:24s} → {os.path.relpath(dest, ROOT)}")
        if move:
            os.makedirs(dest_dir, exist_ok=True)
            # ältere Fassung desselben Bildes (andere Endung) entfernen
            for e in (".png", ".webp", ".jpg", ".jpeg"):
                old = os.path.join(dest_dir, info["id"] + e)
                if os.path.exists(old) and old != dest:
                    subprocess.run(["git", "rm", "-q", old], cwd=ROOT)
            subprocess.run(["git", "mv", "-f", os.path.join(INBOX, fn), dest], cwd=ROOT, check=True)
    for fn in unknown:
        print(f"{fn:24s} → ? unbekanntes Kürzel")


if __name__ == "__main__":
    main()
