# Prompt-Heft: alle Bilder des Spiels

Vollständige Liste aller Grafiken mit Prompt und Status. Erzeugt mit `python tools/content/gen_prompt_book.py` – nach jeder Lieferung und jeder neuen Erkenntnis neu erzeugt, damit Status und Prompts aktuell sind.

**Status je Bild:**

- ⬜ noch nicht vorhanden – Prompt verwenden und liefern
- 🟡 von Gemini vorhanden – durch Midjourney ersetzen – ist im Spiel, soll später ersetzt werden
- 🟠 von Midjourney vorhanden – sollte noch verändert werden – der Hinweis darunter sagt, was
- ✅ gut (Midjourney) – fertig

**Bildquelle:** Bis zum 20.11.2026 Gemini, seitdem **Midjourney**. Prompts in Midjourney-Schreibweise: Verbote hinter `--no`, Seitenverhältnis hinter `--ar`. Herkunft und Bewertung je Bild: `provenance.json`.

## Übersicht

| Status | Anzahl |
|---|---|
| ✅ gut (Midjourney) | 0 |
| 🟠 von Midjourney vorhanden – sollte noch verändert werden | 2 |
| 🟡 von Gemini vorhanden – durch Midjourney ersetzen | 42 |
| ⬜ noch nicht vorhanden | 81 |
| ⬜ noch nicht vorhanden (optional) | 62 |

| Bereich | ✅ gut | 🟠 ändern | 🟡 Gemini | ⬜ fehlt | ⬜ optional |
|---|---|---|---|---|---|
| A · Werkstatt-Hintergründe | 0 | 2 | 5 | 3 | 0 |
| B · Essen | 0 | 0 | 4 | 2 | 0 |
| C · Amboss und Hämmer | 0 | 0 | 5 | 0 | 0 |
| D · Maschinen | 0 | 0 | 7 | 3 | 4 |
| E · Werkstücke | 0 | 0 | 9 | 72 | 0 |
| F · Kundenporträts | 0 | 0 | 0 | 0 | 54 |
| G · Oberfläche, Symbole, Store | 0 | 0 | 12 | 1 | 4 |

## Erkenntnisse aus den bisherigen Bildern

Jede Erkenntnis ist in **alle** betroffenen Prompts eingebaut (gemeinsame Bausteine im Generator).

| Datum | gilt für | Beobachtung | Umsetzung |
|---|---|---|---|
| 19.11. | alle | Jahreszahlen und Schrift im Bild („1772“ auf dem Hammer, „1775“ auf dem Victoria-Siegel) | `--no text, letters, numbers, date, signature, watermark` bei jedem Prompt |
| 19.11. | alle Bilder auf weißem Grund | weißer Sticker-Rand mit Kontur um den Nagel | `--no sticker border, outline frame, drop shadow, ground shadow` bei allen freigestellten Bildern |
| 19.11. | Werkstücke | Holzstiele würden im Spiel mitglühen | „metal only“, `--no wood, leather, rope` |
| 19.11. | Werkstücke | eingemalte Glut wäre auch kalt sichtbar | „cold and unheated“, `--no glow, sparks, fire` |
| 20.11. | Hämmer | Schrägansicht trifft nicht flach auf das Werkstück | reine Seitenansicht, Kopf links senkrecht, Stiel waagerecht |
| 20.11. | Essen | Schrägansicht passt nicht in die frontalen Räume | Frontalansicht leicht von oben, Glutbett als waagerechter Streifen |
| 20.11. | Essen | Kohlehaufen und Zangen lagen vor dem Glutbett | „nothing in front of the hearth“ |
| 20.11. | Hintergründe | Midjourney setzte die Wand-Boden-Kante bei 54–71 % statt 40 % | Bildaufbau ganz vorn im Prompt, Tipp: vorhandenen Hintergrund als Bild-Prompt mit `--iw 0.5` |
| 20.11. | Hintergründe | zu dunkel, obere Hälfte fast schwarz | „moderately bright evening light, the upper wall clearly visible“ |
| 20.11. | Hintergründe | Fenster am oberen Rand, zur Hälfte von der Statusleiste verdeckt | „the top 10 percent shows only dark ceiling beams and the window sits just below them“ |
| 20.11. | Hintergründe | schwarzer Balken am unteren Rand | `--no black bars, letterbox, border` |
| 20.11. | alle | Midjourney liefert immer vier Varianten | eine auswählen (Website: anklicken; Discord: U1–U4) und nur diese schicken |
| 20.11. | alle | der Seitenverhältnis-Regler überstimmt `--ar` im Prompt | bei jedem Bild steht die Regler-Einstellung (z. B. „Portrait 9:16“) – vor dem Erzeugen einstellen |
| 20.11. | Hintergründe | trotz Textvorgabe Wand-Boden-Kante bei 62 % (Epoche 8, 3. Versuch); Fenster und Helligkeit passten | Bildaufbau-Vorlage `vorlagen/bildaufbau_hintergrund.png` als **Bild-Prompt** vor den Text setzen |
| 20.11. | Hintergründe | Midjourney setzt die Kante im Hochformat hartnäckig auf ~60 % (Epoche 8 und 9) | **Format 3:4** statt 9:16: dort landet die Kante bei 55–62 % genau richtig im Spiel; das Spiel verlängert den Boden nach unten |
| 20.11. | alle | Zuordnung der Bilder in Midjourney schwierig | jeder Prompt beginnt mit der ID (= Dateiname), z. B. `background_9 —` |
| 20.11. | Essen | Test-Esse (Stufe 1): Frontalansicht gut, aber geschlossener Backofen mit Kuppel, Glut tief in der Öffnung, nur ~35 % breit | „open smith's hearth, not an oven“, Glut liegt offen auf einem hüfthohen Herdtisch, Abzugshaube mit freiem Spalt darüber; `--no dome, oven, bread oven, arch over the fire, enclosed firebox` |
| 20.11. | Essen | Blasebalg sah aus wie eine Kanone bzw. ein Fernrohr | Blasebalg ausdrücklich beschreiben: tropfenförmig, zwei Holzbretter mit gefaltetem Leder, waagerecht auf einem Holzgestell; `--no cannon` |
| 20.11. | Essen | Bodenfleck trotz `--no ground patch`; Hintergrund cremeweiß statt reinweiß | unkritisch – der Import schneidet beides weg |
| 20.11. | Hintergründe | Epoche 1 in 3:4 auf Anhieb brauchbar: Kante bei 64 %, Fenster direkt unter den Deckenbalken, Wand hell | Format 3:4 und Bildaufbau-Text beibehalten; 50–65 % Kantenhöhe sind in Ordnung |
| 20.11. | Hintergründe | Das Spiel soll später auf dem Tablet auch im Querformat laufen – mit denselben Hintergründen, damit es gleich aussieht | **Format 1:1** (Regler: Square 1:1, danach Upscale 2×): Hochformat nutzt den mittleren 3:4-Ausschnitt (Kante unverändert bei ~55–60 %), Querformat die volle Breite; Fenster und alles Wichtige in den mittleren drei Vierteln, die äußeren Achtel nur Wand und Boden; Randdeko „near the left/right side“ statt „far edge“ |
| 20.11. | Hintergründe | erstes 1:1-Bild (Epoche 1) auf Anhieb gelungen: Kante bei 65 %, Fenster in den mittleren drei Vierteln, Regal und Hufeisen in den äußeren Achteln – genau wie vorgesehen | 1:1-Bildaufbau beibehalten; Hinweis „Upscale 2×“ hervorgehoben: Midjourney liefert ohne Upscale nur 1024 × 1024 – zu wenig für das Hochformat (1080 breit) und das Querformat |
| 20.11. | Hintergründe | drei von vier 1:1-Bildern (Epoche 1 Variante 2, Epoche 2, Epoche 3) mit einfarbig schwarzem Streifen unten (10–18 % der Höhe); der Boden hört dort abrupt auf | „the floor continues all the way to the bottom edge“, `--no black band at the bottom, dark strip below the floor`; der Import schneidet einen solchen Streifen automatisch ab (Bild bleibt brauchbar) |
| 20.11. | Hintergründe | Epoche 1, Variante 3: eine große, leere, helle Wandfläche direkt hinter der Esse lässt Esse und Amboss im Spiel am besten wirken (bei Variante 1 stand ein Fachwerkpfosten genau dahinter) | „a large plain wall area without posts or beams directly behind the centre“ in allen Hintergrund-Prompts |
| 20.11. | alle | Midjourney meldet „Long prompt – Prompts of this length will be adjusted … may increase variability“ (Hintergründe hatten ~320 Wörter) | alle Prompts gekürzt: Bausteine in Stichworten, Verbote knapp (`--no text, numbers, watermark`, freigestellt zusätzlich `border, shadow`); Wortzahl steht jetzt bei jedem Prompt |

## Midjourney-Einstellungen (Version 8.2)

**Seitenverhältnis immer am Regler einstellen** – er überstimmt `--ar` im Prompt; die nötige Einstellung steht bei jedem Bild. Version immer gleich lassen (8.2). Weirdness immer 0. Video-Einstellungen spielen keine Rolle.

| Gruppe | Model | Raw | Stylization | Variety | Speed |
|---|---|---|---|---|---|
| Werkstücke (E), Hämmer (C), Maschinenteile (D), Symbole (G) | Standard | **Raw** | niedrig (ca. 10 %) | 0 | Relax, wenn möglich |
| Essen (B), Amboss, Schabotte | Standard | **Raw** | niedrig (ca. 10 %) | 0 | Fast |
| Hintergründe (A) | **HD** (für das ausgewählte Bild) | Standard | mittel (ca. 30–40 %) | 0 | Fast |
| Porträts (F) | Standard | Standard | mittel (ca. 30 %) | 0 | Relax, wenn möglich |
| App-Icon, Store-Banner | **HD** | Standard | mittel | 0 | Fast |

Raw hält sich genauer an Vorgaben wie „genau von der Seite“ oder „Kopf links“. HD lohnt sich nur, wo das Bild groß zu sehen ist (Hintergründe 1080 × 1920, Icon, Banner); Gegenstände verkleinert das Spiel ohnehin auf 256–1000 px. Für eine Serie (z. B. alle Werkstücke) das beste Bild als Stil-Referenz `--sref <URL>` an alle weiteren Prompts der Gruppe hängen.


## Regeln für alle Bilder

- Freigestellt auf **reinem Weiß**, ohne Schatten, ohne Text, ohne Jahreszahlen, ohne Wasserzeichen.
- Objekt vollständig im Bild mit etwas Rand.
- Dateiname = die fett gedruckte ID (z. B. `door_hinge.webp`); Format egal (webp, png, jpg).
- Einheitlicher Stil: handgemalt, dünne dunkle Tuschekontur, warme Malstruktur.
- Midjourney: Prompt komplett kopieren (inkl. `--ar` und `--no`); Einstellungen je Gruppe siehe oben.
- Für einheitlichen Stil: ein gelungenes Bild als Stil-Referenz verwenden (`--sref <Bild-URL>`).

## Reihenfolge (was am meisten bringt)

1. **Essen in Frontalansicht** (B) – sieht man ständig.
2. **Hintergründe 7–10** (A) und **Dampfhammer-Teile** (D).
3. **Werkstücke** epochenweise (E), dann **Löschtrog** (G).
4. Optional: Porträts (F), Ladenbilder, Victoria-Münzen, Sterne, Sanduhr, Pyrometer-Zifferblatt.
5. Dann: alle 🟠 Midjourney-Bilder mit Hinweis nachbessern, später alle 🟡 Gemini-Bilder ersetzen (gleiche Dateinamen).

## A · Werkstatt-Hintergründe (1:1 – für Hoch- und Querformat)

Esse, Amboss und Maschinen stellt das Spiel davor – der Raum bleibt leer. Wand-Boden-Kante bei etwa 55–60 % der Höhe, unteres Drittel ruhig und dunkel (Bedienelemente).

**Format 1:1 (Regler: Square 1:1), danach Upscale 2× (Subtle) und erst das vergrößerte Bild (2048 × 2048) schicken** – ohne Upscale sind es nur 1024 × 1024. Ein Bild für beide Ausrichtungen: Im Hochformat nimmt das Spiel den mittleren 3:4-Ausschnitt (die äußeren Achtel links und rechts fallen weg) und verlängert den dunklen Boden nach unten; im Querformat (Tablet, später) die volle Breite. Deshalb gehören Fenster und alles Wichtige in die mittleren drei Viertel. Mindestgröße nach dem Upscale: 1440 × 1440 Pixel. Hilfreich: die Vorlage `assets/source/user_art/vorlagen/bildaufbau_hintergrund.png` (1:1) als **Bild-Prompt** vor den Text setzen (nicht als Stil-Referenz) und ein gelungenes Midjourney-Bild als Stil-Referenz. Ich messe die Kante bei jedem Bild aus (50–65 % geht).

Vorhandene gute 3:4-Bilder (Epoche 1) nicht neu erzeugen, sondern im Midjourney-Editor links und rechts um je ein Sechstel der Breite auf 1:1 erweitern.

**background_1** – Die Dorfschmiede (1700–1715) · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Square 1:1** · 90 Wörter  
*20.11.: Variante 3 (1:1) – Inhalt gut: Kante 63 % (Bühne y 911), große helle Putzfläche hinter der Esse, Fenster in den mittleren drei Vierteln, Regal und Hufeisen in den äußeren Achteln; schwarzer Streifen unten wird beim Import abgeschnitten. Nur die Auflösung fehlt: dasselbe Bild als Upscale 2× (2048 × 2048) nachliefern.*
```
background_1 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. English village smithy around 1700: half-timbered wall with whitewashed daub, earth floor with straw. Window view: green fields, hedge, church tower. Edges: tongs rack, horseshoes on a beam --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_2** – Kutschen & Handelswege (1715–1735) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 93 Wörter
```
background_2 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. Roadside smithy on an English coaching road around 1725: rough grey stone wall, timber beams, worn flagstones. Window view: dirt road with a stagecoach. Edges: spare coach wheel, harness on pegs --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_3** – Hafen & Royal Navy (1735–1750) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 97 Wörter
```
background_3 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. Harbour smithy in a Royal Navy dockyard around 1740: red brick, tarred timber beams, tarred plank floor. Window view: masts and furled sails of a ship of the line. Edges: barrel, coiled rope, heavy chain --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_4** – Stahl & Tuch (1750–1765) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 90 Wörter
```
background_4 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. Smith's and cutler's workshop in Sheffield around 1755: soot-darkened brick, worn stone slabs. Window view: rooftops with smoking chimneys. Edges: bolts of dyed wool, shelf with knife blades --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_5** – Das Zeitalter des Dampfes (1765–1785) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 97 Wörter
```
background_5 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. Forge of a water-powered hammer works in the Severn Gorge around 1780: brick wall, oak beams, wet stone floor. Window view: the cast-iron Iron Bridge in a wooded gorge. Right third of the floor empty --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_6** – Das Zeitalter der Eisenwerke (1785–1800) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 94 Wörter
```
background_6 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. Smithy of a large English ironworks around 1790: dark brick wall, cast-iron columns, iron floor plates with coke dust. Window view: glowing blast furnaces at dusk. Right third of the floor empty --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_7** – Krieg & Erfindergeist (1800–1820) · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Square 1:1** · 91 Wörter  
*Fenster sitzt ganz oben und wird zur Hälfte von der Statusleiste verdeckt; Wand-Boden-Kante bei 49 % (Ziel 40 %). Im Spiel nutzbar.*
```
background_7 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. London engineering smithy in Lambeth around 1810: smoke-blackened yellow brick, York stone floor. Window view: the Thames with barges, dome of St Paul's. Edges: iron bars, rack with templates --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_8** – Eisenbahnfieber (1820–1839) · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 92 Wörter
```
background_8 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. Locomotive smithy in Newcastle around 1830: dark red brick with bricked-up arches and tie-rod plates, cinder floor. Window view: early steam locomotive with coal wagons. Edges: locomotive wheels, coupling chains --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_9** – Der Dampfhammer (1839–1860) · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 93 Wörter
```
background_9 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. Forge shop of a great engineering foundry around 1845: tall soot-stained brick, cast-iron columns, iron floor plates. Window view: canal with a narrowboat, foundry chimneys. Right third of the floor empty --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

**background_10** – Das Stahlzeitalter (1860–1880) · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 94 Wörter
```
background_10 — Square 2D game background, hand-painted, dark ink outlines, moderately bright. Empty room, front view from slightly above: ceiling beams in the top 15 percent, back wall to 55 percent of the height, empty floor to the bottom edge. Small window just below the beams, left of centre. Plain wall behind the centre, warm firelight from below. Props only at the far edges. Sheffield steelworks forge around 1870: very tall dark brick wall, iron roof trusses, crane rail, iron floor plates. Window view: Bessemer converters blowing sparks at night. Right third of the floor empty --ar 1:1 --no forge, fire, anvil, machine, people, text, numbers, watermark, black band, border
```

## B · Essen (Frontalansicht, alle sechs Stufen)

Frontal und symmetrisch, leicht von oben: Das Glutbett ist ein waagerechter Streifen über etwa 60 % der Breite, damit die Werkstücke gleichmäßig nebeneinander liegen. Blasebalg bzw. Gebläse immer links. Die bisherigen Schrägansichten (Stufe 1–4) werden ersetzt.

**forge_clay** – Lehm-Esse mit Handblasebalg (Stufe 1, Epoche 1) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 97 Wörter  
*Schrägansicht – neu als Frontalansicht (Prompt unten).*
```
forge_clay — 2D game asset, a small rustic early-18th-century village forge, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of clay and rough fieldstones, a simple clay-plastered hood with a short chimney, on the left a teardrop-shaped leather bellows with wooden boards on a stand, orange glowing charcoal fire, front view from slightly above, glowing coal bed a flat band across 60 percent of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no oven, dome, arch over the fire, cannon, perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow
```

**forge_brick** – Ziegel-Esse (Stufe 2, Epoche 2) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 99 Wörter  
*Schrägansicht – neu als Frontalansicht (Prompt unten).*
```
forge_brick — 2D game asset, a smith's forge of the 1720s, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of red brick bound with iron straps, a brick hood and a square brick chimney, on the left a teardrop-shaped leather bellows with wooden boards on a stand, bright orange coal fire, front view from slightly above, glowing coal bed a flat band across 60 percent of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no oven, dome, arch over the fire, cannon, perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow
```

**forge_double_bellows** – Esse mit Doppelblasebalg (Stufe 3, Epoche 3) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 96 Wörter  
*Schrägansicht – neu als Frontalansicht (Prompt unten).*
```
forge_double_bellows — 2D game asset, a large smith's forge of the 1740s, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of brick and stone, a wide brick hood bound with iron bands, on the left two stacked teardrop-shaped leather bellows with one long lever, hot yellow-orange coal fire, front view from slightly above, glowing coal bed a flat band across 60 percent of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no oven, dome, arch over the fire, cannon, perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow
```

**forge_coke** – Koks-Esse mit Zylindergebläse (Stufe 4, Epoche 5) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 100 Wörter  
*Schrägansicht – neu als Frontalansicht (Prompt unten).*
```
forge_coke — 2D game asset, a long late-18th-century coke-fired smith's forge, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of cast-iron plates and firebrick, a riveted iron hood and a round iron chimney, on the left an upright cast-iron blowing cylinder with an air pipe into the hearth, brilliant yellow-white coke fire, front view from slightly above, glowing coal bed a flat band across 60 percent of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no oven, dome, arch over the fire, perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow
```

**forge_welding_furnace** – Schweißofen (Stufe 5, Epoche 8) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 79 Wörter
```
forge_welding_furnace — 2D game asset, a long 1830s coal-fired welding furnace: a low hearth of firebrick and cast-iron plates bound by iron tie bars, a low brick arch over a long white-hot coal bed, a short square brick chimney, front view from slightly above, glowing coal bed a flat band across 60 percent of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow
```

**forge_siemens** – Siemens-Gasofen (Stufe 6, Epoche 10) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 87 Wörter
```
forge_siemens — 2D game asset, a massive 1870s Siemens regenerative gas furnace: a rectangular firebrick body clad with riveted iron plates and vertical iron buckstays, a wide open working front showing a blinding white-hot hearth, gas pipes with valves at both sides, a squat iron chimney stub, front view from slightly above, glowing coal bed a flat band across 60 percent of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow
```

## C · Amboss und Hämmer

Hämmer in reiner Seitenansicht: Kopf links senkrecht, Bahn unten, Stiel waagerecht nach rechts.

**anvil** – Amboss auf Eichenklotz (alle Epochen) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 35 Wörter
```
anvil — 2D game sprite asset, heavy 18th-century cast iron anvil mounted on a thick oak wood stump, blacksmith equipment, side-view orthographic perspective, horn pointing to the right, crisp clean edges, isolated on white background, game art --ar 1:1 --no text, numbers, watermark, border, shadow
```

**hammer_hand** – Handhammer (Stufe 1) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 79 Wörter
```
hammer_hand — 2D game asset, a simple 18th-century blacksmith's hand hammer in flat side view (orthographic), the plain forged iron head stands upright on the left: flat striking face pointing straight down, short rounded back pointing straight up, the straight ash-wood handle goes through the middle of the head and points horizontally to the right, matte dark iron with hammer marks, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, engraving, text, numbers, watermark, border, shadow
```

**hammer_cross_peen** – Kreuzschlaghammer (Stufe 2) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 86 Wörter
```
hammer_cross_peen — 2D game asset, an 18th-century cast iron cross-peen blacksmith's hammer in flat side view (orthographic), the head stands upright on the left: square flat striking face pointing straight down, the back of the head tapers to a wedge-shaped cross peen pointing straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, dark cast iron with slight rust, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, engraving, text, numbers, watermark, border, shadow
```

**hammer_steel_faced** – Hammer mit verstählter Bahn (Stufe 3) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 95 Wörter
```
hammer_steel_faced — 2D game asset, an 18th-century blacksmith's hammer with a steel-faced head in flat side view (orthographic), the head stands upright on the left: dark wrought iron body with a bright polished steel striking face forge-welded onto the bottom, a visible weld line between iron and steel, the striking face points straight down, a wedge-shaped peen points straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, engraving, text, numbers, watermark, border, shadow
```

**hammer_crucible** – Gussstahl-Hammer / Tiegelstahl (Stufe 4) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 85 Wörter
```
hammer_crucible — 2D game asset, a high-quality late-18th-century crucible steel blacksmith's hammer in flat side view (orthographic), the polished bright steel head stands upright on the left: flat striking face pointing straight down, short flat back pointing straight up, a decorated brass ferrule where the head meets the handle, the straight dark walnut handle points horizontally to the right and ends in a small brass end cap, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, engraving, text, numbers, watermark, border, shadow
```

## D · Maschinen (Einzelteile für die Animation)

Drehteile genau von vorn und kreisrund, Mittelpunkt = Bildmitte; bewegliche Teile einzeln.

**water_wheel** – Wasserrad (Wasser-Schwanzhammer, Epoche 5) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 56 Wörter
```
water_wheel — 2D game asset, a single wooden undershot water wheel seen exactly from the side so that it is a perfect circle, eight straight spokes, wooden paddles all around the rim, iron bands and an iron axle hub exactly in the centre of the image, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no water, frame, stand, text, numbers, watermark, border, shadow
```

**helve_beam** – Hammerbalken mit Hammerkopf (Epoche 5–8) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 64 Wörter
```
helve_beam — 2D game asset, a single helve-hammer beam seen exactly from the side: a long heavy oak beam lying horizontally, bound with iron hoops, a round iron pivot boss with a hole at one third from the left end, a heavy forged iron hammer head fixed at the right end pointing straight down, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no frame, posts, anvil, text, numbers, watermark, border, shadow
```

**helve_frame** – Gestell mit Daumenwelle · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 61 Wörter
```
helve_frame — 2D game asset, the wooden support frame of an 18th-century helve hammer seen exactly from the side: two heavy upright oak posts joined by cross beams, an iron bearing on top of the posts for a pivot, and a horizontal cam shaft with four iron cams at the bottom, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no hammer beam, water wheel, anvil, text, numbers, watermark, border, shadow
```

**flywheel** – Schwungrad (Dampf-Schwanzhammer, Epoche 6–8) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 54 Wörter
```
flywheel — 2D game asset, a single cast-iron flywheel of an 18th-century beam engine seen exactly from the front so that it is a perfect circle, six gently curved spokes, a heavy rim, the hub exactly in the centre of the image, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 1:1 --no frame, shaft stand, text, numbers, watermark, border, shadow
```

**engine_body** – Dampfmaschine ohne Balancier und Schwungrad · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 68 Wörter
```
engine_body — 2D game asset, the body of a Boulton and Watt style beam engine around 1785 seen from the side: a tall vertical cast-iron steam cylinder with a piston rod sticking out of the top, a brick and timber engine bed, a tall cast-iron column on the right that would carry a beam, pipes and valve gear, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no rocking beam, flywheel, smoke, text, numbers, watermark, border, shadow
```

**engine_beam** – Balancier · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 61 Wörter
```
engine_beam — 2D game asset, a single cast-iron rocking beam of an 18th-century beam engine seen from the side: long horizontal beam, thicker in the middle and tapering to both ends, an open lattice pattern, a round pivot hole exactly in the centre and connection eyes at both ends, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 1:1 --no column, engine, text, numbers, watermark, border, shadow
```

**steam_hammer_frame** – Dampfhammer: Gestell (Epoche 9) · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 91 Wörter
```
steam_hammer_frame — 2D game asset, the frame of an 1840s Nasmyth steam hammer exact front view (orthographic): two tall cast-iron standards shaped like an inverted V on each side, joined at the top by a heavy cross beam that carries a vertical steam cylinder with flanges and a valve chest, a control lever with a handle on the right standard, a tall empty open gap in the middle between the standards where the hammer moves, hand-painted 2D game art, dark ink outlines, dark iron with rivets and bolts, on pure flat white background --ar 3:4 --no perspective, hammer head, piston rod, anvil, text, numbers, watermark, border, shadow
```

**steam_hammer_ram** – Dampfhammer: Bär mit Kolbenstange · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 64 Wörter
```
steam_hammer_ram — 2D game asset, the moving ram (tup) of an 1840s steam hammer exact front view (orthographic): a long vertical polished piston rod at the top fixed into a heavy rectangular cast-iron hammer block with guide grooves on both sides and a flat steel die at the very bottom, upright and perfectly vertical, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:2 --no perspective, frame, cylinder, anvil, text, numbers, watermark, border, shadow
```

**steam_hammer_anvil** – Dampfhammer: Schabotte (Ambossblock) · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 57 Wörter
```
steam_hammer_anvil — 2D game asset, the anvil block (schabotte) of an 1840s steam hammer exact front view (orthographic): a massive squat cast-iron block, wider at the base, with a flat steel die on top held by a dovetail and wedges, set on heavy oak timbers, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 3:2 --no perspective, hammer, frame, text, numbers, watermark, border, shadow
```

**steam_hammer_large_frame** – Gestell des großen Dampfhammers (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 3:4** · 71 Wörter
```
steam_hammer_large_frame — 2D game asset, the frame of a huge 1870s double-standard steam hammer exact front view (orthographic): two massive riveted wrought-iron standards forming an arch, a large steam cylinder on top with pipes and valve gear, a platform with railing for the hammer driver, a tall empty open gap in the middle where the hammer moves, hand-painted 2D game art, dark ink outlines, dark iron with rivets, on pure flat white background --ar 3:4 --no perspective, hammer head, piston rod, anvil, text, numbers, watermark, border, shadow
```

**Ladenbilder der Maschinen** (ganze Maschine als ein Bild, nur für den Laden)

**machine_water_helve** – Wasser-Schwanzhammer (Ladenbild) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 53 Wörter
```
machine_water_helve — 2D game asset, an 18th-century water-powered helve hammer: a wooden undershot water wheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on a wooden stump on the right, side view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**machine_steam_helve** – Dampf-Schwanzhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 51 Wörter
```
machine_steam_helve — 2D game asset, a 1790s steam-powered helve hammer: a small beam engine with a flywheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on the right, side view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**machine_nasmyth** – Nasmyth-Dampfhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 42 Wörter
```
machine_nasmyth — 2D game asset, an 1840s Nasmyth steam hammer: two cast-iron standards, a steam cylinder on top, the hammer block hanging above a massive anvil block, a control lever, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**machine_great_steam_hammer** – Großer Dampfhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 40 Wörter
```
machine_great_steam_hammer — 2D game asset, a huge 1870s steam hammer with riveted wrought-iron arch standards, a large cylinder, a platform for the driver and a massive anvil block, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

## E · Werkstücke (Rohling + 80)

Kalt, nur Metall (kein Holz), von oben, weißer Hintergrund ohne Schatten, quadratisch. Die Glut färbt das Spiel ein.

**blank** – Rohling (alle Epochen) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 69 Wörter
```
blank — 2D game asset, a single piece of rectangular wrought iron bar stock, about eight times as long as it is wide, square cross-section, both ends roughly cut, horizontal from left to right, dark grey wrought iron with mill scale, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

### Epoche 1 – Die Dorfschmiede (1700–1715)

**nail** – Nagel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 64 Wörter
```
nail — 2D game asset, a single large hand-forged nail with a square tapering shank ending in a sharp point and a faceted hammered rosehead, horizontal with the head on the left, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**horseshoe** – Hufeisen · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 53 Wörter
```
horseshoe — 2D game asset, a single hand-forged horseshoe with a fullered groove and eight square nail holes, opening pointing down, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**hook** – Haken · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 61 Wörter
```
hook — 2D game asset, a single hand-forged S-shaped hanging hook made from round bar, pointed tip on the lower curve, small curled scroll on the upper end, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**door_hinge** – Türangel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 73 Wörter
```
door_hinge — 2D game asset, a single hand-forged strap hinge for a cottage door: long flat tapering iron strap with three round nail holes, a rolled eye at the left end and a spade-shaped decorative tip at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**sickle** – Sichel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 71 Wörter
```
sickle — 2D game asset, a single hand-forged sickle blade without handle: wide crescent-shaped thin steel blade with a smooth ground inner edge and a short pointed bare tang on the left, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**ploughshare** – Pflugschar · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 66 Wörter
```
ploughshare — 2D game asset, a single hand-forged ploughshare: flat, slightly curved triangular iron blade with a sharp point on the right and a short socket with two bolt holes on the left, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**fire_poker** – Schürhaken · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 75 Wörter
```
fire_poker — 2D game asset, a single hand-forged fireplace poker: long round iron bar with a small hooked side spur at the tip, a twisted section near the handle and a closed ring loop as handle, horizontal with the tip on the right, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**gate_latch** – Torriegel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 66 Wörter
```
gate_latch — 2D game asset, a single hand-forged gate latch: flat iron latch bar with a curled thumb lever at one end and a small decorative scrolled back plate with two nail holes, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

### Epoche 2 – Kutschen & Handelswege (1715–1735)

**wheel_tyre** – Radreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
wheel_tyre — 2D game asset, a single forged iron wheel tyre: one flat iron hoop forming a perfect circle seen from directly above, narrow uniform band, a visible forge-welded joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**coach_axle** – Kutschachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 65 Wörter
```
coach_axle — 2D game asset, a single forged coach axle: straight thick square iron bar with a round tapered axle arm at each end and a raised collar where each arm begins, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**coach_fitting** – Kutschbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
coach_fitting — 2D game asset, a single forged coach body fitting: flat iron stay bar with elegant scrolled curls at both ends and four countersunk bolt holes, gently curved, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**lantern_bracket** – Laternenhalter · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 76 Wörter
```
lantern_bracket — 2D game asset, a single hand-forged wall bracket for a hanging lantern: horizontal square-bar arm with a small hook at the right tip, a decorative scroll brace below the arm, and a flat wall plate with two nail holes on the left, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**post_horseshoe** – Postpferd-Hufeisen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
post_horseshoe — 2D game asset, a single light hand-forged horseshoe for a coach horse: narrow web, deep fullered groove, six nail holes and a small raised toe clip at the front, opening pointing down, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**turnpike_fitting** – Schlagbaumbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter
```
turnpike_fitting — 2D game asset, a single heavy forged hinge for a turnpike toll gate: thick flat iron strap with three bolt holes and a large rolled eye at the left end, with an L-shaped iron pintle pin seated in the eye, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**drag_shoe** – Hemmschuh · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter
```
drag_shoe — 2D game asset, a single forged drag shoe for a coach wheel: elongated iron skid shaped like a narrow trough, front end curled upwards, a forged ring for the chain at the back, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

### Epoche 3 – Hafen & Royal Navy (1735–1750)

**chain_link** – Kettenglied · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
chain_link — 2D game asset, a single large forged oval chain link made from thick round bar, a visible forge-weld seam on one long side, empty in the middle, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**anchor_shank** – Ankerschaft · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter
```
anchor_shank — 2D game asset, a single forged ship's anchor shank without arms: long thick square iron bar, a forged ring eye at the left end, a thickened square crown block at the right end where the anchor arms would be welded, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**boathook** – Bootshaken · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
boathook — 2D game asset, a single forged boathook head without pole: a straight pointed spike on the right with one backward-curving hook beside it, and a conical open socket on the left, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**mooring_ring** – Festmacherring · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter
```
mooring_ring — 2D game asset, a single heavy forged mooring ring: thick round-section iron ring, empty in the middle, held by a short U-shaped staple with two pointed spikes at the bottom, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**ship_bolt** – Schiffsbolzen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter
```
ship_bolt — 2D game asset, a single forged ship's bolt: long round iron rod with a domed head at the left end and a narrow slot for a forelock wedge near the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**carriage_fitting** – Lafettenbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 76 Wörter
```
carriage_fitting — 2D game asset, a single forged gun-carriage fitting (cap square): heavy flat iron band bent into a half-round arch in the middle, a hinge eye at the left end and a slotted tab with two bolt holes at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**rudder_pintle** – Ruderfingerling · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 93 Wörter
```
rudder_pintle — 2D game asset, a single forged rudder pintle for a sailing ship: long flat iron strap with four bolt holes, at the left end bent into a thick round pin pointing downwards at a right angle, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow
```

### Epoche 4 – Stahl & Tuch (1750–1765)

**spindle** – Spindel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
spindle — 2D game asset, a single forged spindle for a spinning machine: long thin round steel rod tapering to a fine point on the right, with a small round collar near the left end, horizontal, dark grey unheated forged steel, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**cloth_shears** – Tuchschere · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter
```
cloth_shears — 2D game asset, a single pair of large forged cloth shears of the spring type: two long straight steel blades joined at the left end by a U-shaped bow spring, blades slightly open, horizontal, dark grey unheated forged steel with slightly brighter ground edges, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, pivot screw, other objects, text, numbers, watermark, border, shadow
```

**knife** – Messerklinge · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter
```
knife — 2D game asset, a single forged knife blade without handle: straight spine, curved sharp edge rising to a point on the right, a narrow bare tang on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**spring** – Feder · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter
```
spring — 2D game asset, a single hand-forged coil spring: steel wire wound into eight even coils with open straight ends, seen from the side, horizontal, dark grey unheated forged steel, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow
```

**chisel** – Meißel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter
```
chisel — 2D game asset, a single forged cold chisel: octagonal steel bar, slightly mushroomed striking head on the left, tapering to a sharp ground cutting edge on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**file** – Feile · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
file — 2D game asset, a single hand-cut file without handle: flat steel bar tapering towards the right, the whole surface covered with fine diagonal cross-hatched teeth, a narrow pointed bare tang on the left, horizontal, dark grey unheated forged steel, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**cargo_chain** – Ladekette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 63 Wörter
```
cargo_chain — 2D game asset, a short forged cargo chain: five interlocking oval links of round bar with a forged cargo hook at the right end, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**barrel_hoop** – Fassreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
barrel_hoop — 2D game asset, a single forged barrel hoop: thin flat iron band forming a circle seen from directly above, a small riveted overlap joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

### Epoche 5 – Das Zeitalter des Dampfes (1765–1785)

**piston_rod** – Kolbenstange · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter
```
piston_rod — 2D game asset, a single forged piston rod for a steam engine: long perfectly straight round iron rod, a forged flat crosshead eye at the left end and a tapered end with a cotter slot at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**valve_part** – Ventilteil · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 86 Wörter
```
valve_part — 2D game asset, a single forged steam-engine valve: round flat valve disc with a bevelled rim on the left and a straight round valve stem pointing to the right, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow
```

**beam_strap** – Balancierbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter
```
beam_strap — 2D game asset, a single forged strap for a beam engine: heavy flat iron band bent into a long U-shape lying on its side, with two rectangular cotter slots through both legs near the open end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**lock_fitting** – Schleusenbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 65 Wörter
```
lock_fitting — 2D game asset, a single forged canal lock-gate fitting: heavy flat iron collar band bent into a rectangular U-shape with two long straight arms, each arm with three bolt holes, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**miners_pick** – Keilhaue · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 79 Wörter
```
miners_pick — 2D game asset, a single forged miner's pick head without handle: slightly curved steel head with one long pointed end on the right, a short blunt poll on the left and an empty oval eye in the middle, horizontal, dark grey unheated forged steel with a slightly brighter point, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**drill_steel** – Bohreisen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
drill_steel — 2D game asset, a single forged rock drill steel for mining: long octagonal steel bar with a wide chisel-shaped bit on the right and a flat striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter bit, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**conveyor_chain** – Förderkette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter
```
conveyor_chain — 2D game asset, a short length of heavy flat-link winding chain for a mine shaft: five flat forged iron plate links connected by round pins, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**pump_rod** – Pumpengestänge · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 76 Wörter
```
pump_rod — 2D game asset, a single section of forged pump rod for a Cornish mine pump: long square iron rod with a flat forked strap joint and two bolt holes at the left end and a plain square end on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

### Epoche 6 – Das Zeitalter der Eisenwerke (1785–1800)

**boiler_rivet** – Kesselniete · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 78 Wörter
```
boiler_rivet — 2D game asset, a single large forged boiler rivet: short thick round shank with a domed snap head on the left, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow
```

**boiler_plate** – Kesselblech · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter
```
boiler_plate — 2D game asset, a single forged wrought iron boiler plate: thick rectangular iron sheet, landscape format, slightly uneven hammered surface, one row of round rivet holes along all four edges, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**rabble** – Puddelkrücke · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
rabble — 2D game asset, a single forged puddling rabble: very long round iron rod with a flat rectangular paddle blade bent at a right angle at the right end and a closed loop handle at the left end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**tie_rod** – Zuganker · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter
```
tie_rod — 2D game asset, a single forged building tie rod: long round iron rod with a decorative S-shaped wall anchor plate at the left end and a forged eye at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**ship_chain** – Ankerkette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 63 Wörter
```
ship_chain — 2D game asset, a short length of heavy open-link anchor cable: four very large interlocking oval links of thick round bar, without cross studs, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**lathe_tool** – Drehmeißel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
lathe_tool — 2D game asset, a single forged lathe cutting tool: short square steel bar with a bent, sharply ground hooked cutting tip on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground tip, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**leaf_spring** – Blattfeder · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 94 Wörter
```
leaf_spring — 2D game asset, a single forged carriage leaf spring: a stack of five gently curved steel leaves of decreasing length held by a central iron clamp band, rolled eyes at both ends of the longest leaf, seen from the side, horizontal, dark grey unheated forged steel, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow
```

**wagon_axle** – Wagenachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
wagon_axle — 2D game asset, a single heavy forged wagon axle for a horse-drawn plateway wagon: thick straight round iron bar with a raised collar and a short round journal at each end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**large_shaft** – Antriebswelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter
```
large_shaft — 2D game asset, a single forged mill drive shaft: very long thick round iron shaft with two square bosses and two raised collars along its length and round journals at both ends, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**crankshaft** – Kurbelwelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 89 Wörter
```
crankshaft — 2D game asset, a single forged crankshaft: straight round iron shaft with one single crank throw in the middle, made of two rectangular webs and a round crankpin offset to one side, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow
```

### Epoche 7 – Krieg & Erfindergeist (1800–1820)

**block_pin** – Blockrollen-Bolzen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter
```
block_pin — 2D game asset, a single forged pulley-block pin: short thick perfectly straight round iron pin with a slightly domed head on the left and a small hole for a split pin near the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**boiler_stay** – Kessel-Stehbolzen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
boiler_stay — 2D game asset, a single forged boiler stay bolt: a long straight round iron rod with a thick upset collar near each end and slightly peened ends, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**gas_lamp_bracket** – Gaslaternen-Ausleger · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 86 Wörter
```
gas_lamp_bracket — 2D game asset, a single hand-forged wall bracket for a gas street lamp: a horizontal arm of square bar with a decorative twisted section and a large scroll brace underneath, a flat wall plate with four bolt holes on the left and a downward ring at the right tip for the lamp, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**navvy_spade** – Spaten · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 80 Wörter
```
navvy_spade — 2D game asset, a single forged navvy's spade blade without wooden handle: a broad flat slightly dished iron blade with a squared cutting edge at the bottom, rolled tread edges at the top and a long tapering open socket strap, upright with the socket pointing up, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**press_screw** – Pressenspindel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 79 Wörter
```
press_screw — 2D game asset, a single forged screw spindle for an iron printing press: a thick round iron rod with a coarse square thread twisted along its middle part, a square end for the lever on the left and a round foot on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**bayonet** – Bajonett · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 83 Wörter
```
bayonet — 2D game asset, a single forged socket bayonet without musket: a long triangular-section steel blade tapering to a sharp point on the right, joined by a short curved neck to a round hollow socket with an L-shaped slot on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**anchor_fluke** – Ankerarm · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter
```
anchor_fluke — 2D game asset, a single forged anchor arm for a ship's anchor: a thick curved iron arm ending in a broad flat triangular fluke (palm) on the right and a heavy square stump on the left where it is welded to the shank, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**chain_eyebar** – Brückenglied · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
chain_eyebar — 2D game asset, a single forged suspension bridge eyebar: a long flat wrought iron bar with a thickened round eye with a large hole at each end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

### Epoche 8 – Eisenbahnfieber (1820–1839)

**rail_spike** – Schienennagel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter
```
rail_spike — 2D game asset, a single forged railway track spike: a long square-section iron shank with a chisel point at the bottom and a hooked offset head at the top, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**coupling_hook** – Kupplungshaken · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
coupling_hook — 2D game asset, a single forged railway wagon coupling hook: a heavy curved iron hook with a thick shank and a punched eye at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**safety_valve_lever** – Sicherheitsventil-Hebel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter
```
safety_valve_lever — 2D game asset, a single forged safety valve lever for a locomotive boiler: a long flat iron lever with a fork and pin hole at the left end, two holes along its length and a rounded end on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**coupling_chain** – Kupplungskette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 55 Wörter
```
coupling_chain — 2D game asset, a short forged railway coupling chain: three heavy oval links of round bar, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**loco_tyre** – Lokomotiv-Radreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
loco_tyre — 2D game asset, a single forged locomotive wheel tyre: a thick iron hoop seen from directly above forming a perfect circle, with a raised flange along the inner edge and a visible forge-welded joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**buffer_spring** – Pufferfeder · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter
```
buffer_spring — 2D game asset, a single forged railway buffer spring: a stack of four curved steel leaves held by a central iron band, seen from the side, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**connecting_rod** – Treibstange · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter
```
connecting_rod — 2D game asset, a single forged locomotive connecting rod: a long tapered flat iron rod with a large rectangular strap end with a bearing hole on the left and a smaller round eye on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**crank_axle** – Kurbelachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
crank_axle — 2D game asset, a single forged locomotive crank axle: a thick straight round iron axle with two offset crank throws in the middle, each made of two rectangular webs and a crank pin, seen from the side, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

### Epoche 9 – Der Dampfhammer (1839–1860)

**bridge_rivet** – Brückenniete · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 56 Wörter
```
bridge_rivet — 2D game asset, a single large forged bridge rivet: short thick round shank with a domed head, seen from the side, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**palace_bracket** – Säulenkopf-Beschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
palace_bracket — 2D game asset, a single forged iron connecting bracket for a glass-and-iron exhibition hall: a flat L-shaped iron plate with a decorative curved gusset and six bolt holes, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**paddle_arm** – Schaufelrad-Arm · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
paddle_arm — 2D game asset, a single forged paddle-wheel arm for a paddle steamer: a long flat iron bar with a bolted palm plate at the right end and two bolt holes at the left end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**hammer_die** – Hammergesenk · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter
```
hammer_die — 2D game asset, a single forged steam-hammer die: a heavy rectangular steel block with a dovetail tongue on top and a smooth flat working face at the bottom, seen from the side, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**admiralty_anchor** – Admiralitätsanker · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter
```
admiralty_anchor — 2D game asset, a single forged Admiralty pattern anchor without stock: a long straight shank with a ring at the top and two curved arms with broad triangular flukes at the bottom, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**marine_piston_rod** – Schiffs-Kolbenstange · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
marine_piston_rod — 2D game asset, a single forged marine engine piston rod: a very long perfectly straight round iron rod with a tapered cone end on the left and a forged crosshead block with a hole on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**marine_crank** – Schiffskurbel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter
```
marine_crank — 2D game asset, a single forged marine engine crank: a heavy flat iron crank arm with a large round boss with a shaft hole at the left end and a smaller boss with a pin hole at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**propeller_shaft** – Schraubenwelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter
```
propeller_shaft — 2D game asset, a single forged ship's propeller shaft: a very long thick round iron shaft with a flanged coupling disc at the left end and a tapered end with a keyway on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

### Epoche 10 – Das Stahlzeitalter (1860–1880)

**velocipede_fork** – Hochrad-Gabel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
velocipede_fork — 2D game asset, a single forged front fork of a penny-farthing bicycle: two long slightly curved steel blades joined at the top by a crown with a vertical steering stem, upright, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**steel_axle** – Stahlachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
steel_axle — 2D game asset, a single forged railway carriage steel axle: a thick straight round steel bar with raised wheel seats and short round journals at both ends, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**reaper_knife** – Mähmesser · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter
```
reaper_knife — 2D game asset, a single forged reaper section knife: a long flat steel bar with a row of riveted triangular cutting sections along its upper edge, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**tunnel_drill** – Tunnelbohrer · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter
```
tunnel_drill — 2D game asset, a single forged tunnelling drill steel: a long octagonal steel bar with a cross-shaped four-point bit on the right and a collar near the striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**steel_tyre** – Stahl-Radreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
steel_tyre — 2D game asset, a single weldless forged steel wheel tyre seen from directly above: a thick perfect steel ring seamless, with a flange along the inner edge, empty in the middle, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**gun_hoop** – Geschützring · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter
```
gun_hoop — 2D game asset, a single forged gun hoop for a built-up cannon: a short thick wide iron ring seen at a slight angle from above so its thickness is visible, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**armour_plate** – Panzerplatte · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
armour_plate — 2D game asset, a single forged armour plate for an ironclad warship: a very thick rectangular wrought iron slab, landscape format, with slightly bevelled edges and a row of bolt holes along the long edges, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

**steel_shaft** – Stahlwelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter
```
steel_shaft — 2D game asset, a single forged steel intermediate shaft for an ocean liner: a very long thick round steel shaft with a large flanged coupling disc at each end, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow
```

## F · Kundenporträts (54)

Die aktuellen Porträts sind noch meine gerenderten (im Spiel vorhanden, aber im alten Stil). Für einen einheitlichen Stil empfehlenswert, aber nicht zwingend.

**portrait_squire** – the squire (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_squire — 2D game asset, a head-and-shoulders portrait of a stout English country squire of about 1710, full-bottomed powdered wig, brown velvet coat, ruddy cheeks, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_vicar** – the vicar (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_vicar — 2D game asset, a head-and-shoulders portrait of an elderly Anglican village vicar of about 1710, black cassock, white preaching bands, small grey wig, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_farmer_hollow** – Farmer Hollow (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_farmer_hollow — 2D game asset, a head-and-shoulders portrait of a weathered English farmer of about 1710, grey hair tied back, linen smock, broad-brimmed straw hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_miller_upton** – the miller of Upton (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_miller_upton — 2D game asset, a head-and-shoulders portrait of a cheerful village miller of about 1710, flour-dusted face and clothes, white linen cap, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_landlady_red_lion** – the landlady of the Red Lion (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 57 Wörter
```
portrait_landlady_red_lion — 2D game asset, a head-and-shoulders portrait of a sturdy English innkeeper's wife of about 1710, white linen cap, shawl over a laced bodice, warm smile, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_carpenter** – the carpenter (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_carpenter — 2D game asset, a head-and-shoulders portrait of an English village carpenter of about 1710, leather apron, rolled sleeves, a pencil behind the ear, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_postmaster_bath** – the postmaster of Bath (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_postmaster_bath — 2D game asset, a head-and-shoulders portrait of a fashionable postmaster of Bath around 1725, neat tie wig, blue coat with brass buttons, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_coachbuilder_york** – the coachbuilder of York (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 58 Wörter
```
portrait_coachbuilder_york — 2D game asset, a head-and-shoulders portrait of a coachbuilder from York around 1725, sturdy man in a waistcoat with rolled sleeves, wood shavings on his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_turnpike_trust** – the Turnpike Trust (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_turnpike_trust — 2D game asset, a head-and-shoulders portrait of a gentleman trustee of a turnpike road around 1725, tricorn hat, grey coat, holding a ledger, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_innkeeper_coaching** – the coaching-inn keeper (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_innkeeper_coaching — 2D game asset, a head-and-shoulders portrait of the portly landlord of a coaching inn around 1725, red waistcoat, white apron, jolly expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_carrier_bennett** – Carrier Bennett (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 57 Wörter
```
portrait_carrier_bennett — 2D game asset, a head-and-shoulders portrait of a carrier wagon driver around 1725, weather-beaten face, slouch hat, heavy woollen greatcoat, a whip over his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_navy_board** – the Navy Board (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_navy_board — 2D game asset, a head-and-shoulders portrait of a Navy Board commissioner around 1740, white powdered wig, dark blue coat with gold lace, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_shipwright_portsmouth** – the master shipwright of Portsmouth (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 57 Wörter
```
portrait_shipwright_portsmouth — 2D game asset, a head-and-shoulders portrait of a master shipwright of Portsmouth around 1740, grey hair, plain brown coat, holding a pair of brass dividers, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_merchant_bristol** – a Bristol merchant (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_merchant_bristol — 2D game asset, a head-and-shoulders portrait of a wealthy Bristol merchant around 1740, powdered wig, rich green silk coat, lace cravat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_harbourmaster** – the harbourmaster (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_harbourmaster — 2D game asset, a head-and-shoulders portrait of a harbourmaster around 1740, weathered sailor's face, tricorn hat, dark blue sea coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_ropewalk_chatham** – the Chatham ropewalk (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 61 Wörter
```
portrait_ropewalk_chatham — 2D game asset, a head-and-shoulders portrait of the foreman of the Chatham ropewalk around 1740, strong man with tarred hands, knitted cap, a coil of rope over his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_clothier_leeds** – a Leeds clothier (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_clothier_leeds — 2D game asset, a head-and-shoulders portrait of a prosperous Leeds clothier around 1755, brown wig, plain cloth coat, holding a bolt of dyed wool, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_cutlers_sheffield** – the Sheffield cutlers (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 57 Wörter
```
portrait_cutlers_sheffield — 2D game asset, a head-and-shoulders portrait of the Master Cutler of Sheffield around 1755, dignified man with a chain of office over a dark coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_spinning_master** – the spinning master (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_spinning_master — 2D game asset, a head-and-shoulders portrait of a spinning master around 1760, middle-aged man in shirtsleeves and waistcoat, wisps of cotton on his clothes, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_toolmaker_holt** – toolmaker Holt (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_toolmaker_holt — 2D game asset, a head-and-shoulders portrait of a wiry toolmaker around 1760, spectacles on the nose, leather apron, a file in his hand, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_dockyard_chatham** – Chatham Dockyard (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_dockyard_chatham — 2D game asset, a head-and-shoulders portrait of the master attendant of Chatham Dockyard around 1760, naval officer, white wig, blue coat with gold buttons, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_boulton_watt** – Boulton & Watt of Soho (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 65 Wörter
```
portrait_boulton_watt — 2D game asset, a head-and-shoulders portrait of two engineering partners of Birmingham around 1780 side by side, one stout and cheerful in a fine coat, one thin and thoughtful Scotsman with grey hair, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_mine_cornwall** – a Cornish tin mine (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 60 Wörter
```
portrait_mine_cornwall — 2D game asset, a head-and-shoulders portrait of the captain of a Cornish tin mine around 1775, rugged face, miner's felt hat with a candle stuck on with clay, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_colliery_wednesbury** – the Wednesbury colliery (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_colliery_wednesbury — 2D game asset, a head-and-shoulders portrait of a colliery owner from Wednesbury around 1775, stout man, tall hat, coal dust on his collar, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_canal_company** – the canal company (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter
```
portrait_canal_company — 2D game asset, a head-and-shoulders portrait of a canal company engineer around 1775, surveyor's coat, holding rolled plans, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_ironmaster_coalbrookdale** – the ironmaster of Coalbrookdale (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_ironmaster_coalbrookdale — 2D game asset, a head-and-shoulders portrait of a Quaker ironmaster of Coalbrookdale around 1779, plain dark Quaker coat, broad-brimmed hat, calm expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_wedgwood_etruria** – Josiah Wedgwood of Etruria (Epoche 5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 58 Wörter
```
portrait_wedgwood_etruria — 2D game asset, a head-and-shoulders portrait of a master potter of Staffordshire around 1770, dignified man in a brown coat, holding a pale blue jasperware vase, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_mill_owner** – a cotton-mill owner (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 51 Wörter
```
portrait_mill_owner — 2D game asset, a head-and-shoulders portrait of a self-made cotton-mill owner around 1790, high collar, brown tailcoat, watch chain, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_plateway_company** – the plateway company (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_plateway_company — 2D game asset, a head-and-shoulders portrait of a tramroad company agent around 1790, top hat, grey tailcoat, holding a measuring rod, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_engine_works** – an engine works (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_engine_works — 2D game asset, a head-and-shoulders portrait of an engine-works manager around 1790, sideburns, dark tailcoat, an oil stain on his cuff, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_ironworks_partners** – your ironworks partners (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_ironworks_partners — 2D game asset, a head-and-shoulders portrait of a well-to-do ironworks partner around 1795, silver hair, black tailcoat, high white cravat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_east_india** – the East India Company (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_east_india — 2D game asset, a head-and-shoulders portrait of an East India Company director around 1795, powdered wig, rich red coat, gold-headed cane, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_navy_portsmouth** – the Portsmouth block mills (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_navy_portsmouth — 2D game asset, a head-and-shoulders portrait of a naval officer overseeing the Portsmouth block mills around 1805, bicorne hat, blue coat with an epaulette, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_maudslay** – Henry Maudslay of Lambeth (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_maudslay — 2D game asset, a head-and-shoulders portrait of a broad-shouldered master engineer of London around 1810, kind face, dark coat, holding a brass micrometer, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_telford** – the engineer Thomas Telford (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_telford — 2D game asset, a head-and-shoulders portrait of a Scottish civil engineer around 1815, grey hair, plain dark coat and cravat, rolled bridge drawings, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_gas_light_company** – the Gas Light and Coke Company (Epoche 7) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_gas_light_company — 2D game asset, a head-and-shoulders portrait of a gas company director around 1812, top hat, bottle-green tailcoat, a small gas lamp beside him, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_horse_guards** – the Royal Horse Guards (Epoche 7) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_horse_guards — 2D game asset, a head-and-shoulders portrait of a Royal Horse Guards officer around 1815, blue tunic, shining steel helmet with a plume, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_trevithick** – Richard Trevithick (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_trevithick — 2D game asset, a head-and-shoulders portrait of a tall Cornish engineer around 1805, curly hair, open-necked shirt and waistcoat, energetic expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_stockton_darlington** – the Stockton & Darlington Railway (Epoche 8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter
```
portrait_stockton_darlington — 2D game asset, a head-and-shoulders portrait of a Quaker railway promoter around 1825, plain dark coat, broad-brimmed hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_stephenson_works** – Robert Stephenson & Co. (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_stephenson_works — 2D game asset, a head-and-shoulders portrait of a young locomotive engineer from Newcastle around 1830, dark curly hair, high collar, black tailcoat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_liverpool_manchester** – the Liverpool & Manchester Railway (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_liverpool_manchester — 2D game asset, a head-and-shoulders portrait of a railway company director around 1830, top hat, dark green tailcoat, side whiskers, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_brunel** – Isambard Kingdom Brunel (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_brunel — 2D game asset, a head-and-shoulders portrait of a short energetic engineer around 1840, tall stovepipe hat, cigar, dark frock coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_hetton_colliery** – the Hetton colliery (Epoche 8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_hetton_colliery — 2D game asset, a head-and-shoulders portrait of a colliery viewer around 1825, sturdy northern man, flat cap, waistcoat, coal-dusted hands, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_nasmyth** – James Nasmyth of Patricroft (Epoche 9–10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_nasmyth — 2D game asset, a head-and-shoulders portrait of a Scottish engineer around 1845, broad face, bushy dark beard, dark frock coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_great_western_ss** – the Great Western Steamship Company (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_great_western_ss — 2D game asset, a head-and-shoulders portrait of a steamship company director around 1843, mutton-chop whiskers, black frock coat, top hat in hand, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_admiralty_steam** – the Admiralty (Epoche 9–10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_admiralty_steam — 2D game asset, a head-and-shoulders portrait of a Royal Navy captain around 1845, dark blue frock coat with gold epaulettes, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_britannia_bridge** – the Britannia Bridge works (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_britannia_bridge — 2D game asset, a head-and-shoulders portrait of a bridge works resident engineer around 1848, top hat, plaid waistcoat, holding riveting plans, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_crystal_palace** – Fox, Henderson & Co. (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_crystal_palace — 2D game asset, a head-and-shoulders portrait of a building contractor around 1851, prosperous, top hat, grey frock coat, a drawing of a glass-and-iron hall, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_john_brown** – John Brown & Co. of Sheffield (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_john_brown — 2D game asset, a head-and-shoulders portrait of a Sheffield steel magnate around 1865, grey beard, black frock coat, gold watch chain, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_armstrong_elswick** – Armstrong's ordnance works at Elswick (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_armstrong_elswick — 2D game asset, a head-and-shoulders portrait of an ordnance manufacturer around 1865, white side whiskers, dark frock coat, stern expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_midland_railway** – the Midland Railway (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_midland_railway — 2D game asset, a head-and-shoulders portrait of a railway general manager around 1868, full beard, black frock coat, railway pocket watch, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_white_star** – the White Star Line (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_white_star — 2D game asset, a head-and-shoulders portrait of a shipping line owner around 1870, neat beard, dark double-breasted coat, a ship model behind him, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_hornsby** – Hornsby the agricultural engineers (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter
```
portrait_hornsby — 2D game asset, a head-and-shoulders portrait of an agricultural engineer around 1865, ruddy face, tweed jacket, bowler hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

**portrait_coventry_machinists** – the Coventry Machinists Company (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_coventry_machinists — 2D game asset, a head-and-shoulders portrait of a young bicycle maker around 1870, moustache, waistcoat with rolled sleeves, flat cap, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow
```

## G · Oberfläche, Symbole, Store

Spieltitel und Schriften kommen aus Schriftarten (kein Bild nötig); Glühskala, Fortschritt und Partikel zeichnet das Spiel selbst.

**panel_parchment** – Pergament mit Messingecken (alle Fenster) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 30 Wörter
```
panel_parchment — 2D game asset, UI panel frame, aged 18th-century parchment paper texture, worn burned edges, brass metal corner protectors, georgian style craftsmanship, clean flat view, high detail, isolated on black background --ar 1:1 --no shadows, text, numbers, watermark
```

**buttons_leather_brass** – Leder-Messing-Knöpfe (alle Knöpfe) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 24 Wörter
```
buttons_leather_brass — Set of 4 game UI buttons, 18th-century georgian style, polished brass with dark leather inlay, blank rectangular icons, flat design, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**frame_wood_iron** – Holzrahmen mit Eisenplatte (Status- und Navigationsleiste) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 31 Wörter
```
frame_wood_iron — 2D UI window frame, 18th-century forge workshop style, dark oak wood frame with brass rivets and iron fittings, game interface panel, front view, orthographic projection, clean edges, isolated on white background --ar 1:1 --no 3d perspective, text, numbers, watermark, border, shadow
```

**button_ember** – Glut-Knopf HAMMERN · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 32 Wörter
```
button_ember — 2D game UI button, forged dark iron plate with glowing orange ember cracks, heavy brass border, a hammer-and-gear symbol in the middle, industrial 18th-century style, flat orthographic view, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**ledger_page** – Auftragsbuch-Seite · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Portrait 3:4** · 77 Wörter
```
ledger_page — 2D game asset, a single page of an 18th-century leather-bound ledger book seen from directly above, aged cream parchment with faint brown ruled lines and soft stains, completely empty page, the dark brown leather binding and a few page edges visible along the left side, small brass corner fittings on the right corners, a red ribbon bookmark hanging out at the bottom, hand-painted 2D game art, dark ink outlines, soft even lighting, on pure flat white background --ar 3:4 --no writing, numbers, cast shadow, text, watermark, border, shadow
```

**coin_pouch** – Münzbeutel (Geldanzeige) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 24 Wörter
```
coin_pouch — 2D game asset icon, 18th-century leather coin pouch tied with string, filled with old British silver shillings and copper pence, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**coins** – Münzen George III: Guinee, Shilling, Halfpenny · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 27 Wörter
```
coins — Set of 3 antique British coins of George III, one gold guinea, one silver shilling, one copper halfpenny, game item icons, top-down view, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**coins_victoria** – Münzen Victoria: Sovereign, Shilling, Penny (für Epoche 9–10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 39 Wörter
```
coins_victoria — Set of 3 antique British coins of Queen Victoria from the 1850s, one gold sovereign, one silver shilling, one bronze penny, game item icons, top-down view, crisp hand-painted 2D game art, thin dark outlines, on pure flat white background --ar 1:1 --no text other than the coin legends, text, numbers, watermark, border, shadow
```

**wax_seals** – Wachssiegel George III und Admiralität · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 32 Wörter
```
wax_seals — Set of red wax seals with royal stamp emblems: one with the royal cipher of King George III, one with the anchor of the Admiralty, game badge icons, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**seal_victoria** – Wachssiegel Victoria (Meilensteine ab Epoche 9) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 26 Wörter  
*Trägt die falsche Jahreszahl „1775“ (Victoria regierte ab 1837).*
```
seal_victoria — Red wax seal with the royal cipher of Queen Victoria (VR) and a crown, game badge icon, hand-painted 2D game art, on pure flat white background --ar 1:1 --no date, year, text, numbers, watermark, border, shadow
```

**pointer_sheet** – Pyrometer-Zeiger · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 17 Wörter
```
pointer_sheet — 2D game asset, antique brass indicator needle, fine clockwork pointer, ornate georgian style, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**pyrometer_dial** – Pyrometer-Zifferblatt ohne Zeiger · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 40 Wörter
```
pyrometer_dial — 2D game asset, an 18th-century brass pyrometer temperature gauge seen exactly from the front, a semicircular arc scale with engraved tick marks, antique clockwork style, dark iron base, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no needle, pointer, numbers, text, watermark, border, shadow
```

**stars** – Sterne für die Bewertung (voll und leer) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 36 Wörter
```
stars — 2D game UI icons, two five-pointed stars side by side: one polished gold star with a brass rim, one empty dark iron star outline, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**hourglass** – Sanduhr (Eilaufträge) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 27 Wörter
```
hourglass — 2D game UI icon, an 18th-century brass and wood hourglass with golden sand, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow
```

**trough** – Löschtrog (ab Epoche 4) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 53 Wörter
```
trough — 2D game asset, a wooden quench trough for a blacksmith: a long rectangular oak tub bound with iron bands, filled with dark water whose surface is visible, standing on two short trestles, shown in a straight front view slightly from above, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 2:1 --no steam, tools, text, numbers, watermark, border, shadow
```

**app_icon** – App-Icon · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 64 Wörter
```
app_icon — Square 1:1 mobile game app icon, a heavy blacksmith's hammer striking a glowing orange-hot horseshoe on the face of a dark iron anvil, a burst of bright sparks, warm firelight against a deep dark brown background, bold simple shapes and strong contrast that stay readable at very small size, hand-painted 2D game art, dark ink outlines, subject centred and filling most of the square --ar 1:1 --no text, letters, border, rounded corners, numbers, watermark
```

**store_banner** – Store-Banner (Google Play 1024 × 500) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Landscape 2:1** · 69 Wörter
```
store_banner — Wide 2:1 banner illustration for a mobile game, interior of an 18th-century English smithy at night lit only by forge fire, on the right half a blacksmith's anvil with a glowing horseshoe and a raised hammer with sparks flying, a brick forge glowing in the background, the left half is calm, dark and empty for a title to be added later, hand-painted 2D game art, dark ink outlines, painterly --ar 2:1 --no people, text, letters, numbers, watermark
```

