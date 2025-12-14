import 'package:country_info/core/domain/failure.dart';
import 'package:country_info/core/presentation/views/error_view.dart';
import 'package:country_info/core/presentation/views/loading_view.dart';
import 'package:country_info/features/country/presentation/providers/country_providers.dart';
import 'package:country_info/features/country/presentation/views/country_list/views/loaded_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Countries'), centerTitle: false),
      body: countriesAsync.when(
        data: (countries) {
          return CountryLoadedView(
            countries: countries,
            onCountrySelected: (code, name) => (),
            //todo go to detail screen
          );
        },
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          errorMessage: error is Failure ? error.message : error.toString(),
          onRetry: () => ref.invalidate(countriesProvider),
        ),
      ),
    );
  }
}
