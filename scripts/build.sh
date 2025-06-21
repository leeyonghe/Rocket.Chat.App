#!/bin/bash

# Rocket.Chat Desktop App 빌드 스크립트
# 사용법: ./scripts/build.sh [플랫폼] [옵션]

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로그 함수
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 도움말 함수
show_help() {
    echo "Rocket.Chat Desktop App 빌드 스크립트"
    echo ""
    echo "사용법:"
    echo "  $0 [플랫폼] [옵션]"
    echo ""
    echo "플랫폼:"
    echo "  all        - 모든 플랫폼 빌드"
    echo "  mac        - macOS 빌드"
    echo "  win        - Windows 빌드"
    echo "  linux      - Linux 빌드"
    echo "  dev        - 개발 모드 빌드"
    echo ""
    echo "옵션:"
    echo "  --clean    - 빌드 전 정리"
    echo "  --watch    - 감시 모드"
    echo "  --release  - 릴리스 빌드"
    echo "  --help     - 이 도움말 표시"
    echo ""
    echo "예시:"
    echo "  $0 all --clean"
    echo "  $0 mac --release"
    echo "  $0 dev --watch"
}

# 의존성 확인
check_dependencies() {
    log_info "의존성 확인 중..."

    if ! command -v node &> /dev/null; then
        log_error "Node.js가 설치되지 않았습니다."
        exit 1
    fi

    if ! command -v yarn &> /dev/null; then
        log_error "Yarn이 설치되지 않았습니다."
        exit 1
    fi

    # Node.js 버전 확인
    NODE_VERSION=$(node -v | cut -d'v' -f2)
    REQUIRED_VERSION="22.13.1"

    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
        log_warning "Node.js 버전이 권장 버전($REQUIRED_VERSION)보다 낮습니다. 현재 버전: $NODE_VERSION"
    fi

    log_success "의존성 확인 완료"
}

# 정리 함수
clean_build() {
    log_info "빌드 디렉토리 정리 중..."
    yarn clean
    log_success "정리 완료"
}

# 의존성 설치
install_dependencies() {
    log_info "의존성 설치 중..."
    yarn install
    log_success "의존성 설치 완료"
}

# 개발 모드 빌드
build_dev() {
    log_info "개발 모드 빌드 시작..."

    if [ "$WATCH_MODE" = true ]; then
        log_info "감시 모드로 빌드 중..."
        yarn build:watch
    else
        yarn build
    fi

    log_success "개발 모드 빌드 완료"
}

# macOS 빌드
build_mac() {
    log_info "macOS 빌드 시작..."

    if [ "$CLEAN_BUILD" = true ]; then
        clean_build
    fi

    yarn build-mac

    log_success "macOS 빌드 완료"
}

# Windows 빌드
build_windows() {
    log_info "Windows 빌드 시작..."

    if [ "$CLEAN_BUILD" = true ]; then
        clean_build
    fi

    yarn build-win

    log_success "Windows 빌드 완료"
}

# Linux 빌드
build_linux() {
    log_info "Linux 빌드 시작..."

    if [ "$CLEAN_BUILD" = true ]; then
        clean_build
    fi

    yarn build-linux

    log_success "Linux 빌드 완료"
}

# 릴리스 빌드
build_release() {
    log_info "릴리스 빌드 시작..."

    if [ "$CLEAN_BUILD" = true ]; then
        clean_build
    fi

    yarn release

    log_success "릴리스 빌드 완료"
}

# 모든 플랫폼 빌드
build_all() {
    log_info "모든 플랫폼 빌드 시작..."

    if [ "$CLEAN_BUILD" = true ]; then
        clean_build
    fi

    # 현재 플랫폼 확인
    PLATFORM=$(uname -s)

    case $PLATFORM in
        Darwin*)
            log_info "macOS에서 실행 중 - macOS 빌드만 수행"
            build_mac
            ;;
        Linux*)
            log_info "Linux에서 실행 중 - Linux 빌드만 수행"
            build_linux
            ;;
        MINGW*|MSYS*|CYGWIN*)
            log_info "Windows에서 실행 중 - Windows 빌드만 수행"
            build_windows
            ;;
        *)
            log_warning "알 수 없는 플랫폼: $PLATFORM"
            log_info "기본 빌드 수행"
            yarn build
            ;;
    esac

    log_success "모든 플랫폼 빌드 완료"
}

# 메인 함수
main() {
    PLATFORM=""
    CLEAN_BUILD=false
    WATCH_MODE=false
    RELEASE_MODE=false

    # 인수 파싱
    while [[ $# -gt 0 ]]; do
        case $1 in
            all|mac|win|linux|dev)
                PLATFORM="$1"
                shift
                ;;
            --clean)
                CLEAN_BUILD=true
                shift
                ;;
            --watch)
                WATCH_MODE=true
                shift
                ;;
            --release)
                RELEASE_MODE=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "알 수 없는 옵션: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # 플랫폼이 지정되지 않은 경우 기본값
    if [ -z "$PLATFORM" ]; then
        PLATFORM="dev"
    fi

    log_info "빌드 시작: 플랫폼=$PLATFORM, 정리=$CLEAN_BUILD, 감시=$WATCH_MODE, 릴리스=$RELEASE_MODE"

    # 의존성 확인
    check_dependencies

    # 의존성 설치 (필요한 경우)
    if [ ! -d "node_modules" ]; then
        install_dependencies
    fi

    # 플랫폼별 빌드 실행
    case $PLATFORM in
        all)
            build_all
            ;;
        mac)
            build_mac
            ;;
        win)
            build_windows
            ;;
        linux)
            build_linux
            ;;
        dev)
            if [ "$RELEASE_MODE" = true ]; then
                build_release
            else
                build_dev
            fi
            ;;
        *)
            log_error "알 수 없는 플랫폼: $PLATFORM"
            exit 1
            ;;
    esac

    log_success "빌드 프로세스 완료!"
}

# 스크립트 실행
main "$@"
