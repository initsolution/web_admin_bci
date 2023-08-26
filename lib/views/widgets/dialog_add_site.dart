import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/site_provider.dart';

// ignore: must_be_immutable
class DialogAddSite extends ConsumerWidget {
  DialogAddSite({super.key});
  TextEditingController siteIdController = TextEditingController();
  TextEditingController siteNameController = TextEditingController();
  TextEditingController towerTypeController = TextEditingController();
  TextEditingController towerHeightController = TextEditingController();
  TextEditingController fabricatorController = TextEditingController();
  TextEditingController tenantsController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
                    'New Site',
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
              const Text('Site Id'),
              TextField(
                controller: siteIdController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Site Id',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Site Name'),
              TextField(
                controller: siteNameController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Site Name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tower Type'),
              TextField(
                controller: towerTypeController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Tower Type',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Tower Height'),
              TextField(
                controller: towerHeightController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Tower Height',
                ),
              ),
              const SizedBox(
                height: 10,
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
              const Text('Tenants'),
              TextField(
                controller: tenantsController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Tenants',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Address'),
              TextField(
                maxLines: 4,
                controller: addressController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please type your Address',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Regional'),
                        getDropdownRole(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Province'),
                        getDropdownActive(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () => {
                    saveSite(ref),
                    Navigator.pop(context)
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

  void saveSite(WidgetRef ref) {
    Site site = Site(
      id: siteIdController.text,
      name: siteNameController.text,
      tower_type: towerTypeController.text,
      tower_height: int.parse(towerHeightController.text),
      fabricator: fabricatorController.text,
      tenants: tenantsController.text,
      kabupaten: "kab semarang",
      province: "jawa tengah",
      address: addressController.text,
      latitude: '100',
      longitude: '200',
    );
    if (DEBUG) {
      debugPrint('site : $site.toString()');
    }
    ref.read(siteNotifierProvider.notifier).createSite(site);
  }

  Widget getDropdownRole() {
    List<String> dataRole = ['Maker', 'Verify', 'Admin'];
    return Consumer(builder: (_, WidgetRef ref, __) {
      final String employeeRole = ref.watch(employeeRoleProvider);
      return DropdownButton(
        value: employeeRole.isNotEmpty ? employeeRole : null,
        onChanged: (value) =>
            ref.read(employeeRoleProvider.notifier).state = value!,
        items: dataRole.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }

  Widget getDropdownActive() {
    String? initialVal = "Vendor";
    // var func;

    return DropdownButton(
      value: initialVal,
      onChanged: (value) {
        debugPrint(value);
      }, // =========== Here the error occurs ==========================
      items: <String>['Vendor', 'Internal']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
