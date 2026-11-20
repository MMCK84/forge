# Konzept: Aufbau der Werkstatt

Stand 20.11.2026 · Teil 1 (Einrichtung) vom Auftraggeber freigegeben und umgesetzt; Teil 2 und weitere Ideen offen

## Ausgangslage

Fortschritt gibt es viel (4 Hämmer mit 10 Verbesserungsstufen, 6 Essen, 4 Maschinen, 4 Arten Personal,
Ruf-Schild), aber er steckt fast nur in Zahlen und Menüs. Sichtbar ändert sich die Werkstatt nur beim
Epochenwechsel und beim Kauf einer Esse oder Maschine. Die langen Epochen (4–6 und 8–10, je 1,5–2,5 h)
haben dadurch lange Strecken, in denen „nichts wächst“.

Ziel: Der Spieler sieht seinen Betrieb in **jeder** Epoche Stück für Stück wachsen – mit kleinen,
spürbaren Vorteilen. Die Spielzeit darf dadurch länger werden, aber jeder Abschnitt soll ein nächstes,
sichtbares Ziel haben.

## Teil 1: Werkstatt-Einrichtung

### Grundidee

Jede Epoche hat **fünf Einrichtungsplätze**. Jeder Platz hat in jeder Epoche ein eigenes, zur Zeit und zum
Ort passendes Einrichtungsstück (eigenes Bild), aber immer **dieselbe Art von Wirkung**. So lernt der Spieler
die fünf Plätze einmal und baut sie in jeder neuen Werkstatt wieder auf.

**Neu je Epoche (Vorschlag):** Mit dem Umzug in die nächste Werkstatt beginnt der Aufbau von vorn. Das gibt
jeder Epoche einen eigenen Aufbaubogen, die Vorteile summieren sich nicht über das ganze Spiel auf (leicht
auszubalancieren), und die Bilder passen immer zum Raum.
*Alternative:* Einrichtung bleibt dauerhaft (Wirkung über alle Epochen). Stärkeres Sammelgefühl, aber die
Vorteile wachsen über 50 Käufe stark an und machen spätere Epochen zu leicht.

### Die fünf Plätze und ihre Wirkung

| Platz | Wirkung (Stufe der Epoche) | Stellschraube im Spiel |
|---|---|---|
| **A Brennstoff** (Kohlenkorb … Koksbunker) | Esse heizt **15 %** schneller | Heizrate der Esse (wie der Heizer, stapelbar) |
| **B Werkzeugwand** (Zangen, Setzhämmer, Gesenke) | **+10 %** Arbeitsfortschritt je Schlag | Schlagwirkung |
| **C Werkbank** (Schraubstock, Schleifstein, Lehren) | Präzisionsfenster **±25 °C breiter**, Gefügeschaden **−20 %** | Qualität / Sterne |
| **D Kundschaft** (Schild, Anschlagtafel, Kontor) | **4 statt 3** Angebote, Neu-Würfeln nach **30 s** statt 60 s | Auftragsbuch |
| **E Licht & Lager** (Laterne, Stabeisenlager, Gaslicht) | Lohn **+5 %**, Materialverlust bei Fehlschlag halbiert | Abrechnung |

Reihenfolge der Preise innerhalb einer Epoche: A und B früh (ca. 5–8 Aufträge Lohn), C und D mittel,
E zuletzt (ca. 25–30 Aufträge). Alle fünf zusammen kosten etwa ein Viertel bis ein Drittel der
Meistergebühr der Epoche. Die genauen Werte stimme ich mit `tools/tune_balance.py` ab.

Kleiner Abschluss je Epoche: **„Werkstatt vollständig eingerichtet“** als Meilenstein (Siegel, kleine Prämie).

### Einrichtung je Epoche (historisch passend)

| Ep. | A Brennstoff | B Werkzeugwand | C Werkbank | D Kundschaft | E Licht & Lager |
|---|---|---|---|---|---|
| 1 Dorfschmiede 1700 | Holzkohlekorb | Zangenbrett | Schleifstein mit Kurbel | bemaltes Brett mit Hufeisen über dem Tor | Talglaterne |
| 2 Kutschenstraße 1725 | Kohlenkiste | Werkzeugwand mit Gesenken | Werkbank mit Schraubstock | Schild „Smith & Farrier“ an der Straße | Stabeisenregal |
| 3 Hafen 1740 | Kohlenschütte | Gesenkblock (Swage block) | Werkbank mit Feilen | Anschlagtafel der Admiralität | Schiffslaterne |
| 4 Sheffield 1755 | Koksvorrat | Zangenreihe für Klingen | Schleifbock mit Wasserrad | Firmenmarke der Cutlers' Company | Öllampen |
| 5 Severn 1780 | Kohlenhund (Grubenwagen) | Werkzeugwand mit Setzhämmern | Drehbank mit Fußantrieb | Schreibpult mit Auftragsbuch | Stabeisenlager |
| 6 Eisenwerk 1790 | Koksbunker | Gesenksatz | Schraubstockbank | Kontor mit Schreiber | Öllampenreihe |
| 7 London 1810 | Kohlenaufzug | Normallehren und Schablonen | Werkbank mit Messschraube | Messingschild am Tor | **Gaslicht** (ab 1812 in London) |
| 8 Newcastle 1830 | Kohlenwagen auf Schienen | Gesenke für Kupplungen | Prüfbank | Anschlag der Eisenbahngesellschaft | Gaslicht |
| 9 Gießerei 1845 | Bunker mit Schütte | **Drehkran** (große Stücke leichter) | Prüfbank mit Lehren | **Telegraf** (Aufträge kommen schneller) | Gaslaternen |
| 10 Stahlwerk 1870 | Gasgenerator | **Laufkran** | Werkstoff-Prüfmaschine | Kontor mit Telegraf | Gaslicht, Bogenlampe |

Ab Epoche 9 wirkt B zusätzlich auf große Schmiedestücke (Handarbeit an großen Stücken weniger mühsam),
passend zu Dreh- und Laufkran.

### Darstellung

- Fünf feste Plätze in der Werkstatt: zwei an der Wand (links/rechts oben), zwei auf dem Boden
  (vorn links/rechts), einer neben der Esse. Im Querformat später mehr Platz an den Rändern.
- Noch nicht gekaufte Plätze: dezenter Umriss (Kreide-Kontur), damit man sieht, was noch fehlt.
- Kauf: kurze Einblende-Animation, Klang, im Laden ein eigener Abschnitt **„Einrichtung“**
  (kein zusätzlicher Navigationsknopf).

### Bilder

Freigestellte Einzelbilder wie die Werkstücke (Midjourney, weißer Grund, Seiten- bzw. Frontansicht).
Gleiche Stücke dürfen über benachbarte Epochen wiederverwendet werden (z. B. Gaslicht 7–10):
**ca. 35–40 Bilder** statt 50. Bis die Bilder da sind, zeichne ich einfache Platzhalter, damit Spiel
und Balancing vorher fertig werden können.

## Teil 2: Sichtbares Personal

| Figur | Platz | Bewegung (je 2 Bilder) |
|---|---|---|
| **Lehrling** | zwischen Esse und Amboss | geht mit der Zange hin und her, wenn er ein Stück umlegt |
| **Heizer** | am Blasebalg / Kohlenhaufen | schaufelt bzw. zieht den Blasebalg |
| **Zuschläger** | gegenüber am Amboss | Vorschlaghammer oben / unten, im Takt seiner Schläge (alle 2 s) |
| **Geselle** | hinten an eigener Werkbank | hämmert an seinem eigenen Stück |

Zwei Kleidungsstile: georgianisch (Epoche 1–6) und viktorianisch (7–10) → **16 Posen**.
Risiko: Midjourney hält Figuren über **mehrere getrennte Bilder** nicht zuverlässig gleich.

**Lösung (Stand 20.11.):**
1. **Beide Posen in einem Bild** („same man, two poses side by side“, Format 2:1): Innerhalb eines Bildes bleibt die
   Figur gleich. Der Import schneidet das Bild in zwei Posen → **8 Bilder statt 16**.
2. **Gegenlicht vor der Glut:** Figuren eher dunkel, vom Feuer angestrahlt, ohne viele Kleinteile
   (keine Knöpfe, Muster, Schrift). Das passt zur Stimmung, und kleine Abweichungen fallen nicht auf.
3. **Klein im Spiel** (ca. 250–350 px Höhe auf der Bühne): Gesichter sind kaum erkennbar, Haltung und
   Kleidung zählen.
4. **Viktorianische Fassung** mit der georgianischen als Figuren-Referenz in Midjourney, damit es
   erkennbar „derselbe Lehrling, ein Jahrhundert später“ ist (muss nicht exakt gleich sein: neue Werkstatt, neue Leute).
5. **Rückfall:** Klappt eine zweite Pose nicht, genügt eine Pose; die Bewegung macht dann das Spiel
   (Wippen, Verschieben, Werkzeug als eigenes Bild drehen).
6. **Erst eine Probefigur** (Zuschläger, Epoche 1–6), danach entscheiden.

Umsetzung **später**, nach dem Kernausbau (Schlagserie, Stufensprung, Meisterschaft, Musterbuch, Meisterstück, Kapitelübergang).

## Weitere Ideen gegen Langeweile (zur Auswahl, später)

- **Stammkunden mit kleinen Geschichten:** wiederkehrende Kunden je Epoche mit einer Folge von 3–4
  Aufträgen und einer Belohnung am Ende (z. B. Einrichtungsstück geschenkt).
- **Besondere Ereignisse:** Messe, Pferdemarkt, Flottenausrüstung – zeitlich begrenzt mehr Lohn für
  bestimmte Werkstücke.
- **Meisterstück je Epoche:** ein großer, mehrstufiger Auftrag als Abschluss vor dem Umzug.

## Aufwand und Reihenfolge (Vorschlag)

1. Einrichtung mit Platzhalterbildern: Daten, Laden-Abschnitt, Darstellung, Wirkungen, Speichern,
   Unit-Tests, Balancing (ca. eine Arbeitssitzung).
2. Prompts für die Einrichtungsbilder ins Prompt-Heft (neuer Bereich H), Bilder nach und nach einbauen.
3. Sichtbares Personal (ca. eine halbe Sitzung plus 16 Bilder).

## Zu entscheiden

1. Einrichtung **je Epoche neu** (Vorschlag) oder **dauerhaft**?
2. Die fünf Plätze und Wirkungen so übernehmen oder ändern?
3. Sichtbares Personal: ja / nein / später?
4. Weitere Ideen: welche davon vormerken?
