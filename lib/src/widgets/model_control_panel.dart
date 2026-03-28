import 'package:flutter/material.dart';

class ModelControlPanel extends StatelessWidget {
  const ModelControlPanel({
    super.key,
    required this.rotationY,
    required this.scale,
    required this.autoRotate,
    required this.onRotationChanged,
    required this.onScaleChanged,
    required this.onRotateLeft,
    required this.onRotateRight,
    required this.onAutoRotateChanged,
    required this.onReset,
  });

  final double rotationY;
  final double scale;
  final bool autoRotate;
  final ValueChanged<double> onRotationChanged;
  final ValueChanged<double> onScaleChanged;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;
  final ValueChanged<bool> onAutoRotateChanged;
  final VoidCallback onReset;

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
              'Object Controls',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Adjust rotation and scale to inspect how the mascot changes in the scene.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF5D7186),
              ),
            ),
            const SizedBox(height: 20),
            _ControlSection(
              label: 'Y Rotation',
              valueText: '${rotationY.toStringAsFixed(0)}°',
              child: Slider(
                min: -180,
                max: 180,
                divisions: 24,
                value: rotationY,
                label: '${rotationY.toStringAsFixed(0)}°',
                onChanged: onRotationChanged,
              ),
            ),
            const SizedBox(height: 12),
            _ControlSection(
              label: 'Scale',
              valueText: '${scale.toStringAsFixed(2)}x',
              child: Slider(
                min: 0.6,
                max: 2.2,
                divisions: 16,
                value: scale,
                label: '${scale.toStringAsFixed(2)}x',
                onChanged: onScaleChanged,
              ),
            ),
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Auto Rotate'),
              subtitle: const Text(
                'Watch state updates flow back into the 3D scene.',
              ),
              value: autoRotate,
              onChanged: onAutoRotateChanged,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onRotateLeft,
                    icon: const Icon(Icons.rotate_left),
                    label: const Text('-15°'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onRotateRight,
                    icon: const Icon(Icons.rotate_right),
                    label: const Text('+15°'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlSection extends StatelessWidget {
  const _ControlSection({
    required this.label,
    required this.valueText,
    required this.child,
  });

  final String label;
  final String valueText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              valueText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }
}
