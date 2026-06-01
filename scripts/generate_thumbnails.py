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
                
                # Automatically convert fuchsia/magenta (#FF00FF) background to transparent
                datas = cropped.getdata()
                newData = []
                for item in datas:
                    if item[0] > 230 and item[1] < 40 and item[2] > 230:
                        newData.append((0, 0, 0, 0))
                    else:
                        newData.append(item)
                cropped.putdata(newData)
                
                # Resize thumbnail slightly to make README files load faster
                # (GitHub README renders them at around 80-100px width anyway)
                # Let's keep them high-res but reasonable size (e.g. max width 96px)
                # Wait, let's keep full size (192x208) so they look sharp on retina displays,
                # but compress nicely as transparent PNGs!
                
                output_path = folder_path / "base.png"
                cropped.save(output_path, "PNG", optimize=True)
                print(f"Created base.png for {slug}")
                
                # For animated.svg (6 frames)
                idle_strip = img.crop((0, top, fw * 6, top + fh))
                idle_datas = idle_strip.getdata()
                idle_newData = []
                for item in idle_datas:
                    if item[0] > 230 and item[1] < 40 and item[2] > 230:
                        idle_newData.append((0, 0, 0, 0))
                    else:
                        idle_newData.append(item)
                idle_strip.putdata(idle_newData)
                
                # Generate 50% resized idle strip for ultra-lightweight embedded base64 animation
                # NEAREST resampling preserves crisp pixel-art edges perfectly!
                rw = 96
                rh = 104
                resized_strip = idle_strip.resize((rw * 6, rh), Image.Resampling.NEAREST)
                
                # Compress highly using WebP quality 90 to keep it extremely small (~30KB)
                import base64
                from io import BytesIO
                buf = BytesIO()
                resized_strip.save(buf, format="WEBP", quality=90)
                b64_data = base64.b64encode(buf.getvalue()).decode("utf-8")
                
                total_idle_width = rw * 6
                svg_content = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {rw} {rh}" width="100%" height="100%">
  <defs>
    <style>
      .sprite {{
        transform: translate(0, 0);
      }}
      @media (hover: hover) {{
        svg:hover .sprite {{
          animation: play-idle 1.1s steps(6) infinite;
        }}
      }}
      /* Hover fallback style */
      svg:hover .sprite {{
        animation: play-idle 1.1s steps(6) infinite;
      }}
      @keyframes play-idle {{
        from {{ transform: translate(0, 0); }}
        to {{ transform: translate(-{total_idle_width}px, 0); }}
      }}
    </style>
  </defs>
  <g width="{rw}" height="{rh}" clip-path="url(#clip)">
    <clipPath id="clip">
      <rect width="{rw}" height="{rh}" />
    </clipPath>
    <image class="sprite" href="data:image/webp;base64,{b64_data}" width="{total_idle_width}" height="{rh}" />
  </g>
</svg>
"""
                svg_path = folder_path / "animated.svg"
                svg_path.write_text(svg_content.strip() + "\n", encoding="utf-8")
                print(f"Created self-contained animated.svg for {slug}")
        except Exception as e:
            print(f"Error processing {slug}: {e}")

    print("\nAll thumbnails generated successfully!")

if __name__ == "__main__":
    main()
