import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/presentation/views/widgets/country_list_item.dart';
import 'package:flutter/material.dart';

class CountryListView extends StatelessWidget {
  final List<Country> countries;
  final Function(String code, String name) onCountrySelected;
  const CountryListView({
    super.key,
    required this.countries,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return CountryListItem(
          flag: country.emoji,
          name: country.name,
          countryCode: country.code,
          onTap: () => onCountrySelected(country.code, country.name),
        );
      },
    );
  }
}
