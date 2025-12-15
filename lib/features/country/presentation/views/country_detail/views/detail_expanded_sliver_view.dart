import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/entities/country_mapper_ext.dart';
import 'package:country_info/features/country/presentation/providers/show_more_notifier.dart';
import 'package:country_info/features/country/presentation/views/widgets/country_detail_item.dart';
import 'package:country_info/features/country/presentation/views/widgets/more_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailExpandedSliverView extends StatelessWidget {
  final Country country;
  final VoidCallback onExpandToggle;
  const DetailExpandedSliverView({
    super.key,
    required this.country,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final showMore = ref.watch(showMoreProvider);
        final extendedItems = country.extendedFields;

        if (!showMore) {
          // Just show the button
          return SliverToBoxAdapter(
            child: ExpandedToggleButton(
              showMore: false,
              onToggle: onExpandToggle,
            ),
          );
        }

        // Show extended items + button
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == extendedItems.length) {
              // Last item is the button
              return ExpandedToggleButton(
                showMore: true,
                onToggle: onExpandToggle,
              );
            }

            final item = extendedItems.entries.elementAt(index);
            return CountryDetailItem(
              key: ValueKey('extended_${item.key}'),
              label: item.key,
              value: item.value,
            );
          }, childCount: extendedItems.length + 1),
        );
      },
    );
  }
}
