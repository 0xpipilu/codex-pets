#!/usr/bin/env python3

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
PETS_DIR = ROOT / "pets"
INDEX_PATH = ROOT / "index.json"
CATALOG_JS_PATH = ROOT / "catalog.js"


def build_catalog() -> dict:
    pets = []

    for pet_dir in sorted((path for path in PETS_DIR.iterdir() if path.is_dir()), key=lambda p: p.name.lower()):
        pet_json = pet_dir / "pet.json"
        if not pet_json.exists():
            continue

        data = json.loads(pet_json.read_text(encoding="utf-8"))
        spritesheet_path = data.get("spritesheetPath", "spritesheet.webp")
        state_names = sorted((data.get("states") or {}).keys())

        pets.append(
            {
                "slug": pet_dir.name,
                "folder": f"pets/{pet_dir.name}",
                "id": data.get("id", pet_dir.name),
                "displayName": data.get("displayName", pet_dir.name),
                "description": data.get("description", ""),
                "spritesheetPath": spritesheet_path,
                "petJsonPath": f"pets/{pet_dir.name}/pet.json",
                "spritesheetFile": f"pets/{pet_dir.name}/{spritesheet_path}",
                "stateNames": state_names,
                "stateCount": len(state_names),
            }
        )

    return {
        "count": len(pets),
        "pets": pets,
    }


def main() -> None:
    catalog = build_catalog()

    INDEX_PATH.write_text(
        json.dumps(catalog, ensure_ascii=True, indent=2) + "\n",
        encoding="utf-8",
    )
    CATALOG_JS_PATH.write_text(
        "window.__CODEX_PETS__ = " + json.dumps(catalog, ensure_ascii=True, indent=2) + ";\n",
        encoding="utf-8",
    )
    print(f"Wrote {INDEX_PATH.relative_to(ROOT)}")
    print(f"Wrote {CATALOG_JS_PATH.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
