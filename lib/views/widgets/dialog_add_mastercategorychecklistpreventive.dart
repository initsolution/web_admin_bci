import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/mastercategorychecklistpreventive.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_provider.dart';

// ignore: must_be_immutable
class DialogAddMasterCategoryChecklistPreventive extends ConsumerWidget {
  final bool isEdit;
  MasterCategoryChecklistPreventive? editMasterCategoryChecklistPreventive;
  DialogAddMasterCategoryChecklistPreventive(
      {super.key,
      this.isEdit = false,
      this.editMasterCategoryChecklistPreventive});
  TextEditingController nameCategoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isEdit) {
      if (editMasterCategoryChecklistPreventive != null) {
        nameCategoryController.text =
            editMasterCategoryChecklistPreventive!.categoryName ?? '';
      }
    }
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
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
                      '${isEdit ? 'Edit' : 'New'} Master Category Checklist Preventive',
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
                const Text('Tower Category'),
                TextFormField(
                  controller: nameCategoryController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Name',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Tower Category";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        saveMasterCategoryChecklistPreventive(ref);
                        Navigator.pop(context);
                      }
                      //
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

  void saveMasterCategoryChecklistPreventive(WidgetRef ref) {
    MasterCategoryChecklistPreventive masterCategoryChecklistPreventive =
        MasterCategoryChecklistPreventive(
            categoryName: nameCategoryController.text);
    if (isEdit) {
      masterCategoryChecklistPreventive.id =
          editMasterCategoryChecklistPreventive!.id;
    }
    if (DEBUG) {
      debugPrint('site : $masterCategoryChecklistPreventive.toString()');
    }
    ref
        .read(masterCategoryChecklistPreventivNotifierProvider.notifier)
        .createOrEditMasterCategoryChecklistPreventive(
            masterCategoryChecklistPreventive, isEdit);
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
