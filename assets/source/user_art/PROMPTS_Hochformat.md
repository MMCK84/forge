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
| ✅ gut (Midjourney) | 19 |
| 🟠 von Midjourney vorhanden – sollte noch verändert werden | 1 |
| 🟡 von Gemini vorhanden – durch Midjourney ersetzen | 28 |
| ⬜ noch nicht vorhanden | 127 |
| ⬜ noch nicht vorhanden (optional) | 62 |

| Bereich | ✅ gut | 🟠 ändern | 🟡 Gemini | ⬜ fehlt | ⬜ optional |
|---|---|---|---|---|---|
| A · Werkstatt-Hintergründe | 10 | 0 | 0 | 0 | 0 |
| B · Essen | 4 | 1 | 0 | 1 | 0 |
| C · Amboss und Hämmer | 5 | 0 | 0 | 0 | 0 |
| D · Maschinen | 0 | 0 | 7 | 3 | 4 |
| E · Werkstücke | 0 | 0 | 9 | 72 | 0 |
| F · Kundenporträts | 0 | 0 | 0 | 0 | 54 |
| G · Oberfläche, Symbole, Store | 0 | 0 | 12 | 1 | 4 |
| H · Werkstatt-Einrichtung | 0 | 0 | 0 | 50 | 0 |

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
| 20.11. | Hintergründe | gekürzter Prompt (Epoche 1 V4, Epoche 2): kein schwarzer Streifen mehr, Upscale 2000 × 2000 – aber Kante tiefer (72 % bzw. ~80 %), Tageslicht statt Feuerschein, Epoche 2 mit zweitem Fenster außerhalb des Hochformats und verwischter grauer Fläche („plain wall“) | „high viewpoint, the floor fills the lower half“, „Evening, warm orange firelight on the centre of the back wall“, „only one small window“, „centre free of posts and windows“ statt „plain wall“; `--no daylight beam, second window` |
| 20.11. | Hintergründe | Epoche 2 mit nachgeschärftem Prompt: Abendlicht und Feuerschein in der Wandmitte klappen, Kante 69 % (vorher ~80 %), aber trotz `--no second window` ein zweites großes Fenster rechts der Mitte | Bausteine beibehalten; Fenster noch deutlicher: „Only one small window, high in the upper left part of the back wall“ |
| 20.11. | Hintergründe | Lieferung Epoche 3–10: Stimmung und Inhalt gut; aber (a) alle eher dunkel, (b) Epoche 5 und 9 mit gemaltem Feuer in der Wandmitte, (c) Epoche 3 und 7 mit zweitem, großem Aussichtsfenster am rechten Rand (im Hochformat angeschnitten), (d) Kante 56–84 % | „Evening but well lit“; `--no fireplace, flames`; „Through the small window: …“ statt „Window view“, damit die Aussicht im kleinen Fenster links landet; zu tiefe Kante gleicht der Import aus (oben Decke abschneiden, `BG_TOP_CROP`) |
| 20.11. | Essen | erste Frontalansichten (Stufe 1–5): Aufbau, Blasebalg links und offenes Glutbett gelungen; Stufe 3 zeigt nur einen Blasebalg und einen Sack statt zwei übereinanderliegender Bälge; Stufe 1 hat ein schmales Glutbett (~25 % der Breite) | Doppelblasebalg ausdrücklich: „two identical teardrop bellows stacked one above the other, one lever“; Glutbett „wide, about two thirds of the width“; Glutbett, Schornstein und Ursprung misst jetzt der Import selbst |
| 20.11. | Hämmer, Amboss (Raw) | Formen und Ansicht genau richtig, aber fotorealistische 3D-Renderings statt handgemalt mit Tuschekontur – der Raw-Modus überstimmt die Stilangabe; Amboss mit Horn nach links | Raw nur noch, wenn die Form nicht stimmt; sonst Standard mit Stil-Referenz (ein Hintergrund oder eine Esse); `--no photo, 3d render`; Horn-Richtung gleicht der Import aus (spiegeln); Griff, Bahn und Ambossbahn misst der Import selbst |

## Midjourney-Einstellungen (Version 8.2)

**Seitenverhältnis immer am Regler einstellen** – er überstimmt `--ar` im Prompt; die nötige Einstellung steht bei jedem Bild. Version immer gleich lassen (8.2). Weirdness immer 0. Video-Einstellungen spielen keine Rolle.

| Gruppe | Model | Raw | Stylization | Variety | Speed |
|---|---|---|---|---|---|
| Werkstücke (E), Hämmer (C), Maschinenteile (D), Symbole (G) | Standard | Standard (Raw nur, wenn die Form nicht stimmt) | niedrig (ca. 10 %) | 0 | Relax, wenn möglich |
| Essen (B), Amboss, Schabotte | Standard | Standard (Raw nur, wenn die Form nicht stimmt) | niedrig (ca. 10 %) | 0 | Fast |
| Hintergründe (A) | **HD** (für das ausgewählte Bild) | Standard | mittel (ca. 30–40 %) | 0 | Fast |
| Porträts (F) | Standard | Standard | mittel (ca. 30 %) | 0 | Relax, wenn möglich |
| App-Icon, Store-Banner | **HD** | Standard | mittel | 0 | Fast |

Raw hält sich genauer an Vorgaben wie „genau von der Seite“, malt aber fotorealistisch statt im gezeichneten Stil des Spiels – deshalb nur im Notfall. Für den Stil immer ein gelungenes Bild (Hintergrund oder Esse) als Stil-Referenz `--sref` anhängen. HD lohnt sich nur, wo das Bild groß zu sehen ist (Hintergründe 1080 × 1920, Icon, Banner); Gegenstände verkleinert das Spiel ohnehin auf 256–1000 px. Für eine Serie (z. B. alle Werkstücke) das beste Bild als Stil-Referenz `--sref <URL>` an alle weiteren Prompts der Gruppe hängen.


## Regeln für alle Bilder

- Freigestellt auf **reinem Weiß**, ohne Schatten, ohne Text, ohne Jahreszahlen, ohne Wasserzeichen.
- Objekt vollständig im Bild mit etwas Rand.
- Dateiname = die fett gedruckte ID (z. B. `door_hinge.png`); das unveränderte Original (PNG) über GitHub in `assets/source/user_art/eingang/` hochladen – Bilder im Chat werden verkleinert.
- Einheitlicher Stil: handgemalt, dünne dunkle Tuschekontur, warme Malstruktur.
- Midjourney: Prompt komplett kopieren (inkl. `--ar` und `--no`); Einstellungen je Gruppe siehe oben.
- Für einheitlichen Stil: ein gelungenes Bild als Stil-Referenz verwenden (`--sref <Bild-URL>`).

## Reihenfolge (was am meisten bringt)

Erledigt: alle zehn Hintergründe (A), Essen Stufe 1–5 in Frontalansicht (B), Amboss und Hämmer (C).

1. **Werkstücke** epochenweise (E) – die größte Lücke; Standard-Modus mit Stil-Referenz (nicht Raw).
2. **Esse Stufe 3 neu** (Doppelbalg) und **Siemens-Ofen** (B), **Dampfhammer-Teile** (D), **Löschtrog** (G).
3. **Werkstatt-Einrichtung** (H) – das Spiel zeigt bis dahin Platzhalter.
4. Die übrigen 🟡 Gemini-Bilder ersetzen: Maschinenteile (D), Oberfläche (G) – gleiche Dateinamen.
5. Optional: Porträts (F), Ladenbilder, Victoria-Münzen, Sterne, Sanduhr, Pyrometer-Zifferblatt.

## A · Werkstatt-Hintergründe (1:1 – für Hoch- und Querformat)

Esse, Amboss und Maschinen stellt das Spiel davor – der Raum bleibt leer. Wand-Boden-Kante bei etwa 55–60 % der Höhe, unteres Drittel ruhig und dunkel (Bedienelemente).

**Format 1:1 (Regler: Square 1:1), danach Upscale 2× (Subtle) und erst das vergrößerte Bild (2048 × 2048) schicken** – ohne Upscale sind es nur 1024 × 1024. Ein Bild für beide Ausrichtungen: Im Hochformat nimmt das Spiel den mittleren 3:4-Ausschnitt (die äußeren Achtel links und rechts fallen weg) und verlängert den dunklen Boden nach unten; im Querformat (Tablet, später) die volle Breite. Deshalb gehören Fenster und alles Wichtige in die mittleren drei Viertel. Mindestgröße nach dem Upscale: 1440 × 1440 Pixel. Hilfreich: die Vorlage `assets/source/user_art/vorlagen/bildaufbau_hintergrund.png` (1:1) als **Bild-Prompt** vor den Text setzen (nicht als Stil-Referenz) und ein gelungenes Midjourney-Bild als Stil-Referenz. Ich messe die Kante bei jedem Bild aus (50–70 % geht; liegt sie tiefer, schneidet der Import oben Decke ab).

**background_1** – Die Dorfschmiede (1700–1715) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 111 Wörter  
*20.11.: Variante 4 als Original (PNG 2048 × 2048): kein Streifen, große freie Putzfläche hinter der Esse, Fenster mit Kirchturm in den mittleren drei Vierteln, Werkzeug und Hufeisen an den Rändern. Kante tief (73 %, Bühne y 1053), wirkt im Spiel aber gut. Tageslicht statt Feuerschein – unkritisch.*
```
background_1 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. English village smithy around 1700: half-timbered wall with whitewashed daub, earth floor with straw. Through the small window: green fields, hedge, church tower. Edges: tongs rack, horseshoes on a beam --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_2** – Kutschen & Handelswege (1715–1735) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 114 Wörter  
*20.11.: 1:1, PNG 2048 × 2048, nachgeschärfter Prompt: Abendstimmung mit Feuerschein in der Wandmitte, Bruchstein, Steinplatten, Rad und Geschirr an den Rändern. Kante 69 % (Bühne y 991). Zweites, großes Fenster rechts der Mitte steht teils hinter der Esse, die Postkutsche darin ist kaum zu sehen – im Spiel unauffällig.*
```
background_2 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Roadside smithy on an English coaching road around 1725: rough grey stone wall, timber beams, worn flagstones. Through the small window: dirt road with a stagecoach. Edges: spare coach wheel, harness on pegs --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_3** – Hafen & Royal Navy (1735–1750) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 118 Wörter  
*20.11.: 1:1, PNG 2048 × 2048. Hafen: Ziegel, geteerte Balken, Dielen, Fass, Tau und Kette an den Rändern; Kante 58 % (Bühne y 833). Aussichtsfenster mit Schiffsmasten rechts am Rand, im Hochformat angeschnitten – wirkt trotzdem gut.*
```
background_3 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Harbour smithy in a Royal Navy dockyard around 1740: red brick, tarred timber beams, tarred plank floor. Through the small window: masts and furled sails of a ship of the line. Edges: barrel, coiled rope, heavy chain --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_4** – Stahl & Tuch (1750–1765) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 111 Wörter  
*20.11.: 1:1, PNG 2048 × 2048. Sheffield: Ziegel, Steinplatten, Fenster mit rauchenden Schornsteinen; Kante 60 % (Bühne y 867). Eher dunkel und kühl.*
```
background_4 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Smith's and cutler's workshop in Sheffield around 1755: soot-darkened brick, worn stone slabs. Through the small window: rooftops with smoking chimneys. Edges: bolts of dyed wool, shelf with knife blades --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_5** – Das Zeitalter des Dampfes (1765–1785) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 118 Wörter  
*20.11.: 1:1, PNG 2048 × 2048. Severn: Iron Bridge im Fenster, nasser Steinboden; Kante 68 % (Bühne y 984). Gemaltes Feuer in der Wandmitte steht hinter der Esse und fällt im Spiel kaum auf.*
```
background_5 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Forge of a water-powered hammer works in the Severn Gorge around 1780: brick wall, oak beams, wet stone floor. Through the small window: the cast-iron Iron Bridge in a wooded gorge. Right third of the floor empty --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_6** – Das Zeitalter der Eisenwerke (1785–1800) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 115 Wörter  
*20.11.: 1:1, PNG 2048 × 2048. Eisenwerk: gusseiserne Säulen, Hochöfen im Fenster; Kante 65 % (Bühne y 932).*
```
background_6 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Smithy of a large English ironworks around 1790: dark brick wall, cast-iron columns, iron floor plates with coke dust. Through the small window: glowing blast furnaces at dusk. Right third of the floor empty --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_7** – Krieg & Erfindergeist (1800–1820) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 112 Wörter  
*20.11.: 1:1, PNG 2048 × 2048. London: gelber Ziegel, Steinplatten; St Paul's im Fenster am rechten Rand (im Hochformat angeschnitten); Kante 56 % (Bühne y 812). Ersetzt die frühere Fassung mit zu hohem Fenster.*
```
background_7 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. London engineering smithy in Lambeth around 1810: smoke-blackened yellow brick, York stone floor. Through the small window: the Thames with barges, dome of St Paul's. Edges: iron bars, rack with templates --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_8** – Eisenbahnfieber (1820–1839) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 113 Wörter  
*20.11.: 1:1, PNG 2048 × 2048. Newcastle: zugemauerte Bögen, Lokomotive im Tor, Räder und Ketten an den Rändern; Kante 57 % (Bühne y 827).*
```
background_8 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Locomotive smithy in Newcastle around 1830: dark red brick with bricked-up arches and tie-rod plates, cinder floor. Through the small window: early steam locomotive with coal wagons. Edges: locomotive wheels, coupling chains --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_9** – Der Dampfhammer (1839–1860) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 114 Wörter  
*20.11.: 1:1, PNG 2048 × 2048. Gießerei: hohe Ziegelwand mit Säulen, Rundbogenfenster; Kante 70 % (Bühne y 1005). Gemaltes Feuer in der Wandmitte hinter Esse und Dampfhammer.*
```
background_9 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Forge shop of a great engineering foundry around 1845: tall soot-stained brick, cast-iron columns, iron floor plates. Through the small window: canal with a narrowboat, foundry chimneys. Right third of the floor empty --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**background_10** – Das Stahlzeitalter (1860–1880) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 115 Wörter  
*20.11.: 1:1, PNG 2048 × 2048. Stahlwerk: Eisenbinder, Kranbahn, Bessemer-Funken im Fenster. Kante sehr tief (84 %): der Import schneidet oben 300 px Decke ab (Bühne y 1000).*
```
background_10 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Sheffield steelworks forge around 1870: very tall dark brick wall, iron roof trusses, crane rail, iron floor plates. Through the small window: Bessemer converters blowing sparks at night. Right third of the floor empty --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

## B · Essen (Frontalansicht, alle sechs Stufen)

Frontal und symmetrisch, leicht von oben: Das Glutbett ist ein waagerechter Streifen über etwa 60 % der Breite, damit die Werkstücke gleichmäßig nebeneinander liegen. Blasebalg bzw. Gebläse immer links. Format 2:1, weißer Grund. Originale nach `assets/source/user_art/forges/<id>.png` – Glutbett, Schornstein und Lage misst der Import selbst.

**forge_clay** – Lehm-Esse mit Handblasebalg (Stufe 1, Epoche 1) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 99 Wörter  
*20.11.: Frontalansicht, offener Herdtisch mit Lehmhaube, Blasebalg links auf Bank. Glutbett schmal (~25 % der Breite) – für einen Platz ausreichend.*
```
forge_clay — 2D game asset, a small rustic early-18th-century village forge, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of clay and rough fieldstones, a simple clay-plastered hood with a short chimney, on the left a teardrop-shaped leather bellows with wooden boards on a stand, orange glowing charcoal fire, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no oven, dome, arch over the fire, cannon, perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**forge_brick** – Ziegel-Esse (Stufe 2, Epoche 2) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 101 Wörter  
*20.11.: Frontalansicht, Ziegelherd mit Eisenbändern, Schieferdach-Haube, Schornstein rechts; Blasebalg links steht senkrecht statt waagerecht – unkritisch.*
```
forge_brick — 2D game asset, a smith's forge of the 1720s, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of red brick bound with iron straps, a brick hood and a square brick chimney, on the left a teardrop-shaped leather bellows with wooden boards on a stand, bright orange coal fire, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no oven, dome, arch over the fire, cannon, perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**forge_double_bellows** – Esse mit Doppelblasebalg (Stufe 3, Epoche 3) · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Landscape 2:1** · 103 Wörter  
*20.11.: Esse selbst gut (Ziegel/Stein, Eisenbänder), aber links nur ein Blasebalg und ein Sack statt zweier übereinanderliegender Bälge mit Hebel.*
```
forge_double_bellows — 2D game asset, a large smith's forge of the 1740s, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of brick and stone, a wide brick hood bound with iron bands, on the left two identical teardrop bellows stacked one above the other, worked by one long lever, hot yellow-orange coal fire, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no oven, dome, arch over the fire, cannon, sack, perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**forge_coke** – Koks-Esse mit Zylindergebläse (Stufe 4, Epoche 5) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 102 Wörter  
*20.11.: Frontalansicht, genietete Eisenhaube, Gebläsezylinder links mit Luftrohr, Rohrschornstein rechts; Flammen etwas hoch – im Spiel unauffällig.*
```
forge_coke — 2D game asset, a long late-18th-century coke-fired smith's forge, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of cast-iron plates and firebrick, a riveted iron hood and a round iron chimney, on the left an upright cast-iron blowing cylinder with an air pipe into the hearth, brilliant yellow-white coke fire, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no oven, dome, arch over the fire, perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**forge_welding_furnace** – Schweißofen (Stufe 5, Epoche 8) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 81 Wörter  
*20.11.: niedriger Ziegelbogen über langem Glutbett, Schornstein rechts – genau wie gewünscht.*
```
forge_welding_furnace — 2D game asset, a long 1830s coal-fired welding furnace: a low hearth of firebrick and cast-iron plates bound by iron tie bars, a low brick arch over a long white-hot coal bed, a short square brick chimney, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**forge_siemens** – Siemens-Gasofen (Stufe 6, Epoche 10) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 89 Wörter
```
forge_siemens — 2D game asset, a massive 1870s Siemens regenerative gas furnace: a rectangular firebrick body clad with riveted iron plates and vertical iron buckstays, a wide open working front showing a blinding white-hot hearth, gas pipes with valves at both sides, a squat iron chimney stub, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, on pure flat white background --ar 2:1 --no perspective, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

## C · Amboss und Hämmer

Hämmer in reiner Seitenansicht: Kopf links senkrecht, Bahn unten, Stiel waagerecht nach rechts.

**anvil** – Amboss auf Eichenklotz (alle Epochen) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 35 Wörter  
*20.11.: Amboss auf hohem Holzklotz; Horn zeigte nach links – der Import spiegelt ihn. Fotorealistisch statt gezeichnet, passt im Spiel aber gut.*
```
anvil — 2D game sprite asset, heavy 18th-century cast iron anvil mounted on a thick oak wood stump, blacksmith equipment, side-view orthographic perspective, horn pointing to the right, crisp clean edges, isolated on white background, game art --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**hammer_hand** – Handhammer (Stufe 1) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 79 Wörter  
*20.11.: Handhammer, reine Seitenansicht, Bahn unten – genau wie gewünscht. Fotorealistisch statt gezeichnet; im Spiel klein, fällt kaum auf.*
```
hammer_hand — 2D game asset, a simple 18th-century blacksmith's hand hammer in flat side view (orthographic), the plain forged iron head stands upright on the left: flat striking face pointing straight down, short rounded back pointing straight up, the straight ash-wood handle goes through the middle of the head and points horizontally to the right, matte dark iron with hammer marks, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, engraving, text, numbers, watermark, border, shadow, photo, 3d render
```

**hammer_cross_peen** – Kreuzschlaghammer (Stufe 2) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 86 Wörter  
*20.11.: Kreuzschlaghammer (Finne oben), reine Seitenansicht, Bahn unten – genau wie gewünscht. Fotorealistisch statt gezeichnet; im Spiel klein, fällt kaum auf.*
```
hammer_cross_peen — 2D game asset, an 18th-century cast iron cross-peen blacksmith's hammer in flat side view (orthographic), the head stands upright on the left: square flat striking face pointing straight down, the back of the head tapers to a wedge-shaped cross peen pointing straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, dark cast iron with slight rust, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, engraving, text, numbers, watermark, border, shadow, photo, 3d render
```

**hammer_steel_faced** – Hammer mit verstählter Bahn (Stufe 3) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 95 Wörter  
*20.11.: verstählte Bahn mit sichtbarer Schweißnaht, reine Seitenansicht, Bahn unten – genau wie gewünscht. Fotorealistisch statt gezeichnet; im Spiel klein, fällt kaum auf.*
```
hammer_steel_faced — 2D game asset, an 18th-century blacksmith's hammer with a steel-faced head in flat side view (orthographic), the head stands upright on the left: dark wrought iron body with a bright polished steel striking face forge-welded onto the bottom, a visible weld line between iron and steel, the striking face points straight down, a wedge-shaped peen points straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, engraving, text, numbers, watermark, border, shadow, photo, 3d render
```

**hammer_crucible** – Gussstahl-Hammer / Tiegelstahl (Stufe 4) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 85 Wörter  
*20.11.: Gussstahl mit Messingzwinge und Endkappe, reine Seitenansicht, Bahn unten – genau wie gewünscht. Fotorealistisch statt gezeichnet; im Spiel klein, fällt kaum auf.*
```
hammer_crucible — 2D game asset, a high-quality late-18th-century crucible steel blacksmith's hammer in flat side view (orthographic), the polished bright steel head stands upright on the left: flat striking face pointing straight down, short flat back pointing straight up, a decorated brass ferrule where the head meets the handle, the straight dark walnut handle points horizontally to the right and ends in a small brass end cap, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, engraving, text, numbers, watermark, border, shadow, photo, 3d render
```

## D · Maschinen (Einzelteile für die Animation)

Drehteile genau von vorn und kreisrund, Mittelpunkt = Bildmitte; bewegliche Teile einzeln.

**water_wheel** – Wasserrad (Wasser-Schwanzhammer, Epoche 5) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 56 Wörter
```
water_wheel — 2D game asset, a single wooden undershot water wheel seen exactly from the side so that it is a perfect circle, eight straight spokes, wooden paddles all around the rim, iron bands and an iron axle hub exactly in the centre of the image, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no water, frame, stand, text, numbers, watermark, border, shadow, photo, 3d render
```

**helve_beam** – Hammerbalken mit Hammerkopf (Epoche 5–8) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 64 Wörter
```
helve_beam — 2D game asset, a single helve-hammer beam seen exactly from the side: a long heavy oak beam lying horizontally, bound with iron hoops, a round iron pivot boss with a hole at one third from the left end, a heavy forged iron hammer head fixed at the right end pointing straight down, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no frame, posts, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**helve_frame** – Gestell mit Daumenwelle · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 61 Wörter
```
helve_frame — 2D game asset, the wooden support frame of an 18th-century helve hammer seen exactly from the side: two heavy upright oak posts joined by cross beams, an iron bearing on top of the posts for a pivot, and a horizontal cam shaft with four iron cams at the bottom, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no hammer beam, water wheel, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**flywheel** – Schwungrad (Dampf-Schwanzhammer, Epoche 6–8) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 54 Wörter
```
flywheel — 2D game asset, a single cast-iron flywheel of an 18th-century beam engine seen exactly from the front so that it is a perfect circle, six gently curved spokes, a heavy rim, the hub exactly in the centre of the image, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 1:1 --no frame, shaft stand, text, numbers, watermark, border, shadow, photo, 3d render
```

**engine_body** – Dampfmaschine ohne Balancier und Schwungrad · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 68 Wörter
```
engine_body — 2D game asset, the body of a Boulton and Watt style beam engine around 1785 seen from the side: a tall vertical cast-iron steam cylinder with a piston rod sticking out of the top, a brick and timber engine bed, a tall cast-iron column on the right that would carry a beam, pipes and valve gear, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no rocking beam, flywheel, smoke, text, numbers, watermark, border, shadow, photo, 3d render
```

**engine_beam** – Balancier · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 61 Wörter
```
engine_beam — 2D game asset, a single cast-iron rocking beam of an 18th-century beam engine seen from the side: long horizontal beam, thicker in the middle and tapering to both ends, an open lattice pattern, a round pivot hole exactly in the centre and connection eyes at both ends, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 1:1 --no column, engine, text, numbers, watermark, border, shadow, photo, 3d render
```

**steam_hammer_frame** – Dampfhammer: Gestell (Epoche 9) · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 91 Wörter
```
steam_hammer_frame — 2D game asset, the frame of an 1840s Nasmyth steam hammer exact front view (orthographic): two tall cast-iron standards shaped like an inverted V on each side, joined at the top by a heavy cross beam that carries a vertical steam cylinder with flanges and a valve chest, a control lever with a handle on the right standard, a tall empty open gap in the middle between the standards where the hammer moves, hand-painted 2D game art, dark ink outlines, dark iron with rivets and bolts, on pure flat white background --ar 3:4 --no perspective, hammer head, piston rod, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**steam_hammer_ram** – Dampfhammer: Bär mit Kolbenstange · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 64 Wörter
```
steam_hammer_ram — 2D game asset, the moving ram (tup) of an 1840s steam hammer exact front view (orthographic): a long vertical polished piston rod at the top fixed into a heavy rectangular cast-iron hammer block with guide grooves on both sides and a flat steel die at the very bottom, upright and perfectly vertical, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:2 --no perspective, frame, cylinder, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**steam_hammer_anvil** – Dampfhammer: Schabotte (Ambossblock) · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 57 Wörter
```
steam_hammer_anvil — 2D game asset, the anvil block (schabotte) of an 1840s steam hammer exact front view (orthographic): a massive squat cast-iron block, wider at the base, with a flat steel die on top held by a dovetail and wedges, set on heavy oak timbers, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 3:2 --no perspective, hammer, frame, text, numbers, watermark, border, shadow, photo, 3d render
```

**steam_hammer_large_frame** – Gestell des großen Dampfhammers (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 3:4** · 71 Wörter
```
steam_hammer_large_frame — 2D game asset, the frame of a huge 1870s double-standard steam hammer exact front view (orthographic): two massive riveted wrought-iron standards forming an arch, a large steam cylinder on top with pipes and valve gear, a platform with railing for the hammer driver, a tall empty open gap in the middle where the hammer moves, hand-painted 2D game art, dark ink outlines, dark iron with rivets, on pure flat white background --ar 3:4 --no perspective, hammer head, piston rod, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**Ladenbilder der Maschinen** (ganze Maschine als ein Bild, nur für den Laden)

**machine_water_helve** – Wasser-Schwanzhammer (Ladenbild) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 53 Wörter
```
machine_water_helve — 2D game asset, an 18th-century water-powered helve hammer: a wooden undershot water wheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on a wooden stump on the right, side view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**machine_steam_helve** – Dampf-Schwanzhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 51 Wörter
```
machine_steam_helve — 2D game asset, a 1790s steam-powered helve hammer: a small beam engine with a flywheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on the right, side view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**machine_nasmyth** – Nasmyth-Dampfhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 42 Wörter
```
machine_nasmyth — 2D game asset, an 1840s Nasmyth steam hammer: two cast-iron standards, a steam cylinder on top, the hammer block hanging above a massive anvil block, a control lever, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**machine_great_steam_hammer** – Großer Dampfhammer (Ladenbild) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 40 Wörter
```
machine_great_steam_hammer — 2D game asset, a huge 1870s steam hammer with riveted wrought-iron arch standards, a large cylinder, a platform for the driver and a massive anvil block, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

## E · Werkstücke (Rohling + 80)

Kalt, nur Metall (kein Holz), von oben, weißer Hintergrund ohne Schatten, quadratisch. Die Glut färbt das Spiel ein.

**blank** – Rohling (alle Epochen) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 69 Wörter
```
blank — 2D game asset, a single piece of rectangular wrought iron bar stock, about eight times as long as it is wide, square cross-section, both ends roughly cut, horizontal from left to right, dark grey wrought iron with mill scale, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 1 – Die Dorfschmiede (1700–1715)

**nail** – Nagel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 64 Wörter
```
nail — 2D game asset, a single large hand-forged nail with a square tapering shank ending in a sharp point and a faceted hammered rosehead, horizontal with the head on the left, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**horseshoe** – Hufeisen · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 53 Wörter
```
horseshoe — 2D game asset, a single hand-forged horseshoe with a fullered groove and eight square nail holes, opening pointing down, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**hook** – Haken · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 61 Wörter
```
hook — 2D game asset, a single hand-forged S-shaped hanging hook made from round bar, pointed tip on the lower curve, small curled scroll on the upper end, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**door_hinge** – Türangel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 73 Wörter
```
door_hinge — 2D game asset, a single hand-forged strap hinge for a cottage door: long flat tapering iron strap with three round nail holes, a rolled eye at the left end and a spade-shaped decorative tip at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**sickle** – Sichel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 71 Wörter
```
sickle — 2D game asset, a single hand-forged sickle blade without handle: wide crescent-shaped thin steel blade with a smooth ground inner edge and a short pointed bare tang on the left, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**ploughshare** – Pflugschar · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 66 Wörter
```
ploughshare — 2D game asset, a single hand-forged ploughshare: flat, slightly curved triangular iron blade with a sharp point on the right and a short socket with two bolt holes on the left, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**fire_poker** – Schürhaken · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 75 Wörter
```
fire_poker — 2D game asset, a single hand-forged fireplace poker: long round iron bar with a small hooked side spur at the tip, a twisted section near the handle and a closed ring loop as handle, horizontal with the tip on the right, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**gate_latch** – Torriegel · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 66 Wörter
```
gate_latch — 2D game asset, a single hand-forged gate latch: flat iron latch bar with a curled thumb lever at one end and a small decorative scrolled back plate with two nail holes, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 2 – Kutschen & Handelswege (1715–1735)

**wheel_tyre** – Radreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
wheel_tyre — 2D game asset, a single forged iron wheel tyre: one flat iron hoop forming a perfect circle seen from directly above, narrow uniform band, a visible forge-welded joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**coach_axle** – Kutschachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 65 Wörter
```
coach_axle — 2D game asset, a single forged coach axle: straight thick square iron bar with a round tapered axle arm at each end and a raised collar where each arm begins, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**coach_fitting** – Kutschbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
coach_fitting — 2D game asset, a single forged coach body fitting: flat iron stay bar with elegant scrolled curls at both ends and four countersunk bolt holes, gently curved, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**lantern_bracket** – Laternenhalter · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 76 Wörter
```
lantern_bracket — 2D game asset, a single hand-forged wall bracket for a hanging lantern: horizontal square-bar arm with a small hook at the right tip, a decorative scroll brace below the arm, and a flat wall plate with two nail holes on the left, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**post_horseshoe** – Postpferd-Hufeisen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
post_horseshoe — 2D game asset, a single light hand-forged horseshoe for a coach horse: narrow web, deep fullered groove, six nail holes and a small raised toe clip at the front, opening pointing down, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**turnpike_fitting** – Schlagbaumbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter
```
turnpike_fitting — 2D game asset, a single heavy forged hinge for a turnpike toll gate: thick flat iron strap with three bolt holes and a large rolled eye at the left end, with an L-shaped iron pintle pin seated in the eye, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**drag_shoe** – Hemmschuh · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter
```
drag_shoe — 2D game asset, a single forged drag shoe for a coach wheel: elongated iron skid shaped like a narrow trough, front end curled upwards, a forged ring for the chain at the back, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 3 – Hafen & Royal Navy (1735–1750)

**chain_link** – Kettenglied · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
chain_link — 2D game asset, a single large forged oval chain link made from thick round bar, a visible forge-weld seam on one long side, empty in the middle, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**anchor_shank** – Ankerschaft · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter
```
anchor_shank — 2D game asset, a single forged ship's anchor shank without arms: long thick square iron bar, a forged ring eye at the left end, a thickened square crown block at the right end where the anchor arms would be welded, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**boathook** – Bootshaken · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
boathook — 2D game asset, a single forged boathook head without pole: a straight pointed spike on the right with one backward-curving hook beside it, and a conical open socket on the left, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**mooring_ring** – Festmacherring · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter
```
mooring_ring — 2D game asset, a single heavy forged mooring ring: thick round-section iron ring, empty in the middle, held by a short U-shaped staple with two pointed spikes at the bottom, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**ship_bolt** – Schiffsbolzen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter
```
ship_bolt — 2D game asset, a single forged ship's bolt: long round iron rod with a domed head at the left end and a narrow slot for a forelock wedge near the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**carriage_fitting** – Lafettenbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 76 Wörter
```
carriage_fitting — 2D game asset, a single forged gun-carriage fitting (cap square): heavy flat iron band bent into a half-round arch in the middle, a hinge eye at the left end and a slotted tab with two bolt holes at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**rudder_pintle** – Ruderfingerling · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 93 Wörter
```
rudder_pintle — 2D game asset, a single forged rudder pintle for a sailing ship: long flat iron strap with four bolt holes, at the left end bent into a thick round pin pointing downwards at a right angle, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 4 – Stahl & Tuch (1750–1765)

**spindle** – Spindel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
spindle — 2D game asset, a single forged spindle for a spinning machine: long thin round steel rod tapering to a fine point on the right, with a small round collar near the left end, horizontal, dark grey unheated forged steel, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**cloth_shears** – Tuchschere · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter
```
cloth_shears — 2D game asset, a single pair of large forged cloth shears of the spring type: two long straight steel blades joined at the left end by a U-shaped bow spring, blades slightly open, horizontal, dark grey unheated forged steel with slightly brighter ground edges, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, pivot screw, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**knife** – Messerklinge · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter
```
knife — 2D game asset, a single forged knife blade without handle: straight spine, curved sharp edge rising to a point on the right, a narrow bare tang on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**spring** – Feder · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter
```
spring — 2D game asset, a single hand-forged coil spring: steel wire wound into eight even coils with open straight ends, seen from the side, horizontal, dark grey unheated forged steel, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**chisel** – Meißel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter
```
chisel — 2D game asset, a single forged cold chisel: octagonal steel bar, slightly mushroomed striking head on the left, tapering to a sharp ground cutting edge on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**file** – Feile · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
file — 2D game asset, a single hand-cut file without handle: flat steel bar tapering towards the right, the whole surface covered with fine diagonal cross-hatched teeth, a narrow pointed bare tang on the left, horizontal, dark grey unheated forged steel, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**cargo_chain** – Ladekette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 63 Wörter
```
cargo_chain — 2D game asset, a short forged cargo chain: five interlocking oval links of round bar with a forged cargo hook at the right end, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**barrel_hoop** – Fassreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
barrel_hoop — 2D game asset, a single forged barrel hoop: thin flat iron band forming a circle seen from directly above, a small riveted overlap joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 5 – Das Zeitalter des Dampfes (1765–1785)

**piston_rod** – Kolbenstange · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter
```
piston_rod — 2D game asset, a single forged piston rod for a steam engine: long perfectly straight round iron rod, a forged flat crosshead eye at the left end and a tapered end with a cotter slot at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**valve_part** – Ventilteil · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 86 Wörter
```
valve_part — 2D game asset, a single forged steam-engine valve: round flat valve disc with a bevelled rim on the left and a straight round valve stem pointing to the right, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**beam_strap** – Balancierbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter
```
beam_strap — 2D game asset, a single forged strap for a beam engine: heavy flat iron band bent into a long U-shape lying on its side, with two rectangular cotter slots through both legs near the open end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**lock_fitting** – Schleusenbeschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 65 Wörter
```
lock_fitting — 2D game asset, a single forged canal lock-gate fitting: heavy flat iron collar band bent into a rectangular U-shape with two long straight arms, each arm with three bolt holes, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**miners_pick** – Keilhaue · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 79 Wörter
```
miners_pick — 2D game asset, a single forged miner's pick head without handle: slightly curved steel head with one long pointed end on the right, a short blunt poll on the left and an empty oval eye in the middle, horizontal, dark grey unheated forged steel with a slightly brighter point, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**drill_steel** – Bohreisen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
drill_steel — 2D game asset, a single forged rock drill steel for mining: long octagonal steel bar with a wide chisel-shaped bit on the right and a flat striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter bit, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**conveyor_chain** – Förderkette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter
```
conveyor_chain — 2D game asset, a short length of heavy flat-link winding chain for a mine shaft: five flat forged iron plate links connected by round pins, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**pump_rod** – Pumpengestänge · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 76 Wörter
```
pump_rod — 2D game asset, a single section of forged pump rod for a Cornish mine pump: long square iron rod with a flat forked strap joint and two bolt holes at the left end and a plain square end on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 6 – Das Zeitalter der Eisenwerke (1785–1800)

**boiler_rivet** – Kesselniete · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 78 Wörter
```
boiler_rivet — 2D game asset, a single large forged boiler rivet: short thick round shank with a domed snap head on the left, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**boiler_plate** – Kesselblech · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter
```
boiler_plate — 2D game asset, a single forged wrought iron boiler plate: thick rectangular iron sheet, landscape format, slightly uneven hammered surface, one row of round rivet holes along all four edges, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**rabble** – Puddelkrücke · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
rabble — 2D game asset, a single forged puddling rabble: very long round iron rod with a flat rectangular paddle blade bent at a right angle at the right end and a closed loop handle at the left end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**tie_rod** – Zuganker · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter
```
tie_rod — 2D game asset, a single forged building tie rod: long round iron rod with a decorative S-shaped wall anchor plate at the left end and a forged eye at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**ship_chain** – Ankerkette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 63 Wörter
```
ship_chain — 2D game asset, a short length of heavy open-link anchor cable: four very large interlocking oval links of thick round bar, without cross studs, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**lathe_tool** – Drehmeißel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
lathe_tool — 2D game asset, a single forged lathe cutting tool: short square steel bar with a bent, sharply ground hooked cutting tip on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground tip, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**leaf_spring** – Blattfeder · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 94 Wörter
```
leaf_spring — 2D game asset, a single forged carriage leaf spring: a stack of five gently curved steel leaves of decreasing length held by a central iron clamp band, rolled eyes at both ends of the longest leaf, seen from the side, horizontal, dark grey unheated forged steel, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**wagon_axle** – Wagenachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 66 Wörter
```
wagon_axle — 2D game asset, a single heavy forged wagon axle for a horse-drawn plateway wagon: thick straight round iron bar with a raised collar and a short round journal at each end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**large_shaft** – Antriebswelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter
```
large_shaft — 2D game asset, a single forged mill drive shaft: very long thick round iron shaft with two square bosses and two raised collars along its length and round journals at both ends, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**crankshaft** – Kurbelwelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 89 Wörter
```
crankshaft — 2D game asset, a single forged crankshaft: straight round iron shaft with one single crank throw in the middle, made of two rectangular webs and a round crankpin offset to one side, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centered with a wide empty margin on all sides, hand-painted 2D game asset with a thin dark ink outline, visible hammer marks, matte dark grey metal with strong light-and-shadow modelling, soft even studio lighting, metal only, cold and unheated, pure flat white background --ar 1:1 --no wood, leather, rope, glow, sparks, fire, cast shadow, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 7 – Krieg & Erfindergeist (1800–1820)

**block_pin** – Blockrollen-Bolzen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter
```
block_pin — 2D game asset, a single forged pulley-block pin: short thick perfectly straight round iron pin with a slightly domed head on the left and a small hole for a split pin near the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**boiler_stay** – Kessel-Stehbolzen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
boiler_stay — 2D game asset, a single forged boiler stay bolt: a long straight round iron rod with a thick upset collar near each end and slightly peened ends, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**gas_lamp_bracket** – Gaslaternen-Ausleger · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 86 Wörter
```
gas_lamp_bracket — 2D game asset, a single hand-forged wall bracket for a gas street lamp: a horizontal arm of square bar with a decorative twisted section and a large scroll brace underneath, a flat wall plate with four bolt holes on the left and a downward ring at the right tip for the lamp, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**navvy_spade** – Spaten · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 80 Wörter
```
navvy_spade — 2D game asset, a single forged navvy's spade blade without wooden handle: a broad flat slightly dished iron blade with a squared cutting edge at the bottom, rolled tread edges at the top and a long tapering open socket strap, upright with the socket pointing up, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**press_screw** – Pressenspindel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 79 Wörter
```
press_screw — 2D game asset, a single forged screw spindle for an iron printing press: a thick round iron rod with a coarse square thread twisted along its middle part, a square end for the lever on the left and a round foot on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**bayonet** – Bajonett · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 83 Wörter
```
bayonet — 2D game asset, a single forged socket bayonet without musket: a long triangular-section steel blade tapering to a sharp point on the right, joined by a short curved neck to a round hollow socket with an L-shaped slot on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**anchor_fluke** – Ankerarm · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter
```
anchor_fluke — 2D game asset, a single forged anchor arm for a ship's anchor: a thick curved iron arm ending in a broad flat triangular fluke (palm) on the right and a heavy square stump on the left where it is welded to the shank, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**chain_eyebar** – Brückenglied · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
chain_eyebar — 2D game asset, a single forged suspension bridge eyebar: a long flat wrought iron bar with a thickened round eye with a large hole at each end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 8 – Eisenbahnfieber (1820–1839)

**rail_spike** – Schienennagel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter
```
rail_spike — 2D game asset, a single forged railway track spike: a long square-section iron shank with a chisel point at the bottom and a hooked offset head at the top, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**coupling_hook** – Kupplungshaken · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
coupling_hook — 2D game asset, a single forged railway wagon coupling hook: a heavy curved iron hook with a thick shank and a punched eye at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**safety_valve_lever** – Sicherheitsventil-Hebel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter
```
safety_valve_lever — 2D game asset, a single forged safety valve lever for a locomotive boiler: a long flat iron lever with a fork and pin hole at the left end, two holes along its length and a rounded end on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**coupling_chain** – Kupplungskette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 55 Wörter
```
coupling_chain — 2D game asset, a short forged railway coupling chain: three heavy oval links of round bar, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**loco_tyre** – Lokomotiv-Radreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
loco_tyre — 2D game asset, a single forged locomotive wheel tyre: a thick iron hoop seen from directly above forming a perfect circle, with a raised flange along the inner edge and a visible forge-welded joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**buffer_spring** – Pufferfeder · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter
```
buffer_spring — 2D game asset, a single forged railway buffer spring: a stack of four curved steel leaves held by a central iron band, seen from the side, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**connecting_rod** – Treibstange · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter
```
connecting_rod — 2D game asset, a single forged locomotive connecting rod: a long tapered flat iron rod with a large rectangular strap end with a bearing hole on the left and a smaller round eye on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**crank_axle** – Kurbelachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
crank_axle — 2D game asset, a single forged locomotive crank axle: a thick straight round iron axle with two offset crank throws in the middle, each made of two rectangular webs and a crank pin, seen from the side, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 9 – Der Dampfhammer (1839–1860)

**bridge_rivet** – Brückenniete · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 56 Wörter
```
bridge_rivet — 2D game asset, a single large forged bridge rivet: short thick round shank with a domed head, seen from the side, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**palace_bracket** – Säulenkopf-Beschlag · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 62 Wörter
```
palace_bracket — 2D game asset, a single forged iron connecting bracket for a glass-and-iron exhibition hall: a flat L-shaped iron plate with a decorative curved gusset and six bolt holes, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**paddle_arm** – Schaufelrad-Arm · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
paddle_arm — 2D game asset, a single forged paddle-wheel arm for a paddle steamer: a long flat iron bar with a bolted palm plate at the right end and two bolt holes at the left end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**hammer_die** – Hammergesenk · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter
```
hammer_die — 2D game asset, a single forged steam-hammer die: a heavy rectangular steel block with a dovetail tongue on top and a smooth flat working face at the bottom, seen from the side, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**admiralty_anchor** – Admiralitätsanker · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter
```
admiralty_anchor — 2D game asset, a single forged Admiralty pattern anchor without stock: a long straight shank with a ring at the top and two curved arms with broad triangular flukes at the bottom, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**marine_piston_rod** – Schiffs-Kolbenstange · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
marine_piston_rod — 2D game asset, a single forged marine engine piston rod: a very long perfectly straight round iron rod with a tapered cone end on the left and a forged crosshead block with a hole on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**marine_crank** – Schiffskurbel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter
```
marine_crank — 2D game asset, a single forged marine engine crank: a heavy flat iron crank arm with a large round boss with a shaft hole at the left end and a smaller boss with a pin hole at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**propeller_shaft** – Schraubenwelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter
```
propeller_shaft — 2D game asset, a single forged ship's propeller shaft: a very long thick round iron shaft with a flanged coupling disc at the left end and a tapered end with a keyway on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 10 – Das Stahlzeitalter (1860–1880)

**velocipede_fork** – Hochrad-Gabel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
velocipede_fork — 2D game asset, a single forged front fork of a penny-farthing bicycle: two long slightly curved steel blades joined at the top by a crown with a vertical steering stem, upright, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**steel_axle** – Stahlachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
steel_axle — 2D game asset, a single forged railway carriage steel axle: a thick straight round steel bar with raised wheel seats and short round journals at both ends, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**reaper_knife** – Mähmesser · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter
```
reaper_knife — 2D game asset, a single forged reaper section knife: a long flat steel bar with a row of riveted triangular cutting sections along its upper edge, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**tunnel_drill** – Tunnelbohrer · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter
```
tunnel_drill — 2D game asset, a single forged tunnelling drill steel: a long octagonal steel bar with a cross-shaped four-point bit on the right and a collar near the striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**steel_tyre** – Stahl-Radreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter
```
steel_tyre — 2D game asset, a single weldless forged steel wheel tyre seen from directly above: a thick perfect steel ring seamless, with a flange along the inner edge, empty in the middle, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**gun_hoop** – Geschützring · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter
```
gun_hoop — 2D game asset, a single forged gun hoop for a built-up cannon: a short thick wide iron ring seen at a slight angle from above so its thickness is visible, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**armour_plate** – Panzerplatte · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter
```
armour_plate — 2D game asset, a single forged armour plate for an ironclad warship: a very thick rectangular wrought iron slab, landscape format, with slightly bevelled edges and a row of bolt holes along the long edges, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**steel_shaft** – Stahlwelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter
```
steel_shaft — 2D game asset, a single forged steel intermediate shaft for an ocean liner: a very long thick round steel shaft with a large flanged coupling disc at each end, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

## F · Kundenporträts (54)

Die aktuellen Porträts sind noch meine gerenderten (im Spiel vorhanden, aber im alten Stil). Für einen einheitlichen Stil empfehlenswert, aber nicht zwingend.

**portrait_squire** – the squire (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_squire — 2D game asset, a head-and-shoulders portrait of a stout English country squire of about 1710, full-bottomed powdered wig, brown velvet coat, ruddy cheeks, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_vicar** – the vicar (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_vicar — 2D game asset, a head-and-shoulders portrait of an elderly Anglican village vicar of about 1710, black cassock, white preaching bands, small grey wig, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_farmer_hollow** – Farmer Hollow (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_farmer_hollow — 2D game asset, a head-and-shoulders portrait of a weathered English farmer of about 1710, grey hair tied back, linen smock, broad-brimmed straw hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_miller_upton** – the miller of Upton (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_miller_upton — 2D game asset, a head-and-shoulders portrait of a cheerful village miller of about 1710, flour-dusted face and clothes, white linen cap, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_landlady_red_lion** – the landlady of the Red Lion (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 57 Wörter
```
portrait_landlady_red_lion — 2D game asset, a head-and-shoulders portrait of a sturdy English innkeeper's wife of about 1710, white linen cap, shawl over a laced bodice, warm smile, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_carpenter** – the carpenter (Epoche 1–2) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_carpenter — 2D game asset, a head-and-shoulders portrait of an English village carpenter of about 1710, leather apron, rolled sleeves, a pencil behind the ear, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_postmaster_bath** – the postmaster of Bath (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_postmaster_bath — 2D game asset, a head-and-shoulders portrait of a fashionable postmaster of Bath around 1725, neat tie wig, blue coat with brass buttons, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_coachbuilder_york** – the coachbuilder of York (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 58 Wörter
```
portrait_coachbuilder_york — 2D game asset, a head-and-shoulders portrait of a coachbuilder from York around 1725, sturdy man in a waistcoat with rolled sleeves, wood shavings on his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_turnpike_trust** – the Turnpike Trust (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_turnpike_trust — 2D game asset, a head-and-shoulders portrait of a gentleman trustee of a turnpike road around 1725, tricorn hat, grey coat, holding a ledger, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_innkeeper_coaching** – the coaching-inn keeper (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_innkeeper_coaching — 2D game asset, a head-and-shoulders portrait of the portly landlord of a coaching inn around 1725, red waistcoat, white apron, jolly expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_carrier_bennett** – Carrier Bennett (Epoche 2–3) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 57 Wörter
```
portrait_carrier_bennett — 2D game asset, a head-and-shoulders portrait of a carrier wagon driver around 1725, weather-beaten face, slouch hat, heavy woollen greatcoat, a whip over his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_navy_board** – the Navy Board (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_navy_board — 2D game asset, a head-and-shoulders portrait of a Navy Board commissioner around 1740, white powdered wig, dark blue coat with gold lace, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_shipwright_portsmouth** – the master shipwright of Portsmouth (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 57 Wörter
```
portrait_shipwright_portsmouth — 2D game asset, a head-and-shoulders portrait of a master shipwright of Portsmouth around 1740, grey hair, plain brown coat, holding a pair of brass dividers, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_merchant_bristol** – a Bristol merchant (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_merchant_bristol — 2D game asset, a head-and-shoulders portrait of a wealthy Bristol merchant around 1740, powdered wig, rich green silk coat, lace cravat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_harbourmaster** – the harbourmaster (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_harbourmaster — 2D game asset, a head-and-shoulders portrait of a harbourmaster around 1740, weathered sailor's face, tricorn hat, dark blue sea coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_ropewalk_chatham** – the Chatham ropewalk (Epoche 3–4) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 61 Wörter
```
portrait_ropewalk_chatham — 2D game asset, a head-and-shoulders portrait of the foreman of the Chatham ropewalk around 1740, strong man with tarred hands, knitted cap, a coil of rope over his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_clothier_leeds** – a Leeds clothier (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_clothier_leeds — 2D game asset, a head-and-shoulders portrait of a prosperous Leeds clothier around 1755, brown wig, plain cloth coat, holding a bolt of dyed wool, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_cutlers_sheffield** – the Sheffield cutlers (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 57 Wörter
```
portrait_cutlers_sheffield — 2D game asset, a head-and-shoulders portrait of the Master Cutler of Sheffield around 1755, dignified man with a chain of office over a dark coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_spinning_master** – the spinning master (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_spinning_master — 2D game asset, a head-and-shoulders portrait of a spinning master around 1760, middle-aged man in shirtsleeves and waistcoat, wisps of cotton on his clothes, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_toolmaker_holt** – toolmaker Holt (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_toolmaker_holt — 2D game asset, a head-and-shoulders portrait of a wiry toolmaker around 1760, spectacles on the nose, leather apron, a file in his hand, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_dockyard_chatham** – Chatham Dockyard (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_dockyard_chatham — 2D game asset, a head-and-shoulders portrait of the master attendant of Chatham Dockyard around 1760, naval officer, white wig, blue coat with gold buttons, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_boulton_watt** – Boulton & Watt of Soho (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 65 Wörter
```
portrait_boulton_watt — 2D game asset, a head-and-shoulders portrait of two engineering partners of Birmingham around 1780 side by side, one stout and cheerful in a fine coat, one thin and thoughtful Scotsman with grey hair, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_mine_cornwall** – a Cornish tin mine (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 60 Wörter
```
portrait_mine_cornwall — 2D game asset, a head-and-shoulders portrait of the captain of a Cornish tin mine around 1775, rugged face, miner's felt hat with a candle stuck on with clay, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_colliery_wednesbury** – the Wednesbury colliery (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_colliery_wednesbury — 2D game asset, a head-and-shoulders portrait of a colliery owner from Wednesbury around 1775, stout man, tall hat, coal dust on his collar, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_canal_company** – the canal company (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter
```
portrait_canal_company — 2D game asset, a head-and-shoulders portrait of a canal company engineer around 1775, surveyor's coat, holding rolled plans, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_ironmaster_coalbrookdale** – the ironmaster of Coalbrookdale (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_ironmaster_coalbrookdale — 2D game asset, a head-and-shoulders portrait of a Quaker ironmaster of Coalbrookdale around 1779, plain dark Quaker coat, broad-brimmed hat, calm expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_wedgwood_etruria** – Josiah Wedgwood of Etruria (Epoche 5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 58 Wörter
```
portrait_wedgwood_etruria — 2D game asset, a head-and-shoulders portrait of a master potter of Staffordshire around 1770, dignified man in a brown coat, holding a pale blue jasperware vase, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_mill_owner** – a cotton-mill owner (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 51 Wörter
```
portrait_mill_owner — 2D game asset, a head-and-shoulders portrait of a self-made cotton-mill owner around 1790, high collar, brown tailcoat, watch chain, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_plateway_company** – the plateway company (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_plateway_company — 2D game asset, a head-and-shoulders portrait of a tramroad company agent around 1790, top hat, grey tailcoat, holding a measuring rod, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_engine_works** – an engine works (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_engine_works — 2D game asset, a head-and-shoulders portrait of an engine-works manager around 1790, sideburns, dark tailcoat, an oil stain on his cuff, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_ironworks_partners** – your ironworks partners (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_ironworks_partners — 2D game asset, a head-and-shoulders portrait of a well-to-do ironworks partner around 1795, silver hair, black tailcoat, high white cravat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_east_india** – the East India Company (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_east_india — 2D game asset, a head-and-shoulders portrait of an East India Company director around 1795, powdered wig, rich red coat, gold-headed cane, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_navy_portsmouth** – the Portsmouth block mills (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_navy_portsmouth — 2D game asset, a head-and-shoulders portrait of a naval officer overseeing the Portsmouth block mills around 1805, bicorne hat, blue coat with an epaulette, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_maudslay** – Henry Maudslay of Lambeth (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_maudslay — 2D game asset, a head-and-shoulders portrait of a broad-shouldered master engineer of London around 1810, kind face, dark coat, holding a brass micrometer, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_telford** – the engineer Thomas Telford (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_telford — 2D game asset, a head-and-shoulders portrait of a Scottish civil engineer around 1815, grey hair, plain dark coat and cravat, rolled bridge drawings, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_gas_light_company** – the Gas Light and Coke Company (Epoche 7) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_gas_light_company — 2D game asset, a head-and-shoulders portrait of a gas company director around 1812, top hat, bottle-green tailcoat, a small gas lamp beside him, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_horse_guards** – the Royal Horse Guards (Epoche 7) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_horse_guards — 2D game asset, a head-and-shoulders portrait of a Royal Horse Guards officer around 1815, blue tunic, shining steel helmet with a plume, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_trevithick** – Richard Trevithick (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_trevithick — 2D game asset, a head-and-shoulders portrait of a tall Cornish engineer around 1805, curly hair, open-necked shirt and waistcoat, energetic expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_stockton_darlington** – the Stockton & Darlington Railway (Epoche 8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter
```
portrait_stockton_darlington — 2D game asset, a head-and-shoulders portrait of a Quaker railway promoter around 1825, plain dark coat, broad-brimmed hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_stephenson_works** – Robert Stephenson & Co. (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_stephenson_works — 2D game asset, a head-and-shoulders portrait of a young locomotive engineer from Newcastle around 1830, dark curly hair, high collar, black tailcoat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_liverpool_manchester** – the Liverpool & Manchester Railway (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_liverpool_manchester — 2D game asset, a head-and-shoulders portrait of a railway company director around 1830, top hat, dark green tailcoat, side whiskers, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_brunel** – Isambard Kingdom Brunel (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_brunel — 2D game asset, a head-and-shoulders portrait of a short energetic engineer around 1840, tall stovepipe hat, cigar, dark frock coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_hetton_colliery** – the Hetton colliery (Epoche 8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_hetton_colliery — 2D game asset, a head-and-shoulders portrait of a colliery viewer around 1825, sturdy northern man, flat cap, waistcoat, coal-dusted hands, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_nasmyth** – James Nasmyth of Patricroft (Epoche 9–10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_nasmyth — 2D game asset, a head-and-shoulders portrait of a Scottish engineer around 1845, broad face, bushy dark beard, dark frock coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_great_western_ss** – the Great Western Steamship Company (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter
```
portrait_great_western_ss — 2D game asset, a head-and-shoulders portrait of a steamship company director around 1843, mutton-chop whiskers, black frock coat, top hat in hand, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_admiralty_steam** – the Admiralty (Epoche 9–10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_admiralty_steam — 2D game asset, a head-and-shoulders portrait of a Royal Navy captain around 1845, dark blue frock coat with gold epaulettes, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_britannia_bridge** – the Britannia Bridge works (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_britannia_bridge — 2D game asset, a head-and-shoulders portrait of a bridge works resident engineer around 1848, top hat, plaid waistcoat, holding riveting plans, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_crystal_palace** – Fox, Henderson & Co. (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter
```
portrait_crystal_palace — 2D game asset, a head-and-shoulders portrait of a building contractor around 1851, prosperous, top hat, grey frock coat, a drawing of a glass-and-iron hall, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_john_brown** – John Brown & Co. of Sheffield (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_john_brown — 2D game asset, a head-and-shoulders portrait of a Sheffield steel magnate around 1865, grey beard, black frock coat, gold watch chain, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_armstrong_elswick** – Armstrong's ordnance works at Elswick (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_armstrong_elswick — 2D game asset, a head-and-shoulders portrait of an ordnance manufacturer around 1865, white side whiskers, dark frock coat, stern expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_midland_railway** – the Midland Railway (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter
```
portrait_midland_railway — 2D game asset, a head-and-shoulders portrait of a railway general manager around 1868, full beard, black frock coat, railway pocket watch, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_white_star** – the White Star Line (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter
```
portrait_white_star — 2D game asset, a head-and-shoulders portrait of a shipping line owner around 1870, neat beard, dark double-breasted coat, a ship model behind him, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_hornsby** – Hornsby the agricultural engineers (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter
```
portrait_hornsby — 2D game asset, a head-and-shoulders portrait of an agricultural engineer around 1865, ruddy face, tweed jacket, bowler hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**portrait_coventry_machinists** – the Coventry Machinists Company (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter
```
portrait_coventry_machinists — 2D game asset, a head-and-shoulders portrait of a young bicycle maker around 1870, moustache, waistcoat with rolled sleeves, flat cap, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
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
buttons_leather_brass — Set of 4 game UI buttons, 18th-century georgian style, polished brass with dark leather inlay, blank rectangular icons, flat design, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**frame_wood_iron** – Holzrahmen mit Eisenplatte (Status- und Navigationsleiste) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 31 Wörter
```
frame_wood_iron — 2D UI window frame, 18th-century forge workshop style, dark oak wood frame with brass rivets and iron fittings, game interface panel, front view, orthographic projection, clean edges, isolated on white background --ar 1:1 --no 3d perspective, text, numbers, watermark, border, shadow, photo, 3d render
```

**button_ember** – Glut-Knopf HAMMERN · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 32 Wörter
```
button_ember — 2D game UI button, forged dark iron plate with glowing orange ember cracks, heavy brass border, a hammer-and-gear symbol in the middle, industrial 18th-century style, flat orthographic view, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**ledger_page** – Auftragsbuch-Seite · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Portrait 3:4** · 77 Wörter
```
ledger_page — 2D game asset, a single page of an 18th-century leather-bound ledger book seen from directly above, aged cream parchment with faint brown ruled lines and soft stains, completely empty page, the dark brown leather binding and a few page edges visible along the left side, small brass corner fittings on the right corners, a red ribbon bookmark hanging out at the bottom, hand-painted 2D game art, dark ink outlines, soft even lighting, on pure flat white background --ar 3:4 --no writing, numbers, cast shadow, text, watermark, border, shadow, photo, 3d render
```

**coin_pouch** – Münzbeutel (Geldanzeige) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 24 Wörter
```
coin_pouch — 2D game asset icon, 18th-century leather coin pouch tied with string, filled with old British silver shillings and copper pence, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**coins** – Münzen George III: Guinee, Shilling, Halfpenny · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 27 Wörter
```
coins — Set of 3 antique British coins of George III, one gold guinea, one silver shilling, one copper halfpenny, game item icons, top-down view, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**coins_victoria** – Münzen Victoria: Sovereign, Shilling, Penny (für Epoche 9–10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 39 Wörter
```
coins_victoria — Set of 3 antique British coins of Queen Victoria from the 1850s, one gold sovereign, one silver shilling, one bronze penny, game item icons, top-down view, crisp hand-painted 2D game art, thin dark outlines, on pure flat white background --ar 1:1 --no text other than the coin legends, text, numbers, watermark, border, shadow, photo, 3d render
```

**wax_seals** – Wachssiegel George III und Admiralität · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 32 Wörter
```
wax_seals — Set of red wax seals with royal stamp emblems: one with the royal cipher of King George III, one with the anchor of the Admiralty, game badge icons, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**seal_victoria** – Wachssiegel Victoria (Meilensteine ab Epoche 9) · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 26 Wörter  
*Trägt die falsche Jahreszahl „1775“ (Victoria regierte ab 1837).*
```
seal_victoria — Red wax seal with the royal cipher of Queen Victoria (VR) and a crown, game badge icon, hand-painted 2D game art, on pure flat white background --ar 1:1 --no date, year, text, numbers, watermark, border, shadow, photo, 3d render
```

**pointer_sheet** – Pyrometer-Zeiger · 🟡 von Gemini vorhanden – durch Midjourney ersetzen  
Regler: **Square 1:1** · 17 Wörter
```
pointer_sheet — 2D game asset, antique brass indicator needle, fine clockwork pointer, ornate georgian style, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**pyrometer_dial** – Pyrometer-Zifferblatt ohne Zeiger · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 40 Wörter
```
pyrometer_dial — 2D game asset, an 18th-century brass pyrometer temperature gauge seen exactly from the front, a semicircular arc scale with engraved tick marks, antique clockwork style, dark iron base, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no needle, pointer, numbers, text, watermark, border, shadow, photo, 3d render
```

**stars** – Sterne für die Bewertung (voll und leer) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 36 Wörter
```
stars — 2D game UI icons, two five-pointed stars side by side: one polished gold star with a brass rim, one empty dark iron star outline, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**hourglass** – Sanduhr (Eilaufträge) · ⬜ noch nicht vorhanden (optional)  
Regler: **Square 1:1** · 27 Wörter
```
hourglass — 2D game UI icon, an 18th-century brass and wood hourglass with golden sand, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**trough** – Löschtrog (ab Epoche 4) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 53 Wörter
```
trough — 2D game asset, a wooden quench trough for a blacksmith: a long rectangular oak tub bound with iron bands, filled with dark water whose surface is visible, standing on two short trestles, shown in a straight front view slightly from above, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 2:1 --no steam, tools, text, numbers, watermark, border, shadow, photo, 3d render
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

## H · Werkstatt-Einrichtung (5 je Epoche)

Neu im Spiel: Jede Werkstatt hat fünf Einrichtungsplätze (Brennstoff, Werkzeugwand, Werkbank, Kundschaft, Licht und Lager). Bis die Bilder da sind, zeichnet das Spiel einfache Platzhalter. Freigestellt auf Weiß wie die Werkstücke; Originale nach `assets/source/user_art/furnishings/<id>.png` (über den Eingang). Standard-Modus mit einem Hintergrund der Epoche als Stil-Referenz, damit Licht und Farben zum Raum passen.

### Epoche 1 – Die Dorfschmiede (1700–1715)

**furn_e1_fuel** – Brennstoff: Holzkohlekorb · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 42 Wörter
```
furn_e1_fuel — 2D game asset, a woven wicker basket full of charcoal, early 18th-century English village smithy, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e1_tools** – Werkzeugwand: Zangenbrett · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 48 Wörter
```
furn_e1_tools — 2D game asset, a wooden board hung on a wall with four pairs of blacksmith's tongs and two hammers, around 1700, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e1_bench** – Werkbank: Schleifstein mit Kurbel · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 45 Wörter
```
furn_e1_bench — 2D game asset, a hand-cranked sandstone grindstone in a simple oak frame with a water trough, around 1700, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e1_trade** – Kundschaft: Bemaltes Brett mit Hufeisen über dem Tor · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 49 Wörter
```
furn_e1_trade — 2D game asset, a weathered painted wooden shop board with an iron horseshoe nailed on it, hanging from two chains, around 1700, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e1_light** – Licht und Lager: Talglaterne · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 43 Wörter
```
furn_e1_light — 2D game asset, a small tin tallow lantern with horn panes, hanging from an iron hook, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 2 – Kutschen & Handelswege (1715–1735)

**furn_e2_fuel** – Brennstoff: Kohlenkiste · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 43 Wörter
```
furn_e2_fuel — 2D game asset, an iron-bound wooden coal chest full of coal, with a shovel, around 1725, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e2_tools** – Werkzeugwand: Werkzeugwand mit Gesenken · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 43 Wörter
```
furn_e2_tools — 2D game asset, a wooden tool wall with tongs, swages and fullers on pegs, around 1725, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e2_bench** – Werkbank: Werkbank mit Schraubstock · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 41 Wörter
```
furn_e2_bench — 2D game asset, a heavy oak workbench with a blacksmith's leg vice, around 1725, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e2_trade** – Kundschaft: Schild „Smith & Farrier“ an der Straße · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 46 Wörter
```
furn_e2_trade — 2D game asset, a painted hanging inn-style sign board showing a horseshoe and a hammer, wrought-iron bracket, around 1725, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e2_light** – Licht und Lager: Stabeisenregal · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 40 Wörter
```
furn_e2_light — 2D game asset, a wooden rack holding long iron bars of different sections, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 3 – Hafen & Royal Navy (1735–1750)

**furn_e3_fuel** – Brennstoff: Kohlenschütte · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 46 Wörter
```
furn_e3_fuel — 2D game asset, a wooden coal chute with a heap of coal at its foot, naval dockyard around 1740, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e3_tools** – Werkzeugwand: Gesenkblock · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 46 Wörter
```
furn_e3_tools — 2D game asset, a square cast-iron swage block with many holes and shaped grooves standing on a wooden stand, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e3_bench** – Werkbank: Werkbank mit Feilen · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 44 Wörter
```
furn_e3_bench — 2D game asset, a tarred oak workbench with a vice and a row of files, around 1740, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e3_trade** – Kundschaft: Anschlagtafel der Admiralität · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 46 Wörter
```
furn_e3_trade — 2D game asset, a wooden notice board with pinned paper orders and an anchor emblem, around 1740 (blank papers), single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e3_light** – Licht und Lager: Schiffslaterne · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 39 Wörter
```
furn_e3_light — 2D game asset, a brass and copper ship's lantern with glass panes, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 4 – Stahl & Tuch (1750–1765)

**furn_e4_fuel** – Brennstoff: Koksvorrat · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 39 Wörter
```
furn_e4_fuel — 2D game asset, a timber bin filled with grey coke, around 1755, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e4_tools** – Werkzeugwand: Zangenreihe für Klingen · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 46 Wörter
```
furn_e4_tools — 2D game asset, a wall rack with a long row of slender tongs for knife blades, Sheffield around 1755, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e4_bench** – Werkbank: Schleifbock mit Wasserrad · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 50 Wörter
```
furn_e4_bench — 2D game asset, a grinding bench with a large round grindstone driven by a belt from a small water wheel, Sheffield around 1755, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e4_trade** – Kundschaft: Firmenmarke der Cutlers' Company · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 43 Wörter
```
furn_e4_trade — 2D game asset, a carved wooden plaque with a simple cutler's mark (crossed blades), around 1755, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no lettering, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e4_light** – Licht und Lager: Öllampen · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 42 Wörter
```
furn_e4_light — 2D game asset, a row of three small brass oil lamps on a wooden shelf, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 5 – Das Zeitalter des Dampfes (1765–1785)

**furn_e5_fuel** – Brennstoff: Kohlenhund · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 41 Wörter
```
furn_e5_fuel — 2D game asset, a small four-wheeled wooden coal tub full of coal, around 1780, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e5_tools** – Werkzeugwand: Werkzeugwand mit Setzhämmern · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 44 Wörter
```
furn_e5_tools — 2D game asset, a wooden tool wall with set hammers, flatters and swages on pegs, around 1780, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e5_bench** – Werkbank: Drehbank mit Fußantrieb · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 43 Wörter
```
furn_e5_bench — 2D game asset, a wooden treadle lathe with a foot pedal and a flywheel, around 1780, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e5_trade** – Kundschaft: Schreibpult mit Auftragsbuch · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 48 Wörter
```
furn_e5_trade — 2D game asset, a tall wooden writing desk with an open leather order book and a quill, around 1780 (blank pages), single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e5_light** – Licht und Lager: Stabeisenlager · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 40 Wörter
```
furn_e5_light — 2D game asset, a stack of wrought-iron bars and plates on timber bearers, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 6 – Das Zeitalter der Eisenwerke (1785–1800)

**furn_e6_fuel** – Brennstoff: Koksbunker · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 41 Wörter
```
furn_e6_fuel — 2D game asset, a brick coke bunker with a wooden hatch, ironworks around 1790, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e6_tools** – Werkzeugwand: Gesenksatz · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 44 Wörter
```
furn_e6_tools — 2D game asset, a set of iron swages and dies arranged on a wooden rack, around 1790, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e6_bench** – Werkbank: Schraubstockbank · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 41 Wörter
```
furn_e6_bench — 2D game asset, a long workbench with two vices and iron tools, around 1790, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e6_trade** – Kundschaft: Kontor mit Schreiber · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 43 Wörter
```
furn_e6_trade — 2D game asset, a small wooden counting-house booth with a sloped desk and ledgers, around 1790, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e6_light** – Licht und Lager: Öllampenreihe · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 41 Wörter
```
furn_e6_light — 2D game asset, a row of three hanging oil lamps on an iron bar, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 7 – Krieg & Erfindergeist (1800–1820)

**furn_e7_fuel** – Brennstoff: Kohlenaufzug · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 45 Wörter
```
furn_e7_fuel — 2D game asset, a wooden coal hoist with a rope, pulley and a coal bucket, London around 1810, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e7_tools** – Werkzeugwand: Normallehren und Schablonen · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 43 Wörter
```
furn_e7_tools — 2D game asset, a wall board with iron templates, gauges and squares, engineering works around 1810, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e7_bench** – Werkbank: Werkbank mit Messschraube · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 43 Wörter
```
furn_e7_bench — 2D game asset, a cast-iron workbench with a vice and a brass bench micrometer, around 1810, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e7_trade** – Kundschaft: Messingschild am Tor · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 42 Wörter
```
furn_e7_trade — 2D game asset, a polished brass name plate on a dark wooden board, around 1810, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no lettering, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e7_light** – Licht und Lager: Gaslicht · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 45 Wörter
```
furn_e7_light — 2D game asset, an early gas lamp on a wall bracket with a glass globe, London around 1812, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 8 – Eisenbahnfieber (1820–1839)

**furn_e8_fuel** – Brennstoff: Kohlenwagen auf Schienen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 44 Wörter
```
furn_e8_fuel — 2D game asset, a small iron coal wagon on a short piece of rail track, around 1830, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e8_tools** – Werkzeugwand: Gesenke für Kupplungen · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 43 Wörter
```
furn_e8_tools — 2D game asset, a rack with heavy swages and dies for railway coupling links, around 1830, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e8_bench** – Werkbank: Prüfbank · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 44 Wörter
```
furn_e8_bench — 2D game asset, a cast-iron proving bench for testing chains, with a lever and weights, around 1830, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e8_trade** – Kundschaft: Anschlag der Eisenbahngesellschaft · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 44 Wörter
```
furn_e8_trade — 2D game asset, a wooden notice board with a railway company poster showing a locomotive, around 1830, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no lettering, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e8_light** – Licht und Lager: Gaslicht · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 42 Wörter
```
furn_e8_light — 2D game asset, a cast-iron gas lamp on a wall bracket with a glass globe, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 9 – Der Dampfhammer (1839–1860)

**furn_e9_fuel** – Brennstoff: Bunker mit Schütte · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 41 Wörter
```
furn_e9_fuel — 2D game asset, a riveted iron coal bunker with a chute, foundry around 1845, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e9_tools** – Werkzeugwand: Drehkran · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 42 Wörter
```
furn_e9_tools — 2D game asset, a small cast-iron jib crane with a chain hoist, foundry around 1845, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e9_bench** – Werkbank: Prüfbank mit Lehren · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 40 Wörter
```
furn_e9_bench — 2D game asset, a cast-iron proving bench with gauges and callipers, around 1845, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e9_trade** – Kundschaft: Telegraf · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 42 Wörter
```
furn_e9_trade — 2D game asset, an early electric needle telegraph instrument in a wooden case, around 1845, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no lettering, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e9_light** – Licht und Lager: Gaslaternen · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 39 Wörter
```
furn_e9_light — 2D game asset, two gas lamps with glass globes on iron brackets, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 10 – Das Stahlzeitalter (1860–1880)

**furn_e10_fuel** – Brennstoff: Gasgenerator · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 44 Wörter
```
furn_e10_fuel — 2D game asset, a riveted iron gas producer with pipes and a valve wheel, steelworks around 1870, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e10_tools** – Werkzeugwand: Laufkran · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 45 Wörter
```
furn_e10_tools — 2D game asset, a section of an overhead travelling crane with a hook and chain, steelworks around 1870, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e10_bench** – Werkbank: Werkstoff-Prüfmaschine · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 44 Wörter
```
furn_e10_bench — 2D game asset, a large horizontal materials testing machine with a lever, weights and dial, around 1870, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e10_trade** – Kundschaft: Kontor mit Telegraf · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 42 Wörter
```
furn_e10_trade — 2D game asset, a small office desk with a telegraph key and sounder, around 1870, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

**furn_e10_light** – Licht und Lager: Gaslicht und Bogenlampe · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 41 Wörter
```
furn_e10_light — 2D game asset, an early electric arc lamp in an iron frame, around 1878, single object, straight front view from slightly above, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no people, text, numbers, watermark, border, shadow, photo, 3d render
```

