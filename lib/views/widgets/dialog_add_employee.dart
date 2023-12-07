import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';

// ignore: must_be_immutable
class DialogAddEmployee extends ConsumerWidget {
  final bool isEdit;
  Employee? editEmployee;
  DialogAddEmployee({super.key, this.isEdit = false, this.editEmployee});
  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController instansiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isEdit) {
      if (editEmployee != null) {
        nikController.text = editEmployee!.nik ?? '';
        nameController.text = editEmployee!.name ?? '';
        emailController.text = editEmployee!.email ?? '';
        phoneController.text = editEmployee!.hp ?? '';
        instansiController.text = editEmployee!.instansi ?? '';
        if (editEmployee!.role!.toLowerCase() != 'superadmin') {
          Future(() => ref.read(employeeRoleProvider.notifier).state =
              editEmployee!.role ?? '');
        }
        String isVendor =
            editEmployee!.isVendor! == true ? 'Vendor' : 'Internal';
        Future(
            () => ref.read(employeeVendorProvider.notifier).state = isVendor);
      }
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
                    Text(
                      '${isEdit ? 'Edit' : 'New'} Employee',
                      style: const TextStyle(fontSize: 30),
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
                const Text('NIK'),
                TextFormField(
                  controller: nikController,
                  keyboardType: TextInputType.text,
                  enabled: !isEdit,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Please type your NIK',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input NIK";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('NAME'),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Please type your NAME',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input NAME";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('EMAIL'),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Please type your EMAIL',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input EMAIL";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Password'),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Please type your Password',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Phone Number'),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Please type your Phone Number',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Phone Number";
                    }
                    return null;
                  },
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
                          const Text('Vendor'),
                          getDropdownVendor(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: instansiController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Instansi',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Instansi";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        saveEmployee(ref);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(isEdit ? 'EDIT' : 'SAVE'),
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

  void saveEmployee(WidgetRef ref) {
    final String employeeRole = ref.watch(employeeRoleProvider);
    final String employeeVendor = ref.watch(employeeVendorProvider);
    Employee employee = Employee(
        nik: nikController.text,
        name: nameController.text,
        email: emailController.text,
        hp: phoneController.text,
        password: passwordController.text,
        role: employeeRole,
        isActive: true,
        isVendor: employeeVendor == 'Vendor' ? true : false,
        instansi: instansiController.text);
    if (isEdit) {
      ref
          .read(employeeNotifierProvider.notifier)
          .updateEmployeeWithFile(employee: employee, file: null);
    } else {
      ref.read(employeeNotifierProvider.notifier).createEmployee(employee);
    }
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
}
