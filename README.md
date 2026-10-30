# spz-appearance

> Freemode ped, personal outfits and crew outfits on top of fivem-appearance.

![version](https://img.shields.io/badge/version-1.0.2-ff6200) ![SPiceZ-Core](https://img.shields.io/badge/SPiceZ--Core-beta-18181b)

## Overview

Applies the right look to every player: their saved personal appearance, or their crew's outfit (clothing only) over their own face and hair. Opens the fivem-appearance editor for new characters and on demand.

## Features

- Personal appearance saved per player
- Crew owner's outfit pushed to every member (clothes only)
- Re-applied on spawn, crew change and resource restart
- Customiser lock so nothing overwrites a look being edited

## Requirements

| Resource | Type |
|---|---|
| `ox_lib` | third-party |
| `spz-core` | SPiceZ module |
| `spz-identity` | SPiceZ module |
| `fivem-appearance` | third-party |
| `oxmysql` | third-party |

## Installation

Included in the [txAdmin recipe](https://github.com/SPiceZ21/spz-txrecipe). Manual install:

1. Download `spz-appearance` from GitHub (latest release, or the repository) into your `resources` folder.
2. Add to `server.cfg`, after its requirements:

```cfg
ensure spz-appearance
```

## Commands

| Command | Who | Description |
|---|---|---|
| `/appearance` | player | Open the character editor |
| `/resetoutfit` | player | Drop your saved outfit (falls back to crew/default) |
| `/saveoutfit` | player | Save your current outfit |

## Exports

| Export | Side |
|---|---|
| `IsCustomizing` | client |
| `ReapplyMyOutfit` | client |

```lua
exports["spz-appearance"]:IsCustomizing(...)
```

---

Part of **SPiceZ-Core** — [documentation](https://github.com/SPiceZ21/Docs) · [all modules](https://github.com/SPiceZ21/Docs/blob/main/modules/README.md)
