# Erweiterung: Epochen 7–10 und Schlagstärke

Entwurf zum Absegnen. Ändern, streichen, ergänzen – alles ist noch offen. Die Grafik-Prompts stehen
im zweiten Teil; Inhalte, die du änderst, passe ich in den Prompts an.

## Überblick

| Epoche | Zeitraum | Titel | Standort |
|---|---|---|---|
| 7 | 1800–1820 | Krieg & Erfindergeist | Werkstatt in Lambeth, London – Nachbar von Henry Maudslay |
| 8 | 1820–1839 | Eisenbahnfieber | Schmiede in Newcastle upon Tyne – bei Robert Stephenson & Co. |
| 9 | 1839–1860 | Der Dampfhammer | Schmiede der Bridgewater Foundry in Patricroft – bei James Nasmyth |
| 10 | 1860–1880 | Das Stahlzeitalter | Stahlwerk in Sheffield – Bessemer- und Siemens-Stahl |

Spieldauer: bisher 7,7 Stunden für Epoche 1–6; mit den neuen Epochen ca. **13–14 Stunden**
(je neue Epoche etwa 1,3–1,6 Stunden, steigend). Das Spiel heißt dann „… im Großbritannien des 18. und 19. Jahrhunderts“.

## Die neue Mechanik: Schlagstärke (für alle Epochen)

**Drei Stufen: Leicht · Mittel · Schwer.** Gewählt über drei Knöpfe direkt über dem HAMMERN-Knopf
(am PC zusätzlich die Tasten 1 / 2 / 3). Jeder Arbeitsgang verlangt eine Stärke – angezeigt an der
Glühskala und in der Fortschrittsleiste:

| Arbeitsgang | Stärke | Warum |
|---|---|---|
| Strecken, Stauchen, Lochen | **schwer** | viel Material bewegen |
| Breiten, Spitzen, Abschroten, Feuerschweißen | **mittel** | formen, aber kontrolliert |
| Biegen, Verdrehen, Schlichten | **leicht** | Form treffen, Oberfläche glätten |

**Wirkung eines Schlags**

| Gewählt vs. verlangt | Form-Punkte | Qualität |
|---|---|---|
| richtig | 100 % | zählt als Treffer im Fenster (wenn auch die Temperatur stimmt) |
| eine Stufe daneben | 55 % | zählt nicht als Treffer |
| leicht statt schwer | 25 % | zählt nicht, kein Schaden |
| schwer statt leicht | 30 % | zählt nicht **und Gefügeschaden** (Dellen, Risse) |

**Rückmeldung:** Der Hammer holt je nach Stärke kürzer oder weiter aus, der Klang wird heller oder
dumpfer, Funken mehr oder weniger. Falsche Stärke zeigt „Zu fest!“ / „Zu sanft!“.

**Einführung:** Die fünf Tutorial-Aufträge laufen noch ohne Stärke (alles „Mittel“), danach erklärt
ein Hinweis die drei Stufen. Bis zum Ende von Epoche 1 verlangen die Aufträge nur Schwer und Leicht
(leichter zu lernen), ab Epoche 2 alle drei Stufen.

**Maschinen und Personal**
- **Zuschläger** (Vorschlaghammer) und **Schwanzhammer** (Wasser/Dampf, Epoche 5–6) schlagen nur
  **schwer** – sie arbeiten daher nur in den schweren Arbeitsgängen mit und pausieren sonst. Das ist
  historisch richtig: Feinarbeit machte der Schmied von Hand. Ausnahme **Großschmiedestücke**:
  Dort arbeitet der Schwanzhammer in allen Arbeitsgängen passend mit (der Hammerschmied
  dosierte den Schlag über den Antrieb) – sonst wären sie von Hand kaum zu schaffen.
- **Nasmyth-Dampfhammer** (ab Epoche 9) schlägt mit **der von Euch gewählten Stärke** – sein großer
  Vorteil: Er arbeitet in jedem Arbeitsgang mit. Ist die Wahl viel zu hart (schwer statt
  leicht), hält er an, statt das Werkstück zu zerschlagen – bis Ihr umstellt.
- Das Balancing (Spielzeit je Epoche) stimme ich danach neu ab.


## Epoche 7: Krieg & Erfindergeist (1800–1820)

**Standort:** Werkstatt in Lambeth, London – Nachbar von Henry Maudslay

Napoleon sperrt den Kontinent, die Royal Navy braucht Eisen in nie gekannten Mengen. In Lambeth baut Henry Maudslay die ersten Präzisions-Werkzeugmaschinen, Thomas Telford überspannt Täler und Meerengen, und ab 1812 leuchten Londons Straßen mit Gas.

**Neu:** **Schlagstärke** wird anspruchsvoller (Präzisionsaufträge für Maudslay verlangen exakte Stärke), **Heizer** als neues Personal (Esse heizt 25 % schneller), Großaufträge der Navy mit hoher Stückzahl.

**Kunden**

| ID | Kunde | Hintergrund |
|---|---|---|
| navy_portsmouth | die Blockfabrik in Portsmouth | Royal Navy, Marc Brunels und Maudslays Blockfabrik (1803) |
| maudslay | Henry Maudslay in Lambeth | Werkzeugmaschinenbauer, Erfinder des Support-Drehbanks |
| telford | den Ingenieur Thomas Telford | Kanäle, Straßen, Menai-Hängebrücke (1819–26) |
| gas_light_company | die Gas Light and Coke Company | erste Gasgesellschaft der Welt (1812) |
| horse_guards | die Royal Horse Guards | Kavallerie im Krieg gegen Napoleon |
| trevithick | Richard Trevithick | Hochdruck-Dampfmaschinen, erste Lokomotive 1804 |

**Werkstücke**

| ID | Name | Art | Arbeitsgänge |
|---|---|---|---|
| bayonet | Bajonett | harden · Stahl | Strecken – Spitzen – Schlichten |
| block_pin | Blockrollen-Bolzen | normal | Strecken – Abschroten – Schlichten |
| press_screw | Pressenspindel | normal | Strecken – Verdrehen – Schlichten |
| gas_lamp_bracket | Gaslaternen-Ausleger | normal | Strecken – Biegen – Verdrehen |
| navvy_spade | Spaten der Kanalbauer | normal | Strecken – Breiten – Biegen |
| boiler_stay | Kessel-Stehbolzen | normal | Strecken – Stauchen – Abschroten |
| anchor_fluke | Ankerarm | weld · groß | Strecken – Feuerschweißen – Breiten |
| chain_eyebar | Kettenglied der Menai-Brücke | normal | Strecken – Stauchen – Lochen – Schlichten |

**Meilensteine (Story-Aufträge)**

1. Blockrollen-Bolzen für Portsmouth (Navy)
2. Bajonette für die Horse Guards
3. Pressenspindel für eine Stanhope-Presse
4. Gaslaternen für die Westminster Bridge (1813)
5. Präzisionsbolzen für Maudslay
6. Spaten für Telfords Caledonian Canal
7. Stehbolzen für Trevithicks Hochdruckkessel
8. Ankerarme für ein Linienschiff
9. Kettenglieder für die Menai-Brücke (Finale)

## Epoche 8: Eisenbahnfieber (1820–1839)

**Standort:** Schmiede in Newcastle upon Tyne – bei Robert Stephenson & Co.

1825 fährt der erste Zug auf der Stockton & Darlington Railway, 1829 gewinnt Stephensons „Rocket“ das Rennen von Rainhill, 1830 verbindet die erste Fernbahn Liverpool und Manchester. Lokomotiven und Wagen brauchen Achsen, Radreifen und Kupplungen – in Serie.

**Neu:** **Schweißofen** (Esse Stufe 5, höher und schneller), **Serienaufträge** mit großen Stückzahlen, Kurbelachsen als besonders schwere Stücke.

**Kunden**

| ID | Kunde | Hintergrund |
|---|---|---|
| stockton_darlington | die Stockton & Darlington Railway | erste öffentliche Dampfeisenbahn (1825) |
| stephenson_works | Robert Stephenson & Co. | Lokomotivfabrik in Newcastle (1823) |
| liverpool_manchester | die Liverpool & Manchester Railway | erste Fernbahn (1830) |
| brunel | Isambard Kingdom Brunel | Great Western Railway (1835), Clifton-Brücke |
| hetton_colliery | die Zeche Hetton | Kohlenbahn der Zeche (1822) |

**Werkstücke**

| ID | Name | Art | Arbeitsgänge |
|---|---|---|---|
| rail_spike | Schienennagel | normal | Strecken – Spitzen – Stauchen |
| coupling_hook | Kupplungshaken | normal | Strecken – Biegen – Lochen |
| coupling_chain | Kupplungskette | weld | Strecken – Biegen – Feuerschweißen |
| loco_tyre | Lokomotiv-Radreifen | weld | Strecken – Biegen – Feuerschweißen – Schlichten |
| connecting_rod | Treibstange | groß · Präzision | Strecken – Stauchen – Lochen – Schlichten |
| crank_axle | Kurbelachse | groß | Strecken – Biegen – Schlichten |
| buffer_spring | Pufferfeder | harden · Stahl | Strecken – Biegen – Schlichten |
| safety_valve_lever | Sicherheitsventil-Hebel | normal | Strecken – Lochen – Schlichten |

**Meilensteine (Story-Aufträge)**

1. Schienennägel für die Stockton & Darlington
2. Kupplungsketten für Kohlenwagen der Zeche Hetton
3. Kupplungshaken für Personenwagen
4. Radreifen für die ‚Locomotion‘
5. Sicherheitsventil-Hebel
6. Pufferfedern für die Liverpool & Manchester
7. Treibstangen für die ‚Rocket‘ (1829)
8. Kurbelachse für eine Lokomotive der Great Western
9. Treibachse für Stephensons Schnellzuglok (Finale)

## Epoche 9: Der Dampfhammer (1839–1860)

**Standort:** Schmiede der Bridgewater Foundry in Patricroft – bei James Nasmyth

1839 skizziert James Nasmyth einen Hammer, den Dampf hebt und fallen lässt – so fein steuerbar, dass er ein Ei in einem Weinglas anschlägt, und so stark, dass er Schiffswellen schmiedet. Brunels „Great Britain“ (1843) fährt mit Schraube, die Britannia-Brücke (1850) braucht Millionen Nieten, der Kristallpalast (1851) zeigt der Welt Eisen und Glas.

**Neu:** **Nasmyth-Dampfhammer** (Maschine Stufe 3): schlägt mit der **gewählten Schlagstärke** und arbeitet daher in allen Arbeitsgängen mit. Riesige Werkstücke (Schiffswellen, Admiralitätsanker).

**Kunden**

| ID | Kunde | Hintergrund |
|---|---|---|
| nasmyth | James Nasmyth in Patricroft | Erfinder des Dampfhammers (Patent 1842) |
| great_western_ss | die Great Western Steamship Company | SS Great Britain (1843) |
| admiralty_steam | die Admiralität (Dampfmarine) | HMS Rattler (1843), Schraubenschiffe |
| britannia_bridge | Robert Stephenson (Britannia-Brücke) | Röhrenbrücke über die Menai-Straße (1850) |
| crystal_palace | Fox, Henderson & Co. | Kristallpalast der Weltausstellung (1851) |

**Werkstücke**

| ID | Name | Art | Arbeitsgänge |
|---|---|---|---|
| bridge_rivet | Brückenniete | normal | Stauchen – Schlichten |
| palace_bracket | Säulenkopf-Beschlag | normal | Strecken – Biegen – Lochen |
| paddle_arm | Schaufelrad-Arm | normal | Strecken – Lochen – Schlichten |
| hammer_die | Gesenk für den Dampfhammer | harden · Stahl | Stauchen – Breiten – Schlichten |
| marine_piston_rod | Kolbenstange für Schiffsmaschinen | groß · Präzision | Strecken – Stauchen – Schlichten |
| marine_crank | Schiffskurbel | groß | Strecken – Lochen – Schlichten |
| admiralty_anchor | Admiralitätsanker | weld · groß | Strecken – Feuerschweißen – Biegen – Breiten |
| propeller_shaft | Schraubenwelle | groß | Strecken – Stauchen – Schlichten |

**Meilensteine (Story-Aufträge)**

1. Niete für die Britannia-Brücke
2. Säulenbeschläge für den Kristallpalast
3. Gesenke für Nasmyths eigenen Hammer
4. Schaufelradarme für einen Raddampfer
5. Kolbenstange für die HMS Rattler (1843)
6. Schiffskurbeln für die Admiralität
7. Admiralitätsanker
8. Wettkampf Rad gegen Schraube (1845)
9. Schraubenwelle für die SS Great Britain (Finale)

## Epoche 10: Das Stahlzeitalter (1860–1880)

**Standort:** Stahlwerk in Sheffield – Bessemer- und Siemens-Stahl

Bessemers Konverter (1856) und Siemens' Gasofen (1865) machen Stahl zum Massengut. Die HMS Warrior (1860) trägt eiserne Panzer, Armstrong baut Geschütze aus geschrumpften Ringen, die White Star Line schickt Dampfer über den Atlantik, und auf den Straßen rollen die ersten Hochräder.

**Neu:** **Siemens-Gasofen** (Esse Stufe 6, bis 1550 °C), **Großer Dampfhammer** (Maschine Stufe 4), viele Aufträge aus **Stahl** (engere Fenster, Härten), Panzerplatten als schwerste Stücke des Spiels.

**Kunden**

| ID | Kunde | Hintergrund |
|---|---|---|
| john_brown | John Brown & Co. in Sheffield | Panzerplatten (ab 1860er) |
| armstrong_elswick | Armstrong in Elswick | Geschütze aus geschrumpften Ringen |
| midland_railway | die Midland Railway | Stahlschienen, St Pancras (1868) |
| white_star | die White Star Line | RMS Oceanic (1870) |
| hornsby | den Landmaschinenbauer Hornsby | Mähmaschinen |
| coventry_machinists | die Coventry Machinists Company | Velocipede und Hochräder (1869) |

**Werkstücke**

| ID | Name | Art | Arbeitsgänge |
|---|---|---|---|
| reaper_knife | Mähmesser | harden · Stahl | Strecken – Breiten – Schlichten |
| velocipede_fork | Hochrad-Gabel | normal · Stahl | Strecken – Biegen – Schlichten |
| tunnel_drill | Tunnelbohrer | harden · Stahl | Strecken – Stauchen – Spitzen |
| steel_axle | Stahlachse | normal · Stahl | Strecken – Stauchen – Schlichten |
| steel_tyre | Stahl-Radreifen | harden · Stahl | Lochen – Strecken – Schlichten |
| gun_hoop | Geschützring | weld · groß | Strecken – Biegen – Feuerschweißen – Schlichten |
| steel_shaft | Stahlwelle für Ozeandampfer | groß · Stahl | Strecken – Stauchen – Schlichten |
| armour_plate | Panzerplatte | groß | Stauchen – Breiten – Schlichten |

**Meilensteine (Story-Aufträge)**

1. Mähmesser für Hornsby
2. Gabeln für Coventry-Hochräder (1869)
3. Tunnelbohrer für den Severn-Tunnel
4. Stahlachsen für die Midland Railway
5. Stahl-Radreifen nach Krupp-Art
6. Geschützringe für Armstrong
7. Panzerplatten für ein Panzerschiff
8. Stahlwelle für die RMS Oceanic
9. Euer Lebenswerk: die Hauptwelle für einen Atlantik-Schnelldampfer (Finale)

## Ausrüstung, Personal, Ton

| Epoche | Neu im Laden / Personal |
|---|---|
| 7 | **Heizer** (Personal): Esse heizt 25 % schneller; Lohn 5 % |
| 8 | **Schweißofen** (Esse Stufe 5): 175 °C/s, bis 1500 °C, 3 Plätze |
| 9 | **Nasmyth-Dampfhammer** (Maschine Stufe 3): Schlagkraft 220, 2 Schläge/s, mit Schlagstärke, Betriebskosten |
| 10 | **Siemens-Gasofen** (Esse Stufe 6): 210 °C/s, bis 1550 °C · **Großer Dampfhammer** (Stufe 4): Schlagkraft 450 |

Ton: Dampfhammer-Schlag (zischender Dampf + dumpfer Aufschlag) und je eine neue Musik für die
Epochen 7–10 erzeuge ich wie bisher selbst.

---

# Teil 2: Grafik-Prompts

Gleiche Regeln wie bisher: weißer Hintergrund, kein Schatten, kein Text, kein Wasserzeichen.
Dateinamen = die fett gedruckten IDs.

## Hintergründe (9:16 hochkant)

**background_7** – Krieg & Erfindergeist (1800–1820)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of a London engineering smithy in Lambeth around 1810, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: smoke-blackened yellow London stock brick with a heavy timber lintel. The floor fills the lower 60 % and comes towards the viewer: worn York stone flags with iron filings. A window high on the back wall in the upper left corner shows the river Thames with sailing barges and the dome of St Paul's in the haze. On the far right edge a wooden rack with iron templates and gauges; on the far left edge a stack of iron bars. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no machine, no steam hammer, no tools in the centre, no people, no animals, no text, no watermark.
```

**background_8** – Eisenbahnfieber (1820–1839)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of a locomotive smithy in Newcastle upon Tyne around 1830, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: dark red brick with tall arched openings bricked up, iron tie rods with round anchor plates. The floor fills the lower 60 % and comes towards the viewer: packed cinders and iron plates. A window high on the back wall in the upper left corner shows an early steam locomotive with a tall chimney pulling coal wagons on a track. On the far right edge locomotive wheels and tyres lean against the wall; on the far left edge a stack of coupling chains. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no machine, no steam hammer, no tools in the centre, no people, no animals, no text, no watermark.
```

**background_9** – Der Dampfhammer (1839–1860)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of the forge shop of a great engineering foundry around 1845, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: tall soot-stained brick wall with cast-iron columns and a long row of high round-arched windows. The floor fills the lower 60 % and comes towards the viewer: heavy cast-iron floor plates and scale. A window high on the back wall in the upper left corner shows a canal with a narrowboat and the chimneys of a foundry. The right third of the room is left open and empty, because a large steam hammer will be placed there later. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no machine, no steam hammer, no tools in the centre, no people, no animals, no text, no watermark.
```

**background_10** – Das Stahlzeitalter (1860–1880)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of a Sheffield steelworks forge around 1870, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: very tall dark brick wall with iron roof trusses and a travelling crane rail along the top. The floor fills the lower 60 % and comes towards the viewer: cast-iron floor plates with steel scale. A window high on the back wall in the upper left corner shows Bessemer converters blowing a shower of sparks into the night. The right third of the room is left open and empty, because a very large steam hammer will be placed there later. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no machine, no steam hammer, no tools in the centre, no people, no animals, no text, no watermark.
```

## Essen

Wie die bisherigen Essen: schräg von vorn, komplett im Bild, kein Rauch, **breites offenes Glutbett
für 3 Werkstücke nebeneinander** (mindestens die halbe Breite des Ofens).

**forge_welding_furnace** – Schweißofen (Stufe 5, Epoche 8)
```
2D game asset, a large 1830s coal-fired smith's welding furnace: a long low hearth built of firebrick and cast-iron plates with iron tie bars, a wide open working front showing a long bed of white-hot glowing coal that takes up at least half of the furnace's width, a low brick arch above the bed and a short square brick chimney at the back right shown completely inside the image, side view from slightly above like a game sprite, the whole object fully inside the frame with a margin, no smoke, no sparks, no people, no tools in front of the bed, no text, no watermark, isolated on pure flat white background
```

**forge_siemens** – Siemens-Gasofen (Stufe 6, Epoche 10)
```
2D game asset, a large 1870s Siemens regenerative gas furnace for a steelworks forge: a massive rectangular furnace of firebrick bound with heavy riveted iron plates and vertical buckstays, a wide open working door at the front showing a long hearth of blinding yellow-white heat that takes up at least half of the furnace's width, gas pipes with valves entering at the sides, a squat iron chimney stub on top shown completely inside the image, side view from slightly above like a game sprite, the whole object fully inside the frame with a margin, no smoke, no sparks, no people, no text, no watermark, isolated on pure flat white background
```

## Der Dampfhammer in Einzelteilen

Damit der Bär (der fallende Hammerkopf) sich senkrecht bewegen kann, brauche ich die Teile einzeln,
**genau von vorn bzw. von der Seite, ohne Perspektive**. Der Amboss des Spiels wird bei Dampfhämmern
durch die Schabotte ersetzt.

**steam_hammer_frame** – Gestell (Epoche 9)
```
2D game asset, the frame of an 1840s Nasmyth steam hammer seen exactly from the front (orthographic, no perspective): two tall cast-iron standards shaped like an inverted V on each side, joined at the top by a heavy cross beam that carries a vertical steam cylinder with flanges and a valve chest, a control lever with a handle on the right standard, a tall empty open gap in the middle between the standards where the hammer moves, no hammer head, no piston rod, no anvil, hand-painted 2D game art with dark ink outlines, dark iron with rivets and bolts, no shadow, no text, no watermark, isolated on pure flat white background, portrait 3:4
```

**steam_hammer_ram** – Bär mit Kolbenstange
```
2D game asset, the moving ram (tup) of an 1840s steam hammer seen exactly from the front (orthographic, no perspective): a long vertical polished piston rod at the top fixed into a heavy rectangular cast-iron hammer block with guide grooves on both sides and a flat steel die at the very bottom, upright and perfectly vertical, hand-painted 2D game art with dark ink outlines, no frame, no cylinder, no anvil, no shadow, no text, no watermark, isolated on pure flat white background, portrait 1:2
```

**steam_hammer_anvil** – Schabotte (Ambossblock)
```
2D game asset, the anvil block (schabotte) of an 1840s steam hammer seen exactly from the front (orthographic, no perspective): a massive squat cast-iron block, wider at the base, with a flat steel die on top held by a dovetail and wedges, set on heavy oak timbers, hand-painted 2D game art with dark ink outlines, dark iron, no hammer, no frame, no shadow, no text, no watermark, isolated on pure flat white background, landscape 3:2
```

**steam_hammer_large_frame** – Gestell des großen Dampfhammers (Epoche 10, optional)
```
2D game asset, the frame of a huge 1870s double-standard steam hammer seen exactly from the front (orthographic, no perspective): two massive riveted wrought-iron standards forming an arch, a large steam cylinder on top with pipes and valve gear, a platform with railing for the hammer driver, a tall empty open gap in the middle where the hammer moves, no hammer head, no piston rod, no anvil, hand-painted 2D game art with dark ink outlines, dark iron with rivets, no shadow, no text, no watermark, isolated on pure flat white background, portrait 3:4
```

## Werkstücke (je Epoche 8)

Wie in `PROMPTS_Werkstuecke.md`: kalt, nur Metall, von oben, weißer Hintergrund.

### Epoche 7 – Krieg & Erfindergeist

**bayonet** – Bajonett
```
2D game asset, a single forged socket bayonet without musket: a long triangular-section steel blade tapering to a sharp point on the right, joined by a short curved neck to a round hollow socket with an L-shaped slot on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**block_pin** – Blockrollen-Bolzen
```
2D game asset, a single forged pulley-block pin: short thick perfectly straight round iron pin with a slightly domed head on the left and a small hole for a split pin near the right end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**press_screw** – Pressenspindel
```
2D game asset, a single forged screw spindle for an iron printing press: a thick round iron rod with a coarse square thread twisted along its middle part, a square end for the lever on the left and a round foot on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**gas_lamp_bracket** – Gaslaternen-Ausleger
```
2D game asset, a single hand-forged wall bracket for a gas street lamp: a horizontal arm of square bar with a decorative twisted section and a large scroll brace underneath, a flat wall plate with four bolt holes on the left and a downward ring at the right tip for the lamp, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**navvy_spade** – Spaten der Kanalbauer
```
2D game asset, a single forged navvy's spade blade without wooden handle: a broad flat slightly dished iron blade with a squared cutting edge at the bottom, rolled tread edges at the top and a long tapering open socket strap, upright with the socket pointing up, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**boiler_stay** – Kessel-Stehbolzen
```
2D game asset, a single forged boiler stay bolt: a long straight round iron rod with a thick upset collar near each end and slightly peened ends, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**anchor_fluke** – Ankerarm
```
2D game asset, a single forged anchor arm for a ship's anchor: a thick curved iron arm ending in a broad flat triangular fluke (palm) on the right and a heavy square stump on the left where it is welded to the shank, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**chain_eyebar** – Kettenglied der Menai-Brücke
```
2D game asset, a single forged suspension bridge eyebar: a long flat wrought iron bar with a thickened round eye with a large hole at each end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

### Epoche 8 – Eisenbahnfieber

**rail_spike** – Schienennagel
```
2D game asset, a single forged railway track spike: a long square-section iron shank with a chisel point at the bottom and a hooked offset head at the top, upright, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**coupling_hook** – Kupplungshaken
```
2D game asset, a single forged railway wagon coupling hook: a heavy curved iron hook with a thick shank and a punched eye at the right end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**coupling_chain** – Kupplungskette
```
2D game asset, a short forged railway coupling chain: three heavy oval links of round bar, laid out straight and horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**loco_tyre** – Lokomotiv-Radreifen
```
2D game asset, a single forged locomotive wheel tyre: a thick iron hoop seen from directly above forming a perfect circle, with a raised flange along the inner edge and a visible forge-welded joint, empty in the middle, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**connecting_rod** – Treibstange
```
2D game asset, a single forged locomotive connecting rod: a long tapered flat iron rod with a large rectangular strap end with a bearing hole on the left and a smaller round eye on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**crank_axle** – Kurbelachse
```
2D game asset, a single forged locomotive crank axle: a thick straight round iron axle with two offset crank throws in the middle, each made of two rectangular webs and a crank pin, seen from the side, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**buffer_spring** – Pufferfeder
```
2D game asset, a single forged railway buffer spring: a stack of four curved steel leaves held by a central iron band, seen from the side, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**safety_valve_lever** – Sicherheitsventil-Hebel
```
2D game asset, a single forged safety valve lever for a locomotive boiler: a long flat iron lever with a fork and pin hole at the left end, two holes along its length and a rounded end on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

### Epoche 9 – Der Dampfhammer

**bridge_rivet** – Brückenniete
```
2D game asset, a single large forged bridge rivet: short thick round shank with a domed head, seen from the side, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**palace_bracket** – Säulenkopf-Beschlag
```
2D game asset, a single forged iron connecting bracket for a glass-and-iron exhibition hall: a flat L-shaped iron plate with a decorative curved gusset and six bolt holes, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**paddle_arm** – Schaufelrad-Arm
```
2D game asset, a single forged paddle-wheel arm for a paddle steamer: a long flat iron bar with a bolted palm plate at the right end and two bolt holes at the left end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**hammer_die** – Gesenk für den Dampfhammer
```
2D game asset, a single forged steam-hammer die: a heavy rectangular steel block with a dovetail tongue on top and a smooth flat working face at the bottom, seen from the side, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**marine_piston_rod** – Kolbenstange für Schiffsmaschinen
```
2D game asset, a single forged marine engine piston rod: a very long perfectly straight round iron rod with a tapered cone end on the left and a forged crosshead block with a hole on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**marine_crank** – Schiffskurbel
```
2D game asset, a single forged marine engine crank: a heavy flat iron crank arm with a large round boss with a shaft hole at the left end and a smaller boss with a pin hole at the right end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**admiralty_anchor** – Admiralitätsanker
```
2D game asset, a single forged Admiralty pattern anchor without stock: a long straight shank with a ring at the top and two curved arms with broad triangular flukes at the bottom, upright, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**propeller_shaft** – Schraubenwelle
```
2D game asset, a single forged ship's propeller shaft: a very long thick round iron shaft with a flanged coupling disc at the left end and a tapered end with a keyway on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

### Epoche 10 – Das Stahlzeitalter

**reaper_knife** – Mähmesser
```
2D game asset, a single forged reaper section knife: a long flat steel bar with a row of riveted triangular cutting sections along its upper edge, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**velocipede_fork** – Hochrad-Gabel
```
2D game asset, a single forged front fork of a penny-farthing bicycle: two long slightly curved steel blades joined at the top by a crown with a vertical steering stem, upright, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**tunnel_drill** – Tunnelbohrer
```
2D game asset, a single forged tunnelling drill steel: a long octagonal steel bar with a cross-shaped four-point bit on the right and a collar near the striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**steel_axle** – Stahlachse
```
2D game asset, a single forged railway carriage steel axle: a thick straight round steel bar with raised wheel seats and short round journals at both ends, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**steel_tyre** – Stahl-Radreifen
```
2D game asset, a single weldless forged steel wheel tyre seen from directly above: a thick perfect steel ring with a flange along the inner edge and no joint, empty in the middle, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**gun_hoop** – Geschützring
```
2D game asset, a single forged gun hoop for a built-up cannon: a short thick wide iron ring seen at a slight angle from above so its thickness is visible, empty in the middle, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**steel_shaft** – Stahlwelle für Ozeandampfer
```
2D game asset, a single forged steel intermediate shaft for an ocean liner: a very long thick round steel shaft with a large flanged coupling disc at each end, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**armour_plate** – Panzerplatte
```
2D game asset, a single forged armour plate for an ironclad warship: a very thick rectangular wrought iron slab, landscape format, with slightly bevelled edges and a row of bolt holes along the long edges, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

## Kundenporträts (optional)

Die bisherigen 32 Porträts sind noch meine gerenderten. Für einen einheitlichen Stil (und für die
22 neuen Kunden) wäre diese Vorlage gedacht – Beschreibung in Klammern je Kunde austauschen:
```
2D game asset, a head-and-shoulders portrait of [an 1840s English engineer in a dark frock coat, high collar and cravat, side whiskers], in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, no text, no name plate, no watermark, isolated on pure flat white background outside the frame, portrait 4:5
```

