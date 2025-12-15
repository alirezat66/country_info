import 'package:country_info/features/country/presentation/views/widgets/country_detail_item.dart';
import 'package:flutter/widgets.dart';

class DetailBasicSliverView extends StatelessWidget {
  final Map<String, String> basicItems;
  const DetailBasicSliverView({super.key, required this.basicItems});

  @override
  Widget build(BuildContext context) {
    print('🔵 DetailBasicSliverView build called');
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = basicItems.entries.toList()[index];
        return CountryDetailItem(
          key: ValueKey('basic_${item.key}'),
          label: item.key,
          value: item.value,
        );
      }, childCount: basicItems.length),
    );
  }
}
