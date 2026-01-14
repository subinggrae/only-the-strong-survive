# 클라이언트 측 로직 (`src/client`)

이 디렉토리는 `StarterPlayer/StarterPlayerScripts`에 매핑됩니다.
플레이어 기기에서 실행되는 모든 코드를 포함합니다.

## 구조
- **Controllers**: 특정 클라이언트 시스템을 처리하는 싱글톤 모듈 (예: `CombatController`, `MusicController`).
- **Visuals**: 렌더링 효과, 파티클, UI 애니메이션을 담당하는 스크립트.
- **UI**: GUI 상호작용을 처리하는 모듈.

## 규칙
- **서버 접근 불가**: 여기 있는 코드는 `ServerScriptService`나 `ServerStorage`에 접근할 수 없습니다.
- **FilteringEnabled**: 클라이언트 입력을 신뢰하지 마십시오. 항상 서버에서 작업을 검증하세요.
- **성능**: 렌더링 루프(`RunService.RenderStepped`)를 최적화하세요.
