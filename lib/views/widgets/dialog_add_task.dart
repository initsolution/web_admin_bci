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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var stateSite = ref.watch(siteNotifierProvider);
    var stateMaker = ref.watch(employeeNotifierProvider);
    var stateVerifikator = ref.watch(employeeNotifierProvider);
    return Center(
      child: AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 1.4,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
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
                          onPressed: () {
                            final isValid = _formKey.currentState!.validate();
                            debugPrint('isValid : $isValid');
                            if (isValid) {
                              saveTask(ref);
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
    String createdDate = DateFormat('yyyy-MM-dd').format(now);
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
        compareFn: (item1, item2) => item1.isEqual(item2),
        onChanged: (value) {
          selectedSite = value!;
        },
        popupProps: PopupPropsMultiSelection.dialog(
          showSearchBox: true,
          itemBuilder: _customPopupItemBuilderSite,
          // bottomSheetProps: const BottomSheetProps(elevation: 5),
          containerBuilder: (context, popupWidget) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text('Pilih Site'),
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
            return "Please Select Site";
          }
          return null;
        },
      );
    } else if (stateSite is SiteLoading) {
      return const CircularProgressIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget _customPopupItemBuilderSite(
      BuildContext context, Site item, bool isSelected) {
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
        subtitle: Text(
          item.address!,
          style: const TextStyle(fontSize: 12),
        ),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(item.avatar),
        // ),
      ),
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

  Widget LoadMakerEmployee(var stateMaker) {
    if (stateMaker is EmployeeLoaded) {
      List<Employee> listMaker = [];
      for (var maker in stateMaker.employees) {
        if (maker.role == 'Maker') {
          listMaker.add(maker);
          // if (listMaker.length < 1) {
          //   listMaker.add(maker);
          // }
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
        itemAsString: (item) => item.name!,
        compareFn: (item1, item2) => item1.name == item2.name,
        onChanged: (value) {
          selectedMaker = value!;
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
                const Text('Pilih Maker'),
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
            return "Please Select Maker Employee";
          }
          return null;
        },
        // dropdownBuilder: _customPopupItemBuilderExample,
      );
    } else if (stateMaker is EmployeeLoading) {
      return const CircularProgressIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget LoadVerifikatorEmployee(var stateVerifikator) {
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
    List<String> listTypeTask = ['Reguler', 'Preventive'];
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
