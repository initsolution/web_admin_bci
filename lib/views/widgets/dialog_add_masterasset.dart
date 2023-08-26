import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/masterasset.dart';
import 'package:flutter_web_ptb/providers/masterasset_provider.dart';

// ignore: must_be_immutable
class DialogAddMasterAsset extends ConsumerWidget {
  DialogAddMasterAsset({super.key});
  TextEditingController towerCategoryController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
                  const Text(
                    'New Master Asset',
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
              const Text('Tower Category'),
              TextField(
                controller: towerCategoryController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Tower Category',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Category'),
              TextField(
                controller: categoryController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Category',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Description'),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Description',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () => {
                    saveMasterAsset(ref),
                    Navigator.pop(context),
                  },
                  child: const Text('SAVE'),
                ),
              ),
            ],
          ),
        ),
      ),
      // actions: [ElevatedButton(onPressed: null, child: Text('Save'))],
    );
  }

  void saveMasterAsset(WidgetRef ref) {
    MasterAsset masterAsset = MasterAsset(
      tower_category: towerCategoryController.text,
      category: categoryController.text,
      description: descriptionController.text,
    );
    if (DEBUG) {
      debugPrint('site : $masterAsset.toString()');
    }
    ref.read(masterAssetNotifierProvider.notifier).createMasterAsset(masterAsset);
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
