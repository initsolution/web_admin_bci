import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/province.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/providers/site_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_ptb/providers/tenant_provider.dart';
import 'package:multiselect/multiselect.dart';

import '../../providers/tenant_state.dart';

// ignore: must_be_immutable
class DialogAddSite extends ConsumerWidget {
  DialogAddSite({super.key});
  TextEditingController siteIdController = TextEditingController();
  TextEditingController siteNameController = TextEditingController();
  TextEditingController towerTypeController = TextEditingController();
  TextEditingController towerHeightController = TextEditingController();
  TextEditingController fabricatorController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String province = "";
  String kabupaten = "";
  List<String> selectedTenants = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var stateTenant = ref.watch(tenantNotifierProvider);
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
                      ref.invalidate(provinceNotifierProvider);
                      ref.invalidate(kabupatenNotifierProvider);
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
              if (stateTenant is TenantLoaded)
                DropDownMultiSelect(
                  selected_values_style: const TextStyle(color: Colors.black),
                  options: stateTenant.tenants.map((e) => e.name).toList(),
                  selectedValues: selectedTenants,
                  whenEmpty: 'Select Tenants',
                  onChanged: (List<String?> x) {},
                )
              else if(stateTenant is TenantLoading)
                const CircularProgressIndicator(),
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
              FutureBuilder(
                  future: getProvinceData(),
                  builder: (context, snapshot) {
                    List<Province> data = snapshot.data!;
                    final int selectedProvince =
                        ref.watch(provinceNotifierProvider);
                    final String selectedKabupaten =
                        ref.watch(kabupatenNotifierProvider);
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Province'),
                                DropdownButton(
                                  value: data[selectedProvince],
                                  hint: const Text('Select a Province'),
                                  items: data.map((value) {
                                    return DropdownMenuItem<Province>(
                                      value: value,
                                      child: Text(value.province.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (Province? value) {
                                    // debugPrint('value : ${data.indexOf(value!)}');
                                    province = value!.province.toString();
                                    int idx = data.indexOf(value);
                                    ref
                                        .read(provinceNotifierProvider.notifier)
                                        .state = idx;
                                    ref
                                        .read(
                                            kabupatenNotifierProvider.notifier)
                                        .state = "";
                                  },
                                ),
                                // getDropdownProvince(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Regional'),
                                DropdownButton(
                                  value: selectedKabupaten.isNotEmpty
                                      ? selectedKabupaten
                                      : null,
                                  hint: const Text('Select a City/Region'),
                                  items: data[selectedProvince]
                                      .kabupaten!
                                      .map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    debugPrint('${value!}');
                                    ref
                                        .read(
                                            kabupatenNotifierProvider.notifier)
                                        .state = value;
                                  },
                                )
                                // getDropdownKabupaten(),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: ElevatedButton(
                  onPressed: () => {saveSite(ref), Navigator.pop(context)},
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
    var kabupaten = ref.read(kabupatenNotifierProvider.notifier).state;
    Site site = Site(
      id: siteIdController.text,
      name: siteNameController.text,
      tower_type: towerTypeController.text,
      tower_height: int.parse(towerHeightController.text),
      fabricator: fabricatorController.text,
      tenants: selectedTenants.toString(),
      kabupaten: kabupaten,
      province: province,
      address: addressController.text,
      latitude: '100',
      longitude: '200',
    );
    if (DEBUG) {
      debugPrint('site : $site.toString()');
    }
    // ref.read(siteNotifierProvider.notifier).createSite(site);
  }

  Widget getDropdownProvince() {
    return Consumer(builder: (_, WidgetRef ref, __) {
      final int selectedProvince = ref.watch(provinceNotifierProvider);
      return FutureBuilder<List<Province>>(
        future: getProvinceData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Province> data = snapshot.data!;
            return DropdownButton(
              value: data[selectedProvince],
              hint: const Text('Select a Province'),
              items: data.map((value) {
                return DropdownMenuItem<Province>(
                  value: value,
                  child: Text(value.province.toString()),
                );
              }).toList(),
              onChanged: (Province? value) {
                // debugPrint('value : ${data.indexOf(value!)}');
                int idx = data.indexOf(value!);
                ref.read(provinceNotifierProvider.notifier).state = idx;
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    });
  }

  Widget getDropdownKabupaten() {
    return Consumer(builder: (_, WidgetRef ref, __) {
      final int selectedProvince = ref.watch(provinceNotifierProvider);
      final String selectedKabupaten = ref.watch(kabupatenNotifierProvider);
      return FutureBuilder(
          future: getProvinceData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Province>? data = snapshot.data;
              debugPrint('dataKab : $data');
              return DropdownButton(
                value: selectedKabupaten.isNotEmpty ? selectedKabupaten : null,
                hint: const Text('Select a City/Region'),
                items: data![selectedProvince].kabupaten!.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  debugPrint('${value!}');
                  ref.read(kabupatenNotifierProvider.notifier).state = value;
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          });
    });
  }

  Future<List<Province>> getProvinceData() async {
    var data = await rootBundle.loadString("assets/province/province.json");
    List<Province> list = [];
    List<dynamic> valueMap = json.decode(data);
    for (int i = 0; i < valueMap.length; i++) {
      Province p = Province.fromJson(valueMap[i]);
      // debugPrint('province ${p.province}');
      // debugPrint('kabupaten ${p.kabupaten}');
      list.add(p);
    }
    return list; //latest Dart
  }
}
