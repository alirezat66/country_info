import 'package:flutter/material.dart';

/// Widget for displaying a key-value pair in country details
class CountryDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final EdgeInsetsGeometry padding;

  const CountryDetailItem({
    super.key,
    required this.label,
    required this.value,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    print('label: $label, value: $value');
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label:",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
