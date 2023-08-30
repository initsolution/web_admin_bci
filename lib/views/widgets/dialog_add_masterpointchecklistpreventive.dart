import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/mastercategorychecklistpreventive.dart';
import 'package:flutter_web_ptb/model/masterpointchecklistpreventive.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_provider.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_state.dart';
import 'package:flutter_web_ptb/providers/masterpointchecklistpreventive_provider.dart';

// ignore: must_be_immutable
class DialogAddmasterPointChecklistPreventive extends ConsumerWidget {
  final List<MasterCategoryChecklistPreventive> dataCategoryChecklistPreventive;
  DialogAddmasterPointChecklistPreventive(
      {super.key, required this.dataCategoryChecklistPreventive});
  TextEditingController kriteriaController = TextEditingController();
  TextEditingController uraianController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
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
                  'New Master Point Checklist Preventive',
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
            const Text('Category Checklist Preventive'),
            getDropdownCategory(dataCategoryChecklistPreventive),
            const SizedBox(
              height: 15,
            ),
            const Text('Uraian'),
            TextField(
              controller: uraianController,
              keyboardType: TextInputType.text,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Please type uraian',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text('Kriteria'),
            TextField(
              controller: kriteriaController,
              keyboardType: TextInputType.text,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Please type kriteria',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: ElevatedButton(
                onPressed: () => {
                  saveMasterPointChecklistPreventive(ref),
                  ref
                      .read(masterPointChecklistPreventiveNotifierProvider
                          .notifier)
                      .getAllMasterPointChecklistPreventive(),
                  Navigator.pop(context),
                },
                child: const Text('SAVE'),
              ),
            ),
          ],
        )),
      ),
    );
  }

  void saveMasterPointChecklistPreventive(WidgetRef ref) {
    final MasterCategoryChecklistPreventive
        selectedMasterCategoryChecklistPreventive =
        ref.watch(selectedCategoryChecklistPreventive);
    MasterPointChecklistPreventive masterPointChecklistPreventive =
        MasterPointChecklistPreventive(
            uraian: uraianController.text,
            kriteria: kriteriaController.text,
            mcategorychecklistpreventive: MasterCategoryChecklistPreventive(
                id: selectedMasterCategoryChecklistPreventive.id));
    if (DEBUG) {
      debugPrint('site : $masterPointChecklistPreventive.toString()');
    }
    ref
        .read(masterPointChecklistPreventiveNotifierProvider.notifier)
        .createMasterPointChecklistPreventive(masterPointChecklistPreventive);
  }

  // nanti di set value saat klik tombols
  Widget getDropdownCategory(
      List<MasterCategoryChecklistPreventive> dataCategoryChecklistPreventive) {
    return Consumer(builder: (context, ref, child) {
      final MasterCategoryChecklistPreventive
          masterCategoryChecklistPreventive =
          ref.watch(selectedCategoryChecklistPreventive);
      return DropdownButton<MasterCategoryChecklistPreventive>(
          value: masterCategoryChecklistPreventive,
          items: dataCategoryChecklistPreventive
              .map<DropdownMenuItem<MasterCategoryChecklistPreventive>>((e) {
            return DropdownMenuItem<MasterCategoryChecklistPreventive>(
              value: e,
              child: Text(e.name!),
            );
          }).toList(),
          onChanged: (value) => ref
              .read(selectedCategoryChecklistPreventive.notifier)
              .state = value!);
    });
  }
}
