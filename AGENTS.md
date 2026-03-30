# Agent Guide for EXCategory Data Saver

This document provides essential information for AI agents working on the EXCategory Data Saver project.

## Project Overview
The project consists of a **Flutter mobile application** (frontend) and a **Python Flask backend**. It's designed to save results for EX-500 and EX-A category ship models.

## Backend (ServerSide/)
- **Technology:** Python, Flask, Flask-SQLAlchemy.
- **Database:** SQLite, usually located at `ServerSide/instance/database.db`.
- **Health Check:** `/Heath` (Note the specific casing).
- **Default Server:** `10.0.0.19:5051`.
- **Installation Tip:** When installing Python packages on the server, use `python3 -m pip install <package> --break-system-packages`.
- **Main Logic:** `ServerSide/DataColector.py`.

## Frontend (lib/)
- **Technology:** Flutter (Stable channel).
- **Build Environment:** Java 17, Gradle 8.6.
- **Local Storage:** `shared_preferences` managed via `LocalDataManager` and specific handlers in `lib/Services/LocalDatabaseService/`.
- **Configuration:** `ConfigProvider` (lib/Services/ConfigProvider.dart) handles UI customizations like titles and theme colors.

## Data Models & Field Mappings
Important: Field names must match exactly between the frontend models and backend database/JSON.

### Boat
- Local: `bID` (Local ID), `dbID` (Server ID), `name`, `boatClass`, `timerSeconds`, `timerExplanation`.
- Storage Format: 5-field semicolon-separated string: `name;boatClass;dbID;timerSeconds;timerExplanation`.

### Race
- Local: `rcid` (Local ID), `drcid` (Server ID), `name`, `date`.

### Run
- Local: `rid` (Local ID), `drid` (Server ID), `boatID`, `rcid`, `scopeTo`, `directionTo`, `hit`, `directionHit`, `intendedPartOfGate`, `dateTime`.
- Backend DB: `hitDirection` (Maps to `directionHit` in JSON/Frontend).
- Date format: ISO 8601.
- Storage Format: 10-field semicolon-separated string: `rid;boatID;scopeTo;directionTo;hit;directionHit;drid;rcid;intendedPartOfGate;dateTime`.

## Synchronization Logic (`lib/Services/OnlineSaver.dart`)
- **Endpoints:** `/boats/sync`, `/runs/sync`, `/races/sync`.
- **Behavior:** Bidirectional. The server returns the full set of records.
- **ID Mapping:**
    - When sending to server, local IDs (`bID`, `rcid`) are mapped to server IDs (`dbID`, `drcid`) in the `Run` records.
    - When receiving from server, if no local match is found, local IDs are set to `0`. `LocalDataManager` then assigns a new local ID and updates the corresponding counter in `SharedPreferences` (`boatNums`, `raceNums`, `runNums`).
- **Standardization:**
    - Use `scopeTo` and `directionTo` (avoid typos like `scopeToo`).
    - Use `intendedPartOfGate` (avoid typo `intentedPartOfGate`).

## Testing
- Smoke test: `test/widget_test.dart` verifies the app title.
- Run tests using `flutter test`.

## Important Files
- `lib/Services/OnlineSaver.dart`: Sync logic.
- `lib/Services/LocalDatabaseService/LocalDataManager.dart`: Data persistence entry point.
- `ServerSide/DataColector.py`: Flask API and Database models.
- `lib/Services/ConfigProvider.dart`: UI configuration.
