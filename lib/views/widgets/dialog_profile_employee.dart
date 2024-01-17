// ignore_for_file: must_be_immutable

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:go_router/go_router.dart';

class DialogProfileEmployee extends ConsumerStatefulWidget {
  const DialogProfileEmployee({super.key});

  @override
  ConsumerState<DialogProfileEmployee> createState() =>
      _DialogProfileEmployee();
}

class _DialogProfileEmployee extends ConsumerState<DialogProfileEmployee> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    // String token = ref.watch(userDataProvider.select((value) => value.token));
    // Employee employee = Employee.fromMap(JwtDecoder.decode(token)['employee']);
    ref.listen(employeeNotifierProvider, (previous, next) {
      if (next is EmployeeErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is EmployeeDataChangeSuccess) {
        ref.read(employeeNotifierProvider.notifier).getAllEmployee();
        Navigator.pop(context);
      }
    });

    return Consumer(builder: (context, ref, child) {
      var state = ref.watch(employeeNotifierProvider);
      if (state is EmployeeGotOne) {
        Employee employee = state.employee;
        TextEditingController nikController =
            TextEditingController(text: employee.nik);
        TextEditingController nameController =
            TextEditingController(text: employee.name);
        TextEditingController emailController =
            TextEditingController(text: employee.email);
        TextEditingController passwordController = TextEditingController();
        TextEditingController phoneController =
            TextEditingController(text: employee.hp);
        return AlertDialog(
          content: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile ${nameController.text}',
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
                      obscureText: true,
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
                    const Text('E-Sign'),
                    Column(
                      children: [
                        result != null
                            ? Container()
                            : employee.urlEsign != null
                                ? Image.network(
                                    '$urlRepo/employee/getImage/${employee.nik}',
                                    width: 100,
                                    height: 100,
                                  )
                                : const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            pickFile();
                          },
                          child: result != null
                              ? Container(
                                  height: 500.0,
                                  width: 500.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5.00),
                                  ),
                                  child:
                                      Image.memory(result!.files.first.bytes!),
                                )
                              : Center(
                                  child: Container(
                                    height: 200.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5.00),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ElevatedButton(
                        onPressed: () => {
                          editEmployee(ref,
                              nikController: nikController,
                              nameController: nameController,
                              emailController: emailController,
                              phoneController: phoneController,
                              passwordController:
                                  passwordController.value.toString().isNotEmpty
                                      ? passwordController
                                      : null,
                              employeeOri: employee),
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              )),
        );
      } else if (state is EmployeeLoading) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Container();
    });
  }

  void editEmployee(WidgetRef ref,
      {required TextEditingController nikController,
      required TextEditingController nameController,
      required TextEditingController emailController,
      required TextEditingController phoneController,
      TextEditingController? passwordController,
      required Employee employeeOri}) {
    // debugPrint('ori : ${employeeOri.toString()}');
    Employee employee = Employee(
        nik: nikController.text,
        name: nameController.text,
        email: emailController.text,
        hp: phoneController.text,
        password: passwordController!.text == '' ? '' : passwordController.text,
        instansi: employeeOri.instansi,
        isActive: employeeOri.isActive,
        role: employeeOri.role,
        isVendor: employeeOri.isVendor);
    debugPrint(employee.toString());
    if (result != null) {
      ref.read(employeeNotifierProvider.notifier).updateEmployeeWithFile(
          employee: employee, file: result!.files.first.bytes);
    } else {
      employee.urlEsign = employeeOri.urlEsign!;
      ref
          .read(employeeNotifierProvider.notifier)
          .updateEmployeeWithFile(employee: employee, file: null);
    }
  }

  void pickFile() async {
    await FilePicker.platform.pickFiles(
      dialogTitle: 'Get E-Sign',
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) {
        if (status == FilePickerStatus.done) {
          debugPrint('finish pick');
          // ref.read(backgroundIsDonePickFile.notifier).state = true;
          // context
          //     .read<BackgroundBloc>()
          //     .add(SetStatusPickFileBackground(statusPick: true));
        }
      },
      allowedExtensions: ['png'],
    ).then((value) {
      if (value != null) {
        setState(() {
          result = value;
        });
      }
    });
  }
}
