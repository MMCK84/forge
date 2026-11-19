# Forge Workshop (Arbeitstitel)

2D-Schmiede-Simulation mit Incremental-/Tycoon-Elementen im Großbritannien des
18. Jahrhunderts. Umsetzung des Lastenhefts v1.1 (Stand 19.11.2026) in **Godot 4.3+ (GDScript)**.

> **Status:** In Godot 4.3 getestet. 935 Unit-Prüfungen sind grün, und ein automatischer
> grafischer Spieltest (`tools/playtest.gd`) spielt alle sechs Epochen mit Mengenaufträgen,
> Feuerschweißen, Härten, Maschinen, Großschmiedestücken, Speichern/Laden und allen Fenstern
> ohne Laufzeitfehler durch. Von Menschen gespielt wurde das Spiel noch nicht.

## Erster Start

1. Godot **4.3 oder neuer** (Standard-Version, nicht .NET) installieren.
2. Im Projektmanager „Importieren“ → `project.godot` wählen → Projekt öffnen.
   Beim ersten Öffnen legt der Editor den Klassen-Cache an (`class_name`), der für
   alle weiteren Schritte nötig ist.
3. Mit **F5** starten.
4. Tests ausführen (Ausgabe in der Konsole, Exit-Code 0 = alles grün):

   ```bash
   godot --headless --path . res://tests/run_tests.tscn
   ```

5. Balancing-Simulation (Referenzspieler aus 5.8, spielt alle 6 Epochen durch):

   ```bash
   godot --headless --path . -s res://tools/balance_sim.gd
   ```

   Mit realistischem Auftragsmix (Mengen-, Schweiß-, Härteaufträge usw.):

   ```bash
   godot --headless --path . -s res://tools/balance_sim.gd -- --mixed
   ```

6. Grafischer Spieltest (spielt Abläufe durch und speichert Screenshots nach `user://playtest/`):

   ```bash
   godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/playtest.tscn
   ```

## Testmenü (F12)

Für Tests gibt es ein Testmenü: **F12** in der Werkstatt oder im Hauptmenü, alternativ
der Knopf „Testmenü“ im Pausen- und Hauptmenü. Es ist nur in Testversionen vorhanden
(Start aus dem Godot-Editor oder Debug-Export), nicht im Release-Build.

* **In eine Epoche springen:** Epoche 1–6, jeweils Anfang, Mitte oder Ende. Meilensteine
  davor gelten als erledigt, Ausrüstung und Personal der Epoche werden ergänzt, Geld bleibt.
* **Test-Spielstände:** 5 Plätze zum Speichern, Laden und Löschen (getrennt vom normalen
  Spielstand, unter `user://test_slots/`), dazu „Neues Spiel starten“.
* **Schnellaktionen:** Geld (+£10 / £100 / £1.000), Auftrag sofort mit 3 Sternen abschließen,
  neue Angebote ohne Wartezeit, Spieltempo ×1 / ×2 / ×4.
* Oben stehen Epoche, Auftragsnummer und Komplexitätsgrad (0 = Epochenanfang, 1 = Ende).

## Steuerung (2.7)

| Aktion | Maus | Touch | Tastatur |
|---|---|---|---|
| Hammerschlag | Klick auf Amboss / Knopf „HAMMERN“ | Tippen | Leertaste |
| Rohling einlegen | Klick auf Rohling-Stapel oder leeren Esse-Platz | Tippen | R |
| Umlegen | Klick auf Werkstück in der Esse bzw. auf einen Esse-Platz | Tippen | E |
| Werkstück wählen | Klick | Tippen | 1 / 2 / 3 |
| Abschrecken (ab Ep. 4) | Klick auf Löschtrog | Tippen | Q |
| Auftragsbuch / Laden / Personal | Schaltflächen | Schaltflächen | J / S / P |
| Pause / Menü | Schaltfläche | Schaltfläche | Esc |

Mehr als 8 Schläge/s werden ignoriert. Der Halten-Modus (Einstellungen) erzeugt 4 Schläge/s.

## Export (1.3)

`export_presets.cfg` enthält Vorlagen für **Web** (Single-Threaded, keine COOP/COEP-Header
nötig, z. B. für itch.io), **Windows**, **Linux** und **macOS**. Die Export-Templates
installiert man über *Editor → Export-Templates verwalten*.

## Projektstruktur (8.1)

```
data/                 Balancing-Werte und Kataloge als .tres (ohne Codeänderung anpassbar)
  balance/balance_config.tres   alle Balancing-Konstanten
  hammers/ forges/ machines/ staff/ items/ customers/ milestones/epoch_1..6/
localization/         translations.csv (de, en) – wird zur Laufzeit geladen
resources/            Resource-Klassen (BalanceConfig, HammerData, …, JobInstance)
scenes/autoload/      GameManager, SaveManager, SoundManager
scenes/main/          Hauptszene, Werkstatt, Esse, Amboss, Löschtrog, Maschine, Werkstück
scenes/ui/            HUD, Auftragsbuch, Laden, Personal, Einstellungen, Menüs, Tutorial
scripts/              economy.gd, heat_model.gd, workshop_sim.gd, job_generator.gd,
                      reference_player.gd, catalog.gd, localization.gd, sfx_synth.gd, item_shapes.gd
shaders/glow.gdshader Glutfarben-Shader
assets/               gerenderte Grafiken, Klänge, Musik, Schriften
tools/art/            Render-Pipeline für alle Assets (Python)
tests/                Unit-Tests (eigener kleiner Runner, keine Abhängigkeit von GUT)
tools/balance_sim.gd  Balancing-Simulation
```

Die Spiellogik (`scripts/workshop_sim.gd`) ist von der Darstellung getrennt. Dieselbe
Simulation treibt das Spiel, die Tests, die geschätzte Dauer im Auftragsbuch, das
Zeitlimit von Eilaufträgen und die Balancing-Simulation.

## Grafik und Ton

Alle Assets werden **offline per Skript gerendert** (`tools/art/`) und liegen fertig in `assets/`:

| Bereich | Inhalt |
|---|---|
| `assets/sprites/environment/` | 6 Werkstatt-Hintergründe (je Epoche: Fachwerk-Dorfschmiede, Poststraße, Hafen, Sheffield, Hammerwerk mit Blick auf die Eisenbrücke, Eisenwerk), 4 Essen-Stufen, Glutbett, Feuerschein |
| `assets/sprites/tools/` | Amboss mit Klotz, Handhammer, Blasebalg, Zylindergebläse, Löschtrog, Schwanzhammer (Ständer, Helm, Kopf), Wasserrad, Dampfmaschine mit Balancier und Schwungrad |
| `assets/sprites/items/` | ein graustufiges Sprite je Gegenstand (48 + Rohling); der Glow-Shader färbt es nach Temperatur ein (6.5) |
| `assets/sprites/portraits/` | 32 Kundenporträts im Ovalrahmen |
| `assets/sprites/ui/` | Pergament, Holzknöpfe mit Messingrand, Lederleiste, Münze, Sterne, Sanduhr, Funken-/Rauchpartikel, Titel-Schriftzug |
| `assets/fonts/` | EB Garamond (Text) und IM Fell English SC (Überschriften), beide unter SIL Open Font License |
| `assets/audio/sfx/` | 21 Effekte: 3 Varianten Amboss-Schlag, schwach, kalt („Klonk“), überhitzt (Zischen), Schweißen (Funkenregen), Abschrecken, Ausschuss, Münzen, Pergament, Wasser-/Dampfhammer u. a. |
| `assets/audio/ambience/` | Schleifen: Kohlefeuer, Wasserrad, Dampfmaschine |
| `assets/audio/music/` | Menü-Thema + 1 Stück je Epoche (Jig, Hornpipe, Seemannsweise, Menuett, Country Dance, Marsch); Besetzung wächst: Laute → + Cello → + Flöte → + Violine → + Cembalo |

Stil: handgezeichnet wirkend mit Tuschekontur, Malstruktur, Kupferstich-Schraffur und warmem
Licht der Esse. Instrumente sind physikalisch modelliert (Karplus-Strong-Laute, gestrichene
Saiten, Flöte), keine Aufnahmen. Größe aller Assets: ca. 18 MB (Ziel Web < 40 MB, 9.1).

Neu erzeugen (Python 3.11+ und ffmpeg mit libvorbis):

```bash
pip install -r tools/art/requirements.txt
```

```bash
python tools/art/render_all.py
```

Fehlt eine Datei, nutzt das Spiel automatisch die im Code gezeichnete bzw. synthetisierte
Ersatzvariante. Für ein kommerzielles Release bleibt Kapitel 12 (Punkte 3 und 4) offen:
Die gerenderten Assets sind solide, ersetzen aber keinen Illustrator und keine eingespielte Musik.

### Hochformat (Mobile)

Das Spiel läuft im **Hochformat**: Grundauflösung 720 × 1280 (Bedienoberfläche), die Werkstatt-Bühne
ist in 1080 × 1920 gezeichnet und wird eingepasst. Am PC öffnet sich ein hochkantes Fenster
(540 × 960, frei skalierbar). Aufbau von oben nach unten: Statusleiste (Geld, Menü, Epoche,
Hammer, aktueller Auftrag) – Esse an der Rückwand – Amboss mit Rohling-Stapel, Löschtrog und
Maschine – Bedienfeld (Glühskala, Fortschritt, Aktionen, großer HAMMERN-Knopf) – Navigationsleiste
(Aufträge, Laden, Personal, Statistik). Fenster sind schmal und scrollen bei Bedarf. Höhere
Handys (20:9) bekommen oben und unten verlängerten Hintergrund; breite Fenster seitliche Ränder.
Die Wand-Boden-Kante je Hintergrund steht in `workshop_background.gd` (`USER_FLOOR_Y`), daran
wird die Esse ausgerichtet. App-Icon und Store-Grafiken liegen in `store/`.

### Grafiken des Auftraggebers

Die selbst erstellten Grafiken (Originale in `assets/source/user_art/`, Prompts in
`Graphiken_HUD_und_UI.docx`, `Graphiken_Werkstatt_Equipment.docx`, `PROMPTS_Werkstuecke.md`
und `PROMPTS_Hochformat.md`) werden mit `python tools/art/import_user_art.py` freigestellt,
zerlegt, skaliert und nach `assets/sprites/ui/user/` geschrieben. Das Spiel bevorzugt sie
automatisch; fehlt eine Datei, greift wieder die gerenderte Variante.

| Grafik | Verwendung |
|---|---|
| 6 Werkstatt-Hintergründe (Hochformat) | je Epoche ein Raum; Esse, Amboss und Maschinen stehen davor |
| Lehm-, Ziegel-, Doppelblasebalg- und Koks-Esse | Essen-Stufe 1–4 (Glut eingemalt, Feuerschein flackert darüber, Plätze auf dem Glutbett, Rauch aus dem Schornstein) |
| Amboss auf Eichenklotz | Amboss in allen Epochen |
| Handhammer, Kreuzschlaghammer, Hammer mit verstählter Bahn, Tiegelstahl-Hammer | Bild im Laden und schwingender Hammer über dem Amboss |
| Wasser-Schwanzhammer mit Wasserrad | Bild im Laden |
| Maschinen-Einzelteile (Wasserrad, Hammerbalken, Gestell, Schwungrad, Dampfmaschine, Balancier) | animierte Maschinen in Epoche 5/6: Rad und Schwungrad drehen sich, der Balancier wippt, der Hammerbalken schlägt auf den Amboss (auch bei eigenen Schlägen; der Handhammer ist dann ausgeblendet). Den eingemalten Arm der Dampfmaschine entfernt das Importskript. |
| Auftragsbuch-Seite | Auftragsbuch (Angebote untereinander, scrollbar) |
| Pergament mit Messingecken | Hintergrund aller Fenster |
| Leder-Messing-Karte | alle Standardknöpfe (normal / Hover / gedrückt / gesperrt abgeleitet) |
| Holzrahmen mit Eisenplatte | Status- und Navigationsleiste |
| Glut-Knopf mit Hammer im Zahnrad | großer HAMMERN-Knopf (Daumen, rechts unten) |
| Wachssiegel George III / Admiralität | Meilenstein-Aufträge bzw. Marine-Kunden im Auftragsbuch und in der Abrechnung |
| Guinee, Shilling, Halfpenny | Münzen neben dem gutgeschriebenen Betrag |
| Münzbeutel | Geldanzeige |
| Pyrometer-Zeiger | Zeiger des Messing-Pyrometers (ab Freischaltung) |
| Rohling und alle 8 Werkstücke der Epoche 1 | Werkstück-Sprites; der Glow-Shader färbt sie stufenlos nach Temperatur (Sticker-Ränder werden entfernt) |
| App-Icon, Store-Banner | `icon.png` und `store/` (512, 1024, Feature Graphic 1024 × 500) |

Nicht verwendet: Pyrometer-Zifferblatt (Zeiger eingemalt), Siegel „Regina Victoria“ (1837 ff.),
Siegel Ludwig XV. und Russland (kein Kunde), Karte 4 (Art déco), das aufgeschlagene Kontorbuch
(Doppelseite zu breit fürs Hochformat), die ersten Fassungen von Stein- und Koks-Esse (Feueröffnung
zu schmal für 3 Plätze), Holzschlegel und Steinhammer (keine Schmiedewerkzeuge des 18. Jh.),
Dampf-Fallhammer (erst ab 1839) und die glühenden Hufeisen (Glut kommt aus dem Shader).
Weitere Werkstücke: Bild als `assets/source/user_art/items/<item_id>.webp` ablegen und das
Importskript starten. Kleine Unschärfe: George III regierte ab 1760 – Siegel und Münzen sind in
den Epochen 1–3 streng genommen etwas zu früh. Vor einer Veröffentlichung die Nutzungsbedingungen
des verwendeten Bildgenerators prüfen.

## Erweiterungen gegenüber dem Lastenheft

Nach den ersten Spieltests wurde das Spiel um mehr Abwechslung erweitert:

**Arbeitsgänge.** Jedes Werkstück entsteht in 2–3 Arbeitsgängen, jeder mit eigenem
Zielfenster (Schmiedeeisen):

| Arbeitsgang | Zielfenster | Arbeitsgang | Zielfenster |
|---|---|---|---|
| Strecken | 950–1100 °C | Lochen | 800–950 °C |
| Stauchen | 1000–1100 °C | Biegen | 750–900 °C |
| Breiten | 850–1050 °C | Verdrehen | 750–900 °C |
| Anspitzen | 850–1000 °C | Schlichten | 700–850 °C |
| Spalten | 900–1050 °C | | |

Ein Hufeisen wird zum Beispiel gestreckt, gebogen und gelocht. Die Glutfarben-Skala zeigt
das Fenster des aktuellen Arbeitsgangs, die Abschnitte über dem Fortschrittsbalken die
Reihenfolge. Nur Schläge im Fenster zählen für die Qualität (Sterne). Präzisionsaufträge
nutzen die mittleren 60 % jedes Fensters. Feuerschweißen liegt immer an einer Grenze
zwischen zwei Arbeitsgängen. Die Werte stehen in `balance_config.tres` (`step_windows`),
die Arbeitsgänge je Gegenstand in `data/items/*.tres`.

**Werkstoffe.** Stahl (Klingen, Federn, Werkzeuge, Sicheln, Spindeln) wird 50 °C kühler
geschmiedet; alle Grenzen verschieben sich mit, er verbrennt also schon ab 1250 °C.

**Steigende Komplexität.** Innerhalb jeder Epoche wächst ein Komplexitätsgrad von 0 auf 1.
Er bestimmt, welche Gegenstände kommen (sortiert nach Arbeitsgängen, Werkstoff, Aufwand),
wie hoch die Qualitätsstufen sind (am Anfang 55 % „Einfach“, am Ende 20 % „Meisterlich“)
und wie oft Präzisions-, Eil-, Spezial- und Mengenaufträge auftreten (×0,3 am Anfang,
×1,7 am Ende; Mengen anfangs nur ×2, später bis ×12). Präzisionsaufträge gibt es in
Epoche 1 schon ab dem 5. Auftrag.

## Umsetzungsentscheidungen

An einigen Stellen war das Lastenheft offen oder widersprüchlich. So wurde entschieden;
alle Zahlen liegen in `balance_config.tres`:

| Thema | Entscheidung |
|---|---|
| Anzeige „£26 0s 10d“ (Tabelle 3.3) | Regel aus 2.2 hat Vorrang (Nullstellen weglassen): **£26 10d** |
| Tausendertrennzeichen | de „.“, en „,“ |
| Anteile Spezialaufträge | 40 % Schweißen + 35 % Härten + 30 % Großschmiede ergäben in Ep. 6 über 100 %. Gewählt: Ep. 3: 40/–/–, Ep. 4: 30/35/–, Ep. 5: 30/30/–, Ep. 6: 25/20/30 |
| Anteil Mengenaufträge | nicht spezifiziert: 35 % ab Ep. 2 (Ep. 6: 30 %), Mengen 2–12 gewichtet zugunsten kleiner Mengen |
| Freischaltung der Meilensteine | gleichmäßig verteilt: Meilenstein i von m ab n = round(i·(N_e−1)/m); der letzte beim letzten Auftrag |
| Balancing | Aufheizraten, FP_Start und Satz auf die Zielzeiten aus 5.8 abgestimmt, gemessen mit dem echten Auftragsmix (siehe „Balancing“); Löhne unverändert |
| Ausschuss-Materialkosten | 20 % des Lohns **je Stück** (bei 12 Stück sonst unverhältnismäßig) |
| Löschtrog, Pyrometer | ohne Preis im Lastenheft: Löschtrog kommt mit Epoche 4; Pyrometer als Geschenk von Wedgwood beim Meilenstein „Werkzeug für die Töpferei in Etruria“ (Ep. 5, 1782) |
| Maschinen/Zuschläger auf kaltem Eisen | schlagen erst ab 400 °C (sonst Dauerschaden ohne Zutun des Spielers) |
| Zuschläger bei Großschmiedestücken | zählt als Handarbeit (× 0,25) |
| Schweißschläge | nur der Spieler; Maschinen pausieren in der Schweißphase |
| Lehrling | Er kennt die Fenster der Arbeitsgänge. Wartende Stücke hält er am Rand des Feuers, bis der Amboss frei wird; bei voller Esse tauscht er. Fertige Härte-Stücke holt er bei ca. 830 °C auf den Amboss und legt sie zurück, wenn sie zu kalt werden; abschrecken muss der Spieler |
| Lehm-Esse | Höchsttemperatur 1200 statt 1100 °C, damit auch in Epoche 1 Überhitzen möglich ist (Gefügeschaden, aber kein Verbrennen) |
| Tauschen | Taste E bzw. „Umlegen“ tauscht bei voller Esse das Amboss-Stück gegen das gewählte bzw. heißeste Stück in der Esse; ebenso ein Klick auf ein Stück in der Esse |
| Zeitlimit Eilauftrag | max(45 s; 1,5 × geschätzte Dauer). Die Dauer wird mit dem Referenzspieler simuliert, inkl. Aufheizen und Mengen |
| Großschmiedestücke | werden erst angeboten, wenn eine Maschine vorhanden ist |
| Schweißaufträge | werden erst angeboten, wenn die Esse ≥ 1250 °C erreicht |
| Epochenwechsel mit laufendem Auftrag | Auftrag verfällt ohne Verlust (4.3) |
| Simulation während offener Fenster | pausiert (Laden, Auftragsbuch usw.) |
| Ruf | Titelstufen nach gesammelten Sternen; kosmetisch: Zunftschild in der Werkstatt |
| Geselle online | Einnahmen laufend, Gutschrift alle 10 s |

## Balancing (abgestimmt auf 5.8)

Mit den Startwerten des Lastenhefts ergab die Simulation **12,3 h statt 7,7 h**: Jeder
Rohling startet bei 20 °C, und mit der Lehm-Esse (25 °C/s) dauerte allein das erste
Aufheizen 43 s. Mit Arbeitsgängen kommen weitere Hitzen hinzu.

Abgestimmt wird mit `tools/tune_balance.py` auf die Zielzeiten aus 5.8, und zwar mit dem
**echten Auftragsmix** (Generator mit steigender Komplexität), gemittelt über vier Seeds:

| Wert | Lastenheft | Jetzt |
|---|---|---|
| Aufheizrate Lehm- / Ziegel- / Doppelblasebalg- / Koks-Esse | 25 / 40 / 65 / 100 °C/s | 90 / 110 / 125 / 150 °C/s |
| Höchsttemperatur Lehm-Esse | 1100 °C | 1200 °C |
| FP_Start Epoche 1–6 | 300 / 1.800 / 6.000 / 12.000 / 25.000 / 40.000 | 75 / 450 / 1.728 / 5.875 / 13.943 / 24.083 |
| Satz (d je Form-Punkt) Epoche 1–6 | 0,040 / 0,040 / 0,035 / 0,045 / 0,050 / 0,065 | 0,160 / 0,160 / 0,1215 / 0,0919 / 0,0897 / 0,1080 |

FP_Start und Satz sind im selben Verhältnis geändert: **Die Löhne je Auftrag (Tabelle 3.3)
bleiben exakt gleich**, nur der Arbeitsaufwand sinkt. Die Untergrenze von 25 % der
ursprünglichen Form-Punkte sorgt dafür, dass auch frühe Aufträge rund 15 Hammerschläge brauchen.

Ergebnis (Auftragsmix, Mittel aus vier Seeds):

| Epoche | Spielzeit | Ziel (5.8) |
|---|---|---|
| 1 | 12,9 min | 12 min |
| 2 | 26,6 min | 23 min |
| 3 | 56,1 min | 56 min |
| 4 | 83,0 min | 83 min |
| 5 | 131,0 min | 131 min |
| 6 | 156,9 min | 157 min |
| **Gesamt** | **7,78 h** | **7,7 h** |

Gegenprobe mit vier weiteren Seeds: 7,3–7,8 h. In den Epochen 1 und 2 bestimmen Aufheizen
und Abkühlen zwischen den Arbeitsgängen die Dauer, deshalb liegen sie etwas über dem Ziel
(innerhalb der ±25 % aus Phase 3). Die Einnahmen liegen im Auftragsmix über den Zielwerten,
weil feine und meisterliche Qualität, Präzision, Eile und Meilensteine laut 3.2/3.3 mehr
zahlen als der Referenzauftrag. Die Werte bleiben Startwerte für Tests mit echten Spielern (5.8).

## Offene Punkte (Kapitel 12)

Geschäftsmodell, Vertrieb, finale Grafik und Musik, Prestige-System, endgültiger Titel
und °F-Anzeige sind weiter offen und nicht umgesetzt. Mobile-Exporte (Phase 6) folgen
später; das UI nutzt schon jetzt Touch-Ziele ≥ 48 px und Tippen statt Ziehen.
