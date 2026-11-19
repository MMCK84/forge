"""Kontaktbogen zur Sichtprüfung: python contact_sheet.py out.png datei1.png datei2.png ..."""
import sys
from PIL import Image, ImageDraw
files = sys.argv[2:]
imgs = [Image.open(f).convert("RGBA") for f in files]
cols = int(sys.argv[1].split(":")[1]) if ":" in sys.argv[1] else 4
out = sys.argv[1].split(":")[0]
cw = max(i.width for i in imgs); ch = max(i.height for i in imgs) + 20
rows = (len(imgs) + cols - 1) // cols
sheet = Image.new("RGBA", (cw * cols, ch * rows), (58, 46, 38, 255))
d = ImageDraw.Draw(sheet)
for k, (f, im) in enumerate(zip(files, imgs)):
    x, y = (k % cols) * cw, (k // cols) * ch
    sheet.alpha_composite(im, (x, y))
    d.text((x + 4, y + ch - 16), f.split("/")[-1], fill=(255, 255, 255, 255))
sheet.convert("RGB").save(out)
