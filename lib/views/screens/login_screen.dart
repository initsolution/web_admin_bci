import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_button_theme.dart';
import 'package:flutter_web_ptb/views/widgets/public_master_layout/public_master_layout.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();

  final _isFormLoading = false;

  _doLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed.
      _formKey.currentState!.save();
      ref
          .read(employeeNotifierProvider.notifier)
          .loginEmployee(_formData.username, _formData.password);
      // setState(() => _isFormLoading = false);
    }
  }

  Future<void> _loginAsync({
    required response,
    required VoidCallback onSuccess,
    required void Function(String message) onError,
  }) async {
    String message = response['message'];
    int statusCode = response['statusCode'];

    if (statusCode == 202) {
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(message)['employee'];
      // bool isTokenExpired = JwtDecoder.isExpired(message);
      if (DEBUG) {
        debugPrint('decode token : $decodedToken');
      }
      var email = decodedToken['email'];
      await ref.read(userDataProvider.notifier).setUserDataAsync(
            username: email,
            token: message,
          );
      onSuccess.call();
    } else {
      onError.call(message);
    }
  }

  void _onLoginSuccess(BuildContext context) {
    GoRouter.of(context).go(RouteUri.home);
  }

  void _onLoginError(BuildContext context, String message) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      desc: message,
      width: kDialogWidth,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    );

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    ref.listen<EmployeeState>(employeeNotifierProvider, (prev, next) {
      debugPrint(
          'state prev : ${prev.toString()} state next: ${next.toString()}');
      if (next is EmployeeLoginHTTPResponse) {
        //status code 404 -> user tidak ditemukan
        //status code 401 -> password salah
        //status code 202 -> betul
        // String message = next.httpResponse.data['message'];
        // int statusCode = next.httpResponse.data['statusCode'];

        // debugPrint(next.httpResponse.data.toString());
        // debugPrint('message : $message status code : $statusCode');

        // if (statusCode == 202) {
        // debugPrint('masuk if');
        // token di var message
        // GoRouter.of(context).go(RouteUri.home);
        _loginAsync(
          onSuccess: () => _onLoginSuccess(context),
          onError: (message) => _onLoginError(context, message),
          response: next.httpResponse.data,
        );
        // } else {
        // debugPrint('masuk else');
        // tampilkan message error
        // }
      }
    });
    return PublicMasterLayout(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(top: kDefaultPadding * 5.0),
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        height: 80.0,
                      ),
                    ),
                    Text(
                      'Web App',
                      style: themeData.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: Text(
                        'Admin Portal Login',
                        style: themeData.textTheme.titleMedium,
                      ),
                    ),
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'username',
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Email',
                                // helperText: '* Demo username: admin',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) =>
                                  (_formData.username = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: kDefaultPadding * 2.0),
                            child: FormBuilderTextField(
                              name: 'password',
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Password',
                                // helperText: '* Demo password: admin',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              obscureText: true,
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) =>
                                  (_formData.password = value ?? ''),
                              onSubmitted: (value) {
                                // debugPrint('on submit');
                                _doLogin();
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: kDefaultPadding),
                            child: SizedBox(
                              height: 40.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: themeData
                                    .extension<AppButtonTheme>()!
                                    .primaryElevated,
                                onPressed:
                                    (_isFormLoading ? null : () => _doLogin()),
                                child: const Text('Login'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormData {
  String username = '';
  String password = '';
}
