# Only The Strong Survive - 개발자 가이드

이 문서는 프로젝트의 아키텍처, 코드 구조, 그리고 주요 모듈의 사용법을 설명합니다.  
공동 개발자는 작업을 시작하기 전에 반드시 이 문서를 숙지해주세요.

---

## 1. 시작하기 (Getting Started)

이 프로젝트는 **Rojo**를 사용하여 파일 시스템 기반으로 관리됩니다.

### 필수 도구
- [VS Code](https://code.visualstudio.com/)
- [Rojo CLI](https://rojo.space/) (v7.0.0+)
- **Roblox Studio**

### 프로젝트 실행
1. 저장소를 클론합니다.
2. 터미널에서 다음 명령어를 실행하여 로컬 서버를 엽니다.
   ```bash
   rojo serve
   ```
3. Roblox Studio를 열고 **Rojo 플러그인**을 통해 연결합니다.
4. (선택 사항) 빌드 파일 생성: `rojo build -o game.rbxl`

---

## 2. 프로젝트 아키텍처 (Architecture)

이 프로젝트는 **데이터(Data), 로직(Logic), 뷰(View)**가 분리된 모듈형 구조를 따릅니다.

### 디렉토리 구조 (`src/`)
| 경로 | 설명 | Roblox 서비스 매핑 |
|------|------|-------------------|
| `shared/` | 클라이언트와 서버가 공유하는 설정(`Config`) 및 유틸리티 | `ReplicatedStorage/Shared` |
| `server/` | 서버 측 로직(`Service`), 보안이 필요한 코드 | `ServerScriptService/Server` |
| `client/` | 클라이언트 측 로직(`Controller`), UI, 시각 효과 | `StarterPlayerScripts/Client` |

### 코딩 패턴 (Design Pattern)
- **Service (Server)**: 게임의 핵심 로직을 담당하는 싱글톤 모듈입니다. (예: `CoinService`)
- **Controller (Client)**: 사용자 입력 및 로컬 로직을 담당하는 싱글톤 모듈입니다. (예: `CombatController`)
- **Config (Shared)**: 모든 상수는 코드 하드코딩을 피하고 `Config` 파일에서 관리합니다.

---

## 3. 코딩 컨벤션 (Coding Standards)

1. **Strict Typing (`--!strict`)**: 모든 스크립트 상단에 `--!strict`를 명시하고 타입을 정의해야 합니다.
2. **CollectionService 사용**: `Workspace`에 있는 파트 안에 스크립트를 넣지 마십시오. 대신 `Tag`를 사용하여 `Service`나 `Visuals` 스크립트에서 일괄 제어합니다.
3. **Magic Numbers 금지**: 숫자나 하드코딩된 문자열은 반드시 `src/shared/*Config.lua`에 정의해서 사용하세요.

---

## 4. 모듈별 사용 가이드 (Module Guide)

### ⚔️ 전투 시스템 (Combat)
*   **파일**: `server/CombatService.lua`, `client/CombatController.lua`, `shared/CombatConfig.lua`
*   **구조**: 
    1.  클라이언트(`InputHandler`)가 클릭 감지 → `CombatController:Attack()` 호출.
    2.  애니메이션 재생 후 서버에 `RemoteEvent` 전송.
    3.  서버(`NetworkHandler`)가 요청 검증 후 `CombatService:ApplyDamage()` 실행.
*   **수정 방법**:
    *   **공격력/쿨타임 변경**: `src/shared/CombatConfig.lua` 수정.
    *   **타격 이펙트 변경**: `CombatService.CreateVisualEffect` 함수 수정.

### 💰 코인 시스템 (Coin)
*   **파일**: `server/CoinService.lua`, `client/CoinVisuals.client.lua`, `shared/CoinConfig.lua`
*   **작동 원리**:
    *   **스폰**: `CoinConfig.SPAWN_AREAS`에 정의된 구역에 서버가 자동으로 코인을 생성합니다.
    *   **최적화**: 코인의 회전/부유 애니메이션은 서버가 아닌 `client/CoinVisuals.client.lua`에서 `RunService`를 통해 처리됩니다.
*   **새로운 스폰 구역 추가**:
    `src/shared/CoinConfig.lua`의 `SPAWN_AREAS` 테이블에 다음을 추가:
    ```lua
    {name = "NewArea", minX = 0, maxX = 50, minZ = 0, maxZ = 50, maxCoins = 20}
    ```

### 🌀 포탈 시스템 (Portal)
*   **파일**: `server/PortalService.lua`, `client/PortalVisuals.client.lua`
*   **작동 원리**:
    *   `PortalConfig`에 정의된 위치에 포탈이 자동 생성됩니다.
    *   포탈에 닿으면 `LobbyPortal` 위치로 순간이동합니다.
*   **주의 사항**: 
    *   Workspace에 `LobbyPortal`이라는 이름의 파트가 반드시 존재해야 합니다 (인프라 스크립트가 자동 생성함).

### 🎵 배경 음악 (Music)
*   **파일**: `client/MusicController.client.lua`
*   **특징**:
    *   클라이언트에서 실행되므로 서버 부하가 없습니다.
    *   게임 시작 시 부드러운 **Fade-In** 효과가 적용됩니다.
*   **음악 변경**: `src/shared/MusicConfig.lua`의 `BGM_ID`를 변경하세요.

---

## 5. 인프라 및 자동화 (Infrastructure)
*   **파일**: `server/Infrastructure.server.lua`
*   **역할**: 게임 실행 시 필요한 필수 에셋(`RemoteEvent`, `Coin/Portal Template`)이 없으면 자동으로 생성해줍니다.
*   **GameManager**: `server/GameManager.server.lua`는 게임의 진입점(Entry Point)입니다. 모든 서비스(`StartAutoSpawner`)를 여기서 초기화합니다.

---

## 6. 새로운 기능 추가 시 워크플로우

새로운 기능을 추가할 때는 다음 순서를 따라주세요:

1.  **Config 생성**: `src/shared/NewFeatureConfig.lua` 생성.
2.  **Service/Controller 생성**: 비즈니스 로직 작성.
3.  **Manager 등록**: `GameManager.server.lua`에서 해당 서비스를 `require` 및 초기화.
4.  **테스트**: Rojo 동기화 후 스튜디오에서 테스트.
