# Projektstatus Forge Workshop

Stand: 20.11.2026 · Branch `claude/sharp-rubin-jfnibw` · Godot 4.7.2

**Prompts für alle Bilder:** `assets/source/user_art/PROMPTS_Hochformat.md` (186 Bilder, nach jeder Lieferung neu erzeugt).

## Kurzüberblick

Inkrementelles Schmiede-Spiel (England, 1700–1880) in Godot 4 / GDScript, **Hochformat (Mobile)**,
Entwicklung am PC. Ziel: kommerzielle Veröffentlichung (Android). Der Android-Export kommt erst,
wenn alles fertig ist.

## Fertig

- **Hochformat-Umbau:** Viewport 720×1280, Bühne in 1080×1920 gezeichnet und eingepasst; Statusleiste oben,
  Navigationsleiste unten (Aufträge, Laden, Personal, Statistik), Bedienfeld 720×380 über der Navigation.
- **10 Epochen** (1700–1880), Inhalte 1–6 in `data/`, 7–10 in `tools/content/epochs_7_10.py`
  (32 Werkstücke, 22 Kunden, 36 Meilensteine, Heizer-Personal, Essen-Stufe 5/6, Nasmyth- und großer Dampfhammer).
- **Schlagstärke** (leicht/mittel/schwer) in allen Epochen: je Arbeitsschritt eine passende Stärke,
  Tutorial-Aufträge ohne, in Epoche 1 nur mittel/schwer; Schwanzhammer/Zuschläger nur bei schweren Schritten
  (große Schmiedestücke: alle Schritte); Dampfhammer schlägt mit gewählter Stärke und hält bei zwei Stufen zu hart an.
- **Balancing** mit `tools/tune_balance.py`: Gesamtspielzeit ca. 13,6 h
  (Minuten je Epoche 12.8/25.1/56.9/83.3/130.9/157.5/77.2/85.2/90.2/96.3).
- **Ton:** Musik der Epochen 7–10, Dampfhammer-Klang, Tonhöhe/Lautstärke nach Schlagstärke.
- **Grafiken des Auftraggebers** eingebunden (Import-Pipeline `tools/art/import_user_art.py`):
  Hintergründe, Essen 1–4, Amboss, 4 Hämmer (Seitenansicht), Maschinenteile (Schwanzhammer, Wasserrad,
  Dampfmaschine), 9 Werkstücke Epoche 1, UI (Pergament, Knöpfe, Rahmen, Glut-Knopf, Siegel, Münzen,
  Pyrometer, Auftragsbuch-Seite), App-Icon und Store-Banner.
- **Prompt-Heft** `assets/source/user_art/PROMPTS_Hochformat.md` (Generator `tools/content/gen_prompt_book.py`):
  alle Bilder mit Midjourney-Prompt, ID am Anfang jedes Prompts, Regler-Einstellung, Status, Erkenntnis-Tabelle.
- **Tests:** Unit-Tests grün (1658 Prüfungen, 0 Fehler, 20.11.); grafischer Spieltest bis Epoche 10.

## Bildstatus (Prompt-Heft)

| Bereich | gut (MJ) | MJ ändern | Gemini | fehlt |
|---|---|---|---|---|
| A Hintergründe (3:4) | 1 (Ep. 1) | 1 (Ep. 7) | 5 (Ep. 2–6) | 3 (Ep. 8–10) |
| B Essen (frontal) | – | – | 4 (Schrägansicht) | 2 (Stufe 5, 6) |
| C Amboss, Hämmer | – | – | 5 | – |
| D Maschinenteile | – | – | 7 | 7 (u. a. Dampfhammer) |
| E Werkstücke | – | – | 9 | 72 (Epochen 2–10) |
| F Kundenporträts (optional) | – | – | – | 54 |
| G Oberfläche, Store | – | – | 12 | 5 |

Alle Gemini-Bilder sollen später durch Midjourney ersetzt werden.

## Arbeitsweise mit Bildern (Midjourney v8.2)

- Jede Lieferung: Original nach `assets/source/user_art/` (`items/`, `machines/`, `backgrounds/`),
  `python tools/art/import_user_art.py`, Herkunft/Bewertung in `provenance.json`, Heft neu erzeugen.
- Erkenntnisse sofort in **alle** betroffenen Prompts (gemeinsame Bausteine und `LESSONS` im Generator).
- **Hintergründe im Format 3:4** (Regler „Portrait 3:4“, er überstimmt `--ar`). Wand-Boden-Kante bei 50–65 %
  ist in Ordnung; der Import verlängert den Boden auf 1080×1920. Kante je Epoche ausmessen und in
  `scenes/main/workshop_background.gd` → `USER_FLOOR_Y` eintragen (Bühnen-y; Ep. 1 = 915).
  Bildaufbau-Vorlage: `assets/source/user_art/vorlagen/bildaufbau_hintergrund.png`.
- **Essen:** frontal, Format 2:1, offener Herdtisch (kein Backofen/keine Kuppel), Glutbett ~60 % breit,
  Blasebalg links als tropfenförmiger Leder-Blasebalg. Ein erster Midjourney-Test (Backofen mit Kuppel)
  wurde abgelehnt; die Prompts sind entsprechend nachgeschärft.
- Midjourney liefert vier Varianten: eine auswählen und nur diese schicken.

## Offen / nächste Schritte

1. Midjourney-Bilder einbinden, sobald sie kommen: Hintergründe 8–10 (3:4), Hintergrund 7 neu
   (Fenster zu hoch), Essen frontal 1–6, Dampfhammer-Teile, Werkstücke Epochen 2–10, Löschtrog,
   optional Kundenporträts.
2. Danach die Gemini-Bilder schrittweise durch Midjourney ersetzen.
3. Nach jeder Bildänderung: Unit-Tests und grafischer Spieltest (Auflösung 1080×1920).
4. Zum Schluss: Android-Export, Store-Eintrag, Nutzungsbedingungen des Bildgenerators prüfen.

## Verlauf

- 20.11.: Neue Sitzung; Godot 4.7.2 neu installiert, Unit-Tests grün (1658/0). `.import`-Dateien auf
  4.7.2-Standardfelder aktualisiert. Prompt-Heft neu erzeugt (unverändert).
  Status.md wird ab jetzt nach jedem Arbeitsschritt gepflegt.

## Prüfen

- Unit-Tests: `godot --headless --path . res://tests/run_tests.tscn`
- Spieltest: `xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/playtest.tscn`
- Balancing: `python tools/tune_balance.py`
- Übersetzungen: `python tools/content/gen_csv.py localization/translations.csv`
