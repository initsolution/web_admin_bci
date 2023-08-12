import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme.dart';
import 'package:flutter_web_ptb/utils/app_focus_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RootApp extends ConsumerStatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  ConsumerState<RootApp> createState() => _RootAppState();
}

class _RootAppState extends ConsumerState<RootApp> {
  GoRouter? _appRouter;

  // Future<bool>? _future;

  // Future<bool> _getScreenDataAsync(
  //     AppPreferencesProvider appPreferencesProvider,
  //     UserDataProvider userDataProvider) async {
  //   await appPreferencesProvider.loadAsync();
  //   await userDataProvider.loadAsync();

  //   return true;
  // }

  Future<bool> _getDataAsync() async {
    await ref.read(userDataProvider.notifier).loadAsync();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _getDataAsync();
    var isUserLogin = ref.read(userDataProvider.notifier).isUserLoggedIn();
    _appRouter = appRouter(isUserLogin);
    return GestureDetector(
        onTap: () {
          // Tap anywhere to dismiss soft keyboard.
          AppFocusHelper.instance.requestUnfocus();
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationProvider: _appRouter!.routeInformationProvider,
          routeInformationParser: _appRouter!.routeInformationParser,
          routerDelegate: _appRouter!.routerDelegate,
          onGenerateTitle: (context) => 'Web Admin',
          theme: AppThemeData.instance.light(),
        ));
  }
}
