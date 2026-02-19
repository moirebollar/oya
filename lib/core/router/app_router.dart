import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oya/core/firebase/firebase_providers.dart';
import 'package:oya/features/auth/presentation/screens/login_screen.dart';
import 'package:oya/features/auth/presentation/screens/signup_screen.dart';
import 'package:oya/features/auth/presentation/screens/password_reset_screen.dart';
import 'package:oya/features/auth/presentation/screens/profile_screen.dart';
import 'package:oya/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:oya/features/scanner/presentation/screens/product_detail_screen.dart';
import 'package:oya/features/alternatives/presentation/screens/alternatives_screen.dart';
import 'package:oya/features/store_finder/presentation/screens/store_map_screen.dart';
import 'package:oya/features/store_finder/presentation/screens/store_detail_screen.dart';
import 'package:oya/features/seasonal/presentation/screens/seasonal_screen.dart';
import 'package:oya/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/scan',
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/reset-password';

      if (!isAuthenticated && !isAuthRoute) return '/login';
      if (isAuthenticated && isAuthRoute) return '/scan';
      return null;
    },
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const PasswordResetScreen(),
      ),

      // Main shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/scan',
            builder: (context, state) => const ScannerScreen(),
            routes: [
              GoRoute(
                path: 'product/:ean',
                builder: (context, state) => ProductDetailScreen(
                  ean: state.pathParameters['ean']!,
                ),
                routes: [
                  GoRoute(
                    path: 'alternatives',
                    builder: (context, state) => AlternativesScreen(
                      ean: state.pathParameters['ean']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/stores',
            builder: (context, state) => const StoreMapScreen(),
            routes: [
              GoRoute(
                path: ':osmId',
                builder: (context, state) => StoreDetailScreen(
                  osmId: state.pathParameters['osmId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/seasonal',
            builder: (context, state) => const SeasonalScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
