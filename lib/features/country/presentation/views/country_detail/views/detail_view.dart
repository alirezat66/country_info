import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/entities/country_mapper_ext.dart';
import 'package:country_info/features/country/presentation/views/country_detail/views/detail_basic_sliver_view.dart';
import 'package:country_info/features/country/presentation/views/country_detail/views/detail_expanded_sliver_view.dart';
import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  final Country country;
  final VoidCallback onExpandToggle;

  const DetailView({
    super.key,
    required this.country,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Basic items - calculated once, never rebuilds
    final basicItems = country.basicFields;

    return CustomScrollView(
      slivers: [
        // This part NEVER rebuilds when showMore changes
        DetailBasicSliverView(basicItems: basicItems),

        // Only this Consumer rebuilds when showMore changes
        DetailExpandedSliverView(
          country: country,
          onExpandToggle: onExpandToggle,
        ),
      ],
    );
  }
}
