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
| 🟠 von Midjourney vorhanden – sollte noch verändert werden | 1 |
| 🟡 von Gemini vorhanden – durch Midjourney ersetzen | 43 |
| ⬜ noch nicht vorhanden | 81 |
| ⬜ noch nicht vorhanden (optional) | 62 |

| Bereich | ✅ gut | 🟠 ändern | 🟡 Gemini | ⬜ fehlt | ⬜ optional |
|---|---|---|---|---|---|
| A · Werkstatt-Hintergründe | 0 | 1 | 6 | 3 | 0 |
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

## Regeln für alle Bilder

- Freigestellt auf **reinem Weiß**, ohne Schatten, ohne Text, ohne Jahreszahlen, ohne Wasserzeichen.
- Objekt vollständig im Bild mit etwas Rand.
- Dateiname = die fett gedruckte ID (z. B. `door_hinge.webp`); Format egal (webp, png, jpg).
- Einheitlicher Stil: handgemalt, dünne dunkle Tuschekontur, warme Malstruktur.
- Midjourney: Prompt komplett kopieren (inkl. `--ar` und `--no`). Bei Bedarf `--v 7` bzw. `--style raw` anhängen.
- Für einheitlichen Stil: ein gelungenes Bild als Stil-Referenz verwenden (`--sref <Bild-URL>`).

## Reihenfolge (was am meisten bringt)

1. **Essen in Frontalansicht** (B) – sieht man ständig.
2. **Hintergründe 7–10** (A) und **Dampfhammer-Teile** (D).
3. **Werkstücke** epochenweise (E), dann **Löschtrog** (G).
4. Optional: Porträts (F), Ladenbilder, Victoria-Münzen, Sterne, Sanduhr, Pyrometer-Zifferblatt.
5. Dann: alle 🟠 Midjourney-Bilder mit Hinweis nachbessern, später alle 🟡 Gemini-Bilder ersetzen (gleiche Dateinamen).

## A · Werkstatt-Hintergründe (9:16 hochkant)

Esse, Amboss und Maschinen stellt das Spiel davor – der Raum bleibt leer. Wand-Boden-Kante bei etwa 40 % der Höhe, unteres Drittel ruhig und dunkel (Bedienelemente).

**Midjourney-Tipps:** Midjourney setzt die Wand gern zu tief an. Am zuverlässigsten hilft ein **Bild-Prompt für den Bildaufbau**: einen vorhandenen Hintergrund (z. B. `background_5`) als Bild vor den Prompt setzen und `--iw 0.5` anhängen – dann übernimmt Midjourney die Aufteilung Wand/Boden. Für den einheitlichen Look ein gelungenes Midjourney-Bild als `--sref` verwenden. Die Wand-Boden-Kante messe ich bei jedem Bild aus.

**background_1** – Die Dorfschmiede (1700–1715) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of a small half-timbered English village smithy around 1700, seen from a high viewpoint. The back wall: timber frame with whitewashed wattle-and-daub panels, rough oak beams along the top. The floor comes towards the viewer: packed earth with straw and soot. A small window high on the back wall in the upper left corner shows green English countryside with a hedge and a distant church tower. On the far right edge a wooden rack with tongs, and a few horseshoes nailed to a beam. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_2** – Kutschen & Handelswege (1715–1735) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of a roadside smithy on an English coaching road around 1725, seen from a high viewpoint. The back wall: rough grey stone wall with heavy timber ceiling beams. The floor comes towards the viewer: worn stone flagstones. A small window high on the back wall in the upper left corner shows a dirt coaching road with a milestone and a distant stagecoach. On the far left edge a spare coach wheel leans against the wall; on the far right edge harness and iron hoops hang on wooden pegs. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_3** – Hafen & Royal Navy (1735–1750) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of a harbour smithy in an English naval dockyard around 1740, seen from a high viewpoint. The back wall: weathered red brick with tarred timber beams. The floor comes towards the viewer: tarred wooden planks. A small window high on the back wall in the upper left corner shows the masts and furled sails of a Royal Navy ship of the line in the harbour. On the far left edge a wooden barrel; on the far right edge coils of rope and a length of heavy chain hang from iron hooks. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_4** – Stahl & Tuch (1750–1765) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of a smith's and cutler's workshop in Sheffield around 1755, seen from a high viewpoint. The back wall: soot-darkened brick. The floor comes towards the viewer: worn stone slabs. A small window high on the back wall in the upper left corner shows Sheffield rooftops with many smoking brick chimneys under a grey sky. On the far left edge bolts of dyed woollen cloth (dark red, indigo, ochre) are stacked; on the far right edge a wooden shelf holds knife blades and files. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_5** – Das Zeitalter des Dampfes (1765–1785) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of the forge of a water-powered hammer works in the Severn Gorge around 1780, seen from a high viewpoint. The back wall: high brick wall with heavy oak beams. The floor comes towards the viewer: wet stone floor with small puddles. A small window high on the back wall in the upper left corner shows the cast-iron arch of the Iron Bridge over the river Severn in a wooded gorge. The right third of the room is left open and empty, because a large machine will be placed there later. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_6** – Das Zeitalter der Eisenwerke (1785–1800) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of the smithy of a large English ironworks around 1790, seen from a high viewpoint. The back wall: tall dark brick wall with two cast-iron columns. The floor comes towards the viewer: cast-iron floor plates with coke dust. A window high on the back wall in the upper left corner shows glowing blast furnaces and smoking chimneys of an ironworks at dusk. The right third of the room is left open and empty, because a steam engine will be placed there later. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_7** – Krieg & Erfindergeist (1800–1820) · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
*Fenster sitzt ganz oben und wird zur Hälfte von der Statusleiste verdeckt; Wand-Boden-Kante bei 49 % (Ziel 40 %). Im Spiel nutzbar.*
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of a London engineering smithy in Lambeth around 1810, seen from a high viewpoint. The back wall: smoke-blackened yellow London stock brick with a heavy timber lintel. The floor comes towards the viewer: worn York stone flags with iron filings. A window high on the back wall in the upper left corner shows the river Thames with sailing barges and the dome of St Paul's in the haze. On the far right edge a wooden rack with iron templates and gauges; on the far left edge a stack of iron bars. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_8** – Eisenbahnfieber (1820–1839) · ⬜ noch nicht vorhanden
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of a locomotive smithy in Newcastle upon Tyne around 1830, seen from a high viewpoint. The back wall: dark red brick with tall bricked-up arched openings and iron tie rods with round anchor plates. The floor comes towards the viewer: packed cinders and iron plates. A window high on the back wall in the upper left corner shows an early steam locomotive with a tall chimney pulling coal wagons on a track. On the far right edge locomotive wheels and tyres lean against the wall; on the far left edge a stack of coupling chains. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_9** – Der Dampfhammer (1839–1860) · ⬜ noch nicht vorhanden
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of the forge shop of a great engineering foundry around 1845, seen from a high viewpoint. The back wall: tall soot-stained brick wall with cast-iron columns and a row of high round-arched windows. The floor comes towards the viewer: heavy cast-iron floor plates and scale. A window high on the back wall in the upper left corner shows a canal with a narrowboat and the chimneys of a foundry. The right third of the room is left open and empty, because a large steam hammer will be placed there later. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

**background_10** – Das Stahlzeitalter (1860–1880) · ⬜ noch nicht vorhanden
```
Vertical 9:16 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills only the top 40 percent of the image and meets the floor at 40 percent of the image height, a large empty floor fills the lower 60 percent, the top 10 percent of the image shows only dark ceiling beams and the window sits just below them. Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. Interior of a Sheffield steelworks forge around 1870, seen from a high viewpoint. The back wall: very tall dark brick wall with iron roof trusses and a travelling crane rail along the top. The floor comes towards the viewer: cast-iron floor plates with steel scale. A window high on the back wall in the upper left corner shows Bessemer converters blowing a shower of sparks into the night. The right third of the room is left open and empty, because a very large steam hammer will be placed there later. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge --ar 9:16 --no forge, hearth, fire, anvil, machine, tools in the centre, people, animals, text, watermark, letters, numbers, date, signature, black bars, letterbox, border
```

## B · Essen (Frontalansicht, alle sechs Stufen)

Frontal und symmetrisch, leicht von oben: Das Glutbett ist ein waagerechter Streifen über etwa 60 % der Breite, damit die Werkstücke gleichmäßig nebeneinander liegen. Blasebalg bzw. Gebläse immer links. Die bisherigen Schrägansichten (Stufe 1–4) werden ersetzt.

**forge_clay** – Lehm-Esse mit Handblasebalg (Stufe 1, Epoche 1) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
*Schrägansicht – neu als Frontalansicht (Prompt unten).*
```
2D game asset, a small rustic early-18th-century village forge: a low hearth of clay and rough fieldstones, a simple clay-plastered hood with a short chimney, a leather hand bellows on a wooden stand at the left side with its nozzle pointing into the hearth, orange glowing charcoal fire, shown in a straight front view (symmetrical, orthographic), seen from slightly above so that the glowing fire bed on top of the hearth is visible as a wide horizontal band across the middle of the hearth, the fire bed takes up about 60 % of the forge's width, the hood and chimney are centred above the fire bed and shown completely inside the image, the bottom edge of the hearth is straight and level, hand-painted 2D game art with dark ink outlines and warm painterly textures, nothing in front of the hearth, isolated on pure flat white background --ar 2:1 --no perspective distortion, three-quarter view, floor, ground patch, smoke, sparks, flames rising above the coals, people, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**forge_brick** – Ziegel-Esse (Stufe 2, Epoche 2) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
*Schrägansicht – neu als Frontalansicht (Prompt unten).*
```
2D game asset, a red brick smith's hearth of the 1720s with a brick hood and a square brick chimney, bound with iron straps, a leather bellows at the left side with its nozzle pointing into the hearth, bright orange coal fire, shown in a straight front view (symmetrical, orthographic), seen from slightly above so that the glowing fire bed on top of the hearth is visible as a wide horizontal band across the middle of the hearth, the fire bed takes up about 60 % of the forge's width, the hood and chimney are centred above the fire bed and shown completely inside the image, the bottom edge of the hearth is straight and level, hand-painted 2D game art with dark ink outlines and warm painterly textures, nothing in front of the hearth, isolated on pure flat white background --ar 2:1 --no perspective distortion, three-quarter view, floor, ground patch, smoke, sparks, flames rising above the coals, people, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**forge_double_bellows** – Esse mit Doppelblasebalg (Stufe 3, Epoche 3) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
*Schrägansicht – neu als Frontalansicht (Prompt unten).*
```
2D game asset, a large brick and stone smith's hearth of the 1740s with a wide brick hood bound with iron bands, two large leather bellows stacked at the left side worked by one wooden lever, hot yellow-orange coal fire, shown in a straight front view (symmetrical, orthographic), seen from slightly above so that the glowing fire bed on top of the hearth is visible as a wide horizontal band across the middle of the hearth, the fire bed takes up about 60 % of the forge's width, the hood and chimney are centred above the fire bed and shown completely inside the image, the bottom edge of the hearth is straight and level, hand-painted 2D game art with dark ink outlines and warm painterly textures, nothing in front of the hearth, isolated on pure flat white background --ar 2:1 --no perspective distortion, three-quarter view, floor, ground patch, smoke, sparks, flames rising above the coals, people, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**forge_coke** – Koks-Esse mit Zylindergebläse (Stufe 4, Epoche 5) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
*Schrägansicht – neu als Frontalansicht (Prompt unten).*
```
2D game asset, a long late-18th-century coke-fired smith's hearth of cast-iron plates and firebrick with a riveted iron hood and a round iron chimney, a cast-iron blowing cylinder with an air pipe at the left side, brilliant yellow-white coke fire, shown in a straight front view (symmetrical, orthographic), seen from slightly above so that the glowing fire bed on top of the hearth is visible as a wide horizontal band across the middle of the hearth, the fire bed takes up about 60 % of the forge's width, the hood and chimney are centred above the fire bed and shown completely inside the image, the bottom edge of the hearth is straight and level, hand-painted 2D game art with dark ink outlines and warm painterly textures, nothing in front of the hearth, isolated on pure flat white background --ar 2:1 --no perspective distortion, three-quarter view, floor, ground patch, smoke, sparks, flames rising above the coals, people, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**forge_welding_furnace** – Schweißofen (Stufe 5, Epoche 8) · ⬜ noch nicht vorhanden
```
2D game asset, a long 1830s coal-fired welding furnace: a low hearth of firebrick and cast-iron plates bound by iron tie bars, a low brick arch over a long white-hot coal bed, a short square brick chimney, shown in a straight front view (symmetrical, orthographic), seen from slightly above so that the glowing fire bed on top of the hearth is visible as a wide horizontal band across the middle of the hearth, the fire bed takes up about 60 % of the forge's width, the hood and chimney are centred above the fire bed and shown completely inside the image, the bottom edge of the hearth is straight and level, hand-painted 2D game art with dark ink outlines and warm painterly textures, nothing in front of the hearth, isolated on pure flat white background --ar 2:1 --no perspective distortion, three-quarter view, floor, ground patch, smoke, sparks, flames rising above the coals, people, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**forge_siemens** – Siemens-Gasofen (Stufe 6, Epoche 10) · ⬜ noch nicht vorhanden
```
2D game asset, a massive 1870s Siemens regenerative gas furnace: a rectangular firebrick body clad with riveted iron plates and vertical iron buckstays, a wide open working front showing a blinding white-hot hearth, gas pipes with valves at both sides, a squat iron chimney stub, shown in a straight front view (symmetrical, orthographic), seen from slightly above so that the glowing fire bed on top of the hearth is visible as a wide horizontal band across the middle of the hearth, the fire bed takes up about 60 % of the forge's width, the hood and chimney are centred above the fire bed and shown completely inside the image, the bottom edge of the hearth is straight and level, hand-painted 2D game art with dark ink outlines and warm painterly textures, nothing in front of the hearth, isolated on pure flat white background --ar 2:1 --no perspective distortion, three-quarter view, floor, ground patch, smoke, sparks, flames rising above the coals, people, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

## C · Amboss und Hämmer

Hämmer in reiner Seitenansicht: Kopf links senkrecht, Bahn unten, Stiel waagerecht nach rechts.

**anvil** – Amboss auf Eichenklotz (alle Epochen) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game sprite asset, heavy 18th-century cast iron anvil mounted on a thick oak wood stump, blacksmith equipment, side-view orthographic perspective, horn pointing to the right, crisp clean edges, isolated on white background, game art --ar 1:1 --no text, letters, numbers, date, signature, watermark, sticker border, outline frame, drop shadow, ground shadow
```

**hammer_hand** – Handhammer (Stufe 1) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a simple 18th-century blacksmith's hand hammer shown in a perfectly flat side view (orthographic profile), the plain forged iron head stands upright on the left: flat striking face pointing straight down, short rounded back pointing straight up, the straight ash-wood handle goes through the middle of the head and points horizontally to the right, matte dark iron with hammer marks, the whole hammer is level and not tilted, hand-painted 2D game art with a thin dark ink outline, the whole object fully inside the frame with a margin, isolated on pure flat white background --ar 2:1 --no perspective, three-quarter view, engraving, text, numbers, cast shadow, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**hammer_cross_peen** – Kreuzschlaghammer (Stufe 2) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, an 18th-century cast iron cross-peen blacksmith's hammer shown in a perfectly flat side view (orthographic profile), the head stands upright on the left: square flat striking face pointing straight down, the back of the head tapers to a wedge-shaped cross peen pointing straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, dark cast iron with slight rust, the whole hammer is level and not tilted, hand-painted 2D game art with a thin dark ink outline, the whole object fully inside the frame with a margin, isolated on pure flat white background --ar 2:1 --no perspective, three-quarter view, engraving, text, numbers, cast shadow, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**hammer_steel_faced** – Hammer mit verstählter Bahn (Stufe 3) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, an 18th-century blacksmith's hammer with a steel-faced head shown in a perfectly flat side view (orthographic profile), the head stands upright on the left: dark wrought iron body with a bright polished steel striking face forge-welded onto the bottom, a visible weld line between iron and steel, the striking face points straight down, a wedge-shaped peen points straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, the whole hammer is level and not tilted, hand-painted 2D game art with a thin dark ink outline, the whole object fully inside the frame with a margin, isolated on pure flat white background --ar 2:1 --no perspective, three-quarter view, engraving, text, numbers, cast shadow, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**hammer_crucible** – Gussstahl-Hammer / Tiegelstahl (Stufe 4) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a high-quality late-18th-century crucible steel blacksmith's hammer shown in a perfectly flat side view (orthographic profile), the polished bright steel head stands upright on the left: flat striking face pointing straight down, short flat back pointing straight up, a decorated brass ferrule where the head meets the handle, the straight dark walnut handle points horizontally to the right and ends in a small brass end cap, the whole hammer is level and not tilted, hand-painted 2D game art with a thin dark ink outline, the whole object fully inside the frame with a margin, isolated on pure flat white background --ar 2:1 --no perspective, three-quarter view, engraving, text, numbers, cast shadow, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

## D · Maschinen (Einzelteile für die Animation)

Drehteile genau von vorn und kreisrund, Mittelpunkt = Bildmitte; bewegliche Teile einzeln.

**water_wheel** – Wasserrad (Wasser-Schwanzhammer, Epoche 5) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single wooden undershot water wheel seen exactly from the side so that it is a perfect circle, eight straight spokes, wooden paddles all around the rim, iron bands and an iron axle hub exactly in the centre of the image, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no water, frame, stand, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**helve_beam** – Hammerbalken mit Hammerkopf (Epoche 5–8) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single helve-hammer beam seen exactly from the side: a long heavy oak beam lying horizontally, bound with iron hoops, a round iron pivot boss with a hole at one third from the left end, a heavy forged iron hammer head fixed at the right end pointing straight down, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no frame, posts, anvil, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**helve_frame** – Gestell mit Daumenwelle · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, the wooden support frame of an 18th-century helve hammer seen exactly from the side: two heavy upright oak posts joined by cross beams, an iron bearing on top of the posts for a pivot, and a horizontal cam shaft with four iron cams at the bottom, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no hammer beam, water wheel, anvil, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**flywheel** – Schwungrad (Dampf-Schwanzhammer, Epoche 6–8) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single cast-iron flywheel of an 18th-century beam engine seen exactly from the front so that it is a perfect circle, six gently curved spokes, a heavy rim, the hub exactly in the centre of the image, hand-painted 2D game art with dark ink outlines, dark iron, isolated on pure flat white background --ar 1:1 --no frame, shaft stand, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**engine_body** – Dampfmaschine ohne Balancier und Schwungrad · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, the body of a Boulton and Watt style beam engine around 1785 seen from the side: a tall vertical cast-iron steam cylinder with a piston rod sticking out of the top, a brick and timber engine bed, a tall cast-iron column on the right that would carry a beam, pipes and valve gear, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no rocking beam, flywheel, smoke, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**engine_beam** – Balancier · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single cast-iron rocking beam of an 18th-century beam engine seen from the side: long horizontal beam, thicker in the middle and tapering to both ends, an open lattice pattern, a round pivot hole exactly in the centre and connection eyes at both ends, hand-painted 2D game art with dark ink outlines, dark iron, isolated on pure flat white background --ar 1:1 --no column, engine, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**steam_hammer_frame** – Dampfhammer: Gestell (Epoche 9) · ⬜ noch nicht vorhanden
```
2D game asset, the frame of an 1840s Nasmyth steam hammer seen exactly from the front (orthographic): two tall cast-iron standards shaped like an inverted V on each side, joined at the top by a heavy cross beam that carries a vertical steam cylinder with flanges and a valve chest, a control lever with a handle on the right standard, a tall empty open gap in the middle between the standards where the hammer moves, hand-painted 2D game art with dark ink outlines, dark iron with rivets and bolts, isolated on pure flat white background --ar 3:4 --no perspective, hammer head, piston rod, anvil, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**steam_hammer_ram** – Dampfhammer: Bär mit Kolbenstange · ⬜ noch nicht vorhanden
```
2D game asset, the moving ram (tup) of an 1840s steam hammer seen exactly from the front (orthographic): a long vertical polished piston rod at the top fixed into a heavy rectangular cast-iron hammer block with guide grooves on both sides and a flat steel die at the very bottom, upright and perfectly vertical, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:2 --no perspective, frame, cylinder, anvil, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**steam_hammer_anvil** – Dampfhammer: Schabotte (Ambossblock) · ⬜ noch nicht vorhanden
```
2D game asset, the anvil block (schabotte) of an 1840s steam hammer seen exactly from the front (orthographic): a massive squat cast-iron block, wider at the base, with a flat steel die on top held by a dovetail and wedges, set on heavy oak timbers, hand-painted 2D game art with dark ink outlines, dark iron, isolated on pure flat white background --ar 3:2 --no perspective, hammer, frame, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**steam_hammer_large_frame** – Gestell des großen Dampfhammers (Epoche 10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, the frame of a huge 1870s double-standard steam hammer seen exactly from the front (orthographic): two massive riveted wrought-iron standards forming an arch, a large steam cylinder on top with pipes and valve gear, a platform with railing for the hammer driver, a tall empty open gap in the middle where the hammer moves, hand-painted 2D game art with dark ink outlines, dark iron with rivets, isolated on pure flat white background --ar 3:4 --no perspective, hammer head, piston rod, anvil, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**Ladenbilder der Maschinen** (ganze Maschine als ein Bild, nur für den Laden)

**machine_water_helve** – Wasser-Schwanzhammer (Ladenbild) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, an 18th-century water-powered helve hammer: a wooden undershot water wheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on a wooden stump on the right, side view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**machine_steam_helve** – Dampf-Schwanzhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a 1790s steam-powered helve hammer: a small beam engine with a flywheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on the right, side view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**machine_nasmyth** – Nasmyth-Dampfhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, an 1840s Nasmyth steam hammer: two cast-iron standards, a steam cylinder on top, the hammer block hanging above a massive anvil block, a control lever, front view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**machine_great_steam_hammer** – Großer Dampfhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a huge 1870s steam hammer with riveted wrought-iron arch standards, a large cylinder, a platform for the driver and a massive anvil block, front view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

## E · Werkstücke (Rohling + 80)

Kalt, nur Metall (kein Holz), von oben, weißer Hintergrund ohne Schatten, quadratisch. Die Glut färbt das Spiel ein.

**blank** – Rohling (alle Epochen) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single piece of rectangular wrought iron bar stock, about eight times as long as it is wide, square cross-section, both ends roughly cut, horizontal from left to right, dark grey unheated wrought iron with mill scale, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 1 – Die Dorfschmiede (1700–1715)

**nail** – Nagel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single large hand-forged nail with a square tapering shank ending in a sharp point and a faceted hammered rosehead, horizontal with the head on the left, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**horseshoe** – Hufeisen · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single hand-forged horseshoe with a fullered groove and eight square nail holes, opening pointing down, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**hook** – Haken · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single hand-forged S-shaped hanging hook made from round bar, pointed tip on the lower curve, small curled scroll on the upper end, upright, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**door_hinge** – Türangel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single hand-forged strap hinge for a cottage door: long flat tapering iron strap with three round nail holes, a rolled eye at the left end and a spade-shaped decorative tip at the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**sickle** – Sichel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single hand-forged sickle blade without handle: wide crescent-shaped thin steel blade with a smooth ground inner edge and a short pointed bare tang on the left, dark grey unheated forged steel with a slightly brighter ground edge, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**ploughshare** – Pflugschar · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single hand-forged ploughshare: flat, slightly curved triangular iron blade with a sharp point on the right and a short socket with two bolt holes on the left, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**fire_poker** – Schürhaken · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single hand-forged fireplace poker: long round iron bar with a small hooked side spur at the tip, a twisted section near the handle and a closed ring loop as handle, horizontal with the tip on the right, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**gate_latch** – Torriegel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single hand-forged gate latch: flat iron latch bar with a curled thumb lever at one end and a small decorative scrolled back plate with two nail holes, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 2 – Kutschen & Handelswege (1715–1735)

**wheel_tyre** – Radreifen · ⬜ noch nicht vorhanden
```
2D game asset, a single forged iron wheel tyre: one flat iron hoop forming a perfect circle seen from directly above, narrow uniform band, a visible forge-welded joint, empty in the middle, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**coach_axle** – Kutschachse · ⬜ noch nicht vorhanden
```
2D game asset, a single forged coach axle: straight thick square iron bar with a round tapered axle arm at each end and a raised collar where each arm begins, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**coach_fitting** – Kutschbeschlag · ⬜ noch nicht vorhanden
```
2D game asset, a single forged coach body fitting: flat iron stay bar with elegant scrolled curls at both ends and four countersunk bolt holes, gently curved, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**lantern_bracket** – Laternenhalter · ⬜ noch nicht vorhanden
```
2D game asset, a single hand-forged wall bracket for a hanging lantern: horizontal square-bar arm with a small hook at the right tip, a decorative scroll brace below the arm, and a flat wall plate with two nail holes on the left, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**post_horseshoe** – Postpferd-Hufeisen · ⬜ noch nicht vorhanden
```
2D game asset, a single light hand-forged horseshoe for a coach horse: narrow web, deep fullered groove, six nail holes and a small raised toe clip at the front, opening pointing down, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**turnpike_fitting** – Schlagbaumbeschlag · ⬜ noch nicht vorhanden
```
2D game asset, a single heavy forged hinge for a turnpike toll gate: thick flat iron strap with three bolt holes and a large rolled eye at the left end, with an L-shaped iron pintle pin seated in the eye, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**drag_shoe** – Hemmschuh · ⬜ noch nicht vorhanden
```
2D game asset, a single forged drag shoe for a coach wheel: elongated iron skid shaped like a narrow trough, front end curled upwards, a forged ring for the chain at the back, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 3 – Hafen & Royal Navy (1735–1750)

**chain_link** – Kettenglied · ⬜ noch nicht vorhanden
```
2D game asset, a single large forged oval chain link made from thick round bar, a visible forge-weld seam on one long side, empty in the middle, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**anchor_shank** – Ankerschaft · ⬜ noch nicht vorhanden
```
2D game asset, a single forged ship's anchor shank without arms: long thick square iron bar, a forged ring eye at the left end, a thickened square crown block at the right end where the anchor arms would be welded, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**boathook** – Bootshaken · ⬜ noch nicht vorhanden
```
2D game asset, a single forged boathook head without pole: a straight pointed spike on the right with one backward-curving hook beside it, and a conical open socket on the left, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**mooring_ring** – Festmacherring · ⬜ noch nicht vorhanden
```
2D game asset, a single heavy forged mooring ring: thick round-section iron ring, empty in the middle, held by a short U-shaped staple with two pointed spikes at the bottom, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**ship_bolt** – Schiffsbolzen · ⬜ noch nicht vorhanden
```
2D game asset, a single forged ship's bolt: long round iron rod with a domed head at the left end and a narrow slot for a forelock wedge near the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**carriage_fitting** – Lafettenbeschlag · ⬜ noch nicht vorhanden
```
2D game asset, a single forged gun-carriage fitting (cap square): heavy flat iron band bent into a half-round arch in the middle, a hinge eye at the left end and a slotted tab with two bolt holes at the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**rudder_pintle** – Ruderfingerling · ⬜ noch nicht vorhanden
```
2D game asset, a single forged rudder pintle for a sailing ship: long flat iron strap with four bolt holes, at the left end bent into a thick round pin pointing downwards at a right angle, seen from the side, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 4 – Stahl & Tuch (1750–1765)

**spindle** – Spindel · ⬜ noch nicht vorhanden
```
2D game asset, a single forged spindle for a spinning machine: long thin round steel rod tapering to a fine point on the right, with a small round collar near the left end, horizontal, dark grey unheated forged steel, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**cloth_shears** – Tuchschere · ⬜ noch nicht vorhanden
```
2D game asset, a single pair of large forged cloth shears of the spring type: two long straight steel blades joined at the left end by a U-shaped bow spring, blades slightly open, horizontal, dark grey unheated forged steel with slightly brighter ground edges, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, pivot screw, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**knife** – Messerklinge · ⬜ noch nicht vorhanden
```
2D game asset, a single forged knife blade without handle: straight spine, curved sharp edge rising to a point on the right, a narrow bare tang on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**spring** – Feder · ⬜ noch nicht vorhanden
```
2D game asset, a single hand-forged coil spring: steel wire wound into eight even coils with open straight ends, seen from the side, horizontal, dark grey unheated forged steel, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**chisel** – Meißel · ⬜ noch nicht vorhanden
```
2D game asset, a single forged cold chisel: octagonal steel bar, slightly mushroomed striking head on the left, tapering to a sharp ground cutting edge on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**file** – Feile · ⬜ noch nicht vorhanden
```
2D game asset, a single hand-cut file without handle: flat steel bar tapering towards the right, the whole surface covered with fine diagonal cross-hatched teeth, a narrow pointed bare tang on the left, horizontal, dark grey unheated forged steel, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**cargo_chain** – Ladekette · ⬜ noch nicht vorhanden
```
2D game asset, a short forged cargo chain: five interlocking oval links of round bar with a forged cargo hook at the right end, laid out straight and horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**barrel_hoop** – Fassreifen · ⬜ noch nicht vorhanden
```
2D game asset, a single forged barrel hoop: thin flat iron band forming a circle seen from directly above, a small riveted overlap joint, empty in the middle, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 5 – Das Zeitalter des Dampfes (1765–1785)

**piston_rod** – Kolbenstange · ⬜ noch nicht vorhanden
```
2D game asset, a single forged piston rod for a steam engine: long perfectly straight round iron rod, a forged flat crosshead eye at the left end and a tapered end with a cotter slot at the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**valve_part** – Ventilteil · ⬜ noch nicht vorhanden
```
2D game asset, a single forged steam-engine valve: round flat valve disc with a bevelled rim on the left and a straight round valve stem pointing to the right, seen from the side, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**beam_strap** – Balancierbeschlag · ⬜ noch nicht vorhanden
```
2D game asset, a single forged strap for a beam engine: heavy flat iron band bent into a long U-shape lying on its side, with two rectangular cotter slots through both legs near the open end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**lock_fitting** – Schleusenbeschlag · ⬜ noch nicht vorhanden
```
2D game asset, a single forged canal lock-gate fitting: heavy flat iron collar band bent into a rectangular U-shape with two long straight arms, each arm with three bolt holes, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**miners_pick** – Keilhaue · ⬜ noch nicht vorhanden
```
2D game asset, a single forged miner's pick head without handle: slightly curved steel head with one long pointed end on the right, a short blunt poll on the left and an empty oval eye in the middle, horizontal, dark grey unheated forged steel with a slightly brighter point, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**drill_steel** – Bohreisen · ⬜ noch nicht vorhanden
```
2D game asset, a single forged rock drill steel for mining: long octagonal steel bar with a wide chisel-shaped bit on the right and a flat striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter bit, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**conveyor_chain** – Förderkette · ⬜ noch nicht vorhanden
```
2D game asset, a short length of heavy flat-link winding chain for a mine shaft: five flat forged iron plate links connected by round pins, laid out straight and horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**pump_rod** – Pumpengestänge · ⬜ noch nicht vorhanden
```
2D game asset, a single section of forged pump rod for a Cornish mine pump: long square iron rod with a flat forked strap joint and two bolt holes at the left end and a plain square end on the right, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 6 – Das Zeitalter der Eisenwerke (1785–1800)

**boiler_rivet** – Kesselniete · ⬜ noch nicht vorhanden
```
2D game asset, a single large forged boiler rivet: short thick round shank with a domed snap head on the left, seen from the side, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**boiler_plate** – Kesselblech · ⬜ noch nicht vorhanden
```
2D game asset, a single forged wrought iron boiler plate: thick rectangular iron sheet, landscape format, slightly uneven hammered surface, one row of round rivet holes along all four edges, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**rabble** – Puddelkrücke · ⬜ noch nicht vorhanden
```
2D game asset, a single forged puddling rabble: very long round iron rod with a flat rectangular paddle blade bent at a right angle at the right end and a closed loop handle at the left end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**tie_rod** – Zuganker · ⬜ noch nicht vorhanden
```
2D game asset, a single forged building tie rod: long round iron rod with a decorative S-shaped wall anchor plate at the left end and a forged eye at the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**ship_chain** – Ankerkette · ⬜ noch nicht vorhanden
```
2D game asset, a short length of heavy open-link anchor cable: four very large interlocking oval links of thick round bar, without cross studs, laid out straight and horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**lathe_tool** – Drehmeißel · ⬜ noch nicht vorhanden
```
2D game asset, a single forged lathe cutting tool: short square steel bar with a bent, sharply ground hooked cutting tip on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground tip, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**leaf_spring** – Blattfeder · ⬜ noch nicht vorhanden
```
2D game asset, a single forged carriage leaf spring: a stack of five gently curved steel leaves of decreasing length held by a central iron clamp band, rolled eyes at both ends of the longest leaf, seen from the side, horizontal, dark grey unheated forged steel, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**wagon_axle** – Wagenachse · ⬜ noch nicht vorhanden
```
2D game asset, a single heavy forged wagon axle for a horse-drawn plateway wagon: thick straight round iron bar with a raised collar and a short round journal at each end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**large_shaft** – Antriebswelle · ⬜ noch nicht vorhanden
```
2D game asset, a single forged mill drive shaft: very long thick round iron shaft with two square bosses and two raised collars along its length and round journals at both ends, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**crankshaft** – Kurbelwelle · ⬜ noch nicht vorhanden
```
2D game asset, a single forged crankshaft: straight round iron shaft with one single crank throw in the middle, made of two rectangular webs and a round crankpin offset to one side, seen from the side, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 7 – Krieg & Erfindergeist (1800–1820)

**block_pin** – Blockrollen-Bolzen · ⬜ noch nicht vorhanden
```
2D game asset, a single forged pulley-block pin: short thick perfectly straight round iron pin with a slightly domed head on the left and a small hole for a split pin near the right end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**boiler_stay** – Kessel-Stehbolzen · ⬜ noch nicht vorhanden
```
2D game asset, a single forged boiler stay bolt: a long straight round iron rod with a thick upset collar near each end and slightly peened ends, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**gas_lamp_bracket** – Gaslaternen-Ausleger · ⬜ noch nicht vorhanden
```
2D game asset, a single hand-forged wall bracket for a gas street lamp: a horizontal arm of square bar with a decorative twisted section and a large scroll brace underneath, a flat wall plate with four bolt holes on the left and a downward ring at the right tip for the lamp, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**navvy_spade** – Spaten · ⬜ noch nicht vorhanden
```
2D game asset, a single forged navvy's spade blade without wooden handle: a broad flat slightly dished iron blade with a squared cutting edge at the bottom, rolled tread edges at the top and a long tapering open socket strap, upright with the socket pointing up, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**press_screw** – Pressenspindel · ⬜ noch nicht vorhanden
```
2D game asset, a single forged screw spindle for an iron printing press: a thick round iron rod with a coarse square thread twisted along its middle part, a square end for the lever on the left and a round foot on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**bayonet** – Bajonett · ⬜ noch nicht vorhanden
```
2D game asset, a single forged socket bayonet without musket: a long triangular-section steel blade tapering to a sharp point on the right, joined by a short curved neck to a round hollow socket with an L-shaped slot on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**anchor_fluke** – Ankerarm · ⬜ noch nicht vorhanden
```
2D game asset, a single forged anchor arm for a ship's anchor: a thick curved iron arm ending in a broad flat triangular fluke (palm) on the right and a heavy square stump on the left where it is welded to the shank, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**chain_eyebar** – Brückenglied · ⬜ noch nicht vorhanden
```
2D game asset, a single forged suspension bridge eyebar: a long flat wrought iron bar with a thickened round eye with a large hole at each end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 8 – Eisenbahnfieber (1820–1839)

**rail_spike** – Schienennagel · ⬜ noch nicht vorhanden
```
2D game asset, a single forged railway track spike: a long square-section iron shank with a chisel point at the bottom and a hooked offset head at the top, upright, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**coupling_hook** – Kupplungshaken · ⬜ noch nicht vorhanden
```
2D game asset, a single forged railway wagon coupling hook: a heavy curved iron hook with a thick shank and a punched eye at the right end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**safety_valve_lever** – Sicherheitsventil-Hebel · ⬜ noch nicht vorhanden
```
2D game asset, a single forged safety valve lever for a locomotive boiler: a long flat iron lever with a fork and pin hole at the left end, two holes along its length and a rounded end on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**coupling_chain** – Kupplungskette · ⬜ noch nicht vorhanden
```
2D game asset, a short forged railway coupling chain: three heavy oval links of round bar, laid out straight and horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**loco_tyre** – Lokomotiv-Radreifen · ⬜ noch nicht vorhanden
```
2D game asset, a single forged locomotive wheel tyre: a thick iron hoop seen from directly above forming a perfect circle, with a raised flange along the inner edge and a visible forge-welded joint, empty in the middle, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**buffer_spring** – Pufferfeder · ⬜ noch nicht vorhanden
```
2D game asset, a single forged railway buffer spring: a stack of four curved steel leaves held by a central iron band, seen from the side, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**connecting_rod** – Treibstange · ⬜ noch nicht vorhanden
```
2D game asset, a single forged locomotive connecting rod: a long tapered flat iron rod with a large rectangular strap end with a bearing hole on the left and a smaller round eye on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**crank_axle** – Kurbelachse · ⬜ noch nicht vorhanden
```
2D game asset, a single forged locomotive crank axle: a thick straight round iron axle with two offset crank throws in the middle, each made of two rectangular webs and a crank pin, seen from the side, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 9 – Der Dampfhammer (1839–1860)

**bridge_rivet** – Brückenniete · ⬜ noch nicht vorhanden
```
2D game asset, a single large forged bridge rivet: short thick round shank with a domed head, seen from the side, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**palace_bracket** – Säulenkopf-Beschlag · ⬜ noch nicht vorhanden
```
2D game asset, a single forged iron connecting bracket for a glass-and-iron exhibition hall: a flat L-shaped iron plate with a decorative curved gusset and six bolt holes, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**paddle_arm** – Schaufelrad-Arm · ⬜ noch nicht vorhanden
```
2D game asset, a single forged paddle-wheel arm for a paddle steamer: a long flat iron bar with a bolted palm plate at the right end and two bolt holes at the left end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**hammer_die** – Hammergesenk · ⬜ noch nicht vorhanden
```
2D game asset, a single forged steam-hammer die: a heavy rectangular steel block with a dovetail tongue on top and a smooth flat working face at the bottom, seen from the side, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**admiralty_anchor** – Admiralitätsanker · ⬜ noch nicht vorhanden
```
2D game asset, a single forged Admiralty pattern anchor without stock: a long straight shank with a ring at the top and two curved arms with broad triangular flukes at the bottom, upright, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**marine_piston_rod** – Schiffs-Kolbenstange · ⬜ noch nicht vorhanden
```
2D game asset, a single forged marine engine piston rod: a very long perfectly straight round iron rod with a tapered cone end on the left and a forged crosshead block with a hole on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**marine_crank** – Schiffskurbel · ⬜ noch nicht vorhanden
```
2D game asset, a single forged marine engine crank: a heavy flat iron crank arm with a large round boss with a shaft hole at the left end and a smaller boss with a pin hole at the right end, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**propeller_shaft** – Schraubenwelle · ⬜ noch nicht vorhanden
```
2D game asset, a single forged ship's propeller shaft: a very long thick round iron shaft with a flanged coupling disc at the left end and a tapered end with a keyway on the right, horizontal, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

### Epoche 10 – Das Stahlzeitalter (1860–1880)

**velocipede_fork** – Hochrad-Gabel · ⬜ noch nicht vorhanden
```
2D game asset, a single forged front fork of a penny-farthing bicycle: two long slightly curved steel blades joined at the top by a crown with a vertical steering stem, upright, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**steel_axle** – Stahlachse · ⬜ noch nicht vorhanden
```
2D game asset, a single forged railway carriage steel axle: a thick straight round steel bar with raised wheel seats and short round journals at both ends, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**reaper_knife** – Mähmesser · ⬜ noch nicht vorhanden
```
2D game asset, a single forged reaper section knife: a long flat steel bar with a row of riveted triangular cutting sections along its upper edge, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**tunnel_drill** – Tunnelbohrer · ⬜ noch nicht vorhanden
```
2D game asset, a single forged tunnelling drill steel: a long octagonal steel bar with a cross-shaped four-point bit on the right and a collar near the striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**steel_tyre** – Stahl-Radreifen · ⬜ noch nicht vorhanden
```
2D game asset, a single weldless forged steel wheel tyre seen from directly above: a thick perfect steel ring seamless, with a flange along the inner edge, empty in the middle, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**gun_hoop** – Geschützring · ⬜ noch nicht vorhanden
```
2D game asset, a single forged gun hoop for a built-up cannon: a short thick wide iron ring seen at a slight angle from above so its thickness is visible, empty in the middle, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**armour_plate** – Panzerplatte · ⬜ noch nicht vorhanden
```
2D game asset, a single forged armour plate for an ironclad warship: a very thick rectangular wrought iron slab, landscape format, with slightly bevelled edges and a row of bolt holes along the long edges, dark grey unheated wrought iron, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**steel_shaft** – Stahlwelle · ⬜ noch nicht vorhanden
```
2D game asset, a single forged steel intermediate shaft for an ocean liner: a very long thick round steel shaft with a large flanged coupling disc at each end, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th/19th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

## F · Kundenporträts (54)

Die aktuellen Porträts sind noch meine gerenderten (im Spiel vorhanden, aber im alten Stil). Für einen einheitlichen Stil empfehlenswert, aber nicht zwingend.

**portrait_squire** – the squire (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a stout English country squire of about 1710, full-bottomed powdered wig, brown velvet coat, ruddy cheeks, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_vicar** – the vicar (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of an elderly Anglican village vicar of about 1710, black cassock, white preaching bands, small grey wig, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_farmer_hollow** – Farmer Hollow (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a weathered English farmer of about 1710, grey hair tied back, linen smock, broad-brimmed straw hat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_miller_upton** – the miller of Upton (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a cheerful village miller of about 1710, flour-dusted face and clothes, white linen cap, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_landlady_red_lion** – the landlady of the Red Lion (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a sturdy English innkeeper's wife of about 1710, white linen cap, shawl over a laced bodice, warm smile, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_carpenter** – the carpenter (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of an English village carpenter of about 1710, leather apron, rolled sleeves, a pencil behind the ear, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_postmaster_bath** – the postmaster of Bath (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a fashionable postmaster of Bath around 1725, neat tie wig, blue coat with brass buttons, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_coachbuilder_york** – the coachbuilder of York (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a coachbuilder from York around 1725, sturdy man in a waistcoat with rolled sleeves, wood shavings on his shoulder, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_turnpike_trust** – the Turnpike Trust (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a gentleman trustee of a turnpike road around 1725, tricorn hat, grey coat, holding a ledger, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_innkeeper_coaching** – the coaching-inn keeper (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of the portly landlord of a coaching inn around 1725, red waistcoat, white apron, jolly expression, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_carrier_bennett** – Carrier Bennett (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a carrier wagon driver around 1725, weather-beaten face, slouch hat, heavy woollen greatcoat, a whip over his shoulder, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_navy_board** – the Navy Board (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a Navy Board commissioner around 1740, white powdered wig, dark blue coat with gold lace, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_shipwright_portsmouth** – the master shipwright of Portsmouth (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a master shipwright of Portsmouth around 1740, grey hair, plain brown coat, holding a pair of brass dividers, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_merchant_bristol** – a Bristol merchant (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a wealthy Bristol merchant around 1740, powdered wig, rich green silk coat, lace cravat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_harbourmaster** – the harbourmaster (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a harbourmaster around 1740, weathered sailor's face, tricorn hat, dark blue sea coat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_ropewalk_chatham** – the Chatham ropewalk (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of the foreman of the Chatham ropewalk around 1740, strong man with tarred hands, knitted cap, a coil of rope over his shoulder, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_clothier_leeds** – a Leeds clothier (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a prosperous Leeds clothier around 1755, brown wig, plain cloth coat, holding a bolt of dyed wool, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_cutlers_sheffield** – the Sheffield cutlers (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of the Master Cutler of Sheffield around 1755, dignified man with a chain of office over a dark coat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_spinning_master** – the spinning master (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a spinning master around 1760, middle-aged man in shirtsleeves and waistcoat, wisps of cotton on his clothes, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_toolmaker_holt** – toolmaker Holt (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a wiry toolmaker around 1760, spectacles on the nose, leather apron, a file in his hand, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_dockyard_chatham** – Chatham Dockyard (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of the master attendant of Chatham Dockyard around 1760, naval officer, white wig, blue coat with gold buttons, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_boulton_watt** – Boulton & Watt of Soho (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of two engineering partners of Birmingham around 1780 side by side, one stout and cheerful in a fine coat, one thin and thoughtful Scotsman with grey hair, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_mine_cornwall** – a Cornish tin mine (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of the captain of a Cornish tin mine around 1775, rugged face, miner's felt hat with a candle stuck on with clay, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_colliery_wednesbury** – the Wednesbury colliery (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a colliery owner from Wednesbury around 1775, stout man, tall hat, coal dust on his collar, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_canal_company** – the canal company (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a canal company engineer around 1775, surveyor's coat, holding rolled plans, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_ironmaster_coalbrookdale** – the ironmaster of Coalbrookdale (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a Quaker ironmaster of Coalbrookdale around 1779, plain dark Quaker coat, broad-brimmed hat, calm expression, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_wedgwood_etruria** – Josiah Wedgwood of Etruria (Epoche 5) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a master potter of Staffordshire around 1770, dignified man in a brown coat, holding a pale blue jasperware vase, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_mill_owner** – a cotton-mill owner (Epoche 6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a self-made cotton-mill owner around 1790, high collar, brown tailcoat, watch chain, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_plateway_company** – the plateway company (Epoche 6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a tramroad company agent around 1790, top hat, grey tailcoat, holding a measuring rod, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_engine_works** – an engine works (Epoche 6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of an engine-works manager around 1790, sideburns, dark tailcoat, an oil stain on his cuff, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_ironworks_partners** – your ironworks partners (Epoche 6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a well-to-do ironworks partner around 1795, silver hair, black tailcoat, high white cravat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_east_india** – the East India Company (Epoche 6) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of an East India Company director around 1795, powdered wig, rich red coat, gold-headed cane, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_navy_portsmouth** – the Portsmouth block mills (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a naval officer overseeing the Portsmouth block mills around 1805, bicorne hat, blue coat with an epaulette, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_maudslay** – Henry Maudslay of Lambeth (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a broad-shouldered master engineer of London around 1810, kind face, dark coat, holding a brass micrometer, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_telford** – the engineer Thomas Telford (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a Scottish civil engineer around 1815, grey hair, plain dark coat and cravat, rolled bridge drawings, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_gas_light_company** – the Gas Light and Coke Company (Epoche 7) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a gas company director around 1812, top hat, bottle-green tailcoat, a small gas lamp beside him, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_horse_guards** – the Royal Horse Guards (Epoche 7) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a Royal Horse Guards officer around 1815, blue tunic, shining steel helmet with a plume, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_trevithick** – Richard Trevithick (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a tall Cornish engineer around 1805, curly hair, open-necked shirt and waistcoat, energetic expression, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_stockton_darlington** – the Stockton & Darlington Railway (Epoche 8) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a Quaker railway promoter around 1825, plain dark coat, broad-brimmed hat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_stephenson_works** – Robert Stephenson & Co. (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a young locomotive engineer from Newcastle around 1830, dark curly hair, high collar, black tailcoat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_liverpool_manchester** – the Liverpool & Manchester Railway (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a railway company director around 1830, top hat, dark green tailcoat, side whiskers, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_brunel** – Isambard Kingdom Brunel (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a short energetic engineer around 1840, tall stovepipe hat, cigar, dark frock coat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_hetton_colliery** – the Hetton colliery (Epoche 8) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a colliery viewer around 1825, sturdy northern man, flat cap, waistcoat, coal-dusted hands, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_nasmyth** – James Nasmyth of Patricroft (Epoche 9–10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a Scottish engineer around 1845, broad face, bushy dark beard, dark frock coat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_great_western_ss** – the Great Western Steamship Company (Epoche 9) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a steamship company director around 1843, mutton-chop whiskers, black frock coat, top hat in hand, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_admiralty_steam** – the Admiralty (Epoche 9–10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a Royal Navy captain around 1845, dark blue frock coat with gold epaulettes, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_britannia_bridge** – the Britannia Bridge works (Epoche 9) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a bridge works resident engineer around 1848, top hat, plaid waistcoat, holding riveting plans, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_crystal_palace** – Fox, Henderson & Co. (Epoche 9) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a building contractor around 1851, prosperous, top hat, grey frock coat, a drawing of a glass-and-iron hall, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_john_brown** – John Brown & Co. of Sheffield (Epoche 10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a Sheffield steel magnate around 1865, grey beard, black frock coat, gold watch chain, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_armstrong_elswick** – Armstrong's ordnance works at Elswick (Epoche 10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of an ordnance manufacturer around 1865, white side whiskers, dark frock coat, stern expression, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_midland_railway** – the Midland Railway (Epoche 10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a railway general manager around 1868, full beard, black frock coat, railway pocket watch, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_white_star** – the White Star Line (Epoche 10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a shipping line owner around 1870, neat beard, dark double-breasted coat, a ship model behind him, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_hornsby** – Hornsby the agricultural engineers (Epoche 10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of an agricultural engineer around 1865, ruddy face, tweed jacket, bowler hat, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**portrait_coventry_machinists** – the Coventry Machinists Company (Epoche 10) · ⬜ noch nicht vorhanden (optional)
```
2D game asset, a head-and-shoulders portrait of a young bicycle maker around 1870, moustache, waistcoat with rolled sleeves, flat cap, in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, plain dark background inside the frame, isolated on pure flat white background outside the frame --ar 4:5 --no text, name plate, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

## G · Oberfläche, Symbole, Store

Spieltitel und Schriften kommen aus Schriftarten (kein Bild nötig); Glühskala, Fortschritt und Partikel zeichnet das Spiel selbst.

**panel_parchment** – Pergament mit Messingecken (alle Fenster) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, UI panel frame, aged 18th-century parchment paper texture, worn burned edges, brass metal corner protectors, georgian style craftsmanship, clean flat view, high detail, isolated on black background --ar 1:1 --no shadows, text, letters, numbers, date, signature, watermark
```

**buttons_leather_brass** – Leder-Messing-Knöpfe (alle Knöpfe) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Set of 4 game UI buttons, 18th-century georgian style, polished brass with dark leather inlay, blank rectangular icons, flat design, isolated on white background --ar 1:1 --no text, letters, numbers, date, signature, watermark, sticker border, outline frame, drop shadow, ground shadow
```

**frame_wood_iron** – Holzrahmen mit Eisenplatte (Status- und Navigationsleiste) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D UI window frame, 18th-century forge workshop style, dark oak wood frame with brass rivets and iron fittings, game interface panel, front view, orthographic projection, clean edges, isolated on white background --ar 1:1 --no 3d perspective, text, letters, numbers, date, signature, watermark, sticker border, outline frame, drop shadow, ground shadow
```

**button_ember** – Glut-Knopf HAMMERN · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game UI button, forged dark iron plate with glowing orange ember cracks, heavy brass border, a hammer-and-gear symbol in the middle, industrial 18th-century style, flat orthographic view, isolated on white background --ar 1:1 --no text, letters, numbers, date, signature, watermark, sticker border, outline frame, drop shadow, ground shadow
```

**ledger_page** – Auftragsbuch-Seite · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, a single page of an 18th-century leather-bound ledger book seen from directly above, aged cream parchment with faint brown ruled lines and soft stains, completely empty page, the dark brown leather binding and a few page edges visible along the left side, small brass corner fittings on the right corners, a red ribbon bookmark hanging out at the bottom, hand-painted 2D game art with dark ink outlines, soft even lighting, isolated on pure flat white background --ar 3:4 --no writing, numbers, cast shadow, text, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**coin_pouch** – Münzbeutel (Geldanzeige) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset icon, 18th-century leather coin pouch tied with string, filled with old British silver shillings and copper pence, isolated on white background --ar 1:1 --no text, letters, numbers, date, signature, watermark, sticker border, outline frame, drop shadow, ground shadow
```

**coins** – Münzen George III: Guinee, Shilling, Halfpenny · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Set of 3 antique British coins of George III, one gold guinea, one silver shilling, one copper halfpenny, game item icons, top-down view, isolated on white background --ar 1:1 --no text, letters, numbers, date, signature, watermark, sticker border, outline frame, drop shadow, ground shadow
```

**coins_victoria** – Münzen Victoria: Sovereign, Shilling, Penny (für Epoche 9–10) · ⬜ noch nicht vorhanden (optional)
```
Set of 3 antique British coins of Queen Victoria from the 1850s, one gold sovereign, one silver shilling, one bronze penny, game item icons, top-down view, crisp hand-painted 2D game art with thin dark outlines, isolated on pure flat white background --ar 1:1 --no text other than the coin legends, watermark, text, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**wax_seals** – Wachssiegel George III und Admiralität · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Set of red wax seals with royal stamp emblems: one with the royal cipher of King George III, one with the anchor of the Admiralty, game badge icons, isolated on white background --ar 1:1 --no text, letters, numbers, date, signature, watermark, sticker border, outline frame, drop shadow, ground shadow
```

**seal_victoria** – Wachssiegel Victoria (Meilensteine ab Epoche 9) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
*Trägt die falsche Jahreszahl „1775“ (Victoria regierte ab 1837).*
```
Red wax seal with the royal cipher of Queen Victoria (VR) and a crown, game badge icon, hand-painted 2D game art, isolated on pure flat white background --ar 1:1 --no date, year, watermark, text, letters, numbers, signature, sticker border, outline frame, drop shadow, ground shadow
```

**pointer_sheet** – Pyrometer-Zeiger · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
2D game asset, antique brass indicator needle, fine clockwork pointer, ornate georgian style, isolated on white background --ar 1:1 --no text, letters, numbers, date, signature, watermark, sticker border, outline frame, drop shadow, ground shadow
```

**pyrometer_dial** – Pyrometer-Zifferblatt ohne Zeiger · ⬜ noch nicht vorhanden (optional)
```
2D game asset, an 18th-century brass pyrometer temperature gauge seen exactly from the front, a semicircular arc scale with engraved tick marks, antique clockwork style, dark iron base, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no needle, pointer, numbers, text, watermark, letters, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**stars** – Sterne für die Bewertung (voll und leer) · ⬜ noch nicht vorhanden (optional)
```
2D game UI icons, two five-pointed stars side by side: one polished gold star with a brass rim, one empty dark iron star outline, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**hourglass** – Sanduhr (Eilaufträge) · ⬜ noch nicht vorhanden (optional)
```
2D game UI icon, an 18th-century brass and wood hourglass with golden sand, front view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 1:1 --no text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**trough** – Löschtrog (ab Epoche 4) · ⬜ noch nicht vorhanden
```
2D game asset, a wooden quench trough for a blacksmith: a long rectangular oak tub bound with iron bands, filled with dark water whose surface is visible, standing on two short trestles, shown in a straight front view slightly from above, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background --ar 2:1 --no steam, tools, shadow, text, watermark, letters, numbers, date, signature, sticker border, outline frame, drop shadow, ground shadow
```

**app_icon** – App-Icon · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Square 1:1 mobile game app icon, a heavy blacksmith's hammer striking a glowing orange-hot horseshoe on the face of a dark iron anvil, a burst of bright sparks, warm firelight against a deep dark brown background, bold simple shapes and strong contrast that stay readable at very small size, hand-painted 2D game art with dark ink outlines, subject centred and filling most of the square --ar 1:1 --no text, letters, border, rounded corners, watermark, numbers, date, signature
```

**store_banner** – Store-Banner (Google Play 1024 × 500) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen
```
Wide 2:1 banner illustration for a mobile game, interior of an 18th-century English smithy at night lit only by forge fire, on the right half a blacksmith's anvil with a glowing horseshoe and a raised hammer with sparks flying, a brick forge glowing in the background, the left half is calm, dark and empty for a title to be added later, hand-painted 2D game art with dark ink outlines and warm painterly textures --ar 2:1 --no people, text, letters, watermark, numbers, date, signature
```

