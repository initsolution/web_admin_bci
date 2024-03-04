import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme.dart';
import 'package:flutter_web_ptb/utils/app_focus_helper.dart';
import 'package:flutter_web_ptb/utils/custom_scrollbar.dart';
import 'package:go_router/go_router.dart';

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

  Future<void> _getDataAsync() async {
    await ref.read(userDataProvider.notifier).loadAsync();
  }

  @override
  Widget build(BuildContext context) {
    _getDataAsync();

    var isUserLoggedIn = ref
        .watch(userDataProvider.select((value) => value.username.isNotEmpty));
    _appRouter = appRouter(isUserLoggedIn);
    return GestureDetector(
        onTap: () {
          // Tap anywhere to dismiss soft keyboard.
          AppFocusHelper.instance.requestUnfocus();
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          routeInformationProvider: _appRouter!.routeInformationProvider,
          routeInformationParser: _appRouter!.routeInformationParser,
          routerDelegate: _appRouter!.routerDelegate,
          onGenerateTitle: (context) => 'SIMBA',
          theme: AppThemeData.instance.light(),
        ));
  }
}
