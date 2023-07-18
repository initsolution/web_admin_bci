import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/providers/app_preferences_provider.dart';
import 'package:flutter_web_ptb/providers/user_data_provider.dart';
import 'package:flutter_web_ptb/theme/theme.dart';
import 'package:flutter_web_ptb/utils/app_focus_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  GoRouter? _appRouter;

  Future<bool>? _future;

  Future<bool> _getScreenDataAsync(
      AppPreferencesProvider appPreferencesProvider,
      UserDataProvider userDataProvider) async {
    await appPreferencesProvider.loadAsync();
    await userDataProvider.loadAsync();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppPreferencesProvider()),
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
      ],
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              // Tap anywhere to dismiss soft keyboard.
              AppFocusHelper.instance.requestUnfocus();
            },
            child: FutureBuilder<bool>(
              initialData: null,
              future: (_future ??= _getScreenDataAsync(
                  context.read<AppPreferencesProvider>(),
                  context.read<UserDataProvider>())),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  return Consumer<AppPreferencesProvider>(
                    builder: (context, provider, child) {
                      _appRouter ??=
                          appRouter(context.read<UserDataProvider>());

                      return MaterialApp.router(
                        debugShowCheckedModeBanner: false,
                        routeInformationProvider:
                            _appRouter!.routeInformationProvider,
                        routeInformationParser:
                            _appRouter!.routeInformationParser,
                        routerDelegate: _appRouter!.routerDelegate,
                        // supportedLocales: Lang.delegate.supportedLocales,
                        // localizationsDelegates: const [
                        //   Lang.delegate,
                        //   GlobalMaterialLocalizations.delegate,
                        //   GlobalWidgetsLocalizations.delegate,
                        //   GlobalCupertinoLocalizations.delegate,
                        //   FormBuilderLocalizations.delegate,
                        // ],
                        locale: provider.locale,
                        onGenerateTitle: (context) => 'Web Admin',
                        theme: AppThemeData.instance.light(),
                        darkTheme: AppThemeData.instance.dark(),
                        themeMode: provider.themeMode,
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
