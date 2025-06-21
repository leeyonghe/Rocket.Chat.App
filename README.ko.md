# Rocket.Chat 데스크톱 앱

[![Travis CI 빌드 상태](https://img.shields.io/travis/RocketChat/Rocket.Chat.Electron/master.svg?logo=travis)](https://travis-ci.org/RocketChat/Rocket.Chat.Electron)
[![AppVeyor 빌드 상태](https://img.shields.io/appveyor/ci/RocketChat/rocket-chat-electron/master.svg?logo=appveyor)](https://ci.appveyor.com/project/RocketChat/rocket-chat-electron)
[![Codacy 배지](https://api.codacy.com/project/badge/Grade/3a87141c0a4442809d9a2bff455e3102)](https://www.codacy.com/app/tassoevan/Rocket.Chat.Electron?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=RocketChat/Rocket.Chat.Electron&amp;utm_campaign=Badge_Grade)
[![프로젝트 의존성](https://david-dm.org/RocketChat/Rocket.Chat.Electron.svg)](https://david-dm.org/RocketChat/Rocket.Chat.Electron)
[![GitHub 전체 릴리스](https://img.shields.io/github/downloads/RocketChat/Rocket.Chat.Electron/total.svg)](https://github.com/RocketChat/Rocket.Chat.Electron/releases/latest)
![GitHub](https://img.shields.io/github/license/RocketChat/Rocket.Chat.Electron.svg)

[Electron][]을 사용하여 macOS, Windows 및 Linux에서 사용 가능한 [Rocket.Chat][] 데스크톱 애플리케이션입니다.

![Rocket.Chat 데스크톱 앱](https://user-images.githubusercontent.com/2263066/91490997-c0bd0c80-e889-11ea-92c7-2cbcc3aabc98.png)

---

## 우리와 함께 참여하세요

### 여러분의 이야기를 공유해주세요
[여러분의 경험][]에 대해 듣고 싶으며, 잠재적으로 우리 [블로그][]에 소개할 수 있습니다.

### 업데이트 구독
한 달에 한 번 마케팅 팀이 제품 릴리스, 회사 관련 주제, 이벤트 및 사용 사례에 대한 뉴스와 함께 이메일 업데이트를 발행합니다. [가입하세요!][]

---

## 다운로드

[릴리스][] 페이지에서 최신 버전을 다운로드할 수 있습니다.

[![Snap Store에서 받기](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/rocketchat-desktop)

## 설치

설치 프로그램을 실행하고 설치 지침을 따르세요.

### Windows 옵션

Windows에서는 `/S` 플래그를 추가하여 자동 설치를 실행할 수 있습니다. 아래 옵션도 추가할 수 있습니다:

- `/S` - 자동 설치
- `/allusers` - 모든 사용자를 위해 설치 (관리자 권한 필요)
- `/currentuser` - 현재 사용자만 설치 (기본값)
- `/disableAutoUpdates` - 자동 업데이트 비활성화

## 개발

### 빠른 시작

사전 요구사항:

- [Git](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Node.js](https://nodejs.org)
- [node-gyp](https://github.com/nodejs/node-gyp#installation)
- [Yarn](http://yarnpkg.com/)이 npm 대신 권장됩니다.

이제 클론하고 앱을 시작하세요:

```sh
git clone https://github.com/RocketChat/Rocket.Chat.Electron.git
cd Rocket.Chat.Electron
yarn
yarn start
```

### 프로젝트 구조

소스는 `src` 폴더에 있습니다. 이 폴더의 모든 것이 `yarn start`로 앱을 실행할 때 자동으로 빌드됩니다.

빌드 프로세스는 `src` 폴더의 모든 것을 컴파일하여 `app` 폴더에 넣습니다. 따라서 빌드가 완료된 후 `app` 폴더에는 완전한 실행 가능한 애플리케이션이 포함됩니다.

### TypeScript

[Rocket.Chat 코드베이스의 진행 중인 변경사항][]에 따라, 유지보수성 문제를 해결하기 위해 앱이 TypeScript 4로 재작성되었습니다.

### 빌드 파이프라인

빌드 프로세스는 [rollup][] 번들러를 기반으로 합니다. 코드에는 세 개의 진입점 파일이 있습니다:

- `src/main.ts`, 전체 애플리케이션을 조율하는 메인 Electron 프로세스에서 실행되는 스크립트;

- `src/rootWindow.ts`, 앱의 메인 창인 *루트 창*의 UI를 렌더링하는 스크립트;

- `src/preload.ts`, 앱과 Rocket.Chat 웹 클라이언트를 렌더링하는 웹뷰를 연결하기 위해 권한 모드에서 실행됩니다.

#### Node.js 모듈 추가

`package.json` 파일에서 `dependencies`와 `devDependencies` 간의 분할을 존중하세요. `dependencies`에 나열된 모듈만 배포 가능한 앱에 포함됩니다.

### 문제 해결

#### node-gyp

[node-gyp readme][]의 설치 지침을 따르세요.

#### Ubuntu

다음 패키지를 설치해야 합니다:

```sh
build-essential
libevas-dev
libxss-dev
```

#### Fedora

다음 패키지를 설치해야 합니다:

```sh
libX11
libXScrnSaver-devel
gcc-c++
```

#### Windows 7

Windows 7에서는 [node-gyp 설치 가이드]의 옵션 2를 따르고 Visual Studio를 설치해야 할 수 있습니다.

### 테스트

#### 단위 테스트

```sh
yarn test
```

[Jest][] 테스트 프레임워크와 [Jest electron runner][]를 사용합니다. `src` 디렉토리에서 `*.(spec|test).{js,ts,tsx}` 글로브 패턴과 일치하는 모든 파일을 검색합니다.

### 릴리스 만들기

앱을 설치 프로그램으로 패키징하려면 다음 명령을 사용하세요:

```sh
yarn release
```

이 명령을 실행하는 운영 체제에 대한 패키징 프로세스가 시작됩니다. 배포 준비가 된 파일은 `dist` 디렉토리에 출력됩니다.

모든 패키징 작업은 [electron-builder][]에 의해 처리됩니다. 많은 [사용자 정의 옵션][]이 있습니다.

## 기본 서버

`servers.json` 파일은 클라이언트가 연결할 서버와 사이드바의 서버 목록을 채울 서버를 정의합니다. 사용자가 처음 앱을 실행할 때 (또는 목록에서 모든 서버가 제거될 때) 추가될 기본 서버 목록을 포함합니다.
파일 구문은 다음과 같습니다:

```json
{
  "Demo Rocket Chat": "https://demo.rocket.chat",
  "Open Rocket Chat": "https://open.rocket.chat"
}
```

### 사전 릴리스 구성

설치 패키지와 함께 `servers.json`을 번들링할 수 있습니다. 파일은 프로젝트 애플리케이션의 루트에 위치해야 합니다 (`package.json`과 같은 레벨). 파일이 발견되면 초기 "서버에 연결" 화면이 건너뛰어지고 정의된 배열의 첫 번째 서버에 연결을 시도하여 사용자를 로그인 화면으로 바로 이동시킵니다. `servers.json`은 다른 서버가 이미 추가되지 않은 경우에만 확인됩니다. 앱을 제거할 때 이전 기본 설정을 제거하지 않아도 다시 트리거되지 않습니다.

### 설치 후 구성

앱 내부에 파일을 번들링할 수 없거나 (또는 원하지 않는 경우) 사용자 기본 설정 폴더에 `servers.json`을 생성하여 패키지된 파일을 덮어쓸 수 있습니다. 파일은 `%APPDATA%/Rocket.Chat/` 폴더 또는 모든 사용자를 위한 설치의 경우 설치 폴더에 위치해야 합니다 (Windows만 해당).

Windows의 경우 전체 경로는 다음과 같습니다:

- `~\Users\<username>\AppData\Roaming\Rocket.Chat\`
- `~\Program Files\Rocket.Chat\Resources\`

macOS의 경우 전체 경로는 다음과 같습니다:

- `~/Users/<username>/Library/Application Support/Rocket.Chat/`
- `/Library/Preferences/Rocket.Chat/`

Linux의 경우 전체 경로는 다음과 같습니다:

- `/home/<username>/.config/Rocket.Chat/`
- `/opt/Rocket.Chat/resources/`

### 재정의된 설정

사용자 기본 설정 폴더에 `overridden-settings.json`을 생성하여 사용자 설정을 재정의할 수 있습니다.
파일은 `%APPDATA%/Rocket.Chat/` 폴더 또는 모든 사용자를 위한 설치의 경우 설치 폴더에 위치해야 합니다 (Windows만 해당).

파일에 설정된 모든 설정은 기본 및 사용자 설정을 재정의합니다. 그런 다음 자동 업데이트와 같은 기본 기능을 비활성화하고 단일 서버 모드까지 만들 수 있습니다.

#### 재정의할 수 있는 설정은 다음과 같습니다:

| 설정      | 설명 |
| ----------- | ----------- |
| `"isReportEnabled": true,`                   | 버그가 개발자에게 보고되는지 설정합니다.
| `"isInternalVideoChatWindowEnabled": true,`  | 비디오 통화가 내부 창에서 열리는지 설정합니다.
| `"isFlashFrameEnabled": true,`               | 플래시 프레임이 활성화되는지 설정합니다.
| `"isMinimizeOnCloseEnabled": false,`         | 앱이 닫힐 때 최소화되는지 설정합니다.
|`"doCheckForUpdatesOnStartup": true,`         | 앱이 시작 시 업데이트를 확인하는지 설정합니다.
| `"isMenuBarEnabled": true,`                  | 메뉴 바가 활성화되는지 설정합니다.
|`"isTrayIconEnabled": true,`                  | 트레이 아이콘을 활성화합니다. 앱이 닫힐 때 트레이로 숨겨집니다. `"isMinimizeOnCloseEnabled"`를 재정의합니다.
|`"isUpdatingEnabled": true,`                  | 사용자가 앱을 업데이트할 수 있는지 설정합니다.
|`"isAddNewServersEnabled": true,`              | 사용자가 새 서버를 추가할 수 있는지 설정합니다.

##### 단일 서버 모드
`"isAddNewServersEnabled": false` 설정이 설정되면 사용자는 새 서버를 추가할 수 없습니다.
버튼과 단축키가 비활성화됩니다. 그런 다음 서버를 `servers.json` 파일에 추가해야 합니다.
이를 통해 단일 서버 모드를 만들거나 사용자가 직접 새 서버를 추가하지 못하게 할 수 있습니다.

##### 구성 예시
`overridden-settings.json` 파일:

    {
	   "isTrayIconEnabled": false,
	   "isMinimizeOnCloseEnabled": false
    }
`isTrayIconEnabled`가 활성화되면 앱이 닫힐 때 숨겨집니다.
`isMinimizeOnCloseEnabled`가 활성화되면 앱이 닫힐 때 최소화됩니다.
둘 다 비활성화되면 앱이 닫힐 때 종료됩니다.

## 라이선스

MIT 라이선스 하에 배포됩니다.

[Rocket.Chat]: https://rocket.chat

[Electron]: https://electronjs.org/

[여러분의 경험]: https://survey.zohopublic.com/zs/e4BUFG

[블로그]: https://rocket.chat/case-studies/?utm_source=github&utm_medium=readme&utm_campaign=community

[가입하세요!]: https://rocket.chat/newsletter/?utm_source=github&utm_medium=readme&utm_campaign=community

[릴리스]: https://github.com/RocketChat/Rocket.Chat.Electron/releases/latest

[Rocket.Chat 코드베이스의 진행 중인 변경사항]: https://forums.rocket.chat/t/moving-away-from-meteor-and-beyond/3270

[rollup]: https://github.com/rollup/rollup

[node-gyp readme]: https://github.com/nodejs/node-gyp#installation

[Jest]: https://jestjs.io/

[Jest electron runner]: https://github.com/facebook-atom/jest-electron-runner

[electron-builder]: https://github.com/electron-userland/electron-builder

[사용자 정의 옵션]: https://github.com/electron-userland/electron-builder/wiki/Options

[node-gyp 설치 가이드]: https://github.com/nodejs/node-gyp#installation 
