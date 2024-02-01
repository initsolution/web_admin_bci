import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/model/masterasset.dart';
import 'package:flutter_web_ptb/providers/masterasset_provider.dart';

// ignore: must_be_immutable
class DialogAddOrEditMasterAsset extends ConsumerWidget {
  final bool isEdit;
  MasterAsset? masterAsset;
  DialogAddOrEditMasterAsset(
      {super.key, this.isEdit = false, this.masterAsset});
  TextEditingController taskTypeController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController fabricatorController = TextEditingController();
  TextEditingController towerHeightController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isEdit) {
      if (masterAsset != null) {
        taskTypeController.text = masterAsset!.taskType ?? '';
        sectionController.text = masterAsset!.section ?? '';
        fabricatorController.text = masterAsset!.fabricator ?? '';
        towerHeightController.text = masterAsset!.towerHeight.toString();
        categoryController.text = masterAsset!.category ?? '';
        descriptionController.text = masterAsset!.description ?? '';
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
                      '${(isEdit ? 'Edit' : 'New')} Master Asset',
                      style: const TextStyle(fontSize: 30),
                    ),
                    IconButton(splashRadius: 20,
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
                const Text('Task Type'),
                TextFormField(
                  controller: taskTypeController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Task Type',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Task Type";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Section'),
                TextFormField(
                  controller: sectionController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Section',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Section";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Fabricator'),
                TextFormField(
                  controller: fabricatorController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Fabricator',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Fabricator";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Tower Height'),
                TextFormField(
                  controller: towerHeightController,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Tower Height',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Tower Height";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Category'),
                TextFormField(
                  controller: categoryController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Category',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Category";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Description'),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Description',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Description";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        saveMasterAsset(ref);
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

  void saveMasterAsset(WidgetRef ref) {
    MasterAsset masterAssetSaveEdit = MasterAsset(
      taskType: taskTypeController.text,
      section: sectionController.text,
      fabricator: fabricatorController.text,
      category: categoryController.text,
      towerHeight: int.parse(towerHeightController.text),
      description: descriptionController.text,
    );
    if (isEdit) {
      masterAssetSaveEdit.id = masterAsset!.id;
    }
    // debugPrint('before sent ${masterAssetSaveEdit.toString()}');
    ref
        .read(masterAssetNotifierProvider.notifier)
        .createOrEditMasterAsset(masterAssetSaveEdit, isEdit);
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
