# Epoche 1 auf Alpha-Niveau

Stand 21.11.2026 · Ziel: Epoche 1 (Die Dorfschmiede, Lehrzeit bis Meisterbrief) sieht fertig aus und spielt sich
ohne Stolperstellen. Was wir dabei an Bildern, Menüs und Optik lernen, gilt danach für alle Epochen.

**Prüfwerkzeug:** `xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/audit_epoch1.tscn`
nimmt alle 38 Bildschirme von Epoche 1 auf (Hauptmenü, Einstellungen, Mitwirkende, jeder Lehrzeit-Schritt, Auftragsbuch,
Schmieden, Abrechnungen, alle Hinweisfenster, Laden, eingerichtete Werkstatt, alle Fenster, Meisterstück, Meisterbrief,
Epochenwechsel). Bilder in `user://audit_e1/`.

## Alpha-Kriterien

| # | Kriterium | Stand |
|---|---|---|
| 1 | Alle Grafiken von Epoche 1 aus Midjourney und mit „gut“ bewertet, keine Platzhalter-Zeichnungen sichtbar | erledigt (21.11.) |
| 2 | Alle Menüs und Fenster im selben Stil (Pergament, Leder, Messing), nichts im Godot-Standardlook | erledigt (Häkchen und Regler neu) |
| 3 | Keine bekannten Fehler in Epoche 1 | erledigt (Durchspiel-Test, Bestandsaufnahme) |
| 4 | Texte geprüft (Rechtschreibung, Anrede „Ihr“, passend zu dem, was man gerade sieht) | erledigt für alle Hinweise der Epoche 1 |
| 5 | Lehrzeit führt ohne Umwege (nur das zeigen, was gerade gebraucht wird) | erledigt |
| 6 | Musik der Epoche 1 und Menümusik (Suno) | offen – Prompts im Musik-Heft |
| 7 | Klänge (Hammer, Esse, Münzen, Siegel) | Platzhalter – nach der Musik |

## Bestandsaufnahme 21.11. – behoben

1. **Fehler:** Nach der Lehrzeit erschienen die Knöpfe für die Schlagstärke nicht (erst nach einem Neustart), obwohl die
   Stärke ab dann zählt.
2. **Laden in der Lehrzeit:** Die Einrichtung stand ganz oben, noch bevor sie eingeführt wird – jetzt erst nach der Lehrzeit;
   in der Lehrzeit stehen die Hämmer oben (dort soll man den Kreuzschlaghammer kaufen).
3. **Zu teure Angebote** waren kaum von kaufbaren zu unterscheiden – jetzt gedämpft, im Tooltip steht, was noch fehlt.
4. **Einstellungen:** Häkchen und Schieberegler im Godot-Standardlook → Messingkästchen mit goldenem Häkchen, Messingknopf.
   Der Hinweis „Browserdaten können gelöscht werden“ erscheint nur noch in der Browserfassung.
5. **Hinweis Schlagstärke** nannte „Leicht, Mittel oder Schwer“ – in Epoche 1 gibt es nur Leicht und Schwer (Mittel kommt in
   Epoche 2 mit eigenem Hinweis). Tippfehler im Hinweis „Arbeitsgänge“ korrigiert.
6. **Mitwirkende:** „Grafik … Platzhalter, die zur Laufzeit erzeugt werden“ war veraltet → Bilder (Midjourney, Gemini),
   Schriften (EB Garamond, IM FELL English SC, SIL Open Font License), Klänge/Musik vorläufig.
7. **Handhammer** schwebte ohne Werkstück erhoben über der Esse → liegt jetzt auf der Ambossbahn, erst mit Werkstück erhoben.
8. **Werkstück auf dem Amboss** war schwer zu erkennen → größer dargestellt.
9. **Epochenwechsel-Fenster** zeigte fast nur die Deckenbalken → Ausschnitt mit Rückwand und Fenster.
10. **Fenster:** letzte Zeile klebte am Brandrand des Pergaments → mehr Rand unten.
11. **Meisterstück** stand im Auftragsbuch als „Meilenstein“ → „Meisterstück“.

## Noch offen (Code)

- **Testmenü-Knöpfe** (Hauptmenü, Pause) nur in der Entwicklerfassung, nicht im Export.
- Erledigt 21.11.: Tastenhinweise nur am Rechner (dort an jedem Knopf), Einrichtung im Shop mit Bildern, „Shop“ statt
  „Laden“, Schlagstärke Sanft/Mittel/Fest, Hammer lehnt in Ruhelage am Horn, Dauerschlag erst mit dem Lehrling.

## Noch fehlende Bilder für Epoche 1 (Stand 21.11.)

U22 Titelbild, U23 Meisterbrief. (Rohformen W1-1R bis W1-8R: alle geliefert und gut, 21.11.)

## Benötigte Bilder (Kürzel aus dem Prompt-Heft)

| Priorität | Kürzel | Was | Warum |
|---|---|---|---|
| 1 | **E1-1 … E1-5** | Einrichtung: Holzkohlekorb, Zangenbrett, Schleifstein, Schild mit Hufeisen, Talglaterne | In der Werkstatt sieht man sonst grobe Platzhalter |
| 2 | **W1-4 … W1-8** | Türangel, Sichel, Pflugschar, Schürhaken, Torriegel | Noch Gemini, Stil passt nicht zu Nagel/Hufeisen/Haken |
| 3 | **U1 – U5** | Pergament, Knöpfe, Leisten, Glut-Knopf, Auftragsbuch-Seite | Auf jedem Bildschirm sichtbar, noch Gemini |
| 4 | **U18 – U20** | Meisterschafts-Siegel Bronze, Silber, Gold | Bisher vom Spiel gezeichnet |
| 4 | **U6, U7, U9, U13** | Münzbeutel, Münzen, Wachssiegel, Sterne | Gemini bzw. fehlt |
| 5 | **P1-4** | Müller von Upton (ändern) | einziges nicht abgenommenes Porträt der Epoche 1 |
| 5 | **U16** | App-Icon | Gemini |

Fertig und abgenommen für Epoche 1: Hintergrund BG1, Lehm-Esse F1, Amboss, Hand- und Kreuzschlaghammer, Rohling, Nagel,
Hufeisen, Haken, fünf Porträts.

## Schwache Grafiken (ehrliche Einschätzung, 21.11.)

- **U4 Glut-Knopf HAMMERN:** Das Symbol ist ein Zahnrad mit Hammer – ein Industrie-Zeichen, das nicht in eine Dorfschmiede
  von 1700 passt. Prompt geändert: gekreuzter Hammer und Zange, ausdrücklich ohne Zahnrad.
- **W1-4 bis W1-8 (Gemini):** flach, wenig Schmiedespuren, uneinheitliche Größe und Blickrichtung – neben den
  Midjourney-Stücken (Nagel, Hufeisen, Haken) fällt der Unterschied im Musterbuch sofort auf.
- **Einrichtung:** bisher nur meine Platzhalter-Zeichnungen (Laterne als gelbes Rechteck, Schild als brauner Kasten) – das
  ist im Moment das Schlechteste im Bild.
- **Hauptmenü:** nur der abgedunkelte Werkstatt-Hintergrund – wirkt leer (siehe Vorschlag Titelbild).

## Entschieden (21.11.)

- **Rohformen für den Stufensprung: ja, je Werkstück eine eigene** (hohe Qualität); geteilt nur, wo der Stand nach dem
  ersten Arbeitsgang gleich ist (`ROUGH_SHARED`, 7 Werkstücke) – – Prompt-Heft Bereich I (Kürzel W1-1R … W10-8R, 80 Bilder),
  fertiges Werkstück als Bild-Prompt mit `--iw 1.5`. Zuerst Epoche 1 (W1-1R bis W1-8R). Das Spiel zeigt Rohling →
  (nach dem ersten Arbeitsgang) Rohform → fertiges Stück, sobald ein Rohform-Bild vorhanden ist.
- **Titelbild für das Hauptmenü: ja** – U22 (1:1, oberes Drittel frei für den Titel). Das Hauptmenü nutzt es automatisch.
- **Meisterbrief: ja** – U23 (Urkunde mit Zunftsiegel). Die Abrechnung nach dem Meisterstück zeigt ihn statt des Goldsiegels.
- **W3-8 (Schere)** wird als **W4-2 Tuchschere** verwendet (Schneiderschere mit Fingerringen, Prompt angepasst).
- **Musik:** später.
