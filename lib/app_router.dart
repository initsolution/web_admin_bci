import 'package:flutter_web_ptb/views/screens/dashboard_screen.dart';
import 'package:flutter_web_ptb/views/screens/employee_screen.dart';
import 'package:flutter_web_ptb/views/screens/error_screen.dart';
import 'package:flutter_web_ptb/views/screens/login_screen.dart';
import 'package:flutter_web_ptb/views/screens/logout_screen.dart';
import 'package:flutter_web_ptb/views/screens/site_screen.dart';
import 'package:flutter_web_ptb/views/screens/task_screen.dart';
import 'package:go_router/go_router.dart';

class RouteUri {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String myProfile = '/my-profile';
  static const String site = '/site';
  static const String employee = '/employee';
  static const String task = '/task';
  static const String logout = '/logout';
  static const String form = '/form';
  static const String generalUi = '/general-ui';
  static const String colors = '/colors';
  static const String text = '/text';
  static const String buttons = '/buttons';
  static const String dialogs = '/dialogs';
  static const String error404 = '/404';
  static const String login = '/login';
  static const String register = '/register';
  static const String crud = '/crud';
  static const String crudDetail = '/crud-detail';
  static const String iframe = '/iframe';
}

const List<String> unrestrictedRoutes = [
  RouteUri.error404,
  RouteUri.logout,
  RouteUri.login, // Remove this line for actual authentication flow.
  RouteUri.register, // Remove this line for actual authentication flow.
];

const List<String> publicRoutes = [
  // RouteUri.login, // Enable this line for actual authentication flow.
  // RouteUri.register, // Enable this line for actual authentication flow.
];

GoRouter appRouter(bool isUserLoggedIn) {
  return GoRouter(
    initialLocation: RouteUri.home,
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: const ErrorScreen(),
    ),
    routes: [
      GoRoute(
        path: RouteUri.home,
        redirect: (context, state) => RouteUri.dashboard,
      ),
      GoRoute(
        path: RouteUri.login,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.logout,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LogoutScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.dashboard,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.site,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const SiteScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.employee,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const EmployeeScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.task,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const TaskScreen(),
        ),
      ),
    ],
    redirect: (context, state) {
      if (unrestrictedRoutes.contains(state.matchedLocation)) {
        return null;
      } else if (publicRoutes.contains(state.matchedLocation)) {
        // Is public route.
        if (isUserLoggedIn) {
          // User is logged in, redirect to home page.
          return RouteUri.home;
        }
      } else {
        // Not public route.
        if (!isUserLoggedIn) {
          // User is not logged in, redirect to login page.
          return RouteUri.login;
        }
      }

      return null;
    },
  );
}
