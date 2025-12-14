import 'package:country_info/core/presentation/widgets/hero_text.dart';
import 'package:flutter/material.dart';

/// Widget for displaying a country in the list
class CountryListItem extends StatelessWidget {
  final String flag;
  final String name;
  final String countryCode;
  final VoidCallback onTap;

  const CountryListItem({
    super.key,
    required this.flag,
    required this.name,
    required this.countryCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 32)),
      title: HeroText(tag: 'name_$countryCode', text: name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
