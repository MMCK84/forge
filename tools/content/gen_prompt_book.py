# -*- coding: utf-8 -*-
"""Erzeugt das vollständige Prompt-Heft für alle Bilder des Spiels mit Status je Bild
(vorhanden / fehlt / neu zu machen / optional):

    python tools/content/gen_prompt_book.py

Ausgabe: assets/source/user_art/PROMPTS_Hochformat.md. Den Status liest das Skript aus den
fertig aufbereiteten Grafiken in assets/sprites/ui/user/ und assets/source/user_art/.
Prompts der Werkstücke stammen aus PROMPTS_Werkstuecke.md (Epochen 1–6) und
docs/Erweiterung_Epochen_7-10.md (Epochen 7–10).
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, HERE)
from content import ITEMS, CUSTOMERS  # noqa: E402

USER = os.path.join(ROOT, "assets", "sprites", "ui", "user")
SRC = os.path.join(ROOT, "assets", "source", "user_art")
OUT = os.path.join(SRC, "PROMPTS_Hochformat.md")

# Interne Zwischenwerte (vom Dateisystem) …
HAVE, NEED, REDO, OPT = "_vorhanden_", "_fehlt_", "_neu_", "_optional_"
# … und die vier Stufen im Heft
NOT = "⬜ noch nicht vorhanden"
NOT_OPT = "⬜ noch nicht vorhanden (optional)"
GEMINI = "🟡 von Gemini vorhanden – durch Midjourney ersetzen"
MJ_CHANGE = "🟠 von Midjourney vorhanden – sollte noch verändert werden"
GOOD = "✅ gut (Midjourney)"

# Erkenntnisse aus gelieferten Bildern: (Datum, gilt für, Beobachtung, Umsetzung in den Prompts).
# Jede Erkenntnis steckt in einem gemeinsamen Baustein, damit ALLE betroffenen Prompts aktuell sind.
LESSONS = [
    ("19.11.", "alle", "Jahreszahlen und Schrift im Bild („1772“ auf dem Hammer, „1775“ auf dem Victoria-Siegel)",
     "`--no text, letters, numbers, date, signature, watermark` bei jedem Prompt"),
    ("19.11.", "alle Bilder auf weißem Grund", "weißer Sticker-Rand mit Kontur um den Nagel",
     "`--no sticker border, outline frame, drop shadow, ground shadow` bei allen freigestellten Bildern"),
    ("19.11.", "Werkstücke", "Holzstiele würden im Spiel mitglühen", "„metal only“, `--no wood, leather, rope`"),
    ("19.11.", "Werkstücke", "eingemalte Glut wäre auch kalt sichtbar", "„cold and unheated“, `--no glow, sparks, fire`"),
    ("20.11.", "Hämmer", "Schrägansicht trifft nicht flach auf das Werkstück", "reine Seitenansicht, Kopf links senkrecht, Stiel waagerecht"),
    ("20.11.", "Essen", "Schrägansicht passt nicht in die frontalen Räume", "Frontalansicht leicht von oben, Glutbett als waagerechter Streifen"),
    ("20.11.", "Essen", "Kohlehaufen und Zangen lagen vor dem Glutbett", "„nothing in front of the hearth“"),
    ("20.11.", "Hintergründe", "Midjourney setzte die Wand-Boden-Kante bei 54–71 % statt 40 %",
     "Bildaufbau ganz vorn im Prompt, Tipp: vorhandenen Hintergrund als Bild-Prompt mit `--iw 0.5`"),
    ("20.11.", "Hintergründe", "zu dunkel, obere Hälfte fast schwarz", "„moderately bright evening light, the upper wall clearly visible“"),
    ("20.11.", "Hintergründe", "Fenster am oberen Rand, zur Hälfte von der Statusleiste verdeckt", "„the top 10 percent shows only dark ceiling beams and the window sits just below them“"),
    ("20.11.", "Hintergründe", "schwarzer Balken am unteren Rand", "`--no black bars, letterbox, border`"),
    ("20.11.", "alle", "Midjourney liefert immer vier Varianten", "eine auswählen (Website: anklicken; Discord: U1–U4) und nur diese schicken"),
    ("20.11.", "alle", "der Seitenverhältnis-Regler überstimmt `--ar` im Prompt", "bei jedem Bild steht die Regler-Einstellung (z. B. „Portrait 9:16“) – vor dem Erzeugen einstellen"),
    ("20.11.", "Hintergründe", "trotz Textvorgabe Wand-Boden-Kante bei 62 % (Epoche 8, 3. Versuch); Fenster und Helligkeit passten",
     "Bildaufbau-Vorlage `vorlagen/bildaufbau_hintergrund.png` als **Bild-Prompt** vor den Text setzen"),
    ("20.11.", "Hintergründe", "Midjourney setzt die Kante im Hochformat hartnäckig auf ~60 % (Epoche 8 und 9)",
     "**Format 3:4** statt 9:16: dort landet die Kante bei 55–62 % genau richtig im Spiel; das Spiel verlängert den Boden nach unten"),
    ("20.11.", "alle", "Zuordnung der Bilder in Midjourney schwierig", "jeder Prompt beginnt mit der ID (= Dateiname), z. B. `background_9 —`"),
    ("20.11.", "Essen", "Test-Esse (Stufe 1): Frontalansicht gut, aber geschlossener Backofen mit Kuppel, Glut tief in der Öffnung, nur ~35 % breit",
     "„open smith's hearth, not an oven“, Glut liegt offen auf einem hüfthohen Herdtisch, Abzugshaube mit freiem Spalt darüber; `--no dome, oven, bread oven, arch over the fire, enclosed firebox`"),
    ("20.11.", "Essen", "Blasebalg sah aus wie eine Kanone bzw. ein Fernrohr",
     "Blasebalg ausdrücklich beschreiben: tropfenförmig, zwei Holzbretter mit gefaltetem Leder, waagerecht auf einem Holzgestell; `--no cannon`"),
    ("20.11.", "Essen", "Bodenfleck trotz `--no ground patch`; Hintergrund cremeweiß statt reinweiß",
     "unkritisch – der Import schneidet beides weg"),
    ("20.11.", "Hintergründe", "Epoche 1 in 3:4 auf Anhieb brauchbar: Kante bei 64 %, Fenster direkt unter den Deckenbalken, Wand hell",
     "Format 3:4 und Bildaufbau-Text beibehalten; 50–65 % Kantenhöhe sind in Ordnung"),
]
GLOBAL_NEG = ["text", "letters", "numbers", "date", "signature", "watermark"]
ISOLATED_NEG = ["sticker border", "outline frame", "drop shadow", "ground shadow"]
BG_NEG = ["black bars", "letterbox", "border"]
# Essen: die vorhandenen Schrägansichten werden durch Frontalansichten ersetzt.
# Sobald die Frontalansichten da sind, hier True setzen.
FORGES_FRONTAL_DONE = os.path.exists(os.path.join(SRC, "forges_frontal"))

EPOCH_NAMES = {1: "Die Dorfschmiede (1700–1715)", 2: "Kutschen & Handelswege (1715–1735)", 3: "Hafen & Royal Navy (1735–1750)",
               4: "Stahl & Tuch (1750–1765)", 5: "Das Zeitalter des Dampfes (1765–1785)", 6: "Das Zeitalter der Eisenwerke (1785–1800)",
               7: "Krieg & Erfindergeist (1800–1820)", 8: "Eisenbahnfieber (1820–1839)", 9: "Der Dampfhammer (1839–1860)",
               10: "Das Stahlzeitalter (1860–1880)"}


def have(name):
    return os.path.exists(os.path.join(USER, name))


def status(name, optional=False):
    if have(name):
        return HAVE
    return OPT if optional else NEED


PROVENANCE = {}
_pv = os.path.join(SRC, "provenance.json")
if os.path.exists(_pv):
    import json
    PROVENANCE = json.load(open(_pv, encoding="utf-8")).get("bilder", {})


def _split_top(text):
    """Komma-Trennung, aber nicht innerhalb von Klammern."""
    parts, depth, cur = [], 0, ""
    for ch in text:
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        if ch == "," and depth == 0:
            parts.append(cur.strip())
            cur = ""
        else:
            cur += ch
    if cur.strip():
        parts.append(cur.strip())
    return parts


def midjourney(prompt):
    """Wandelt einen Prompt in Midjourney-Schreibweise: Verbote („no …“) als --no,
    Seitenverhältnis als --ar. Midjourney liest „no text“ im Text sonst als „text“."""
    neg, keep, ar = [], [], None

    def _paren(m):
        inner = _split_top(m.group(1))
        neg.extend(x[3:].strip() for x in inner if x.startswith("no "))
        pos = [x for x in inner if not x.startswith("no ")]
        return f"({', '.join(pos)})" if pos else ""
    prompt = re.sub(r"\(([^()]*\bno [^()]*)\)", _paren, prompt)
    prompt = re.sub(r"\s+([,.:])", r"\1", prompt)
    sentences = re.split(r"(?<=\.)\s+", prompt.strip())
    for sent in sentences:
        body = sent.rstrip(".")
        if re.match(r"^No\b", body):
            neg += [re.sub(r"^no\s+", "", x.strip(), flags=re.I) for x in body.split(",")]
            continue
        out = []
        for tok in _split_top(body):
            m = re.fullmatch(r"(?:square|wide|wide landscape|landscape|portrait|portrait orientation)?\s*(\d+):(\d+)", tok.strip())
            if m:
                ar = f"{m.group(1)}:{m.group(2)}"
                continue
            if re.match(r"^no\s", tok):
                neg.append(tok[3:].strip())
                continue
            # Klammern mit Verboten: „metal only (no wood, no leather)“
            pm = re.match(r"^(.*?)\s*\((.*)\)$", tok)
            if pm and re.search(r"\bno\s", pm.group(2)):
                inner = _split_top(pm.group(2))
                pos = [x for x in inner if not x.startswith("no ")]
                neg += [x[3:].strip() for x in inner if x.startswith("no ")]
                tok = pm.group(1) + (f" ({', '.join(pos)})" if pos else "")
            out.append(tok)
        if out:
            keep.append(", ".join(out))
    text = ". ".join(keep).strip()
    if ar is None:
        m = re.search(r"(\d+):(\d+)", prompt)
        ar = f"{m.group(1)}:{m.group(2)}" if m else "1:1"
    # Erkenntnisse, die für ganze Gruppen gelten (siehe LESSONS)
    neg += GLOBAL_NEG
    if "white background" in prompt:
        neg += ISOLATED_NEG
    if "game background" in prompt:
        neg += BG_NEG
    neg = [n for n in dict.fromkeys(x.strip(" .") for x in neg) if n]
    return f"{text} --ar {ar} --no {', '.join(neg)}" if neg else f"{text} --ar {ar}"


def _prov(fname):
    v = PROVENANCE.get(fname, {})
    return {"quelle": v} if isinstance(v, str) else dict(v)


def final_status(st, fname):
    """Vier Stufen: noch nicht vorhanden · Gemini · Midjourney (ändern) · gut."""
    if st in (NEED, ):
        return NOT
    if st == OPT:
        return NOT_OPT
    pv = _prov(fname)
    if pv.get("quelle") == "Midjourney":
        return GOOD if pv.get("bewertung") == "gut" else MJ_CHANGE
    return GEMINI


def block(title, prompt, st, fname, note=""):
    st = final_status(st, fname)
    pv_note = _prov(fname).get("hinweis", "")
    note = " ".join(x for x in (pv_note, note) if x and st != NOT and st != NOT_OPT) or ("" if st in (NOT, NOT_OPT) else note)
    # ID vorn: Zuordnung in Midjourney (die Galerie zeigt den Prompt); --no text verhindert Schrift im Bild
    mj = f"{fname} — " + midjourney(prompt)
    m = re.search(r"--ar (\d+):(\d+)", mj)
    w, h = (int(m.group(1)), int(m.group(2))) if m else (1, 1)
    slider = ("Portrait" if w < h else "Landscape" if w > h else "Square") + f" {w}:{h}"
    s = f"**{fname}** – {title} · {st}  \nRegler: **{slider}**"
    if note:
        s += f"  \n*{note}*"
    return s + "\n```\n" + mj + "\n```\n"


def parse_prompts(path):
    """**id** – Name … ``` prompt ``` → {id: (name, prompt)}"""
    text = open(path, encoding="utf-8").read()
    out = {}
    for m in re.finditer(r"\*\*([a-z0-9_]+)\*\* – ([^\n*]+?)(?: \*[^\n]*)?\n```\n(.*?)\n```", text, re.S):
        out[m.group(1)] = (m.group(2).strip(), m.group(3).strip())
    return out


# ------------------------------------------------------------------ Bausteine der Prompts

BG_HEAD = ("Vertical 3:4 game background, composition: seen from a high viewpoint looking down into the room, the back wall fills the upper 55 percent "
           "of the image and meets the floor at 55 percent of the image height, an empty floor fills the lower 45 percent, the top 15 percent of the image shows only dark ceiling beams and the window sits just below them. "
           "Hand-painted 2D game art with dark ink outlines and warm painterly textures, moderately bright evening light, the upper wall clearly visible. ")
BG_TAIL = ("The centre of the back wall and the floor in front of it are completely empty, because a forge and an anvil will be placed there later. "
           "Warm orange firelight falls on the centre of the back wall from below, as if from an off-screen hearth; the corners are dim. "
           "The lower third is plain dark floor with little detail, getting darker towards the bottom edge. "
           "No forge, no hearth, no fire, no anvil, no machine, no tools in the centre, no people, no animals, no text, no watermark.")
BACKGROUNDS = {
    1: "Interior of a small half-timbered English village smithy around 1700, seen from a high viewpoint. The back wall: timber frame with whitewashed wattle-and-daub panels, rough oak beams along the top. The floor comes towards the viewer: packed earth with straw and soot. A small window high on the back wall in the upper left corner shows green English countryside with a hedge and a distant church tower. On the far right edge a wooden rack with tongs, and a few horseshoes nailed to a beam. ",
    2: "Interior of a roadside smithy on an English coaching road around 1725, seen from a high viewpoint. The back wall: rough grey stone wall with heavy timber ceiling beams. The floor comes towards the viewer: worn stone flagstones. A small window high on the back wall in the upper left corner shows a dirt coaching road with a milestone and a distant stagecoach. On the far left edge a spare coach wheel leans against the wall; on the far right edge harness and iron hoops hang on wooden pegs. ",
    3: "Interior of a harbour smithy in an English naval dockyard around 1740, seen from a high viewpoint. The back wall: weathered red brick with tarred timber beams. The floor comes towards the viewer: tarred wooden planks. A small window high on the back wall in the upper left corner shows the masts and furled sails of a Royal Navy ship of the line in the harbour. On the far left edge a wooden barrel; on the far right edge coils of rope and a length of heavy chain hang from iron hooks. ",
    4: "Interior of a smith's and cutler's workshop in Sheffield around 1755, seen from a high viewpoint. The back wall: soot-darkened brick. The floor comes towards the viewer: worn stone slabs. A small window high on the back wall in the upper left corner shows Sheffield rooftops with many smoking brick chimneys under a grey sky. On the far left edge bolts of dyed woollen cloth (dark red, indigo, ochre) are stacked; on the far right edge a wooden shelf holds knife blades and files. ",
    5: "Interior of the forge of a water-powered hammer works in the Severn Gorge around 1780, seen from a high viewpoint. The back wall: high brick wall with heavy oak beams. The floor comes towards the viewer: wet stone floor with small puddles. A small window high on the back wall in the upper left corner shows the cast-iron arch of the Iron Bridge over the river Severn in a wooded gorge. The right third of the room is left open and empty, because a large machine will be placed there later. ",
    6: "Interior of the smithy of a large English ironworks around 1790, seen from a high viewpoint. The back wall: tall dark brick wall with two cast-iron columns. The floor comes towards the viewer: cast-iron floor plates with coke dust. A window high on the back wall in the upper left corner shows glowing blast furnaces and smoking chimneys of an ironworks at dusk. The right third of the room is left open and empty, because a steam engine will be placed there later. ",
    7: "Interior of a London engineering smithy in Lambeth around 1810, seen from a high viewpoint. The back wall: smoke-blackened yellow London stock brick with a heavy timber lintel. The floor comes towards the viewer: worn York stone flags with iron filings. A window high on the back wall in the upper left corner shows the river Thames with sailing barges and the dome of St Paul's in the haze. On the far right edge a wooden rack with iron templates and gauges; on the far left edge a stack of iron bars. ",
    8: "Interior of a locomotive smithy in Newcastle upon Tyne around 1830, seen from a high viewpoint. The back wall: dark red brick with tall bricked-up arched openings and iron tie rods with round anchor plates. The floor comes towards the viewer: packed cinders and iron plates. A window high on the back wall in the upper left corner shows an early steam locomotive with a tall chimney pulling coal wagons on a track. On the far right edge locomotive wheels and tyres lean against the wall; on the far left edge a stack of coupling chains. ",
    9: "Interior of the forge shop of a great engineering foundry around 1845, seen from a high viewpoint. The back wall: tall soot-stained brick wall with cast-iron columns and a row of high round-arched windows. The floor comes towards the viewer: heavy cast-iron floor plates and scale. A window high on the back wall in the upper left corner shows a canal with a narrowboat and the chimneys of a foundry. The right third of the room is left open and empty, because a large steam hammer will be placed there later. ",
    10: "Interior of a Sheffield steelworks forge around 1870, seen from a high viewpoint. The back wall: very tall dark brick wall with iron roof trusses and a travelling crane rail along the top. The floor comes towards the viewer: cast-iron floor plates with steel scale. A window high on the back wall in the upper left corner shows Bessemer converters blowing a shower of sparks into the night. The right third of the room is left open and empty, because a very large steam hammer will be placed there later. ",
}

## Offene Schmiede-Esse (Stufe 1–4): Midjourney macht aus „hearth with hood“ sonst einen Backofen
OPEN_HEARTH = ("an open smith's hearth, not an oven: a waist-high flat hearth table with the glowing coals lying openly on top of it, "
               "open at the front and at both sides, the hood hangs above the fire with a clear open gap between the coals and the hood "
               "(no dome, no oven, no bread oven, no arch over the fire, no enclosed firebox)")
BELLOWS = ("a large classic blacksmith's leather bellows shaped like a teardrop, made of two wooden boards joined by pleated leather, "
           "lying horizontally on a wooden stand, its iron nozzle leads into the side of the hearth (no cannon)")

FORGE_TAIL = ("shown in a straight front view (symmetrical, orthographic, no perspective distortion, no three-quarter view), seen from slightly above "
              "so that the glowing fire bed lying flat on top of the hearth is visible as a wide horizontal band across the middle of the hearth, the fire bed "
              "takes up about 60 % of the forge's width, the hood and chimney are centred above the fire bed and shown completely inside the image, "
              "the bottom edge of the hearth is straight and level (no floor, no ground patch), hand-painted 2D game art with dark ink outlines and "
              "warm painterly textures, no smoke, no sparks, no flames rising above the coals, no people, nothing in front of the hearth, no text, "
              "no watermark, isolated on pure flat white background, wide landscape 2:1")
FORGES = [
    ("forge_clay", "Lehm-Esse mit Handblasebalg (Stufe 1, Epoche 1)", "a small rustic early-18th-century village forge, " + OPEN_HEARTH + ", the hearth table built of clay and rough fieldstones, a simple clay-plastered hood with a short chimney, at the left side " + BELLOWS + ", orange glowing charcoal fire"),
    ("forge_brick", "Ziegel-Esse (Stufe 2, Epoche 2)", "a smith's forge of the 1720s, " + OPEN_HEARTH + ", the hearth table built of red brick bound with iron straps, a brick hood and a square brick chimney, at the left side " + BELLOWS + ", bright orange coal fire"),
    ("forge_double_bellows", "Esse mit Doppelblasebalg (Stufe 3, Epoche 3)", "a large smith's forge of the 1740s, " + OPEN_HEARTH + ", the hearth table built of brick and stone, a wide brick hood bound with iron bands, at the left side two large teardrop-shaped leather bellows of wooden boards and pleated leather stacked one above the other, worked by one long wooden lever, their nozzle leads into the side of the hearth (no cannon), hot yellow-orange coal fire"),
    ("forge_coke", "Koks-Esse mit Zylindergebläse (Stufe 4, Epoche 5)", "a long late-18th-century coke-fired smith's forge, " + OPEN_HEARTH + ", the hearth table built of cast-iron plates and firebrick, a riveted iron hood and a round iron chimney, at the left side an upright cast-iron blowing cylinder with an air pipe leading into the side of the hearth, brilliant yellow-white coke fire"),
    ("forge_welding_furnace", "Schweißofen (Stufe 5, Epoche 8)", "a long 1830s coal-fired welding furnace: a low hearth of firebrick and cast-iron plates bound by iron tie bars, a low brick arch over a long white-hot coal bed, a short square brick chimney"),
    ("forge_siemens", "Siemens-Gasofen (Stufe 6, Epoche 10)", "a massive 1870s Siemens regenerative gas furnace: a rectangular firebrick body clad with riveted iron plates and vertical iron buckstays, a wide open working front showing a blinding white-hot hearth, gas pipes with valves at both sides, a squat iron chimney stub"),
]

HAMMER_TAIL = ("the whole hammer is level and not tilted, hand-painted 2D game art with a thin dark ink outline, no engraving, no text, no numbers, "
               "no cast shadow, no watermark, the whole object fully inside the frame with a margin, isolated on pure flat white background, wide 2:1")
HAMMERS = [
    ("hammer_hand", "Handhammer (Stufe 1)", "a simple 18th-century blacksmith's hand hammer shown in a perfectly flat side view (orthographic profile, no perspective, no three-quarter view), the plain forged iron head stands upright on the left: flat striking face pointing straight down, short rounded back pointing straight up, the straight ash-wood handle goes through the middle of the head and points horizontally to the right, matte dark iron with hammer marks"),
    ("hammer_cross_peen", "Kreuzschlaghammer (Stufe 2)", "an 18th-century cast iron cross-peen blacksmith's hammer shown in a perfectly flat side view (orthographic profile, no perspective, no three-quarter view), the head stands upright on the left: square flat striking face pointing straight down, the back of the head tapers to a wedge-shaped cross peen pointing straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right, dark cast iron with slight rust"),
    ("hammer_steel_faced", "Hammer mit verstählter Bahn (Stufe 3)", "an 18th-century blacksmith's hammer with a steel-faced head shown in a perfectly flat side view (orthographic profile, no perspective, no three-quarter view), the head stands upright on the left: dark wrought iron body with a bright polished steel striking face forge-welded onto the bottom, a visible weld line between iron and steel, the striking face points straight down, a wedge-shaped peen points straight up, the straight hardwood handle goes through the middle of the head and points horizontally to the right"),
    ("hammer_crucible", "Gussstahl-Hammer / Tiegelstahl (Stufe 4)", "a high-quality late-18th-century crucible steel blacksmith's hammer shown in a perfectly flat side view (orthographic profile, no perspective, no three-quarter view), the polished bright steel head stands upright on the left: flat striking face pointing straight down, short flat back pointing straight up, a decorated brass ferrule where the head meets the handle, the straight dark walnut handle points horizontally to the right and ends in a small brass end cap"),
]

MACHINES = [
    ("machine_water_wheel", "water_wheel", "Wasserrad (Wasser-Schwanzhammer, Epoche 5)", False, "2D game asset, a single wooden undershot water wheel seen exactly from the side so that it is a perfect circle, eight straight spokes, wooden paddles all around the rim, iron bands and an iron axle hub exactly in the centre of the image, hand-painted 2D game art with dark ink outlines, no water, no frame, no stand, no shadow, no text, no watermark, isolated on pure flat white background, square 1:1"),
    ("machine_helve_beam", "helve_beam", "Hammerbalken mit Hammerkopf (Epoche 5–8)", False, "2D game asset, a single helve-hammer beam seen exactly from the side: a long heavy oak beam lying horizontally, bound with iron hoops, a round iron pivot boss with a hole at one third from the left end, a heavy forged iron hammer head fixed at the right end pointing straight down, hand-painted 2D game art with dark ink outlines, no frame, no posts, no anvil, no shadow, no text, no watermark, isolated on pure flat white background"),
    ("machine_helve_frame", "helve_frame", "Gestell mit Daumenwelle", False, "2D game asset, the wooden support frame of an 18th-century helve hammer seen exactly from the side: two heavy upright oak posts joined by cross beams, an iron bearing on top of the posts for a pivot, and a horizontal cam shaft with four iron cams at the bottom, hand-painted 2D game art with dark ink outlines, no hammer beam, no water wheel, no anvil, no shadow, no text, no watermark, isolated on pure flat white background"),
    ("machine_flywheel", "flywheel", "Schwungrad (Dampf-Schwanzhammer, Epoche 6–8)", False, "2D game asset, a single cast-iron flywheel of an 18th-century beam engine seen exactly from the front so that it is a perfect circle, six gently curved spokes, a heavy rim, the hub exactly in the centre of the image, hand-painted 2D game art with dark ink outlines, dark iron, no frame, no shaft stand, no shadow, no text, no watermark, isolated on pure flat white background, square 1:1"),
    ("machine_engine_body", "engine_body", "Dampfmaschine ohne Balancier und Schwungrad", False, "2D game asset, the body of a Boulton and Watt style beam engine around 1785 seen from the side: a tall vertical cast-iron steam cylinder with a piston rod sticking out of the top, a brick and timber engine bed, a tall cast-iron column on the right that would carry a beam, pipes and valve gear, hand-painted 2D game art with dark ink outlines, no rocking beam, no flywheel, no smoke, no shadow, no text, no watermark, isolated on pure flat white background"),
    ("machine_engine_beam", "engine_beam", "Balancier", False, "2D game asset, a single cast-iron rocking beam of an 18th-century beam engine seen from the side: long horizontal beam, thicker in the middle and tapering to both ends, an open lattice pattern, a round pivot hole exactly in the centre and connection eyes at both ends, hand-painted 2D game art with dark ink outlines, dark iron, no column, no engine, no shadow, no text, no watermark, isolated on pure flat white background"),
    ("machine_steam_hammer_frame", "steam_hammer_frame", "Dampfhammer: Gestell (Epoche 9)", False, "2D game asset, the frame of an 1840s Nasmyth steam hammer seen exactly from the front (orthographic, no perspective): two tall cast-iron standards shaped like an inverted V on each side, joined at the top by a heavy cross beam that carries a vertical steam cylinder with flanges and a valve chest, a control lever with a handle on the right standard, a tall empty open gap in the middle between the standards where the hammer moves, no hammer head, no piston rod, no anvil, hand-painted 2D game art with dark ink outlines, dark iron with rivets and bolts, no shadow, no text, no watermark, isolated on pure flat white background, portrait 3:4"),
    ("machine_steam_hammer_ram", "steam_hammer_ram", "Dampfhammer: Bär mit Kolbenstange", False, "2D game asset, the moving ram (tup) of an 1840s steam hammer seen exactly from the front (orthographic, no perspective): a long vertical polished piston rod at the top fixed into a heavy rectangular cast-iron hammer block with guide grooves on both sides and a flat steel die at the very bottom, upright and perfectly vertical, hand-painted 2D game art with dark ink outlines, no frame, no cylinder, no anvil, no shadow, no text, no watermark, isolated on pure flat white background, portrait 1:2"),
    ("machine_steam_hammer_anvil", "steam_hammer_anvil", "Dampfhammer: Schabotte (Ambossblock)", False, "2D game asset, the anvil block (schabotte) of an 1840s steam hammer seen exactly from the front (orthographic, no perspective): a massive squat cast-iron block, wider at the base, with a flat steel die on top held by a dovetail and wedges, set on heavy oak timbers, hand-painted 2D game art with dark ink outlines, dark iron, no hammer, no frame, no shadow, no text, no watermark, isolated on pure flat white background, landscape 3:2"),
    ("machine_steam_hammer_large_frame", "steam_hammer_large_frame", "Gestell des großen Dampfhammers (Epoche 10)", True, "2D game asset, the frame of a huge 1870s double-standard steam hammer seen exactly from the front (orthographic, no perspective): two massive riveted wrought-iron standards forming an arch, a large steam cylinder on top with pipes and valve gear, a platform with railing for the hammer driver, a tall empty open gap in the middle where the hammer moves, no hammer head, no piston rod, no anvil, hand-painted 2D game art with dark ink outlines, dark iron with rivets, no shadow, no text, no watermark, isolated on pure flat white background, portrait 3:4"),
]

SHOP_MACHINES = [
    ("machine_water_helve", "Wasser-Schwanzhammer (Ladenbild)", False, "2D game asset, an 18th-century water-powered helve hammer: a wooden undershot water wheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on a wooden stump on the right, side view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background, no text, no watermark"),
    ("machine_steam_helve", "Dampf-Schwanzhammer (Ladenbild)", True, "2D game asset, a 1790s steam-powered helve hammer: a small beam engine with a flywheel on the left driving a cam shaft, a long oak hammer beam with an iron head striking an anvil on the right, side view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background, no text, no watermark"),
    ("machine_nasmyth", "Nasmyth-Dampfhammer (Ladenbild)", True, "2D game asset, an 1840s Nasmyth steam hammer: two cast-iron standards, a steam cylinder on top, the hammer block hanging above a massive anvil block, a control lever, front view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background, no text, no watermark"),
    ("machine_great_steam_hammer", "Großer Dampfhammer (Ladenbild)", True, "2D game asset, a huge 1870s steam hammer with riveted wrought-iron arch standards, a large cylinder, a platform for the driver and a massive anvil block, front view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background, no text, no watermark"),
]

UI = [
    ("panel_parchment.png", "panel_parchment", "Pergament mit Messingecken (alle Fenster)", False, "2D game asset, UI panel frame, aged 18th-century parchment paper texture, worn burned edges, brass metal corner protectors, georgian style craftsmanship, clean flat view, high detail, isolated on black background, no shadows"),
    ("btn_normal.png", "buttons_leather_brass", "Leder-Messing-Knöpfe (alle Knöpfe)", False, "Set of 4 game UI buttons, 18th-century georgian style, polished brass with dark leather inlay, blank rectangular icons, flat design, isolated on white background"),
    ("hud_bar.png", "frame_wood_iron", "Holzrahmen mit Eisenplatte (Status- und Navigationsleiste)", False, "2D UI window frame, 18th-century forge workshop style, dark oak wood frame with brass rivets and iron fittings, game interface panel, front view, orthographic projection, clean edges, no 3d perspective, isolated on white background"),
    ("ember_normal.png", "button_ember", "Glut-Knopf HAMMERN", False, "2D game UI button, forged dark iron plate with glowing orange ember cracks, heavy brass border, a hammer-and-gear symbol in the middle, industrial 18th-century style, flat orthographic view, isolated on white background"),
    ("ledger_page.png", "ledger_page", "Auftragsbuch-Seite", False, "2D game asset, a single page of an 18th-century leather-bound ledger book seen from directly above, portrait orientation 3:4, aged cream parchment with faint brown ruled lines and soft stains, completely empty page (no writing, no numbers), the dark brown leather binding and a few page edges visible along the left side, small brass corner fittings on the right corners, a red ribbon bookmark hanging out at the bottom, hand-painted 2D game art with dark ink outlines, soft even lighting, no cast shadow, no text, no watermark, isolated on pure flat white background"),
    ("coin_pouch.png", "coin_pouch", "Münzbeutel (Geldanzeige)", False, "2D game asset icon, 18th-century leather coin pouch tied with string, filled with old British silver shillings and copper pence, isolated on white background"),
    ("coin_guinea.png", "coins", "Münzen George III: Guinee, Shilling, Halfpenny", False, "Set of 3 antique British coins of George III, one gold guinea, one silver shilling, one copper halfpenny, game item icons, top-down view, isolated on white background"),
    ("coin_victoria_sovereign.png", "coins_victoria", "Münzen Victoria: Sovereign, Shilling, Penny (für Epoche 9–10)", True, "Set of 3 antique British coins of Queen Victoria from the 1850s, one gold sovereign, one silver shilling, one bronze penny, game item icons, top-down view, crisp hand-painted 2D game art with thin dark outlines, isolated on pure flat white background, no text other than the coin legends, no watermark"),
    ("seal_george_iii.png", "wax_seals", "Wachssiegel George III und Admiralität", False, "Set of red wax seals with royal stamp emblems: one with the royal cipher of King George III, one with the anchor of the Admiralty, game badge icons, isolated on white background"),
    ("seal_victoria.png", "seal_victoria", "Wachssiegel Victoria (Meilensteine ab Epoche 9)", False, "Red wax seal with the royal cipher of Queen Victoria (VR) and a crown, no date, no year, game badge icon, hand-painted 2D game art, isolated on pure flat white background, no watermark"),
    ("pyrometer_needle.png", "pointer_sheet", "Pyrometer-Zeiger", False, "2D game asset, antique brass indicator needle, fine clockwork pointer, ornate georgian style, isolated on white background"),
    ("pyrometer_dial_empty.png", "pyrometer_dial", "Pyrometer-Zifferblatt ohne Zeiger", True, "2D game asset, an 18th-century brass pyrometer temperature gauge seen exactly from the front, a semicircular arc scale with engraved tick marks, antique clockwork style, dark iron base, no needle, no pointer, no numbers, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background, no text, no watermark"),
    ("star_full.png", "stars", "Sterne für die Bewertung (voll und leer)", True, "2D game UI icons, two five-pointed stars side by side: one polished gold star with a brass rim, one empty dark iron star outline, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background, no text, no watermark"),
    ("icon_hourglass.png", "hourglass", "Sanduhr (Eilaufträge)", True, "2D game UI icon, an 18th-century brass and wood hourglass with golden sand, front view, hand-painted 2D game art with dark ink outlines, isolated on pure flat white background, no text, no watermark"),
    ("trough.png", "trough", "Löschtrog (ab Epoche 4)", False, "2D game asset, a wooden quench trough for a blacksmith: a long rectangular oak tub bound with iron bands, filled with dark water whose surface is visible, standing on two short trestles, shown in a straight front view slightly from above, hand-painted 2D game art with dark ink outlines, no steam, no tools, no shadow, no text, no watermark, isolated on pure flat white background, landscape 2:1"),
    ("app_icon", "app_icon", "App-Icon", False, "Square 1:1 mobile game app icon, a heavy blacksmith's hammer striking a glowing orange-hot horseshoe on the face of a dark iron anvil, a burst of bright sparks, warm firelight against a deep dark brown background, bold simple shapes and strong contrast that stay readable at very small size, hand-painted 2D game art with dark ink outlines, subject centred and filling most of the square, no text, no letters, no border, no rounded corners, no watermark"),
    ("store_banner", "store_banner", "Store-Banner (Google Play 1024 × 500)", False, "Wide 2:1 banner illustration for a mobile game, interior of an 18th-century English smithy at night lit only by forge fire, on the right half a blacksmith's anvil with a glowing horseshoe and a raised hammer with sparks flying, a brick forge glowing in the background, the left half is calm, dark and empty for a title to be added later, hand-painted 2D game art with dark ink outlines and warm painterly textures, no people, no text, no letters, no watermark"),
]

PORTRAIT_TAIL = ("in an oval gilt wooden frame, hand-painted 2D game art with dark ink outlines and warm painterly textures, friendly but serious expression, "
                 "plain dark background inside the frame, no text, no name plate, no watermark, isolated on pure flat white background outside the frame, portrait 4:5")
PORTRAITS = {
    "squire": "a stout English country squire of about 1710, full-bottomed powdered wig, brown velvet coat, ruddy cheeks",
    "vicar": "an elderly Anglican village vicar of about 1710, black cassock, white preaching bands, small grey wig",
    "farmer_hollow": "a weathered English farmer of about 1710, grey hair tied back, linen smock, broad-brimmed straw hat",
    "miller_upton": "a cheerful village miller of about 1710, flour-dusted face and clothes, white linen cap",
    "landlady_red_lion": "a sturdy English innkeeper's wife of about 1710, white linen cap, shawl over a laced bodice, warm smile",
    "carpenter": "an English village carpenter of about 1710, leather apron, rolled sleeves, a pencil behind the ear",
    "postmaster_bath": "a fashionable postmaster of Bath around 1725, neat tie wig, blue coat with brass buttons",
    "coachbuilder_york": "a coachbuilder from York around 1725, sturdy man in a waistcoat with rolled sleeves, wood shavings on his shoulder",
    "turnpike_trust": "a gentleman trustee of a turnpike road around 1725, tricorn hat, grey coat, holding a ledger",
    "innkeeper_coaching": "the portly landlord of a coaching inn around 1725, red waistcoat, white apron, jolly expression",
    "carrier_bennett": "a carrier wagon driver around 1725, weather-beaten face, slouch hat, heavy woollen greatcoat, a whip over his shoulder",
    "navy_board": "a Navy Board commissioner around 1740, white powdered wig, dark blue coat with gold lace",
    "shipwright_portsmouth": "a master shipwright of Portsmouth around 1740, grey hair, plain brown coat, holding a pair of brass dividers",
    "merchant_bristol": "a wealthy Bristol merchant around 1740, powdered wig, rich green silk coat, lace cravat",
    "harbourmaster": "a harbourmaster around 1740, weathered sailor's face, tricorn hat, dark blue sea coat",
    "ropewalk_chatham": "the foreman of the Chatham ropewalk around 1740, strong man with tarred hands, knitted cap, a coil of rope over his shoulder",
    "clothier_leeds": "a prosperous Leeds clothier around 1755, brown wig, plain cloth coat, holding a bolt of dyed wool",
    "cutlers_sheffield": "the Master Cutler of Sheffield around 1755, dignified man with a chain of office over a dark coat",
    "spinning_master": "a spinning master around 1760, middle-aged man in shirtsleeves and waistcoat, wisps of cotton on his clothes",
    "toolmaker_holt": "a wiry toolmaker around 1760, spectacles on the nose, leather apron, a file in his hand",
    "dockyard_chatham": "the master attendant of Chatham Dockyard around 1760, naval officer, white wig, blue coat with gold buttons",
    "boulton_watt": "two engineering partners of Birmingham around 1780 side by side, one stout and cheerful in a fine coat, one thin and thoughtful Scotsman with grey hair",
    "mine_cornwall": "the captain of a Cornish tin mine around 1775, rugged face, miner's felt hat with a candle stuck on with clay",
    "colliery_wednesbury": "a colliery owner from Wednesbury around 1775, stout man, tall hat, coal dust on his collar",
    "canal_company": "a canal company engineer around 1775, surveyor's coat, holding rolled plans",
    "ironmaster_coalbrookdale": "a Quaker ironmaster of Coalbrookdale around 1779, plain dark Quaker coat, broad-brimmed hat, calm expression",
    "wedgwood_etruria": "a master potter of Staffordshire around 1770, dignified man in a brown coat, holding a pale blue jasperware vase",
    "mill_owner": "a self-made cotton-mill owner around 1790, high collar, brown tailcoat, watch chain",
    "plateway_company": "a tramroad company agent around 1790, top hat, grey tailcoat, holding a measuring rod",
    "engine_works": "an engine-works manager around 1790, sideburns, dark tailcoat, an oil stain on his cuff",
    "ironworks_partners": "a well-to-do ironworks partner around 1795, silver hair, black tailcoat, high white cravat",
    "east_india": "an East India Company director around 1795, powdered wig, rich red coat, gold-headed cane",
    "navy_portsmouth": "a naval officer overseeing the Portsmouth block mills around 1805, bicorne hat, blue coat with an epaulette",
    "maudslay": "a broad-shouldered master engineer of London around 1810, kind face, dark coat, holding a brass micrometer",
    "telford": "a Scottish civil engineer around 1815, grey hair, plain dark coat and cravat, rolled bridge drawings",
    "gas_light_company": "a gas company director around 1812, top hat, bottle-green tailcoat, a small gas lamp beside him",
    "horse_guards": "a Royal Horse Guards officer around 1815, blue tunic, shining steel helmet with a plume",
    "trevithick": "a tall Cornish engineer around 1805, curly hair, open-necked shirt and waistcoat, energetic expression",
    "stockton_darlington": "a Quaker railway promoter around 1825, plain dark coat, broad-brimmed hat",
    "stephenson_works": "a young locomotive engineer from Newcastle around 1830, dark curly hair, high collar, black tailcoat",
    "liverpool_manchester": "a railway company director around 1830, top hat, dark green tailcoat, side whiskers",
    "brunel": "a short energetic engineer around 1840, tall stovepipe hat, cigar, dark frock coat",
    "hetton_colliery": "a colliery viewer around 1825, sturdy northern man, flat cap, waistcoat, coal-dusted hands",
    "nasmyth": "a Scottish engineer around 1845, broad face, bushy dark beard, dark frock coat",
    "great_western_ss": "a steamship company director around 1843, mutton-chop whiskers, black frock coat, top hat in hand",
    "admiralty_steam": "a Royal Navy captain around 1845, dark blue frock coat with gold epaulettes",
    "britannia_bridge": "a bridge works resident engineer around 1848, top hat, plaid waistcoat, holding riveting plans",
    "crystal_palace": "a building contractor around 1851, prosperous, top hat, grey frock coat, a drawing of a glass-and-iron hall",
    "john_brown": "a Sheffield steel magnate around 1865, grey beard, black frock coat, gold watch chain",
    "armstrong_elswick": "an ordnance manufacturer around 1865, white side whiskers, dark frock coat, stern expression",
    "midland_railway": "a railway general manager around 1868, full beard, black frock coat, railway pocket watch",
    "white_star": "a shipping line owner around 1870, neat beard, dark double-breasted coat, a ship model behind him",
    "hornsby": "an agricultural engineer around 1865, ruddy face, tweed jacket, bowler hat",
    "coventry_machinists": "a young bicycle maker around 1870, moustache, waistcoat with rolled sleeves, flat cap",
}


def main():
    items_a = parse_prompts(os.path.join(SRC, "PROMPTS_Werkstuecke.md"))
    items_b = parse_prompts(os.path.join(ROOT, "docs", "Erweiterung_Epochen_7-10.md"))
    item_prompts = dict(items_a)
    item_prompts.update(items_b)
    count = {HAVE: 0, NEED: 0, REDO: 0, OPT: 0}
    sections = []

    def add(st):
        count[st] += 1
        return st

    # A Hintergründe
    a = []
    for e in range(1, 11):
        st = add(status(f"background_{e}.jpg"))
        a.append(block(EPOCH_NAMES[e], BG_HEAD + BACKGROUNDS[e] + BG_TAIL, st, f"background_{e}"))
    sections.append(("A · Werkstatt-Hintergründe (3:4 hochkant)",
                     "Esse, Amboss und Maschinen stellt das Spiel davor – der Raum bleibt leer. Wand-Boden-Kante bei etwa 55–60 % der Höhe, "
                     "unteres Drittel ruhig und dunkel (Bedienelemente).\n\n"
                     "**Format 3:4 (Regler: Portrait 3:4).** Im Hochformat 9:16 setzt Midjourney die Wand hartnäckig zu tief. In 3:4 "
                     "landet die Wand-Boden-Kante bei 55–62 % der Bildhöhe genau richtig; das Spiel verlängert den dunklen Boden nach unten "
                     "(dort liegt das Bedienfeld). Hilfreich: die Vorlage `assets/source/user_art/vorlagen/bildaufbau_hintergrund.png` als "
                     "**Bild-Prompt** vor den Text setzen (nicht als Stil-Referenz) und ein gelungenes Midjourney-Bild als Stil-Referenz. "
                     "Ich messe die Kante bei jedem Bild aus (50–65 % geht).", a))
    # B Essen
    b = []
    for fid, title, desc in FORGES:
        st = add(HAVE if have(fid + ".png") else NEED)
        b.append(block(title, f"2D game asset, {desc}, {FORGE_TAIL}", st, fid))
    sections.append(("B · Essen (Frontalansicht, alle sechs Stufen)",
                     "Frontal und symmetrisch, leicht von oben: Das Glutbett ist ein waagerechter Streifen über etwa 60 % der Breite, "
                     "damit die Werkstücke gleichmäßig nebeneinander liegen. Blasebalg bzw. Gebläse immer links. Die bisherigen "
                     "Schrägansichten (Stufe 1–4) werden ersetzt.", b))
    # C Amboss & Hämmer
    c = [block("Amboss auf Eichenklotz (alle Epochen)", "2D game sprite asset, heavy 18th-century cast iron anvil mounted on a thick oak wood stump, blacksmith equipment, side-view orthographic perspective, horn pointing to the right, crisp clean edges, isolated on white background, game art", add(status("anvil.png")), "anvil")]
    for hid, title, desc in HAMMERS:
        c.append(block(title, f"2D game asset, {desc}, {HAMMER_TAIL}", add(status(hid + ".png")), hid))
    sections.append(("C · Amboss und Hämmer",
                     "Hämmer in reiner Seitenansicht: Kopf links senkrecht, Bahn unten, Stiel waagerecht nach rechts.", c))
    # D Maschinen
    d = []
    for out_name, fname, title, optional, prompt in MACHINES:
        d.append(block(title, prompt, add(status(out_name + ".png", optional)), fname))
    d.append("**Ladenbilder der Maschinen** (ganze Maschine als ein Bild, nur für den Laden)\n")
    for fname, title, optional, prompt in SHOP_MACHINES:
        d.append(block(title, prompt, add(status(fname + ".png", optional)), fname))
    sections.append(("D · Maschinen (Einzelteile für die Animation)",
                     "Drehteile genau von vorn und kreisrund, Mittelpunkt = Bildmitte; bewegliche Teile einzeln.", d))
    # E Werkstücke
    e_parts = []
    st = add(status("item_blank.png"))
    name, prompt = item_prompts.get("blank", ("Rohling", ""))
    e_parts.append(block("Rohling (alle Epochen)", prompt, st, "blank"))
    for ep in range(1, 11):
        e_parts.append(f"### Epoche {ep} – {EPOCH_NAMES[ep]}\n")
        for it in ITEMS:
            if it[1] != ep:
                continue
            iid = it[0]
            name, prompt = item_prompts.get(iid, (it[6], "(Prompt fehlt)"))
            e_parts.append(block(it[6], prompt, add(status(f"item_{iid}.png")), iid))
    sections.append(("E · Werkstücke (Rohling + 80)",
                     "Kalt, nur Metall (kein Holz), von oben, weißer Hintergrund ohne Schatten, quadratisch. Die Glut färbt das Spiel ein.", e_parts))
    # F Porträts
    f_parts = []
    for cust in CUSTOMERS:
        cid, lo, hi = cust[0], cust[1], cust[2]
        desc = PORTRAITS.get(cid, "a customer")
        st = add(status(f"portrait_{cid}.png", True))
        rng = f"Epoche {lo}" if lo == hi else f"Epoche {lo}–{hi}"
        f_parts.append(block(f"{cust[5]} ({rng})", f"2D game asset, a head-and-shoulders portrait of {desc}, {PORTRAIT_TAIL}", st, f"portrait_{cid}"))
    sections.append(("F · Kundenporträts (54)",
                     "Die aktuellen Porträts sind noch meine gerenderten (im Spiel vorhanden, aber im alten Stil). "
                     "Für einen einheitlichen Stil empfehlenswert, aber nicht zwingend.", f_parts))
    # G Oberfläche
    g = []
    for out_name, fname, title, optional, prompt in UI:
        if out_name == "app_icon":
            st = HAVE if os.path.exists(os.path.join(ROOT, "store", "app_icon_1024.png")) else NEED
        elif out_name == "store_banner":
            st = HAVE if os.path.exists(os.path.join(ROOT, "store", "feature_graphic_1024x500.png")) else NEED
        elif out_name == "trough.png":
            st = HAVE if have("trough.png") else NEED
        else:
            st = status(out_name, optional)
        g.append(block(title, prompt, add(st), fname))
    sections.append(("G · Oberfläche, Symbole, Store",
                     "Spieltitel und Schriften kommen aus Schriftarten (kein Bild nötig); Glühskala, Fortschritt und Partikel zeichnet das Spiel selbst.", g))

    def counts(txt):
        n_opt = txt.count(NOT_OPT)
        return {GOOD: txt.count(GOOD), MJ_CHANGE: txt.count(MJ_CHANGE), GEMINI: txt.count(GEMINI),
                NOT: txt.count(NOT) - n_opt, NOT_OPT: n_opt}
    alltext = "\n".join("\n".join(p) for _, _, p in sections)
    total = counts(alltext)
    lines = ["# Prompt-Heft: alle Bilder des Spiels", "",
             "Vollständige Liste aller Grafiken mit Prompt und Status. Erzeugt mit `python tools/content/gen_prompt_book.py` – "
             "nach jeder Lieferung und jeder neuen Erkenntnis neu erzeugt, damit Status und Prompts aktuell sind.", "",
             "**Status je Bild:**", "",
             f"- {NOT} – Prompt verwenden und liefern",
             f"- {GEMINI} – ist im Spiel, soll später ersetzt werden",
             f"- {MJ_CHANGE} – der Hinweis darunter sagt, was",
             f"- {GOOD} – fertig", "",
             "**Bildquelle:** Bis zum 20.11.2026 Gemini, seitdem **Midjourney**. Prompts in Midjourney-Schreibweise: "
             "Verbote hinter `--no`, Seitenverhältnis hinter `--ar`. Herkunft und Bewertung je Bild: `provenance.json`.", "",
             "## Übersicht", "",
             "| Status | Anzahl |", "|---|---|"]
    for k in (GOOD, MJ_CHANGE, GEMINI, NOT, NOT_OPT):
        lines.append(f"| {k} | {total[k]} |")
    lines += ["", "| Bereich | ✅ gut | 🟠 ändern | 🟡 Gemini | ⬜ fehlt | ⬜ optional |", "|---|---|---|---|---|---|"]
    for title, _, parts in sections:
        c = counts("\n".join(parts))
        lines.append(f"| {title.split(' (')[0]} | {c[GOOD]} | {c[MJ_CHANGE]} | {c[GEMINI]} | {c[NOT]} | {c[NOT_OPT]} |")
    lines += ["", "## Erkenntnisse aus den bisherigen Bildern", "",
              "Jede Erkenntnis ist in **alle** betroffenen Prompts eingebaut (gemeinsame Bausteine im Generator).", "",
              "| Datum | gilt für | Beobachtung | Umsetzung |", "|---|---|---|---|"]
    for d, scope, obs, fix in LESSONS:
        lines.append(f"| {d} | {scope} | {obs} | {fix} |")
    lines += ["", "## Midjourney-Einstellungen (Version 8.2)", "",
              "**Seitenverhältnis immer am Regler einstellen** – er überstimmt `--ar` im Prompt; die nötige Einstellung steht bei jedem Bild. "
              "Version immer gleich lassen (8.2). "
              "Weirdness immer 0. Video-Einstellungen spielen keine Rolle.", "",
              "| Gruppe | Model | Raw | Stylization | Variety | Speed |", "|---|---|---|---|---|---|",
              "| Werkstücke (E), Hämmer (C), Maschinenteile (D), Symbole (G) | Standard | **Raw** | niedrig (ca. 10 %) | 0 | Relax, wenn möglich |",
              "| Essen (B), Amboss, Schabotte | Standard | **Raw** | niedrig (ca. 10 %) | 0 | Fast |",
              "| Hintergründe (A) | **HD** (für das ausgewählte Bild) | Standard | mittel (ca. 30–40 %) | 0 | Fast |",
              "| Porträts (F) | Standard | Standard | mittel (ca. 30 %) | 0 | Relax, wenn möglich |",
              "| App-Icon, Store-Banner | **HD** | Standard | mittel | 0 | Fast |", "",
              "Raw hält sich genauer an Vorgaben wie „genau von der Seite“ oder „Kopf links“. HD lohnt sich nur, wo das Bild "
              "groß zu sehen ist (Hintergründe 1080 × 1920, Icon, Banner); Gegenstände verkleinert das Spiel ohnehin auf 256–1000 px. "
              "Für eine Serie (z. B. alle Werkstücke) das beste Bild als Stil-Referenz `--sref <URL>` an alle weiteren Prompts der Gruppe hängen.", ""]
    lines += ["", "## Regeln für alle Bilder", "",
              "- Freigestellt auf **reinem Weiß**, ohne Schatten, ohne Text, ohne Jahreszahlen, ohne Wasserzeichen.",
              "- Objekt vollständig im Bild mit etwas Rand.",
              "- Dateiname = die fett gedruckte ID (z. B. `door_hinge.webp`); Format egal (webp, png, jpg).",
              "- Einheitlicher Stil: handgemalt, dünne dunkle Tuschekontur, warme Malstruktur.",
              "- Midjourney: Prompt komplett kopieren (inkl. `--ar` und `--no`); Einstellungen je Gruppe siehe oben.",
              "- Für einheitlichen Stil: ein gelungenes Bild als Stil-Referenz verwenden (`--sref <Bild-URL>`).",
              "",
              "## Reihenfolge (was am meisten bringt)", "",
              "1. **Essen in Frontalansicht** (B) – sieht man ständig.",
              "2. **Hintergründe 7–10** (A) und **Dampfhammer-Teile** (D).",
              "3. **Werkstücke** epochenweise (E), dann **Löschtrog** (G).",
              "4. Optional: Porträts (F), Ladenbilder, Victoria-Münzen, Sterne, Sanduhr, Pyrometer-Zifferblatt.",
              "5. Dann: alle 🟠 Midjourney-Bilder mit Hinweis nachbessern, später alle 🟡 Gemini-Bilder ersetzen (gleiche Dateinamen).",
              ""]
    for title, intro, parts in sections:
        lines += [f"## {title}", "", intro, ""] + parts
    open(OUT, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    print(OUT, total)


if __name__ == "__main__":
    main()
