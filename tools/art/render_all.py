# -*- coding: utf-8 -*-
"""Erzeugt alle Grafik- und Audio-Assets neu (assets/…).

    pip install -r tools/art/requirements.txt   # zusätzlich: ffmpeg mit libvorbis
    python tools/art/render_all.py
"""
import props
import items
import backgrounds
import ui_art
import render_audio

if __name__ == "__main__":
    print("Requisiten …"); props.render_all()
    print("Gegenstände …"); items.render_all()
    print("Hintergründe …"); backgrounds.render_all()
    print("Porträts & UI …"); ui_art.render_all()
    print("Klänge & Musik …"); render_audio.render_all()
    print("fertig")
