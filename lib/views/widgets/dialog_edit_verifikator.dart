// ignore_for_file: must_be_immutable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';

class DialogEditVerifikator extends ConsumerWidget {
  Task task;
  DialogEditVerifikator({super.key, required this.task});

  Employee? selectedVerifier;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    selectedVerifier = task.verifierEmployee;
    return Center(
      child: AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Verifikator'),
                      loadVerifikatorEmployee(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton(
                          onPressed: () {
                            final isValid = _formKey.currentState!.validate();
                            debugPrint('isValid : $isValid');
                            if (isValid) {
                              editTask(ref);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('EDIT'),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void editTask(WidgetRef ref) {
    Task t = Task(
      id: task.id,
      created_at: task.created_at,
      dueDate: task.dueDate,
      submitedDate: task.submitedDate,
      verifiedDate: task.verifiedDate,
      status: task.status,
      type: task.type,
      towerCategory: task.towerCategory,
      note: task.note,
      makerEmployee: task.makerEmployee,
      site: task.site,
      verifierEmployee: selectedVerifier,
    );
    if (DEBUG) {
      debugPrint('site : ${t.toString()}');
    }
    ref.read(taskNotifierProvider.notifier).updateTask(t);
  }

  Widget loadVerifikatorEmployee() {
    return Consumer(
      builder: (context, ref, child) {
        var stateVerifikator = ref.watch(employeeNotifierProvider);
        if (stateVerifikator is EmployeeLoaded) {
          List<Employee> listMaker = [];
          for (var maker in stateVerifikator.employees) {
            if (maker.role == 'Verify') {
              listMaker.add(maker);
            }
          }
          double width = 500;
          double height = 500;
          if (listMaker.length == 1) {
            height = 160;
          } else if (listMaker.length == 2) {
            height = 210;
          } else if (listMaker.length >= 3 && listMaker.length <= 7) {
            height = ((listMaker.length - 2) * 50) + 200;
          }
          return DropdownSearch<Employee>(
            items: listMaker,
            selectedItem: selectedVerifier,
            itemAsString: (item) => item.name!,
            compareFn: (item1, item2) => item1.name == item2.name,
            onChanged: (value) {
              selectedVerifier = value!;
            },
            popupProps: PopupPropsMultiSelection.dialog(
              showSearchBox: true,
              constraints: BoxConstraints.tight(
                Size(width, height),
              ),
              itemBuilder: _customPopupItemBuilderMaker,
              // bottomSheetProps: const BottomSheetProps(elevation: 5),
              containerBuilder: (context, popupWidget) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Pilih Verifikator'),
                    Flexible(
                      child: Container(
                        child: popupWidget,
                      ),
                    ),
                  ],
                );
              },
            ),
            validator: (input) {
              if (input == null) {
                return "Please Select Verifikator Employee";
              }
              return null;
            },
            // dropdownBuilder: _customPopupItemBuilderExample,
          );
        } else if (stateVerifikator is EmployeeLoading) {
          return const CircularProgressIndicator();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _customPopupItemBuilderMaker(
      BuildContext context, Employee item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(
          item.name!,
          style: const TextStyle(fontSize: 14),
        ),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(item.avatar),
        // ),
      ),
    );
  }
}
