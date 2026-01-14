# 서버 측 로직 (`src/server`)

이 디렉토리는 `ServerScriptService/Server`에 매핑됩니다.
모든 권한 있는 게임 로직을 포함합니다.

## 구조
- **Services**: 핵심 게임 메커니즘을 처리하는 싱글톤 모듈 (예: `CoinService`, `CombatService`).
- **Managers**: 여러 서비스를 조정하거나 게임 수명 주기를 처리하는 스크립트.
- **Infrastructure**: 게임 환경을 초기화하는 설정 스크립트.

## 규칙
- **권한**: 서버는 유일한 진실 공급원입니다.
- **보안**: RemoteEvents를 통해 클라이언트에서 전송된 데이터를 절대 신뢰하지 마십시오. 모든 것을 검증하세요.
- **지속성**: `pcall`을 사용하여 DataStore 작업을 안전하게 처리하세요.
