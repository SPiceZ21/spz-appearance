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

## Customization lock

While the editor is open the ped **is** the preview: every drawable on it is something the
player is trying on and has not committed to. Anything that re-applies the saved outfit in
that window fights the player directly — they pick a jacket and the ped snaps back.

Several things push outfits without knowing the editor is up: the `crewId` statebag handler
(which fires ~500 ms after identity writes the profile statebags, i.e. exactly when
character creation opens the editor), `SPZ:crewChanged`, and crew propagation echoing a
save back to the owner who just made it. `fivem-appearance` re-asserts its preview every
frame, so the two overwrote each other continuously — a flicker rather than a clean revert.

`client/main.lua` holds one flag for the duration. Every apply path checks it —
`SPZ:applyOutfit`, `SPZ:applyCrewOutfit` and the `ReapplyMyOutfit` export — and re-checks
after the server round-trip, since the editor can open while a callback is in flight.
Pushes that arrive during customization are **dropped, not queued**: whatever the player
saves is newer than anything that arrived while they were choosing.

Exposed as `IsCustomizing` for anything else that needs to keep its hands off the ped.

## Exports

| Side | Exports |
|---|---|
| Server | `PropagateCrewOutfit` · `GetCrewOutfit` · `ClearCrewOutfit` · `GetOutfitForPlayer` |
| Client | `ApplyFullAppearance` · `ApplyOutfitToLocalPed` · `CaptureCurrentOutfit` · `SaveOutfit` · `GetSavedOutfit` · `ReapplyMyOutfit` · `ResetOutfit` · `IsCustomizing` |

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
