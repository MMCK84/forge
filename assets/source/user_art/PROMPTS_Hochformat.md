# Prompt-Heft: alle Bilder des Spiels

Vollständige Liste aller Grafiken mit Prompt und Status. Erzeugt mit `python tools/content/gen_prompt_book.py` – nach jeder Lieferung und jeder neuen Erkenntnis neu erzeugt, damit Status und Prompts aktuell sind.

**Status je Bild:**

- ⬜ noch nicht vorhanden – Prompt verwenden und liefern
- 🟡 von Gemini vorhanden – durch Midjourney ersetzen – ist im Spiel, soll später ersetzt werden
- 🟠 von Midjourney vorhanden – sollte noch verändert werden – der Hinweis darunter sagt, was
- ✅ gut (Midjourney) – fertig

**Kürzel:** Jedes Bild hat ein Kürzel (z. B. `W2-3`, `BG4`, `E1-2`), das ganz vorn im Prompt steht. Die Datei beim Hochladen einfach so nennen (`W2-3.png`) – ich sortiere sie anhand des Kürzels ein.

**Bildquelle:** Bis zum 20.11.2026 Gemini, seitdem **Midjourney**. Prompts in Midjourney-Schreibweise: Verbote hinter `--no`, Seitenverhältnis hinter `--ar`. Herkunft und Bewertung je Bild: `provenance.json`.

## Übersicht

| Status | Anzahl |
|---|---|
| ✅ gut (Midjourney) | 163 |
| 🟠 von Midjourney vorhanden – sollte noch verändert werden | 12 |
| 🟡 von Gemini vorhanden – durch Midjourney ersetzen | 0 |
| ⬜ noch nicht vorhanden | 113 |
| ⬜ noch nicht vorhanden (optional) | 34 |

| Bereich | ✅ gut | 🟠 ändern | 🟡 Gemini | ⬜ fehlt | ⬜ optional |
|---|---|---|---|---|---|
| A · Werkstatt-Hintergründe | 11 | 0 | 0 | 0 | 0 |
| B · Essen | 6 | 0 | 0 | 0 | 0 |
| C · Amboss und Hämmer | 6 | 0 | 0 | 0 | 0 |
| D · Maschinen | 13 | 1 | 0 | 0 | 0 |
| E · Werkstücke | 58 | 3 | 0 | 20 | 0 |
| F · Kundenporträts | 20 | 0 | 0 | 0 | 34 |
| G · Oberfläche, Symbole, Store | 23 | 0 | 0 | 4 | 0 |
| H · Werkstatt-Einrichtung | 18 | 8 | 0 | 24 | 0 |
| I · Rohformen für den Stufensprung | 8 | 0 | 0 | 65 | 0 |

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
| 20.11. | Essen | Esse Stufe 3 (neu) und Siemens-Ofen: Inhalt gelungen (zwei Bälge mit Hebel bzw. genieteter Gasofen), aber trotz `--no smoke` Rauch über dem Schornstein | „the chimney top is clean (no smoke)“; den Rest schneidet der Import weg (`FORGE_SMOKE`), das Spiel erzeugt eigenen Rauch |
| 20.11. | alle Frontal-/Seitenansichten | Midjourney malt freigestellte Objekte häufig perspektivisch, obwohl „front view“ im Prompt steht | Ansicht ganz an den Anfang: „Flat orthographic front/side elevation, like a technical drawing“ + `--no perspective, isometric view, three-quarter view, angled view, vanishing point`; dazu ein gelungenes frontales Bild (auch das alte Gemini-Bild) als **Bild-Prompt** mit `--iw 1` – das überträgt die Blickrichtung am zuverlässigsten |
| 20.11. | Maschinenteile | neuer Hammerbalken mit Lager am Ende (statt bei einem Drittel), neues Gestell mit mittigem Lagerbock | historisch richtig (Brust-Schwanzhammer); Lager, Hammerkopf und Gestell-Lager misst jetzt der Import, das Spiel skaliert passend – Prompt bleibt |
| 20.11. | Werkstücke | Hemmschuh (Epoche 2) kam als Stab mit Haken und Öse – von oben ist eine Kufe nicht zu erkennen; Werkstücke wieder fotorealistisch auf grauem Grund mit Schatten | Hemmschuh in Seitenansicht mit genauer Form (Sohle, aufgebogene Spitze wie eine Schlittenkufe, Ring mit Kette); grauer Grund und Schatten stören nicht (Import stellt frei, das Spiel färbt selbst) |
| 21.11. | Einrichtung | Schleifstein (E1-3) in strenger Seitenansicht: technischer Unsinn – Kurbel auf der Steinfläche, Lagerbock vor dem Stein, Achse ohne Lager; in reiner Seitenansicht liegen Achse und Lager hinter dem Stein, Midjourney erfindet dann etwas | Mechanik mit Achse (Schleifstein, Schleifbank) Bauteil für Bauteil beschreiben (Achse durch die Mitte, Achsenden in Lagerböcken auf den Seitenholmen, Stein taucht in den Trog, Kurbel am Achsende, „mechanically correct“) und eine **leichte Dreiviertelansicht** erlauben – die Einrichtung steht im Raum, der selbst perspektivisch gemalt ist; flach bleiben nur Esse, Amboss, Hämmer, Maschinen und Werkstücke |
| 21.11. | Einrichtung | Schleifstein (E1-3) kam immer perspektivisch: Der Prompt verlangte zugleich „orthographic front elevation“ und „front view from slightly above“ – das „von oben“ erzeugt die Schrägsicht | „from slightly above“ aus allen Einrichtungs-Prompts entfernt („front view at eye level“); runde Teile (Schleifstein, Räder, Schwungrad) „seen exactly from the side so that … is a perfect circle“ wie beim Wasserrad (M1), das so sofort flach kam; hilft das nicht: M1 als Bild-Prompt mit `--iw 0.5` anhängen |
| 21.11. | Siegel | Wachssiegel George III (U9) kam als Doppeladler – das ist ein ausländisches Wappen | Motiv als Buchstaben-Monogramm beschreiben („crowned monogram GR“) und „no eagle, no coat of arms“ ergänzen |
| 21.11. | Einrichtung/Werkstücke | Talglaterne (E1-5) kam als Sturmlaterne mit Glaszylinder (ab etwa 1850); Pflugschar (W1-6) kam symmetrisch wie eine Kelle | Zeittypische Form genau benennen und die naheliegende moderne Verwechslung ausschließen („no glass globe, not a kerosene lamp, not a hurricane lantern“; „not a trowel, not a spearhead, not symmetric“) |
| 21.11. | Werkstücke | Ruderfingerling (W3-7) kam als dünner, schräger Spieß ohne Bandeisen und Bolzenlöcher; eine Schere kam mit Fingerringen statt als Federschere | Form mit einem bekannten Umriss beschreiben („shaped like a capital letter L turned on its side“), Verwechslungen ausdrücklich ausschließen („not a thin spike, not diagonal“, „no finger rings, not scissors“) |
| 20.11. | Porträts | Müller von Upton (P1-4) kam als Frau mit Haube statt als fröhlicher, mehlbestäubter Müller | bei mehrdeutigen Berufen „(a man)“ bzw. „(a woman)“ ausdrücklich in die Beschreibung |
| 21.11. | Rohformen (Bereich I) | W1-1R mit fertigem Nagel als Bild-Prompt und `--iw 1.5` ergab wieder den fertigen Nagel (Kopf und Spitze) | Rohform = Stand nach dem ersten Arbeitsgang, je Werkstück beschrieben; was spätere Arbeitsgänge formen (Spitze, Kopf, Biegung, Löcher, Verdrillung) als `--no`; Bild-Prompt nur noch `--iw 0.5` |
| 21.11. | Einrichtung, Behälter | E2-1 „Kohlenkiste mit Eisenbeschlag“ kam als Schatztruhe (gewölbter Deckel, Schlüsselschild, glänzende Kohle) | Behälter als schlichte offene Kiste/Kasten ohne Deckel beschreiben, `--no treasure chest, domed lid, lock, keyhole, ornament`, Kohle „matt“ |
| 21.11. | Titelbild / Schlüsselbilder | U22: „oberes Drittel frei für den Titel“ ignoriert (Hammer oben), Schmied links statt mittig – im Hochformat abgeschnitten | Hauptfigur „centred in the middle third of the width“ verlangen; freie Titelfläche nicht verlassen – das Spiel legt den Titel auf einen dunklen Verlauf und wählt den Ausschnitt (TITLE_FOCUS) |
| 21.11. | Lampen und Laternen bis ~1850 | E3-5, E4-5, E6-5 kamen als Petroleum-/Sturmlaternen mit Glaskolben bzw. Glaszylinder (erst ab ~1850) | Kerze hinter flachen Glas- oder Hornscheiben bzw. offene Tüllenlampe beschreiben; `--no glass globe, glass chimney, kerosene lamp, hurricane lantern, fuel tank` |
| 21.11. | Einrichtung | E4-5 und E5-5 kamen als mehrere Varianten in einem Bild (zwei Regale, fünf Stapel) | „one single object only (no variations, no second version)“ in allen Einrichtungs-Prompts; Format nach dem Objekt wählen (liegender Stapel: 2:1) |
| 21.11. | Einrichtung | E6-1 Koksbunker sah aus wie ein Backofen (Gewölbe, Tür), E6-4 Kontor als leerer Schrank, E4-2 Zangen wie Spieße | Form und Bestandteile ausdrücklich nennen (offene Ziegelbucht, Pult mit Hauptbuch, zweischenklige Zangen) und Verwechslungen ausschließen (`not an oven, no arch`, `no wardrobe`) |
| 21.11. | Werkstücke | W9-1 Brückenniete kam trotz „seen from the side“ immer von oben – im selben Prompt stand „top-down view, lying flat“ (auch bei drei weiteren Prompts der Epochen 7–10) | Der Generator entfernt bei Seitenansicht jede Draufsicht-Angabe und setzt „seen exactly from the side (not from above)“ und die Seitenansicht an den Anfang |
| 21.11. | Maschinen (Ladenbilder) | ML1 Wasser-Schwanzhammer: Rad ohne Schaufeln, mit Riemen und Zahnrädern – wirkte wie eine Dampf-/Transmissionsanlage | Wasserrad mit vielen Schaufeln im Wassergerinne und Daumenwelle beschreiben; `--no belts, gear wheels, flywheel, steam engine` |

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

**Gegen perspektivische Bilder** (Midjourney ignoriert „front view“ oft): (1) ein Bild mit der richtigen Blickrichtung als **Bild-Prompt** vor den Text setzen und `--iw 1` anhängen – am besten das bisherige Bild desselben Objekts (auch Gemini) oder ein gelungenes Bild derselben Gruppe; (2) Stylization niedrig lassen (ca. 10 %, notfalls `--s 50`); (3) wenn es dann noch kippt: Raw einschalten **und** ein gezeichnetes Bild als Stil-Referenz `--sref` anhängen, damit es nicht fotorealistisch wird. Leicht perspektivische Bilder lieber trotzdem schicken – oft reicht es im Spiel (z. B. die Schabotte).


## Regeln für alle Bilder

- Freigestellt auf **reinem Weiß**, ohne Schatten, ohne Text, ohne Jahreszahlen, ohne Wasserzeichen.
- Objekt vollständig im Bild mit etwas Rand.
- Dateiname = das fett gedruckte Kürzel (z. B. `W1-4.png`); das unveränderte Original (PNG) über GitHub in `assets/source/user_art/eingang/` hochladen – Bilder im Chat werden verkleinert.
- Einheitlicher Stil: handgemalt, dünne dunkle Tuschekontur, warme Malstruktur.
- Midjourney: Prompt komplett kopieren (inkl. `--ar` und `--no`); Einstellungen je Gruppe siehe oben.
- Für einheitlichen Stil: ein gelungenes Bild als Stil-Referenz verwenden (`--sref <Bild-URL>`).

## Reihenfolge (was am meisten bringt)

Erledigt: alle zehn Hintergründe (A), alle sechs Essen (B), Amboss und Hämmer (C), alle Maschinenteile (D).

Erledigt (21.11.): **alle Bilder der Epoche 1** – Einrichtung, Werkstücke, Rohformen W1-1R–W1-8R, Oberfläche U1–U23.

**Jetzt:**

1. **BG0 Lehrwerkstatt des Meisters** – die Werkstatt der Lehrzeit (danach zieht man in die eigene Dorfschmiede BG1). BG1 als Stil-Referenz anhängen, gleiche Bodenhöhe wie BG1; 1:1, Upscale 2×.
2. **U24 Zunfttafel Ruf 2** (2 Sterne) – zuerst; dann **U25–U27** mit U24 als Bild-Prompt (`--iw 1`), damit alle vier Tafeln gleich aussehen. Ersetzt die gezeichnete Tafel mit den gelben Punkten.

Danach:

1. **Werkstücke** der übrigen Epochen (E) – Standard-Modus mit Stil-Referenz (nicht Raw).
2. **Löschtrog** (U15) für Epoche 4 und die Einrichtung der übrigen Epochen (H).
3. Die übrigen 🟡 Gemini-Bilder ersetzen – gleiche Dateinamen.
4. Optional: Porträts (F), Victoria-Münzen, Sanduhr, Pyrometer-Zifferblatt.

## A · Werkstatt-Hintergründe (1:1 – für Hoch- und Querformat)

Esse, Amboss und Maschinen stellt das Spiel davor – der Raum bleibt leer. Wand-Boden-Kante bei etwa 55–60 % der Höhe, unteres Drittel ruhig und dunkel (Bedienelemente).

**Format 1:1 (Regler: Square 1:1), danach Upscale 2× (Subtle) und erst das vergrößerte Bild (2048 × 2048) schicken** – ohne Upscale sind es nur 1024 × 1024. Ein Bild für beide Ausrichtungen: Im Hochformat nimmt das Spiel den mittleren 3:4-Ausschnitt (die äußeren Achtel links und rechts fallen weg) und verlängert den dunklen Boden nach unten; im Querformat (Tablet, später) die volle Breite. Deshalb gehören Fenster und alles Wichtige in die mittleren drei Viertel. Mindestgröße nach dem Upscale: 1440 × 1440 Pixel. Hilfreich: die Vorlage `assets/source/user_art/vorlagen/bildaufbau_hintergrund.png` (1:1) als **Bild-Prompt** vor den Text setzen (nicht als Stil-Referenz) und ein gelungenes Midjourney-Bild als Stil-Referenz. Ich messe die Kante bei jedem Bild aus (50–70 % geht; liegt sie tiefer, schneidet der Import oben Decke ab).

**BG0** – Lehrwerkstatt des Meisters (Lehrzeit, vor der eigenen Dorfschmiede) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 124 Wörter · Datei `background_0`  
*21.11.: Lehrwerkstatt des Meisters: Fachwerk über Steinsockel, Steinplatten, Marktkreuz im Fenster, Werkzeugregale an den Rändern; Kante ca. 71 % wie BG1. Im Hochformat fallen die Regale an den Rändern weg – Wirkung im Spiel wird mit der Umsetzung von Nr. 15 geprüft. Wie BG1 aufbauen (gleiche Höhe der Wand-Boden-Kante, ca. 70 %), aber reicher: das ist die Werkstatt, in der man lernt. BG1 als Stil-Referenz verwenden, damit Licht und Malweise gleich bleiben.*
```
BG0 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Master smith's workshop in an English market town around 1700, richer than a village smithy: dressed stone lower wall, half-timbered upper wall, clean flagstone floor. Through the small window: market square with a stone cross. Edges: neatly racked tools, shelf with finished ironwork --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG1** – Die Dorfschmiede (1700–1715) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 111 Wörter · Datei `background_1`  
*20.11.: Variante 4 als Original (PNG 2048 × 2048): kein Streifen, große freie Putzfläche hinter der Esse, Fenster mit Kirchturm in den mittleren drei Vierteln, Werkzeug und Hufeisen an den Rändern. Kante tief (73 %, Bühne y 1053), wirkt im Spiel aber gut. Tageslicht statt Feuerschein – unkritisch.*
```
BG1 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. English village smithy around 1700: half-timbered wall with whitewashed daub, earth floor with straw. Through the small window: green fields, hedge, church tower. Edges: tongs rack, horseshoes on a beam --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG2** – Kutschen & Handelswege (1715–1735) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 114 Wörter · Datei `background_2`  
*20.11.: 1:1, PNG 2048 × 2048, nachgeschärfter Prompt: Abendstimmung mit Feuerschein in der Wandmitte, Bruchstein, Steinplatten, Rad und Geschirr an den Rändern. Kante 69 % (Bühne y 991). Zweites, großes Fenster rechts der Mitte steht teils hinter der Esse, die Postkutsche darin ist kaum zu sehen – im Spiel unauffällig.*
```
BG2 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Roadside smithy on an English coaching road around 1725: rough grey stone wall, timber beams, worn flagstones. Through the small window: dirt road with a stagecoach. Edges: spare coach wheel, harness on pegs --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG3** – Hafen & Royal Navy (1735–1750) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 118 Wörter · Datei `background_3`  
*20.11.: 1:1, PNG 2048 × 2048. Hafen: Ziegel, geteerte Balken, Dielen, Fass, Tau und Kette an den Rändern; Kante 58 % (Bühne y 833). Aussichtsfenster mit Schiffsmasten rechts am Rand, im Hochformat angeschnitten – wirkt trotzdem gut.*
```
BG3 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Harbour smithy in a Royal Navy dockyard around 1740: red brick, tarred timber beams, tarred plank floor. Through the small window: masts and furled sails of a ship of the line. Edges: barrel, coiled rope, heavy chain --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG4** – Stahl & Tuch (1750–1765) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 111 Wörter · Datei `background_4`  
*20.11.: 1:1, PNG 2048 × 2048. Sheffield: Ziegel, Steinplatten, Fenster mit rauchenden Schornsteinen; Kante 60 % (Bühne y 867). Eher dunkel und kühl.*
```
BG4 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Smith's and cutler's workshop in Sheffield around 1755: soot-darkened brick, worn stone slabs. Through the small window: rooftops with smoking chimneys. Edges: bolts of dyed wool, shelf with knife blades --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG5** – Das Zeitalter des Dampfes (1765–1785) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 118 Wörter · Datei `background_5`  
*20.11.: 1:1, PNG 2048 × 2048. Severn: Iron Bridge im Fenster, nasser Steinboden; Kante 68 % (Bühne y 984). Gemaltes Feuer in der Wandmitte steht hinter der Esse und fällt im Spiel kaum auf.*
```
BG5 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Forge of a water-powered hammer works in the Severn Gorge around 1780: brick wall, oak beams, wet stone floor. Through the small window: the cast-iron Iron Bridge in a wooded gorge. Right third of the floor empty --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG6** – Das Zeitalter der Eisenwerke (1785–1800) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 115 Wörter · Datei `background_6`  
*20.11.: 1:1, PNG 2048 × 2048. Eisenwerk: gusseiserne Säulen, Hochöfen im Fenster; Kante 65 % (Bühne y 932).*
```
BG6 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Smithy of a large English ironworks around 1790: dark brick wall, cast-iron columns, iron floor plates with coke dust. Through the small window: glowing blast furnaces at dusk. Right third of the floor empty --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG7** – Krieg & Erfindergeist (1800–1820) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 112 Wörter · Datei `background_7`  
*20.11.: 1:1, PNG 2048 × 2048. London: gelber Ziegel, Steinplatten; St Paul's im Fenster am rechten Rand (im Hochformat angeschnitten); Kante 56 % (Bühne y 812). Ersetzt die frühere Fassung mit zu hohem Fenster.*
```
BG7 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. London engineering smithy in Lambeth around 1810: smoke-blackened yellow brick, York stone floor. Through the small window: the Thames with barges, dome of St Paul's. Edges: iron bars, rack with templates --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG8** – Eisenbahnfieber (1820–1839) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 113 Wörter · Datei `background_8`  
*20.11.: 1:1, PNG 2048 × 2048. Newcastle: zugemauerte Bögen, Lokomotive im Tor, Räder und Ketten an den Rändern; Kante 57 % (Bühne y 827).*
```
BG8 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Locomotive smithy in Newcastle around 1830: dark red brick with bricked-up arches and tie-rod plates, cinder floor. Through the small window: early steam locomotive with coal wagons. Edges: locomotive wheels, coupling chains --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG9** – Der Dampfhammer (1839–1860) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 114 Wörter · Datei `background_9`  
*20.11.: 1:1, PNG 2048 × 2048. Gießerei: hohe Ziegelwand mit Säulen, Rundbogenfenster; Kante 70 % (Bühne y 1005). Gemaltes Feuer in der Wandmitte hinter Esse und Dampfhammer.*
```
BG9 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Forge shop of a great engineering foundry around 1845: tall soot-stained brick, cast-iron columns, iron floor plates. Through the small window: canal with a narrowboat, foundry chimneys. Right third of the floor empty --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

**BG10** – Das Stahlzeitalter (1860–1880) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 115 Wörter · Datei `background_10`  
*20.11.: 1:1, PNG 2048 × 2048. Stahlwerk: Eisenbinder, Kranbahn, Bessemer-Funken im Fenster. Kante sehr tief (84 %): der Import schneidet oben 300 px Decke ab (Bühne y 1000).*
```
BG10 — Square 2D game background, hand-painted, dark ink outlines. Evening but well lit, warm orange firelight glowing on the centre of the back wall. Empty room seen from a high viewpoint: ceiling beams at the top, the floor fills the lower half of the image and reaches the bottom edge. Only one small window, just below the beams, left of centre. The centre of the back wall is free of posts and windows. Props only at the far left and right edges. Sheffield steelworks forge around 1870: very tall dark brick wall, iron roof trusses, crane rail, iron floor plates. Through the small window: Bessemer converters blowing sparks at night. Right third of the floor empty --ar 1:1 --no forge, fire, fireplace, flames, anvil, machine, people, daylight beam, second window, text, numbers, watermark, black band, border
```

## B · Essen (Frontalansicht, alle sechs Stufen)

Frontal und symmetrisch, leicht von oben: Das Glutbett ist ein waagerechter Streifen über etwa 60 % der Breite, damit die Werkstücke gleichmäßig nebeneinander liegen. Blasebalg bzw. Gebläse immer links. Format 2:1, weißer Grund. Originale nach `assets/source/user_art/forges/<id>.png` – Glutbett, Schornstein und Lage misst der Import selbst.

**F1** – Lehm-Esse (Stufe 1, Epoche 1) – ohne Blasebalg, der bewegliche Blasebalg BB steht daneben · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 119 Wörter · Datei `forge_clay`  
*20.11.: Frontalansicht, offener Herdtisch mit Lehmhaube, Blasebalg links auf Bank. Glutbett schmal (~25 % der Breite) – für einen Platz ausreichend. 21.11.: bleibt – der Import blendet den oberen Teil des Sack-Blasebalgs aus, den Rest verdeckt der bewegliche Blasebalg BB auf der Bank. Die neue Fassung ohne Blasebalg (Bogen über dem Feuer, wirkt wie ein Ofen/Kamin) liegt im Archiv (archiv/forge_clay_v2_bogen.png).*
```
F1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a small rustic early-18th-century village forge, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of clay and rough fieldstones, a simple clay-plastered hood with a short chimney, a short iron blast pipe (tuyère) entering the hearth from the left side, nothing to the left of the hearth, orange glowing charcoal fire, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, the chimney top is clean, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, oven, dome, arch over the fire, bellows, bench, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**F2** – Ziegel-Esse (Stufe 2, Epoche 2) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 146 Wörter · Datei `forge_brick`  
*20.11.: Frontalansicht, Ziegelherd mit Eisenbändern, Schieferdach-Haube, Schornstein rechts; Blasebalg links steht senkrecht statt waagerecht – unkritisch.*
```
F2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a smith's forge of the 1720s, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of red brick bound with iron straps, a brick hood and a square brick chimney, on the left a classic blacksmith's bellows lying horizontally on a low wooden stand: two pear-shaped wooden boards with pleated dark leather between them, a long wooden lever handle, an iron nozzle pointing into the hearth (not a sack, not a vase, not standing upright), bright orange coal fire, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, the chimney top is clean, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, oven, dome, arch over the fire, cannon, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**F3** – Esse mit Doppelblasebalg (Stufe 3, Epoche 3) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 116 Wörter · Datei `forge_double_bellows`  
*20.11.: neu: zwei tropfenförmige Bälge mit Hebel links, Ziegel/Stein mit Eisenbändern, hohes Rohr und Ziegelschornstein. Gemalten Rauch schneidet der Import weg.*
```
F3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a large smith's forge of the 1740s, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of brick and stone, a wide brick hood bound with iron bands, on the left two identical teardrop bellows stacked one above the other, worked by one long lever, hot yellow-orange coal fire, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, the chimney top is clean, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, oven, dome, arch over the fire, cannon, sack, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**F4** – Koks-Esse mit Zylindergebläse (Stufe 4, Epoche 5) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 115 Wörter · Datei `forge_coke`  
*20.11.: Frontalansicht, genietete Eisenhaube, Gebläsezylinder links mit Luftrohr, Rohrschornstein rechts; Flammen etwas hoch – im Spiel unauffällig.*
```
F4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a long late-18th-century coke-fired smith's forge, open waist-high hearth table, coals lying openly on top, hood above with a clear gap, built of cast-iron plates and firebrick, a riveted iron hood and a round iron chimney, on the left an upright cast-iron blowing cylinder with an air pipe into the hearth, brilliant yellow-white coke fire, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, the chimney top is clean, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, oven, dome, arch over the fire, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**F5** – Schweißofen (Stufe 5, Epoche 8) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 94 Wörter · Datei `forge_welding_furnace`  
*20.11.: niedriger Ziegelbogen über langem Glutbett, Schornstein rechts – genau wie gewünscht.*
```
F5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a long 1830s coal-fired welding furnace: a low hearth of firebrick and cast-iron plates bound by iron tie bars, a low brick arch over a long white-hot coal bed, a short square brick chimney, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, the chimney top is clean, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**F6** – Siemens-Gasofen (Stufe 6, Epoche 10) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 102 Wörter · Datei `forge_siemens`  
*20.11.: genieteter Eisenkörper mit Ankerstäben, weißglühende Arbeitsöffnung, Gasleitungen mit Ventilen beidseitig, Schornsteinstutzen. Gemalten Rauch schneidet der Import weg.*
```
F6 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a massive 1870s Siemens regenerative gas furnace: a rectangular firebrick body clad with riveted iron plates and vertical iron buckstays, a wide open working front showing a blinding white-hot hearth, gas pipes with valves at both sides, a squat iron chimney stub, front view from slightly above, wide glowing coal bed, a flat band across about two thirds of the width, hood and chimney centred and fully visible, level bottom edge, hand-painted 2D game art, dark ink outlines, nothing in front, the chimney top is clean, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, floor, smoke, flames, people, text, numbers, watermark, border, shadow, photo, 3d render
```

## C · Amboss und Hämmer

Hämmer in reiner Seitenansicht: Kopf links senkrecht, Bahn unten, Stiel waagerecht nach rechts.

**AN** – Amboss auf Eichenklotz (alle Epochen) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 35 Wörter · Datei `anvil`  
*20.11.: Amboss auf hohem Holzklotz; Horn zeigte nach links – der Import spiegelt ihn. Fotorealistisch statt gezeichnet, passt im Spiel aber gut.*
```
AN — 2D game sprite asset, heavy 18th-century cast iron anvil mounted on a thick oak wood stump, blacksmith equipment, side-view orthographic perspective, horn pointing to the right, crisp clean edges, isolated on white background, game art --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**H1** – Handhammer (Stufe 1) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 87 Wörter · Datei `hammer_hand`  
*20.11.: Handhammer, reine Seitenansicht, Bahn unten – genau wie gewünscht. Fotorealistisch statt gezeichnet; im Spiel klein, fällt kaum auf.*
```
H1 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a simple 18th-century blacksmith's hand hammer in flat side view (orthographic), the plain forged iron head stands upright on the left: flat striking face pointing straight down, short rounded back pointing straight up, the straight ash-wood handle goes through the middle of the head and points horizontally to the right, matte dark iron with hammer marks, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, engraving, text, numbers, watermark, border, shadow, photo, 3d render
```

**H2** – Kreuzschlaghammer (Stufe 2) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 94 Wörter · Datei `hammer_cross_peen`  
*20.11.: Kreuzschlaghammer (Finne oben), reine Seitenansicht, Bahn unten – genau wie gewünscht. Fotorealistisch statt gezeichnet; im Spiel klein, fällt kaum auf.*
```
H2 — Flat orthographic side elevation, like a technical drawing. 2D game asset, an 18th-century cast iron cross-peen blacksmith's hammer in flat side view (orthographic), the head stands upright on the left: square flat striking face pointing straight down, the back of the head tapers to a wedge-shaped cross peen pointing straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, dark cast iron with slight rust, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, engraving, text, numbers, watermark, border, shadow, photo, 3d render
```

**H3** – Hammer mit verstählter Bahn (Stufe 3) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 103 Wörter · Datei `hammer_steel_faced`  
*20.11.: verstählte Bahn mit sichtbarer Schweißnaht, reine Seitenansicht, Bahn unten – genau wie gewünscht. Fotorealistisch statt gezeichnet; im Spiel klein, fällt kaum auf.*
```
H3 — Flat orthographic side elevation, like a technical drawing. 2D game asset, an 18th-century blacksmith's hammer with a steel-faced head in flat side view (orthographic), the head stands upright on the left: dark wrought iron body with a bright polished steel striking face forge-welded onto the bottom, a visible weld line between iron and steel, the striking face points straight down, a wedge-shaped peen points straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, engraving, text, numbers, watermark, border, shadow, photo, 3d render
```

**H4** – Gussstahl-Hammer / Tiegelstahl (Stufe 4) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 93 Wörter · Datei `hammer_crucible`  
*20.11.: Gussstahl mit Messingzwinge und Endkappe, reine Seitenansicht, Bahn unten – genau wie gewünscht. Fotorealistisch statt gezeichnet; im Spiel klein, fällt kaum auf.*
```
H4 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a high-quality late-18th-century crucible steel blacksmith's hammer in flat side view (orthographic), the polished bright steel head stands upright on the left: flat striking face pointing straight down, short flat back pointing straight up, a decorated brass ferrule where the head meets the handle, the straight dark walnut handle points horizontally to the right and ends in a small brass end cap, level, not tilted, hand-painted 2D game art, thin dark ink outline, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, engraving, text, numbers, watermark, border, shadow, photo, 3d render
```

**BB** – Beweglicher Blasebalg neben der Lehm-Esse (Epoche 1, pumpt im Spiel) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 96 Wörter · Datei `bellows`  
*21.11.: Schmiedeblasebalg in Seitenansicht, Lederfalten mit Messingnieten, Düse nach rechts – liegt im Spiel auf der Bank links der Lehm-Esse und pumpt.*
```
BB — Flat orthographic side elevation, like a technical drawing. 2D game asset, a classic early-18th-century blacksmith's hand bellows in a flat side view (orthographic), lying horizontally: two pear-shaped wooden boards one above the other with pleated dark leather between them, the wide end on the left with a short wooden lever handle, the narrow end on the right ending in an iron nozzle pointing straight to the right, brass studs along the leather, hand-painted 2D game art, dark ink outlines, warm painterly texture, not standing upright, not a sack, not a vase, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, stand, bench, shadow, text, numbers, watermark, border, photo, 3d render
```

## D · Maschinen (Einzelteile für die Animation)

Drehteile genau von vorn und kreisrund, Mittelpunkt = Bildmitte; bewegliche Teile einzeln.

**M1** – Wasserrad (Wasser-Schwanzhammer, Epoche 5) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 64 Wörter · Datei `water_wheel`  
*20.11.: unterschlächtiges Wasserrad, acht Speichen, Nabe mittig – dreht sauber.*
```
M1 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single wooden undershot water wheel seen exactly from the side so that it is a perfect circle, eight straight spokes, wooden paddles all around the rim, iron bands and an iron axle hub exactly in the centre of the image, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, water, frame, stand, text, numbers, watermark, border, shadow, photo, 3d render
```

**M2** – Hammerbalken mit Hammerkopf (Epoche 5–8) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 72 Wörter · Datei `helve_beam`  
*20.11.: Lager am Balkenende statt bei einem Drittel – entspricht dem englischen Brust-Schwanzhammer (belly helve); Lager und Kopf misst der Import.*
```
M2 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single helve-hammer beam seen exactly from the side: a long heavy oak beam lying horizontally, bound with iron hoops, a round iron pivot boss with a hole at one third from the left end, a heavy forged iron hammer head fixed at the right end pointing straight down, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, frame, posts, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**M3** – Gestell mit Daumenwelle · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 69 Wörter · Datei `helve_frame`  
*20.11.: Eichengestell mit mittigem Lagerbock und Daumenwelle unten; Lager oben misst der Import.*
```
M3 — Flat orthographic side elevation, like a technical drawing. 2D game asset, the wooden support frame of an 18th-century helve hammer seen exactly from the side: two heavy upright oak posts joined by cross beams, an iron bearing on top of the posts for a pivot, and a horizontal cam shaft with four iron cams at the bottom, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, hammer beam, water wheel, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**M4** – Schwungrad (Dampf-Schwanzhammer, Epoche 6–8) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 62 Wörter · Datei `flywheel`  
*20.11.: gusseisernes Schwungrad mit acht geraden Speichen (statt sechs gebogenen) – unkritisch.*
```
M4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a single cast-iron flywheel of an 18th-century beam engine seen exactly from the front so that it is a perfect circle, six gently curved spokes, a heavy rim, the hub exactly in the centre of the image, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, frame, shaft stand, text, numbers, watermark, border, shadow, photo, 3d render
```

**M5** – Dampfmaschine ohne Balancier und Schwungrad · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 76 Wörter · Datei `engine_body`  
*20.11.: Zylinder mit Kolbenstange, Säule und Ziegelsockel, ohne eingemalten Balancier; Kolbenstange und Säulenkopf misst der Import.*
```
M5 — Flat orthographic side elevation, like a technical drawing. 2D game asset, the body of a Boulton and Watt style beam engine around 1785 seen from the side: a tall vertical cast-iron steam cylinder with a piston rod sticking out of the top, a brick and timber engine bed, a tall cast-iron column on the right that would carry a beam, pipes and valve gear, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, rocking beam, flywheel, smoke, text, numbers, watermark, border, shadow, photo, 3d render
```

**M6** – Balancier · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 69 Wörter · Datei `engine_beam`  
*20.11.: gusseiserner Gitter-Balancier mit Mittellager und Augen an den Enden, flache Seitenansicht.*
```
M6 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single cast-iron rocking beam of an 18th-century beam engine seen from the side: long horizontal beam, thicker in the middle and tapering to both ends, an open lattice pattern, a round pivot hole exactly in the centre and connection eyes at both ends, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, column, engine, text, numbers, watermark, border, shadow, photo, 3d render
```

**M7** – Dampfhammer: Gestell (Epoche 9) · ✅ gut (Midjourney)  
Regler: **Portrait 3:4** · 99 Wörter · Datei `steam_hammer_frame`  
*20.11.: zwei A-Ständer, Querhaupt mit Zylinder, Steuerhebel rechts – frontal. Schmaler als das bisher gezeichnete Gestell, wirkt im Spiel aber gut.*
```
M7 — Flat orthographic front elevation, like a technical drawing. 2D game asset, the frame of an 1840s Nasmyth steam hammer exact front view (orthographic): two tall cast-iron standards shaped like an inverted V on each side, joined at the top by a heavy cross beam that carries a vertical steam cylinder with flanges and a valve chest, a control lever with a handle on the right standard, a tall empty open gap in the middle between the standards where the hammer moves, hand-painted 2D game art, dark ink outlines, dark iron with rivets and bolts, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, hammer head, piston rod, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**M8** – Dampfhammer: Bär mit Kolbenstange · ✅ gut (Midjourney)  
Regler: **Portrait 1:2** · 72 Wörter · Datei `steam_hammer_ram`  
*20.11.: Hammerblock eher klein, die Kolbenstange läuft bis zur Bahn durch; das Spiel zeigt nur den unteren Teil – im Spiel stimmig.*
```
M8 — Flat orthographic front elevation, like a technical drawing. 2D game asset, the moving ram (tup) of an 1840s steam hammer exact front view (orthographic): a long vertical polished piston rod at the top fixed into a heavy rectangular cast-iron hammer block with guide grooves on both sides and a flat steel die at the very bottom, upright and perfectly vertical, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, frame, cylinder, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**M9** – Dampfhammer: Schabotte (Ambossblock) · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 65 Wörter · Datei `steam_hammer_anvil`  
*20.11.: massive Schabotte mit Gesenk, Keilen und Eichenbalken; leicht von oben – im Spiel unauffällig.*
```
M9 — Flat orthographic front elevation, like a technical drawing. 2D game asset, the anvil block (schabotte) of an 1840s steam hammer exact front view (orthographic): a massive squat cast-iron block, wider at the base, with a flat steel die on top held by a dovetail and wedges, set on heavy oak timbers, hand-painted 2D game art, dark ink outlines, dark iron, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, hammer, frame, text, numbers, watermark, border, shadow, photo, 3d render
```

**M10** – Gestell des großen Dampfhammers (Epoche 10) · ✅ gut (Midjourney)  
Regler: **Portrait 3:4** · 79 Wörter · Datei `steam_hammer_large_frame`  
*20.11.: genietete Bogenständer, Zylinder mit Rohren, Plattform mit Geländer – frontal.*
```
M10 — Flat orthographic front elevation, like a technical drawing. 2D game asset, the frame of a huge 1870s double-standard steam hammer exact front view (orthographic): two massive riveted wrought-iron standards forming an arch, a large steam cylinder on top with pipes and valve gear, a platform with railing for the hammer driver, a tall empty open gap in the middle where the hammer moves, hand-painted 2D game art, dark ink outlines, dark iron with rivets, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, hammer head, piston rod, anvil, text, numbers, watermark, border, shadow, photo, 3d render
```

**Ladenbilder der Maschinen** (ganze Maschine als ein Bild, nur für den Laden)

**ML1** – Wasser-Schwanzhammer (Ladenbild) · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Square 1:1** · 84 Wörter · Datei `machine_water_helve`  
*21.11.: Rad ohne Schaufeln, mit Riemen und Zahnrädern – wirkt wie eine Dampf-/Transmissionsanlage; Prompt mit Schaufelrad im Gerinne und Daumenwelle.*
```
ML1 — Flat orthographic side elevation, like a technical drawing. 2D game asset, an 18th-century water-powered helve hammer: a wooden undershot water wheel with many flat paddles on the left, its lower part dipping into a stone water channel, on its axle a wooden cam shaft with iron tappets that lift the beam, a long oak hammer beam with an iron head striking an anvil on a wooden stump on the right, side view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, belts, gear wheels, flywheel, steam engine, text, numbers, watermark, border, shadow, photo, 3d render
```

**ML2** – Dampf-Schwanzhammer (Ladenbild) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 59 Wörter · Datei `machine_steam_helve`  
*20.11.: Ladenbild: Balanciermaschine mit Schwungrad treibt den Schwanzhammer, Amboss rechts – Seitenansicht.*
```
ML2 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a 1790s steam-powered helve hammer: a small beam engine with a flywheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on the right, side view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, text, numbers, watermark, border, shadow, photo, 3d render
```

**ML3** – Nasmyth-Dampfhammer (Ladenbild) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 50 Wörter · Datei `machine_nasmyth`  
*20.11.: Ladenbild: Nasmyth-Dampfhammer frontal mit Ständern, Zylinder, Steuerhebel und Schabotte.*
```
ML3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, an 1840s Nasmyth steam hammer: two cast-iron standards, a steam cylinder on top, the hammer block hanging above a massive anvil block, a control lever, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, text, numbers, watermark, border, shadow, photo, 3d render
```

**ML4** – Großer Dampfhammer (Ladenbild) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 48 Wörter · Datei `machine_great_steam_hammer`  
*20.11.: Ladenbild: großer Dampfhammer mit Bogenständern, Plattform und Treppe.*
```
ML4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a huge 1870s steam hammer with riveted wrought-iron arch standards, a large cylinder, a platform for the driver and a massive anvil block, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, text, numbers, watermark, border, shadow, photo, 3d render
```

## E · Werkstücke (Rohling + 80)

Kalt, nur Metall (kein Holz), von oben, weißer Hintergrund ohne Schatten, quadratisch. Die Glut färbt das Spiel ein.

**W0** – Rohling (alle Epochen) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 69 Wörter · Datei `blank`  
*20.11.: Stabeisen-Rohling, flach von oben.*
```
W0 — 2D game asset, a single piece of rectangular wrought iron bar stock, about eight times as long as it is wide, square cross-section, both ends roughly cut, horizontal from left to right, dark grey wrought iron with mill scale, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 1 – Die Dorfschmiede (1700–1715)

**W1-1** – Nagel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 64 Wörter · Datei `nail`  
*20.11.: geschmiedeter Nagel mit Rosenkopf.*
```
W1-1 — 2D game asset, a single large hand-forged nail with a square tapering shank ending in a sharp point and a faceted hammered rosehead, horizontal with the head on the left, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W1-2** – Hufeisen · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 53 Wörter · Datei `horseshoe`  
*20.11.: Hufeisen mit Nagellöchern, Öffnung unten.*
```
W1-2 — 2D game asset, a single hand-forged horseshoe with a fullered groove and eight square nail holes, opening pointing down, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W1-3** – Haken · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 61 Wörter · Datei `hook`  
*20.11.: S-Haken.*
```
W1-3 — 2D game asset, a single hand-forged S-shaped hanging hook made from round bar, pointed tip on the lower curve, small curled scroll on the upper end, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W1-4** – Türangel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 73 Wörter · Datei `door_hinge`  
*21.11.: Bandscharnier mit Rolle und Speerspitze, Nagellöcher.*
```
W1-4 — 2D game asset, a single hand-forged strap hinge for a cottage door: long flat tapering iron strap with three round nail holes, a rolled eye at the left end and a spade-shaped decorative tip at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W1-5** – Sichel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 71 Wörter · Datei `sickle`  
*21.11.: Sichelblatt mit eingerollter Angel – liest sich klar als Sichel.*
```
W1-5 — 2D game asset, a single hand-forged sickle blade without handle: wide crescent-shaped thin steel blade with a smooth ground inner edge and a short pointed bare tang on the left, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W1-6** – Pflugschar · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 94 Wörter · Datei `ploughshare`  
*21.11.: zweite Fassung: asymmetrische Schar mit gerader Oberkante, geschwungener Schneide und Tülle.*
```
W1-6 — 2D game asset, a single hand-forged ploughshare for a wooden plough: an asymmetric triangular iron share, the top side a straight thick landside, the lower side a long curved cutting edge sweeping back into a wing, sharp point on the right, a short socket with two bolt holes on the left, not a trowel, not a spearhead, not symmetric, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W1-7** – Schürhaken · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 75 Wörter · Datei `fire_poker`  
*21.11.: Schürhaken mit tordiertem Schaft und Ringgriff.*
```
W1-7 — 2D game asset, a single hand-forged fireplace poker: long round iron bar with a small hooked side spur at the tip, a twisted section near the handle and a closed ring loop as handle, horizontal with the tip on the right, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W1-8** – Torriegel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 66 Wörter · Datei `gate_latch`  
*21.11.: Torriegel mit Schnecke, Zierblech und Krampe.*
```
W1-8 — 2D game asset, a single hand-forged gate latch: flat iron latch bar with a curled thumb lever at one end and a small decorative scrolled back plate with two nail holes, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 2 – Kutschen & Handelswege (1715–1735)

**W2-1** – Radreifen · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 66 Wörter · Datei `wheel_tyre`  
*20.11.: geschmiedeter Radreifen, leicht schräg – im Spiel unauffällig. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W2-1 — 2D game asset, a single forged iron wheel tyre: one flat iron hoop forming a perfect circle seen from directly above, narrow uniform band, a visible forge-welded joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W2-2** – Kutschachse · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 65 Wörter · Datei `coach_axle`  
*20.11.: vereinfachte Achse mit Endknöpfen. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W2-2 — 2D game asset, a single forged coach axle: straight thick square iron bar with a round tapered axle arm at each end and a raised collar where each arm begins, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W2-3** – Kutschbeschlag · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 62 Wörter · Datei `coach_fitting`  
*20.11.: Beschlagband mit Voluten und Nagellöchern. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W2-3 — 2D game asset, a single forged coach body fitting: flat iron stay bar with elegant scrolled curls at both ends and four countersunk bolt holes, gently curved, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W2-4** – Laternenhalter · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 76 Wörter · Datei `lantern_bracket`  
*20.11.: Wandplatte mit Ausleger, Voluten und Haken. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W2-4 — 2D game asset, a single hand-forged wall bracket for a hanging lantern: horizontal square-bar arm with a small hook at the right tip, a decorative scroll brace below the arm, and a flat wall plate with two nail holes on the left, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W2-5** – Postpferd-Hufeisen · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 66 Wörter · Datei `post_horseshoe`  
*20.11.: Hufeisen mit Falz und Nagellöchern, Öffnung unten. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W2-5 — 2D game asset, a single light hand-forged horseshoe for a coach horse: narrow web, deep fullered groove, six nail holes and a small raised toe clip at the front, opening pointing down, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W2-6** – Schlagbaumbeschlag · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 75 Wörter · Datei `turnpike_fitting`  
*20.11.: Bandbeschlag mit Ring und Riegel. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W2-6 — 2D game asset, a single heavy forged hinge for a turnpike toll gate: thick flat iron strap with three bolt holes and a large rolled eye at the left end, with an L-shaped iron pintle pin seated in the eye, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W2-7** – Hemmschuh · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Square 1:1** · 91 Wörter · Datei `drag_shoe`  
*20.11.: falsches Objekt – Stab mit Haken und Öse statt Hemmschuh (Kufe unter dem Rad); Prompt jetzt in Seitenansicht mit genauer Form.*
```
W2-7 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged drag shoe (wheel skid) for a coach wheel, seen exactly from the side: a flat iron sole as long as a forearm with low side walls, the front end curled upwards like a sleigh runner, a forged ring with a short chain at the back end, horizontal, dark grey wrought iron, British smith's work, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 3 – Hafen & Royal Navy (1735–1750)

**W3-1** – Kettenglied · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 62 Wörter · Datei `chain_link`  
*20.11.: drei Glieder statt einem – liest sich klar als Kette. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W3-1 — 2D game asset, a single large forged oval chain link made from thick round bar, a visible forge-weld seam on one long side, empty in the middle, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W3-2** – Ankerschaft · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 75 Wörter · Datei `anchor_shank`  
*21.11.: Schaft mit Ring links und Kreuzblock rechts – wie gewünscht. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W3-2 — 2D game asset, a single forged ship's anchor shank without arms: long thick square iron bar, a forged ring eye at the left end, a thickened square crown block at the right end where the anchor arms would be welded, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W3-3** – Bootshaken · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 66 Wörter · Datei `boathook`  
*21.11.: Tülle, Haken und Spitze – wie gewünscht. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W3-3 — 2D game asset, a single forged boathook head without pole: a straight pointed spike on the right with one backward-curving hook beside it, and a conical open socket on the left, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W3-4** – Festmacherring · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 64 Wörter · Datei `mooring_ring`  
*21.11.: Ring mit U-Krampe und zwei Spitzen – wie gewünscht (stehend statt liegend, unkritisch). Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W3-4 — 2D game asset, a single heavy forged mooring ring: thick round-section iron ring, empty in the middle, held by a short U-shaped staple with two pointed spikes at the bottom, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W3-5** – Schiffsbolzen · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 67 Wörter · Datei `ship_bolt`  
*21.11.: Bolzen mit Rundkopf und Splintschlitz – wie gewünscht. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W3-5 — 2D game asset, a single forged ship's bolt: long round iron rod with a domed head at the left end and a narrow slot for a forelock wedge near the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W3-6** – Lafettenbeschlag · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 76 Wörter · Datei `carriage_fitting`  
*21.11.: Lafettenbeschlag als Schildzapfen-Deckel (capsquare) mit Scharnierauge – historisch passend. Fotorealistisch auf grauem Grund, Import stellt sauber frei.*
```
W3-6 — 2D game asset, a single forged gun-carriage fitting (cap square): heavy flat iron band bent into a half-round arch in the middle, a hinge eye at the left end and a slotted tab with two bolt holes at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W3-7** – Ruderfingerling · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 103 Wörter · Datei `rudder_pintle`  
*21.11.: jetzt richtig: L-förmiges Band mit Bolzenlöchern und Zapfen.*
```
W3-7 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single L-shaped forged rudder pintle for a sailing ship: a long flat iron strap with four round bolt holes lying exactly horizontal, and at its left end a short thick round pin pointing straight down at a right angle, shaped like a capital letter L turned on its side, not a thin spike, not diagonal, seen from the side, dark grey wrought iron, British smith's work, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 4 – Stahl & Tuch (1750–1765)

**W4-1** – Spindel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 69 Wörter · Datei `spindle`  
*21.11.: lange Spinnspindel mit Bund.*
```
W4-1 — 2D game asset, a single forged spindle for a spinning machine: long thin round steel rod tapering to a fine point on the right, with a small round collar near the left end, horizontal, dark grey unheated forged steel, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W4-2** – Tuchschere · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 76 Wörter · Datei `cloth_shears`  
*21.11.: kam als W3-8 – große Schneiderschere mit Fingerringen statt Federschere; passt zu „Stahl & Tuch“ (Sheffield fertigte solche Scheren), Prompt W4-2 entsprechend angepasst.*
```
W4-2 — 2D game asset, a single pair of large forged tailor's cloth shears: two long straight steel blades joined by a pivot rivet, two forged finger rings on the right, blades slightly open, blades slightly open, horizontal, dark grey unheated forged steel with slightly brighter ground edges, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W4-3** – Messerklinge · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 71 Wörter · Datei `knife`  
*21.11.: Messerklinge mit Angel.*
```
W4-3 — 2D game asset, a single forged knife blade without handle: straight spine, curved sharp edge rising to a point on the right, a narrow bare tang on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W4-4** – Feder · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 65 Wörter · Datei `spring`  
*21.11.: Schraubenfeder.*
```
W4-4 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single hand-forged coil spring: steel wire wound into eight even coils with open straight ends, seen from the side, horizontal, dark grey unheated forged steel, British smith's work, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W4-5** – Meißel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 70 Wörter · Datei `chisel`  
*21.11.: Meißel.*
```
W4-5 — 2D game asset, a single forged cold chisel: octagonal steel bar, slightly mushroomed striking head on the left, tapering to a sharp ground cutting edge on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W4-6** – Feile · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 69 Wörter · Datei `file`  
*21.11.: Feile mit Hieb (sehr schlank).*
```
W4-6 — 2D game asset, a single hand-cut file without handle: flat steel bar tapering towards the right, the whole surface covered with fine diagonal cross-hatched teeth, a narrow pointed bare tang on the left, horizontal, dark grey unheated forged steel, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W4-7** – Ladekette · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 63 Wörter · Datei `cargo_chain`  
*21.11.: Kette mit Haken.*
```
W4-7 — 2D game asset, a short forged cargo chain: five interlocking oval links of round bar with a forged cargo hook at the right end, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W4-8** – Fassreifen · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 62 Wörter · Datei `barrel_hoop`  
*21.11.: Fassreifen.*
```
W4-8 — 2D game asset, a single forged barrel hoop: thin flat iron band forming a circle seen from directly above, a small riveted overlap joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 5 – Das Zeitalter des Dampfes (1765–1785)

**W5-1** – Kolbenstange · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Square 1:1** · 84 Wörter · Datei `piston_rod`  
*21.11.: noch nach dem alten Prompt (ohne Kolben) – neu mit Kolbenscheibe, damit man den Kolben erkennt.*
```
W5-1 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged piston rod with its piston: long perfectly straight round iron rod, a thick round flat piston disc forged onto the left end (seen edge-on from the side), a forged crosshead eye at the right end, horizontal, seen from the side, dark grey wrought iron, British smith's work, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W5-2** – Ventilteil · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 74 Wörter · Datei `valve_part`  
*21.11.: Ventilteller mit Schaft – gefällt dem Auftraggeber.*
```
W5-2 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged steam-engine valve: round flat valve disc with a bevelled rim on the left and a straight round valve stem pointing to the right, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W5-3** – Kohlenschaufel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 79 Wörter · Datei `beam_strap`
```
W5-3 — 2D game asset, a single forged coal shovel head of the 1780s: broad, slightly dished rectangular iron blade with low raised sides and a straight front edge, a short tapering socket at the back for a wooden handle, the socket pointing to the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no handle, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W5-4** – Schleusenkurbel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter · Datei `lock_fitting`
```
W5-4 — 2D game asset, a single forged canal lock windlass: an L-shaped iron crank, the short arm ending in a square socket eye that fits the gate spindle, the long arm ending in a round hand grip, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W5-5** – Keilhaue · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 79 Wörter · Datei `miners_pick`
```
W5-5 — 2D game asset, a single forged miner's pick head without handle: slightly curved steel head with one long pointed end on the right, a short blunt poll on the left and an empty oval eye in the middle, horizontal, dark grey unheated forged steel with a slightly brighter point, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W5-6** – Bohreisen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter · Datei `drill_steel`
```
W5-6 — 2D game asset, a single forged rock drill steel for mining: long octagonal steel bar with a wide chisel-shaped bit on the right and a flat striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter bit, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W5-7** – Förderkette · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter · Datei `conveyor_chain`
```
W5-7 — 2D game asset, a short length of heavy flat-link winding chain for a mine shaft: five flat forged iron plate links connected by round pins, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W5-8** – Pumpenschwengel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter · Datei `pump_rod`
```
W5-8 — 2D game asset, a single forged hand-pump handle: a long, gently curved iron lever, a flat fork with two pivot holes at the left end, the right end thickened into a rounded hand grip, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 6 – Das Zeitalter der Eisenwerke (1785–1800)

**W6-1** – Kesselniete · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 66 Wörter · Datei `boiler_rivet`  
*21.11.: Niete in Seitenansicht.*
```
W6-1 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single large forged boiler rivet: short thick round shank with a domed snap head on the left, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-2** – Kesselblech · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 64 Wörter · Datei `boiler_plate`  
*21.11.: Kesselblech mit Nietreihen.*
```
W6-2 — 2D game asset, a single forged wrought iron boiler plate: thick rectangular iron sheet, landscape format, slightly uneven hammered surface, one row of round rivet holes along all four edges, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-3** – Puddelkrücke · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 72 Wörter · Datei `rabble`  
*21.11.: Puddelkrücke mit Ring und Schaufel.*
```
W6-3 — 2D game asset, a single forged puddling rabble: very long round iron rod with a flat rectangular paddle blade bent at a right angle at the right end and a closed loop handle at the left end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-4** – Zuganker · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 67 Wörter · Datei `tie_rod`  
*21.11.: Zuganker mit Öse und Haken.*
```
W6-4 — 2D game asset, a single forged building tie rod: long round iron rod with a decorative S-shaped wall anchor plate at the left end and a forged eye at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-5** – Ankerkette · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 63 Wörter · Datei `ship_chain`  
*21.11.: Ankerkette.*
```
W6-5 — 2D game asset, a short length of heavy open-link anchor cable: four very large interlocking oval links of thick round bar, without cross studs, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-6** – Drehmeißel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 66 Wörter · Datei `lathe_tool`  
*21.11.: Drehmeißel.*
```
W6-6 — 2D game asset, a single forged lathe cutting tool: short square steel bar with a bent, sharply ground hooked cutting tip on the right, horizontal, dark grey unheated forged steel with a slightly brighter ground tip, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-7** – Blattfeder · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 82 Wörter · Datei `leaf_spring`  
*21.11.: Blattfeder mit Augen.*
```
W6-7 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged carriage leaf spring: a stack of five gently curved steel leaves of decreasing length held by a central iron clamp band, rolled eyes at both ends of the longest leaf, seen from the side, horizontal, dark grey unheated forged steel, British smith's work, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-8** – Wagenachse · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 66 Wörter · Datei `wagon_axle`  
*21.11.: Wagenachse mit Bunden.*
```
W6-8 — 2D game asset, a single heavy forged wagon axle for a horse-drawn plateway wagon: thick straight round iron bar with a raised collar and a short round journal at each end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-9** – Antriebswelle · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 67 Wörter · Datei `large_shaft`  
*21.11.: Welle mit Bunden – entspricht dem Prompt, das Werkstück selbst ist aber abstrakt (Kandidat Nr. 21).*
```
W6-9 — 2D game asset, a single forged mill drive shaft: very long thick round iron shaft with two square bosses and two raised collars along its length and round journals at both ends, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W6-10** – Kurbelwelle · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 77 Wörter · Datei `crankshaft`  
*21.11.: Welle mit einer Kröpfung – entspricht dem Prompt, abstrakt (Kandidat Nr. 21).*
```
W6-10 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged crankshaft: straight round iron shaft with one single crank throw in the middle, made of two rectangular webs and a round crankpin offset to one side, seen from the side, horizontal, dark grey wrought iron, British smith's work, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 7 – Krieg & Erfindergeist (1800–1820)

**W7-1** – Blockrollen-Bolzen · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 70 Wörter · Datei `block_pin`  
*21.11.: Bolzen mit Kopf und Splintloch.*
```
W7-1 — 2D game asset, a single forged pulley-block pin: short thick perfectly straight round iron pin with a slightly domed head on the left and a small hole for a split pin near the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W7-2** – Kessel-Stehbolzen · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 62 Wörter · Datei `boiler_stay`  
*21.11.: dünner Bolzen – entspricht dem Prompt, abstrakt (Kandidat Nr. 21).*
```
W7-2 — 2D game asset, a single forged boiler stay bolt: a long straight round iron rod with a thick upset collar near each end and slightly peened ends, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W7-3** – Gaslaternen-Ausleger · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 86 Wörter · Datei `gas_lamp_bracket`  
*21.11.: Gaslaternen-Ausleger mit Voluten – sehr schön.*
```
W7-3 — 2D game asset, a single hand-forged wall bracket for a gas street lamp: a horizontal arm of square bar with a decorative twisted section and a large scroll brace underneath, a flat wall plate with four bolt holes on the left and a downward ring at the right tip for the lamp, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W7-4** – Spaten · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 80 Wörter · Datei `navvy_spade`  
*21.11.: Spaten mit D-Griff.*
```
W7-4 — 2D game asset, a single forged navvy's spade blade without wooden handle: a broad flat slightly dished iron blade with a squared cutting edge at the bottom, rolled tread edges at the top and a long tapering open socket strap, upright with the socket pointing up, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W7-5** – Pressenspindel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 79 Wörter · Datei `press_screw`  
*21.11.: Pressenspindel mit Gewinde.*
```
W7-5 — 2D game asset, a single forged screw spindle for an iron printing press: a thick round iron rod with a coarse square thread twisted along its middle part, a square end for the lever on the left and a round foot on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W7-6** – Bajonett · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 83 Wörter · Datei `bayonet`  
*21.11.: Tüllenbajonett.*
```
W7-6 — 2D game asset, a single forged socket bayonet without musket: a long triangular-section steel blade tapering to a sharp point on the right, joined by a short curved neck to a round hollow socket with an L-shaped slot on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W7-7** – Draggen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 86 Wörter · Datei `anchor_fluke`
```
W7-7 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged grapnel (small boat anchor): a straight round shank with a ring at the top end, four curved arms with small pointed flukes at the bottom end spreading out like a claw, seen exactly from the side, upright, the ring at the top, dark grey wrought iron, British smith's work, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W7-8** – Brückenglied · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 62 Wörter · Datei `chain_eyebar`  
*21.11.: Brückenglied mit zwei Augen.*
```
W7-8 — 2D game asset, a single forged suspension bridge eyebar: a long flat wrought iron bar with a thickened round eye with a large hole at each end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 8 – Eisenbahnfieber (1820–1839)

**W8-1** – Schienennagel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 64 Wörter · Datei `rail_spike`  
*21.11.: Schienennagel (senkrecht statt waagerecht – im Spiel unauffällig).*
```
W8-1 — 2D game asset, a single forged railway track spike: a long square-section iron shank with a chisel point at the bottom and a hooked offset head at the top, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W8-2** – Kupplungshaken · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 62 Wörter · Datei `coupling_hook`  
*21.11.: Kupplungshaken mit Ring.*
```
W8-2 — 2D game asset, a single forged railway wagon coupling hook: a heavy curved iron hook with a thick shank and a punched eye at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W8-3** – Sicherheitsventil-Hebel · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 75 Wörter · Datei `safety_valve_lever`  
*21.11.: Hebel mit Gabel und Auge – entspricht dem Prompt, abstrakt (Kandidat Nr. 21).*
```
W8-3 — 2D game asset, a single forged safety valve lever for a locomotive boiler: a long flat iron lever with a fork and pin hole at the left end, two holes along its length and a rounded end on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W8-4** – Kupplungskette · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 55 Wörter · Datei `coupling_chain`  
*21.11.: Kupplungskette.*
```
W8-4 — 2D game asset, a short forged railway coupling chain: three heavy oval links of round bar, laid out straight and horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W8-5** – Lokomotiv-Radreifen · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 72 Wörter · Datei `loco_tyre`  
*21.11.: Lokomotiv-Radreifen.*
```
W8-5 — 2D game asset, a single forged locomotive wheel tyre: a thick iron hoop seen from directly above forming a perfect circle, with a raised flange along the inner edge and a visible forge-welded joint, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W8-6** – Pufferfeder · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 84 Wörter · Datei `buffer_spring`
```
W8-6 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged railway volute buffer spring: a wide flat steel band coiled into a short cone (like a squat spiral cone, wide at the bottom, narrow at the top), seen exactly from the side, upright, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W8-7** – Treibstange · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 71 Wörter · Datei `connecting_rod`  
*21.11.: Treibstange mit Augen.*
```
W8-7 — 2D game asset, a single forged locomotive connecting rod: a long tapered flat iron rod with a large rectangular strap end with a bearing hole on the left and a smaller round eye on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W8-8** – Kurbelachse · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 80 Wörter · Datei `crank_axle`  
*21.11.: Achse mit zwei Kröpfungen – entspricht dem Prompt, abstrakt (Kandidat Nr. 21).*
```
W8-8 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged locomotive crank axle: a thick straight round iron axle with two offset crank throws in the middle, each made of two rectangular webs and a crank pin, seen exactly from the side (not from above), horizontal, dark grey wrought iron, British smith's work, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 9 – Der Dampfhammer (1839–1860)

**W9-1** – Brückenniete · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 64 Wörter · Datei `bridge_rivet`  
*21.11.: jetzt in Seitenansicht (Prompt ohne widersprüchliche Ansicht).*
```
W9-1 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single large forged bridge rivet: short thick round shank with a domed head, seen exactly from the side (not from above), horizontal, dark grey wrought iron, British smith's work, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W9-2** – Säulenkopf-Beschlag · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 62 Wörter · Datei `palace_bracket`  
*21.11.: Winkelbeschlag mit Schnecke.*
```
W9-2 — 2D game asset, a single forged iron connecting bracket for a glass-and-iron exhibition hall: a flat L-shaped iron plate with a decorative curved gusset and six bolt holes, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W9-3** – Schaufelrad-Arm · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Square 1:1** · 69 Wörter · Datei `paddle_arm`  
*21.11.: schräg statt waagerecht; außerdem ein abstrakter Stab (Kandidat Nr. 21).*
```
W9-3 — 2D game asset, a single forged paddle-wheel arm for a paddle steamer: a long flat iron bar with a bolted palm plate at the right end and two bolt holes at the left end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W9-4** – Hammergesenk · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 77 Wörter · Datei `hammer_die`  
*21.11.: Gesenkblock; Schwalbenschwanz seitlich statt oben – im Spiel unauffällig.*
```
W9-4 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a single forged steam-hammer die: a heavy rectangular steel block with a dovetail tongue on top and a smooth flat working face at the bottom, seen from the side, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W9-5** – Admiralitätsanker · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 67 Wörter · Datei `admiralty_anchor`
```
W9-5 — 2D game asset, a single forged Admiralty pattern anchor without stock: a long straight shank with a ring at the top and two curved arms with broad triangular flukes at the bottom, upright, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W9-6** – Schiffs-Kolbenstange · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter · Datei `marine_piston_rod`
```
W9-6 — 2D game asset, a single forged marine engine piston rod: a very long perfectly straight round iron rod with a tapered cone end on the left and a forged crosshead block with a hole on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W9-7** – Schiffskurbel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 75 Wörter · Datei `marine_crank`
```
W9-7 — 2D game asset, a single forged marine engine crank: a heavy flat iron crank arm with a large round boss with a shaft hole at the left end and a smaller boss with a pin hole at the right end, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W9-8** – Schraubenwelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `propeller_shaft`
```
W9-8 — 2D game asset, a single forged ship's propeller shaft: a very long thick round iron shaft with a flanged coupling disc at the left end and a tapered end with a keyway on the right, horizontal, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 10 – Das Stahlzeitalter (1860–1880)

**W10-1** – Hochrad-Gabel · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter · Datei `velocipede_fork`
```
W10-1 — 2D game asset, a single forged front fork of a penny-farthing bicycle: two long slightly curved steel blades joined at the top by a crown with a vertical steering stem, upright, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W10-2** – Stahlachse · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter · Datei `steel_axle`
```
W10-2 — 2D game asset, a single forged railway carriage steel axle: a thick straight round steel bar with raised wheel seats and short round journals at both ends, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W10-3** – Mähmesser · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `reaper_knife`
```
W10-3 — 2D game asset, a single forged reaper section knife: a long flat steel bar with a row of riveted triangular cutting sections along its upper edge, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W10-4** – Tunnelbohrer · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter · Datei `tunnel_drill`
```
W10-4 — 2D game asset, a single forged tunnelling drill steel: a long octagonal steel bar with a cross-shaped four-point bit on the right and a collar near the striking end on the left, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W10-5** – Stahl-Radreifen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter · Datei `steel_tyre`
```
W10-5 — 2D game asset, a single weldless forged steel wheel tyre seen from directly above: a thick perfect steel ring seamless, with a flange along the inner edge, empty in the middle, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W10-6** – Geschützring · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `gun_hoop`
```
W10-6 — 2D game asset, a single forged gun hoop for a built-up cannon: a short thick wide iron ring seen at a slight angle from above so its thickness is visible, empty in the middle, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W10-7** – Panzerplatte · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 69 Wörter · Datei `armour_plate`
```
W10-7 — 2D game asset, a single forged armour plate for an ironclad warship: a very thick rectangular wrought iron slab, landscape format, with slightly bevelled edges and a row of bolt holes along the long edges, dark grey wrought iron, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

**W10-8** – Stahlwelle · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter · Datei `steel_shaft`
```
W10-8 — 2D game asset, a single forged steel intermediate shaft for an ocean liner: a very long thick round steel shaft with a large flanged coupling disc at each end, horizontal, dark grey unheated forged steel with a slightly brighter ground edge, British smith's work, top-down view, lying flat, centred with wide margin, hand-painted, thin dark ink outline, hammer marks, matte metal, soft studio light, metal only, cold, pure flat white background --ar 1:1 --no wood, rope, glow, fire, other objects, text, numbers, watermark, border, shadow, photo, 3d render
```

## F · Kundenporträts (54)

Die aktuellen Porträts sind noch meine gerenderten (im Spiel vorhanden, aber im alten Stil). Für einen einheitlichen Stil empfehlenswert, aber nicht zwingend.

**P1-1** – the squire (Epoche 1–2) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_squire`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Allongeperücke und braunem Samtrock.*
```
P1-1 — 2D game asset, a head-and-shoulders portrait of a stout English country squire of about 1710, full-bottomed powdered wig, brown velvet coat, ruddy cheeks, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P1-2** – the vicar (Epoche 1–2) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_vicar`  
*20.11.: Brustbild im ovalen Goldrahmen, mit schwarzem Talar und Beffchen.*
```
P1-2 — 2D game asset, a head-and-shoulders portrait of an elderly Anglican village vicar of about 1710, black cassock, white preaching bands, small grey wig, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P1-3** – Farmer Hollow (Epoche 1–2) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 57 Wörter · Datei `portrait_farmer_hollow`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Strohhut und Leinenkittel.*
```
P1-3 — 2D game asset, a head-and-shoulders portrait of a weathered English farmer (a man) of about 1710, grey hair tied back, linen smock, broad-brimmed straw hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P1-4** – the miller of Upton (Epoche 1–2) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 58 Wörter · Datei `portrait_miller_upton`  
*21.11.: fröhlicher, mehlbestäubter Müller mit Mütze – etwas karikiert, passt aber zur Rolle.*
```
P1-4 — 2D game asset, a head-and-shoulders portrait of a cheerful, plump village miller (a man) of about 1710, broad smile, flour-dusted face and clothes, white linen cap, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P1-5** – the landlady of the Red Lion (Epoche 1–2) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 57 Wörter · Datei `portrait_landlady_red_lion`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Haube, Schultertuch und Mieder.*
```
P1-5 — 2D game asset, a head-and-shoulders portrait of a sturdy English innkeeper's wife of about 1710, white linen cap, shawl over a laced bodice, warm smile, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P1-6** – the carpenter (Epoche 1–2) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_carpenter`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Lederschurz und hochgekrempelten Ärmeln.*
```
P1-6 — 2D game asset, a head-and-shoulders portrait of an English village carpenter of about 1710, leather apron, rolled sleeves, a pencil behind the ear, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P2-1** – the postmaster of Bath (Epoche 2–3) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 54 Wörter · Datei `portrait_postmaster_bath`  
*20.11.: Brustbild im ovalen Goldrahmen, passend zur Beschreibung; Import stellt den Rahmen frei.*
```
P2-1 — 2D game asset, a head-and-shoulders portrait of a fashionable postmaster of Bath around 1725, neat tie wig, blue coat with brass buttons, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P2-2** – the coachbuilder of York (Epoche 2–3) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 58 Wörter · Datei `portrait_coachbuilder_york`  
*20.11.: Brustbild im ovalen Goldrahmen, passend zur Beschreibung; Import stellt den Rahmen frei.*
```
P2-2 — 2D game asset, a head-and-shoulders portrait of a coachbuilder from York around 1725, sturdy man in a waistcoat with rolled sleeves, wood shavings on his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P2-3** – the Turnpike Trust (Epoche 2–3) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_turnpike_trust`  
*20.11.: Brustbild im ovalen Goldrahmen, passend zur Beschreibung; Import stellt den Rahmen frei.*
```
P2-3 — 2D game asset, a head-and-shoulders portrait of a gentleman trustee of a turnpike road around 1725, tricorn hat, grey coat, holding a ledger, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P2-4** – the coaching-inn keeper (Epoche 2–3) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 54 Wörter · Datei `portrait_innkeeper_coaching`  
*20.11.: Brustbild im ovalen Goldrahmen, passend zur Beschreibung; Import stellt den Rahmen frei.*
```
P2-4 — 2D game asset, a head-and-shoulders portrait of the portly landlord of a coaching inn around 1725, red waistcoat, white apron, jolly expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P2-5** – Carrier Bennett (Epoche 2–3) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 57 Wörter · Datei `portrait_carrier_bennett`  
*20.11.: Brustbild im ovalen Goldrahmen, passend zur Beschreibung; Import stellt den Rahmen frei.*
```
P2-5 — 2D game asset, a head-and-shoulders portrait of a carrier wagon driver around 1725, weather-beaten face, slouch hat, heavy woollen greatcoat, a whip over his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P3-1** – the Navy Board (Epoche 3–4) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 54 Wörter · Datei `portrait_navy_board`  
*20.11.: Brustbild im ovalen Goldrahmen, passend zur Beschreibung; Import stellt den Rahmen frei.*
```
P3-1 — 2D game asset, a head-and-shoulders portrait of a Navy Board commissioner around 1740, white powdered wig, dark blue coat with gold lace, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P3-2** – the master shipwright of Portsmouth (Epoche 3–4) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 57 Wörter · Datei `portrait_shipwright_portsmouth`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Messingzirkel.*
```
P3-2 — 2D game asset, a head-and-shoulders portrait of a master shipwright of Portsmouth around 1740, grey hair, plain brown coat, holding a pair of brass dividers, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P3-3** – a Bristol merchant (Epoche 3–4) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 53 Wörter · Datei `portrait_merchant_bristol`  
*20.11.: Brustbild im ovalen Goldrahmen, im grünen Seidenrock mit Spitzenhalstuch.*
```
P3-3 — 2D game asset, a head-and-shoulders portrait of a wealthy Bristol merchant around 1740, powdered wig, rich green silk coat, lace cravat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P3-4** – the harbourmaster (Epoche 3–4) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_harbourmaster`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Dreispitz und blauem Seerock.*
```
P3-4 — 2D game asset, a head-and-shoulders portrait of a harbourmaster around 1740, weathered sailor's face, tricorn hat, dark blue sea coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P3-5** – the Chatham ropewalk (Epoche 3–4) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 61 Wörter · Datei `portrait_ropewalk_chatham`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Tau über der Schulter und Strickmütze.*
```
P3-5 — 2D game asset, a head-and-shoulders portrait of the foreman of the Chatham ropewalk around 1740, strong man with tarred hands, knitted cap, a coil of rope over his shoulder, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P4-1** – a Leeds clothier (Epoche 4–5) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 56 Wörter · Datei `portrait_clothier_leeds`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Ballen gefärbter Wolle.*
```
P4-1 — 2D game asset, a head-and-shoulders portrait of a prosperous Leeds clothier around 1755, brown wig, plain cloth coat, holding a bolt of dyed wool, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P4-2** – the Sheffield cutlers (Epoche 4–5) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 57 Wörter · Datei `portrait_cutlers_sheffield`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Amtskette.*
```
P4-2 — 2D game asset, a head-and-shoulders portrait of the Master Cutler of Sheffield around 1755, dignified man with a chain of office over a dark coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P4-3** – the spinning master (Epoche 4–5) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 56 Wörter · Datei `portrait_spinning_master`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Weste und Fasern auf den Schultern.*
```
P4-3 — 2D game asset, a head-and-shoulders portrait of a spinning master around 1760, middle-aged man in shirtsleeves and waistcoat, wisps of cotton on his clothes, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P4-4** – toolmaker Holt (Epoche 4–5) · ✅ gut (Midjourney)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_toolmaker_holt`  
*20.11.: Brustbild im ovalen Goldrahmen, mit Brille, Schurz und Feile.*
```
P4-4 — 2D game asset, a head-and-shoulders portrait of a wiry toolmaker around 1760, spectacles on the nose, leather apron, a file in his hand, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P4-5** – Chatham Dockyard (Epoche 4–5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter · Datei `portrait_dockyard_chatham`
```
P4-5 — 2D game asset, a head-and-shoulders portrait of the master attendant of Chatham Dockyard around 1760, naval officer, white wig, blue coat with gold buttons, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P5-1** – Boulton & Watt of Soho (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 65 Wörter · Datei `portrait_boulton_watt`
```
P5-1 — 2D game asset, a head-and-shoulders portrait of two engineering partners of Birmingham around 1780 side by side, one stout and cheerful in a fine coat, one thin and thoughtful Scotsman with grey hair, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P5-2** – a Cornish tin mine (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 60 Wörter · Datei `portrait_mine_cornwall`
```
P5-2 — 2D game asset, a head-and-shoulders portrait of the captain of a Cornish tin mine around 1775, rugged face, miner's felt hat with a candle stuck on with clay, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P5-3** – the Wednesbury colliery (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_colliery_wednesbury`
```
P5-3 — 2D game asset, a head-and-shoulders portrait of a colliery owner from Wednesbury around 1775, stout man, tall hat, coal dust on his collar, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P5-4** – the canal company (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter · Datei `portrait_canal_company`
```
P5-4 — 2D game asset, a head-and-shoulders portrait of a canal company engineer around 1775, surveyor's coat, holding rolled plans, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P5-5** – the ironmaster of Coalbrookdale (Epoche 5–6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter · Datei `portrait_ironmaster_coalbrookdale`
```
P5-5 — 2D game asset, a head-and-shoulders portrait of a Quaker ironmaster of Coalbrookdale around 1779, plain dark Quaker coat, broad-brimmed hat, calm expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P5-6** – Josiah Wedgwood of Etruria (Epoche 5) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 58 Wörter · Datei `portrait_wedgwood_etruria`
```
P5-6 — 2D game asset, a head-and-shoulders portrait of a master potter of Staffordshire around 1770, dignified man in a brown coat, holding a pale blue jasperware vase, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P6-1** – a cotton-mill owner (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 51 Wörter · Datei `portrait_mill_owner`
```
P6-1 — 2D game asset, a head-and-shoulders portrait of a self-made cotton-mill owner around 1790, high collar, brown tailcoat, watch chain, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P6-2** – the plateway company (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter · Datei `portrait_plateway_company`
```
P6-2 — 2D game asset, a head-and-shoulders portrait of a tramroad company agent around 1790, top hat, grey tailcoat, holding a measuring rod, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P6-3** – an engine works (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter · Datei `portrait_engine_works`
```
P6-3 — 2D game asset, a head-and-shoulders portrait of an engine-works manager around 1790, sideburns, dark tailcoat, an oil stain on his cuff, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P6-4** – your ironworks partners (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_ironworks_partners`
```
P6-4 — 2D game asset, a head-and-shoulders portrait of a well-to-do ironworks partner around 1795, silver hair, black tailcoat, high white cravat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P6-5** – the East India Company (Epoche 6) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter · Datei `portrait_east_india`
```
P6-5 — 2D game asset, a head-and-shoulders portrait of an East India Company director around 1795, powdered wig, rich red coat, gold-headed cane, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P7-1** – the Portsmouth block mills (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter · Datei `portrait_navy_portsmouth`
```
P7-1 — 2D game asset, a head-and-shoulders portrait of a naval officer overseeing the Portsmouth block mills around 1805, bicorne hat, blue coat with an epaulette, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P7-2** – Henry Maudslay of Lambeth (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_maudslay`
```
P7-2 — 2D game asset, a head-and-shoulders portrait of a broad-shouldered master engineer of London around 1810, kind face, dark coat, holding a brass micrometer, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P7-3** – the engineer Thomas Telford (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_telford`
```
P7-3 — 2D game asset, a head-and-shoulders portrait of a Scottish civil engineer around 1815, grey hair, plain dark coat and cravat, rolled bridge drawings, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P7-4** – the Gas Light and Coke Company (Epoche 7) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_gas_light_company`
```
P7-4 — 2D game asset, a head-and-shoulders portrait of a gas company director around 1812, top hat, bottle-green tailcoat, a small gas lamp beside him, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P7-5** – the Royal Horse Guards (Epoche 7) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter · Datei `portrait_horse_guards`
```
P7-5 — 2D game asset, a head-and-shoulders portrait of a Royal Horse Guards officer around 1815, blue tunic, shining steel helmet with a plume, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P7-6** – Richard Trevithick (Epoche 7–8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter · Datei `portrait_trevithick`
```
P7-6 — 2D game asset, a head-and-shoulders portrait of a tall Cornish engineer around 1805, curly hair, open-necked shirt and waistcoat, energetic expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P8-1** – the Stockton & Darlington Railway (Epoche 8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter · Datei `portrait_stockton_darlington`
```
P8-1 — 2D game asset, a head-and-shoulders portrait of a Quaker railway promoter around 1825, plain dark coat, broad-brimmed hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P8-2** – Robert Stephenson & Co. (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter · Datei `portrait_stephenson_works`
```
P8-2 — 2D game asset, a head-and-shoulders portrait of a young locomotive engineer from Newcastle around 1830, dark curly hair, high collar, black tailcoat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P8-3** – the Liverpool & Manchester Railway (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_liverpool_manchester`
```
P8-3 — 2D game asset, a head-and-shoulders portrait of a railway company director around 1830, top hat, dark green tailcoat, side whiskers, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P8-4** – Isambard Kingdom Brunel (Epoche 8–9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_brunel`
```
P8-4 — 2D game asset, a head-and-shoulders portrait of a short energetic engineer around 1840, tall stovepipe hat, cigar, dark frock coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P8-5** – the Hetton colliery (Epoche 8) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_hetton_colliery`
```
P8-5 — 2D game asset, a head-and-shoulders portrait of a colliery viewer around 1825, sturdy northern man, flat cap, waistcoat, coal-dusted hands, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P9-1** – James Nasmyth of Patricroft (Epoche 9–10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_nasmyth`
```
P9-1 — 2D game asset, a head-and-shoulders portrait of a Scottish engineer around 1845, broad face, bushy dark beard, dark frock coat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P9-2** – the Great Western Steamship Company (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 54 Wörter · Datei `portrait_great_western_ss`
```
P9-2 — 2D game asset, a head-and-shoulders portrait of a steamship company director around 1843, mutton-chop whiskers, black frock coat, top hat in hand, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P9-3** – the Admiralty (Epoche 9–10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_admiralty_steam`
```
P9-3 — 2D game asset, a head-and-shoulders portrait of a Royal Navy captain around 1845, dark blue frock coat with gold epaulettes, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P9-4** – the Britannia Bridge works (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter · Datei `portrait_britannia_bridge`
```
P9-4 — 2D game asset, a head-and-shoulders portrait of a bridge works resident engineer around 1848, top hat, plaid waistcoat, holding riveting plans, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P9-5** – Fox, Henderson & Co. (Epoche 9) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 56 Wörter · Datei `portrait_crystal_palace`
```
P9-5 — 2D game asset, a head-and-shoulders portrait of a building contractor around 1851, prosperous, top hat, grey frock coat, a drawing of a glass-and-iron hall, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P10-1** – John Brown & Co. of Sheffield (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter · Datei `portrait_john_brown`
```
P10-1 — 2D game asset, a head-and-shoulders portrait of a Sheffield steel magnate around 1865, grey beard, black frock coat, gold watch chain, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P10-2** – Armstrong's ordnance works at Elswick (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_armstrong_elswick`
```
P10-2 — 2D game asset, a head-and-shoulders portrait of an ordnance manufacturer around 1865, white side whiskers, dark frock coat, stern expression, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P10-3** – the Midland Railway (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 53 Wörter · Datei `portrait_midland_railway`
```
P10-3 — 2D game asset, a head-and-shoulders portrait of a railway general manager around 1868, full beard, black frock coat, railway pocket watch, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P10-4** – the White Star Line (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 55 Wörter · Datei `portrait_white_star`
```
P10-4 — 2D game asset, a head-and-shoulders portrait of a shipping line owner around 1870, neat beard, dark double-breasted coat, a ship model behind him, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P10-5** – Hornsby the agricultural engineers (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 50 Wörter · Datei `portrait_hornsby`
```
P10-5 — 2D game asset, a head-and-shoulders portrait of an agricultural engineer around 1865, ruddy face, tweed jacket, bowler hat, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

**P10-6** – the Coventry Machinists Company (Epoche 10) · ⬜ noch nicht vorhanden (optional)  
Regler: **Portrait 4:5** · 52 Wörter · Datei `portrait_coventry_machinists`
```
P10-6 — 2D game asset, a head-and-shoulders portrait of a young bicycle maker around 1870, moustache, waistcoat with rolled sleeves, flat cap, in an oval gilt wooden frame, hand-painted 2D game art, dark ink outlines, painterly, friendly but serious expression, plain dark background inside the frame, on pure flat white background outside the frame --ar 4:5 --no text, name plate, numbers, watermark, border, shadow, photo, 3d render
```

## G · Oberfläche, Symbole, Store

Spieltitel und Schriften kommen aus Schriftarten (kein Bild nötig); Glühskala, Fortschritt und Partikel zeichnet das Spiel selbst.

**U1** – Pergament mit Messingecken (alle Fenster) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 30 Wörter · Datei `panel_parchment`  
*21.11.: Pergament mit Messingecken auf Schwarz; Import stellt den leichten Verlauf mit frei.*
```
U1 — 2D game asset, UI panel frame, aged 18th-century parchment paper texture, worn burned edges, brass metal corner protectors, georgian style craftsmanship, clean flat view, high detail, isolated on black background --ar 1:1 --no shadows, text, numbers, watermark
```

**U2** – Leder-Messing-Knöpfe (alle Knöpfe) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 24 Wörter · Datei `buttons_leather_brass`  
*21.11.: fünf Leder-Messing-Knöpfe; heller Schlagschatten wird beim Import entfernt.*
```
U2 — Set of 4 game UI buttons, 18th-century georgian style, polished brass with dark leather inlay, blank rectangular icons, flat design, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**U3** – Holzrahmen mit Eisenplatte (Status- und Navigationsleiste) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 39 Wörter · Datei `frame_wood_iron`  
*21.11.: Holzrahmen mit Eisenecken, innen offen – der Import füllt die Mitte der Leiste dunkel.*
```
U3 — Flat orthographic front elevation, like a technical drawing. 2D UI window frame, 18th-century forge workshop style, dark oak wood frame with brass rivets and iron fittings, game interface panel, front view, orthographic projection, clean edges, isolated on white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, 3d perspective, text, numbers, watermark, border, shadow, photo, 3d render
```

**U4** – Glut-Knopf HAMMERN · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 43 Wörter · Datei `button_ember`  
*21.11.: runder Glut-Knopf mit gekreuztem Hammer und Zange (ohne Zahnrad) – das Spiel zeigt ihn quadratisch.*
```
U4 — 2D game UI button, forged dark iron plate with glowing orange ember cracks, heavy brass border, a simple embossed symbol of a blacksmith hammer crossed with forge tongs in the middle, early 18th-century village smithy style, flat orthographic view, isolated on white background --ar 1:1 --no gear, cogwheel, text, numbers, watermark, border, shadow, photo, 3d render
```

**U5** – Auftragsbuch-Seite (Hochformat) · ✅ gut (Midjourney)  
Regler: **Portrait 3:4** · 87 Wörter · Datei `ledger_page`  
*21.11.: Einzelseite mit Lederrücken, Seitenstapel links und Lesebändchen; Schreibfläche im Spiel neu vermessen.*
```
U5 — 2D game asset, an 18th-century leather-bound ledger lying open, seen from directly above, portrait orientation 3:4: the right-hand page fully visible, aged cream parchment with a thin red double border line and faint stains, completely empty, along the left side the curved gutter and a narrow strip of the left-hand page with stacked page edges, dark brown leather binding, small brass corner fittings, a red ribbon bookmark hanging out at the bottom, hand-painted 2D game art, dark ink outlines, soft even lighting, on pure flat white background --ar 3:4 --no writing, numbers, cast shadow, text, watermark, border, shadow, photo, 3d render
```

**U6** – Münzbeutel (Geldanzeige) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 24 Wörter · Datei `coin_pouch`  
*21.11.: Lederbeutel mit Münzen, leichter Bodenschatten.*
```
U6 — 2D game asset icon, 18th-century leather coin pouch tied with string, filled with old British silver shillings and copper pence, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**U7** – Münzen George III: Guinee, Shilling, Halfpenny · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 27 Wörter · Datei `coins`  
*21.11.: Guinee, Shilling und Halfpenny (George III).*
```
U7 — Set of 3 antique British coins of George III, one gold guinea, one silver shilling, one copper halfpenny, game item icons, top-down view, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**U8** – Münzen Victoria: Sovereign, Shilling, Penny (für Epoche 9–10) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 39 Wörter · Datei `coins_victoria`  
*21.11.: Sovereign, Shilling, Penny mit Victoria; Umschriften erfunden – im Spiel zu klein, um aufzufallen.*
```
U8 — Set of 3 antique British coins of Queen Victoria from the 1850s, one gold sovereign, one silver shilling, one bronze penny, game item icons, top-down view, crisp hand-painted 2D game art, thin dark outlines, on pure flat white background --ar 1:1 --no text other than the coin legends, text, numbers, watermark, border, shadow, photo, 3d render
```

**U9** – Wachssiegel George III und Admiralität · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 39 Wörter · Datei `wax_seals`  
*21.11.: zweite Fassung: links Monogramm GR mit Krone (George III), rechts Admiralitätsanker, ohne Jahreszahl.*
```
U9 — Two red wax seals side by side: left the royal cipher of King George III as the crowned monogram GR, right the fouled anchor of the Admiralty, game badge icons, hand-painted 2D game art, on pure flat white background --ar 1:1 --no eagle, coat of arms, date, year, text, numbers, watermark, border, shadow, photo, 3d render
```

**U10** – Wachssiegel Victoria (Meilensteine ab Epoche 9) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 26 Wörter · Datei `seal_victoria`  
*21.11.: VR-Monogramm mit Krone, ohne Jahreszahl.*
```
U10 — Red wax seal with the royal cipher of Queen Victoria (VR) and a crown, game badge icon, hand-painted 2D game art, on pure flat white background --ar 1:1 --no date, year, text, numbers, watermark, border, shadow, photo, 3d render
```

**U11** – Pyrometer-Zeiger · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 17 Wörter · Datei `pointer_sheet`  
*21.11.: Zierzeiger aus Messing; Import dreht ihn waagerecht und legt die Nabe fest.*
```
U11 — 2D game asset, antique brass indicator needle, fine clockwork pointer, ornate georgian style, isolated on white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**U12** – Pyrometer-Zifferblatt ohne Zeiger · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 48 Wörter · Datei `pyrometer_dial`  
*21.11.: Halbkreis-Skala mit Mechanik (optional, derzeit nicht im Spiel verwendet).*
```
U12 — Flat orthographic front elevation, like a technical drawing. 2D game asset, an 18th-century brass pyrometer temperature gauge seen exactly from the front, a semicircular arc scale with engraved tick marks, antique clockwork style, dark iron base, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, needle, pointer, numbers, text, watermark, border, shadow, photo, 3d render
```

**U13** – Sterne für die Bewertung (voll und leer) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 36 Wörter · Datei `stars`  
*21.11.: goldener und leerer Eisenstern.*
```
U13 — 2D game UI icons, two five-pointed stars side by side: one polished gold star with a brass rim, one empty dark iron star outline, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no text, numbers, watermark, border, shadow, photo, 3d render
```

**U14** – Sanduhr (Eilaufträge) · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 35 Wörter · Datei `hourglass`  
*21.11.: Sanduhr aus Messing und Holz.*
```
U14 — Flat orthographic front elevation, like a technical drawing. 2D game UI icon, an 18th-century brass and wood hourglass with golden sand, front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, text, numbers, watermark, border, shadow, photo, 3d render
```

**U15** – Löschtrog (ab Epoche 4) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 65 Wörter · Datei `trough`  
*21.11.: Löschtrog aus Eichendauben mit Eisenbändern auf kurzen Füßen – frontal, wie gewünscht.*
```
U15 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden quench trough for a blacksmith: a long rectangular oak tub bound with iron bands, standing on two short trestles, a thin strip of dark water visible along the top edge, shown in a flat straight front view at eye level, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, steam, tools, text, numbers, watermark, border, shadow, photo, 3d render
```

**U16** – App-Icon · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 64 Wörter · Datei `app_icon`  
*21.11.: Hammer schlägt auf glühendes Hufeisen, Funkenregen, warmes Licht – klar und kräftig, auch klein gut lesbar.*
```
U16 — Square 1:1 mobile game app icon, a heavy blacksmith's hammer striking a glowing orange-hot horseshoe on the face of a dark iron anvil, a burst of bright sparks, warm firelight against a deep dark brown background, bold simple shapes and strong contrast that stay readable at very small size, hand-painted 2D game art, dark ink outlines, subject centred and filling most of the square --ar 1:1 --no text, letters, border, rounded corners, numbers, watermark
```

**U17** – Store-Banner (Google Play 1024 × 500) · ✅ gut (Midjourney)  
Regler: **Landscape 2:1** · 69 Wörter · Datei `store_banner`  
*21.11.: Schmiede bei Nacht, Amboss und Funken rechts, links Platz für den Titel.*
```
U17 — Wide 2:1 banner illustration for a mobile game, interior of an 18th-century English smithy at night lit only by forge fire, on the right half a blacksmith's anvil with a glowing horseshoe and a raised hammer with sparks flying, a brick forge glowing in the background, the left half is calm, dark and empty for a title to be added later, hand-painted 2D game art, dark ink outlines, painterly --ar 2:1 --no people, text, letters, numbers, watermark
```

**U18** – Meisterschafts-Siegel Bronze · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 54 Wörter · Datei `seal_mastery_1`  
*21.11.: Bronzesiegel mit Hämmern, Amboss und einem Stern.*
```
U18 — Flat orthographic front elevation, like a technical drawing. 2D game UI icon, a round guild seal medallion of warm brown polished bronze, embossed crossed hammers above a small anvil, one small star below the anvil, a wavy wax-seal-like rim, straight front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, text, letters, numbers, watermark, border, shadow, photo, 3d render
```

**U19** – Meisterschafts-Siegel Silber · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 53 Wörter · Datei `seal_mastery_2`  
*21.11.: Silbersiegel mit zwei Sternen.*
```
U19 — Flat orthographic front elevation, like a technical drawing. 2D game UI icon, a round guild seal medallion of bright polished silver, embossed crossed hammers above a small anvil, two small stars below the anvil, a wavy wax-seal-like rim, straight front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, text, letters, numbers, watermark, border, shadow, photo, 3d render
```

**U20** – Meisterschafts-Siegel Gold · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 60 Wörter · Datei `seal_mastery_3`  
*21.11.: Goldsiegel mit Lorbeer und drei Sternen.*
```
U20 — Flat orthographic front elevation, like a technical drawing. 2D game UI icon, a round guild seal medallion of shining gold with a small laurel wreath around the rim, embossed crossed hammers above a small anvil, three small stars below the anvil, a wavy wax-seal-like rim, straight front view, hand-painted 2D game art, dark ink outlines, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, text, letters, numbers, watermark, border, shadow, photo, 3d render
```

**U21** – Auftragsbuch aufgeschlagen, Doppelseite (für das Tablet im Querformat, später) · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 78 Wörter · Datei `ledger_spread`  
*21.11.: aufgeschlagenes Auftragsbuch mit roter Doppellinie, Messingecken und Lesebändchen – für das Querformat (Tablet) später; noch nicht im Spiel.*
```
U21 — 2D game asset, an 18th-century leather-bound ledger lying wide open, seen from directly above, landscape 3:2: two facing pages of aged cream parchment with a thin red double border line and faint stains, completely empty, a soft curved gutter in the middle, dark brown leather binding visible around the edges, small brass corner fittings, a red ribbon bookmark lying across the right page, hand-painted 2D game art, dark ink outlines, soft even lighting, on pure flat white background --ar 3:2 --no writing, numbers, cast shadow, text, watermark, border, shadow, photo, 3d render
```

**U22** – Titelbild für das Hauptmenü · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 94 Wörter · Datei `title_art`  
*21.11.: stimmungsvoll (Schmied mit erhobenem Hammer, glühendes Hufeisen, Funken, Feuerschein). Oberes Drittel nicht frei und Schmied links statt mittig – das Hauptmenü zeigt deshalb einen Ausschnitt um den Schmied (TITLE_FOCUS), Titel auf dunklem Verlauf oben, Knöpfe unten. Im Spiel als JPG (370 KB).*
```
U22 — Square 1:1 key art illustration for a game title screen, an English village blacksmith around 1700 in a leather apron at his anvil, seen from the front at a slight distance, hammer raised, a glowing horseshoe on the anvil, a fan of bright sparks, the brick forge glowing behind him, warm firelight against deep dark brown shadows, the upper third of the image calm and dark (smoke-darkened oak beams) as free space for the game title, the blacksmith centred in the middle third of the width, hand-painted 2D game art, dark ink outlines, painterly --ar 1:1 --no text, letters, border, numbers, watermark
```

**U23** – Meisterbrief (Abrechnung nach dem Meisterstück) · ✅ gut (Midjourney)  
Regler: **Portrait 3:4** · 85 Wörter · Datei `master_certificate`  
*21.11.: Pergament mit Rolle, gestochener Rahmen mit Hämmern, Zangen und Eichenlaub, unleserliche Schreibschrift, rotes Zunftsiegel mit gekreuzten Hämmern – genau wie gewünscht. In der Abrechnung jetzt groß (210 px) neben dem Text.*
```
U23 — Flat orthographic front elevation, like a technical drawing. 2D game asset, an 18th-century English blacksmiths' guild master's certificate seen flat from the front: a sheet of aged cream parchment with slightly curled edges, an engraved ornamental frame of hammers, tongs and oak leaves drawn on the paper, a few lines of illegible flourished script, at the bottom a large red wax guild seal with crossed hammers on a red ribbon, hand-painted 2D game art, dark ink outlines, soft even lighting, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, cast shadow, readable text, date, text, numbers, watermark, border, shadow, photo, 3d render
```

**U24** – Zunfttafel Ruf 2: Geachteter Schmied (2 Sterne) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 82 Wörter · Datei `guild_plaque_2`
```
U24 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a rectangular wooden guild plaque of the English blacksmiths' guild, 18th century, to hang flat on a smithy wall, seen exactly from the front at eye level, dark oiled oak board, fixed with four hand-forged iron nails in the corners, a plain narrow brass edging, in a straight row across the middle: two five-pointed brass stars, hand-painted 2D game art, dark ink outlines, warm painterly texture, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, letters, writing, numbers, date, chains, hook, horseshoe, shadow, text, watermark, border, photo, 3d render
```

**U25** – Zunfttafel Ruf 3 (Bild-Prompt: U24 anhängen, --iw 1): Angesehener Meister (3 Sterne) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 87 Wörter · Datei `guild_plaque_3`
```
U25 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a rectangular wooden guild plaque of the English blacksmiths' guild, 18th century, to hang flat on a smithy wall, seen exactly from the front at eye level, dark oiled oak board, fixed with four hand-forged iron nails in the corners, a plain narrow brass edging and small brass corner fittings, in a straight row across the middle: three five-pointed brass stars, hand-painted 2D game art, dark ink outlines, warm painterly texture, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, letters, writing, numbers, date, chains, hook, horseshoe, shadow, text, watermark, border, photo, 3d render
```

**U26** – Zunfttafel Ruf 4 (Bild-Prompt: U24 anhängen, --iw 1): Berühmter Meisterschmied (4 Sterne) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 94 Wörter · Datei `guild_plaque_4`
```
U26 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a rectangular wooden guild plaque of the English blacksmiths' guild, 18th century, to hang flat on a smithy wall, seen exactly from the front at eye level, dark oiled oak board, fixed with four hand-forged iron nails in the corners, a brass frame with corner fittings and a small brass emblem of crossed hammers above the stars, in a straight row across the middle: four five-pointed brass stars, hand-painted 2D game art, dark ink outlines, warm painterly texture, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, letters, writing, numbers, date, chains, hook, horseshoe, shadow, text, watermark, border, photo, 3d render
```

**U27** – Zunfttafel Ruf 5 (Bild-Prompt: U24 anhängen, --iw 1): Legende der Zunft (5 Sterne) · ⬜ noch nicht vorhanden  
Regler: **Landscape 2:1** · 97 Wörter · Datei `guild_plaque_5`
```
U27 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a rectangular wooden guild plaque of the English blacksmiths' guild, 18th century, to hang flat on a smithy wall, seen exactly from the front at eye level, dark oiled oak board, fixed with four hand-forged iron nails in the corners, a gilded carved frame with oak leaves, brass corner fittings and a brass emblem of crossed hammers above the stars, in a straight row across the middle: five five-pointed gilded stars, hand-painted 2D game art, dark ink outlines, warm painterly texture, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, letters, writing, numbers, date, chains, hook, horseshoe, shadow, text, watermark, border, photo, 3d render
```

## H · Werkstatt-Einrichtung (5 je Epoche)

Neu im Spiel: Jede Werkstatt hat fünf Einrichtungsplätze (Brennstoff, Werkzeugwand, Werkbank, Kundschaft, Licht und Lager). Bis die Bilder da sind, zeichnet das Spiel einfache Platzhalter. Freigestellt auf Weiß wie die Werkstücke; Originale nach `assets/source/user_art/furnishings/<id>.png` (über den Eingang). Standard-Modus mit einem Hintergrund der Epoche als Stil-Referenz, damit Licht und Farben zum Raum passen.

### Epoche 1 – Die Dorfschmiede (1700–1715)

**E1-1** – Brennstoff: Holzkohlekorb · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 52 Wörter · Datei `furn_e1_fuel`  
*21.11.: Weidenkorb mit Holzkohle.*
```
E1-1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a woven wicker basket full of charcoal, early 18th-century English village smithy, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E1-2** – Werkzeugwand: Zangenbrett · ✅ gut (Midjourney)  
Regler: **Portrait 3:4** · 58 Wörter · Datei `furn_e1_tools`  
*21.11.: Zangenbrett mit Zangen und Hämmern an der Kordel.*
```
E1-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden board hung on a wall with four pairs of blacksmith's tongs and two hammers, around 1700, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E1-3** – Werkbank: Schleifstein mit Kurbel · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 77 Wörter · Datei `furn_e1_bench`  
*21.11.: Schleifstein mit Lagerböcken, Achse und Kurbel – leichte Dreiviertelansicht (für die Einrichtung so gewollt), wirkt im Raum natürlich.*
```
E1-3 — 2D game asset, a hand-cranked smithy grindstone around 1700: thick sandstone wheel on an iron axle, the axle ends resting in bearings on top of a four-legged oak trestle frame, lower part of the stone dipping into a water trough, crank handle on the axle end, mechanically correct, slight three-quarter view at eye level, one single object only, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E1-4** – Kundschaft: Bemaltes Brett mit Hufeisen über dem Tor · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 59 Wörter · Datei `furn_e1_trade`  
*21.11.: Holzschild mit Hufeisen an zwei Ketten.*
```
E1-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a weathered painted wooden shop board with an iron horseshoe nailed on it, hanging from two chains, around 1700, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E1-5** – Licht und Lager: Talglaterne · ✅ gut (Midjourney)  
Regler: **Portrait 1:2** · 73 Wörter · Datei `furn_e1_light`  
*21.11.: zweite Fassung: Blechlaterne mit Kerze und Hornscheiben an Ring und Haken – zeitgemäß.*
```
E1-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a small square punched-tin candle lantern with horn panes and a ring on top, a tallow candle inside, hanging from an iron hook, around 1700, not a kerosene lamp, not a hurricane lantern, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, glass globe, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 2 – Kutschen & Handelswege (1715–1735)

**E2-1** – Brennstoff: Kohlenkiste · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Square 1:1** · 67 Wörter · Datei `furn_e2_fuel`  
*21.11.: wirkt wie eine Schatztruhe (gewölbter Deckel, verziertes Schlüsselschild, glänzende Kohle) – im Spiel liest man „Piratenschatz“. Prompt jetzt: offene Kohlenkiste aus Brettern ohne Deckel und Schloss, matte Kohle, Schaufel steckt darin.*
```
E2-1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a plain open wooden coal box of rough planks with iron corner straps, heaped with matt black coal, an iron shovel stuck in the coal, around 1725, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, lid, treasure chest, domed lid, lock, keyhole, ornament, text, numbers, watermark, border, shadow, photo, 3d render
```

**E2-2** – Werkzeugwand: Werkzeugwand mit Gesenken · ✅ gut (Midjourney)  
Regler: **Portrait 3:4** · 53 Wörter · Datei `furn_e2_tools`  
*21.11.: Bretterwand mit Zangen, Setzhämmern, Abschrot und Gesenken an zwei Leisten, frontal, gemalt. Kleine Signatur unten rechts im Original weiß übermalt.*
```
E2-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden tool wall with tongs, swages and fullers on pegs, around 1725, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E2-3** – Werkbank: Werkbank mit Schraubstock · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 51 Wörter · Datei `furn_e2_bench`  
*21.11.: schwere Eichen-Werkbank mit Schraubstock, leichte Dreiviertelansicht.*
```
E2-3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a heavy oak workbench with a blacksmith's leg vice, around 1725, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E2-4** – Kundschaft: Schild „Smith & Farrier“ an der Straße · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 56 Wörter · Datei `furn_e2_trade`  
*21.11.: Wirtshausschild mit Hufeisen und Hammer an geschmiedetem Ausleger.*
```
E2-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a painted hanging inn-style sign board showing a horseshoe and a hammer, wrought-iron bracket, around 1725, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E2-5** – Licht und Lager: Stabeisenregal · ✅ gut (Midjourney)  
Regler: **Portrait 1:2** · 50 Wörter · Datei `furn_e2_light`  
*21.11.: Ständer mit langen Eisenstangen.*
```
E2-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden rack holding long iron bars of different sections, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 3 – Hafen & Royal Navy (1735–1750)

**E3-1** – Brennstoff: Kohlenschütte · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 56 Wörter · Datei `furn_e3_fuel`  
*21.11.: Kohlenschütte aus Holz mit Haufen davor (wirkt etwas wie ein Förderturm, im Spiel unauffällig).*
```
E3-1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden coal chute with a heap of coal at its foot, naval dockyard around 1740, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E3-2** – Werkzeugwand: Gesenkblock · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 56 Wörter · Datei `furn_e3_tools`
```
E3-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a square cast-iron swage block with many holes and shaped grooves standing on a wooden stand, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E3-3** – Werkbank: Werkbank mit Feilen · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 54 Wörter · Datei `furn_e3_bench`
```
E3-3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a tarred oak workbench with a vice and a row of files, around 1740, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E3-4** – Kundschaft: Anschlagtafel der Admiralität · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 56 Wörter · Datei `furn_e3_trade`  
*21.11.: Aushangbrett mit leeren Aufträgen und Anker-Emblem.*
```
E3-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden notice board with pinned paper orders and an anchor emblem, around 1740 (blank papers), one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E3-5** – Licht und Lager: Schiffslaterne · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Portrait 1:2** · 69 Wörter · Datei `furn_e3_light`  
*21.11.: Schiffslaterne wie eine Sturm-/Petroleumlaterne mit Glaskolben und Brennstofftank (erst ab ~1850) → Prompt: Kerze hinter flachen Glasscheiben, ohne Glaskolben.*
```
E3-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a square brass ship's lantern with flat glass panes, a pierced conical top and a ring, a candle inside, around 1740, not a kerosene lamp, not a hurricane lantern, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, glass globe, fuel tank, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 4 – Stahl & Tuch (1750–1765)

**E4-1** – Brennstoff: Koksvorrat · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 54 Wörter · Datei `furn_e4_fuel`  
*21.11.: Holzkiste mit Brennstoff; zeigt schwarze Kohle statt grauem Koks – klein im Spiel, Prompt für künftige Bilder geschärft.*
```
E4-1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a timber bin filled with light grey porous coke (not black coal), around 1755, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E4-2** – Werkzeugwand: Zangenreihe für Klingen · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Portrait 3:4** · 67 Wörter · Datei `furn_e4_tools`  
*21.11.: Reihe aus Spießen statt zweischenkliger Zangen – liest sich nicht als Zangenregal → Prompt geschärft.*
```
E4-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wall rack with a long row of slender two-legged blacksmith's tongs hanging jaws up, for knife blades, Sheffield around 1755, clearly tongs with two handles each, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E4-3** – Werkbank: Schleifbock mit Wasserrad · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 76 Wörter · Datei `furn_e4_bench`
```
E4-3 — 2D game asset, a Sheffield grinding trough around 1755: large sandstone grindstone on an iron axle resting in bearings on a heavy timber frame, lower part of the stone in a water trough, leather belt from a pulley on the axle to a drive shaft, mechanically correct, slight three-quarter view at eye level, one single object only, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E4-4** – Kundschaft: Firmenmarke der Cutlers' Company · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 53 Wörter · Datei `furn_e4_trade`  
*21.11.: runde Holzplakette mit gekreuzten Klingen (Messerschmiedzeichen).*
```
E4-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a carved wooden plaque with a simple cutler's mark (crossed blades), around 1755, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, lettering, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E4-5** – Licht und Lager: Öllampen · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Portrait 1:2** · 62 Wörter · Datei `furn_e4_light`  
*21.11.: zwei Regale (Varianten) mit Lampen mit Glaszylinder und einer Sturmlaterne (erst ab ~1780/1850) → ein Regal, drei offene Tüllenlampen.*
```
E4-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, one wooden wall shelf with three small open brass spout oil lamps with a burning wick, around 1755, not a kerosene lamp, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, glass chimney, glass globe, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 5 – Das Zeitalter des Dampfes (1765–1785)

**E5-1** – Brennstoff: Kohlenhund · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 61 Wörter · Datei `furn_e5_fuel`  
*21.11.: Kohlenhunt in Seitenansicht, runde Räder.*
```
E5-1 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a small four-wheeled wooden coal tub full of coal seen exactly from the side, the wheels as perfect circles, around 1780, one single object only, straight side view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E5-2** – Werkzeugwand: Werkzeugwand mit Setzhämmern · ✅ gut (Midjourney)  
Regler: **Portrait 3:4** · 54 Wörter · Datei `furn_e5_tools`  
*21.11.: Werkzeugwand mit Setzhämmern und Gesenken.*
```
E5-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden tool wall with set hammers, flatters and swages on pegs, around 1780, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E5-3** – Werkbank: Drehbank mit Fußantrieb · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 60 Wörter · Datei `furn_e5_bench`  
*21.11.: Tretdrehbank in Seitenansicht mit Schwungrädern und Pedal.*
```
E5-3 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a wooden treadle lathe seen exactly from the side, its flywheel a perfect circle, with a foot pedal, around 1780, one single object only, straight side view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E5-4** – Kundschaft: Schreibpult mit Auftragsbuch · ✅ gut (Midjourney)  
Regler: **Landscape 3:2** · 58 Wörter · Datei `furn_e5_trade`  
*21.11.: Schreibsekretär mit aufgeschlagenem Auftragsbuch und Feder.*
```
E5-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a tall wooden writing desk with an open leather order book and a quill, around 1780 (blank pages), one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E5-5** – Licht und Lager: Stabeisenlager · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Landscape 2:1** · 57 Wörter · Datei `furn_e5_light`  
*21.11.: fünf Stapel (Varianten) untereinander statt eines Stapels – Hochformat passte nicht zum liegenden Stapel → Format 2:1, ein Stapel.*
```
E5-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, one single stack of wrought-iron bars and plates lying on two timber bearers, seen from the front, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 2:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 6 – Das Zeitalter der Eisenwerke (1785–1800)

**E6-1** – Brennstoff: Koksbunker · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Square 1:1** · 65 Wörter · Datei `furn_e6_fuel`  
*21.11.: Ziegelgewölbe mit Holztür – wirkt wie ein Backofen → offene Ziegelbucht mit grauem Koks.*
```
E6-1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, an open-topped rectangular bay of low brick walls heaped with light grey porous coke, a wooden board in front, ironworks around 1790, not an oven, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, arch, dome, door, text, numbers, watermark, border, shadow, photo, 3d render
```

**E6-2** – Werkzeugwand: Gesenksatz · ✅ gut (Midjourney)  
Regler: **Portrait 3:4** · 54 Wörter · Datei `furn_e6_tools`  
*21.11.: Werkbank mit Gesenken und Setzeisen.*
```
E6-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a set of iron swages and dies arranged on a wooden rack, around 1790, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E6-3** – Werkbank: Schraubstockbank · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 51 Wörter · Datei `furn_e6_bench`
```
E6-3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a long workbench with two vices and iron tools, around 1790, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E6-4** – Kundschaft: Kontor mit Schreiber · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Landscape 3:2** · 69 Wörter · Datei `furn_e6_trade`  
*21.11.: leerer Holzschrank statt Kontor mit Pult und Hauptbüchern → Prompt mit Bestandteilen.*
```
E6-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a small wooden counting-house booth: a sloped writing desk on legs with an open ledger, stacked ledgers on a shelf above, a low wooden half-wall around it, around 1790, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, people, variations, second version, cabinet doors, wardrobe (blank pages), text, numbers, watermark, border, shadow, photo, 3d render
```

**E6-5** – Licht und Lager: Öllampenreihe · 🟠 von Midjourney vorhanden – sollte noch verändert werden  
Regler: **Portrait 1:2** · 65 Wörter · Datei `furn_e6_light`  
*21.11.: drei Sturmlaternen mit Glaskolben (erst ab ~1850) → Kerzenlaternen mit flachen Scheiben.*
```
E6-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a row of three hanging candle lanterns with flat glass panes on an iron bar, around 1790, not a kerosene lamp, not a hurricane lantern, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, glass globe, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 7 – Krieg & Erfindergeist (1800–1820)

**E7-1** – Brennstoff: Kohlenaufzug · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 55 Wörter · Datei `furn_e7_fuel`
```
E7-1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden coal hoist with a rope, pulley and a coal bucket, London around 1810, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E7-2** – Werkzeugwand: Normallehren und Schablonen · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 53 Wörter · Datei `furn_e7_tools`
```
E7-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wall board with iron templates, gauges and squares, engineering works around 1810, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E7-3** – Werkbank: Werkbank mit Messschraube · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 53 Wörter · Datei `furn_e7_bench`
```
E7-3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a cast-iron workbench with a vice and a brass bench micrometer, around 1810, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E7-4** – Kundschaft: Messingschild am Tor · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 52 Wörter · Datei `furn_e7_trade`
```
E7-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a polished brass name plate on a dark wooden board, around 1810, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, lettering, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E7-5** – Licht und Lager: Gaslicht · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 55 Wörter · Datei `furn_e7_light`
```
E7-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, an early gas lamp on a wall bracket with a glass globe, London around 1812, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 8 – Eisenbahnfieber (1820–1839)

**E8-1** – Brennstoff: Kohlenwagen auf Schienen · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 64 Wörter · Datei `furn_e8_fuel`
```
E8-1 — Flat orthographic side elevation, like a technical drawing. 2D game asset, a small iron coal wagon on a short piece of rail track seen exactly from the side, the wheels as perfect circles, around 1830, one single object only, straight side view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E8-2** – Werkzeugwand: Gesenke für Kupplungen · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 53 Wörter · Datei `furn_e8_tools`
```
E8-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a rack with heavy swages and dies for railway coupling links, around 1830, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E8-3** – Werkbank: Prüfbank · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 54 Wörter · Datei `furn_e8_bench`
```
E8-3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a cast-iron proving bench for testing chains, with a lever and weights, around 1830, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E8-4** – Kundschaft: Anschlag der Eisenbahngesellschaft · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 54 Wörter · Datei `furn_e8_trade`
```
E8-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a wooden notice board with a railway company poster showing a locomotive, around 1830, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, lettering, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E8-5** – Licht und Lager: Gaslicht · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 52 Wörter · Datei `furn_e8_light`
```
E8-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a cast-iron gas lamp on a wall bracket with a glass globe, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 9 – Der Dampfhammer (1839–1860)

**E9-1** – Brennstoff: Bunker mit Schütte · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 51 Wörter · Datei `furn_e9_fuel`
```
E9-1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a riveted iron coal bunker with a chute, foundry around 1845, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E9-2** – Werkzeugwand: Drehkran · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 52 Wörter · Datei `furn_e9_tools`
```
E9-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a small cast-iron jib crane with a chain hoist, foundry around 1845, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E9-3** – Werkbank: Prüfbank mit Lehren · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 50 Wörter · Datei `furn_e9_bench`
```
E9-3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a cast-iron proving bench with gauges and callipers, around 1845, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E9-4** – Kundschaft: Telegraf · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 52 Wörter · Datei `furn_e9_trade`
```
E9-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, an early electric needle telegraph instrument in a wooden case, around 1845, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, lettering, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E9-5** – Licht und Lager: Gaslaternen · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 49 Wörter · Datei `furn_e9_light`
```
E9-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, two gas lamps with glass globes on iron brackets, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

### Epoche 10 – Das Stahlzeitalter (1860–1880)

**E10-1** – Brennstoff: Gasgenerator · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 54 Wörter · Datei `furn_e10_fuel`
```
E10-1 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a riveted iron gas producer with pipes and a valve wheel, steelworks around 1870, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E10-2** – Werkzeugwand: Laufkran · ⬜ noch nicht vorhanden  
Regler: **Portrait 3:4** · 55 Wörter · Datei `furn_e10_tools`
```
E10-2 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a section of an overhead travelling crane with a hook and chain, steelworks around 1870, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:4 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E10-3** – Werkbank: Werkstoff-Prüfmaschine · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 54 Wörter · Datei `furn_e10_bench`
```
E10-3 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a large horizontal materials testing machine with a lever, weights and dial, around 1870, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

**E10-4** – Kundschaft: Kontor mit Telegraf · ⬜ noch nicht vorhanden  
Regler: **Landscape 3:2** · 52 Wörter · Datei `furn_e10_trade`
```
E10-4 — Flat orthographic front elevation, like a technical drawing. 2D game asset, a small office desk with a telegraph key and sounder, around 1870, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 3:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, people, variations, second version, text, numbers, watermark, border, shadow, photo, 3d render
```

**E10-5** – Licht und Lager: Gaslicht und Bogenlampe · ⬜ noch nicht vorhanden  
Regler: **Portrait 1:2** · 51 Wörter · Datei `furn_e10_light`
```
E10-5 — Flat orthographic front elevation, like a technical drawing. 2D game asset, an early electric arc lamp in an iron frame, around 1878, one single object only, straight front view at eye level, hand-painted 2D game art, dark ink outlines, warm painterly texture, fully inside the frame, on pure flat white background --ar 1:2 --no perspective, isometric view, three-quarter view, angled view, vanishing point, variations, second version, people, text, numbers, watermark, border, shadow, photo, 3d render
```

## I · Rohformen für den Stufensprung (je Werkstück eine)

Das Spiel zeigt beim Schmieden zuerst den Rohling (W0), nach dem ersten Arbeitsgang die **Rohform** und am Ende das fertige Werkstück. Kürzel = Kürzel des fertigen Werkstücks mit „R“ (W1-2R ist die Rohform von W1-2). **Wichtig:** Das fertige Werkstück als **Bild-Prompt** anhängen (Bild in die Prompt-Leiste ziehen), der Prompt endet schon mit `--iw 0.5` – so bleiben Lage und Blickrichtung ungefähr gleich, ohne dass Midjourney das fertige Stück kopiert (mit `--iw 1.5` kam bei W1-1R einfach wieder der fertige Nagel). Die Rohform zeigt den Stand **nach dem ersten Arbeitsgang**; was die späteren Arbeitsgänge erst formen (Spitze, Kopf, Biegung, Löcher, Verdrillung), steht ausdrücklich als Verbot im Prompt. Kommt trotzdem ein zu fertiges Stück: im Midjourney-Editor am fertigen Bild die Teile wegradieren und neu füllen lassen. Grundsatz (Auftraggeber, 21.11.): **jedes Werkstück eine eigene Rohform** – nur wo der Stand nach dem ersten Arbeitsgang gleich ist und ein eigenes Bild nichts bringt, teilen sich Werkstücke eine (z. B. alle Ketten die des Kettenglieds); diese sind unten vermerkt, Tabelle `ROUGH_SHARED` in `scripts/assets.gd`. Rohformen erst für Werkstücke anlegen, deren fertiges Bild „gut“ ist.

### Epoche 1 – Die Dorfschmiede (1700–1715)

**W1-1R** – Nagel – Rohform · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 66 Wörter · Datei `nail_rough`  
*21.11.: zweiter Versuch (neuer Prompt): gestreckter Vierkantstab mit stumpfem Ende und Kopfansatz, ohne Spitze; deckt sich in Lage und Länge fast genau mit dem Nagel – sauberes Überblenden.*
```
W1-1R — 2D game asset, a long straight square iron rod drawn out by hammering, lying horizontally like the nail in the reference, both ends still blunt and square-cut, only a slightly thicker rough stub at the left end, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no sharp point, tapered tip, nail head, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W1-2R** – Hufeisen – Rohform · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 65 Wörter · Datei `horseshoe_rough`  
*21.11.: gestreckter Flachstab, leicht gebogen, ohne Nagellöcher – im Spiel klar vom Rohling und vom Hufeisen zu unterscheiden. Gilt auch für: Postpferd-Hufeisen.*
```
W1-2R — 2D game asset, a flat iron bar drawn out by hammering, still almost straight, only very slightly curved like a shallow arch, lying horizontally across the centre, both ends blunt, not yet bent into a U, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no nail holes, fullered groove, horseshoe shape, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W1-3R** – Haken – Rohform · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 59 Wörter · Datei `hook_rough`  
*21.11.: gerader Rundstab, senkrecht, beide Enden stumpf – aus ihm wird im Spiel der S-Haken.*
```
W1-3R — 2D game asset, a round iron rod drawn out by hammering, still straight, standing upright in the centre along the long axis of the S-hook, both ends blunt and thick, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no points, curls, S shape, hook, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W1-4R** – Türangel – Rohform · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 54 Wörter · Datei `door_hinge_rough`  
*21.11.: flaches Band ohne Öse, Löcher und Spitze, Lage wie die Türangel.*
```
W1-4R — 2D game asset, a long flat iron strap hammered flat, lying horizontally where the hinge lies in the reference, both ends plain and roughly rounded, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no rolled loop, knuckle, nail holes, spear tip, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W1-5R** – Sichel – Rohform · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 58 Wörter · Datei `sickle_rough`  
*21.11.: dicker, leicht gekrümmter Stab mit Angel; Angel lag rechts statt links – der Import spiegelt das Bild (ROUGH_MIRROR).*
```
W1-5R — 2D game asset, a thick iron bar drawn out by hammering with a short tang at one end, lying diagonally, only slightly curved, not yet flattened into a blade, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thin cutting edge, crescent shape, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W1-6R** – Pflugschar – Rohform · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 60 Wörter · Datei `ploughshare_rough`  
*21.11.: grobe Dreiecksplatte mit Zunder und Dellen; Umriss fast wie die fertige Schar – der Sprung zeigt sich vor allem an der Oberfläche (rau → glatt), das entspricht dem Arbeitsgang Glätten.*
```
W1-6R — 2D game asset, a thick flat iron plate roughly hammered out into a triangle, ragged uneven edges, deep hammer dents, the short socket stub at the left still flat and unbent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, sharp edge, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W1-7R** – Schürhaken – Rohform · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 57 Wörter · Datei `fire_poker_rough`  
*21.11.: gerader Stab mit Ring, ohne Verdrillung und Haken; deckt sich in der Lage mit dem Schürhaken.*
```
W1-7R — 2D game asset, a long straight square iron rod drawn out by hammering, lying horizontally, with a roughly bent ring at the right end, the left end blunt, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no twisted section, spiral, hooked tip, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W1-8R** – Torriegel – Rohform · ✅ gut (Midjourney)  
Regler: **Square 1:1** · 51 Wörter · Datei `gate_latch_rough`  
*21.11.: gerader Flachstab ohne Schnecke, Löcher, Zierblech und Krampe. Sehr ähnlich wie die Türangel-Rohform – gewollt, beide sind nach dem Flachschlagen ein Band.*
```
W1-8R — 2D game asset, a straight flat iron bar hammered flat, lying horizontally like the latch bar in the reference, both ends plain, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curled scroll, nail holes, decorative leaf work, keeper, staple, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 2 – Kutschen & Handelswege (1715–1735)

**W2-1R** – Radreifen – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `wheel_tyre_rough`
```
W2-1R — 2D game asset, the raw iron for a wheel tyre right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the wheel tyre in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, holes, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W2-2R** – Kutschachse – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `coach_axle_rough`
```
W2-2R — 2D game asset, the raw iron for a coach axle right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the coach axle in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W2-3R** – Kutschbeschlag – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `coach_fitting_rough`
```
W2-3R — 2D game asset, the raw iron for a coach fitting right after the first forging step, only hammered flat, same position and orientation as the coach fitting in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, holes, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W2-4R** – Laternenhalter – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `lantern_bracket_rough`
```
W2-4R — 2D game asset, the raw iron for a lantern bracket right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the lantern bracket in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no twisted section, curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W2-5R** – Postpferd-Hufeisen – Rohform · *kein eigenes Bild nötig: nutzt die Rohform von Hufeisen (W1-2R), gleicher Stand nach dem ersten Arbeitsgang*

**W2-6R** – Schlagbaumbeschlag – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `turnpike_fitting_rough`
```
W2-6R — 2D game asset, the raw iron for a turnpike gate fitting right after the first forging step, only hammered flat, same position and orientation as the turnpike gate fitting in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no holes, curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W2-7R** – Hemmschuh – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter · Datei `drag_shoe_rough`
```
W2-7R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a drag shoe right after the first forging step, only hammered flat, same position and orientation as the drag shoe in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 3 – Hafen & Royal Navy (1735–1750)

**W3-1R** – Kettenglied – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `chain_link_rough`
```
W3-1R — 2D game asset, the raw iron for a chain link right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the chain link in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W3-2R** – Ankerschaft – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `anchor_shank_rough`
```
W3-2R — 2D game asset, the raw iron for a anchor shank right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the anchor shank in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W3-3R** – Bootshaken – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter · Datei `boathook_rough`
```
W3-3R — 2D game asset, the raw iron for a boathook right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the boathook in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no sharp point, curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W3-4R** – Festmacherring – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `mooring_ring_rough`
```
W3-4R — 2D game asset, the raw iron for a mooring ring right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the mooring ring in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W3-5R** – Schiffsbolzen – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `ship_bolt_rough`
```
W3-5R — 2D game asset, the raw iron for a ship's bolt right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the ship's bolt in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W3-6R** – Lafettenbeschlag – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `carriage_fitting_rough`
```
W3-6R — 2D game asset, the raw iron for a gun-carriage fitting right after the first forging step, only hammered flat, same position and orientation as the gun-carriage fitting in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, holes, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W3-7R** – Ruderfingerling – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 82 Wörter · Datei `rudder_pintle_rough`
```
W3-7R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a rudder pintle right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the rudder pintle in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, curves, loops, thickened head, collar, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 4 – Stahl & Tuch (1750–1765)

**W4-1R** – Spindel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `spindle_rough`
```
W4-1R — 2D game asset, the raw iron for a spindle right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the spindle in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no sharp point, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W4-2R** – Tuchschere – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `cloth_shears_rough`
```
W4-2R — 2D game asset, the raw iron for a pair of cloth shears right after the first forging step, only hammered flat, same position and orientation as the pair of cloth shears in the reference, still far from the finished shape, ends not yet trimmed, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W4-3R** – Messerklinge – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter · Datei `knife_rough`
```
W4-3R — 2D game asset, the raw iron for a knife blade right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the knife blade in the reference, still far from the finished shape, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W4-4R** – Feder – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 84 Wörter · Datei `spring_rough`
```
W4-4R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a spring right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the spring in the reference, still far from the finished shape, not yet hammered flat, not yet bent, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W4-5R** – Meißel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `chisel_rough`
```
W4-5R — 2D game asset, the raw iron for a chisel right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the chisel in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no sharp point, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W4-6R** – Feile – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter · Datei `file_rough`
```
W4-6R — 2D game asset, the raw iron for a file right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the file in the reference, still far from the finished shape, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W4-7R** – Ladekette – Rohform · *kein eigenes Bild nötig: nutzt die Rohform von Kettenglied (W3-1R), gleicher Stand nach dem ersten Arbeitsgang*

**W4-8R** – Fassreifen – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `barrel_hoop_rough`
```
W4-8R — 2D game asset, the raw iron for a barrel hoop right after the first forging step, only hammered flat, same position and orientation as the barrel hoop in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 5 – Das Zeitalter des Dampfes (1765–1785)

**W5-1R** – Kolbenstange – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 79 Wörter · Datei `piston_rod_rough`
```
W5-1R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a piston rod right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the piston rod in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W5-2R** – Ventilteil – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 78 Wörter · Datei `valve_part_rough`
```
W5-2R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a valve part right after the first forging step, only thickened at one end by upsetting, same position and orientation as the valve part in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, holes, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W5-3R** – Kohlenschaufel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `beam_strap_rough`
```
W5-3R — 2D game asset, the raw iron for a coal shovel right after the first forging step, only hammered flat, same position and orientation as the coal shovel in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, holes, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W5-4R** – Schleusenkurbel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `lock_fitting_rough`
```
W5-4R — 2D game asset, the raw iron for a lock windlass right after the first forging step, only hammered flat, same position and orientation as the lock windlass in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no holes, curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W5-5R** – Keilhaue – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `miners_pick_rough`
```
W5-5R — 2D game asset, the raw iron for a miner's pick right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the miner's pick in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no sharp point, holes, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W5-6R** – Bohreisen – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `drill_steel_rough`
```
W5-6R — 2D game asset, the raw iron for a drill steel right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the drill steel in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no sharp point, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W5-7R** – Förderkette – Rohform · *kein eigenes Bild nötig: nutzt die Rohform von Kettenglied (W3-1R), gleicher Stand nach dem ersten Arbeitsgang*

**W5-8R** – Pumpenschwengel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `pump_rod_rough`
```
W5-8R — 2D game asset, the raw iron for a pump handle right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the pump handle in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 6 – Das Zeitalter der Eisenwerke (1785–1800)

**W6-1R** – Kesselniete – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 79 Wörter · Datei `boiler_rivet_rough`
```
W6-1R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a boiler rivet right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the boiler rivet in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, thickened head, collar, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W6-2R** – Kesselblech – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 65 Wörter · Datei `boiler_plate_rough`
```
W6-2R — 2D game asset, the raw iron for a boiler plate right after the first forging step, only hammered flat, same position and orientation as the boiler plate in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W6-3R** – Puddelkrücke – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter · Datei `rabble_rough`
```
W6-3R — 2D game asset, the raw iron for a puddling rabble right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the puddling rabble in the reference, still far from the finished shape, not yet bent, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W6-4R** – Zuganker – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `tie_rod_rough`
```
W6-4R — 2D game asset, the raw iron for a tie rod right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the tie rod in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W6-5R** – Ankerkette – Rohform · *kein eigenes Bild nötig: nutzt die Rohform von Kettenglied (W3-1R), gleicher Stand nach dem ersten Arbeitsgang*

**W6-6R** – Drehmeißel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter · Datei `lathe_tool_rough`
```
W6-6R — 2D game asset, the raw iron for a lathe tool right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the lathe tool in the reference, still far from the finished shape, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W6-7R** – Blattfeder – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter · Datei `leaf_spring_rough`
```
W6-7R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a leaf spring right after the first forging step, only hammered flat, same position and orientation as the leaf spring in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W6-8R** – Wagenachse – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `wagon_axle_rough`
```
W6-8R — 2D game asset, the raw iron for a wagon axle right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the wagon axle in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W6-9R** – Antriebswelle – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `large_shaft_rough`
```
W6-9R — 2D game asset, the raw iron for a drive shaft right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the drive shaft in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W6-10R** – Kurbelwelle – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 80 Wörter · Datei `crankshaft_rough`
```
W6-10R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a crankshaft right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the crankshaft in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 7 – Krieg & Erfindergeist (1800–1820)

**W7-1R** – Blockrollen-Bolzen – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter · Datei `block_pin_rough`
```
W7-1R — 2D game asset, the raw iron for a pulley-block pin right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the pulley-block pin in the reference, still far from the finished shape, ends not yet trimmed, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W7-2R** – Kessel-Stehbolzen – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter · Datei `boiler_stay_rough`
```
W7-2R — 2D game asset, the raw iron for a boiler stay right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the boiler stay in the reference, still far from the finished shape, ends not yet trimmed, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W7-3R** – Gaslaternen-Ausleger – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `gas_lamp_bracket_rough`
```
W7-3R — 2D game asset, the raw iron for a gas-lamp bracket right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the gas-lamp bracket in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, twisted section, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W7-4R** – Spaten – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter · Datei `navvy_spade_rough`
```
W7-4R — 2D game asset, the raw iron for a navvy's spade right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the navvy's spade in the reference, still far from the finished shape, not yet hammered flat, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W7-5R** – Pressenspindel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `press_screw_rough`
```
W7-5R — 2D game asset, the raw iron for a press screw right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the press screw in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no twisted section, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W7-6R** – Bajonett – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 68 Wörter · Datei `bayonet_rough`
```
W7-6R — 2D game asset, the raw iron for a bayonet right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the bayonet in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no sharp point, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W7-7R** – Draggen – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 81 Wörter · Datei `anchor_fluke_rough`
```
W7-7R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a grapnel right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the grapnel in the reference, still far from the finished shape, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W7-8R** – Brückenglied – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `chain_eyebar_rough`
```
W7-8R — 2D game asset, the raw iron for a bridge eyebar right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the bridge eyebar in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, holes, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 8 – Eisenbahnfieber (1820–1839)

**W8-1R** – Schienennagel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `rail_spike_rough`
```
W8-1R — 2D game asset, the raw iron for a track spike right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the track spike in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no sharp point, thickened head, collar, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W8-2R** – Kupplungshaken – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `coupling_hook_rough`
```
W8-2R — 2D game asset, the raw iron for a coupling hook right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the coupling hook in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, holes, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W8-3R** – Sicherheitsventil-Hebel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `safety_valve_lever_rough`
```
W8-3R — 2D game asset, the raw iron for a safety-valve lever right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the safety-valve lever in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no holes, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W8-4R** – Kupplungskette – Rohform · *kein eigenes Bild nötig: nutzt die Rohform von Kettenglied (W3-1R), gleicher Stand nach dem ersten Arbeitsgang*

**W8-5R** – Lokomotiv-Radreifen – Rohform · *kein eigenes Bild nötig: nutzt die Rohform von Radreifen (W2-1R), gleicher Stand nach dem ersten Arbeitsgang*

**W8-6R** – Pufferfeder – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 82 Wörter · Datei `buffer_spring_rough`
```
W8-6R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a buffer spring right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the buffer spring in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W8-7R** – Treibstange – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `connecting_rod_rough`
```
W8-7R — 2D game asset, the raw iron for a connecting rod right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the connecting rod in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, holes, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W8-8R** – Kurbelachse – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 82 Wörter · Datei `crank_axle_rough`
```
W8-8R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a crank axle right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the crank axle in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 9 – Der Dampfhammer (1839–1860)

**W9-1R** – Brückenniete – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 78 Wörter · Datei `bridge_rivet_rough`
```
W9-1R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a bridge rivet right after the first forging step, only thickened at one end by upsetting, same position and orientation as the bridge rivet in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W9-2R** – Säulenkopf-Beschlag – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `palace_bracket_rough`
```
W9-2R — 2D game asset, the raw iron for a column-head bracket right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the column-head bracket in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, holes, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W9-3R** – Schaufelrad-Arm – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `paddle_arm_rough`
```
W9-3R — 2D game asset, the raw iron for a paddle-wheel arm right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the paddle-wheel arm in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no holes, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W9-4R** – Hammergesenk – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 82 Wörter · Datei `hammer_die_rough`
```
W9-4R — Flat orthographic side elevation, like a technical drawing. 2D game asset, the raw iron for a hammer die right after the first forging step, only thickened at one end by upsetting, same position and orientation as the hammer die in the reference, still far from the finished shape, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, seen from the side, horizontal, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no perspective, isometric view, three-quarter view, angled view, vanishing point, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W9-5R** – Admiralitätsanker – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 77 Wörter · Datei `admiralty_anchor_rough`
```
W9-5R — 2D game asset, the raw iron for a Admiralty anchor right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the Admiralty anchor in the reference, still far from the finished shape, not yet bent, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W9-6R** – Schiffs-Kolbenstange – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 72 Wörter · Datei `marine_piston_rod_rough`
```
W9-6R — 2D game asset, the raw iron for a marine piston rod right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the marine piston rod in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W9-7R** – Schiffskurbel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `marine_crank_rough`
```
W9-7R — 2D game asset, the raw iron for a marine crank right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the marine crank in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no holes, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W9-8R** – Schraubenwelle – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `propeller_shaft_rough`
```
W9-8R — 2D game asset, the raw iron for a propeller shaft right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the propeller shaft in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

### Epoche 10 – Das Stahlzeitalter (1860–1880)

**W10-1R** – Hochrad-Gabel – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `velocipede_fork_rough`
```
W10-1R — 2D game asset, the raw iron for a velocipede fork right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the velocipede fork in the reference, still far from the finished shape, not yet bent, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no curves, loops, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W10-2R** – Stahlachse – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `steel_axle_rough`
```
W10-2R — 2D game asset, the raw iron for a steel axle right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the steel axle in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W10-3R** – Mähmesser – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 74 Wörter · Datei `reaper_knife_rough`
```
W10-3R — 2D game asset, the raw iron for a reaper knife right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the reaper knife in the reference, still far from the finished shape, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W10-4R** – Tunnelbohrer – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `tunnel_drill_rough`
```
W10-4R — 2D game asset, the raw iron for a tunnelling drill right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the tunnelling drill in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, sharp point, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W10-5R** – Stahl-Radreifen – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 71 Wörter · Datei `steel_tyre_rough`
```
W10-5R — 2D game asset, the raw iron for a steel tyre right after the first forging step, only with roughly punched holes, same position and orientation as the steel tyre in the reference, still far from the finished shape, not yet drawn out, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W10-6R** – Geschützring – Rohform · *kein eigenes Bild nötig: nutzt die Rohform von Radreifen (W2-1R), gleicher Stand nach dem ersten Arbeitsgang*

**W10-7R** – Panzerplatte – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 73 Wörter · Datei `armour_plate_rough`
```
W10-7R — 2D game asset, the raw iron for a armour plate right after the first forging step, only thickened at one end by upsetting, same position and orientation as the armour plate in the reference, still far from the finished shape, not yet hammered flat, crude and unfinished, uneven hammer marks, dark grey wrought iron with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

**W10-8R** – Stahlwelle – Rohform · ⬜ noch nicht vorhanden  
Regler: **Square 1:1** · 70 Wörter · Datei `steel_shaft_rough`
```
W10-8R — 2D game asset, the raw iron for a steel shaft right after the first forging step, only drawn out longer and thinner by hammering, same position and orientation as the steel shaft in the reference, still far from the finished shape, crude and unfinished, uneven hammer marks, dark grey forged steel with fresh forge scale, top-down view, lying flat, centred with wide margin, metal only, cold, pure flat white background --ar 1:1 --no thickened head, collar, smooth surface, polish, decoration, text, numbers, watermark, border, shadow, photo, 3d render --iw 0.5
```

