import 'package:country_info/features/country/presentation/views/country_list/list_screen.dart';
import 'package:go_router/go_router.dart';

/// App router configuration
final appRouter = GoRouter(
  initialLocation: '/countries',
  routes: [
    GoRoute(
      path: '/countries',
      builder: (context, state) => const ListScreen(),
    ),
  ],
);
