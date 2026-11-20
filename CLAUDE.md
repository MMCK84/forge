# Hinweise für die Arbeit an diesem Projekt

- Sprache mit dem Auftraggeber: Deutsch.
- Godot 4.7.2 verwenden (4.7.1 stürzt ab); `.uid`-Dateien gehören ins Repository.
- **Grafiken des Auftraggebers:** Alle Bilder bis zum 20.11.2026 stammen von **Gemini**, alle neuen
  von **Midjourney**. Die Gemini-Bilder sollen später durch Midjourney-Bilder ersetzt werden.
  Herkunft je Bild in `assets/source/user_art/provenance.json` eintragen (neue Lieferungen: "Midjourney").
- Prompts für alle Bilder (mit Status): `assets/source/user_art/PROMPTS_Hochformat.md`, erzeugt mit
  `python tools/content/gen_prompt_book.py` – nach jeder Lieferung neu erzeugen.
- Gelieferte Bilder: Originale nach `assets/source/user_art/` (Werkstücke in `items/`, Maschinenteile in
  `machines/`, Hintergründe in `backgrounds/`), dann `python tools/art/import_user_art.py`.
- Inhalte: Epochen 1–6 direkt in `data/`, Epochen 7–10 in `tools/content/epochs_7_10.py`
  (`gen_epochs_7_10.py`); Übersetzungen mit `python tools/content/gen_csv.py localization/translations.csv`.
- Prüfen: Unit-Tests `res://tests/run_tests.tscn`, grafischer Spieltest `res://tools/playtest.tscn`
  (Auflösung 1080×1920), Balancing `tools/tune_balance.py`.
- Android-Export erst, wenn alles fertig ist.
