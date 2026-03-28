import 'package:flutter_test/flutter_test.dart';

import 'package:cube_study_demo/src/controllers/model_viewer_controller.dart';

void main() {
  test('reset brings values back to the presentation defaults', () {
    final controller = ModelViewerController();

    controller.setRotationY(90);
    controller.setScale(1.9);
    controller.reset();

    expect(controller.rotationY, ModelViewerController.initialRotationY);
    expect(controller.scale, ModelViewerController.initialScale);
  });
}
