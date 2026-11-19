# Forge Workshop (Arbeitstitel)

2D-Schmiede-Simulation mit Incremental-/Tycoon-Elementen im Großbritannien des
18. Jahrhunderts. Umsetzung des Lastenhefts v1.1 (Stand 19.11.2026) in **Godot 4.3+ (GDScript)**.

> **Status:** Der Code ist vollständig geschrieben, wurde aber noch **nie in Godot
> ausgeführt**. In der Entwicklungsumgebung durfte die Engine nicht gestartet werden.
> Alle Skripte bestehen eine Syntaxprüfung (gdtoolkit), und die Spielregeln wurden mit
> einer unabhängigen Python-Simulation gegengerechnet. Beim ersten Start im Editor
> können trotzdem noch Fehler auftauchen. Siehe „Erster Start“.

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
| Ausschuss-Materialkosten | 20 % des Lohns **je Stück** (bei 12 Stück sonst unverhältnismäßig) |
| Löschtrog, Pyrometer | ohne Preis im Lastenheft: Löschtrog kommt mit Epoche 4; Pyrometer als Geschenk von Wedgwood beim Meilenstein „Werkzeug für die Töpferei in Etruria“ (Ep. 5, 1782) |
| Maschinen/Zuschläger auf kaltem Eisen | schlagen erst ab 400 °C (sonst Dauerschaden ohne Zutun des Spielers) |
| Zuschläger bei Großschmiedestücken | zählt als Handarbeit (× 0,25) |
| Schweißschläge | nur der Spieler; Maschinen pausieren in der Schweißphase |
| Zeitlimit Eilauftrag | max(45 s; 1,5 × geschätzte Dauer). Die Dauer wird mit dem Referenzspieler simuliert, inkl. Aufheizen und Mengen |
| Großschmiedestücke | werden erst angeboten, wenn eine Maschine vorhanden ist |
| Schweißaufträge | werden erst angeboten, wenn die Esse ≥ 1250 °C erreicht |
| Epochenwechsel mit laufendem Auftrag | Auftrag verfällt ohne Verlust (4.3) |
| Simulation während offener Fenster | pausiert (Laden, Auftragsbuch usw.) |
| Ruf | Titelstufen nach gesammelten Sternen; kosmetisch: Zunftschild in der Werkstatt |
| Geselle online | Einnahmen laufend, Gutschrift alle 10 s |

## Balancing-Befund

Eine unabhängige Nachrechnung des Referenzmodells (5.8) mit genau den Regeln aus
Kapitel 2–5 ergibt:

| Epoche | Spielzeit (Ziel) | Einnahmen (Ziel) |
|---|---|---|
| 1 | ca. 29 min (12) | £3 15s (£3 15s) |
| 2 | ca. 50 min (23) | £29 (£30) |
| 3 | ca. 90 min (56) | £100 (£109) |
| 4 | ca. 126 min (83) | £253 (£281) |
| 5 | ca. 183 min (131) | £701 (£779) |
| 6 | ca. 256 min (157) | £1.701 (£1.890) |
| **Gesamt** | **ca. 12,2 h (7,7 h)** | |

Die Einnahmen treffen die Zielwerte gut. Die Spielzeit liegt aber etwa 60 % darüber, vor
allem weil jeder Rohling bei 20 °C startet: Mit der Lehm-Esse (25 °C/s) dauert allein das
erste Aufheizen 43 s, der erste Auftrag also rund 56 s statt 20 s. Das Referenzmodell in
5.8 berücksichtigt dieses Aufheizen offenbar nicht. Das Abnahmekriterium „±25 %“
(Phase 3) wird mit den Startwerten daher verfehlt. Mögliche Stellschrauben in
`balance_config.tres` bzw. den Essen: höhere `k_heat`, vorgewärmte Rohlinge oder weniger
Aufträge je Epoche. Die Werte sind laut 5.8 ohnehin Startwerte für Spielertests.

## Offene Punkte (Kapitel 12)

Geschäftsmodell, Vertrieb, finale Grafik und Musik, Prestige-System, endgültiger Titel
und °F-Anzeige sind weiter offen und nicht umgesetzt. Mobile-Exporte (Phase 6) folgen
später; das UI nutzt schon jetzt Touch-Ziele ≥ 48 px und Tippen statt Ziehen.
