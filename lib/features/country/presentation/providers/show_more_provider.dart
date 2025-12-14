import 'package:country_info/features/country/presentation/providers/show_more_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showMoreProvider = NotifierProvider.autoDispose<ShowMoreNotifier, bool>(
  ShowMoreNotifier.new,
);
