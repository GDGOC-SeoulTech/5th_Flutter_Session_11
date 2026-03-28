### App Session 11주차
> 담당 Member: 이소담

![GDGoC Header](https://github.com/user-attachments/assets/dfe27e31-d863-40ff-81f0-051b1742bdc0)

## 이번 주에는

- `flutter_cube` 패키지를 사용해 Flutter에서 3D 모델을 렌더링합니다.
- 외부에서 가져온 귀여운 character 모델을 Flutter asset으로 연결합니다.
- `Cube`, `Scene`, `Object`의 역할과 연결 구조를 정리합니다.
- 슬라이더와 버튼으로 3D 모델의 회전과 크기를 제어합니다.
- `setState()`와 `updateTransform()`을 통해 UI 상태와 3D 상태가 어떻게 연결되는지 확인합니다.

<br />

## 프로젝트 개요

이번 예제는 `flutter_cube`를 이용해 Flutter에서 외부 cat character 모델을 띄우고,
사용자 입력에 따라 모델의 회전과 크기가 바뀌는 흐름을 확인할 수 있도록 만든 실습용 예제 앱입니다.

이번 버전에서는 너무 단순한 기본 도형 대신,
외부 모델을 가져와 OBJ/MTL/PNG asset으로 연결하는 방식으로 구성했습니다.
또한 첫 화면에서 모델이 더 잘 보이도록 기본 카메라 거리와 초기 scale 값도 함께 조정했습니다.

프로젝트 목적은 다음과 같습니다.

- Flutter에서 3D asset을 로드하는 기본 흐름 이해하기
- `Cube -> Scene -> Object` 구조를 코드로 확인하기
- 외부 모델 asset을 프로젝트에 포함하는 방법 정리하기
- 상태 변경이 3D 모델에 반영되는 과정을 직접 확인하기

<br />

## 동작 구조

이 프로젝트의 핵심 흐름은 아래처럼 보면 됩니다.

```text
Flutter Widget -> Cube -> Scene -> Object -> Asset(.obj/.mtl/.png)
```

각 구성 요소의 역할은 다음과 같습니다.

- `Cube`
  - Flutter 위젯입니다.
  - 3D 장면을 화면에 렌더링하는 영역입니다.
- `Scene`
  - 3D 공간 전체를 의미합니다.
  - 카메라, 월드(`world`), 조명 같은 요소를 포함합니다.
- `Object`
  - 실제 3D 모델입니다.
  - `.obj` 파일을 기반으로 생성됩니다.
- `assets`
  - 앱 내부에서 읽을 3D 파일입니다.
  - 이번 예제에서는 `poly_pizza_cat.obj`, `poly_pizza_cat.mtl`, `Tex_Cat.png`를 사용합니다.

상태 변경 흐름은 아래와 같습니다.

```text
User Input -> setState() -> Object 값 변경 -> updateTransform() -> Scene 갱신
```

<br />

## 폴더 구조

```text
.
├─ assets/
│  └─ models/
│     ├─ poly_pizza_cat.glb
│     ├─ poly_pizza_cat.mtl
│     ├─ poly_pizza_cat.obj
│     └─ Tex_Cat.png
├─ lib/
│  ├─ app.dart
│  ├─ main.dart
│  └─ src/
│     ├─ controllers/
│     │  └─ model_viewer_controller.dart
│     ├─ pages/
│     │  └─ cube_demo_page.dart
│     └─ widgets/
│        └─ model_control_panel.dart
├─ test/
│  └─ widget_test.dart
└─ pubspec.yaml
```

<br />

## 주요 파일 설명

### `pubspec.yaml`

- `flutter_cube: ^0.1.1` 의존성을 추가했습니다.
- 모델 관련 파일을 한 번에 읽을 수 있도록 `assets/models/` 디렉터리를 asset으로 등록했습니다.

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_cube: ^0.1.1

flutter:
  uses-material-design: true
  assets:
    - assets/models/
```

### `lib/main.dart`

앱의 시작점입니다.
`CubeStudyApp`을 실행하는 역할만 두어 진입 구조를 단순하게 유지했습니다.

```dart
import 'package:flutter/widgets.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CubeStudyApp());
}
```

### `lib/app.dart`

앱 전체 테마와 `MaterialApp` 구성을 담당합니다.
현재 앱 타이틀은 `Cat Character Viewer`로 설정되어 있습니다.

### `lib/src/controllers/model_viewer_controller.dart`

3D 모델 제어 로직을 모아둔 파일입니다.

담당하는 역할은 다음과 같습니다.

- `Scene`이 생성되면 카메라 위치 설정
- `.obj` 모델을 `Object`로 생성 후 `scene.world`에 추가
- 회전값과 크기값 변경
- 초기 상태로 리셋
- `updateTransform()` 호출로 실제 모델 변형 반영

핵심 코드는 아래 부분입니다.

```dart
void attachScene(cube.Scene scene) {
  _scene = scene;

  scene.camera.position.setValues(0, 0, 6);
  scene.camera.target.setValues(0, 0, 0);
  scene.camera.zoom = 1.2;

  final model = cube.Object(
    fileName: 'assets/models/poly_pizza_cat.obj',
    isAsset: true,
    lighting: true,
    normalized: true,
    name: 'poly-pizza-cat',
  );

  scene.world.add(model);
  _model = model;
  _applyTransform();
}
```

```dart
void _applyTransform() {
  final model = _model;
  if (model == null) {
    return;
  }

  model.rotation.setValues(rotationX, rotationY, 0);
  model.scale.setValues(scale, scale, scale);
  model.updateTransform();
  _scene?.update();
}
```

### `lib/src/pages/cube_demo_page.dart`

실제 메인 화면입니다.

포함된 내용은 다음과 같습니다.

- 앱 제목과 설명 문구
- `Cube` 기반 3D 뷰어 영역
- 회전/크기/자동 회전/리셋 제어 UI
- `Cube`, `Scene`, `Object` 설명 카드
- 더 친근한 캐릭터 느낌에 맞춘 색감과 레이아웃

### `lib/src/widgets/model_control_panel.dart`

제어용 UI만 따로 분리한 파일입니다.

이렇게 분리한 이유는 다음과 같습니다.

- 화면 레이아웃과 제어 위젯 코드를 분리하기 위해
- 팀원이 읽을 때 UI 코드와 로직 코드를 구분하기 쉽게 하기 위해
- 세션 자료로 사용할 때 구조를 명확하게 보여주기 위해

<br />

## Asset 구성

이번 예제는 외부 모델을 프로젝트 안으로 가져와,
Flutter에서 바로 사용할 수 있도록 OBJ/MTL/PNG asset으로 구성했습니다.

### `assets/models/poly_pizza_cat.obj`

- 외부 모델의 정점(vertex), 면(face), UV 정보가 포함된 OBJ 파일입니다.
- `flutter_cube`가 실제로 읽는 메인 모델 파일입니다.

### `assets/models/poly_pizza_cat.mtl`

- 외부 모델의 재질과 텍스처 연결 정보를 담은 MTL 파일입니다.
- `map_Kd Tex_Cat.png` 설정을 통해 PNG 텍스처를 연결합니다.

### `assets/models/Tex_Cat.png`

- 외부 모델의 색 정보를 담는 텍스처 파일입니다.
- 단색 재질만 쓰는 대신 텍스처 기반으로 더 자연스러운 캐릭터 표현이 가능합니다.

### `assets/models/poly_pizza_cat.glb`

- 외부에서 받은 원본 파일입니다.
- 현재 앱에서는 직접 읽지 않고, OBJ/MTL 변환용 원본으로 보관하고 있습니다.

<br />

## 외부 모델 출처

- 모델명: `Cat`
- 제공처: Poly Pizza
- 제작자 표기: Poly by Google
- 라이선스: Creative Commons Attribution 3.0
- 모델 페이지: https://poly.pizza/m/6dM1J6f6pm9

이번 프로젝트에서는 원본 GLB 파일을 내려받은 뒤,
Flutter에서 바로 사용할 수 있도록 OBJ/MTL/PNG asset으로 변환해 사용했습니다.

<br />

## 사용자 상호작용

앱에서 제공하는 조작 기능은 다음과 같습니다.

- Y축 회전 슬라이더
- 모델 크기 슬라이더
- `-15°`, `+15°` 회전 버튼
- 자동 회전 스위치
- Reset 버튼

이 기능들은 모두 `ModelViewerController`를 통해 3D 모델에 반영됩니다.

예를 들어 회전 슬라이더는 다음 흐름으로 동작합니다.

1. 사용자가 슬라이더를 움직입니다.
2. `setState()`가 호출됩니다.
3. 컨트롤러의 `setRotationY()`가 실행됩니다.
4. `_applyTransform()`이 실행됩니다.
5. `Object.rotation`과 `Scene`이 갱신됩니다.

<br />

## 실행 방법

프로젝트 루트에서 아래 명령을 실행하면 됩니다.

```bash
flutter pub get
flutter run
```

Windows 환경에서 바로 확인하려면 아래 명령을 사용할 수 있습니다.

```bash
flutter run -d windows
```

실행 파일까지 빌드하려면 아래 명령을 사용할 수 있습니다.

```bash
flutter build windows
```

<br />

## 확인한 환경

이번 프로젝트는 아래 환경에서 확인했습니다.

- Flutter `3.41.4`
- Dart `3.11.1`
- `flutter_cube` `^0.1.1`

`flutter_cube`는 비교적 오래된 패키지지만,
현재 프로젝트 기준으로는 의존성 설치, 분석, 테스트, Windows 빌드까지 모두 통과했습니다.

<br />

## 검증 내용

아래 항목을 확인했습니다.

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build windows`

<br />

## 참고 포인트

팀원들이 코드를 볼 때 특히 확인하면 좋은 부분은 아래와 같습니다.

- `Cube` 위젯이 생성되는 위치
- `onSceneCreated`에서 `Scene`을 설정하는 흐름
- `Object(fileName: ...)`로 asset 기반 3D 모델을 읽는 부분
- `updateTransform()`과 `scene.update()`가 함께 호출되는 이유
- 외부 모델이 OBJ/MTL/PNG asset으로 연결되는 방식
- 초기 카메라 거리와 scale 값이 첫 화면 인상에 주는 영향
- UI 입력이 컨트롤러를 통해 3D 모델 상태로 연결되는 구조
