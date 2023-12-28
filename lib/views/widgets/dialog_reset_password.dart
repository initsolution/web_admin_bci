import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';

// ignore: must_be_immutable
class DialogResetPassword extends ConsumerWidget {
  DialogResetPassword({super.key});
  TextEditingController resetPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(employeeNotifierProvider, (previous, next) {
      if (next is EmployeeErrorServer) {
        if (next.statusCode == 404) {
          final message = next.message.toString();
          messageDialog(context, message);
        }
      } else if (next is EmployeeResetPassword) {
        final message = next.message.toString();
        messageDialog(context, message);
      }
    });
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 30),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('Email'),
                TextFormField(
                  controller: resetPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please input your Email',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input your Email";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        // Navigator.pop(context);
                        var email = resetPasswordController.text;
                        ref
                            .read(employeeNotifierProvider.notifier)
                            .resetDataPassword(email);
                      }
                    },
                    child: const Text('Send'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  messageDialog(context, message) {
    Widget closeButton = TextButton(
      child: const Text("Close"),
      onPressed: () {
        dismissDialog(context);
        dismissDialog(context);
      },
    );
    AlertDialog alert = AlertDialog(
      elevation: 0,
      title: const Text('Information'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Text(message),
      ),
      actions: [closeButton],
    );
    showDialog(
      //prevent outside touch
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        //prevent Back button press
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  dismissDialog(context) {
    Navigator.pop(context);
  }
}
