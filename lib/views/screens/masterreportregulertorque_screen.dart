import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/masterreportregulertorque.dart';
import 'package:flutter_web_ptb/providers/masterreportregulertorque_provider.dart';
import 'package:flutter_web_ptb/providers/masterreportregulertorque_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

import '../widgets/dialog_add_masterreportregulertorque.dart';
// import 'package:provider/provider.dart';

// import '../../providers/user_data_provider.dart';

class MasterReportRegulerTorqueScreen extends ConsumerStatefulWidget {
  const MasterReportRegulerTorqueScreen({super.key});

  @override
  ConsumerState<MasterReportRegulerTorqueScreen> createState() =>
      _MasterReportRegulerTorqueScreenState();
}

class _MasterReportRegulerTorqueScreenState
    extends ConsumerState<MasterReportRegulerTorqueScreen> {
  late List<MasterReportRegulerTorque> filterData;
  bool _sortFabricatorAsc = true;
  bool _sortTowerHeightAsc = true;
  bool _sortTowerSegmentAsc = true;
  bool _sortElevasiAsc = true;
  bool _sortBoltSizeAsc = true;
  bool _sortMinumumTorqueAsc = true;
  bool _sortQtyBoltAsc = true;
  final _dataTableHorizontalScrollController = ScrollController();

  void sort(columnIndex) {
    setState(() {
      if (columnIndex == 0) {
        //fabricator
        if (_sortFabricatorAsc == true) {
          _sortFabricatorAsc = false;
          filterData.sort((a, b) => b.fabricator!.compareTo(a.fabricator!));
        } else {
          _sortFabricatorAsc = true;
          filterData.sort((a, b) => a.fabricator!.compareTo(b.fabricator!));
        }
      } else if (columnIndex == 1) {
        //towerheight
        if (_sortTowerHeightAsc == true) {
          _sortTowerHeightAsc = false;
          filterData.sort((a, b) => b.towerHeight!.compareTo(a.towerHeight!));
        } else {
          _sortTowerHeightAsc = true;
          filterData.sort((a, b) => a.towerHeight!.compareTo(b.towerHeight!));
        }
      } else if (columnIndex == 2) {
        //towersegment
        if (_sortTowerSegmentAsc == true) {
          _sortTowerSegmentAsc = false;
          filterData.sort((a, b) => b.towerSegment!.compareTo(a.towerSegment!));
        } else {
          _sortTowerSegmentAsc = true;
          filterData.sort((a, b) => a.towerSegment!.compareTo(b.towerSegment!));
        }
      } else if (columnIndex == 3) {
        //elevasi
        if (_sortElevasiAsc == true) {
          _sortElevasiAsc = false;
          filterData.sort((a, b) => b.elevasi!.compareTo(a.elevasi!));
        } else {
          _sortElevasiAsc = true;
          filterData.sort((a, b) => a.elevasi!.compareTo(b.elevasi!));
        }
      } else if (columnIndex == 2) {
        //towersegment
        if (_sortTowerSegmentAsc == true) {
          _sortTowerSegmentAsc = false;
          filterData.sort((a, b) => b.towerSegment!.compareTo(a.towerSegment!));
        } else {
          _sortTowerSegmentAsc = true;
          filterData.sort((a, b) => a.towerSegment!.compareTo(b.towerSegment!));
        }
      } else if (columnIndex == 4) {
        //boltsize
        if (_sortBoltSizeAsc == true) {
          _sortBoltSizeAsc = false;
          filterData.sort((a, b) => b.boltSize!.compareTo(a.boltSize!));
        } else {
          _sortBoltSizeAsc = true;
          filterData.sort((a, b) => a.boltSize!.compareTo(b.boltSize!));
        }
      } else if (columnIndex == 5) {
        //minimumtorque
        if (_sortMinumumTorqueAsc == true) {
          _sortMinumumTorqueAsc = false;
          filterData
              .sort((a, b) => b.minimumTorque!.compareTo(a.minimumTorque!));
        } else {
          _sortMinumumTorqueAsc = true;
          filterData
              .sort((a, b) => a.minimumTorque!.compareTo(b.minimumTorque!));
        }
      } else if (columnIndex == 6) {
        //qtybolt
        if (_sortQtyBoltAsc == true) {
          _sortQtyBoltAsc = false;
          filterData.sort((a, b) => b.qtyBolt!.compareTo(a.qtyBolt!));
        } else {
          _sortQtyBoltAsc = true;
          filterData.sort((a, b) => a.qtyBolt!.compareTo(b.qtyBolt!));
        }
      }
    });
  }

  Widget tableMasterReportRegulerTorque() {
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
                        var state = ref
                            .watch(masterReportRegulerTorqueNotifierProvider);
                        if (state is MasterReportRegulerTorqueStateLoaded) {
                          DataTableSource data = MasterReportRegulerTorqueData(
                              ref: ref,
                              context: context,
                              masterTorque: state.masterReportRegulerTorque);
                          filterData = state.masterReportRegulerTorque;
                          return PaginatedDataTable(
                            source: data,
                            // header: const Text('Master Report Reguler Torque'),
                            columns: [
                              DataColumn(
                                label: const Text('Fabricator'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Tower Height'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Tower Segment'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Elevasi'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Bolt Size'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Minimum Torque'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Qty Bolt'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              const DataColumn(label: Text('Actions')),
                            ],
                            horizontalMargin: 10,
                            rowsPerPage: 10,
                            showCheckboxColumn: false,
                          );
                        } else if (state
                            is MasterReportRegulerTorqueStateLoading) {
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

  @override
  void initState() {
    Future(() => ref
        .read(masterReportRegulerTorqueNotifierProvider.notifier)
        .getAllMasterReportRegulerTorqueRepo());
    super.initState();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    ref.listen(masterReportRegulerTorqueNotifierProvider, (previous, next) {
      if (next is MasterReportRegulerTorqueErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is MasterReportRegulerTorqueDataChangeSuccess) {
        ref
            .read(masterReportRegulerTorqueNotifierProvider.notifier)
            .getAllMasterReportRegulerTorqueRepo();
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const Header(
            title: 'Master Report Reguler Torque',
            subMenu: 'submenu master torque',
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                margin: const EdgeInsets.only(top: 15),
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
                                .read(masterReportRegulerTorqueNotifierProvider
                                    .notifier)
                                .searchMasterReportRegulerTorque(value)),
                            onSubmitted: (value) {
                              Future(() => ref
                                  .read(
                                      masterReportRegulerTorqueNotifierProvider
                                          .notifier)
                                  .searchMasterReportRegulerTorque(value));
                            }, // onChanged return the value of the field
                            decoration: InputDecoration(
                                labelText: "Search Fabricator",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.add),
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                    child:
                                        DialogAddMasterReportRegulerTorque());
                              },
                            ),
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            ref
                                .read(masterReportRegulerTorqueNotifierProvider
                                    .notifier)
                                .getAllMasterReportRegulerTorqueRepo();
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.filter_list),
                        //   onPressed: () {},
                        // ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                        // IconButton(
                        //   icon: const Icon(Icons.more_vert),
                        //   onPressed: () {},
                        // ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(child: tableMasterReportRegulerTorque())
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MasterReportRegulerTorqueData extends DataTableSource {
  final List<MasterReportRegulerTorque> masterTorque;
  final BuildContext context;
  final WidgetRef ref;
  MasterReportRegulerTorqueData(
      {required this.masterTorque, required this.ref, required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(masterTorque[index].fabricator!)),
      DataCell(Text(masterTorque[index].towerHeight!.toString())),
      DataCell(Text(masterTorque[index].towerSegment!)),
      DataCell(Text(masterTorque[index].elevasi!.toString())),
      DataCell(Text(masterTorque[index].boltSize!)),
      DataCell(Text(masterTorque[index].minimumTorque!.toString())),
      DataCell(Text(masterTorque[index].qtyBolt!.toString())),
      DataCell(Row(
        children: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    // debugPrint(masterAssets[index].toString());
                    return SizedBox(
                      child: DialogAddMasterReportRegulerTorque(
                        isEdit: true,
                        editMasterReportRegulerTorque: masterTorque[index],
                      ),
                    );
                  });
            },
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Master Reguler Torque'),
                    content: Text(
                        'Do you want to delete ${masterTorque[index].fabricator} - ${masterTorque[index].towerHeight}?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ref
                                .read(masterReportRegulerTorqueNotifierProvider
                                    .notifier)
                                .deleteMasterReportRegulerTorque(
                                    masterTorque[index].id!);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Colors.green),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  );
                },
              );
            },
          )
        ],
      ))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => masterTorque.length;

  @override
  int get selectedRowCount => 0;
}
