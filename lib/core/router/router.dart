
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:land2/core/router/router_names.dart';

import '../../features/authentication/presentation/providers/auth_state_provider.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';


final routeProvider = Provider((ref) {
  final authState = ref.watch(authStateNotifier);
  return GoRouter(
    redirect: (context, state) {
      final isLoggedIn = authState;
      if (isLoggedIn && state.matchedLocation == '/register') return '/home';
      if (isLoggedIn && state.matchedLocation == '/login') return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: RouterNames.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouterNames.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouterNames.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: RouterNames.home.name,
        builder: (context, state) => const MapScreen(),
      ),
    ],
  );
});
