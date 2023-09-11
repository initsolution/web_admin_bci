import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/providers/site_provider.dart';
import 'package:flutter_web_ptb/providers/site_state.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DialogAddTask extends ConsumerWidget {
  DialogAddTask({super.key});

  Site selectedSite = Site();
  Employee selectedMaker = Employee();
  Employee selectedVerifier = Employee();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var stateSite = ref.watch(siteNotifierProvider);
    var stateMaker = ref.watch(employeeNotifierProvider);
    var stateVerifikator = ref.watch(employeeNotifierProvider);
    return Center(
      child: AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'New Task',
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
                  const Text('Site'),
                  LoadSite(stateSite),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Maker'),
                  LoadMakerEmployee(stateMaker),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Verifikator'),
                  LoadVerifikatorEmployee(stateVerifikator),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Type Task'),
                  getDropDownTypeTask(),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: ElevatedButton(
                      onPressed: () => {saveTask(ref), Navigator.pop(context)},
                      child: const Text('SAVE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // actions: [ElevatedButton(onPressed: null, child: Text('Save'))],
      ),
    );
  }

  void saveTask(WidgetRef ref) {
    final String typeTask = ref.watch(typeTaskProvider);
    String status = "todo";
    DateTime now = DateTime.now();
    String createdDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    // String siteId = selectedSite.id.toString();
    // String nikMaker = selectedMaker.nik.toString();
    // String nikVerifier = selectedVerifier.nik.toString();
    // debugPrint('createdDate : $createdDate');
    // debugPrint('typeTask : $typeTask');
    // debugPrint('site : ${selectedSite.id}');
    // debugPrint('makerEmployee : ${selectedMaker.nik}');
    // debugPrint('verifierEmployee : ${selectedVerifier.nik}');
    Task task = Task(
      createdDate: createdDate,
      submitedDate: "",
      verifiedDate: "",
      status: status,
      type: typeTask,
      towerCategory: "-",
      makerEmployee: selectedMaker,
      verifierEmployee: selectedVerifier,
      site: selectedSite,
    );
    if (DEBUG) {
      debugPrint('site : ${task.toString()}');
    }
    ref.read(taskNotifierProvider.notifier).createTask(task);
  }

  Widget LoadSite(var stateSite) {
    if (stateSite is SiteLoaded) {
      List<Site> listSite = stateSite.sites;
      return DropdownSearch<Site>(
        items: listSite,
        itemAsString: (item) => item.name!,
        onChanged: (value) {
          selectedSite = value!;
        },
        popupProps: const PopupPropsMultiSelection.bottomSheet(
            bottomSheetProps: BottomSheetProps(elevation: 5)),

        // dropdownBuilder: _customPopupItemBuilderExample,
      );
    } else if (stateSite is SiteLoading) {
      return const CircularProgressIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget LoadMakerEmployee(var stateMaker) {
    if (stateMaker is EmployeeLoaded) {
      List<Employee> listMaker = stateMaker.employees;
      return DropdownSearch<Employee>(
        items: listMaker,
        itemAsString: (item) => item.name!,
        onChanged: (value) {
          selectedMaker = value!;
        },
        popupProps: const PopupPropsMultiSelection.bottomSheet(
            bottomSheetProps: BottomSheetProps(elevation: 5)),

        // dropdownBuilder: _customPopupItemBuilderExample,
      );
    } else if (stateMaker is EmployeeLoading) {
      return const CircularProgressIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget LoadVerifikatorEmployee(var stateMaker) {
    if (stateMaker is EmployeeLoaded) {
      List<Employee> listMaker = stateMaker.employees;
      return DropdownSearch<Employee>(
        items: listMaker,
        itemAsString: (item) => item.name!,
        onChanged: (value) {
          selectedVerifier = value!;
        },
        popupProps: const PopupPropsMultiSelection.bottomSheet(
            bottomSheetProps: BottomSheetProps(elevation: 5)),

        // dropdownBuilder: _customPopupItemBuilderExample,
      );
    } else if (stateMaker is EmployeeLoading) {
      return const CircularProgressIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }

  // Widget LoadVerifikatorEmployee(var stateMaker) {
  //   if (stateMaker is EmployeeLoaded) {
  //     return Autocomplete(
  //       optionsBuilder: (TextEditingValue textEditingValue) {
  //         if (textEditingValue.text == '') {
  //           return const Iterable<String>.empty();
  //         } else {
  //           List<String> matches = <String>[];
  //           matches.addAll(
  //               stateMaker.employees.map((e) => e.name.toString()).toList());

  //           matches.retainWhere((s) {
  //             return s
  //                 .toLowerCase()
  //                 .contains(textEditingValue.text.toLowerCase());
  //           });
  //           return matches;
  //         }
  //       },
  //       onSelected: (String selection) {
  //         print('You just selected $selection');
  //       },
  //       fieldViewBuilder: (BuildContext context,
  //           TextEditingController textEditingController,
  //           FocusNode focusNode,
  //           VoidCallback onFieldSubmitted) {
  //         return TextField(
  //           decoration: const InputDecoration(border: OutlineInputBorder()),
  //           controller: textEditingController,
  //           focusNode: focusNode,
  //           onSubmitted: (String value) {
  //             print('you select $value');
  //           },
  //         );
  //       },
  //       optionsViewBuilder: (BuildContext context,
  //           void Function(String) onSelected, Iterable<String> options) {
  //         return Material(
  //           child: SizedBox(
  //             height: 100,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: options.map((opt) {
  //                   return InkWell(
  //                       onTap: () {
  //                         onSelected(opt);
  //                       },
  //                       child: Container(
  //                           padding: const EdgeInsets.only(right: 60),
  //                           child: Card(
  //                               child: Container(
  //                             width: double.infinity,
  //                             padding: const EdgeInsets.all(10),
  //                             child: Text(opt),
  //                           ))));
  //                 }).toList(),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   } else if (stateMaker is EmployeeLoading) {
  //     return const CircularProgressIndicator();
  //   } else {
  //     return const CircularProgressIndicator();
  //   }
  // }

  Widget getDropDownTypeTask() {
    List<String> listTypeTask = ['Regular', 'Preventive'];
    return Consumer(builder: (_, WidgetRef ref, __) {
      final String typeTask = ref.watch(typeTaskProvider);
      return DropdownButton(
        value: typeTask.isNotEmpty ? typeTask : null,
        onChanged: (value) {
          ref.read(typeTaskProvider.notifier).state = value!;
        }, // =========== Here the error occurs ==========================
        items: listTypeTask.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }
}
