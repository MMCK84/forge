# Hinweise für die Arbeit an diesem Projekt

- Sprache mit dem Auftraggeber: Deutsch.
- Aktueller Projektstand und offene Punkte: `Status.md` (nach **jedem** Arbeitsschritt aktualisieren, mitcommitten).
- Godot 4.7.2 verwenden (4.7.1 stürzt ab); `.uid`-Dateien gehören ins Repository.
- **Grafiken des Auftraggebers:** Alle Bilder bis zum 20.11.2026 stammen von **Gemini**, alle neuen
  von **Midjourney**. Die Gemini-Bilder sollen später durch Midjourney-Bilder ersetzt werden.
  Herkunft je Bild in `assets/source/user_art/provenance.json` eintragen (neue Lieferungen: "Midjourney").
- Prompts für alle Bilder (mit Status): `assets/source/user_art/PROMPTS_Hochformat.md`, erzeugt mit
  `python tools/content/gen_prompt_book.py` – nach jeder Lieferung neu erzeugen.
- **Erkenntnisse aus einem Bild sofort in ALLE betroffenen Prompts einbauen** (gemeinsame Bausteine
  und `LESSONS` in `gen_prompt_book.py`), dann das Heft neu erzeugen.
- Status je Bild in `provenance.json`: quelle Gemini/Midjourney, bei Midjourney bewertung gut/ändern
  mit hinweis. Stufen im Heft: noch nicht vorhanden · Gemini · Midjourney (ändern) · gut.
- Originale lädt der Auftraggeber über GitHub in `assets/source/user_art/eingang/` hoch (Chat-Bilder sind verkleinert);
  vor jeder Lieferung `git pull`, dann `python tools/art/sort_inbox.py --move` (sortiert nach dem Kürzel im Dateinamen,
  z. B. `W2-3.png`, `BG4.png`, `E1-2.png`; Kürzel stehen im Prompt-Heft und in `assets/source/user_art/codes.json`).
- Gelieferte Bilder: Originale nach `assets/source/user_art/` (Werkstücke in `items/`, Maschinenteile in
  `machines/`, Hintergründe in `backgrounds/`), dann `python tools/art/import_user_art.py` und
  `godot --headless --path . --import` (sonst zeigt das Spiel noch die alten Bilder).
- **Schwache Grafiken jederzeit melden:** Fällt eine Grafik negativ auf (Stil, Perspektive, Zeitbezug, Qualität), dem
  Auftraggeber sofort Bescheid geben – mit Kürzel und Vorschlag (Wunsch des Auftraggebers, 21.11.).
- Hintergründe im Format **1:1** (Hochformat: mittlerer 3:4-Ausschnitt, Querformat/Tablet später: volle Breite).
- **Musik (Suno):** Prompts in `assets/source/user_audio/PROMPTS_Musik.md`, erzeugt mit
  `python tools/content/gen_music_book.py`; Originale nach `assets/source/user_audio/music/<id>.wav`, Herkunft/Bewertung in
  `assets/source/user_audio/provenance.json`. Erkenntnisse wie bei den Bildern sofort in `LESSONS` und Bausteine einbauen.
- Inhalte: Epochen 1–6 direkt in `data/`, Epochen 7–10 in `tools/content/epochs_7_10.py`
  (`gen_epochs_7_10.py`); Übersetzungen mit `python tools/content/gen_csv.py localization/translations.csv`.
- Prüfen: Unit-Tests `res://tests/run_tests.tscn`, grafischer Spieltest `res://tools/playtest.tscn`
  (Auflösung 1080×1920), Durchspiel-Test `res://tools/full_playthrough.tscn` (ganzes Spiel bis zum Finale),
  Balancing `tools/tune_balance.py`.
- Android-Export erst, wenn alles fertig ist.
- Spiel-ZIP (`git archive`) nur liefern, wenn der Auftraggeber ausdrücklich darum bittet.
