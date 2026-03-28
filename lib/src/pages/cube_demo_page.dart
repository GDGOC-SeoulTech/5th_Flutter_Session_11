import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart' as cube;

import '../controllers/model_viewer_controller.dart';
import '../widgets/model_control_panel.dart';

class CubeDemoPage extends StatefulWidget {
  const CubeDemoPage({super.key});

  @override
  State<CubeDemoPage> createState() => _CubeDemoPageState();
}

class _CubeDemoPageState extends State<CubeDemoPage> {
  final ModelViewerController _controller = ModelViewerController();

  Timer? _autoRotateTimer;
  bool _autoRotate = false;

  @override
  void dispose() {
    _autoRotateTimer?.cancel();
    super.dispose();
  }

  void _onSceneCreated(cube.Scene scene) {
    _controller.attachScene(scene);
    setState(() {});
  }

  void _setRotation(double value) {
    setState(() {
      _controller.setRotationY(value);
    });
  }

  void _setScale(double value) {
    setState(() {
      _controller.setScale(value);
    });
  }

  void _rotateBy(double delta) {
    setState(() {
      _controller.rotateStep(delta);
    });
  }

  void _reset() {
    setState(() {
      _autoRotate = false;
      _controller.reset();
    });
    _autoRotateTimer?.cancel();
  }

  void _toggleAutoRotate(bool value) {
    setState(() {
      _autoRotate = value;
    });

    _autoRotateTimer?.cancel();

    if (!value) {
      return;
    }

    _autoRotateTimer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!mounted) {
        return;
      }

      setState(_controller.stepAutoRotation);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cat Character Viewer')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFBF6), Color(0xFFFFF1E2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Textured Cat Character',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF6A3D1E),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A softer and friendlier OBJ character for showing 3D loading, scene setup, and transform updates in Flutter.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF7D5B43),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 920;
                        final viewer = _ViewerCard(
                          rotationY: _controller.rotationY,
                          scale: _controller.scale,
                          isReady: _controller.isReady,
                          onSceneCreated: _onSceneCreated,
                        );
                        final sidePanel = Column(
                          children: [
                            ModelControlPanel(
                              rotationY: _controller.rotationY,
                              scale: _controller.scale,
                              autoRotate: _autoRotate,
                              onRotationChanged: _setRotation,
                              onScaleChanged: _setScale,
                              onRotateLeft: () => _rotateBy(-15),
                              onRotateRight: () => _rotateBy(15),
                              onAutoRotateChanged: _toggleAutoRotate,
                              onReset: _reset,
                            ),
                            const SizedBox(height: 16),
                            const _ExplanationCard(),
                          ],
                        );

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 11, child: viewer),
                              const SizedBox(width: 20),
                              Expanded(flex: 9, child: sidePanel),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            viewer,
                            const SizedBox(height: 16),
                            sidePanel,
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewerCard extends StatelessWidget {
  const _ViewerCard({
    required this.rotationY,
    required this.scale,
    required this.isReady,
    required this.onSceneCreated,
  });

  final double rotationY;
  final double scale;
  final bool isReady;
  final ValueChanged<cube.Scene> onSceneCreated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                const _InfoPill(
                  label: 'Model',
                  value: 'assets/models/poly_pizza_cat.obj',
                ),
                _InfoPill(
                  label: 'Rotation',
                  value: '${rotationY.toStringAsFixed(0)} deg',
                ),
                _InfoPill(
                  label: 'Scale',
                  value: '${scale.toStringAsFixed(2)}x',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 460,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8B5A3C),
                    Color(0xFFD08C60),
                    Color(0xFFF6C28B),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    right: -10,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -60,
                    left: -20,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: cube.Cube(
                          interactive: false,
                          onSceneCreated: onSceneCreated,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        isReady ? 'Cat ready' : 'Loading cat',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Structure',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const _ConceptLine(
              title: 'Cube',
              body: 'The Flutter widget that renders the 3D scene on screen.',
            ),
            const SizedBox(height: 12),
            const _ConceptLine(
              title: 'Scene',
              body:
                  'The 3D space that owns the camera, world, and rendering context.',
            ),
            const SizedBox(height: 12),
            const _ConceptLine(
              title: 'Object',
              body:
                  'The loaded OBJ model whose rotation and scale values change over time.',
            ),
            const SizedBox(height: 12),
            const _ConceptLine(
              title: 'State Update',
              body:
                  'UI input triggers setState, then updateTransform refreshes the model in the scene.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ConceptLine extends StatelessWidget {
  const _ConceptLine({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFFE28A4D),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6F5846),
                height: 1.55,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6A3D1E),
                  ),
                ),
                TextSpan(text: body),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFF0DFD3)),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF8A6B53),
          ),
          children: [
            TextSpan(
              text: '$label  ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Color(0xFF6A3D1E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
