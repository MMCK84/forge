# -*- coding: utf-8 -*-
"""Stimmt die Spielzeit je Epoche auf die Zielwerte aus Lastenheft 5.8 ab.

Hebel: Aufheizrate der Essen und je Epoche ein Faktor f auf FP_Start(e). Der Satz je
Form-Punkt wird durch denselben Faktor geteilt, damit die Löhne (Tabelle 3.3) und damit
die Einnahmen unverändert bleiben. Misst mit tools/balance_sim.gd in Godot.

    python tools/tune_balance.py /pfad/zu/godot [f1,f2,f3,f4,f5,f6]
"""
import re
import subprocess
import sys

ROOT = __file__.rsplit("/tools/", 1)[0]
GODOT = sys.argv[1] if len(sys.argv) > 1 else "godot"
BASE_FP = [300, 1800, 6000, 12000, 25000, 40000, 60000, 100000, 180000, 300000]
BASE_RATE = [0.040, 0.040, 0.035, 0.045, 0.050, 0.065, 0.096, 0.0873, 0.0711, 0.064]
TARGET_MIN = [12, 23, 56, 83, 131, 157, 78, 84, 90, 96]
N = len(TARGET_MIN)
FORGES = {"forge_clay": 90.0, "forge_brick": 110.0, "forge_double_bellows": 125.0, "forge_coke": 150.0,
          "forge_welding_furnace": 175.0, "forge_siemens": 210.0}
# Abgestimmt wird auf den echten Auftragsmix (Generator), denn das ist die tatsächliche Spielzeit.
MIXED = True


def write_params(f):
    p = ROOT + "/data/balance/balance_config.tres"
    s = open(p, encoding="utf-8").read()
    fp = ", ".join(repr(float(round(BASE_FP[i] * f[i]))) for i in range(N))
    rate = ", ".join(repr(round(BASE_RATE[i] * BASE_FP[i] / round(BASE_FP[i] * f[i]), 6)) for i in range(N))
    s = re.sub(r"fp_start = PackedFloat32Array\([^)]*\)", f"fp_start = PackedFloat32Array({fp})", s)
    s = re.sub(r"rate_per_fp = PackedFloat32Array\([^)]*\)", f"rate_per_fp = PackedFloat32Array({rate})", s)
    open(p, "w", encoding="utf-8").write(s)
    for fid, k in FORGES.items():
        q = f"{ROOT}/data/forges/{fid}.tres"
        t = open(q, encoding="utf-8").read()
        t = re.sub(r"k_heat = [\d.]+", f"k_heat = {k}", t)
        open(q, "w", encoding="utf-8").write(t)


SEEDS = [1, 2, 3, 4]


def measure_one(mixed=False, seed=12345):
    args = [GODOT, "--headless", "--path", ROOT, "-s", "res://tools/balance_sim.gd"]
    if mixed:
        args += ["--", "--mixed", f"--seed={seed}"]
    out = subprocess.run(args, capture_output=True, text=True, timeout=900).stdout
    rows = re.findall(r"^\s+(\d+)\s+\|\s+([\d.]+) min", out, re.M)
    total = re.search(r"Gesamt: ([\d.]+) h", out).group(1)
    if "WARNUNG" in out:
        print("  ! hängender Auftrag:", [l for l in out.splitlines() if "WARNUNG" in l][0])
    return [float(m) for _, m in rows], float(total), out


def measure(mixed=False):
    """Mittelwert über mehrere Seeds (Auftragsmix ist zufällig)."""
    if not mixed:
        return measure_one(False)
    runs = [measure_one(True, s) for s in SEEDS]
    mins = [sum(r[0][i] for r in runs) / len(runs) for i in range(N)]
    total = sum(r[1] for r in runs) / len(runs)
    return mins, round(total, 2), runs[0][2]


def main():
    f = [float(x) for x in sys.argv[2].split(",")] if len(sys.argv) > 2 else [1.0] * N
    for it in range(8):
        write_params(f)
        mins, total, _ = measure(MIXED)
        print(f"Iteration {it}: gesamt {total} h, Epochen {[round(m, 1) for m in mins]}, f = {[round(x, 3) for x in f]}")
        if all(abs(m / t - 1) < 0.025 for m, t in zip(mins, TARGET_MIN)):
            break
        # Annahme: Zeit ≈ a + b·f; ein Teil der Zeit (Aufheizen) hängt nicht von f ab
        f = [max(0.25, x * (0.35 + 0.65 * t / m)) for x, m, t in zip(f, mins, TARGET_MIN)]
    print("f =", [round(x, 3) for x in f])


if __name__ == "__main__":
    main()
