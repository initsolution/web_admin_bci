import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/tenant.dart';
import 'package:flutter_web_ptb/providers/tenant_provider.dart';

// ignore: must_be_immutable
class DialogEditTenant extends ConsumerWidget {
  Tenant? tenant;
  DialogEditTenant({super.key, required this.tenant});
  TextEditingController tenantKodeController = TextEditingController();
  TextEditingController tenantNameController = TextEditingController();
  bool isActive = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tenant != null) {
      tenantKodeController.text = tenant!.kodeTenant!;
      tenantNameController.text = tenant!.name!;
      isActive = tenant!.isActive!;
      Future(() => ref.read(tenantIsActiveProvider.notifier).state = isActive);
    }
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
                      'Edit Tenant',
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
                        Navigator.of(context, rootNavigator: true).pop();
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
    Tenant t = Tenant(
      id: tenant!.id,
      kodeTenant: tenantKodeController.text,
      name: tenantNameController.text,
      isActive: isActive,
    );
    if (DEBUG) {
      debugPrint('site : $t.toString()');
    }
    ref.read(tenantNotifierProvider.notifier).updateTenant(t);
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
