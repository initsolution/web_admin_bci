import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends ConsumerStatefulWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends ConsumerState<LogoutScreen> {
  Future<void> _doLogoutAsync({
    required VoidCallback onSuccess,
  }) async {
    await ref.read(userDataProvider.notifier).clearUserDataAsync();

    onSuccess.call();
  }

  void _onLogoutSuccess(BuildContext context) {
    GoRouter.of(context).go(RouteUri.login);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Clear local user data and redirect to login screen.
      await (_doLogoutAsync(
        onSuccess: () => _onLogoutSuccess(context),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
