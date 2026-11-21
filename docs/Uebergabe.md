# Übergabe an eine neue Sitzung

Stand 21.11.2026. Diesen Text als erste Nachricht in eine neue Claude-Code-Sitzung kopieren
(Repository `MMCK84/forge`, Branch `claude/sharp-rubin-jfnibw`).

---

Wir arbeiten weiter an **Forge Workshop** (Godot 4.7.2, Hochformat-Mobilspiel, 10 Epochen England 1700–1880).
Bitte sprich Deutsch mit mir.

**Bitte zuerst lesen:** `CLAUDE.md` (Arbeitsregeln), `Status.md` (Stand und offene Punkte), `docs/Alpha_Epoche1.md`
(aktuelles Ziel), `docs/Roter_Faden.md` (Aufbau des Spiels). Arbeite auf dem Branch `claude/sharp-rubin-jfnibw`.

**Wichtigste Regeln (Kurzfassung, Details in CLAUDE.md):**
- `Status.md` nach **jedem** Arbeitsschritt aktualisieren und mitcommitten; jeden Commit pushen.
- Bilder kommen von mir über **GitHub Desktop** in `assets/source/user_art/eingang/`, Dateiname = Kürzel (z. B. `W1-2R.png`).
  Ablauf: `git pull` → `python tools/art/sort_inbox.py --move` → `python tools/art/import_user_art.py` →
  `godot --headless --path . --import` → Bewertung in `assets/source/user_art/provenance.json` (Midjourney, gut/ändern +
  Hinweis) → `python tools/content/gen_prompt_book.py`. Jedes Bild ansehen, im Spiel prüfen und mir ehrlich sagen,
  ob es passt – **schwache Grafiken sofort melden** (Stil, Perspektive, Zeitbezug), mit Kürzel und Vorschlag.
- **Erkenntnisse aus jedem Bild sofort in alle betroffenen Prompts** (`LESSONS` und Bausteine in `gen_prompt_book.py`).
- Prüfen: Unit-Tests `res://tests/run_tests.tscn`, Spieltest `res://tools/playtest.tscn` und Bestandsaufnahme
  `res://tools/audit_epoch1.tscn` (beide mit `xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 …`),
  Durchspiel-Test `res://tools/full_playthrough.tscn`, Balancing `tools/tune_balance.py`.
- Spiel-ZIP nur, wenn ich ausdrücklich darum bitte. Android-Export erst ganz am Ende.

**Stand:** Der Kern ist eingefroren (Schlagserie, Stufensprung, Meisterschaft mit Musterbuch, Meisterstück je Epoche,
Kapitelübergang, Werkstatt-Einrichtung, Lehrzeit nach Drehbuch). Zuletzt umgesetzt: „Shop“ statt „Laden“, Schlagstärke
Sanft/Mittel/Fest, Tastenhinweise nur am Rechner (dort an jedem Knopf), Dauerschlag (Gedrückthalten) erst mit dem Lehrling,
Hammer lehnt in Ruhelage am Horn. Alle Bilder der Epoche 1 und der Oberfläche sind von Midjourney und abgenommen.

**Als Nächstes:** Ich liefere die letzten Bilder für Epoche 1 – Rohformen **W1-1R bis W1-8R** (mit dem fertigen Werkstück
als Bild-Prompt), **U22 Titelbild**, **U23 Meisterbrief**. Bitte einbinden, im Spiel prüfen (Stufensprung beim Schmieden,
Hauptmenü, Abrechnung nach dem Meisterstück) und Epoche 1 dann gemeinsam mit mir abnehmen. Danach folgen die übrigen
Epochen nach demselben Muster. Musik (Suno) machen wir später; die Frage „Sprache für das Interface“ ist noch offen.
