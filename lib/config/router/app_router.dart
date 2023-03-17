import 'package:go_router/go_router.dart';
import 'package:solesteals/presentation/screens/home_screen.dart';
import 'package:solesteals/screens/splash_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      // builder: (context, state) => const HomeScreen(path: '/'),
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(path: '/'),
    ),
    GoRoute(
      name: 'homeWithPath',
      path: '/homeWithPath/:path',
      builder: (context, state) =>
          HomeScreen(path: state.params['path'] ?? '/'),
    ),
  ],
);
