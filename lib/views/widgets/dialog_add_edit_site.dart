import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/model/province.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/model/tenant.dart';
import 'package:flutter_web_ptb/providers/site_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_ptb/providers/tenant_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:multiselect/multiselect.dart';

import '../../providers/tenant_state.dart';

// ignore: must_be_immutable
class DialogAddEditSite extends ConsumerWidget {
  final bool isEdit;
  Site? site;
  DialogAddEditSite({super.key, this.isEdit = false, this.site});
  TextEditingController siteIdController = TextEditingController();
  TextEditingController siteNameController = TextEditingController();
  TextEditingController towerTypeController = TextEditingController();
  TextEditingController towerHeightController = TextEditingController();
  TextEditingController fabricatorController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  bool isHavePju = false;
  List<Province> listProvince = [];
  String province = "";
  String kabupaten = "";
  List<String> selectedTenants = [];
  List<Tenant> dtTenant = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var stateTenant = ref.watch(tenantNotifierProvider);
    if (isEdit) {
      if (site != null) {
        siteIdController.text = site!.id ?? '';
        siteNameController.text = site!.name ?? '';
        towerTypeController.text = site!.towerType ?? '';
        towerHeightController.text = site!.towerHeight.toString();
        fabricatorController.text = site!.fabricator ?? '';
        addressController.text = site!.address ?? '';
        longitudeController.text = site!.longitude ?? '';
        latitudeController.text = site!.latitude ?? '';
        print('site!.tenants! = ${site!.tenants!}');
        if (stateTenant is TenantLoaded) {
          dtTenant = stateTenant.tenants;
          print('dtTenant : ${dtTenant.toString()}');
          if (site!.tenants!.contains(';')) {
            var pecahTenant = site!.tenants!.split(';');
            for (var i = 0; i < pecahTenant.length; i++) {
              int idxTenant = dtTenant.indexWhere(
                  (element) => element.kodeTenant == pecahTenant[i]);
              Tenant tenant = dtTenant[idxTenant];
              selectedTenants.add('${pecahTenant[i]}-${tenant.name}');
            }
          } else {
            int idxTenant = dtTenant
                .indexWhere((element) => element.kodeTenant == site!.tenants!);
            debugPrint('idxTenant : ${idxTenant}');
            if (idxTenant != -1) {
              Tenant tenant = dtTenant[idxTenant];
              selectedTenants.add('${tenant.kodeTenant}-${tenant.name}');
            }
          }
        }
        isHavePju = site!.isHavePJU!;
        Future(() => ref.read(isHavePjuProvider.notifier).state = isHavePju);
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
                      isEdit ? 'Edit Site' : 'New Site',
                      style: const TextStyle(fontSize: 30),
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
                TextFormField(
                  controller: siteIdController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Site Id',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Site Id";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Site Name'),
                TextFormField(
                  controller: siteNameController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Site Name',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Site Name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Tower Type'),
                TextFormField(
                  controller: towerTypeController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Tower Type',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Tower Type";
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
                  keyboardType: TextInputType.text,
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
                const Text('Tenants'),
                if (stateTenant is TenantLoaded)
                  DropDownMultiSelect(
                    selected_values_style: const TextStyle(color: Colors.black),
                    options: stateTenant.tenants
                        .map((e) => '${e.kodeTenant}-${e.name}')
                        .toList(),
                    selectedValues: selectedTenants,
                    whenEmpty: 'Select Tenants',
                    onChanged: (List<String?> x) {},
                  )
                // MultiSelectDialog(
                //     items: stateTenant.tenants
                //         .map((e) => MultiSelectItem(e, e.name.toString()))
                //         .toList(),
                //     listType: MultiSelectListType.CHIP,
                //     initialValue: stateTenant.tenants)
                else if (stateTenant is TenantLoading)
                  const CircularProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
                const Text('Is Have PJU'),
                loadPJU(),
                const SizedBox(
                  height: 10,
                ),
                const Text('Address'),
                TextFormField(
                  maxLines: 4,
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your Address',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Your Address";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Province>>(
                    future: getProvinceData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        listProvince = snapshot.data!;
                        final int selectedProvince =
                            ref.watch(provinceNotifierProvider);
                        final String selectedKabupaten =
                            ref.watch(kabupatenNotifierProvider);
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Province'),
                                  DropdownButton(
                                    value: listProvince[selectedProvince],
                                    hint: const Text('Select a Province'),
                                    items: listProvince.map((value) {
                                      return DropdownMenuItem<Province>(
                                        value: value,
                                        child: Text(value.province.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (Province? value) {
                                      province = value!.province.toString();
                                      int idx = listProvince.indexOf(value);
                                      ref
                                          .read(
                                              provinceNotifierProvider.notifier)
                                          .state = idx;
                                      ref
                                          .read(kabupatenNotifierProvider
                                              .notifier)
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
                                  DropdownButtonFormField(
                                    value: selectedKabupaten.isNotEmpty
                                        ? selectedKabupaten
                                        : null,
                                    hint: const Text('Select a City/Region'),
                                    items: listProvince[selectedProvince]
                                        .kabupaten!
                                        .map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      debugPrint(value!);
                                      ref
                                          .read(kabupatenNotifierProvider
                                              .notifier)
                                          .state = value;
                                    },
                                    validator: (input) {
                                      if (input == null) {
                                        return "Please Select Region";
                                      }
                                      return null;
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
                const SizedBox(
                  height: 10,
                ),
                const Text('Longitude'),
                TextFormField(
                  controller: longitudeController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your longitude',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Longitude";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Latitude'),
                TextFormField(
                  controller: latitudeController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please type your latitude',
                  ),
                  validator: (input) {
                    if (input!.isEmpty) {
                      return "Please Input Latitude";
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
                        saveSite(ref);
                        Navigator.pop(context);
                        // if (selectedTenants.isNotEmpty) {
                        //   saveSite(ref);
                        //   Navigator.pop(context);
                        // } else {
                        //   showToast(context, 'Please Input Tenant');
                        // }
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

  showToast(
    context,
    String msg,
  ) {
    final dialog = AwesomeDialog(
      context: context,
      desc: msg,
      width: 460,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    );
    dialog.show();
  }

  void saveSite(WidgetRef ref) {
    var kabupaten = ref.read(kabupatenNotifierProvider.notifier).state;
    var province =
        listProvince[ref.read(provinceNotifierProvider.notifier).state];
    isHavePju = ref.watch(isHavePjuProvider);
    var listTenant = "";
    for (var kodeTenant in selectedTenants) {
      var temp = kodeTenant.split("-");
      if (listTenant.isNotEmpty) {
        listTenant += ";";
      }
      listTenant += temp[0];
    }
    debugPrint('listTenant : $listTenant');
    Site site = Site(
      id: siteIdController.text,
      name: siteNameController.text,
      towerType: towerTypeController.text,
      towerHeight: int.parse(towerHeightController.text),
      fabricator: fabricatorController.text,
      tenants: listTenant,
      isHavePJU: isHavePju,
      region: kabupaten,
      province: province.province,
      address: addressController.text,
      latitude: latitudeController.text,
      longitude: longitudeController.text,
    );
    if (DEBUG) {
      debugPrint('site : ${site.toString()}');
    }

    ref.read(siteNotifierProvider.notifier).createOrEditSite(site, isEdit);
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
                  debugPrint(value!);
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

  Widget loadPJU() {
    return Consumer(builder: (_, WidgetRef ref, __) {
      bool isActive = ref.watch(isHavePjuProvider);
      return Switch(
        // This bool value toggles the switch.
        value: isActive,
        activeColor: Colors.blue,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          ref.read(isHavePjuProvider.notifier).state = value;
        },
      );
    });
  }
}
