# Codpet - Interactive Pixel Companions / 像素桌面伴侣

[English](#english) | [简体中文](#简体中文)

---

<a name="english"></a>
## English Description

**Codpet** (formerly Codex Pets) is a curated collection of beautiful animated pixel companions designed to live in your editor or developer environment.

This repository serves as:
- **Asset Storage**: Every pet is neatly organized in its own folder containing its runtime metadata (`pet.json`) and spritesheet (`spritesheet.webp`).
- **Interactive Showcase**: A high-performance, minimalist static web gallery deployed on GitHub Pages at [https://0xpipilu.github.io/codpet/](https://0xpipilu.github.io/codpet/) (formerly `codex-pets`).

### Live Preview & Showcase

Browse the library online at: **[https://0xpipilu.github.io/codpet/](https://0xpipilu.github.io/codpet/)**
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
favicon.png           # Premium HD browser tab icon (Blackbird logo)
og-image.png          # High-definition social preview cover art
scripts/
  build_index.py      # Script to rebuild catalog index
  generate_thumbnails.py # Script to generate base thumbnails
  generate_favicon.py # Script to generate the browser tab icon
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

### Generating Favicon
To update the high-definition favicon.png browser tab icon from the Blackbird assets:
```bash
python3 scripts/generate_favicon.py
```

---

<a name="简体中文"></a>
## 简体中文说明

**Codpet**（原名 Codex Pets）是一个专为编辑器和开发环境设计的像素动画宠物精选库。

本仓库主要用途：
- **资源存储**：每只宠物拥有独立目录，包含其运行时元数据 (`pet.json`) 及精灵图 (`spritesheet.webp`)。
- **互动展示页**：部署于 GitHub Pages 的极简、高性能展示画廊，线上地址：[https://0xpipilu.github.io/codpet/](https://0xpipilu.github.io/codpet/)。

### 线上互动预览

在线浏览地址：**[https://0xpipilu.github.io/codpet/](https://0xpipilu.github.io/codpet/)**
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
favicon.png           # 高清浏览器页签图标（以黑鸟形象为 Logo）
og-image.png          # 高清社交预览封面大图
scripts/
  build_index.py      # 重建整站索引的 Python 脚本
  generate_thumbnails.py # 从精灵图自动裁剪生成静态缩略图的脚本
  generate_favicon.py # 自动裁剪、居中缩放生成浏览器图标的脚本
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

### 生成浏览器图标
需要从黑鸟资源更新高清浏览器页签图标时，运行：
```bash
python3 scripts/generate_favicon.py
```

---

## Pets Gallery / 宠物画廊

Here is a visual list of all the **89** interactive pixel pets available in Codpet:

<table align="center">
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/battle-damaged-idle/base.png" width="80" alt="Battle-Damaged Idle" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/blackbird/base.png" width="80" alt="Blackbird" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/brass-reed/base.png" width="80" alt="Brass Reed" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/brassbun/base.png" width="80" alt="Brassbun" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/brassprout/base.png" width="80" alt="Brassprout" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/brew/base.png" width="80" alt="Brew" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/brigbeak/base.png" width="80" alt="Brigbeak" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/brine-star/base.png" width="80" alt="Brine Star" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/brinepaw/base.png" width="80" alt="Brinepaw" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/bruno/base.png" width="80" alt="Bruno" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/Budley-pet/base.png" width="80" alt="Budley" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/butch-dog/base.png" width="80" alt="Butch Dog" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/cardinal/base.png" width="80" alt="Cardinal" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/castle-guard/base.png" width="80" alt="Castle Guard" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/climber-stick/base.png" width="80" alt="Climber" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/copper-cat-package/base.png" width="80" alt="Copper Cat" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/curlcap-pet/base.png" width="80" alt="Curlcap" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/dandy-beak/base.png" width="80" alt="Dandy Beak" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/dart/base.png" width="80" alt="Dart" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/dog-creak/base.png" width="80" alt="Dog Creak" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/droopy7/base.png" width="80" alt="Droopy-7" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/dusty/base.png" width="80" alt="Dusty" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/fat-robot/base.png" width="80" alt="Fat Robot" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/flamingo/base.png" width="80" alt="flamingo" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/freddy-machi/base.png" width="80" alt="Freddy Machi" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/glint/base.png" width="80" alt="Glint" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/glowtail/base.png" width="80" alt="Glowtail" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/grit/base.png" width="80" alt="Grit" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/heron/base.png" width="80" alt="Heron" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/honeybee/base.png" width="80" alt="Honeybee" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/inkbit/base.png" width="80" alt="Inkbit" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/jem/base.png" width="80" alt="Jem" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/josef-bot/base.png" width="80" alt="Josef Bot" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/koi/base.png" width="80" alt="Koi" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/luna/base.png" width="80" alt="Luna" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/machi-cat/base.png" width="80" alt="Machi Cat" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/machi-chef/base.png" width="80" alt="Machi Chef" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/machi-dog/base.png" width="80" alt="Machi Dog" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/machi-foxy/base.png" width="80" alt="Machi Foxy" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/machi-owl/base.png" width="80" alt="Machi Owl" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/marten/base.png" width="80" alt="Marten" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/mean guard/base.png" width="80" alt="Mean Guard" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/mechanical-maze-knight/base.png" width="80" alt="Mechanical Maze Knight" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/miso/base.png" width="80" alt="Miso" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/moss-maw/base.png" width="80" alt="Moss Maw" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/nib/base.png" width="80" alt="Nib" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/patch/base.png" width="80" alt="Patch" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/pebb/base.png" width="80" alt="Pebb" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/pinka/base.png" width="80" alt="Pinka" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/pinky/base.png" width="80" alt="Pinky" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/pip/base.png" width="80" alt="Pip" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/pipe-wrench-robot/base.png" width="80" alt="Pipe Wrench Robot" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/pub-player/base.png" width="80" alt="Pub Player" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/redcheek/base.png" width="80" alt="Redcheek" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/rivet-puff/base.png" width="80" alt="Rivet Puff" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/rook/base.png" width="80" alt="Rook" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/rosefinch/base.png" width="80" alt="Rosefinch" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/flying robot/base.png" width="80" alt="Rotor Josef" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/rustango/base.png" width="80" alt="Rustango" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/rustbeak/base.png" width="80" alt="RustBeak" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/rustveil/base.png" width="80" alt="Rustveil" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/samorost-boxbot/base.png" width="80" alt="Samorost Boxbot" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/scarlet-ibis/base.png" width="80" alt="Scarlet Ibis" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/walle/base.png" width="80" alt="Scrapling" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/scrib-codex-pet/base.png" width="80" alt="Scrib" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/skipp/base.png" width="80" alt="Skipp" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/smoking-robot/base.png" width="80" alt="Smoking Robot" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/snoo/base.png" width="80" alt="Snoo" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/spike/base.png" width="80" alt="Spike" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/split-chip/base.png" width="80" alt="Split Chip" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/spot/base.png" width="80" alt="Spot" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/springtrap-machi/base.png" width="80" alt="Springtrap Machi" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/stilt/base.png" width="80" alt="Stilt" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/sunny/base.png" width="80" alt="Sunny" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/tavern-lampbot/base.png" width="80" alt="Tavern Lampbot" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/the-drummer/base.png" width="80" alt="The Drummer" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/tin-grin/base.png" width="80" alt="Tin Grin" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/tin-terrier/base.png" width="80" alt="Tin Terrier" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/tinward-pet/base.png" width="80" alt="Tinward" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/tomo/base.png" width="80" alt="Tomo" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/tsuru/base.png" width="80" alt="tsuru" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/turaco/base.png" width="80" alt="Turaco" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/velmour/base.png" width="80" alt="velmour" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/vendo/base.png" width="80" alt="Vendo" /></td>
  </tr>
  <tr>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/vermora/base.png" width="80" alt="Vermora" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/wheelbox/base.png" width="80" alt="Wheelbox" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/whisk/base.png" width="80" alt="Whisk" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/white-eye/base.png" width="80" alt="White-Eye" /></td>
    <td align="center" valign="middle" width="160" height="160"><img src="pets/wreckling/base.png" width="80" alt="Wreckling" /></td>
    <td align="center" valign="middle" width="160" height="160">&nbsp;</td>
  </tr>
</table>
