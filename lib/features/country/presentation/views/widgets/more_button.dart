import 'package:flutter/material.dart';

class ExpandedToggleButton extends StatelessWidget {
  final bool showMore;
  final VoidCallback onToggle;
  const ExpandedToggleButton({
    super.key,
    required this.showMore,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: onToggle,
          child: Text(showMore ? 'Show less' : 'Show more'),
        ),
      ),
    );
  }
}
