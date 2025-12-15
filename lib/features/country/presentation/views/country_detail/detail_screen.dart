import 'package:country_info/core/presentation/views/error_view.dart';
import 'package:country_info/core/presentation/views/loading_view.dart';
import 'package:country_info/core/presentation/widgets/hero_text.dart';
import 'package:country_info/features/country/presentation/providers/country_providers.dart';
import 'package:country_info/features/country/presentation/providers/show_more_notifier.dart';
import 'package:country_info/features/country/presentation/views/country_detail/views/detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen displaying detailed country information
class DetailScreen extends ConsumerWidget {
  final String countryCode;
  final String? countryName;

  const DetailScreen({super.key, required this.countryCode, this.countryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryAsync = ref.watch(countryDetailsProvider(countryCode));

    return Scaffold(
      appBar: AppBar(
        title: HeroText(tag: 'name_$countryCode', text: countryName ?? ''),
      ),
      body: countryAsync.when(
        data: (country) {
          return DetailView(
            country: country,
            onExpandToggle: () => ref.read(showMoreProvider.notifier).toggle(),
          );
        },
        loading: () => const LoadingView(),
        error: (error, stackTrace) => ErrorView(
          errorMessage: error.toString(),
          onRetry: () => ref.invalidate(countryDetailsProvider(countryCode)),
        ),
      ),
    );
  }
}
