import 'package:country_info/core/presentation/views/error_view.dart';
import 'package:country_info/core/presentation/views/loading_view.dart';
import 'package:country_info/core/presentation/widgets/hero_text.dart';
import 'package:country_info/features/country/domain/entities/country_mapper_ext.dart';
import 'package:country_info/features/country/presentation/providers/country_providers.dart';
import 'package:country_info/features/country/presentation/providers/show_more_provider.dart';
import 'package:country_info/features/country/presentation/views/widgets/country_detail_item.dart';
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
    final showMore = ref.watch(showMoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: HeroText(tag: 'name_$countryCode', text: countryName ?? ''),
      ),
      body: countryAsync.when(
        data: (country) {
          final fields = showMore
              ? country.extendedFields
              : country.basicFields;
          final items = fields.entries.toList();

          return ListView.builder(
            itemCount: items.length + 1, // +1 for the show more/less button
            itemBuilder: (context, index) {
              if (index == items.length) {
                // Show more/less button
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(showMoreProvider.notifier).toggle();
                      },
                      child: Text(showMore ? 'Show less' : 'Show more'),
                    ),
                  ),
                );
              }

              final item = items[index];
              return CountryDetailItem(label: item.key, value: item.value);
            },
          );
        },
        loading: () => const LoadingView(),
        error: (error, stackTrace) => ErrorView(
          errorMessage: error.toString(),
          onRetry: () {
            ref.invalidate(countryDetailsProvider(countryCode));
          },
        ),
      ),
    );
  }
}
