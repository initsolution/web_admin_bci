import 'package:flutter_web_ptb/model/categorychecklistpreventive.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/views/screens/asset_screen.dart';
import 'package:flutter_web_ptb/views/screens/dashboard_detail_screen.dart';
import 'package:flutter_web_ptb/views/screens/dashboard_screen.dart';
import 'package:flutter_web_ptb/views/screens/employee_screen.dart';
import 'package:flutter_web_ptb/views/screens/error_screen.dart';
import 'package:flutter_web_ptb/views/screens/login_screen.dart';
import 'package:flutter_web_ptb/views/screens/logout_screen.dart';
import 'package:flutter_web_ptb/views/screens/masterasset_screen.dart';
import 'package:flutter_web_ptb/views/screens/mastercategorychecklistpreventive_screen.dart';
import 'package:flutter_web_ptb/views/screens/masterpointchecklistpreventive_screen.dart';
import 'package:flutter_web_ptb/views/screens/masterreportregulertorque_screen.dart';
import 'package:flutter_web_ptb/views/screens/result_asset_screen.dart';
import 'package:flutter_web_ptb/views/screens/site_screen.dart';
import 'package:flutter_web_ptb/views/screens/site_task_reguler_screen.dart';
import 'package:flutter_web_ptb/views/screens/task_screen.dart';
import 'package:flutter_web_ptb/views/screens/tenant_screen.dart';
import 'package:flutter_web_ptb/views/widgets/report_preventive_widget.dart';
import 'package:go_router/go_router.dart';

class RouteUri {
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String detailDashboard = '/detail-dashboard';
  static const String myProfile = '/my-profile';
  static const String site = '/site';
  static const String siteTask = '/sitetask';
  static const String employee = '/employee';
  static const String tenant = '/tenant';
  static const String masterAsset = '/masterasset';
  static const String masterCategoryChecklistPreventive =
      '/mastercategorychecklistpreventive';
  static const String masterReportRegulerTorque = '/masterReportRegulerTorque';
  static const String task = '/task';
  static const String logout = '/logout';
  static const String error404 = '/404';
  static const String login = '/login';
  static const String masterPointChecklistPreventive =
      '/masterPointChecklistPreventive';
  static const String asset = '/asset';
  static const String resultAsset = '/result-asset';
  static const String reportChecklist = '/report-checklist';
  static const String reportTorque = '/report-torque';
  static const String reportVerticality = '/report-verticality';
  // static const String form = '/form';
  // static const String generalUi = '/general-ui';
  // static const String colors = '/colors';
  // static const String text = '/text';
  // static const String buttons = '/buttons';
  // static const String dialogs = '/dialogs';
  // static const String register = '/register';
  // static const String crud = '/crud';
  // static const String crudDetail = '/crud-detail';
  // static const String iframe = '/iframe';
}

const List<String> unrestrictedRoutes = [
  RouteUri.error404,
  RouteUri.logout,
  RouteUri.login, // Remove this line for actual authentication flow.
  // RouteUri.register, // Remove this line for actual authentication flow.
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
        path: RouteUri.detailDashboard,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const DashboardDetailScreen(),
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
        path: RouteUri.siteTask,
        pageBuilder: (context, state) {
          Site site = state.extra as Site;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: SiteTaskRegulerScreen(site: site),
          );
        },
      ),
      GoRoute(
        path: RouteUri.employee,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const EmployeeScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.tenant,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const TenantScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.masterAsset,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MasterAssetScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.masterCategoryChecklistPreventive,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MasterCategoryChecklistPreventiveScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.masterReportRegulerTorque,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MasterReportRegulerTorqueScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.task,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const TaskScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.masterPointChecklistPreventive,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const MasterPointChecklistPreventiveScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.asset,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const AssetScreen(),
        ),
      ),
      GoRoute(
        path: RouteUri.resultAsset,
        pageBuilder: (context, state) {
          Task task = state.extra as Task;
          return NoTransitionPage<void>(
              key: state.pageKey,
              child: ResultAssetScreen(
                task: task,
              ));
        },
      ),
      GoRoute(
        path: RouteUri.reportChecklist,
        pageBuilder: (context, state) {
          List<CategoryChecklistPreventive> report =
              state.extra as List<CategoryChecklistPreventive>;
          return NoTransitionPage<void>(
              key: state.pageKey,
              child:
                  ReportPreventiveWidget(categoryChecklistPreventives: report));
        },
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
