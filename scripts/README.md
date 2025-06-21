# Rocket.Chat Desktop App 빌드 스크립트

이 디렉토리에는 Rocket.Chat Desktop App을 빌드하기 위한 다양한 플랫폼별 스크립트가 포함되어 있습니다.

## 사용 가능한 스크립트

### 1. Bash 스크립트 (Linux/macOS)
- **파일**: `build.sh`
- **사용법**: `./scripts/build.sh [플랫폼] [옵션]`

### 2. Windows 배치 스크립트
- **파일**: `build.bat`
- **사용법**: `scripts\build.bat [플랫폼] [옵션]`

### 3. PowerShell 스크립트 (Windows)
- **파일**: `build.ps1`
- **사용법**: `.\scripts\build.ps1 [플랫폼] [옵션]`

## 플랫폼 옵션

| 플랫폼 | 설명 |
|--------|------|
| `all` | 모든 플랫폼 빌드 (현재 OS에 맞는 것만) |
| `mac` | macOS 빌드 |
| `win` | Windows 빌드 |
| `linux` | Linux 빌드 |
| `dev` | 개발 모드 빌드 (기본값) |

## 빌드 옵션

| 옵션 | 설명 |
|------|------|
| `--clean` / `-Clean` | 빌드 전 정리 수행 |
| `--watch` / `-Watch` | 감시 모드로 빌드 |
| `--release` / `-Release` | 릴리스 빌드 |
| `--help` / `-Help` | 도움말 표시 |

## 사용 예시

### 기본 개발 빌드
```bash
# Linux/macOS
./scripts/build.sh

# Windows (배치)
scripts\build.bat

# Windows (PowerShell)
.\scripts\build.ps1
```

### 특정 플랫폼 빌드
```bash
# macOS 빌드
./scripts/build.sh mac

# Windows 빌드
./scripts/build.sh win

# Linux 빌드
./scripts/build.sh linux
```

### 정리 후 빌드
```bash
# 정리 후 개발 빌드
./scripts/build.sh dev --clean

# 정리 후 macOS 릴리스 빌드
./scripts/build.sh mac --clean --release
```

### 감시 모드
```bash
# 개발 모드 감시
./scripts/build.sh dev --watch
```

## 사전 요구사항

빌드를 실행하기 전에 다음이 설치되어 있어야 합니다:

1. **Node.js** (버전 22.13.1 이상)
2. **Yarn** (버전 4.0.2 이상)

### 설치 확인
```bash
node --version
yarn --version
```

## 빌드 프로세스

각 스크립트는 다음 단계를 수행합니다:

1. **의존성 확인**: Node.js와 Yarn이 설치되어 있는지 확인
2. **의존성 설치**: `node_modules`가 없으면 자동으로 설치
3. **정리**: `--clean` 옵션이 지정된 경우 빌드 디렉토리 정리
4. **빌드**: 지정된 플랫폼에 맞는 빌드 실행

## 빌드 결과물

빌드가 완료되면 다음 위치에 결과물이 생성됩니다:

- **개발 빌드**: `app/` 디렉토리
- **배포 빌드**: `dist/` 디렉토리

## 문제 해결

### 일반적인 오류

1. **Node.js 버전 오류**
   ```
   [WARNING] Node.js 버전이 권장 버전(22.13.1)보다 낮습니다.
   ```
   - 해결: Node.js를 최신 버전으로 업데이트

2. **Yarn 설치 오류**
   ```
   [ERROR] Yarn이 설치되지 않았습니다.
   ```
   - 해결: `npm install -g yarn` 실행

3. **권한 오류 (Linux/macOS)**
   ```
   Permission denied
   ```
   - 해결: `chmod +x scripts/build.sh` 실행

### 플랫폼별 문제

#### Windows
- PowerShell 실행 정책 오류가 발생하면:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

#### macOS
- Xcode Command Line Tools가 필요할 수 있습니다:
  ```bash
  xcode-select --install
  ```

#### Linux
- 추가 패키지가 필요할 수 있습니다:
  ```bash
  # Ubuntu/Debian
  sudo apt-get install build-essential libevas-dev libxss-dev
  
  # Fedora
  sudo dnf install libX11 libXScrnSaver-devel gcc-c++
  ```

## 스크립트 커스터마이징

스크립트를 수정하여 추가 기능을 구현할 수 있습니다:

- 환경 변수 설정
- 추가 빌드 단계
- 배포 자동화
- 테스트 실행

## 지원

문제가 발생하면 다음을 확인하세요:

1. [Rocket.Chat Desktop App README](../README.md)
2. [GitHub Issues](https://github.com/RocketChat/Rocket.Chat.Electron/issues)
3. [Rocket.Chat Community](https://forums.rocket.chat/) 
