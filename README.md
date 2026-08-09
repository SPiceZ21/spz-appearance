# spz-appearance

> MP Freemode ped, personal outfits, crew uniforms · `v2.0.0`

## Overview

`spz-appearance` owns how players look. It applies the MP Freemode ped, persists saved
outfits per player, propagates crew uniforms, and reapplies the correct look after spawns,
state changes and respawns. It sits on top of `fivem-appearance`, which supplies the
editor UI and the underlying component API.

## Structure

| Side | File | Purpose |
|---|---|---|
| Shared | `config.lua` | Appearance configuration |
| Server | `server/main.lua` | Entry point, appearance persistence |
| Server | `server/outfits.lua` | Personal outfit storage |
| Server | `server/crew_outfit.lua` | Crew uniform assignment and propagation |
| Server | `server/autoshot.lua` | Automatic player headshot capture |
| Client | `client/main.lua` | Ped model loading and appearance application |
| Client | `client/outfits.lua` | Outfit apply / capture / reset |
| Client | `client/commands.lua` | Player commands |
| Client | `client/autoshot.lua` | Client half of headshot capture |

## Exports

| Side | Exports |
|---|---|
| Server | `PropagateCrewOutfit` · `GetCrewOutfit` · `ClearCrewOutfit` · `GetOutfitForPlayer` |
| Client | `ApplyFullAppearance` · `ApplyOutfitToLocalPed` · `CaptureCurrentOutfit` · `SaveOutfit` · `GetSavedOutfit` · `ReapplyMyOutfit` · `ResetOutfit` |

## Commands

| Command | Effect |
|---|---|
| `/appearance` | Open the appearance editor |
| `/saveoutfit` | Save the current outfit |
| `/resetoutfit` | Restore the default outfit |
| `/autoshot` | Trigger a headshot capture |

## Dependencies

`ox_lib` · `spz-core` · `spz-identity` · `fivem-appearance` · `oxmysql` · `screenshot-basic`

---

Part of [SPiceZ-Core](../README.md) · GPL-3.0
