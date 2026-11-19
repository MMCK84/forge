# Prompts für die Grafik im Hochformat (Mobile)

Das Spiel wird auf **1080 × 1920 Pixel hochkant** umgestellt. Am PC läuft es dann in einem
hochkanten Fenster. Zum Entwickeln und Testen ändert sich nichts.

## Was sich ändert und was bleibt

| Grafik | Hochformat |
|---|---|
| **6 Werkstatt-Hintergründe** | **neu nötig** – die bisherigen sind quer (Abschnitt A) |
| **Auftragsbuch** | **neu nötig** – eine einzelne Seite statt Doppelseite (Abschnitt B) |
| **App-Icon, Store-Banner** | **neu** – Pflicht für Google Play und den App Store (Abschnitt C) |
| Essen Stufe 3 und 4, Handhammer, Hammer mit verstählter Bahn | fehlen noch (Abschnitt D) |
| Maschinen in Einzelteilen | optional, für die Animation (Abschnitt E) |
| 49 Werkstücke | **unverändert** – `PROMPTS_Werkstuecke.md` gilt weiter |
| Amboss, Lehm-/Ziegel-Esse, Hämmer, Pergament, Knöpfe, HUD-Leiste, Glut-Knopf, Siegel, Münzen, Münzbeutel, Pyrometer-Zeiger | **unverändert** – sind freigestellt bzw. dehnbar und passen in beide Formate |

## Aufbau des Bildschirms

Die Hintergründe müssen genau dazu passen. Esse, Amboss und Maschinen sind eigene Grafiken,
die das Spiel **über** den Hintergrund legt – der Hintergrund ist deshalb ein **leerer Raum**.

```
 y (px)  ┌──────────────────────────┐
    0    │ HUD: Geld · Epoche       │  Holz-Eisen-Leiste
  120    │ Rückwand: Fenster oben   │
         │ links, Kleinkram an den  │
         │ Rändern                  │
         │      ┌──── Esse ────┐    │  steht an der Rückwand
  760    │──────┴──────────────┴────│  ← Wand trifft Boden
         │        Fußboden          │
         │       ┌─ Amboss ─┐  [M] │  M = Maschine / Löschtrog
 1300    │       └──────────┘       │
         │  Glühskala, Fortschritt  │  Bedienfeld auf dunklem Boden
         │ [Rohling]     [Umlegen]  │
         │       ( HAMMERN )        │  großer Daumen-Knopf
 1920    │ Auftragsleiste           │
         └──────────────────────────┘
```

---

## A · Werkstatt-Hintergründe (6 Stück, je Epoche einer)

**Format:** 9:16 hochkant, möglichst 1080 × 1920 oder größer (Midjourney: `--ar 9:16`).
**Dateiname:** `background_1.webp` … `background_6.webp`.

Jeder Prompt ist vollständig. Der gemeinsame Teil legt fest, dass Wand und Boden genau dort
liegen, wo das Spiel Esse und Amboss hinstellt, und dass die Bildmitte frei bleibt.

**background_1** – Die Dorfschmiede (1700–1715)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of a small half-timbered English village smithy around 1700, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: timber frame with whitewashed wattle-and-daub panels, rough oak beams along the top. The floor fills the lower 60 % and comes towards the viewer: packed earth with straw and soot. A small window high on the back wall in the upper left corner shows green English countryside with a hedge and a distant church tower. On the far right edge a wooden rack with tongs, and a few horseshoes nailed to a beam. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no tools in the centre, no people, no animals, no text, no watermark.
```

**background_2** – Kutschen & Handelswege (1715–1735)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of a roadside smithy on an English coaching road around 1725, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: rough grey stone wall with heavy timber ceiling beams. The floor fills the lower 60 % and comes towards the viewer: worn stone flagstones. A small window high on the back wall in the upper left corner shows a dirt coaching road with a milestone and a distant stagecoach. On the far left edge a spare coach wheel leans against the wall; on the far right edge harness and iron hoops hang on wooden pegs. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no tools in the centre, no people, no animals, no text, no watermark.
```

**background_3** – Hafen & Royal Navy (1735–1750)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of a harbour smithy in an English naval dockyard around 1740, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: weathered red brick with tarred timber beams. The floor fills the lower 60 % and comes towards the viewer: tarred wooden planks. A small window high on the back wall in the upper left corner shows the masts and furled sails of a Royal Navy ship of the line in the harbour. On the far left edge a wooden barrel; on the far right edge coils of rope and a length of heavy chain hang from iron hooks. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no tools in the centre, no people, no animals, no text, no watermark.
```

**background_4** – Stahl & Tuch (1750–1765)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of a smith's and cutler's workshop in Sheffield around 1755, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: soot-darkened brick. The floor fills the lower 60 % and comes towards the viewer: worn stone slabs. A small window high on the back wall in the upper left corner shows Sheffield rooftops with many smoking brick chimneys under a grey sky. On the far left edge bolts of dyed woollen cloth (dark red, indigo, ochre) are stacked; on the far right edge a wooden shelf holds knife blades and files. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no tools in the centre, no people, no animals, no text, no watermark.
```

**background_5** – Das Zeitalter des Dampfes (1765–1785)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of the forge of a water-powered hammer works in the Severn Gorge around 1780, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: high brick wall with heavy oak beams. The floor fills the lower 60 % and comes towards the viewer: wet stone floor with small puddles. A small window high on the back wall in the upper left corner shows the cast-iron arch of the Iron Bridge over the river Severn in a wooded gorge. The right third of the room is left open and empty, because a large machine will be placed there later. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no machine, no water wheel, no tools in the centre, no people, no animals, no text, no watermark.
```

**background_6** – Das Zeitalter der Eisenwerke (1785–1800)
```
Vertical 9:16 portrait game background, hand-painted 2D game art with dark ink outlines and warm painterly textures. Interior of the smithy of a large English ironworks around 1790, seen from standing eye height and looking slightly down. The back wall fills the upper 40 % of the image: tall dark brick wall with two cast-iron columns. The floor fills the lower 60 % and comes towards the viewer: cast-iron floor plates with coke dust. A window high on the back wall in the upper left corner shows glowing blast furnaces and smoking chimneys of an ironworks at dusk. The right third of the room is left open and empty, because a steam engine will be placed there later. The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. The lower third is plain dark floor with little detail, getting darker towards the bottom edge. No forge, no hearth, no fire, no anvil, no machine, no steam engine, no tools in the centre, no people, no animals, no text, no watermark.
```

**Tipps:** Malt der Generator trotzdem eine Esse oder einen Amboss hinein, hilft es, den letzten
Satz an den Anfang zu stellen. Wichtig ist nur: Wand-Boden-Kante ungefähr bei 40 % der Höhe,
Bildmitte leer, unteres Drittel ruhig und dunkel (dort liegen die Bedienelemente).

---

## B · Auftragsbuch als Einzelseite

Ersetzt das aufgeschlagene Kontorbuch (Doppelseite ist im Hochformat zu breit).
Angebote stehen untereinander, bei mehr Inhalt wird geblättert.
**Dateiname:** `ledger_page.webp`
```
2D game asset, a single page of an 18th-century leather-bound ledger book seen from directly above, portrait orientation 3:4, aged cream parchment with faint brown ruled lines and soft stains, completely empty page (no writing, no numbers), the dark brown leather binding and a few page edges visible along the left side, small brass corner fittings on the right corners, a red ribbon bookmark hanging out at the bottom, hand-painted 2D game art with dark ink outlines, soft even lighting, no cast shadow, no text, no watermark, isolated on pure flat white background
```

---

## C · App-Icon und Store-Grafik

**App-Icon** (Google Play 512 × 512, App Store 1024 × 1024). Muss auch winzig auf dem
Homescreen erkennbar sein. **Dateiname:** `app_icon.webp`
```
Square 1:1 mobile game app icon, a heavy blacksmith's hammer striking a glowing orange-hot horseshoe on the face of a dark iron anvil, a burst of bright sparks, warm firelight against a deep dark brown background, bold simple shapes and strong contrast that stay readable at very small size, hand-painted 2D game art with dark ink outlines, subject centred and filling most of the square, no text, no letters, no border, no rounded corners, no watermark
```

**Store-Banner** (Google Play „Feature Graphic“, 1024 × 500). Der Spieltitel kommt später
als Schrift dazu, deshalb bleibt links Platz. **Dateiname:** `store_banner.webp`
```
Wide 2:1 banner illustration for a mobile game, interior of an 18th-century English smithy at night lit only by forge fire, on the right half a blacksmith's anvil with a glowing horseshoe and a raised hammer with sparks flying, a brick forge glowing in the background, the left half is calm, dark and empty for a title to be added later, hand-painted 2D game art with dark ink outlines and warm painterly textures, no people, no text, no letters, no watermark
```

---

## D · Fehlende Ausrüstung

Gleicher Stil und gleiche Ansicht wie deine Lehm- und Ziegel-Esse bzw. deine Hämmer.

**forge_double_bellows** – Esse Stufe 3 (Doppelblasebalg, ab Epoche 3)
Das Spiel braucht **3 Plätze nebeneinander** auf dem Glutbett – das Glutbett muss also
mindestens die halbe Breite der Esse einnehmen.
```
2D game asset, a large 18th-century brick and stone blacksmith forge hearth with two leather bellows side by side on the left, a long wide open fire bed of glowing coals that takes up at least half of the forge's width, a brick chimney hood above it shown completely inside the image, iron straps and rivets, side view from slightly above like a game sprite, the whole object fully inside the frame with a margin, no smoke, no sparks above the forge, no people, no tools in front of the fire bed, no text, no watermark, isolated on pure flat white background
```

**forge_coke** – Esse Stufe 4 (Koks-Esse, ab Epoche 5)
Ebenfalls 3 Plätze; das Gebläse zeichnet das Spiel selbst links daneben.
```
2D game asset, a large late-18th-century coke-fired smith's hearth: a long rectangular hearth of cast-iron plates and firebrick with a wide open fire bed of brilliant yellow-white glowing coke that takes up at least half of the forge's width, a cast-iron air pipe entering from the left side, an iron hood and short chimney shown completely inside the image, riveted iron bands, side view from slightly above like a game sprite, the whole object fully inside the frame with a margin, no smoke, no sparks above the forge, no people, no text, no watermark, isolated on pure flat white background
```

**hammer_hand** – Handhammer (Stufe 1)
```
2D game asset, a simple 18th-century blacksmith's hand hammer: plain forged iron head with a flat face and a short rounded back, wedged into a straight ash-wood handle, three-quarter view from above, head in the upper left and handle pointing to the lower right, hand-painted 2D game art with dark ink outlines, matte dark iron, no engraving, no text, no numbers, no cast shadow, no watermark, isolated on pure flat white background
```

**hammer_steel_faced** – Hammer mit verstählter Bahn (Stufe 3)
```
2D game asset, an 18th-century blacksmith's hammer with a steel-faced head: dark wrought iron body with a bright, polished steel striking face forge-welded onto the front, a visible weld line between iron and steel, a wedge-shaped peen on the back, straight hardwood handle with an iron wedge, three-quarter view from above, head in the upper left and handle pointing to the lower right, hand-painted 2D game art with dark ink outlines, no engraving, no text, no numbers, no cast shadow, no watermark, isolated on pure flat white background
```

---

## E · Maschinen in Einzelteilen (optional)

Damit sich Wasserrad, Hammerbalken und Schwungrad bewegen können, braucht das Spiel
**jedes Teil einzeln**. Drehteile genau von vorn und kreisrund, Mittelpunkt = Bildmitte.

**water_wheel** – Wasserrad (Wasser-Schwanzhammer, Epoche 5)
```
2D game asset, a single wooden undershot water wheel seen exactly from the side so that it is a perfect circle, eight straight spokes, wooden paddles all around the rim, iron bands and an iron axle hub exactly in the centre of the image, hand-painted 2D game art with dark ink outlines, no water, no frame, no stand, no shadow, no text, no watermark, isolated on pure flat white background, square 1:1
```

**helve_beam** – Hammerbalken mit Hammerkopf
```
2D game asset, a single helve-hammer beam seen exactly from the side: a long heavy oak beam lying horizontally, bound with iron hoops, a round iron pivot boss with a hole at one third from the left end, a heavy forged iron hammer head fixed at the right end pointing straight down, hand-painted 2D game art with dark ink outlines, no frame, no posts, no anvil, no shadow, no text, no watermark, isolated on pure flat white background
```

**helve_frame** – Gestell mit Daumenwelle
```
2D game asset, the wooden support frame of an 18th-century helve hammer seen exactly from the side: two heavy upright oak posts joined by cross beams, an iron bearing on top of the posts for a pivot, and a horizontal cam shaft with four iron cams at the bottom, hand-painted 2D game art with dark ink outlines, no hammer beam, no water wheel, no anvil, no shadow, no text, no watermark, isolated on pure flat white background
```

**flywheel** – Schwungrad (Dampf-Schwanzhammer, Epoche 6)
```
2D game asset, a single cast-iron flywheel of an 18th-century beam engine seen exactly from the front so that it is a perfect circle, six gently curved spokes, a heavy rim, the hub exactly in the centre of the image, hand-painted 2D game art with dark ink outlines, dark iron, no frame, no shaft stand, no shadow, no text, no watermark, isolated on pure flat white background, square 1:1
```

**engine_body** – Dampfmaschine ohne Balancier und Schwungrad
```
2D game asset, the body of a Boulton and Watt style beam engine around 1785 seen from the side: a tall vertical cast-iron steam cylinder with a piston rod sticking out of the top, a brick and timber engine bed, a tall cast-iron column on the right that would carry a beam, pipes and valve gear, hand-painted 2D game art with dark ink outlines, no rocking beam, no flywheel, no smoke, no shadow, no text, no watermark, isolated on pure flat white background
```

**engine_beam** – Balancier
```
2D game asset, a single cast-iron rocking beam of an 18th-century beam engine seen from the side: long horizontal beam, thicker in the middle and tapering to both ends, an open lattice pattern, a round pivot hole exactly in the centre and connection eyes at both ends, hand-painted 2D game art with dark ink outlines, dark iron, no column, no engine, no shadow, no text, no watermark, isolated on pure flat white background
```

---

## Reihenfolge (was am meisten bringt)

1. **background_1** und **background_2** – damit sieht man das Hochformat sofort gut.
2. **ledger_page** – das Auftragsbuch öffnet man ständig.
3. **app_icon** – braucht man spätestens für den ersten Test auf dem Handy über den Store.
4. **forge_double_bellows**, **hammer_hand** – sieht man früh im Spiel.
5. Hintergründe 3–6, Rest nach Lust und Laune.
