import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  const RadiantGradientMask({Key? key, required this.child, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: colors,
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}