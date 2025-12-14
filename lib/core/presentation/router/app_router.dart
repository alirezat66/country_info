import 'package:country_info/features/country/presentation/views/country_detail/detail_screen.dart';
import 'package:country_info/features/country/presentation/views/country_list/list_screen.dart';
import 'package:go_router/go_router.dart';

/// App router configuration
final appRouter = GoRouter(
  initialLocation: '/countries',
  routes: [
    GoRoute(
      path: '/countries',
      builder: (context, state) => const ListScreen(),
      routes: [
        GoRoute(
          path: ':code',
          builder: (context, state) {
            final code = state.pathParameters['code']!;
            final countryName = state.extra as String?;
            return DetailScreen(countryCode: code, countryName: countryName);
          },
        ),
      ],
    ),
  ],
);
