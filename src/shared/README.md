# Shared Modules (`src/shared`)

This directory corresponds to `ReplicatedStorage/Shared`.
It contains code and data accessible by both Client and Server.

## Content
- **Config**: Configuration tables (constants) for game balance (e.g., `CombatConfig`, `CoinConfig`).
- **Utils**: Helper functions used across the project.
- **Types**: Luau type definitions.

## Rules
- **Side-Effect Free**: Modules here should generally be pure functions or data holders.
- **Replication**: Remember that changes to tables here by the Client are NOT replicated to the Server (and vice versa).
