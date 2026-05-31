# Codex Pets Library

A curated library of Codex pets collected in a simple repository structure.

This repo is set up for two use cases:

- asset storage: each pet lives in its own folder with just the runtime files
- visual browsing: a static preview page reads generated catalog data and renders the collection

## Repository Structure

```text
pets/
  <pet-folder>/
    pet.json
    spritesheet.webp

index.json
catalog.js
index.html
scripts/build_index.py
```

## What Is Included

- `pets/<pet-folder>/pet.json`: pet metadata and state mapping
- `pets/<pet-folder>/spritesheet.webp`: spritesheet used by the pet runtime
- `index.json`: generated catalog for the whole collection
- `catalog.js`: browser-ready copy of the generated catalog
- `index.html`: static gallery page for browsing the pets

## Preview The Library

If you enable GitHub Pages for this repository, `index.html` becomes a lightweight browser for the collection.

Suggested Pages settings:

1. Go to repository `Settings`
2. Open `Pages`
3. Set source to `Deploy from a branch`
4. Choose branch `main` and folder `/ (root)`

After that, your gallery page will be available at a URL like:

```text
https://0xpipilu.github.io/codex-pets/
```

If GitHub still shows a plain `404` page that says there is no Pages site, the repository has not been published yet. Open `Settings` -> `Pages`, choose branch `main`, folder `/ (root)`, and wait a few minutes for the first deploy.

## Update The Catalog

When you add, remove, or rename pets, regenerate the catalog files:

```bash
python3 scripts/build_index.py
```

The script scans `pets/*/pet.json` and rebuilds both `index.json` and `catalog.js`.

## Share A Specific Pet

The static preview supports direct links to a selected pet with a query parameter or hash:

```text
https://0xpipilu.github.io/codex-pets/?pet=bruno
https://0xpipilu.github.io/codex-pets/#bruno
```

## Publish Changes

```bash
git add .
git commit -m "update pet library"
git push
```

## Notes

- Folder names are preserved from the original build output, so some folder names differ from the `id` inside `pet.json`.
- This repository currently tracks the minimal runtime package for each pet: `pet.json` plus `spritesheet.webp`.
- I intentionally did not add a license yet, because that choice affects how others may reuse your work.
