
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../modules/auth/models/user_role.dart';
import '../../../modules/auth/presentation/pages/forgot_password_page.dart';
import '../../../modules/auth/presentation/pages/login_page.dart';
import '../../../modules/auth/presentation/pages/register_page.dart';
import '../../../modules/auth/presentation/pages/reset_password_page.dart';
import '../../../modules/books/presentation/pages/books_page.dart';
import '../../../modules/dashboard/presentation/pages/dashboard_page.dart';
import '../../../modules/loans/presentation/pages/loans_page.dart';
import '../../../modules/profile/presentation/pages/profile_page.dart';
import '../../../modules/publishers/presentation/pages/publishers_page.dart';
import '../../../modules/users/presentation/pages/users_page.dart';
import '../../widgets/main_shell.dart';

class AppRoutes {
  static const loading = '/loading';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const profile = '/profile';
  static const loans = '/loans';
  static const users = '/users';
  static const publishers = '/publishers';
  static const books = '/books';
}

GoRouter createAppRouter({
  required AuthController authController,
  required Locale Function() getLocale,
  required ValueChanged<Locale> onLocaleChanged,
}) {
  const publicPaths = {
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
    AppRoutes.resetPassword,
  };

  const adminPaths = {
    AppRoutes.loans,
    AppRoutes.users,
    AppRoutes.publishers,
    AppRoutes.books,
  };

  return GoRouter(
    initialLocation: AppRoutes.loading,
    refreshListenable: authController,
    redirect: (context, state) {
      final path = state.uri.path;

      if (authController.isRestoring) {
        return path == AppRoutes.loading
            ? null
            : AppRoutes.loading;
      }

      if (!authController.isAuthenticated) {
        if (publicPaths.contains(path)) {
          return null;
        }

        return AppRoutes.login;
      }

      if (publicPaths.contains(path) ||
          path == AppRoutes.loading ||
          path == '/') {
        return AppRoutes.dashboard;
      }

      if (adminPaths.contains(path) &&
          authController.role != UserRole.admin) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => AppRoutes.dashboard,
      ),
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginPage(
          authController: authController,
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) =>
            const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        redirect: (context, state) {
          final token = state.extra;

          if (token is! String || token.isEmpty) {
            return AppRoutes.forgotPassword;
          }

          return null;
        },
        builder: (context, state) => ResetPasswordPage(
          token: state.extra as String,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(
          authController: authController,
          locale: getLocale(),
          onLocaleChanged: onLocaleChanged,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) =>
                const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => ProfilePage(
              authController: authController,
            ),
          ),
          GoRoute(
            path: AppRoutes.loans,
            builder: (context, state) =>
                const LoansPage(),
          ),
          GoRoute(
            path: AppRoutes.users,
            builder: (context, state) =>
                const UsersPage(),
          ),
          GoRoute(
            path: AppRoutes.publishers,
            builder: (context, state) =>
                const PublishersPage(),
          ),
          GoRoute(
            path: AppRoutes.books,
            builder: (context, state) =>
                const BooksPage(),
          ),
        ],
      ),
    ],
  );
}
