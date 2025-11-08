import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/models/enums/role_account.dart';
import '../core/state/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/exercise/screens/exercise_page.dart';
import '../features/home/screens/home_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/home/screens/admin_dashboard_screen.dart';
import '../features/learning/screens/learn_page.dart';
import '../features/learning/screens/flashcard_screen.dart';
import '../features/learning/screens/matching_game_screen.dart';
import '../features/dictionary/screens/search_screen.dart';
import 'responsive_shell.dart';
import '../features/learning/screens/daily_lesson_screen.dart';
import '../features/about/screens/about_screen.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          if (authProvider.user?.role == RoleAccount.admin) {
            return Scaffold(body: child);
          }
          return ResponsiveShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/exercise',
            builder: (context, state) => const ExercisePage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
              path: '/learn',
              builder: (context, state) => const LearnPage(),
              routes: [
                GoRoute(
                  path: 'flashcard',
                  builder: (context, state) => const FlashcardScreen(),
                ),
                GoRoute(
                  path: 'matching',
                  builder: (context, state) => const MatchingGameScreen(),
                ),
              ]),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/test-lesson',
            builder: (context, state) => const DailyLessonScreen(),
          ),
        ],
      ),

      // --- Các trang cho Admin ---
      ShellRoute(
          builder: (context, state, child) {
            if (authProvider.user?.role != RoleAccount.admin) {
              return Scaffold(body: child);
            }
            return AdminDashboardScreen(child: child);
          },
          routes: [
            GoRoute(
              path: '/admin',
              builder: (context, state) => const AdminHomeScreen(),
            ),
          ]),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authStatus = authProvider.status;
      final userRole = authProvider.user?.role;
      final location = state.matchedLocation;

      final isAuthRoute = (location == '/' || location == '/login' || location == '/register');

      if (authStatus == AuthStatus.unknown) {
        return null;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        return isAuthRoute ? null : '/login';
      }

      // Đã đăng nhập
      if (authStatus == AuthStatus.authenticated) {
        if (userRole == RoleAccount.admin) {
          if (isAuthRoute) return '/admin';
          if (!location.startsWith('/admin')) return '/admin';
          return null;
        } else {
          if (isAuthRoute) return '/home';
          if (location.startsWith('/admin')) return '/home';
          return null;
        }
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Trang không tồn tại: ${state.error}')),
    ),
  );
}