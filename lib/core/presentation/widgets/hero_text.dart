import 'package:flutter/material.dart';

class HeroText extends StatelessWidget {
  final String text;
  final String tag;
  final TextStyle? style;

  const HeroText({
    super.key,
    required this.text,
    required this.tag,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        type: MaterialType.transparency,
        child: Text(text, style: style),
      ),
    );
  }
}
