import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';

class DialogFilterEmployee extends ConsumerWidget {
  const DialogFilterEmployee({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.invalidate(employeeVendorProvider);
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      bool resVendor = ref
                                  .read(employeeVendorProvider.notifier)
                                  .state
                                  .toLowerCase() ==
                              'vendor'
                          ? true
                          : false;
                      final String employeeRole =
                          ref.watch(employeeRoleProvider);
                      List<String> dataFilter = [];
                      dataFilter.add('isVendor||eq||$resVendor');
                      dataFilter.add('role||eq||$employeeRole');
                      ref
                          .read(employeeNotifierProvider.notifier)
                          .getAllEmployee(header: {'filter': dataFilter});
                      ref.invalidate(employeeVendorProvider);
                      ref.invalidate(employeeNotifierProvider);

                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              Row(
                children: [
                  const Text('Is Vendor ? '),
                  const SizedBox(
                    width: 10,
                  ),
                  getDropdownVendor(),
                ],
              ),
              Row(
                children: [
                  const Text('Role '),
                  const SizedBox(
                    width: 10,
                  ),
                  getDropdownRole(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getDropdownVendor() {
    List<String> dataVendor = ['Internal', 'Vendor'];
    return Consumer(builder: (_, WidgetRef ref, __) {
      final String employeeVendor = ref.watch(employeeVendorProvider);
      return DropdownButton(
        value: employeeVendor.isNotEmpty ? employeeVendor : null,
        onChanged: (value) {
          ref.read(employeeVendorProvider.notifier).state = value!;
        }, // =========== Here the error occurs ==========================
        items: dataVendor.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }

  Widget getDropdownRole() {
    List<String> dataRole = ['Maker', 'Verify', 'Admin'];
    return Consumer(builder: (_, WidgetRef ref, __) {
      final String employeeRole = ref.watch(employeeRoleProvider);
      return DropdownButton(
        value: employeeRole.isNotEmpty ? employeeRole : null,
        onChanged: (value) =>
            ref.read(employeeRoleProvider.notifier).state = value!,
        items: dataRole.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }
}
