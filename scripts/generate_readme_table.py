#!/usr/bin/env python3

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
INDEX_PATH = ROOT / "index.json"

def main():
    if not INDEX_PATH.exists():
        print("Error: index.json not found.")
        return

    with open(INDEX_PATH, "r", encoding="utf-8") as f:
        catalog = json.load(f)

    pets = catalog.get("pets", [])
    cols = 6
    rows = []
    
    # Sort pets alphabetically by displayName
    pets = sorted(pets, key=lambda p: p["displayName"].lower())

    markdown = []
    markdown.append("| " + " | ".join([""] * cols) + " |")
    markdown.append("|" + "|".join([":---:"] * cols) + "|")

    current_row = []
    for pet in pets:
        slug = pet["slug"]
        name = pet["displayName"]
        img_tag = f'<img src="pets/{slug}/base.png" width="80" alt="{name}" />'
        cell = f"{img_tag}<br>**{name}**"
        current_row.append(cell)
        
        if len(current_row) == cols:
            markdown.append("| " + " | ".join(current_row) + " |")
            current_row = []
            
    if current_row:
        # Pad the last row
        while len(current_row) < cols:
            current_row.append("")
        markdown.append("| " + " | ".join(current_row) + " |")

    print("\n".join(markdown))

if __name__ == "__main__":
    main()
