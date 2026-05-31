#!/usr/bin/env python3

import json
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
PETS_DIR = ROOT / "pets"
INDEX_PATH = ROOT / "index.json"

def main():
    if not INDEX_PATH.exists():
        print(f"Error: {INDEX_PATH} does not exist. Run scripts/build_index.py first.")
        return

    with open(INDEX_PATH, "r", encoding="utf-8") as f:
        catalog = json.load(f)

    pets = catalog.get("pets", [])
    print(f"Generating thumbnails for {len(pets)} pets...")

    for pet in pets:
        slug = pet["slug"]
        folder_path = ROOT / pet["folder"]
        spritesheet_file = ROOT / pet["spritesheetFile"]
        
        if not spritesheet_file.exists():
            print(f"Warning: spritesheet not found for {slug} at {spritesheet_file}")
            continue

        # Get atlas specs
        atlas = pet.get("atlas", {})
        fw = atlas.get("frameWidth", 192)
        fh = atlas.get("frameHeight", 208)
        
        # Get first row's rowIndex
        preview_rows = pet.get("previewRows", [])
        row0 = preview_rows[0] if preview_rows else {"rowIndex": 0}
        row_idx = row0.get("rowIndex", 0)

        # Base frame coordinates
        left = 0
        top = row_idx * fh
        right = fw
        bottom = top + fh

        try:
            with Image.open(spritesheet_file) as img:
                # Ensure transparent backgrounds are handled properly
                if img.mode != "RGBA":
                    img = img.convert("RGBA")
                
                cropped = img.crop((left, top, right, bottom))
                
                # Resize thumbnail slightly to make README files load faster
                # (GitHub README renders them at around 80-100px width anyway)
                # Let's keep them high-res but reasonable size (e.g. max width 96px)
                # Wait, let's keep full size (192x208) so they look sharp on retina displays,
                # but compress nicely as transparent PNGs!
                
                output_path = folder_path / "base.png"
                cropped.save(output_path, "PNG", optimize=True)
                # Print dot to show progress
                print(f"Created base.png for {slug}")
        except Exception as e:
            print(f"Error processing {slug}: {e}")

    print("\nAll thumbnails generated successfully!")

if __name__ == "__main__":
    main()
