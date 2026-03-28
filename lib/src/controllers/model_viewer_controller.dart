import 'package:flutter_cube/flutter_cube.dart' as cube;

class ModelViewerController {
  static const double initialRotationX = -14;
  static const double initialRotationY = 18;
  static const double initialScale = 1.75;
  static const double minScale = 0.8;
  static const double maxScale = 2.8;

  cube.Scene? _scene;
  cube.Object? _model;

  double rotationX = initialRotationX;
  double rotationY = initialRotationY;
  double scale = initialScale;

  bool get isReady => _model != null;

  // Scene is created once the Cube widget is ready.
  // We attach the camera, add the model, and apply the default transform here.
  void attachScene(cube.Scene scene) {
    _scene = scene;

    // Bring the camera a little closer so the model feels present from the start.
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

  void setRotationY(double value) {
    rotationY = value;
    _applyTransform();
  }

  void rotateStep(double delta) {
    rotationY = _wrapDegrees(rotationY + delta);
    _applyTransform();
  }

  void setScale(double value) {
    scale = value.clamp(minScale, maxScale);
    _applyTransform();
  }

  void reset() {
    rotationX = initialRotationX;
    rotationY = initialRotationY;
    scale = initialScale;
    _applyTransform();
  }

  void stepAutoRotation() {
    rotationY = _wrapDegrees(rotationY + 2);
    _applyTransform();
  }

  // flutter_cube does not automatically know that we changed the object's
  // vectors, so we update the transform matrix and refresh the scene manually.
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

  double _wrapDegrees(double value) {
    if (value > 180) {
      return value - 360;
    }
    if (value < -180) {
      return value + 360;
    }
    return value;
  }
}
