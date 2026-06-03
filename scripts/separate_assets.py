import re

def main():
    print("Reading index.html...")
    with open("index.html", "r", encoding="utf-8") as f:
        html_content = f.read()

    # Find CSS block between <style> and </style>
    css_match = re.search(r'<style>\s*(:root\s*\{.*?)</style>', html_content, re.DOTALL)
    if not css_match:
        print("Error: Could not find main CSS block!")
        return
    css_content = css_match.group(1)

    # Find the script block starting with "const galleryEl = "
    # We find '<script>' followed by "const galleryEl = " and then everything until '</script>'
    js_match = re.search(r'<script>\s*(const galleryEl = .*?)</script>', html_content, re.DOTALL)
    if not js_match:
        print("Error: Could not find main JS block!")
        return
    js_content = js_match.group(1)

    print("Writing style.css...")
    with open("style.css", "w", encoding="utf-8") as f:
        f.write(css_content.strip() + "\n")

    print("Writing app.js...")
    with open("app.js", "w", encoding="utf-8") as f:
        f.write(js_content.strip() + "\n")

    # Replace blocks in HTML
    html_content = html_content.replace(css_match.group(0), '<link rel="stylesheet" href="style.css">')
    html_content = html_content.replace(js_match.group(0), '<script defer src="app.js"></script>')

    print("Writing updated index.html...")
    with open("index.html", "w", encoding="utf-8") as f:
        f.write(html_content)

    print("Success!")

if __name__ == "__main__":
    main()
