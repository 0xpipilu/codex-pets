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

|  |  |  |  |  |  |
|:---:|:---:|:---:|:---:|:---:|:---:|
| <img src="pets/battle-damaged-idle/base.png" width="80" alt="Battle-Damaged Idle" /><br>**Battle-Damaged Idle** | <img src="pets/blackbird/base.png" width="80" alt="Blackbird" /><br>**Blackbird** | <img src="pets/brass-reed/base.png" width="80" alt="Brass Reed" /><br>**Brass Reed** | <img src="pets/brassbun/base.png" width="80" alt="Brassbun" /><br>**Brassbun** | <img src="pets/brassprout/base.png" width="80" alt="Brassprout" /><br>**Brassprout** | <img src="pets/brew/base.png" width="80" alt="Brew" /><br>**Brew** |
| <img src="pets/brigbeak/base.png" width="80" alt="Brigbeak" /><br>**Brigbeak** | <img src="pets/brine-star/base.png" width="80" alt="Brine Star" /><br>**Brine Star** | <img src="pets/brinepaw/base.png" width="80" alt="Brinepaw" /><br>**Brinepaw** | <img src="pets/bruno/base.png" width="80" alt="Bruno" /><br>**Bruno** | <img src="pets/Budley-pet/base.png" width="80" alt="Budley" /><br>**Budley** | <img src="pets/butch-dog/base.png" width="80" alt="Butch Dog" /><br>**Butch Dog** |
| <img src="pets/cardinal/base.png" width="80" alt="Cardinal" /><br>**Cardinal** | <img src="pets/castle-guard/base.png" width="80" alt="Castle Guard" /><br>**Castle Guard** | <img src="pets/climber-stick/base.png" width="80" alt="Climber" /><br>**Climber** | <img src="pets/copper-cat-package/base.png" width="80" alt="Copper Cat" /><br>**Copper Cat** | <img src="pets/curlcap-pet/base.png" width="80" alt="Curlcap" /><br>**Curlcap** | <img src="pets/dandy-beak/base.png" width="80" alt="Dandy Beak" /><br>**Dandy Beak** |
| <img src="pets/dart/base.png" width="80" alt="Dart" /><br>**Dart** | <img src="pets/dog-creak/base.png" width="80" alt="Dog Creak" /><br>**Dog Creak** | <img src="pets/droopy7/base.png" width="80" alt="Droopy-7" /><br>**Droopy-7** | <img src="pets/fat-robot/base.png" width="80" alt="Fat Robot" /><br>**Fat Robot** | <img src="pets/flamingo/base.png" width="80" alt="flamingo" /><br>**flamingo** | <img src="pets/freddy-machi/base.png" width="80" alt="Freddy Machi" /><br>**Freddy Machi** |
| <img src="pets/glint/base.png" width="80" alt="Glint" /><br>**Glint** | <img src="pets/glowtail/base.png" width="80" alt="Glowtail" /><br>**Glowtail** | <img src="pets/heron/base.png" width="80" alt="Heron" /><br>**Heron** | <img src="pets/honeybee/base.png" width="80" alt="Honeybee" /><br>**Honeybee** | <img src="pets/inkbit/base.png" width="80" alt="Inkbit" /><br>**Inkbit** | <img src="pets/jem/base.png" width="80" alt="Jem" /><br>**Jem** |
| <img src="pets/josef-bot/base.png" width="80" alt="Josef Bot" /><br>**Josef Bot** | <img src="pets/koi/base.png" width="80" alt="Koi" /><br>**Koi** | <img src="pets/luna/base.png" width="80" alt="Luna" /><br>**Luna** | <img src="pets/machi-cat/base.png" width="80" alt="Machi Cat" /><br>**Machi Cat** | <img src="pets/machi-chef/base.png" width="80" alt="Machi Chef" /><br>**Machi Chef** | <img src="pets/machi-dog/base.png" width="80" alt="Machi Dog" /><br>**Machi Dog** |
| <img src="pets/machi-foxy/base.png" width="80" alt="Machi Foxy" /><br>**Machi Foxy** | <img src="pets/machi-owl/base.png" width="80" alt="Machi Owl" /><br>**Machi Owl** | <img src="pets/marten/base.png" width="80" alt="Marten" /><br>**Marten** | <img src="pets/mean guard/base.png" width="80" alt="Mean Guard" /><br>**Mean Guard** | <img src="pets/mechanical-maze-knight/base.png" width="80" alt="Mechanical Maze Knight" /><br>**Mechanical Maze Knight** | <img src="pets/moss-maw/base.png" width="80" alt="Moss Maw" /><br>**Moss Maw** |
| <img src="pets/pebb/base.png" width="80" alt="Pebb" /><br>**Pebb** | <img src="pets/pinky/base.png" width="80" alt="Pinky" /><br>**Pinky** | <img src="pets/pip/base.png" width="80" alt="Pip" /><br>**Pip** | <img src="pets/pipe-wrench-robot/base.png" width="80" alt="Pipe Wrench Robot" /><br>**Pipe Wrench Robot** | <img src="pets/pub-player/base.png" width="80" alt="Pub Player" /><br>**Pub Player** | <img src="pets/redcheek/base.png" width="80" alt="Redcheek" /><br>**Redcheek** |
| <img src="pets/rivet-puff/base.png" width="80" alt="Rivet Puff" /><br>**Rivet Puff** | <img src="pets/rook/base.png" width="80" alt="Rook" /><br>**Rook** | <img src="pets/rosefinch/base.png" width="80" alt="Rosefinch" /><br>**Rosefinch** | <img src="pets/flying robot/base.png" width="80" alt="Rotor Josef" /><br>**Rotor Josef** | <img src="pets/rustango/base.png" width="80" alt="Rustango" /><br>**Rustango** | <img src="pets/rustbeak/base.png" width="80" alt="RustBeak" /><br>**RustBeak** |
| <img src="pets/rustveil/base.png" width="80" alt="Rustveil" /><br>**Rustveil** | <img src="pets/samorost-boxbot/base.png" width="80" alt="Samorost Boxbot" /><br>**Samorost Boxbot** | <img src="pets/scarlet-ibis/base.png" width="80" alt="Scarlet Ibis" /><br>**Scarlet Ibis** | <img src="pets/walle/base.png" width="80" alt="Scrapling" /><br>**Scrapling** | <img src="pets/scrib-codex-pet/base.png" width="80" alt="Scrib" /><br>**Scrib** | <img src="pets/skipp/base.png" width="80" alt="Skipp" /><br>**Skipp** |
| <img src="pets/smoking-robot/base.png" width="80" alt="Smoking Robot" /><br>**Smoking Robot** | <img src="pets/snoo/base.png" width="80" alt="Snoo" /><br>**Snoo** | <img src="pets/spike/base.png" width="80" alt="Spike" /><br>**Spike** | <img src="pets/split-chip/base.png" width="80" alt="Split Chip" /><br>**Split Chip** | <img src="pets/spot/base.png" width="80" alt="Spot" /><br>**Spot** | <img src="pets/springtrap-machi/base.png" width="80" alt="Springtrap Machi" /><br>**Springtrap Machi** |
| <img src="pets/stilt/base.png" width="80" alt="Stilt" /><br>**Stilt** | <img src="pets/sunny/base.png" width="80" alt="Sunny" /><br>**Sunny** | <img src="pets/tavern-lampbot/base.png" width="80" alt="Tavern Lampbot" /><br>**Tavern Lampbot** | <img src="pets/the-drummer/base.png" width="80" alt="The Drummer" /><br>**The Drummer** | <img src="pets/tin-grin/base.png" width="80" alt="Tin Grin" /><br>**Tin Grin** | <img src="pets/tin-terrier/base.png" width="80" alt="Tin Terrier" /><br>**Tin Terrier** |
| <img src="pets/tinward-pet/base.png" width="80" alt="Tinward" /><br>**Tinward** | <img src="pets/tomo/base.png" width="80" alt="Tomo" /><br>**Tomo** | <img src="pets/tsuru/base.png" width="80" alt="tsuru" /><br>**tsuru** | <img src="pets/turaco/base.png" width="80" alt="Turaco" /><br>**Turaco** | <img src="pets/velmour/base.png" width="80" alt="velmour" /><br>**velmour** | <img src="pets/vendo/base.png" width="80" alt="Vendo" /><br>**Vendo** |
| <img src="pets/vermora/base.png" width="80" alt="Vermora" /><br>**Vermora** | <img src="pets/wheelbox/base.png" width="80" alt="Wheelbox" /><br>**Wheelbox** | <img src="pets/whisk/base.png" width="80" alt="Whisk" /><br>**Whisk** | <img src="pets/white-eye/base.png" width="80" alt="White-Eye" /><br>**White-Eye** | <img src="pets/wreckling/base.png" width="80" alt="Wreckling" /><br>**Wreckling** |  |
