import 'package:flutter/material.dart';

class GoldIcons extends StatelessWidget {
  const GoldIcons({
    super.key,
    this.size,
    this.icon,
  });
  final double? size;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.13,
            0.25,
            0.50,
            1.0
          ],
          colors: [
            Color(0xFFCBA948),
            Color(0xFFE9CB68),
            Color(0xFFE6C25F),
            Color(0xFFEDC967),
          ]).createShader(bounds),
      child: Icon(
        icon,
        size: size ?? 35,
      ),
    );
  }
}
