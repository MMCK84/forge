# Projektstatus Forge Workshop

Stand: 20.11.2026 · Branch `claude/sharp-rubin-jfnibw` · Godot 4.7.2

**Prompts für alle Bilder:** `assets/source/user_art/PROMPTS_Hochformat.md` (186 Bilder, nach jeder Lieferung neu erzeugt).  
**Prompts für die Musik (Suno):** `assets/source/user_audio/PROMPTS_Musik.md` (11 Stücke + 2 optionale Jingles).

## Kurzüberblick

Inkrementelles Schmiede-Spiel (England, 1700–1880) in Godot 4 / GDScript, **Hochformat (Mobile)**,
Entwicklung am PC. **Fokus derzeit Hochformat**; später soll das Spiel am **Tablet auch im Querformat** laufen
(eigene Anordnung der Bedienelemente, aber dieselben Bilder). Ziel: kommerzielle Veröffentlichung (Android). Der Android-Export kommt erst,
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
- **Werkstatt-Einrichtung:** je Epoche fünf Plätze (Brennstoff, Werkzeugwand, Werkbank, Kundschaft, Licht und Lager) mit
  zeitgemäßem Stück und Wirkung (Heizen +15 %, Schlag +10 %/Kran, Fenster ±25 °C und −20 % Schaden, 4 Angebote/30 s,
  Lohn +5 %/halber Ausschuss); Preise 40 % der Meistergebühr, Prämie bei vollständiger Einrichtung; beginnt je Epoche neu.
  Daten `scripts/furnishings.gd`, Darstellung `scenes/main/furnish_view.gd` (Platzhalter, Kreide-Umriss), Laden-Abschnitt.
- **Tests:** Unit-Tests grün (1841 Prüfungen, 0 Fehler, 20.11.); grafischer Spieltest bis Epoche 10 (mit Einrichtung).

## Bildstatus (Prompt-Heft)

| Bereich | gut (MJ) | MJ ändern | Gemini | fehlt |
|---|---|---|---|---|
| A Hintergründe (1:1) | **10 (alle)** | – | – | – |
| B Essen (frontal) | **6 (alle)** | – | – | – |
| C Amboss, Hämmer | 5 (fotorealistisch) | – | – | – |
| D Maschinenteile | 9 (Schwanzhammer, Dampfmaschine, Dampfhammer) | – | 1 (Ladenbild) | 4 optional |
| E Werkstücke | 7 (Epoche 2/3) | 1 (Hemmschuh) | 9 (Epoche 1) | 64 |
| F Kundenporträts (optional) | – | – | – | 54 |
| G Oberfläche, Store | – | – | 12 | 5 |
| H Werkstatt-Einrichtung | – | – | – | 50 (Platzhalter im Spiel) |

Alle Gemini-Bilder sollen später durch Midjourney ersetzt werden.

## Musik (Suno)

- Bisher spielt das Spiel selbst erzeugte Musik (`tools/art/render_audio.py`, 11 Schleifen: Menü + Epoche 1–10).
  Sie soll durch Suno-Stücke ersetzt werden (Auftraggeber bucht Suno Pro für einen Monat).
- Heft: `assets/source/user_audio/PROMPTS_Musik.md` (Generator `tools/content/gen_music_book.py`) mit Styles,
  Exclude Styles und Strukturangaben je Stück; Tempo und Tonart wie bisher. Zeitgerechte Instrumente je Epoche.
- Jede Lieferung: Original nach `assets/source/user_audio/music/<id>.wav`, Schleife schneiden und überblenden,
  Lautstärke angleichen, OGG nach `assets/audio/music/`, `provenance.json` (Suno, gut/ändern), Heft neu erzeugen.
  Das Import-Skript (Schleife, Lautstärke) schreibe ich mit der ersten Lieferung.
- Optional: Fanfare „neue Epoche“ und Meilenstein-Jingle (spielt das Spiel noch nicht ab, würde ich einbauen).

## Arbeitsweise mit Bildern (Midjourney v8.2)

- **Originale über GitHub** in `assets/source/user_art/eingang/` hochladen, **Dateiname = Kürzel** (z. B. `W2-3.png`) (Chat-Bilder werden verkleinert/komprimiert und
  kommen während einer laufenden Antwort gar nicht als Datei an). Der Chat bleibt für die schnelle Ansicht.
- Jede Lieferung: Original nach `assets/source/user_art/` (`items/`, `machines/`, `backgrounds/`),
  `python tools/art/import_user_art.py`, Herkunft/Bewertung in `provenance.json`, Heft neu erzeugen.
- Erkenntnisse sofort in **alle** betroffenen Prompts (gemeinsame Bausteine und `LESSONS` im Generator).
- **Hintergründe im Format 1:1** (Regler „Square 1:1“, danach Upscale 2×, mind. 1440 px): ein Bild für Hoch- und Querformat.
  Hochformat = mittlerer 3:4-Ausschnitt (macht der Import automatisch), Querformat = volle Breite. Fenster und alles
  Wichtige in den mittleren drei Vierteln, äußere Achtel nur Wand und Boden. Wand-Boden-Kante bei 50–65 % ist in Ordnung;
  der Import verlängert den Boden auf 1080×1920. Kante je Epoche ausmessen und in `scenes/main/workshop_background.gd` →
  `USER_FLOOR_Y` eintragen (Bühnen-y; Ep. 1–10 eingetragen). Zu tiefe Kante: `BG_TOP_CROP` im Import (Ep. 10: 300 px). Bildaufbau-Vorlage (1:1, Bild-Prompt):
  `assets/source/user_art/vorlagen/bildaufbau_hintergrund.png` (`python tools/art/make_bg_template.py`).
  **Erst nach dem Upscale 2× (2048 × 2048) schicken** – ohne Upscale nur 1024 × 1024.
- **Essen:** frontal, Format 2:1, offener Herdtisch (kein Backofen/keine Kuppel), Glutbett ~60 % breit,
  Blasebalg links als tropfenförmiger Leder-Blasebalg. Ein erster Midjourney-Test (Backofen mit Kuppel)
  wurde abgelehnt; die Prompts sind entsprechend nachgeschärft.
- Midjourney liefert vier Varianten: eine auswählen und nur diese schicken.

## Offen / nächste Schritte

1. Midjourney-Bilder einbinden, sobald sie kommen: Dampfhammer-Teile, Werkstücke Epochen 2–10, Löschtrog,
   optional Kundenporträts.
2. Danach die Gemini-Bilder schrittweise durch Midjourney ersetzen.
3. Nach jeder Bildänderung: Unit-Tests und grafischer Spieltest (Auflösung 1080×1920).
4. Später: Querformat für Tablets (Anordnung der Bedienelemente, Querformat-Ausschnitt der 1:1-Hintergründe;
   der Boden ist dort nur ~20 % hoch – ggf. ebenfalls verlängern).
5. **Aufbau der Werkstatt** (Konzept `docs/Konzept_Aufbau.md`): Teil 1 Einrichtung **umgesetzt** (Platzhalterbilder;
   Bilder kommen über Prompt-Heft Bereich H). Offen: Lage von Kohle und Werkbank (ab Epoche 5 hinter der Maschine) mit den
   echten Bildern abstimmen; Teil 2 sichtbares Personal; weitere Ideen (Stammkunden, Ereignisse, Meisterstück).
   Spielzeit darf länger werden, darf aber nicht langweilig sein.
6. Musik von Suno einbinden, sobald sie kommt (Import-Skript für Schleifen mit der ersten Lieferung).
7. Zum Schluss: Android-Export, Store-Eintrag, Nutzungsbedingungen von Bild- und Musikgenerator prüfen.

## Verlauf

- 20.11.: Neue Sitzung; Godot 4.7.2 neu installiert, Unit-Tests grün (1658/0). `.import`-Dateien auf
  4.7.2-Standardfelder aktualisiert. Prompt-Heft neu erzeugt (unverändert).
  Status.md wird ab jetzt nach jedem Arbeitsschritt gepflegt.
- 20.11.: Hintergründe auf **1:1** umgestellt (Hoch- und Querformat aus demselben Bild): Prompts (Bildaufbau,
  Fenster/Randdeko in die mittleren drei Viertel), Erkenntnis in `LESSONS`, Import schneidet 1:1 auf den mittleren
  3:4-Ausschnitt, neue quadratische Bildaufbau-Vorlage. Vorhandene Hintergründe unverändert.
- 20.11.: Musik-Prompt-Heft für Suno angelegt (`gen_music_book.py`, `PROMPTS_Musik.md`, `user_audio/provenance.json`).
- 20.11.: **Hintergrund Epoche 1 neu in 1:1** (Midjourney) eingebaut: Kante 65 % → `USER_FLOOR_Y` 939, Fenster und Deko wie
  vorgesehen. Bewertung „ändern“ nur wegen der Auflösung (1024 × 1024): als Upscale 2× nachliefern. Erkenntnis im Heft.
  Unit-Tests grün (1658/0), Spieltest 33 Screenshots, 0 Probleme.
- 20.11.: Epoche 1 Variante 2 im Spiel verglichen (fast gleichwertig) – Variante 1 bleibt. Schwarzer Streifen unten bei 3 von 4
  1:1-Bildern: Prompts nachgeschärft, Import schneidet ihn bei 1:1-Bildern automatisch ab. Epoche 2 und 3 (1:1) geprüft,
  aber nur als Vorschau angekommen – Dateien fehlen noch.
- 20.11.: **Epoche 1 Variante 3** eingebaut (Kante 63 % → `USER_FLOOR_Y` 911): große helle Wandfläche hinter der Esse wirkt
  im Spiel am besten – als Baustein in alle Hintergrund-Prompts übernommen. Nur Upscale 2× fehlt noch.
  Unit-Tests grün, Spieltest 33 Screenshots, 0 Probleme.
- 20.11.: Midjourney warnte „Long prompt“: **alle Prompts gekürzt** (Hintergründe 320 → ~90 Wörter, Essen 220 → ~100,
  Werkstücke ~110 → ~80, Mittel 88 → 64). Bausteine in Stichworten, gemeinsame Langformeln über `SHORTEN`, Verbote knapp;
  Wortzahl steht bei jedem Prompt im Heft. Ob die Warnung noch kommt, testet der Auftraggeber.
- 20.11.: **Epoche 1 fertig (✅)**: Variante 4, 2000 × 2000, gekürzter Prompt, kein Streifen; Kante 72 % → `USER_FLOOR_Y` 1044,
  im Spiel gut. Epoche 2 (1:1) nur als Vorschau, abgelehnt (Kante ~80 %, zweites Fenster außerhalb, kalt, kein Feuerschein).
  Hintergrund-Prompts nachgeschärft (hoher Blickpunkt, Boden untere Hälfte, Abendlicht/Feuerschein, nur ein Fenster).
- 20.11.: Bild-Upload im Chat ist verlustbehaftet (5 MB → 0,5 MB WebP, max. 2000 px). Eingangsordner
  `assets/source/user_art/eingang/` für Originale über GitHub angelegt.
- 20.11.: Erste Originale über den Eingang: **Epoche 1** (PNG 2048², `USER_FLOOR_Y` 1053) und **Epoche 2 neu** (nachgeschärfter
  Prompt: Abendlicht, Feuerschein; Kante 69 % → 991) – beide ✅. Zweites Fenster trotz `--no` → Fenster-Baustein präzisiert.
  Wichtig: nach `import_user_art.py` erst `godot --headless --path . --import`, sonst zeigt der Spieltest alte Bilder.
  Unit-Tests grün, Spieltest 34 Screenshots, 0 Probleme.
- 20.11.: BG3–BG10 laut Auftraggeber hochgeladen, auf GitHub aber noch nicht angekommen (Commit fehlt vermutlich).
  Auftraggeber findet die Hintergründe etwas dunkel – Aufhellung beim Import möglich, Entscheidung wenn alle 10 im Spiel sind.
- 20.11.: Konzept „Aufbau der Werkstatt“ geschrieben (`docs/Konzept_Aufbau.md`). Auftraggeber: „klingt sehr gut“.
- 20.11.: **Hintergründe 3–10** (1:1, 2048²) und **Essen Stufe 1–5** (Frontalansicht) eingebaut. Alle 10 Hintergründe ✅.
  Essen: Originale in `assets/source/user_art/forges/`; der Import misst Glutbett, Schornstein und Lage selbst und schreibt
  `scripts/user_forge_meta.gd` (ersetzt die Handwerte in `forge_view.gd`). Stufe 3 „ändern“ (nur ein Blasebalg).
  Ep. 10: Kante 84 % → Import schneidet oben 300 px ab. Erkenntnisse (gemaltes Feuer, zweites Fenster rechts, dunkel,
  Doppelbalg) in alle Prompts übernommen. Unit-Tests grün, Spieltest 0 Probleme.
- 20.11.: **Amboss und vier Hämmer** (Midjourney) eingebaut; Originale in `assets/source/user_art/tools/`. Der Import spiegelt
  den Amboss (Horn rechts) und misst Ambossbahn, Griffpunkt und Hammerbahn → `scripts/user_tool_meta.gd`. Stil fotorealistisch
  (Raw-Modus) – im Spiel unauffällig; Prompt-Heft empfiehlt künftig Standard + Stil-Referenz und `--no photo, 3d render`.
- 20.11.: **Werkstatt-Einrichtung (Aufbau Teil 1)** eingebaut: Daten, Wirkungen in Simulation/Abrechnung/Auftragsbuch,
  Laden-Abschnitt, Darstellung mit Platzhaltern, Speichern, Prämie, Statistik, Hinweis, Klang; 183 neue Prüfungen; Spieltest
  kauft Einrichtung in Ep. 3/5–10. Balancing: mit Einrichtung 12,98 h statt 13,58 h (Vorteile beschleunigen) → Nachstimmen
  der Epochen mit `tune_balance.py`. Prompt-Heft: Bereich H (50 Einrichtungsbilder), Reihenfolge und Regeln aktualisiert;
  Import für `assets/source/user_art/furnishings/`.
- 20.11.: **Balancing nachgestimmt** (`tune_balance.py`, 8 Iterationen): mit Einrichtung 13,51 h, Minuten je Epoche
  12.6/23.8/55.3/82.9/131.0/157.0/77.9/83.8/90.0/96.0 (`fp_start`/`rate_per_fp` angepasst, Löhne unverändert).
- 20.11.: **Esse Stufe 3 neu und Siemens-Ofen** (alle sechs Essen ✅) sowie **Wasserrad, Hammerbalken, Gestell, Schwungrad**
  (Midjourney) eingebaut. Gemalten Rauch schneidet der Import weg (`FORGE_SMOKE`). Schwanzhammer: Lager, Kopf und Gestell-
  Lager misst der Import (`scripts/user_machine_meta.gd`), die Maschinenansicht skaliert passend. Tests grün (1841/0),
  Spieltest 0 Probleme.
- 20.11.: **Dampfmaschine, Balancier und Dampfhammer** (Gestell, Bär, Schabotte; Midjourney) eingebaut. Der Import misst
  Kolbenstange, Säulenkopf und Balancier; der Bär wird bis zum Zylinder gezeigt. Die Anzeige „Rohlinge“ ist in Ep. 9/10 nicht
  mehr verdeckt. Gegen perspektivische Bilder: Ansicht an den Prompt-Anfang („Flat orthographic … elevation“), Verbote gegen
  Perspektive, Tipp Bild-Prompt mit `--iw 1` und Raw + `--sref` – im Heft unter Einstellungen und in `LESSONS`.
- 20.11.: **Erste Werkstücke** (Midjourney): Epoche 2 Radreifen, Kutschachse, Kutschbeschlag, Laternenhalter, Postpferd-
  Hufeisen, Schlagbaumbeschlag ✅, Hemmschuh 🟠 (falsches Objekt → Prompt in Seitenansicht); Epoche 3 Kettenglied ✅.
  Fotorealistisch auf grauem Grund – Import stellt sauber frei. Frage des Auftraggebers: Was fehlt für Epoche 1? → Antwort:
  spielbar ist sie schon; für einen einheitlichen Midjourney-Look fehlen 9 Werkstücke, 5 Einrichtungsstücke und die UI-Bilder.
- 20.11.: Projekt als ZIP an den Auftraggeber (spielt am PC in Godot). Rückmeldung umgesetzt: **„Neues Spiel“ im Pausemenü**
  (mit Rückfrage), „Speichern & Beenden“ heißt jetzt „Speichern & zum Hauptmenü“; **Schlagstärke** deutlicher: Knöpfe in der
  Lehrzeit ausgeblendet (erscheinen mit dem Erklär-Hinweis), der verlangte Knopf pulsiert golden, wenn eine andere Stärke
  gewählt ist.
- 20.11.: **Kürzel je Bild** (Wunsch des Auftraggebers): BG1–10, F1–6, AN, H1–4, M1–10, ML1–4, W0/W1-1…W10-n, P…, U1–17,
  E1-1…E10-5 – stehen vorn im Prompt und im Heft (Datei-ID dahinter). `tools/art/sort_inbox.py --move` sortiert Lieferungen
  anhand des Kürzels im Dateinamen ein; Import findet Originale mit beliebiger Endung.
- 20.11.: Optik-Prüfung (Auftraggeber: „teilweise verschoben bzw. schräg“): In breiten Fenstern wurde ein Randstreifen
  des Hintergrunds in die Breite gezogen (verzerrte Streifen). Jetzt erzeugt der Import `background_N_wide.jpg` (volles
  1:1-Bild, 1440×1920) und das Spiel zeigt daneben eine gespiegelte, abgedunkelte Fortsetzung mit weichem Übergang.
  Fenster (z. B. Personal) ragten im Standardfenster unter die Navigationsleiste → Höhe begrenzt. Werkbank-Platzhalter
  innerhalb der Bühne.
- 20.11.: Lieferung mit Kürzeln (erste Nutzung von `sort_inbox.py`): großer Dampfhammer (M10), Ladenbilder Dampf-Schwanzhammer,
  Nasmyth, großer Dampfhammer (ML2–4), Rohling und Werkstücke W1-1–3 (Nagel, Hufeisen, Haken), erste sechs Kundenporträts
  (P2-1–5, P3-1). Neu: Import für Porträts (ovaler Rahmen freigestellt, `ui/user/portrait_<kunde>.png` hat Vorrang) und alle
  vier Ladenbilder. Stand Heft: 51 ✅, 1 🟠, 18 Gemini, 115 fehlen, 52 optional.

## Prüfen

- Nach neuen Bildern: `python tools/art/import_user_art.py`, dann `godot --headless --path . --import`

- Unit-Tests: `godot --headless --path . res://tests/run_tests.tscn`
- Spieltest: `xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/playtest.tscn`
- Balancing: `python tools/tune_balance.py`
- Übersetzungen: `python tools/content/gen_csv.py localization/translations.csv`
