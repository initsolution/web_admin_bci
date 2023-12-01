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
  // final List<MasterCategoryChecklistPreventive> dataCategoryChecklistPreventive;
  final bool isEdit;
  MasterPointChecklistPreventive? editMasterPointChecklistPreventive;
  DialogAddmasterPointChecklistPreventive(
      {super.key,
      // required this.dataCategoryChecklistPreventive,
      this.isEdit = false,
      this.editMasterPointChecklistPreventive});
  TextEditingController kriteriaController = TextEditingController();
  TextEditingController uraianController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isEdit) {
      if (editMasterPointChecklistPreventive != null) {
        debugPrint('awalan ${editMasterPointChecklistPreventive.toString()}');
        kriteriaController.text =
            editMasterPointChecklistPreventive!.kriteria ?? '';
        uraianController.text =
            editMasterPointChecklistPreventive!.uraian ?? '';
        Future(() {
          ref.read(selectedCategoryChecklistPreventive.notifier).state =
              editMasterPointChecklistPreventive!.mcategorychecklistpreventive!;
          ref.read(isChecklistMasterPointChecklist.notifier).state =
              editMasterPointChecklistPreventive!.isChecklist ?? false;
        });
      }
    }
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${isEdit ? 'Edit' : 'New'} Master Point Checklist Preventive',
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
            const Text('Category Checklist Preventive'),
            Consumer(builder: ((context, ref, child) {
              late List<MasterCategoryChecklistPreventive>
                  dataCategoryChecklistPreventive;
              var stateCategoryChecklistPreventive =
                  ref.watch(masterCategoryChecklistPreventivNotifierProvider);
              if (stateCategoryChecklistPreventive
                  is MasterCategoryChecklistPreventiveLoaded) {
                dataCategoryChecklistPreventive =
                    stateCategoryChecklistPreventive.masterCategoryPrev;
                if (!isEdit) {
                  Future(() => ref
                      .read(selectedCategoryChecklistPreventive.notifier)
                      .state = dataCategoryChecklistPreventive[0]);
                }
              }
              return getDropdownCategory(dataCategoryChecklistPreventive);
            })),
            const SizedBox(
              height: 15,
            ),
            const Text('Uraian'),
            TextField(
              controller: uraianController,
              keyboardType: TextInputType.text,
              obscureText: false,
              maxLines: 3,
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
              maxLines: 3,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Please type kriteria',
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text('Apakah Bentuk Checklist'),
            getChecklist(),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () => {
                  saveMasterPointChecklistPreventive(ref),
                  Navigator.pop(context),
                },
                child: Text(isEdit ? 'EDIT' : 'SAVE'),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget getChecklist() {
    return Consumer(builder: (_, WidgetRef ref, __) {
      final isChecklist = ref.watch(isChecklistMasterPointChecklist);
      return Checkbox(
        value: isChecklist,
        onChanged: (val) =>
            ref.read(isChecklistMasterPointChecklist.notifier).state = val!,
      );
    });
  }

  void saveMasterPointChecklistPreventive(WidgetRef ref) {
    final MasterCategoryChecklistPreventive
        selectedMasterCategoryChecklistPreventive =
        ref.watch(selectedCategoryChecklistPreventive);
    final isChecklist = ref.watch(isChecklistMasterPointChecklist);

    debugPrint('is checklist : $isChecklist');
    MasterPointChecklistPreventive masterPointChecklistPreventive =
        MasterPointChecklistPreventive(
            uraian: uraianController.text,
            kriteria: kriteriaController.text,
            isChecklist: isChecklist,
            mcategorychecklistpreventive: MasterCategoryChecklistPreventive(
                id: selectedMasterCategoryChecklistPreventive.id));
    if (isEdit) {
      masterPointChecklistPreventive.id =
          editMasterPointChecklistPreventive!.id;
    }
    debugPrint(masterPointChecklistPreventive.toString());
    ref
        .read(masterPointChecklistPreventiveNotifierProvider.notifier)
        .createOrEditMasterPointChecklistPreventive(
            masterPointChecklistPreventive, isEdit);
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
              child: Text(e.categoryName!),
            );
          }).toList(),
          onChanged: (value) => ref
              .read(selectedCategoryChecklistPreventive.notifier)
              .state = value!);
    });
  }
}
