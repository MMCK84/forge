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
   godot --path . --rendering-driver opengl3 --resolution 1920x1080 res://tools/playtest.tscn
   ```

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
| Balancing | Aufheizraten, FP_Start und Satz auf die Zielzeiten aus 5.8 abgestimmt (siehe „Balancing“); Löhne unverändert |
| Ausschuss-Materialkosten | 20 % des Lohns **je Stück** (bei 12 Stück sonst unverhältnismäßig) |
| Löschtrog, Pyrometer | ohne Preis im Lastenheft: Löschtrog kommt mit Epoche 4; Pyrometer als Geschenk von Wedgwood beim Meilenstein „Werkzeug für die Töpferei in Etruria“ (Ep. 5, 1782) |
| Maschinen/Zuschläger auf kaltem Eisen | schlagen erst ab 400 °C (sonst Dauerschaden ohne Zutun des Spielers) |
| Zuschläger bei Großschmiedestücken | zählt als Handarbeit (× 0,25) |
| Schweißschläge | nur der Spieler; Maschinen pausieren in der Schweißphase |
| Lehrling und Härten | Er holt fertig geschmiedete Härte-Stücke bei ca. 830 °C aus der Esse auf den Amboss (sonst verbrennen sie in heißen Essen); abschrecken muss der Spieler |
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
Aufheizen 43 s. Das Referenzmodell in 5.8 rechnet dieses Aufheizen offenbar nicht mit.

Die Werte sind deshalb auf die Zielzeiten aus 5.8 abgestimmt (`tools/tune_balance.py`):

| Wert | Lastenheft | Jetzt |
|---|---|---|
| Aufheizrate Lehm- / Ziegel- / Doppelblasebalg- / Koks-Esse | 25 / 40 / 65 / 100 °C/s | 60 / 80 / 100 / 130 °C/s |
| FP_Start Epoche 1–6 | 300 / 1.800 / 6.000 / 12.000 / 25.000 / 40.000 | 114 / 900 / 4.012 / 8.380 / 18.264 / 24.599 |
| Satz (d je Form-Punkt) Epoche 1–6 | 0,040 / 0,040 / 0,035 / 0,045 / 0,050 / 0,065 | 0,1053 / 0,080 / 0,0523 / 0,0644 / 0,0684 / 0,1057 |

FP_Start und Satz sind im selben Verhältnis geändert: **Die Löhne je Auftrag (Tabelle 3.3)
bleiben exakt gleich**, nur der Arbeitsaufwand sinkt. Alle anderen Regeln (Faktor 5 je
Epoche, Temperaturen, Schaden, Sterne, Preise, Gebühren) sind unverändert.

Ergebnis der Balancing-Simulation in Godot (Referenzspieler aus 5.8):

| Epoche | Spielzeit (Ziel) | Einnahmen (Ziel) | Spielzeit mit Auftragsmix |
|---|---|---|---|
| 1 | 12,3 min (12) | £3 15s (£3 15s) | 12,4 min |
| 2 | 22,9 min (23) | £28 19s (£30) | 26,7 min |
| 3 | 56,0 min (56) | £100 (£109) | 59,5 min |
| 4 | 83,0 min (83) | £253 (£281) | 75,5 min |
| 5 | 131,0 min (131) | £701 (£779) | 135,3 min |
| 6 | 157,0 min (157) | £1.698 (£1.890) | 151,6 min |
| **Gesamt** | **7,70 h (7,7 h)** | | **7,68 h** |

„Auftragsmix“ nutzt den echten Generator (Qualitätsstufen, Mengen-, Eil-, Präzisions-,
Schweiß-, Härte- und Großaufträge). Dort liegen die Einnahmen 13–44 % über den Zielwerten,
weil feine und meisterliche Qualität, Präzision, Eile und Meilensteine laut 3.2/3.3 mehr
zahlen als der Referenzauftrag. Die Werte bleiben Startwerte für Tests mit echten Spielern (5.8).

## Offene Punkte (Kapitel 12)

Geschäftsmodell, Vertrieb, finale Grafik und Musik, Prestige-System, endgültiger Titel
und °F-Anzeige sind weiter offen und nicht umgesetzt. Mobile-Exporte (Phase 6) folgen
später; das UI nutzt schon jetzt Touch-Ziele ≥ 48 px und Tippen statt Ziehen.
