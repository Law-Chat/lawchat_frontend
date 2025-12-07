# Law Chat
핵심 금융 법령과 규정을 쉽고 간단하게 알려주는 금융 법률 챗봇 애플리케이션

<br/>

## 1. 서비스 소개
### 1-1. Law Chat이란?
Law Chat은 금융소비자보호법, 자본시장법, 대부업법 등 금융 관련 법령을 기반으로 신뢰도 높은 답변을 제공하는 챗봇 서비스입니다.
사용자가 자연어로 질문하면 관련 법령 근거, 요약 답변, 관련 조문까지 한 번에 정리해 제공하여 금융 법률 상담의 진입장벽을 크게 낮추는 것을 목표로 합니다.

### 1-2. 타 서비스와의 차별점
1. **‘금융 법률’만을 위한 즉시 상담 경험**
    - 기존 챗봇이나 검색 서비스가 다루지 않는 금융 법률 영역에 특화
    - 금융 관련 법률 질문에 대해 조문 기반 즉시 답변 제공

2. **검색·조회·상담의 ‘중간 단계’를 자동으로 해결**
    - 사용자가 직접 법령을 검색하거나 이해할 필요 없음
    - 질문을 해석해 필요한 법령·요약·근거를 한 번에 정리하여 제공

3. **개인 상황을 기억하는 지속형 금융 케어**
    - 상담 히스토리 기반으로 사용자의 흐름을 이해
    - 이전 대화 내용과 상황을 기억해 후속 정보까지 자연스럽게 연결
    - 알림과 연동되어 ‘지속적인 법률 케어’ 경험 제공

### 1-3. 서비스 관련 링크
- [Figma](https://www.figma.com/design/xPGMt4hfBtPhvQL3Hm2hhd/LawChat-UI?node-id=0-1&t=SW2XUJHcn8WMA5Tk-1)

<br/>

## 2. 팀원 소개
<table>
    <tr align="center">
        <td><img src="https://avatars.githubusercontent.com/u/81706832?v=4" width="250"></td>
        <td><img src="https://avatars.githubusercontent.com/u/84304379?v=4" width="250"></td>
        <td><img src="https://avatars.githubusercontent.com/u/163857590?v=4" width="250"></td>
        <td><img src="https://avatars.githubusercontent.com/u/104902715?v=4" width="250"></td>
    </tr>
    <tr align="center">
        <td><a href="https://github.com/gyuwonsong">송규원</a></td>
        <td><a href="https://github.com/wngktjd13">윤성욱</a></td>
        <td><a href="https://github.com/tnals0924">황수민</a></td>
        <td><a href="https://github.com/hyeonjin6530">황현진</a></td>
    </tr>
    <tr align="center">
        <td>소프트웨어학부 20213015</td>
        <td>소프트웨어학부 20213029</td>
        <td>소프트웨어학부 20213102</td>
        <td>소프트웨어학부 20223158</td>
    </tr>
    <tr align="center">
        <td>Design, Frontend</td>
        <td>Frontend, Backend, AI</td>
        <td>Frontend, Backend, AI</td>
        <td>Design, Frontend</td>
    </tr>
</table>

<br/>

## 3. 기술 스택
| 구분             | 기술                                                                                                                                                                                                                                               |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **IDE**        | <img src="https://img.shields.io/badge/Android%20Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white"/> <img src="https://img.shields.io/badge/IntelliJ%20IDEA-000000?style=for-the-badge&logo=intellijidea&logoColor=white"/> |
| **디자인**        | <img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white"/>                                                                                                                                            |
| **프론트엔드**      | <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>                                                                                                                                        |
| **백엔드**        | <img src="https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white"/>                                                                                                                               |
| **DBMS**       | <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white"/>                                                                                                                                  |
| **클라우드 / 인증**  | <img src="https://img.shields.io/badge/AWS%20EC2-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white"/> <img src="https://img.shields.io/badge/AWS%20RDS-527FFF?style=for-the-badge&logo=amazon-aws&logoColor=white"/>                    |
| **AI**         | <img src="https://img.shields.io/badge/Gemini-8E75FF?style=for-the-badge&logo=google&logoColor=white"/>                                                                                                                                          |
| **버전관리**       | <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>                                                                                                                                          |
| **API 문서화 도구** | <img src="https://img.shields.io/badge/Swagger-85EA2D?style=for-the-badge&logo=swagger&logoColor=black"/>                                                                                                                                        |
| **문서화**        | <img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white"/>                                                                                                                                          |


<br/>

## 4. 프로젝트 실행 방법
### 4-1. Frontend 실행 방법
1. 프로젝트 Repository를 원하는 경로에 clone합니다.
```sh
git clone https://github.com/Law-Chat/lawchat_frontend.git
```

<br/>

2. clone한 Repository의 root 경로로 이동합니다.
```sh
cd lawchat_frontend
```

<br/>

3. Flutter SDK가 설치되어 있는지 확인하고 환경을 점검합니다.  
    3-1. 운영체제에 맞는 Flutter SDK를 다운로드합니다. ([다운로드 링크](https://docs.flutter.dev/get-started/install))  
    3-2. 원하는 경로에 SDK를 압축 해제합니다.  
    3-3. `bin` 디렉터리 경로를 시스템 PATH 환경 변수에 추가합니다.  
    3-4. 아래 명령어로 설치 상태를 확인합니다.

    ```sh
    flutter doctor
    ```

> 이 프로젝트는 아래 버전에서 개발되었습니다.  
> **Flutter 3.35.7, Dart 3.9.2**


<br/>

4. 프로젝트 의존성 패키지를 설치합니다.
```sh
flutter pub get
```

<br/>

5. 프로젝트 루트에 `.env` 파일을 생성하고 내용을 추가합니다.(보안 이슈로 `.env` 파일 내용은 아래의 노션 상단 .env 설정 가이드를 참고해주세요.) <br/>
🔗 [Law-Chat 로컬 환경 테스트 .env 파일 설정 방법](https://www.notion.so/2025-2-_-2-_03-299aa5307d2a80a1a2f2f11eb568a0b3?source=copy_link)
<br/>

6. 가상 기기(에뮬레이터)를 실행합니다. <br/>
> 이 프로젝트는 아래와 같은 Android 가상 기기에서 테스트되었습니다.
> **Pixel 7 (Android 14.0 "UpsideDownCake", API 34, arm64)**

7. 아래 명령어를 실행하여 Flutter App을 실행합니다.
```sh
flutter run
```

<br/>

## 5. 주요 기능
### 5-1. 로그인/회원가입
LawChat 접속 시 짧은 스플래시 스크린을 지나 로그인 화면으로 이동하게 됩니다. <br/>
본 서비스는 구글 계정을 기반으로 하고 있으므로 **구글 로그인 버튼** 클릭시 간편하게 로그인 가능합니다. <br/>
이후 최초 로그인 시 사용자 이름과 이메일 정보를 자동으로 불러와 회원가입을 진행합니다. 약관 동의 후 **가입하기 버튼**을 클릭하면 즉시 서비스 이용이 가능합니다.
(이미 계정이 있을 경우 '로그인' 버튼 클릭)
<p align="center">
  <img width="334" height="668" alt="MP-03-최종발표" src="https://github.com/user-attachments/assets/129251d8-0480-45a8-a348-1b93344adade" />
  <img width="334" height="668" alt="MP-03-최종발표 (1)" src="https://github.com/user-attachments/assets/f6bc12f0-3753-4901-8297-fd587b3dba99" />
</p>

### 5-2. 온보딩 
온보딩 화면은 앱을 처음 접속하는 유저에게 서비스의 핵심 기능과 사용 목적을 안내하는 역할을 합니다.
<p align="center">
    <img width="334" height="668" alt="MP-03-최종발표" src="https://github.com/user-attachments/assets/92b62553-c89f-478b-80fd-68bd083db6d5" />
  <img width="334" height="668" alt="MP-03-최종발표" src="https://github.com/user-attachments/assets/6ea1227b-4513-493c-b352-08758f7cce77" />
</p>

### 5-3. 홈
홈 화면에서는 최근 진행한 상담 내역 중 **최근 채팅 3개**를 바로 확인할 수 있습니다.<br/>
또한 금융 법률에서 유용한 주제를 기반으로 구성된 **추천 질문 목록**도 제공하여 보다 쉽게 상담을 시작할 수 있도록 돕습니다.
<p align="center">
  <img width="334" height="668" alt="MP-03-최종발표 (1)" src="https://github.com/user-attachments/assets/e1612131-f4b2-4738-8bdd-775f2379d57f" />
</p>

### 5-4. 히스토리
히스토리 화면에서는 그동안 진행한 상담 내역을 모두 확인할 수 있으며, 날짜 필터링 기능을 통해 특정 기간의 상담 기록을 쉽게 찾아볼 수 있습니다. 이전 질문을 다시 선택해 새로운 질문으로 이어갈 수 있어 지속적인 상담 흐름을 제공합니다.
<p align="center">
  <img width="334" height="668" alt="MP-03-최종발표 (2)" src="https://github.com/user-attachments/assets/f4c81a00-b19c-451b-ba10-afb1ef43a550" />
</p>

### 5-5. 채팅
채팅 화면에서는 추천 질문을 선택하여 상담을 시작할 수도 있으며 사용자가 자유롭게 금융 법률 관련 질문을 입력할 수 있습니다.<br/>
또한 챗봇의 답변에서는 **출처 보기** 기능을 통해 실제 법령 전문과 상세 근거를 확인할 수 있어 신뢰도 높은 정보를 제공합니다.
<p align="center">
  <img width="334" height="668" alt="MP-03-최종발표 (3)" src="https://github.com/user-attachments/assets/aa98dd2b-7e16-49eb-9a0a-950f27cc1c97" />
  <img width="334" height="668" alt="MP-03-최종발표 (4)" src="https://github.com/user-attachments/assets/c73b0ec1-ec13-440f-8f3e-ef3e5bc04c60" />
  <img width="334" height="668" alt="MP-03-최종발표 (5)" src="https://github.com/user-attachments/assets/142b3064-4789-42d5-b43e-778b20017434" />
</p>

### 5-6. 마이페이지 
마이페이지는 사용자가 개인 정보와 서비스 이용 환경을 직접 관리할 수 있는 공간입니다. <br/>
사용자의 기본 정보를 확인할 수 있으며 **푸시 알림 설정 변경**, **로그아웃**, **서비스 탈퇴** 기능을 제공합니다.
<p align="center">
  <img width="334" height="668" alt="MP-03-최종발표 (7)" src="https://github.com/user-attachments/assets/ff176aa1-e53d-44e1-8ac4-f514b64ec8fc" />
</p>

### 5-7. 알림
알림 페이지에서는 전날 보도된 금융 규제 뉴스 등 중요한 **금융 정보 알림**을 모아서 확인할 수 있습니다. 또한 읽지 않은 알림은 파란 배경으로 표시되고 확인하면 자동으로 읽음 처리되어 필요한 정보만 빠르게 구분할 수 있습니다.
<p align="center">
  <img width="333" height="667" alt="MP-03-최종발표 (6)" src="https://github.com/user-attachments/assets/f58cf73b-6082-4a72-8464-2ebf2d9f20ad" />
</p>
