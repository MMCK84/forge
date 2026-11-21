# Roter Faden durch das Spiel

Stand 20.11.2026. Grundsatz: **Jede Epoche erzählt ein Kapitel und bringt im Kern eine neue Mechanik.**
Neues wird einzeln eingeführt (mit Hinweisfenster beim ersten Auftreten), innerhalb einer Epoche steigt
die Komplexität von einfachen zu anspruchsvollen Aufträgen (Komplexitätsgrad 0 → 1).

## Lehrzeit – Drehbuch der ersten fünf Aufträge (Epoche 1)

Fest vorgegeben statt gewürfelt, ein Stück, Standardauftrag, einfache Qualität, Schlagstärke zählt noch nicht.

| Auftrag | Werkstück | Arbeitsgänge | Was der Spieler lernt | Angebote |
|---|---|---|---|---|
| 1 | Haken | Biegen | Einlegen, auf Kirschrot warten, schmieden, abliefern – ein Zielfenster, niedrige Hitze | **1** |
| 2 | Nagel | Anspitzen | ein zweites, heißeres Zielfenster | 1 |
| 3 | Nagel | Strecken → Anspitzen | zwei Arbeitsgänge nacheinander, zurück in die Esse | 1 |
| 4 | Hufeisen | Strecken → Biegen | großer Hitzeunterschied zwischen den Arbeitsgängen | 1 |
| 5 | Hufeisen | Strecken → Biegen → Lochen | ein vollständiges Werkstück | 1 |

Nach dem ersten Lohn: Kreuzschlaghammer kaufen (Lehrzeit-Hinweis). Nach Auftrag 5: Hinweis auf die
**Einrichtung der Werkstatt**, danach **Schlagstärke** (Hinweisfenster), ab jetzt drei Angebote und
gewürfelte Aufträge mit allen Arbeitsgängen. Meilensteine beginnen ab Auftrag 7 (Pflugschar für den Gutsherrn).

## Zeitleiste der Mechaniken

| Epoche | Kapitel | Neue Mechanik (Kern) | Ausrüstung / Personal | Sonst neu |
|---|---|---|---|---|
| 1 Dorfschmiede 1700 | Gutsherr, Pfarrer, Bauern | Hitze, Zielfenster, Arbeitsgänge (Lehrzeit) | Kreuzschlaghammer | Präzisionsaufträge (2. Hälfte), Schlagstärke leicht/schwer nach der Lehrzeit, Einrichtung |
| 2 Kutschenstraße 1725 | Poststraße, Wagenbauer | **Mengenaufträge** mit Zweiplatz-Esse | Ziegel-Esse, verstählter Hammer, **Lehrling** | mittlere Schlagstärke; **Eilaufträge erst ab der Epochenmitte** |
| 3 Hafen 1740 | Royal Navy | **Feuerschweißen** | Doppelbalg-Esse (3 Plätze), **Zuschläger** | – |
| 4 Sheffield 1755 | Messerschmiede, Tuch | **Stahl** (kühler schmieden) und **Härten** im Löschtrog | Gussstahl-Hammer, **Geselle** (arbeitet auch offline) | mehr Präzisionsaufträge |
| 5 Severn 1780 | Wasserkraft | **Maschine**: Wasser-Schwanzhammer (Wasserstand) | Koks-Esse | – |
| 6 Eisenwerk 1790 | Dampfmaschinen | **Große Schmiedestücke** | Dampf-Schwanzhammer | – |
| 7 London 1810 | Krieg und Erfindergeist | Präzision im Maschinenbau | **Heizer** | – |
| 8 Newcastle 1830 | Eisenbahn | große Mengen, Schweißofen | Schweißofen | – |
| 9 Gießerei 1845 | Dampfhammer | **Dampfhammer mit wählbarer Schlagstärke** | Nasmyth-Hammer | – |
| 10 Stahlwerk 1870 | Bessemer-Stahl | riesige Stahlteile | Siemens-Ofen, großer Dampfhammer | Finale, danach Freies Spiel |

Die Werkstatt-Einrichtung (fünf Plätze) gibt es in jeder Epoche neu; sie ist der Aufbaubogen innerhalb
eines Kapitels.

## Nachgesteuert am 20.11.

1. **Lehrzeit nach Drehbuch** (Tabelle oben) statt gewürfelter Aufträge; erster Auftrag mit nur einem
   Angebot, danach zwei. Lehrzeit und „nur Standardaufträge“ einheitlich 5 Aufträge.
   **Geändert 21.11.:** in der ganzen Lehrzeit nur ein Angebot – zwei Angebote aus demselben Drehbuch-Schritt waren
   derselbe Auftrag (Anmerkung des Auftraggebers). Danach haben alle Angebote verschiedene Werkstücke.
2. **Sichel aus Eisen statt Stahl:** Stahl kam bisher schon in Epoche 1 (Sichel, auch als Meilenstein) –
   jetzt wie im Kapitel vorgesehen erst in Epoche 4 „Stahl & Tuch“.
3. **Epoche 2 entzerrt:** Sie brachte Zweiplatz-Esse, Mengen, Eilaufträge, mittlere Schläge und Lehrling
   gleichzeitig. Eilaufträge kommen jetzt erst ab der Epochenmitte (`rush_from_grade`).
4. **Einrichtung wird angekündigt:** Hinweisfenster am Ende der Lehrzeit.

## Kernausbau (beschlossen 20.11.)

Erfolgserlebnisse auf jeder Zeitebene:

| Zeitebene | Neu | Stand |
|---|---|---|
| Sekunden | **Schlagserie** (alle 5 Treffer +10 % Schlagkraft, max. +30 %), **Stufensprung** je Arbeitsgang | umgesetzt |
| Minuten | **Meisterschaft je Werkstück** (Bronze/Silber/Gold nach 2/5/10 Aufträgen, je +5 % Lohn), **Musterbuch** | umgesetzt |
| Stunden | **Meisterstück je Epoche** (Vorarbeiten + Hauptstück, Zunftprüfung ≥ 2 Sterne), **Kapitelübergang** („Was Euch erwartet“) | umgesetzt |

Das erste Siegel gibt es meist schon in der Lehrzeit (Auftrag 3: zweiter Nagel) – ein frühes Erfolgserlebnis.

Die Schlagserie gilt ab dem ersten Auftrag (keine neue Bedienung, sie erklärt sich durch die Anzeige).
Danach wird der Kern eingefroren.

### Meisterstücke (scripts/masterpieces.gd)

| Ep. | Vorarbeiten | Hauptstück |
|---|---|---|
| 1 | Türangel | Torriegel für die Kirchentür (präzise) |
| 2 | 3 Kutschbeschläge, Hemmschuh | 4 Radreifen für die Postkutsche |
| 3 | 3 Kettenglieder, Festmacherring (geschweißt) | Ankerschaft (geschweißt) |
| 4 | 2 Federn (gehärtet), 2 Ladeketten (geschweißt) | 6 Lafettenbeschläge für die Victory (präzise) |
| 5 | 2 Ventilteile, Pumpenschwengel | Kolbenstange (präzise) |
| 6 | 4 Kesselnieten, Blattfeder (gehärtet) | Antriebswelle (großes Stück) |
| 7 | 4 Blockrollen-Bolzen (präzise) | Brückenglied der Menai-Brücke |
| 8 | 2 Kupplungshaken, 2 Pufferfedern | Kurbelachse (präzise) |
| 9 | 4 Brückennieten, Admiralitätsanker | Schraubenwelle der SS Great Britain |
| 10 | 2 Stahlachsen, 2 Geschützringe | Stahlwelle des Atlantik-Dampfers |

Danach ist der Kern eingefroren (keine neuen Mechaniken mehr).

## Weitere Vorschläge (zur Entscheidung)

- **Stammkunden mit kleinen Geschichten:** zwei, drei wiederkehrende Kunden je Epoche, deren Aufträge
  aufeinander aufbauen (die Meilensteine erzählen das schon teilweise).
- **Sichtbares Personal** (Konzept Aufbau, Teil 2): Lehrling, Zuschläger, Geselle und Heizer als Figuren.
