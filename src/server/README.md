# Server-Side Logic (`src/server`)

This directory corresponds to `ServerScriptService/Server`.
It contains all authoritative game logic.

## Structure
- **Services**: Singleton modules that handle core game mechanics (e.g., `CoinService`, `CombatService`).
- **Managers**: Scripts that coordinate multiple services or handle game lifecycle.
- **Infrastructure**: Setup scripts that initialize the game environment.

## Rules
- **Authority**: The server is the single source of truth.
- **Security**: Never trust data sent from clients via RemoteEvents. Validate everything.
- **Persistence**: Handle DataStore operations safely using `pcall`.
