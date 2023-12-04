import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/province.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/providers/site_provider.dart';
import 'package:flutter_web_ptb/providers/site_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_edit_site.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_filter_site.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

import '../../providers/tenant_provider.dart';

class SiteScreen extends ConsumerStatefulWidget {
  const SiteScreen({super.key});

  @override
  ConsumerState<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends ConsumerState<SiteScreen> {
  final pdf = pw.Document();
  var anchor;

  late List<Site> filterData;
  bool _sortIDAsc = true;
  bool _sortNameAsc = true;
  bool _sortTowerTypeAsc = true;
  bool _sortTowerHeightAsc = true;
  bool _sortFabricatorAsc = true;
  bool _sortAddressAsc = true;
  bool _sortRegionalAsc = true;
  bool _sortProvinceAsc = true;
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void initState() {
    Future(() => ref.read(siteNotifierProvider.notifier).getAllSite({}));
    super.initState();
    // createPDF();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'pdf.pdf';
    html.document.body!.children.add(anchor);
  }

  createPDF() async {
    //contoh1
    // final profileImage = pw.MemoryImage((await rootBundle.load('hospital_ic.png')).buffer.asUint8List(),);
    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) => pw.Column(
    //       children: [
    //         pw.Text('Hello World1', style: pw.TextStyle(fontSize: 40)),
    //         pw.Text('Hello World2', style: pw.TextStyle(fontSize: 40)),
    //         pw.Text('Hello World3', style: pw.TextStyle(fontSize: 40)),
    //         pw.Image(profileImage),
    //       ],
    //     ),
    //   ),
    // );

    //contoh2
    // var reportedItems = [
    //   ["A1", "B1", "C1", "D1"],
    //   ["A2", "B2", "C2", "D2"],
    //   ["A3", "B3", "C3", "D3"]
    // ];
    // pdf.addPage(
    //   pw.Page(
    //       build: (pw.Context context) => pw.Table(children: [
    //             for (var i = 0; i < reportedItems.length; i++)
    //               pw.TableRow(children: [
    //                 pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
    //                     mainAxisAlignment: pw.MainAxisAlignment.center,
    //                     children: [
    //                       pw.Text(reportedItems[i][0],
    //                           style: pw.TextStyle(fontSize: 6)),
    //                       pw.Divider(thickness: 1)
    //                     ]),
    //                 pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
    //                     mainAxisAlignment: pw.MainAxisAlignment.center,
    //                     children: [
    //                       pw.Text(reportedItems[i][1],
    //                           style: pw.TextStyle(fontSize: 6)),
    //                       pw.Divider(thickness: 1)
    //                     ]),
    //                 pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
    //                     mainAxisAlignment: pw.MainAxisAlignment.center,
    //                     children: [
    //                       pw.Text(reportedItems[i][2],
    //                           style: pw.TextStyle(fontSize: 6)),
    //                       pw.Divider(thickness: 1)
    //                     ]),
    //                 pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
    //                     mainAxisAlignment: pw.MainAxisAlignment.center,
    //                     children: [
    //                       pw.Text(reportedItems[i][3],
    //                           style: pw.TextStyle(fontSize: 6)),
    //                       pw.Divider(thickness: 1)
    //                     ])
    //               ])
    //           ])),
    // );

    //contoh3
    final profileImage = pw.MemoryImage(
      (await rootBundle.load('hospital_ic.png')).buffer.asUint8List(),
    );
    pdf.addPage(
      pw.Page(
          build: (pw.Context context) => pw.Container(
                height: 1280.0,
                width: 720.0,
                padding: const pw.EdgeInsets.all(10.0),
                child: pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text('PERIODIC MAINTENANCE TIGHTENING BOLT'),
                      pw.Text('Site ID'),
                      pw.Text('Site Name'),
                      pw.Row(children: [
                        pw.Column(children: [
                          pw.Text('Site Information'),
                          pw.Image(profileImage),
                        ]),
                        pw.Column(children: [
                          pw.Text('Site Information'),
                          pw.Image(profileImage),
                        ]),
                      ]),
                    ],
                  ),
                ),
              )),
    );
    savePDF();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(siteNotifierProvider, (previous, next) {
      if (next is SiteErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is SiteDataChangeSuccess) {
        ref.read(siteNotifierProvider.notifier).getAllSite({});
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const Header(
            title: 'Data Site',
            subMenu: 'All',
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              margin: const EdgeInsets.only(top: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 400,
                        height: 40,
                        child: TextField(
                          onChanged: (value) => Future(() => ref
                              .read(siteNotifierProvider.notifier)
                              .searchSite(
                                  value)), // onChanged return the value of the field
                          decoration: InputDecoration(
                              labelText: "Search ...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Map<String, dynamic> header = {
                            "filter": "isActive||eq||true"
                          };
                          ref
                              .read(tenantNotifierProvider.notifier)
                              .getAllTenant(header);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox(child: DialogAddEditSite());
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          ref
                              .read(siteNotifierProvider.notifier)
                              .getAllSite({});
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => DialogFilterSite());
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),

                      // IconButton(
                      //   icon: const Icon(Icons.more_vert),
                      //   onPressed: () {},
                      // ),
                      // const SizedBox(
                      //   width: 30,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  tableSite(),
                ],
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     anchor.click();
          //   },
          //   child: const Text('click me'),
          // ),
        ],
      ),
    );
  }

  void sort(columnIndex) {
    setState(() {
      if (columnIndex == 0) {
        //nik
        if (_sortIDAsc == true) {
          _sortIDAsc = false;
          filterData.sort((a, b) => b.id!.compareTo(a.id!));
        } else {
          _sortIDAsc = true;
          filterData.sort((a, b) => a.id!.compareTo(b.id!));
        }
      } else if (columnIndex == 1) {
        //nama
        if (_sortNameAsc == true) {
          _sortNameAsc = false;
          filterData.sort((a, b) => b.name!.compareTo(a.name!));
        } else {
          _sortNameAsc = true;
          filterData.sort((a, b) => a.name!.compareTo(b.name!));
        }
      } else if (columnIndex == 2) {
        //tower type
        if (_sortTowerTypeAsc == true) {
          _sortTowerTypeAsc = false;
          filterData.sort((a, b) => b.towerType!.compareTo(a.towerType!));
        } else {
          _sortTowerTypeAsc = true;
          filterData.sort((a, b) => a.towerType!.compareTo(b.towerType!));
        }
      } else if (columnIndex == 3) {
        //tower height
        if (_sortTowerHeightAsc == true) {
          _sortTowerHeightAsc = false;
          filterData.sort((a, b) => b.towerHeight!.compareTo(a.towerHeight!));
        } else {
          _sortTowerHeightAsc = true;
          filterData.sort((a, b) => a.towerHeight!.compareTo(b.towerHeight!));
        }
      } else if (columnIndex == 4) {
        //tower height
        if (_sortFabricatorAsc == true) {
          _sortFabricatorAsc = false;
          filterData.sort((a, b) => b.fabricator!.compareTo(a.fabricator!));
        } else {
          _sortFabricatorAsc = true;
          filterData.sort((a, b) => a.fabricator!.compareTo(b.fabricator!));
        }
      } else if (columnIndex == 6) {
        //address
        if (_sortAddressAsc == true) {
          _sortAddressAsc = false;
          filterData.sort((a, b) => b.address!.compareTo(a.address!));
        } else {
          _sortAddressAsc = true;
          filterData.sort((a, b) => a.address!.compareTo(b.address!));
        }
      } else if (columnIndex == 7) {
        //region
        if (_sortRegionalAsc == true) {
          _sortRegionalAsc = false;
          filterData.sort((a, b) => b.region!.compareTo(a.region!));
        } else {
          _sortRegionalAsc = true;
          filterData.sort((a, b) => a.region!.compareTo(b.region!));
        }
      } else if (columnIndex == 8) {
        //province
        if (_sortProvinceAsc == true) {
          _sortProvinceAsc = false;
          filterData.sort((a, b) => b.province!.compareTo(a.province!));
        } else {
          _sortProvinceAsc = true;
          filterData.sort((a, b) => a.province!.compareTo(b.province!));
        }
      }
    });
  }

  Widget tableSite() {
    final themeData = Theme.of(context);
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    return Theme(
      data: themeData.copyWith(
        cardTheme: appDataTableTheme.cardTheme,
        dataTableTheme: appDataTableTheme.dataTableThemeData,
      ),
      child: SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double dataTableWidth =
                  max(kScreenWidthMd, constraints.maxWidth);
              return Scrollbar(
                controller: _dataTableHorizontalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _dataTableHorizontalScrollController,
                  child: SizedBox(
                    width: dataTableWidth,
                    child: Consumer(
                      builder: (context, ref, child) {
                        var state = ref.watch(siteNotifierProvider);
                        if (DEBUG) debugPrint('state : $state');
                        if (state is SiteLoaded) {
                          DataTableSource data = SiteData(
                              sites: state.sites, ref: ref, context: context);
                          filterData = state.sites;
                          return PaginatedDataTable(
                            headingRowHeight: 50,
                            columnSpacing: 0,
                            source: data,
                            columns: [
                              DataColumn(
                                label: const Text('ID'),
                                tooltip: "SITE ID",
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('NAME'),
                                tooltip: "SITE NAME",
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('TYPE'),
                                tooltip: "TOWER TYPE",
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('HEIGHT'),
                                tooltip: "TOWER HEIGHT",
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('FABRICATOR'),
                                tooltip: "FABRICATOR",
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              const DataColumn(
                                label: Text('TENANTS'),
                                tooltip: "TENANTS",
                              ),
                              DataColumn(
                                label: const Text('ADDRESS'),
                                tooltip: "SITE ADDRESS",
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('REGION'),
                                tooltip: "SITE REGION",
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('PROVINCE'),
                                tooltip: "SITE PROVINCE",
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              // const DataColumn(
                              //     label: Text('LONG'), tooltip: "LONGITUDE"),
                              // const DataColumn(
                              //     label: Text('LAT'), tooltip: "LATITUDE"),
                              const DataColumn(label: Text('ACTION')),
                              const DataColumn(label: Text('TASKS')),
                            ],
                            horizontalMargin: 20,
                            rowsPerPage: 10,
                            showCheckboxColumn: false,
                          );
                        } else if (state is SiteLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}

class SiteData extends DataTableSource {
  final List<Site> sites;
  final WidgetRef ref;
  final BuildContext context;
  SiteData({required this.sites, required this.ref, required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(sites[index].id!)),
      DataCell(Text(sites[index].name!)),
      DataCell(Text(sites[index].towerType!)),
      DataCell(Text(sites[index].towerHeight!.toString())),
      DataCell(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text(sites[index].fabricator!.toString()))),
      DataCell(Text(sites[index].tenants!.toString())),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Text(sites[index].address!.toString(),
            overflow: TextOverflow.ellipsis),
      )),
      DataCell(Text(sites[index].region!.toString())),
      DataCell(Text(sites[index].province!.toString())),
      // DataCell(Text(sites[index].longitude!.toString())),
      // DataCell(Text(sites[index].latitude!.toString())),
      DataCell(IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          Map<String, dynamic> header = {"filter": "isActive||eq||true"};
          ref.read(tenantNotifierProvider.notifier).getAllTenant(header);
          getProvinceData().then((value) {
            int idxEditProvince = value.indexWhere(
                (element) => element.province == sites[index].province);
            ref.read(provinceNotifierProvider.notifier).state = idxEditProvince;
            ref.read(kabupatenNotifierProvider.notifier).state =
                sites[index].region!;
          });
          showDialog(
            context: context,
            builder: (context) {
              return SizedBox(
                  child: DialogAddEditSite(
                isEdit: true,
                site: sites[index],
              ));
            },
          );
        },
      )),
      DataCell(Row(
        children: [
          TextButton(onPressed: () {}, child: const Text('Regular')),
          TextButton(onPressed: () {}, child: const Text('Preventive'))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => sites.length;

  @override
  int get selectedRowCount => 0;

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
