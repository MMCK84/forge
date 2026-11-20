# Prompts für die Werkstück-Grafiken

> Das vollständige Heft mit allen Bildern und ihrem Status ist `PROMPTS_Hochformat.md`.

49 Werkstücke (48 Gegenstände + Rohling). Jedes Bild ersetzt im Spiel automatisch das
gerenderte Sprite. Die Glut färbt das Spiel selbst ein (stufenlos nach Temperatur) –
deshalb brauchen wir jedes Stück nur **einmal, kalt**.

Gilt unverändert auch für das Hochformat. Hintergründe, Auftragsbuch, App-Icon und fehlende
Ausrüstung stehen in `PROMPTS_Hochformat.md`.

## Was das Spiel technisch braucht

| Anforderung | Warum |
|---|---|
| **Nur Metall, kein Holz, kein Leder** | Der Glow-Shader färbt das ganze Bild als glühendes Metall – ein Holzstiel würde mitglühen. |
| **Kalt, keine Glut, keine Funken** | Die Glut kommt aus dem Shader; eingemalte Glut wäre bei 20 °C noch sichtbar. |
| **Reines Weiß als Hintergrund, kein Schatten** | Weiß wird automatisch entfernt; ein grauer Schlagschatten bliebe als Fleck stehen. |
| **Ein einzelnes Objekt, mittig, mit Rand** | Das Objekt darf den Bildrand nicht berühren. |
| **Ansicht von oben bzw. flach liegend** | Das Stück liegt in der Esse und auf dem Amboss. |
| **Lange Teile waagerecht** | Passt zum Amboss; das Spiel dreht die Bilder nicht. |
| **Kräftige Hell-Dunkel-Zeichnung** | Farbe geht verloren (Graustufen), Schmiedespuren und Kanten bleiben sichtbar. |
| **Kein Text, keine Jahreszahl, kein Wasserzeichen** | Gemini-Stern unten rechts bitte wegschneiden oder vermeiden. |

Dateiname = ID aus der Liste (z. B. `door_hinge.webp`). Einfach hochladen – ich lege sie unter
`assets/source/user_art/items/` ab, `python tools/art/import_user_art.py` erledigt den Rest.

## Stil-Block (in jedem Prompt enthalten)

Jeder Prompt unten ist vollständig zum Kopieren. Er besteht aus dem Motiv und diesem
gemeinsamen Stil-Block, damit alle 49 Bilder zusammenpassen:

```
… 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

Funktioniert ein Generator mit `--v 6.0` (Midjourney), einfach anhängen. Erzeugt er trotzdem
einen Schatten, hilft oft der Zusatz `isolated cut-out sticker style, no floor`.

---

## Rohling (alle Epochen) – wichtigstes Bild, sieht man bei jedem Auftrag

**blank** – Rohling
```
2D game asset, a single piece of rectangular wrought iron bar stock, about eight times as long as it is wide, square cross-section, both ends roughly cut, horizontal from left to right, dark grey unheated wrought iron with mill scale, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

## Epoche 1 – Die Dorfschmiede (1700–1715)

**nail** – Nagel
```
2D game asset, a single large hand-forged nail with a square tapering shank ending in a sharp point and a faceted hammered rosehead, horizontal with the head on the left, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**hook** – Haken
```
2D game asset, a single hand-forged S-shaped hanging hook made from round bar, pointed tip on the lower curve, small curled scroll on the upper end, upright, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**fire_poker** – Schürhaken
```
2D game asset, a single hand-forged fireplace poker: long round iron bar with a small hooked side spur at the tip, a twisted section near the handle and a closed ring loop as handle, horizontal with the tip on the right, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**door_hinge** – Türangel
```
2D game asset, a single hand-forged strap hinge for a cottage door: long flat tapering iron strap with three round nail holes, a rolled eye at the left end and a spade-shaped decorative tip at the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**gate_latch** – Torriegel
```
2D game asset, a single hand-forged gate latch: flat iron latch bar with a curled thumb lever at one end and a small decorative scrolled back plate with two nail holes, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**horseshoe** – Hufeisen *(schon vorhanden, nur bei Bedarf neu)*
```
2D game asset, a single hand-forged horseshoe with a fullered groove and eight square nail holes, opening pointing down, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**ploughshare** – Pflugschar
```
2D game asset, a single hand-forged ploughshare: flat, slightly curved triangular iron blade with a sharp point on the right and a short socket with two bolt holes on the left, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**sickle** – Sichel
```
2D game asset, a single hand-forged sickle blade without handle: wide crescent-shaped thin steel blade with a smooth ground inner edge and a short pointed bare tang on the left, dark grey unheated forged steel with a slightly brighter ground edge, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

## Epoche 2 – Kutschen & Handelswege (1715–1735)

**coach_axle** – Kutschachse
```
2D game asset, a single forged coach axle: straight thick square iron bar with a round tapered axle arm at each end and a raised collar where each arm begins, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**coach_fitting** – Kutschbeschlag
```
2D game asset, a single forged coach body fitting: flat iron stay bar with elegant scrolled curls at both ends and four countersunk bolt holes, gently curved, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**drag_shoe** – Hemmschuh
```
2D game asset, a single forged drag shoe (wheel skid) for a coach wheel, seen exactly from the side: a flat iron sole as long as a forearm with low side walls, the front end curled upwards like a sleigh runner, a forged ring with a short chain at the back end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**lantern_bracket** – Laternenhalter
```
2D game asset, a single hand-forged wall bracket for a hanging lantern: horizontal square-bar arm with a small hook at the right tip, a decorative scroll brace below the arm, and a flat wall plate with two nail holes on the left, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**post_horseshoe** – Postpferd-Hufeisen
```
2D game asset, a single light hand-forged horseshoe for a coach horse: narrow web, deep fullered groove, six nail holes and a small raised toe clip at the front, opening pointing down, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**turnpike_fitting** – Schlagbaumbeschlag
```
2D game asset, a single heavy forged hinge for a turnpike toll gate: thick flat iron strap with three bolt holes and a large rolled eye at the left end, with an L-shaped iron pintle pin seated in the eye, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**wheel_tyre** – Radreifen
```
2D game asset, a single forged iron wheel tyre: one flat iron hoop forming a perfect circle seen from directly above, narrow uniform band, a visible forge-welded joint, empty in the middle, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

## Epoche 3 – Hafen & Royal Navy (1735–1750)

**anchor_shank** – Ankerschaft
```
2D game asset, a single forged ship's anchor shank without arms: long thick square iron bar, a forged ring eye at the left end, a thickened square crown block at the right end where the anchor arms would be welded, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**boathook** – Bootshaken
```
2D game asset, a single forged boathook head without pole: a straight pointed spike on the right with one backward-curving hook beside it, and a conical open socket on the left, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**carriage_fitting** – Lafettenbeschlag
```
2D game asset, a single forged gun-carriage fitting (cap square): heavy flat iron band bent into a half-round arch in the middle, a hinge eye at the left end and a slotted tab with two bolt holes at the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**chain_link** – Kettenglied
```
2D game asset, a single large forged oval chain link made from thick round bar, a visible forge-weld seam on one long side, empty in the middle, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**mooring_ring** – Festmacherring
```
2D game asset, a single heavy forged mooring ring: thick round-section iron ring, empty in the middle, held by a short U-shaped staple with two pointed spikes at the bottom, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**rudder_pintle** – Ruderfingerling
```
2D game asset, a single forged rudder pintle for a sailing ship: long flat iron strap with four bolt holes, at the left end bent into a thick round pin pointing downwards at a right angle, seen from the side, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**ship_bolt** – Schiffsbolzen
```
2D game asset, a single forged ship's bolt: long round iron rod with a domed head at the left end and a narrow slot for a forelock wedge near the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

## Epoche 4 – Stahl & Tuch (1750–1765)

**barrel_hoop** – Fassreifen
```
2D game asset, a single forged barrel hoop: thin flat iron band forming a circle seen from directly above, a small riveted overlap joint, empty in the middle, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**cargo_chain** – Ladekette
```
2D game asset, a short forged cargo chain: five interlocking oval links of round bar with a forged cargo hook at the right end, laid out straight and horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**chisel** – Meißel
```
2D game asset, a single forged cold chisel: octagonal steel bar, slightly mushroomed striking head on the left, tapering to a sharp ground cutting edge on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**cloth_shears** – Tuchschere
```
2D game asset, a single pair of large forged cloth shears of the spring type: two long straight steel blades joined at the left end by a U-shaped bow spring, no pivot screw, blades slightly open, horizontal, dark grey unheated forged steel with slightly brighter ground edges, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**file** – Feile
```
2D game asset, a single hand-cut file without handle: flat steel bar tapering towards the right, the whole surface covered with fine diagonal cross-hatched teeth, a narrow pointed bare tang on the left, horizontal, dark grey unheated forged steel, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**knife** – Messerklinge
```
2D game asset, a single forged knife blade without handle: straight spine, curved sharp edge rising to a point on the right, a narrow bare tang on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**spindle** – Spindel
```
2D game asset, a single forged spindle for a spinning machine: long thin round steel rod tapering to a fine point on the right, with a small round collar near the left end, horizontal, dark grey unheated forged steel, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**spring** – Feder
```
2D game asset, a single hand-forged coil spring: steel wire wound into eight even coils with open straight ends, seen from the side, horizontal, dark grey unheated forged steel, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

## Epoche 5 – Das Zeitalter des Dampfes (1765–1785)

**beam_strap** – Balancierbeschlag
```
2D game asset, a single forged strap for a beam engine: heavy flat iron band bent into a long U-shape lying on its side, with two rectangular cotter slots through both legs near the open end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**conveyor_chain** – Förderkette
```
2D game asset, a short length of heavy flat-link winding chain for a mine shaft: five flat forged iron plate links connected by round pins, laid out straight and horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**drill_steel** – Bohreisen
```
2D game asset, a single forged rock drill steel for mining: long octagonal steel bar with a wide chisel-shaped bit on the right and a flat striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter bit, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**lock_fitting** – Schleusenbeschlag
```
2D game asset, a single forged canal lock-gate fitting: heavy flat iron collar band bent into a rectangular U-shape with two long straight arms, each arm with three bolt holes, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**miners_pick** – Keilhaue
```
2D game asset, a single forged miner's pick head without handle: slightly curved steel head with one long pointed end on the right, a short blunt poll on the left and an empty oval eye in the middle, horizontal, dark grey unheated forged steel with a slightly brighter point, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**piston_rod** – Kolbenstange
```
2D game asset, a single forged piston rod for a steam engine: long perfectly straight round iron rod, a forged flat crosshead eye at the left end and a tapered end with a cotter slot at the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**pump_rod** – Pumpengestänge
```
2D game asset, a single section of forged pump rod for a Cornish mine pump: long square iron rod with a flat forked strap joint and two bolt holes at the left end and a plain square end on the right, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**valve_part** – Ventilteil
```
2D game asset, a single forged steam-engine valve: round flat valve disc with a bevelled rim on the left and a straight round valve stem pointing to the right, seen from the side, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

## Epoche 6 – Das Zeitalter der Eisenwerke (1785–1800)

**boiler_plate** – Kesselblech
```
2D game asset, a single forged wrought iron boiler plate: thick rectangular iron sheet, landscape format, slightly uneven hammered surface, one row of round rivet holes along all four edges, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**boiler_rivet** – Kesselniete
```
2D game asset, a single large forged boiler rivet: short thick round shank with a domed snap head on the left, seen from the side, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**crankshaft** – Kurbelwelle
```
2D game asset, a single forged crankshaft: straight round iron shaft with one single crank throw in the middle, made of two rectangular webs and a round crankpin offset to one side, seen from the side, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**large_shaft** – Antriebswelle
```
2D game asset, a single forged mill drive shaft: very long thick round iron shaft with two square bosses and two raised collars along its length and round journals at both ends, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**lathe_tool** – Drehmeißel
```
2D game asset, a single forged lathe cutting tool: short square steel bar with a bent, sharply ground hooked cutting tip on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground tip, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**leaf_spring** – Blattfeder
```
2D game asset, a single forged carriage leaf spring: a stack of five gently curved steel leaves of decreasing length held by a central iron clamp band, rolled eyes at both ends of the longest leaf, seen from the side, horizontal, dark grey unheated forged steel, 18th-century British blacksmith work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**rabble** – Puddelkrücke
```
2D game asset, a single forged puddling rabble: very long round iron rod with a flat rectangular paddle blade bent at a right angle at the right end and a closed loop handle at the left end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**ship_chain** – Ankerkette
```
2D game asset, a short length of heavy open-link anchor cable: four very large interlocking oval links of thick round bar, without cross studs, laid out straight and horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**tie_rod** – Zuganker
```
2D game asset, a single forged building tie rod: long round iron rod with a decorative S-shaped wall anchor plate at the left end and a forged eye at the right end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

**wagon_axle** – Wagenachse
```
2D game asset, a single heavy forged wagon axle for a horse-drawn plateway wagon: thick straight round iron bar with a raised collar and a short round journal at each end, horizontal, dark grey unheated wrought iron, 18th-century British blacksmith work, viewed from directly above, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only (no wood, no leather, no rope), cold and unheated (no glow, no sparks, no fire), no cast shadow, no other objects, no text, no numbers, no watermark, pure flat white background, square 1:1
```

---

## Historische Hinweise (bereits in die Prompts eingearbeitet)

- **Ankerkette:** offene Glieder ohne Stege – Stegketten gibt es erst ab 1816.
- **Werkzeuge ohne Stiel** (Sichel, Feile, Messer, Keilhaue, Bootshaken): Holzgriffe würden im
  Spiel mitglühen; der Schmied liefert ohnehin nur das Eisen.
- **Tuchschere:** Federschere ohne Schraube, wie sie Tuchscherer im 18. Jh. nutzten.
- **Wagenachse:** Pferdebahn-Wagen („plateway“), noch keine Eisenbahn.
