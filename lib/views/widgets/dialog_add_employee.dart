import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';

class DialogAddEmployee extends ConsumerWidget {
  DialogAddEmployee({super.key});
  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('New Employee'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('NIK'),
              TextField(
                controller: nikController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Please type your NIK',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('NAME'),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Please type your NAME',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('EMAIL'),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Please type your EMAIL',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Password'),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Please type your Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Phone Number'),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Please type your Phone Number',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Role'),
                        getDropdownRole(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Active'),
                        getDropdownActive(),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => saveEmployee(ref),
                child: Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
      // actions: [ElevatedButton(onPressed: null, child: Text('Save'))],
    );
  }

  void saveEmployee(WidgetRef ref) {
    final String employeeRole = ref.watch(employeeRoleProvider);
    Employee employee = Employee(
        nik: nikController.text,
        name: nameController.text,
        email: emailController.text,
        hp: phoneController.text,
        password: passwordController.text,
        role: employeeRole,
        is_active: 1,
        is_vendor: 0);
    ref.read(employeeNotifierProvider.notifier).createEmployee(employee);
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

  Widget getDropdownActive() {
    String? initialVal = "Vendor";
    // var func;

    return DropdownButton(
      value: initialVal,
      onChanged: (value) {
        debugPrint(value);
      }, // =========== Here the error occurs ==========================
      items: <String>['Vendor', 'Internal']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
