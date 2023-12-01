import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/model/masterreportregulertorque.dart';
import 'package:flutter_web_ptb/providers/masterreportregulertorque_provider.dart';

// ignore: must_be_immutable
class DialogAddMasterReportRegulerTorque extends ConsumerWidget {
  final bool isEdit;
  MasterReportRegulerTorque? editMasterReportRegulerTorque;
  DialogAddMasterReportRegulerTorque(
      {super.key, this.isEdit = false, this.editMasterReportRegulerTorque});
  TextEditingController fabricatorController = TextEditingController();
  TextEditingController towerHeightController = TextEditingController();
  TextEditingController towerSegmentController = TextEditingController();
  TextEditingController elevasiController = TextEditingController();
  TextEditingController boltSizeController = TextEditingController();
  TextEditingController minimumTorqueController = TextEditingController();
  TextEditingController qtyBoltController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isEdit) {
      if (editMasterReportRegulerTorque != null) {
        fabricatorController.text =
            editMasterReportRegulerTorque!.fabricator ?? '';
        towerHeightController.text =
            editMasterReportRegulerTorque!.towerHeight.toString();
        towerSegmentController.text =
            editMasterReportRegulerTorque!.towerSegment ?? '';
        elevasiController.text =
            editMasterReportRegulerTorque!.elevasi.toString();
        boltSizeController.text = editMasterReportRegulerTorque!.boltSize ?? '';
        minimumTorqueController.text =
            editMasterReportRegulerTorque!.minimumTorque.toString();
        qtyBoltController.text =
            editMasterReportRegulerTorque!.qtyBolt.toString();
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
                      '${isEdit ? 'Edit' : 'Add'} Master Report Regular Torque',
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
                const Text('Tower Segment'),
                TextFormField(
                  controller: towerSegmentController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Tower Segment',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Tower Segment";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Elevasi'),
                TextFormField(
                  controller: elevasiController,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Elevasi',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Elevasi";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Bolt Size'),
                TextFormField(
                  controller: boltSizeController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Bolt Size',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Bolt Size";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Minimum Torque'),
                TextFormField(
                  controller: minimumTorqueController,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Minimum Torque',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Minimum Torque";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Qty Bolt'),
                TextFormField(
                  controller: qtyBoltController,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Qty Bolt',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Qty Bolt";
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
                    child: const Text('SAVE'),
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
    MasterReportRegulerTorque masterTorque = MasterReportRegulerTorque(
        fabricator: fabricatorController.text,
        towerHeight: int.parse(towerHeightController.text),
        towerSegment: towerSegmentController.text,
        elevasi: int.parse(elevasiController.text),
        boltSize: boltSizeController.text,
        minimumTorque: int.parse(minimumTorqueController.text),
        qtyBolt: int.parse(qtyBoltController.text));
    if (isEdit) {
      masterTorque.id = editMasterReportRegulerTorque!.id;
    }
    ref
        .read(masterReportRegulerTorqueNotifierProvider.notifier)
        .createOrUpdateMasterReportRegulerTorqueRepo(masterTorque, isEdit);
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
