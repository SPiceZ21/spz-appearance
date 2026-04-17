<div align="center">

<img src="https://github.com/SPiceZ21/spz-core-media-kit/raw/main/Banner/Banner%232.png" alt="SPiceZ-Core Banner" width="100%"/>

<br/>

# spz-appearance

### Player Models & Outfit Management

*The dedicated module for handling ped models, outfit priority systems, and personal/crew outfit persistence.*

<br/>

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-orange.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-orange?style=flat-square)](https://fivem.net)
[![Lua](https://img.shields.io/badge/Lua-5.4-blue?style=flat-square&logo=lua)](https://lua.org)
[![Status](https://img.shields.io/badge/Status-In%20Development-green?style=flat-square)]()

</div>

---

## Overview

`spz-appearance` is the dedicated resource for managing the visual appearance of players within the ecosystem. It provides an architecture for applying and persisting ped models, managing personal saved outfits, assigning crew uniforms, and prioritizing different layers of clothing correctly.

---

## Features

- **Ped Model Management** — Safe network/client loading of custom and default ped models.
- **Outfit Persistence** — Save and load player-specific outfits persistently via database.
- **Crew Outfits** — Easily apply and replace crew-based clothing.
- **Priority System** — Logic to determine the correct application priority when multiple outfit sources exist.
- **Client Application Logic** — Reliable client-side scripts to ensure clothing changes apply flawlessly during state changes, spawns, and free roam.

---

## Dependencies

| Resource | Version | Role |
|---|---|---|
| `spz-lib` | 1.0.0+ | Callbacks, notify, logger |
| `spz-core` | 1.0.0+ | Spawns, state machine |
| `oxmysql` | 2.0.0+ | Outfit persistence |

---

<div align="center">

*Part of the [SPiceZ-Core](https://github.com/SPiceZ-Core) ecosystem*

**[Docs](https://github.com/SPiceZ-Core/spz-docs) · [Discord](https://discord.gg/) · [Issues](https://github.com/SPiceZ-Core/spz-appearance/issues)**

</div>
