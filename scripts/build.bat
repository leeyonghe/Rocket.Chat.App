@echo off
setlocal enabledelayedexpansion

REM Rocket.Chat Desktop App 빌드 스크립트 (Windows)
REM 사용법: scripts\build.bat [플랫폼] [옵션]

set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."

REM 색상 정의 (Windows 10+)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM 로그 함수
:log_info
echo %BLUE%[INFO]%NC% %~1
goto :eof

:log_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:log_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:log_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM 도움말 함수
:show_help
echo Rocket.Chat Desktop App 빌드 스크립트 (Windows)
echo.
echo 사용법:
echo   %~nx0 [플랫폼] [옵션]
echo.
echo 플랫폼:
echo   all        - 모든 플랫폼 빌드
echo   mac        - macOS 빌드
echo   win        - Windows 빌드
echo   linux      - Linux 빌드
echo   dev        - 개발 모드 빌드
echo.
echo 옵션:
echo   --clean    - 빌드 전 정리
echo   --watch    - 감시 모드
echo   --release  - 릴리스 빌드
echo   --help     - 이 도움말 표시
echo.
echo 예시:
echo   %~nx0 all --clean
echo   %~nx0 win --release
echo   %~nx0 dev --watch
goto :eof

REM 의존성 확인
:check_dependencies
call :log_info "의존성 확인 중..."

where node >nul 2>&1
if %errorlevel% neq 0 (
    call :log_error "Node.js가 설치되지 않았습니다."
    exit /b 1
)

where yarn >nul 2>&1
if %errorlevel% neq 0 (
    call :log_error "Yarn이 설치되지 않았습니다."
    exit /b 1
)

REM Node.js 버전 확인
for /f "tokens=*" %%i in ('node -v') do set "NODE_VERSION=%%i"
set "NODE_VERSION=!NODE_VERSION:v=!"

REM 간단한 버전 비교 (22.13.1 이상 필요)
for /f "tokens=1,2 delims=." %%a in ("!NODE_VERSION!") do (
    set "MAJOR=%%a"
    set "MINOR=%%b"
)

if !MAJOR! lss 22 (
    call :log_warning "Node.js 버전이 권장 버전(22.13.1)보다 낮습니다. 현재 버전: !NODE_VERSION!"
)

call :log_success "의존성 확인 완료"
goto :eof

REM 정리 함수
:clean_build
call :log_info "빌드 디렉토리 정리 중..."
cd /d "%PROJECT_DIR%"
call yarn clean
call :log_success "정리 완료"
goto :eof

REM 의존성 설치
:install_dependencies
call :log_info "의존성 설치 중..."
cd /d "%PROJECT_DIR%"
call yarn install
call :log_success "의존성 설치 완료"
goto :eof

REM 개발 모드 빌드
:build_dev
call :log_info "개발 모드 빌드 시작..."

if "%WATCH_MODE%"=="true" (
    call :log_info "감시 모드로 빌드 중..."
    call yarn build:watch
) else (
    call yarn build
)

call :log_success "개발 모드 빌드 완료"
goto :eof

REM macOS 빌드
:build_mac
call :log_info "macOS 빌드 시작..."

if "%CLEAN_BUILD%"=="true" (
    call :clean_build
)

call yarn build-mac
call :log_success "macOS 빌드 완료"
goto :eof

REM Windows 빌드
:build_windows
call :log_info "Windows 빌드 시작..."

if "%CLEAN_BUILD%"=="true" (
    call :clean_build
)

call yarn build-win
call :log_success "Windows 빌드 완료"
goto :eof

REM Linux 빌드
:build_linux
call :log_info "Linux 빌드 시작..."

if "%CLEAN_BUILD%"=="true" (
    call :clean_build
)

call yarn build-linux
call :log_success "Linux 빌드 완료"
goto :eof

REM 릴리스 빌드
:build_release
call :log_info "릴리스 빌드 시작..."

if "%CLEAN_BUILD%"=="true" (
    call :clean_build
)

call yarn release
call :log_success "릴리스 빌드 완료"
goto :eof

REM 모든 플랫폼 빌드
:build_all
call :log_info "모든 플랫폼 빌드 시작..."

if "%CLEAN_BUILD%"=="true" (
    call :clean_build
)

REM Windows에서 실행 중이므로 Windows 빌드만 수행
call :log_info "Windows에서 실행 중 - Windows 빌드만 수행"
call :build_windows

call :log_success "모든 플랫폼 빌드 완료"
goto :eof

REM 메인 함수
:main
set "PLATFORM="
set "CLEAN_BUILD=false"
set "WATCH_MODE=false"
set "RELEASE_MODE=false"

REM 인수 파싱
:parse_args
if "%~1"=="" goto :end_parse

if "%~1"=="all" (
    set "PLATFORM=%~1"
    shift
    goto :parse_args
)
if "%~1"=="mac" (
    set "PLATFORM=%~1"
    shift
    goto :parse_args
)
if "%~1"=="win" (
    set "PLATFORM=%~1"
    shift
    goto :parse_args
)
if "%~1"=="linux" (
    set "PLATFORM=%~1"
    shift
    goto :parse_args
)
if "%~1"=="dev" (
    set "PLATFORM=%~1"
    shift
    goto :parse_args
)
if "%~1"=="--clean" (
    set "CLEAN_BUILD=true"
    shift
    goto :parse_args
)
if "%~1"=="--watch" (
    set "WATCH_MODE=true"
    shift
    goto :parse_args
)
if "%~1"=="--release" (
    set "RELEASE_MODE=true"
    shift
    goto :parse_args
)
if "%~1"=="--help" (
    call :show_help
    exit /b 0
)
if "%~1"=="-h" (
    call :show_help
    exit /b 0
)

call :log_error "알 수 없는 옵션: %~1"
call :show_help
exit /b 1

:end_parse

REM 플랫폼이 지정되지 않은 경우 기본값
if "%PLATFORM%"=="" set "PLATFORM=dev"

call :log_info "빌드 시작: 플랫폼=%PLATFORM%, 정리=%CLEAN_BUILD%, 감시=%WATCH_MODE%, 릴리스=%RELEASE_MODE%"

REM 의존성 확인
call :check_dependencies
if %errorlevel% neq 0 exit /b %errorlevel%

REM 의존성 설치 (필요한 경우)
if not exist "%PROJECT_DIR%\node_modules" (
    call :install_dependencies
    if %errorlevel% neq 0 exit /b %errorlevel%
)

REM 플랫폼별 빌드 실행
if "%PLATFORM%"=="all" (
    call :build_all
) else if "%PLATFORM%"=="mac" (
    call :build_mac
) else if "%PLATFORM%"=="win" (
    call :build_windows
) else if "%PLATFORM%"=="linux" (
    call :build_linux
) else if "%PLATFORM%"=="dev" (
    if "%RELEASE_MODE%"=="true" (
        call :build_release
    ) else (
        call :build_dev
    )
) else (
    call :log_error "알 수 없는 플랫폼: %PLATFORM%"
    exit /b 1
)

call :log_success "빌드 프로세스 완료!"
goto :eof

REM 스크립트 실행
cd /d "%SCRIPT_DIR%"
call :main %*
