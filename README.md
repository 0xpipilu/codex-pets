# Copet - Interactive Pixel Companions / 像素桌面伴侣

[English](#english) | [简体中文](#简体中文)

---

<a name="english"></a>
## English Description

**Copet** (formerly Codex Pets) is a curated collection of beautiful animated pixel companions designed to live in your editor or developer environment.

This repository serves as:
- **Asset Storage**: Every pet is neatly organized in its own folder containing its runtime metadata (`pet.json`) and spritesheet (`spritesheet.webp`).
- **Interactive Showcase**: A high-performance, minimalist static web gallery deployed on GitHub Pages at [https://0xpipilu.github.io/copet/](https://0xpipilu.github.io/copet/) (formerly `codex-pets`).

### Live Preview & Showcase

Browse the library online at: **[https://0xpipilu.github.io/copet/](https://0xpipilu.github.io/copet/)**
- **Hover to Preview**: Move your mouse over any pet to see its accelerated interactive animations.
- **One-click Download**: Click `Download` on hover to grab a packaged `.zip` containing the pet's complete assets for easy installation.

### Repository Structure

```text
pets/
  <pet-folder>/
    pet.json          # Pet state mapping and metadata
    spritesheet.webp  # Spritesheet image
    base.png          # Static base thumbnail for documentation
index.json            # Generated catalog data in JSON
catalog.js            # Browser-ready catalog payload
index.html            # Ultra-minimalist showcase page
scripts/
  build_index.py      # Script to rebuild catalog index
  generate_thumbnails.py # Script to generate base thumbnails
```

### Updating the Catalog
When you add, remove, or rename pets, rebuild the index using:
```bash
python3 scripts/build_index.py
```

### Generating Base Thumbnails
To update documentation thumbnails for all pets from their spritesheets:
```bash
python3 scripts/generate_thumbnails.py
```

---

<a name="简体中文"></a>
## 简体中文说明

**Copet**（原名 Codex Pets）是一个专为编辑器和开发环境设计的像素动画宠物精选库。

本仓库主要用途：
- **资源存储**：每只宠物拥有独立目录，包含其运行时元数据 (`pet.json`) 及精灵图 (`spritesheet.webp`)。
- **互动展示页**：部署于 GitHub Pages 的极简、高性能展示画廊，线上地址：[https://0xpipilu.github.io/copet/](https://0xpipilu.github.io/copet/)。

### 线上互动预览

在线浏览地址：**[https://0xpipilu.github.io/copet/](https://0xpipilu.github.io/copet/)**
- **悬停预览**：将鼠标悬停在任意宠物上，即可加速循环预览其所有状态的动态效果。
- **一键下载**：悬浮时点击 `Download` 即可一键下载包含该宠物完整元数据与精灵图的 `.zip` 压缩包。

### 目录结构

```text
pets/
  <宠物目录>/
    pet.json          # 宠物元数据及动作状态映射
    spritesheet.webp  # 精灵图
    base.png          # 用于文档的静态基础缩略图
index.json            # 自动生成的整站 JSON 索引
catalog.js            # 浏览器直接加载的 JS 索引
index.html            # 超极简的线上画廊单页面
scripts/
  build_index.py      # 重建整站索引的 Python 脚本
  generate_thumbnails.py # 从精灵图自动裁剪生成静态缩略图的脚本
```

### 更新索引
当您添加、删除或重命名宠物时，运行以下命令重建索引：
```bash
python3 scripts/build_index.py
```

### 生成基础缩略图
需要更新宠物在 README 文档中的静态缩略图时，运行：
```bash
python3 scripts/generate_thumbnails.py
```

---

## Pets Gallery / 宠物画廊

Here is a visual list of all the **83** interactive pixel pets available in Copet:

| <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" width="160" height="1" /> | <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" width="160" height="1" /> | <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" width="160" height="1" /> | <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" width="160" height="1" /> | <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" width="160" height="1" /> | <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" width="160" height="1" /> |
|:---:|:---:|:---:|:---:|:---:|:---:|
| <img src="pets/battle-damaged-idle/base.png" width="80" alt="Battle-Damaged Idle" /> | <img src="pets/blackbird/base.png" width="80" alt="Blackbird" /> | <img src="pets/brass-reed/base.png" width="80" alt="Brass Reed" /> | <img src="pets/brassbun/base.png" width="80" alt="Brassbun" /> | <img src="pets/brassprout/base.png" width="80" alt="Brassprout" /> | <img src="pets/brew/base.png" width="80" alt="Brew" /> |
| <img src="pets/brigbeak/base.png" width="80" alt="Brigbeak" /> | <img src="pets/brine-star/base.png" width="80" alt="Brine Star" /> | <img src="pets/brinepaw/base.png" width="80" alt="Brinepaw" /> | <img src="pets/bruno/base.png" width="80" alt="Bruno" /> | <img src="pets/Budley-pet/base.png" width="80" alt="Budley" /> | <img src="pets/butch-dog/base.png" width="80" alt="Butch Dog" /> |
| <img src="pets/cardinal/base.png" width="80" alt="Cardinal" /> | <img src="pets/castle-guard/base.png" width="80" alt="Castle Guard" /> | <img src="pets/climber-stick/base.png" width="80" alt="Climber" /> | <img src="pets/copper-cat-package/base.png" width="80" alt="Copper Cat" /> | <img src="pets/curlcap-pet/base.png" width="80" alt="Curlcap" /> | <img src="pets/dandy-beak/base.png" width="80" alt="Dandy Beak" /> |
| <img src="pets/dart/base.png" width="80" alt="Dart" /> | <img src="pets/dog-creak/base.png" width="80" alt="Dog Creak" /> | <img src="pets/droopy7/base.png" width="80" alt="Droopy-7" /> | <img src="pets/fat-robot/base.png" width="80" alt="Fat Robot" /> | <img src="pets/flamingo/base.png" width="80" alt="flamingo" /> | <img src="pets/freddy-machi/base.png" width="80" alt="Freddy Machi" /> |
| <img src="pets/glint/base.png" width="80" alt="Glint" /> | <img src="pets/glowtail/base.png" width="80" alt="Glowtail" /> | <img src="pets/heron/base.png" width="80" alt="Heron" /> | <img src="pets/honeybee/base.png" width="80" alt="Honeybee" /> | <img src="pets/inkbit/base.png" width="80" alt="Inkbit" /> | <img src="pets/jem/base.png" width="80" alt="Jem" /> |
| <img src="pets/josef-bot/base.png" width="80" alt="Josef Bot" /> | <img src="pets/koi/base.png" width="80" alt="Koi" /> | <img src="pets/luna/base.png" width="80" alt="Luna" /> | <img src="pets/machi-cat/base.png" width="80" alt="Machi Cat" /> | <img src="pets/machi-chef/base.png" width="80" alt="Machi Chef" /> | <img src="pets/machi-dog/base.png" width="80" alt="Machi Dog" /> |
| <img src="pets/machi-foxy/base.png" width="80" alt="Machi Foxy" /> | <img src="pets/machi-owl/base.png" width="80" alt="Machi Owl" /> | <img src="pets/marten/base.png" width="80" alt="Marten" /> | <img src="pets/mean guard/base.png" width="80" alt="Mean Guard" /> | <img src="pets/mechanical-maze-knight/base.png" width="80" alt="Mechanical Maze Knight" /> | <img src="pets/moss-maw/base.png" width="80" alt="Moss Maw" /> |
| <img src="pets/pebb/base.png" width="80" alt="Pebb" /> | <img src="pets/pinky/base.png" width="80" alt="Pinky" /> | <img src="pets/pip/base.png" width="80" alt="Pip" /> | <img src="pets/pipe-wrench-robot/base.png" width="80" alt="Pipe Wrench Robot" /> | <img src="pets/pub-player/base.png" width="80" alt="Pub Player" /> | <img src="pets/redcheek/base.png" width="80" alt="Redcheek" /> |
| <img src="pets/rivet-puff/base.png" width="80" alt="Rivet Puff" /> | <img src="pets/rook/base.png" width="80" alt="Rook" /> | <img src="pets/rosefinch/base.png" width="80" alt="Rosefinch" /> | <img src="pets/flying robot/base.png" width="80" alt="Rotor Josef" /> | <img src="pets/rustango/base.png" width="80" alt="Rustango" /> | <img src="pets/rustbeak/base.png" width="80" alt="RustBeak" /> |
| <img src="pets/rustveil/base.png" width="80" alt="Rustveil" /> | <img src="pets/samorost-boxbot/base.png" width="80" alt="Samorost Boxbot" /> | <img src="pets/scarlet-ibis/base.png" width="80" alt="Scarlet Ibis" /> | <img src="pets/walle/base.png" width="80" alt="Scrapling" /> | <img src="pets/scrib-codex-pet/base.png" width="80" alt="Scrib" /> | <img src="pets/skipp/base.png" width="80" alt="Skipp" /> |
| <img src="pets/smoking-robot/base.png" width="80" alt="Smoking Robot" /> | <img src="pets/snoo/base.png" width="80" alt="Snoo" /> | <img src="pets/spike/base.png" width="80" alt="Spike" /> | <img src="pets/split-chip/base.png" width="80" alt="Split Chip" /> | <img src="pets/spot/base.png" width="80" alt="Spot" /> | <img src="pets/springtrap-machi/base.png" width="80" alt="Springtrap Machi" /> |
| <img src="pets/stilt/base.png" width="80" alt="Stilt" /> | <img src="pets/sunny/base.png" width="80" alt="Sunny" /> | <img src="pets/tavern-lampbot/base.png" width="80" alt="Tavern Lampbot" /> | <img src="pets/the-drummer/base.png" width="80" alt="The Drummer" /> | <img src="pets/tin-grin/base.png" width="80" alt="Tin Grin" /> | <img src="pets/tin-terrier/base.png" width="80" alt="Tin Terrier" /> |
| <img src="pets/tinward-pet/base.png" width="80" alt="Tinward" /> | <img src="pets/tomo/base.png" width="80" alt="Tomo" /> | <img src="pets/tsuru/base.png" width="80" alt="tsuru" /> | <img src="pets/turaco/base.png" width="80" alt="Turaco" /> | <img src="pets/velmour/base.png" width="80" alt="velmour" /> | <img src="pets/vendo/base.png" width="80" alt="Vendo" /> |
| <img src="pets/vermora/base.png" width="80" alt="Vermora" /> | <img src="pets/wheelbox/base.png" width="80" alt="Wheelbox" /> | <img src="pets/whisk/base.png" width="80" alt="Whisk" /> | <img src="pets/white-eye/base.png" width="80" alt="White-Eye" /> | <img src="pets/wreckling/base.png" width="80" alt="Wreckling" /> | <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" width="80" height="1" alt="spacer" /> |
