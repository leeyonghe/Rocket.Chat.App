# Rocket.Chat Desktop App 빌드 스크립트 (PowerShell)
# 사용법: .\scripts\build.ps1 [플랫폼] [옵션]

param(
    [Parameter(Position=0)]
    [ValidateSet("all", "mac", "win", "linux", "dev")]
    [string]$Platform = "dev",

    [switch]$Clean,
    [switch]$Watch,
    [switch]$Release,
    [switch]$Help
)

# 스크립트 중단 시 오류 처리
$ErrorActionPreference = "Stop"

# 색상 정의
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    White = "White"
}

# 로그 함수
function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
}

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
}

# 도움말 함수
function Show-Help {
    Write-Host "Rocket.Chat Desktop App 빌드 스크립트 (PowerShell)" -ForegroundColor $Colors.White
    Write-Host ""
    Write-Host "사용법:" -ForegroundColor $Colors.White
    Write-Host "  .\scripts\build.ps1 [플랫폼] [옵션]" -ForegroundColor $Colors.White
    Write-Host ""
    Write-Host "플랫폼:" -ForegroundColor $Colors.White
    Write-Host "  all        - 모든 플랫폼 빌드" -ForegroundColor $Colors.White
    Write-Host "  mac        - macOS 빌드" -ForegroundColor $Colors.White
    Write-Host "  win        - Windows 빌드" -ForegroundColor $Colors.White
    Write-Host "  linux      - Linux 빌드" -ForegroundColor $Colors.White
    Write-Host "  dev        - 개발 모드 빌드" -ForegroundColor $Colors.White
    Write-Host ""
    Write-Host "옵션:" -ForegroundColor $Colors.White
    Write-Host "  -Clean     - 빌드 전 정리" -ForegroundColor $Colors.White
    Write-Host "  -Watch     - 감시 모드" -ForegroundColor $Colors.White
    Write-Host "  -Release   - 릴리스 빌드" -ForegroundColor $Colors.White
    Write-Host "  -Help      - 이 도움말 표시" -ForegroundColor $Colors.White
    Write-Host ""
    Write-Host "예시:" -ForegroundColor $Colors.White
    Write-Host "  .\scripts\build.ps1 all -Clean" -ForegroundColor $Colors.White
    Write-Host "  .\scripts\build.ps1 win -Release" -ForegroundColor $Colors.White
    Write-Host "  .\scripts\build.ps1 dev -Watch" -ForegroundColor $Colors.White
}

# 의존성 확인
function Test-Dependencies {
    Write-LogInfo "의존성 확인 중..."

    # Node.js 확인
    try {
        $nodeVersion = node --version
        if (-not $nodeVersion) {
            throw "Node.js가 설치되지 않았습니다."
        }
        Write-LogInfo "Node.js 버전: $nodeVersion"
    }
    catch {
        Write-LogError "Node.js가 설치되지 않았습니다."
        exit 1
    }

    # Yarn 확인
    try {
        $yarnVersion = yarn --version
        if (-not $yarnVersion) {
            throw "Yarn이 설치되지 않았습니다."
        }
        Write-LogInfo "Yarn 버전: $yarnVersion"
    }
    catch {
        Write-LogError "Yarn이 설치되지 않았습니다."
        exit 1
    }

    # Node.js 버전 확인 (22.13.1 이상 필요)
    $nodeVersion = $nodeVersion.TrimStart('v')
    $requiredVersion = "22.13.1"

    if ([System.Version]$nodeVersion -lt [System.Version]$requiredVersion) {
        Write-LogWarning "Node.js 버전이 권장 버전($requiredVersion)보다 낮습니다. 현재 버전: $nodeVersion"
    }

    Write-LogSuccess "의존성 확인 완료"
}

# 정리 함수
function Clear-Build {
    Write-LogInfo "빌드 디렉토리 정리 중..."
    try {
        yarn clean
        Write-LogSuccess "정리 완료"
    }
    catch {
        Write-LogError "정리 중 오류가 발생했습니다: $_"
        exit 1
    }
}

# 의존성 설치
function Install-Dependencies {
    Write-LogInfo "의존성 설치 중..."
    try {
        yarn install
        Write-LogSuccess "의존성 설치 완료"
    }
    catch {
        Write-LogError "의존성 설치 중 오류가 발생했습니다: $_"
        exit 1
    }
}

# 개발 모드 빌드
function Build-Dev {
    Write-LogInfo "개발 모드 빌드 시작..."

    try {
        if ($Watch) {
            Write-LogInfo "감시 모드로 빌드 중..."
            yarn build:watch
        } else {
            yarn build
        }
        Write-LogSuccess "개발 모드 빌드 완료"
    }
    catch {
        Write-LogError "개발 모드 빌드 중 오류가 발생했습니다: $_"
        exit 1
    }
}

# macOS 빌드
function Build-Mac {
    Write-LogInfo "macOS 빌드 시작..."

    if ($Clean) {
        Clear-Build
    }

    try {
        yarn build-mac
        Write-LogSuccess "macOS 빌드 완료"
    }
    catch {
        Write-LogError "macOS 빌드 중 오류가 발생했습니다: $_"
        exit 1
    }
}

# Windows 빌드
function Build-Windows {
    Write-LogInfo "Windows 빌드 시작..."

    if ($Clean) {
        Clear-Build
    }

    try {
        yarn build-win
        Write-LogSuccess "Windows 빌드 완료"
    }
    catch {
        Write-LogError "Windows 빌드 중 오류가 발생했습니다: $_"
        exit 1
    }
}

# Linux 빌드
function Build-Linux {
    Write-LogInfo "Linux 빌드 시작..."

    if ($Clean) {
        Clear-Build
    }

    try {
        yarn build-linux
        Write-LogSuccess "Linux 빌드 완료"
    }
    catch {
        Write-LogError "Linux 빌드 중 오류가 발생했습니다: $_"
        exit 1
    }
}

# 릴리스 빌드
function Build-Release {
    Write-LogInfo "릴리스 빌드 시작..."

    if ($Clean) {
        Clear-Build
    }

    try {
        yarn release
        Write-LogSuccess "릴리스 빌드 완료"
    }
    catch {
        Write-LogError "릴리스 빌드 중 오류가 발생했습니다: $_"
        exit 1
    }
}

# 모든 플랫폼 빌드
function Build-All {
    Write-LogInfo "모든 플랫폼 빌드 시작..."

    if ($Clean) {
        Clear-Build
    }

    # 현재 플랫폼 확인
    $currentPlatform = [System.Environment]::OSVersion.Platform

    switch ($currentPlatform) {
        "Unix" {
            if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX)) {
                Write-LogInfo "macOS에서 실행 중 - macOS 빌드만 수행"
                Build-Mac
            } else {
                Write-LogInfo "Linux에서 실행 중 - Linux 빌드만 수행"
                Build-Linux
            }
        }
        "Win32NT" {
            Write-LogInfo "Windows에서 실행 중 - Windows 빌드만 수행"
            Build-Windows
        }
        default {
            Write-LogWarning "알 수 없는 플랫폼: $currentPlatform"
            Write-LogInfo "기본 빌드 수행"
            yarn build
        }
    }

    Write-LogSuccess "모든 플랫폼 빌드 완료"
}

# 메인 함수
function Main {
    # 도움말 표시
    if ($Help) {
        Show-Help
        return
    }

    Write-LogInfo "빌드 시작: 플랫폼=$Platform, 정리=$Clean, 감시=$Watch, 릴리스=$Release"

    # 의존성 확인
    Test-Dependencies

    # 의존성 설치 (필요한 경우)
    if (-not (Test-Path "node_modules")) {
        Install-Dependencies
    }

    # 플랫폼별 빌드 실행
    switch ($Platform) {
        "all" {
            Build-All
        }
        "mac" {
            Build-Mac
        }
        "win" {
            Build-Windows
        }
        "linux" {
            Build-Linux
        }
        "dev" {
            if ($Release) {
                Build-Release
            } else {
                Build-Dev
            }
        }
        default {
            Write-LogError "알 수 없는 플랫폼: $Platform"
            exit 1
        }
    }

    Write-LogSuccess "빌드 프로세스 완료!"
}

# 스크립트 실행
try {
    Main
}
catch {
    Write-LogError "예상치 못한 오류가 발생했습니다: $_"
    exit 1
}
