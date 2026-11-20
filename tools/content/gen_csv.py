import csv, sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from content import ITEMS, CUSTOMERS, MILESTONES, EXTRA_STRINGS
from ui_strings import S
rows = dict(S)
rows.update(EXTRA_STRINGS)
for it in ITEMS:
    iid = it[0].upper()
    rows[f"ITEM_{iid}"] = (it[6], it[9])
    rows[f"ITEM_{iid}_PL"] = (it[7], it[10])
    rows[f"ITEM_{iid}_G"] = (it[8], "-")
for c in CUSTOMERS:
    rows[f"CUST_{c[0].upper()}"] = (c[4], c[5])
for m in MILESTONES:
    mid = m[0].upper()
    rows[f"MS_{mid}_TITLE"] = (m[7], m[9])
    rows[f"MS_{mid}_TEXT"] = (m[8], m[10])
with open(sys.argv[1], "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f, lineterminator="\n")
    w.writerow(["keys", "de", "en"])
    for k in sorted(rows):
        de, en = rows[k]
        w.writerow([k, de.replace("\n", "\\n"), en.replace("\n", "\\n")])
print(len(rows), "keys")
