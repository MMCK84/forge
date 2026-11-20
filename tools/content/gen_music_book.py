# -*- coding: utf-8 -*-
"""Erzeugt das Musik-Prompt-Heft (Suno) mit Status je Stück:

    python tools/content/gen_music_book.py

Ausgabe: assets/source/user_audio/PROMPTS_Musik.md. Status aus assets/source/user_audio/provenance.json
und den gelieferten Originalen in assets/source/user_audio/music/.
Erkenntnisse aus gelieferten Stücken gehören in LESSONS und in die gemeinsamen Bausteine
(COMMON_STYLE, COMMON_EXCLUDE, STRUCTURE), damit ALLE Prompts aktuell sind.
"""
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
SRC = os.path.join(ROOT, "assets", "source", "user_audio")
OUT = os.path.join(SRC, "PROMPTS_Musik.md")

NOT = "⬜ noch nicht vorhanden"
NOT_OPT = "⬜ noch nicht vorhanden (optional)"
SYNTH = "🟡 eigene Synthese im Spiel – durch Suno ersetzen"
SUNO_CHANGE = "🟠 von Suno vorhanden – sollte noch verändert werden"
GOOD = "✅ gut (Suno)"

# Erkenntnisse aus gelieferten Stücken: (Datum, gilt für, Beobachtung, Umsetzung in den Prompts)
LESSONS = [
]

# ------------------------------------------------------------------ gemeinsame Bausteine
# Musik läuft stundenlang in Schleife unter Hammerschlägen, Feuer und Maschinen:
# ruhig, gleichmäßig, ohne Höhepunkte, Tonart und Tempo durchgehend gleich (für die Schleife).
COMMON_STYLE = ("instrumental background music for a cosy crafting game, acoustic period instruments, warm intimate recording, "
                "soft and steady dynamics, unobtrusive, calm and even throughout, constant tempo and key from start to end")
COMMON_EXCLUDE = ["vocals", "choir", "singing", "humming", "spoken word", "lyrics", "synthesizer", "electronic", "drum kit",
                  "electric guitar", "bass guitar", "modern pop", "cinematic trailer", "epic orchestra", "heavy reverb",
                  "climax", "crescendo", "fade out", "tempo change", "key change"]
# Strukturangaben (Lyrics-Feld): langes, gleichmäßiges Stück ohne großes Ende – die Schleife schneide ich
STRUCTURE = "[Instrumental]\n[Short Intro]\n[Main Theme]\n[Variation]\n[Main Theme]\n[Interlude]\n[Variation]\n[Main Theme]"
# Instrumente, die es vor ca. 1770 in England so nicht gab (Klavier) bzw. vor 1820/1830 nicht
EARLY_EXCLUDE = ["piano", "accordion", "concertina", "brass band", "saxophone"]
MID_EXCLUDE = ["accordion", "concertina", "brass band", "saxophone"]
LATE_EXCLUDE = ["saxophone", "accordion"]

# id, Titel, Länge, Tonart/Takt/Tempo, Besetzung und Stimmung (Englisch für Suno), Zusatz-Ausschlüsse, optional
TRACKS = [
    ("menu", "Menü-Thema", "2:30–3:30", "D-Dur, 3/4, 72 BPM",
     "English Georgian folk air, gentle and nostalgic, solo violin melody over lute and harpsichord, soft cello, "
     "evokes a quiet village smithy at dusk, D major, 3/4 waltz-like lilt, 72 BPM", EARLY_EXCLUDE, False),
    ("epoch_1", "Die Dorfschmiede (1700–1715)", "2:30–3:30", "G-Dur, 6/8, 104 BPM",
     "early 18th-century English country dance in the style of Playford's dancing tunes, rustic and cheerful, "
     "fiddle and recorder melody, lute or cittern chords, a soft tabor keeping time, village green, G major, 6/8 jig, 104 BPM",
     EARLY_EXCLUDE, False),
    ("epoch_2", "Kutschen & Handelswege (1715–1735)", "2:30–3:30", "D-Dur, 4/4, 112 BPM",
     "English baroque coaching-inn music around 1725, lively but light, fiddle and baroque oboe melody, theorbo and cello continuo, "
     "a gentle trotting rhythm like horses on the road, D major, 4/4, 112 BPM", EARLY_EXCLUDE, False),
    ("epoch_3", "Hafen & Royal Navy (1735–1750)", "2:30–3:30", "A-dorisch, 6/8, 96 BPM",
     "18th-century English naval hornpipe, harbour and tall ships, fiddle and wooden fife melody, cello drone, "
     "very soft rope-tensioned side drum, salty and determined, A dorian, 6/8, 96 BPM", EARLY_EXCLUDE, False),
    ("epoch_4", "Stahl & Tuch (1750–1765)", "2:30–3:30", "C-Dur, 3/4, 120 BPM",
     "English galant chamber music around 1755, elegant minuet, flute and violin melody over harpsichord and cello, "
     "a busy Sheffield workshop, neat and industrious, C major, 3/4, 120 BPM", EARLY_EXCLUDE, False),
    ("epoch_5", "Das Zeitalter des Dampfes (1765–1785)", "3:00–4:00", "e-Moll, 2/4, 88 BPM",
     "English Georgian chamber music around 1775, a steady turning harpsichord ostinato like a water wheel, "
     "strings and flute above it, misty river gorge, earnest and hopeful, E minor, 2/4, 88 BPM", MID_EXCLUDE, False),
    ("epoch_6", "Das Zeitalter der Eisenwerke (1785–1800)", "3:00–4:00", "D-Dur, 4/4, 100 BPM",
     "classical-era English chamber music around 1790, string quartet with fortepiano, confident and industrious, "
     "a steady pulse like a beam engine, glowing ironworks at dusk, D major, 4/4, 100 BPM", MID_EXCLUDE, False),
    ("epoch_7", "Krieg & Erfindergeist (1800–1820)", "2:30–3:30", "G-Dur, 2/4, 116 BPM",
     "English Regency era quick march around 1810, restrained and not loud, fife and violin melody, cello, "
     "a soft military snare far in the background, inventive and resolute, G major, 2/4, 116 BPM", MID_EXCLUDE, False),
    ("epoch_8", "Eisenbahnfieber (1820–1839)", "3:00–4:00", "E-Dur, 2/4, 132 BPM",
     "Northumbrian folk tune around 1830, lively galop, fiddle and Northumbrian smallpipes melody, English concertina, "
     "a chugging rhythm like an early steam train, optimistic, E major, 2/4, 132 BPM", LATE_EXCLUDE, False),
    ("epoch_9", "Der Dampfhammer (1839–1860)", "3:00–4:00", "a-Moll, 4/4, 92 BPM",
     "early Victorian chamber music around 1845, sombre but determined, cello and violin melody over a heavy steady "
     "piano pulse like a distant steam hammer, low soft cornet, foundry at night, A minor, 4/4, 92 BPM", LATE_EXCLUDE, False),
    ("epoch_10", "Das Stahlzeitalter (1860–1880)", "3:00–4:00", "C-Dur, 4/4, 96 BPM",
     "Victorian northern English brass band hymn around 1870, broad, proud and warm but restrained, cornets, tenor horns "
     "and euphonium with soft strings, Sheffield steelworks, C major, 4/4, 96 BPM", LATE_EXCLUDE, False),
    # optional: kurze Stücke, die das Spiel noch nicht abspielt (würde ich einbauen)
    ("jingle_epoch", "Fanfare: neue Epoche freigeschaltet", "0:05–0:10", "D-Dur",
     "short festive English baroque fanfare, natural trumpet and timpani with strings, bright and proud, D major, "
     "a complete short ending", ["vocals", "choir", "synthesizer", "electronic", "drum kit", "electric guitar"], True),
    ("jingle_milestone", "Meilenstein erreicht", "0:03–0:06", "G-Dur",
     "very short cheerful English folk flourish, fiddle and harpsichord, ends on a bright major chord, G major",
     ["vocals", "choir", "synthesizer", "electronic", "drum kit", "electric guitar"], True),
]


def provenance():
    p = os.path.join(SRC, "provenance.json")
    return json.load(open(p, encoding="utf-8")).get("stuecke", {}) if os.path.exists(p) else {}


def delivered(tid):
    d = os.path.join(SRC, "music")
    return os.path.isdir(d) and any(os.path.splitext(f)[0] == tid for f in os.listdir(d))


def status(tid, optional, pv):
    v = pv.get(tid, {})
    if delivered(tid) or v.get("quelle") == "Suno":
        return GOOD if v.get("bewertung") == "gut" else SUNO_CHANGE
    if os.path.exists(os.path.join(ROOT, "assets", "audio", "music", tid + ".ogg")):
        return SYNTH
    return NOT_OPT if optional else NOT


def block(tid, title, length, key, style, extra_ex, optional, pv):
    st = status(tid, optional, pv)
    exclude = ", ".join(dict.fromkeys((COMMON_EXCLUDE if not tid.startswith("jingle") else []) + list(extra_ex)))
    full_style = style if tid.startswith("jingle") else f"{style}, {COMMON_STYLE}"
    s = [f"### {tid} – {title}", "", f"{st}  ", f"Länge: **{length}** · {key}"]
    note = pv.get(tid, {}).get("hinweis", "")
    if note:
        s.append(f"  \n*{note}*")
    s += ["", "Titel:", "```", tid, "```", "Styles:", "```", full_style, "```", "Exclude Styles:", "```", exclude, "```"]
    if not tid.startswith("jingle"):
        s += ["Lyrics (nur Strukturangaben):", "```", STRUCTURE, "```"]
    return "\n".join(s) + "\n", st


def main():
    pv = provenance()
    blocks, stats = [], []
    for t in TRACKS:
        b, st = block(*t, pv)
        blocks.append((t[0], b))
        stats.append(st)
    lines = ["# Musik-Prompt-Heft (Suno)", "",
             "Alle Musikstücke des Spiels mit Prompt und Status. Erzeugt mit `python tools/content/gen_music_book.py` – "
             "nach jeder Lieferung und jeder neuen Erkenntnis neu erzeugt.", "",
             "**Status je Stück:**", "",
             f"- {NOT} – Prompt verwenden und liefern",
             f"- {SYNTH} – das Spiel spielt bisher selbst erzeugte Musik (Skript), soll ersetzt werden",
             f"- {SUNO_CHANGE} – der Hinweis darunter sagt, was",
             f"- {GOOD} – fertig", "",
             "## Übersicht", "", "| Status | Anzahl |", "|---|---|"]
    for k in (GOOD, SUNO_CHANGE, SYNTH, NOT, NOT_OPT):
        lines.append(f"| {k} | {stats.count(k)} |")
    lines += ["", "## Erkenntnisse aus den bisherigen Stücken", "",
              "Jede Erkenntnis ist in **alle** betroffenen Prompts eingebaut (gemeinsame Bausteine im Generator).", ""]
    if LESSONS:
        lines += ["| Datum | gilt für | Beobachtung | Umsetzung |", "|---|---|---|---|"]
        lines += [f"| {d} | {sc} | {o} | {f} |" for d, sc, o, f in LESSONS]
    else:
        lines.append("Noch keine – kommen mit den ersten Lieferungen.")
    lines += ["", "## So geht's in Suno", "",
              "1. **Create → Custom** (benutzerdefiniert) wählen, Schalter **Instrumental** einschalten.",
              "2. **Styles** und **Exclude Styles** aus dem Heft kopieren, **Titel** = die ID (z. B. `epoch_3`).",
              "3. Falls das **Lyrics**-Feld bei „Instrumental“ sichtbar bleibt: die Strukturangaben eintragen, sonst weglassen.",
              "4. Falls angeboten (erweiterte Optionen): **Weirdness niedrig** (ca. 20–30 %), **Style Influence hoch** (ca. 70–80 %).",
              "5. Immer dieselbe (neueste) Suno-Version verwenden, damit alle Stücke gleich klingen.",
              "6. Suno erzeugt zwei Fassungen: anhören, die ruhigere und gleichmäßigere nehmen.",
              "7. Herunterladen, **am liebsten als WAV** (sonst MP3), Dateiname = ID (`epoch_3.wav`), und mir schicken.", "",
              "Die Feldnamen können je nach Suno-Version leicht abweichen.", "",
              "## Worauf es ankommt", "",
              "- **Schleife:** Die Musik läuft pro Epoche etwa 13 bis 160 Minuten in Schleife. Deshalb ruhig, gleichmäßig, ohne Höhepunkt, "
              "Tonart und Tempo durchgehend gleich. Ende und Anfang schneide ich zu einer nahtlosen Schleife zusammen – ein großes "
              "Schlussakkord-Ende ist also kein Problem, aber Ausblenden (Fade-out) stört.",
              "- **Platz für die Geräusche:** Hammerschläge, Feuer, Blasebalg und Maschinen sind laut und hell. Die Musik bleibt "
              "darunter: weich, ohne harte Schlagzeug-Akzente.",
              "- **Zeitgerecht:** Instrumente passend zur Epoche (Klavier erst ab ca. 1770, Concertina ab 1829, Blaskapellen ab ca. 1840). "
              "Unpassendes steht unter Exclude Styles.",
              "- **Keine Namen** von Komponisten oder Bands in den Prompts (Suno lehnt das ab bzw. es ist rechtlich heikel).",
              "- **Rechte:** Nur im bezahlten Abo erzeugte Stücke dürfen kommerziell genutzt werden – Nutzungsbedingungen vor dem Abschluss prüfen.", "",
              "## Lieferung und Einbau (mache ich)", "",
              "Original nach `assets/source/user_audio/music/<id>.wav` · Schleifenpunkt suchen und überblenden · Lautstärke angleichen · "
              "als OGG nach `assets/audio/music/` · Herkunft und Bewertung in `assets/source/user_audio/provenance.json` · Heft neu erzeugen.", "",
              "## Reihenfolge (was am meisten bringt)", "",
              "1. **menu** und **epoch_1** – hört jeder Spieler zuerst.",
              "2. **epoch_5** und **epoch_6** – die längsten Epochen (je über zwei Stunden).",
              "3. Die übrigen Epochen der Reihe nach.",
              "4. Optional: Fanfare und Meilenstein-Jingle.", ""]
    lines += ["## A · Musik je Epoche und Menü", "",
              "Tempo und Grundcharakter entsprechen der bisherigen Musik im Spiel, damit Balancing und Stimmung gleich bleiben.", ""]
    lines += [b for tid, b in blocks if not tid.startswith("jingle")]
    lines += ["## B · Kurze Stücke (optional)", "",
              "Spielt das Spiel noch nicht ab – ich baue sie ein, sobald sie da sind. Hier ist ein klares Ende erwünscht.", ""]
    lines += [b for tid, b in blocks if tid.startswith("jingle")]
    os.makedirs(SRC, exist_ok=True)
    open(OUT, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    print(OUT, {k: stats.count(k) for k in dict.fromkeys(stats)})


if __name__ == "__main__":
    main()
