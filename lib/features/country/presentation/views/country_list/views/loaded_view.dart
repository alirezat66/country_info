import 'package:country_info/core/presentation/views/empty_view.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/presentation/views/country_list/views/country_list_view.dart';
import 'package:flutter/material.dart';
class CountryLoadedView extends StatelessWidget {
  final List<Country> countries;
  final Function(String code, String name) onCountrySelected;
  const CountryLoadedView({
    super.key,
    required this.countries,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (countries.isEmpty) {
      return const EmptyView(message: 'No countries found');
    }
    return CountryListView(
      countries: countries,
      onCountrySelected: onCountrySelected,
    );
  }
}
