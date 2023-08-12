import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_color_scheme.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:flutter_web_ptb/views/widgets/public_master_layout/public_master_layout.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final userDataProvider = context.read<UserDataProvider>();
    var isUserLoggedIn = ref.watch(userDataProvider.select((value) => value.username.isNotEmpty));

    if (isUserLoggedIn) {
      return PortalMasterLayout(
        body: _content(context),
      );
    } else {
      return PublicMasterLayout(
        body: _content(context),
      );
    }
  }

  Widget _content(BuildContext context) {
    // final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;

    return ListView(
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: kDefaultPadding * 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: kDefaultPadding),
                child: Text(
                  '404',
                  style: themeData.textTheme.displayMedium!.copyWith(
                    color: appColorScheme.warning,
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 0.5),
                      child: Text(
                        'Page not found',
                        style: themeData.textTheme.titleLarge!.copyWith(
                          color: appColorScheme.warning,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                      child: Text('Page not found'),
                    ),
                    SizedBox(
                      height: 36.0,
                      width: 100.0,
                      child: ElevatedButton(
                        onPressed: () => GoRouter.of(context).go(RouteUri.home),
                        child: const Text('Home'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
