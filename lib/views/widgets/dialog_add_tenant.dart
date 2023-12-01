import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/tenant.dart';
import 'package:flutter_web_ptb/providers/tenant_provider.dart';

// ignore: must_be_immutable
class DialogAddTenant extends ConsumerWidget {
  DialogAddTenant({super.key});
  TextEditingController tenantKodeController = TextEditingController();
  TextEditingController tenantNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      'New Tenant',
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
                const Text('Kode'),
                TextFormField(
                  controller: tenantKodeController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Kode',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Kode Tenant";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Name'),
                TextFormField(
                  controller: tenantNameController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Name',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('isActive'),
                isActiveTenant(),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        saveTenant(ref);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('SAVE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // actions: [ElevatedButton(onPressed: null, child: Text('Save'))],
    );
  }

  void saveTenant(WidgetRef ref) {
    final bool isActive = ref.watch(tenantIsActiveProvider);
    Tenant tenant = Tenant(
      kodeTenant: tenantKodeController.text,
      name: tenantNameController.text,
      isActive: isActive,
    );
    if (DEBUG) {
      debugPrint('site : $tenant.toString()');
    }
    ref.read(tenantNotifierProvider.notifier).createTenant(tenant);
  }

  Widget isActiveTenant() {
    return Consumer(builder: (_, WidgetRef ref, __) {
      final bool isActive = ref.watch(tenantIsActiveProvider);
      return Switch(
        // This bool value toggles the switch.
        value: isActive,
        activeColor: Colors.blue,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          ref.read(tenantIsActiveProvider.notifier).state = value;
        },
      );
    });
  }

  // Widget getDropdownRole() {
  //   List<String> dataRole = ['Maker', 'Verify', 'Admin'];
  //   return Consumer(builder: (_, WidgetRef ref, __) {
  //     final String employeeRole = ref.watch(employeeRoleProvider);
  //     return DropdownButton(
  //       value: employeeRole.isNotEmpty ? employeeRole : null,
  //       onChanged: (value) =>
  //           ref.read(employeeRoleProvider.notifier).state = value!,
  //       items: dataRole.map<DropdownMenuItem<String>>((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(value),
  //         );
  //       }).toList(),
  //     );
  //   });
  // }

  // Widget getDropdownActive() {
  //   String? initialVal = "Vendor";
  //   // var func;

  //   return DropdownButton(
  //     value: initialVal,
  //     onChanged: (value) {
  //       debugPrint(value);
  //     }, // =========== Here the error occurs ==========================
  //     items: <String>['Vendor', 'Internal']
  //         .map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //   );
  // }
}
