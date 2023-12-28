import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
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
  final bool isCanEditSite;
  DialogAddTask({super.key, this.selectedSite, this.isCanEditSite = true});

  Site? selectedSite;
  Employee? selectedMaker;
  Employee? selectedVerifier;
  final _formKey = GlobalKey<FormState>();
  TextEditingController dueDateInput = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          // height: MediaQuery.of(context).size.height / 1.4,
          child: SingleChildScrollView(
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
                          'Create Task',
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
                    const SizedBox(height: 15),
                    const Text('Site'),
                    loadSite(),
                    const SizedBox(height: 10),
                    const Text('Maker'),
                    loadMakerEmployee(),
                    const SizedBox(height: 10),
                    const Text('Verifikator'),
                    loadVerifikatorEmployee(),
                    const SizedBox(height: 10),
                    const Text('Type Task'),
                    getDropDownTypeTask(),
                    const SizedBox(height: 10),
                    dueDateTask(context),
                    const SizedBox(height: 20),
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
        // actions: [ElevatedButton(onPressed: null, child: Text('Save'))],
      ),
    );
  }

  void saveTask(WidgetRef ref) {
    // if(selectedSite == null || selectedMaker == null || selectedVerifier == null)
    // return
    final String typeTask = ref.watch(typeTaskProvider);
    String status = "todo";
    DateTime now = DateTime.now();
    String dueDate = ref.watch(dueDateTaskProvider);
    // String siteId = selectedSite.id.toString();
    // String nikMaker = selectedMaker.nik.toString();
    // String nikVerifier = selectedVerifier.nik.toString();
    // debugPrint('createdDate : $createdDate');
    // debugPrint('typeTask : $typeTask');
    // debugPrint('site : ${selectedSite.id}');
    // debugPrint('makerEmployee : ${selectedMaker.nik}');
    // debugPrint('verifierEmployee : ${selectedVerifier.nik}');
    Task task = Task(
      dueDate: dueDate,
      submitedDate: "",
      verifiedDate: "",
      status: status,
      type: typeTask,
      towerCategory: "-",
      makerEmployee: selectedMaker,
      verifierEmployee: selectedVerifier,
      site: selectedSite,
      created_at: DateFormat('yyyy-MM-dd').format(now),
    );
    if (DEBUG) {
      debugPrint('site : ${task.toString()}');
    }
    ref.read(taskNotifierProvider.notifier).createTask(task);
  }

  Widget loadSite() {
    if (isCanEditSite) {
      return Consumer(
        builder: (context, ref, child) {
          var stateSite = ref.watch(siteNotifierProvider);
          if (stateSite is SiteLoaded) {
            List<Site> listSite = stateSite.sites;
            return DropdownSearch<Site>(
              // enabled: isCanEditSite,
              // selectedItem: selectedSite,
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
        },
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black26),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(selectedSite?.name ?? ""),
      );
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

  Widget dueDateTask(BuildContext context) {
    return Consumer(builder: (_, WidgetRef ref, __) {
      final String dueDate = ref.watch(dueDateTaskProvider);
      dueDateInput.text = dueDate;
      return TextField(
        controller: dueDateInput,
        decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today), labelText: "Enter Due Date"),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2200));
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            ref.read(dueDateTaskProvider.notifier).state = formattedDate;
          }
        },
      );
    });
  }

  Widget loadMakerEmployee() {
    return Consumer(
      builder: (context, ref, child) {
        var stateMaker = ref.watch(employeeNotifierProvider);
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
      },
    );
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
