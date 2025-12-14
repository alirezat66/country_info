import 'package:country_info/features/country/presentation/providers/show_more_provider.dart';
import 'package:country_info/features/country/presentation/views/widgets/country_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailView extends ConsumerWidget {
  const DetailView({
    super.key,
    required this.items,
    required this.onExpandToggle,
  });

  final List<MapEntry<String, String>> items;
  final VoidCallback onExpandToggle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: items.length + 1, // +1 for the show more/less button
      itemBuilder: (context, index) {
        if (index == items.length) {
          // Show more/less button
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: ()  => onExpandToggle(),
                child: Text(
                  ref.watch(showMoreProvider) ? 'Show less' : 'Show more',
                ),
              ),
            ),
          );
        }

        final item = items[index];
        return CountryDetailItem(label: item.key, value: item.value);
      },
    );
  }
}
