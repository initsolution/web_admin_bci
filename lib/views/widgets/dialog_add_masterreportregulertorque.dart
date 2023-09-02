import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/masterreportregulertorque.dart';
import 'package:flutter_web_ptb/providers/masterreportregulertorque_provider.dart';

// ignore: must_be_immutable
class DialogAddMasterReportRegulerTorque extends ConsumerWidget {
  DialogAddMasterReportRegulerTorque({super.key});
  TextEditingController fabricatorController = TextEditingController();
  TextEditingController towerHeightController = TextEditingController();
  TextEditingController towerSegmentController = TextEditingController();
  TextEditingController elevasiController = TextEditingController();
  TextEditingController boltSizeController = TextEditingController();
  TextEditingController minimumTorqueController = TextEditingController();
  TextEditingController qtyBoltController = TextEditingController();

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
                    'New Master Report Regular Torque',
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
              const Text('Fabricator'),
              TextField(
                controller: fabricatorController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Fabricator',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tower Height'),
              TextField(
                controller: towerHeightController,
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Tower Height',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tower Segment'),
              TextField(
                controller: towerSegmentController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Tower Segment',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Elevasi'),
              TextField(
                controller: elevasiController,
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Elevasi',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Bolt Size'),
              TextField(
                controller: boltSizeController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Bolt Size',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Minimum Torque'),
              TextField(
                controller: minimumTorqueController,
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Minimum Torque',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Qty Bolt'),
              TextField(
                controller: qtyBoltController,
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Qty Bolt',
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
    MasterReportRegulerTorque masterTorque = MasterReportRegulerTorque(
        fabricator: fabricatorController.text,
        towerHeight: int.parse(towerHeightController.text),
        towerSegment: towerSegmentController.text,
        elevasi: int.parse(elevasiController.text),
        boltSize: boltSizeController.text,
        minimumTorque: int.parse(minimumTorqueController.text),
        qtyBolt: int.parse(qtyBoltController.text));
    if (DEBUG) {
      debugPrint('site : $masterTorque.toString()');
    }
    ref
        .read(masterReportRegulerTorqueNotifierProvider.notifier)
        .createMasterReportRegulerTorqueRepo(masterTorque);
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
