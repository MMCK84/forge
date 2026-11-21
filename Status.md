# Projektstatus Forge Workshop

Stand: 21.11.2026 · Branch `claude/sharp-rubin-jfnibw` · Godot 4.7.2

**Prompts für alle Bilder:** `assets/source/user_art/PROMPTS_Hochformat.md` (Bereiche A–I, Kürzel je Bild, nach jeder Lieferung neu erzeugt).  
**Prompts für die Musik (Suno):** `assets/source/user_audio/PROMPTS_Musik.md` (11 Stücke + 2 optionale Jingles) – Musik kommt später.  
**Übergabe an eine neue Sitzung:** `docs/Uebergabe.md`.

## Kurzüberblick

Inkrementelles Schmiede-Spiel (England, 1700–1880) in Godot 4 / GDScript, **Hochformat (Mobile)**, Entwicklung am PC
(der Auftraggeber spielt in Godot 4.7.2 am PC). Später soll das Spiel am **Tablet auch im Querformat** laufen (eigene
Anordnung, dieselben Bilder). Ziel: kommerzielle Veröffentlichung (Android) – Export erst, wenn alles fertig ist.
**Aktuelles Ziel: Epoche 1 auf Alpha-Niveau** (`docs/Alpha_Epoche1.md`), danach die übrigen Epochen nach demselben Muster.
**Der Kern ist eingefroren** (keine neuen Mechaniken mehr; nur Bilder, Musik, Feinschliff und Wünsche des Auftraggebers).

## Fertig

- **Hochformat:** Viewport 720×1280, Bühne 1080×1920; Statusleiste oben, Navigation unten (Aufträge [J], Shop [S],
  Personal [P], Statistik [T]), Bedienfeld 720×380.
- **10 Epochen** (1700–1880), Inhalte 1–6 in `data/`, 7–10 in `tools/content/epochs_7_10.py` (80 Werkstücke, Kunden,
  Meilensteine, Personal, Essen, Maschinen).
- **Lehrzeit** (5 Aufträge nach Drehbuch, `docs/Roter_Faden.md`), **Schlagstärke Sanft – Mittel – Fest** ab Auftrag 6
  (Epoche 1 nur Sanft/Fest), Hinweisfenster beim ersten Auftreten jeder Mechanik, **Kapitelübergang** („Was Euch erwartet“).
- **Steuerung:** Tippen/Leertaste = ein Schlag. **Gedrückthalten = fortlaufend erst mit dem Lehrling** (Epoche 2, „er schlägt
  im Takt mit“). Alle Maschinen (Schwanz- und Dampfhämmer): Tippen = ein Schlag, Halten = fortlaufend, Loslassen = Stopp.
  Tastenhinweise **am Rechner an jedem Knopf, auf Handy/Tablet nie** (Übersetzung entfernt sie, „Klickt“ → „Tippt“;
  Test am Rechner mit `-- --touch`). **Tastenbelegung (21.11.):** Aufträge [J], Shop [S], Personal [H], Statistik [T],
  Pausenmenü [P] (auch Esc), HAMMERN [Leertaste], Rohling [R], Umlegen [E], Abschrecken [Q], Sanft/Mittel/Fest [←][↓][→].
  In jedem Fenster: **Esc schließt**, **Enter = Hauptknopf** („Verstanden“, „Weiter“, „Fortsetzen“), die Fenster-Taste
  schließt ihr Fenster wieder; Auftragsbuch: Annehmen [1]–[3], Neue Angebote [N]; Abrechnung: Weiter [Enter], Wiederholen
  ↻ [R], Menü [P]. Bewusst ohne Taste: „Überspringen“ der Lehrzeit (kein versehentliches Überspringen), Rückfragen-Bestätigung
  (z. B. „Neues Spiel“ – nur per Klick, Esc bricht ab), Kauf-Knöpfe in Listen (Shop, Personal, Einstellungen).
- **Kernausbau:** Schlagserie (je 5 Treffer +10 %, max. +30 %), Stufensprung je Arbeitsgang (Rohform-Bilder vorbereitet,
  Prompt-Heft I), Meisterschaft je Werkstück (Bronze/Silber/Gold nach 2/5/10 Aufträgen, je +5 % Lohn) mit Musterbuch,
  Meisterstück je Epoche (Vorarbeiten + Hauptstück, Zunftprüfung ≥ 2 Sterne, nach zwei Fehlversuchen 1 Stern).
- **Werkstatt-Einrichtung:** je Epoche fünf Plätze mit Wirkung, beginnt je Epoche neu; Epoche 1 mit Midjourney-Bildern,
  übrige Epochen mit Platzhaltern (Prompt-Heft H).
- **Balancing** (`tools/tune_balance.py`, `tools/balance_sim.gd` rechnet Serie, Meisterschaft, Einrichtung und
  Meisterstück-Vorarbeiten mit): Spielzeit ca. **13,9 h**.
- **Grafiken des Auftraggebers:** Import-Pipeline `tools/art/import_user_art.py` (Freistellen, Vermessen, Varianten);
  Lieferweg über GitHub-Eingang + `tools/art/sort_inbox.py`. Bildstatus siehe unten.
- **Prüfwerkzeuge:** Unit-Tests (2153/0), grafischer Spieltest (34 Bilder, 0 Probleme), Durchspiel-Test (ganzes Spiel bis
  zum Finale, Seeds 3/7/11 ohne Probleme), Bestandsaufnahme Epoche 1 (38 Bildschirme).

## Bildstatus (Prompt-Heft, 21.11.)

| Bereich | gut (MJ) | MJ ändern | Gemini | fehlt |
|---|---|---|---|---|
| A Hintergründe (1:1) | **10 (alle)** | – | – | – |
| B Essen (frontal) | **6 (alle)** | – | – | – |
| C Amboss, Hämmer | **5 (alle)** | – | – | – |
| D Maschinenteile, Ladenbilder | 13 | – | 1 (ML1 Wasser-Schwanzhammer) | – |
| E Werkstücke | 22 (Epoche 1–3, Tuchschere) | 2 (W2-7 Hemmschuh, W3-7 Ruderfingerling) | – | 57 |
| F Kundenporträts | 20 | – | – | 34 optional |
| G Oberfläche, Symbole, Store | **alle** (U1–U23, auch U12 und U21 optional) | – | – | – |
| H Werkstatt-Einrichtung | 6 (Epoche 1, E2-2) | 1 (E2-1 Kohlenkiste) | – | 43 |
| I Rohformen | 8 (alle der Epoche 1) | – | – | 65 (+7 geteilt, kein eigenes Bild) |

**Alle Bilder für Epoche 1 sind da und gut (21.11.).** Nächster Schritt: Epoche 1 gemeinsam abnehmen.

## Anmerkungen aus dem Anspielen – gesammelt, noch umzusetzen

Arbeitsweise (Wunsch des Auftraggebers, 21.11.): Anmerkungen **erst sammeln**, dann alles zusammen umsetzen und testen.

| # | Anmerkung (21.11.) | Stand |
|---|---|---|
| 1 | Lehrzeit-Leiste schon hinter dem Willkommensfenster, wiederholt sich bei jedem Auftrag | umgesetzt |
| 2 | Nicht alle Knöpfe haben eine Taste | umgesetzt |
| 3 | P soll das Pausenmenü öffnen | umgesetzt (Personal → [H]) |
| 4 | „Auftrag wiederholen“ als runder Pfeil | umgesetzt |
| 5 | Geld „d“ unverständlich (für „dime“/„day“ gehalten) | **entschieden 21.11.: A + B** – £ s d bleibt; beim ersten Lohn Hinweisfenster mit Erklärung (12 d = 1 s, 20 s = 1 £, d = Penny/denarius), Tooltip an der Geldanzeige, Start „£0“ statt „0d“; dazu Münzsymbole (Gold/Silber/Kupfer mit Zahl) bei der großen Summe in Statuszeile und Abrechnung – „wir scheuen keinen Aufwand“ |
| 6 | Ohne aktiven Auftrag ist schon ein Temperatur-Zielfenster auf der Glutskala eingezeichnet – irritierend | offen |
| 7 | Knöpfe „Rohling einlegen“ und „Umlegen“ zu breit; Schrift wirkt durch den Rahmen durchgestrichen (Text liegt auf der Rahmenkante; ebenso „Menü“) | offen |
| 8 | Schlagstärke-Knöpfe Sanft/Fest ohne Rahmen (anderer Stil als die übrigen Knöpfe) | offen |

## Musik (Suno) – später

- Bisher spielt das Spiel selbst erzeugte Platzhalter-Musik (`tools/art/render_audio.py`).
- Heft: `assets/source/user_audio/PROMPTS_Musik.md` (`tools/content/gen_music_book.py`). Lieferung: Original nach
  `assets/source/user_audio/music/<id>.wav`, Import-Skript (Schleife, Lautstärke) schreibe ich mit der ersten Lieferung.

## Arbeitsweise mit Bildern (Midjourney v8.2)

- Auftraggeber lädt Originale per **GitHub Desktop** in `assets/source/user_art/eingang/` hoch, **Dateiname = Kürzel**
  (z. B. `W2-3.png`, `W1-2R.png`, `U22.png`). Vor dem Einsortieren `git pull`, dann `python tools/art/sort_inbox.py --move`,
  `python tools/art/import_user_art.py`, `godot --headless --path . --import`; `provenance.json` (Midjourney, gut/ändern +
  Hinweis) und Heft (`python tools/content/gen_prompt_book.py`) aktualisieren. Schwache Bilder sofort melden.
- Erkenntnisse sofort in **alle** betroffenen Prompts (Bausteine und `LESSONS` im Generator).
- **Perspektive:** Esse, Amboss, Hämmer, Maschinen und Werkstücke streng flach (Ansicht ganz vorn im Prompt, --no-Liste);
  **Einrichtung darf leicht dreiviertel sein** (steht im perspektivisch gemalten Raum); Mechanik Bauteil für Bauteil beschreiben.
- **Zeitbezug:** typische moderne Verwechslungen ausdrücklich ausschließen (z. B. Sturmlaterne, Doppeladler).
- **Qualität vor Sparsamkeit (Entscheidung des Auftraggebers, 21.11.):** lieber viele eigene Bilder; weglassen/teilen nur, wo ein
  eigenes Bild überhaupt keinen Vorteil bringt (sonst wird nur die Spieldatei größer). Rohformen: je Werkstück eine eigene;
  geteilt nur bei gleichem Stand nach dem ersten Arbeitsgang (`ROUGH_SHARED` in `scripts/assets.gd`, im Heft vermerkt).
- **Absprachen immer hier festhalten** (Wunsch des Auftraggebers, 21.11.: die frühere Absprache „Halbzeuge für mehrere
  Werkstücke“ stand nirgends und war deshalb verloren).
- **Rohformen:** Stand nach dem ersten Arbeitsgang, je Werkstück beschrieben; spätere Formen (Spitze, Kopf, Biegung, Löcher)
  als `--no`. Fertiges Werkstück als Bild-Prompt nur schwach (`--iw 0.5`), sonst kopiert Midjourney das fertige Stück.
- **Hintergründe 1:1**, Upscale 2× vor dem Schicken; Wand-Boden-Kante je Epoche in `USER_FLOOR_Y`.
- Originale liegen im Repository unter `assets/source/user_art/` (z. B. Werkstücke in `items/<id>.png`).

## Offen / nächste Schritte

1. **Epoche 1 Alpha: gemeinsam abnehmen** (alle Bilder da; Bestandsaufnahme `tools/audit_epoch1.tscn`). Noch offen: Musik, Klänge.
2. Vor dem Export: Testmenü-Knöpfe nur in der Entwicklerfassung.
3. Danach Epoche 2 ff. nach demselben Muster (Werkstücke, Rohformen, Einrichtung je Epoche); W2-7, W3-7 und ML1 ersetzen.
4. **Geldanzeige £ s d** verständlicher machen (entschieden: Erklärung + Tooltip + Münzsymbole, siehe Anmerkungen Nr. 5).
5. **Sprache für das Interface überlegen** (Wunsch des Auftraggebers, 20.11.) – zu klären: Wortwahl/Anrede („Ihr“),
   angebotene Sprachen (Deutsch/Englisch) und/oder Gestaltung der Oberfläche.
5. **Musik (Suno)** – später.
6. Später: Querformat für Tablets (U21 Doppelseite des Auftragsbuchs vorbereitet); sichtbares Personal
   (`docs/Konzept_Aufbau.md`, Teil 2); Stammkunden.
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
  innerhalb der Bühne. Spiegelung beginnt in voller Helligkeit (nahtlos) und wird nach außen dunkler.
- 20.11.: Lieferung mit Kürzeln (erste Nutzung von `sort_inbox.py`): großer Dampfhammer (M10), Ladenbilder Dampf-Schwanzhammer,
  Nasmyth, großer Dampfhammer (ML2–4), Rohling und Werkstücke W1-1–3 (Nagel, Hufeisen, Haken), erste sechs Kundenporträts
  (P2-1–5, P3-1). Neu: Import für Porträts (ovaler Rahmen freigestellt, `ui/user/portrait_<kunde>.png` hat Vorrang) und alle
  vier Ladenbilder. Dazu Porträts P3-2–5, P1-1–6 (P1-4 Müller „ändern“: wirkte wie eine Frau) und P4-1–4.
  Aufgeräumt: BG3–6 (Doppel) und P1-* lagen im Hauptordner des Repositorys → gelöscht bzw. einsortiert.
- 20.11.: `project.godot` trug noch die Kennung „4.3“ (Projektmanager zeigte 4.3, Umwandlungs-Rückfrage) → auf „4.7“ gesetzt.
- 20.11.: Rückmeldungen aus dem Anspielen: **Abrechnung** mit „Menü“ (Pausemenü), „Auftrag wiederholen“ (gleicher Auftrag
  noch einmal, nicht bei Meilensteinen) und „Weiter“ (vorausgewählt). **Steigende Komplexität in der Lehrzeit:** Aufträge 1–2
  nur ein Arbeitsgang (ein Zielfenster), 3–4 höchstens zwei, danach alle (`tutorial_single_step_jobs`/`tutorial_two_step_jobs`).
  **Kreide-Umrisse** der Einrichtung entfernt (nicht gekaufte Plätze unsichtbar). Unit-Tests 1850/0.
- 20.11.: **Roter Faden geprüft** (`docs/Roter_Faden.md`: Zeitleiste aller Mechaniken, Drehbuch der Lehrzeit). Nachgesteuert:
  Lehrzeit nach festem Drehbuch (Haken biegen → Nagel anspitzen → Nagel strecken+anspitzen → Hufeisen strecken+biegen →
  Hufeisen vollständig; erst 1, dann 2 Angebote), Sichel aus Eisen (Stahl erst Epoche 4), Eilaufträge in Epoche 2 erst ab
  der Mitte, Hinweis auf die Einrichtung am Ende der Lehrzeit. Unit-Tests 2088/0. Balancing danach 13,1 h → nachgestimmt: **13,49 h**, Minuten je Epoche
  12.2/23.2/54.9/83.1/131.1/156.9/78.0/84.0/90.0/96.1.
- 20.11.: Fehler „keine Punkte in den ersten Aufträgen“: Die Schlagstärke zählte, sobald die Lehrzeit-Hilfe übersprungen
  bzw. abgeschaltet war – Voreinstellung „mittel“, der Haken verlangt „leicht“ → kein Schlag im Zielfenster, 0 Sterne.
  Jetzt hängt die Schlagstärke am Fortschritt (`force_counts()`: erste 5 Aufträge der Epoche 1 zählen nie), in Epoche 1
  ist „mittel“ ausgeblendet (dort nur leicht/schwer), Voreinstellung schwer. Drehbuch-Versatz behoben (Folgeangebote
  werden nach jedem Lehrzeit-Auftrag neu erzeugt).
- 20.11.: Älterer Fehler gefunden: Schweißaufträge mit schnellen Essen (bis 250 °C/s) verbrannten in 0,4 s im Schweißfenster;
  Schätzungen hingen bei 1:00:00. Neu: oberhalb Gelbglut (1100 °C) heizt jede Esse höchstens 60 °C/s (`white_heat_rate`),
  Referenzspieler macht für wartende Schweißstücke den Amboss frei. 0 von 200 Schweißaufträgen hängen. Tests 2098/0.
- 20.11.: Nachstimmen danach scheiterte an verbliebenen Hängern (Schweißaufträge mit 3–6 Stücken) → Werte zurückgesetzt.
  Ursache im Lehrling: Er hält jetzt normale Stücke **immer** auf Arbeitshitze (nichts überhitzt mehr unbemerkt) und lässt
  Schweißstücke immer bis zur Schweißhitze kommen; Referenzspieler wartet nur noch auf erreichbare Hitze.
  Balancing ohne Hänger: **13,48 h**, Minuten 12.2/22.6/54.8/82.3/129.8/159.0/77.4/81.9/90.7/98.0 (alle ±3 %, kein Nachstimmen
  nötig). Spieltest 0 Probleme, Schätzungen in allen Epochen plausibel.
- 20.11.: **Steuerung:** Tippen = ein Schlag, Halten = fortlaufende Schläge (bisher nur als Option; Einstellung entfällt).
  **Dampfhämmer** (Nasmyth, großer Dampfhammer) schlagen nur noch auf Kommando wie am Steuerhebel: Tippen = ein Dampfschlag,
  Halten = fortlaufend, Loslassen = Stopp (vorher liefen sie automatisch und ließen sich nicht anhalten). Schwanzhämmer laufen
  wie bisher am Antrieb mit. Hinweis „Am Steuerhebel“ beim Kauf/Aktivieren. Referenzspieler hält den Hebel → Balancing
  unverändert. Tests 2106/0, Spieltest 0 Probleme.
- 20.11.: **Einheitliche Maschinensteuerung:** Auch die **Schwanzhämmer** (Wasser- und Dampf-Schwanzhammer) schlagen jetzt nur
  auf Kommando – Tippen = ein Schlag, Halten = fortlaufend, Loslassen = Stopp. Damit funktionieren alle Maschinen gleich wie
  der Handhammer. Schwanzhämmer schlagen weiterhin nur schwer (leichte Schritte von Hand). Texte (Maschinen-Hinweis, Laden)
  angepasst. Balancing unverändert **13,33 h** (Seed 1), Tests 2106/0, Spieltest 0 Probleme.
- 20.11.: **Schlagserie und Stufensprung** (Kernausbau Schritt 1) eingebaut, siehe „Fertig“. Rahmen um die Esse-Plätze und den
  Rohling-Stapel entfernt (nur noch Nummer bzw. Anzahl, gewählter Platz mit weichem Schein). Der Serienbonus macht den
  Referenzspieler 15–20 % schneller (11,3 h statt 13,3 h) → mit `tune_balance.py` nachgestimmt (8 Iterationen, 4 Seeds):
  **13,46 h**, Minuten 12.1/22.4/55.0/82.8/130.6/156.9/77.9/83.6/90.0/96.0 (alle ±3 %). Dabei einen Hänger behoben:
  Bei voller Esse holte der Referenzspieler ein Schweißstück nicht an den Amboss (es nahm in der Weißglut Schaden und
  wurde immer wieder Ausschuss) → er tauscht es jetzt sofort gegen das Amboss-Stück. Tests 2119/0.
- 20.11.: **Meisterschaft je Werkstück und Musterbuch** (Kernausbau Schritt 2), siehe „Fertig“. Prompt-Heft: Siegel
  U18–U20. Der Lohnbonus verkürzte die Spielzeit auf 13,0 h (`balance_sim.gd` rechnet die Meisterschaft mit) →
  nachgestimmt (3 Iterationen): **13,40 h**, alle Epochen ±3 %. Tests 2132/0, Spieltest 0 Probleme.
- 20.11.: **Meisterstück und Kapitelübergang** (Kernausbau Schritt 3), siehe „Fertig“. `balance_sim.gd` rechnet die
  Vorarbeiten jetzt mit: Spielzeit **13,9 h** (4 Seeds, Minuten 12.8/23.2/59.0/82.6/135.1/152.2/79.6/88.3/95.7/104.0),
  also rund 30 Minuten mehr – bewusst nicht weggestimmt (Spielzeit darf länger werden). Tests 2148/0, Spieltest 0 Probleme.
  **Kernausbau damit abgeschlossen – Kern eingefroren.** Weiter mit Bildern, Musik und Feinschliff.
- 20.11.: **Durchspiel-Test Epoche für Epoche** (neu: `tools/full_playthrough.tscn`): Der Referenzspieler spielt das echte Spiel
  über den GameManager (Lehrzeit, Angebote, Meilensteine, Meisterstücke, Laden, Personal, Einrichtung, Umzug, Speichern/
  Laden je Epoche) bis zum Finale und ins Freie Spiel. **Gefunden und behoben:**
  1. **Sackgasse in Epoche 10:** Der geschweißte Geschützring (Meisterstück) bekam beim Abkühlen aus der Weißglut auf dem
     Amboss stets so viel Gefügeschaden, dass die Zunft ihn nie annahm – das Finale kam nie. Überhitzung schadet jetzt nur
     noch im Feuer (betraf alle Schweißaufträge: Sterne in Epoche 3–8 jetzt meist 3 statt 2,6–2,8). Zusätzlich genügt nach
     zwei Fehlversuchen an einem Meisterstück-Teil ein Stern (keine Sackgasse mehr möglich).
  2. Meisterstück Epoche 1 verlangte zwei Türangeln – Mengenaufträge kommen laut rotem Faden erst in Epoche 2 → eine Türangel.
  3. Speicherwachstum nur im Test ohne Tonausgabe (Klang-Wiedergaben stauten sich im Zeitraffer) – kein Fehler im Spiel.
  Ergebnis (Seeds 3, 7, 11): alle 10 Epochen mit allen Meilensteinen und Meisterstücken, Umzüge, Speichern/Laden und Freies
  Spiel ohne Probleme; 543 Aufträge, Spielzeit 13,9–14,4 h. Auffällig, aber kein Fehler: In Epoche 9–10 erreicht der
  Referenzspieler im Schnitt nur 2,2–2,4 Sterne (er hält den Dampfhammer auch außerhalb des Zielfensters). Grafischer
  Spieltest 0 Probleme, Tests 2151/0.
- 21.11.: **Epoche 1 auf Alpha-Niveau – Bestandsaufnahme** (`tools/audit_epoch1.tscn`, 38 Bildschirme). Behoben: Schlagstärke-
  Knöpfe erschienen nach der Lehrzeit nicht (Fehler); Laden zeigt die Einrichtung erst nach der Lehrzeit, Hämmer oben;
  zu teure Angebote gedämpft mit Fehlbetrag im Tooltip; Häkchen und Schieberegler im Spielstil; Hinweis Schlagstärke für
  Epoche 1 (nur Leicht/Schwer), Tippfehler; Mitwirkende aktualisiert (Bilder, Schriften mit Lizenz); Hammer liegt ohne
  Werkstück auf dem Amboss; Werkstück auf dem Amboss größer; Bildausschnitt im Epochenwechsel; mehr Rand unten in Fenstern;
  Meisterstück-Kennzeichnung. Prompt-Heft: neue Reihenfolge „Jetzt: Epoche 1 auf Alpha-Niveau“.
  Schlagserie zählt Maschinenschläge weiter mit (Wunsch des Auftraggebers; bei Bedarf später kürzen).
- 21.11.: **Lieferung W3-2 bis W3-8** (erste Lieferung per GitHub Desktop). Gut: Ankerschaft, Bootshaken, Festmacherring,
  Schiffsbolzen, Lafettenbeschlag (W3-2–6). **Ändern:** Ruderfingerling W3-7 (dünner schräger Spieß statt L-förmigem
  Bandeisen mit Zapfen) – bis zum Ersatz im Spiel. **W3-8** (Schere mit Fingerringen) hat kein passendes Kürzel – liegt
  weiter im Eingang; vermutlich W4-2 Tuchschere, die aber als Federschere ohne Fingerringe gedacht ist. Prompts für
  W3-7 und W4-2 nachgeschärft, Erkenntnis in `LESSONS`. Import, Heft neu erzeugt.
- 21.11.: **E1-3 Schleifstein kam immer perspektivisch** (Hinweis des Auftraggebers). Ursache im Prompt: „orthographic front
  elevation“ und zugleich „front view from slightly above“. Alle Einrichtungs-Prompts jetzt „at eye level“; runde Teile
  (Schleifstein E1-3, Schleifbank E4-3, Drehbank E5-3, Kohlenhund E5-1, Kohlenwagen E8-1) in Seitenansicht „so that … is a
  perfect circle“ wie beim Wasserrad; Löschtrog (U15) ebenfalls ohne „von oben“. `LESSONS` ergänzt, Heft neu erzeugt.
- 21.11.: E1-3 in strenger Seitenansicht ergab technischen Unsinn (Kurbel auf der Steinfläche, Lager vor dem Stein). Neu:
  Mechanik Bauteil für Bauteil beschrieben, **leichte Dreiviertelansicht** erlaubt (Einrichtung steht im perspektivisch
  gemalten Raum; flach bleiben Esse, Amboss, Hämmer, Maschinen, Werkstücke); ebenso E4-3. `LESSONS` ergänzt.
- 21.11.: Import entfernt die gezeichnete schwarze Bodenlinie unter den Essen (Lehm-Esse zeigte einen dunklen Strich
  quer unter der Esse; Schweißofen und Siemens-Ofen leicht beschnitten). Einrichtung: Werkbank-Platz größer und höher
  (verschwand halb hinter der Glutskala), Kohle weiter an die Wand. Probe mit dem Schleifstein-Entwurf (Dreiviertelansicht)
  im Spiel: wirkt im perspektivisch gemalten Raum natürlich. **Offen zur Entscheidung:** E1-3 mit leichter Dreiviertel-
  ansicht (Empfehlung) oder streng flach mit anderem Stück; U5 Auftragsbuch als aufgeschlagenes Buch (Hochformat: rechte
  Seite ganz, links Falz und Streifen der linken Seite; Tablet: echte Doppelseite).
- 21.11.: **Lieferung Epoche 1 und Oberfläche (Midjourney):** E1-1–5, W1-4–8, U1–U7 eingebaut. **Gut:** Kohlekorb, Zangenbrett,
  Schleifstein (leichte Dreiviertelansicht, wie vereinbart), Schild, Türangel, Sichel, Schürhaken, Torriegel, Pergament,
  Knöpfe, Leiste, runder Glut-Knopf (Hammer und Zange), Auftragsbuch-Seite, Münzbeutel, Münzen. **Ändern:** E1-5 Laterne
  (Sturmlaterne mit Glaszylinder erst ab ~1850 → Blechlaterne mit Hornscheiben) und W1-6 Pflugschar (symmetrisch wie eine
  Kelle) – Prompts nachgeschärft, `LESSONS` ergänzt. U5 jetzt als aufgeschlagenes Buch formuliert, neu **U21** Doppelseite
  fürs Tablet (optional). W3-8 (Schere) weiter ohne passendes Kürzel im Eingang.
  Import angepasst: Pergament auf den deckenden Teil zugeschnitten (Fenstertitel saßen auf dem Rahmen), heller Schatten um
  die Knöpfe, innen offene Leiste dunkel gefüllt, eingeschlossene weiße Flächen der Einrichtung (Henkel, Aufhängung),
  grauer Verlauf bei Werkstücken (Schürhaken). Spiel: runder Glut-Knopf quadratisch, Schreibfläche der Buchseite neu
  vermessen, Kaufen-Knöpfe im Laden einheitlich hoch.
- 21.11.: **Lieferung U8–U20 und P1-4 (Midjourney).** Gut: Victoria-Münzen (ab Epoche 9 in der Abrechnung), Victoria-Siegel,
  Admiralitätssiegel, Pyrometer-Zeiger (vom Import waagerecht gedreht), Zifferblatt (optional, ungenutzt), Sterne, Sanduhr,
  Löschtrog (jetzt im Spiel), Store-Banner (Feature Graphic neu erzeugt), Meisterschafts-Siegel Bronze/Silber/Gold, Müller
  P1-4. **Ändern:** U9 linkes Siegel (Doppeladler statt Monogramm GR) – bisheriges George-III-Siegel bleibt; Prompt geschärft.
  Import für Sterne, Sanduhr, Löschtrog, Victoria-Münzen, Zeiger, Banner und hellgrauen Grund bei Siegeln erweitert.
  Noch Gemini: App-Icon (U16), Ladenbild Wasser-Schwanzhammer (ML1).
- 21.11.: **Ersatzbilder:** E1-5 Laterne (Blechlaterne mit Kerze), W1-6 Pflugschar (asymmetrisch), U9 Wachssiegel (GR mit Krone,
  Admiralitätsanker) und U16 App-Icon – alle gut und eingebunden (App-Icon in `store/` und `icon.png`). Damit sind alle Bilder
  der Epoche 1 und die ganze Oberfläche von Midjourney und abgenommen; noch Gemini: nur das Ladenbild Wasser-Schwanzhammer (ML1).
- 21.11.: **Entscheidungen des Auftraggebers umgesetzt:** Prompt-Heft Bereich **I – Rohformen** für alle 80 Werkstücke
  (W…R, mit Bild-Prompt `--iw 1.5`), **U22 Titelbild**, **U23 Meisterbrief**. Spiel: Werkstück zeigt nach dem ersten
  Arbeitsgang die Rohform (falls vorhanden), Hauptmenü nutzt das Titelbild, Abrechnung den Meisterbrief; Import für beide.
  **W3-8 → W4-2 Tuchschere** (Schneiderschere, Prompt angepasst). Musik später.
- 21.11.: **Wünsche des Auftraggebers:** „Laden“ heißt auch im Deutschen **Shop**; Schlagstärke **Sanft – Mittel – Fest**
  (alle Hinweise angepasst; englisch Soft/Medium/Firm). **Tastenhinweise:** am Rechner an jedem Knopf mit Taste (Aufträge [J],
  Shop [S], Personal [P], Statistik [T] – neu –, Sanft [←], Mittel [↓], Fest [→], HAMMERN [Leertaste], Rohling [R], Umlegen [E],
  Abschrecken [Q], Menü [Esc]); auf Handy/Tablet nie (die Übersetzung entfernt sie beim Laden und macht aus „Klickt“ „Tippt“;
  Test am Rechner mit `-- --touch`). **Hammer in Ruhelage** lehnt am Horn statt vor dem aufheizenden Werkstück zu stehen.
- 21.11.: **Dauerschlag an den Lehrling gebunden** (Entscheidung des Auftraggebers: „dann schlägt jemand anderer“): Bis zum
  Lehrling (Epoche 2) gibt jeder Druck auf HAMMERN/Leertaste genau einen Schlag; mit dem Lehrling hämmert Gedrückthalten
  fortlaufend (Hinweisfenster beim Einstellen, Beschreibung im Personal-Fenster, Kapitelübergang Epoche 2, Lehrzeit-Text).
  Maschinen lassen sich unabhängig davon immer halten. Tests 2153/0, Spieltest 0 Probleme.
- 21.11.: Neue Sitzung auf `claude/sharp-rubin-jfnibw`; Godot 4.7.2 installiert, Unit-Tests grün (2153/0). Eingang leer –
  warte auf W1-1R bis W1-8R, U22, U23.
- 21.11.: **W1-1R (Probe) abgelehnt:** Mit dem Nagel als Bild-Prompt und `--iw 1.5` kam wieder der fertige Nagel (Kopf, Spitze) –
  im Spiel wäre kein Stufensprung zu sehen. Rohform-Prompts neu: Stand **nach dem ersten Arbeitsgang** (Nagel: gestreckter
  Vierkantstab, stumpf, ohne Kopf und Spitze), Epoche 1 von Hand beschrieben, übrige Epochen aus den Arbeitsgängen in
  `data/items/*.tres`; was spätere Gänge formen, steht als `--no`; `--iw 0.5`; Material aus den Spieldaten (Sichel Eisen).
  `LESSONS` ergänzt, Heft neu erzeugt.
- 21.11.: **Lieferung W1-1R, W1-2R, E2-1, E2-2** (GitHub). **Gut:** Nagel- und Hufeisen-Rohform (im Spiel klar: Rohling →
  gestreckter Stab → fertiges Stück; Nagel-Rohform deckt sich fast genau mit dem Nagel), E2-2 Werkzeugwand (kleine Signatur
  unten rechts im Original weiß übermalt). **Ändern:** E2-1 Kohlenkiste wirkt wie eine Schatztruhe → Prompt: offene Bretterkiste
  ohne Deckel/Schloss, `LESSONS` ergänzt. Neues Prüfwerkzeug `tools/rough_check.tscn` (Stufensprung je Werkstück auf dem
  Amboss in fünf Stadien, Einrichtung je Epoche). Hinweis: Das fertige Bild erscheint erst mit dem letzten Arbeitsgang –
  beim Nagel sieht man die Spitze also erst in der Abrechnung. Tests 2153/0.
- 21.11.: **Frage des Auftraggebers: Halbzeuge für mehrere Werkstücke?** Im Projekt war nur „eine Rohform je Werkstück
  (80 Bilder)“ festgehalten; eine Absprache zum Teilen fand sich nirgends. **Entscheidung:** hohe Qualität, eigene Bilder; teilen
  nur, wo es keinen Vorteil bringt. Umgesetzt: `ROUGH_SHARED` (Postpferd-Hufeisen → Hufeisen; Lade-, Förder-, Anker-,
  Kupplungskette → Kettenglied; Lokomotiv-Radreifen, Geschützring → Radreifen) – 7 Bilder weniger, im Heft als „kein eigenes
  Bild nötig“ vermerkt; Spiel nutzt dann die geteilte Rohform (`Assets.rough_tex`), Unit-Test prüft die Tabelle.
- 21.11.: **Lieferung W1-3R bis W1-8R** – alle gut (Haken, Türangel, Sichel, Pflugschar, Schürhaken, Torriegel). Sichel-Rohform
  kam seitenverkehrt → Import spiegelt sie. Pflugschar: Sprung vor allem rau → glatt (entspricht dem Glätten). **Import:**
  Rohformen übernehmen jetzt Maßstab und Lage des fertigen Stücks (vorher einzeln auf volle Größe gezogen) → sauberes
  Überblenden. Im Spiel geprüft (`rough_check`, alle 8 + Postpferd-Hufeisen). **Alle Rohformen der Epoche 1 fertig.**
  Tests 2182/0.
- 21.11.: **Lieferung U21, U22, U23 – alle gut.** U22 Titelbild: stimmungsvoll, aber Schmied links und oberes Drittel nicht frei
  → Hauptmenü neu aufgebaut: Bildausschnitt um den Schmied (`TITLE_FOCUS` in `main_menu.gd`), Titel oben auf dunklem Verlauf,
  Knöpfe unten, dazwischen bleibt der Schmied sichtbar; Titelbild als JPG (370 KB statt 2,8 MB PNG). U23 Meisterbrief: in
  der Abrechnung groß (210 px statt 110) neben dem Text, Text schmaler, damit das Fenster nicht breiter wird. U21 Doppelseite
  liegt fürs Tablet bereit. Prompt U22: Schmied mittig, `LESSONS` ergänzt. Heft zählt bewertete Originale jetzt auch dann als
  vorhanden, wenn das Spiel sie (noch) nicht nutzt (U12, U21 standen fälschlich als fehlend). Tests 2182/0, Spieltest 0 Probleme,
  Bestandsaufnahme Epoche 1 neu aufgenommen. **Damit sind alle Bilder der Epoche 1 fertig.**
- 21.11.: **Rückmeldungen des Auftraggebers aus dem Anspielen (Epoche 1):**
  1. **Lehrzeit-Leiste** lag schon hinter dem Willkommensfenster und wiederholte bei jedem Auftrag dieselben Anweisungen →
     erscheint erst, wenn kein Fenster offen ist, und **jeder Schritt nur, bis er einmal erledigt ist** (`tut_<schritt>` in
     `seen_hints`, wird gespeichert). Statuszeile ohne Auftrag: „Kein aktiver Auftrag.“
  2. **Tasten für alle Knöpfe**, wo es sinnvoll ist (Belegung siehe „Fertig“); Ausnahmen bewusst (siehe dort).
  3. **P = Pausenmenü** (öffnet und schließt; Esc weiterhin); Personal dafür auf **[H]** (Helfer / englisch „hands“).
  4. **Auftrag wiederholen** als Pfeil-Symbol ↻ (eigenes Symbol `ui/icon_repeat.png`, Text im Tooltip) – spart Platz.
  5. **Geldanzeige „d“** (Auftraggeber dachte an „dime“/„day“): d = Penny (lat. denarius), £sd bis 1971. **Entschieden:**
     £ s d behalten + Erklärung beim ersten Lohn + Tooltip, ergänzt um Münzsymbole bei Statuszeile und Abrechnung.
  Tests 2182/0, Spieltest 0 Probleme, Bestandsaufnahme Epoche 1 geprüft.

## Prüfen

- Nach neuen Bildern: `python tools/art/import_user_art.py`, dann `godot --headless --path . --import`

- Unit-Tests: `godot --headless --path . res://tests/run_tests.tscn`
- Spieltest: `xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/playtest.tscn`
- Bestandsaufnahme Epoche 1 (alle Bildschirme): `xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/audit_epoch1.tscn`
- Stufensprung/Rohformen und Einrichtung: `xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/rough_check.tscn -- --items=nail,horseshoe --furn=2` (Bilder in `user://rough_check/`)
- Durchspiel-Test (ganzes Spiel, Epoche für Epoche): `godot --headless --path . res://tools/full_playthrough.tscn -- --seed=7`
- Balancing: `python tools/tune_balance.py`
- Übersetzungen: `python tools/content/gen_csv.py localization/translations.csv`
