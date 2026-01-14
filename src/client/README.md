# Client-Side Logic (`src/client`)

This directory corresponds to `StarterPlayer/StarterPlayerScripts`.
It contains all code that runs on the player's device.

## Structure
- **Controllers**: Singleton modules that handle specific client-side systems (e.g., `CombatController`, `MusicController`).
- **Visuals**: Scripts responsible for rendering effects, particles, and UI animations.
- **UI**: Modules handling GUI interactions.

## Rules
- **No Server Access**: Code here cannot access `ServerScriptService` or `ServerStorage`.
- **FilteringEnabled**: Do not trust client input. Always validate actions on the server.
- **Performance**: Keep render loops (`RunService.RenderStepped`) optimized.
