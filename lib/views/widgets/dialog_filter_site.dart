import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/model/province.dart';
import 'package:flutter_web_ptb/providers/site_provider.dart';

// ignore: must_be_immutable
class DialogFilterSite extends ConsumerWidget {
  DialogFilterSite({super.key});

  String province = "";
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
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.invalidate(provinceNotifierProvider);
                      ref.invalidate(kabupatenNotifierProvider);
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      var kabupaten =
                          ref.read(kabupatenNotifierProvider.notifier).state;
                      debugPrint('province : $province kabupaten : $kabupaten');
                      List<String> dataFilter = [];
                      if (province.isNotEmpty) {
                        dataFilter.add('province||eq||$province');
                      }
                      if (kabupaten.isNotEmpty) {
                        dataFilter.add('region||eq||$kabupaten');
                      }
                      ref
                          .read(siteNotifierProvider.notifier)
                          .getAllSite({'filter': dataFilter});
                      ref.invalidate(provinceNotifierProvider);
                      ref.invalidate(kabupatenNotifierProvider);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              FutureBuilder<List<Province>>(
                  future: getProvinceData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Province> data = snapshot.data!;
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
                                    debugPrint(value!);
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
            ],
          ),
        ),
      ),
    );
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
