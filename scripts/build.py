import re
import os

def minify_css(css):
    # Remove block comments
    css = re.sub(r'/\*.*?\*/', '', css, flags=re.DOTALL)
    # Collapse multiple spaces and newlines
    css = re.sub(r'\s+', ' ', css)
    # Remove whitespace around structural characters
    css = re.sub(r'\s*([\{\};:,])\s*', r'\1', css)
    # Remove trailing semicolons in blocks
    css = css.replace(';}', '}')
    return css.strip()

def minify_js(js):
    # Safe JS minifier (removes comments, empty lines, and preserves syntax integrity)
    # Remove block comments
    js = re.sub(r'/\*.*?\*/', '', js, flags=re.DOTALL)
    
    lines = []
    for line in js.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith('//'):
            continue
            
        # Strip trailing comments if they exist and are safe (not inside URLs or strings)
        if '//' in line:
            if 'http://' in line or 'https://' in line or 'url(' in line or '"' in line or "'" in line:
                lines.append(stripped)
            else:
                parts = line.split('//', 1)
                left = parts[0].strip()
                if left:
                    lines.append(left)
        else:
            lines.append(stripped)
            
    # Join with newlines (safe against automatic semicolon insertion issues)
    return '\n'.join(lines)

def main():
    print("=== Starting build.py ===")
    
    # Paths
    dev_html_path = "index.dev.html"
    css_path = "style.css"
    js_path = "app.js"
    prod_html_path = "index.html"

    # Verify files exist
    for p in [dev_html_path, css_path, js_path]:
        if not os.path.exists(p):
            print(f"Error: Required file '{p}' not found!")
            return

    # Read development files
    with open(dev_html_path, "r", encoding="utf-8") as f:
        html = f.read()
    with open(css_path, "r", encoding="utf-8") as f:
        css = f.read()
    with open(js_path, "r", encoding="utf-8") as f:
        js = f.read()

    print("Minifying CSS...")
    min_css = minify_css(css)
    print(f"  - CSS size reduced from {len(css)/1024:.1f} KB to {len(min_css)/1024:.1f} KB")

    print("Minifying JS...")
    min_js = minify_js(js)
    print(f"  - JS size reduced from {len(js)/1024:.1f} KB to {len(min_js)/1024:.1f} KB")

    # Replace local stylesheet link
    style_placeholder = '<link rel="stylesheet" href="style.css">'
    if style_placeholder in html:
        html = html.replace(style_placeholder, f"<style>{min_css}</style>")
        print("  - Inline style.css injected successfully.")
    else:
        print("  - Warning: Could not find style.css link placeholder in index.dev.html!")

    # Replace local script link
    script_placeholder = '<script src="app.js"></script>'
    if script_placeholder in html:
        html = html.replace(script_placeholder, f"<script>{min_js}</script>")
        print("  - Inline app.js injected successfully.")
    else:
        print("  - Warning: Could not find app.js script placeholder in index.dev.html!")

    # Write output to index.html
    with open(prod_html_path, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"Production index.html compiled successfully! File size: {os.path.getsize(prod_html_path)/1024:.1f} KB")

if __name__ == "__main__":
    main()
