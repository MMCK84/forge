# -*- coding: utf-8 -*-
"""Schreibt die Godot-Ressourcen der Epochen 7–10 aus epochs_7_10.py und trägt sie in
scripts/catalog.gd ein. Berührt keine Daten der Epochen 1–6.

    python tools/content/gen_epochs_7_10.py
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, HERE)
import epochs_7_10 as E  # noqa: E402


def fmt(v):
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, str):
        return '"' + v.replace("\\", "\\\\").replace('"', '\\"') + '"'
    if isinstance(v, float):
        return repr(v)
    if isinstance(v, int):
        return str(v)
    if isinstance(v, tuple) and v and v[0] == "color":
        r, g, b = v[1]
        return f"Color({r:.3f}, {g:.3f}, {b:.3f}, 1)"
    if isinstance(v, list):
        return "[" + ", ".join(fmt(x) for x in v) + "]"
    if isinstance(v, dict):
        return "{\n" + ",\n".join(f"{fmt(k)}: {fmt(x)}" for k, x in v.items()) + "\n}"
    raise ValueError(v)


def tres(cls, script, props):
    lines = [f'[gd_resource type="Resource" script_class="{cls}" load_steps=2 format=3]', "",
             f'[ext_resource type="Script" path="res://resources/{script}" id="1_script"]', "", "[resource]",
             'script = ExtResource("1_script")']
    lines += [f"{k} = {fmt(v)}" for k, v in props]
    return "\n".join(lines) + "\n"


def write(rel, text):
    p = os.path.join(ROOT, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "w", encoding="utf-8") as f:
        f.write(text)
    return "res://" + rel


def hex_color(h):
    return ("color", tuple(int(h[i:i + 2], 16) / 255.0 for i in (0, 2, 4)))


def main():
    paths = {"ITEMS": [], "CUSTOMERS": [], "MILESTONES": [], "FORGES": [], "MACHINES": [], "STAFF": []}
    for it in E.ITEMS:
        iid, epoch, factor, cat, shape, allow_qty = it[:6]
        material, steps = E.STEPS[iid]
        assert abs(sum(s for _, s in steps) - 1.0) < 1e-6, iid
        props = [("id", iid), ("epoch", epoch), ("factor", factor), ("category", cat), ("shape", shape),
                 ("allow_quantity", allow_qty), ("material", material),
                 ("steps", [{"id": sid, "share": share} for sid, share in steps])]
        paths["ITEMS"].append(write(f"data/items/{iid}.tres", tres("ItemData", "item_data.gd", props)))
    for c in E.CUSTOMERS:
        cid, lo, hi, col = c[:4]
        props = [("id", cid), ("min_epoch", lo), ("max_epoch", hi), ("portrait_color", hex_color(col))]
        paths["CUSTOMERS"].append(write(f"data/customers/{cid}.tres", tres("CustomerData", "customer_data.gd", props)))
    counter = {}
    for m in E.MILESTONES:
        mid, epoch, item, cust, qty, prec, fpf = m[:7]
        counter[epoch] = counter.get(epoch, 0) + 1
        props = [("id", mid), ("epoch", epoch), ("index", counter[epoch]), ("item_id", item), ("customer_id", cust),
                 ("quantity", qty), ("precision", prec), ("fp_factor", fpf)]
        paths["MILESTONES"].append(write(f"data/milestones/epoch_{epoch}/{mid}.tres", tres("MilestoneData", "milestone_data.gd", props)))
    for folder, cls, script, props in E.EQUIPMENT:
        pid = dict(props)["id"]
        key = {"staff": "STAFF", "forges": "FORGES", "machines": "MACHINES"}[folder]
        paths[key].append(write(f"data/{folder}/{pid}.tres", tres(cls, script, props)))
    _update_catalog(paths)
    print({k: len(v) for k, v in paths.items()})


def _update_catalog(paths):
    p = os.path.join(ROOT, "scripts", "catalog.gd")
    s = open(p, encoding="utf-8").read()
    for const, files in paths.items():
        m = re.search(r"const %s := \[\n(.*?)\n\]" % const, s, re.S)
        if m is None:
            raise SystemExit("Katalog-Liste nicht gefunden: " + const)
        body = m.group(1)
        lines = body.split("\n")
        for f in files:
            line = f'\tpreload("{f}"),'
            if line not in lines:
                lines.append(line)
        s = s[:m.start(1)] + "\n".join(lines) + s[m.end(1):]
    with open(p, "w", encoding="utf-8") as f:
        f.write(s)


if __name__ == "__main__":
    main()
