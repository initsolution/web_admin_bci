import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/masterpointchecklistpreventive.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_provider.dart';
import 'package:flutter_web_ptb/providers/masterpointchecklistpreventive_provider.dart';
import 'package:flutter_web_ptb/providers/masterpointchecklistpreventive_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_masterpointchecklistpreventive.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

class MasterPointChecklistPreventivetData extends DataTableSource {
  final List<MasterPointChecklistPreventive> masterData;
  final BuildContext context;
  final WidgetRef ref;

  MasterPointChecklistPreventivetData(
      {required this.masterData, required this.context, required this.ref});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(
          Text(masterData[index].mcategorychecklistpreventive!.categoryName!)),
      DataCell(Text(masterData[index].uraian!)),
      // DataCell(Text(masterData[index].kriteria!)),
      DataCell(ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Text(masterData[index].kriteria!,
            overflow: TextOverflow.ellipsis),
      )),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SizedBox(
                      child: DialogAddmasterPointChecklistPreventive(
                    isEdit: true,
                    editMasterPointChecklistPreventive: masterData[index],
                  ));
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title:
                        const Text('Delete Master Point Checklist Preventive'),
                    content: Text(
                        'Do you want to delete ${masterData[index].kriteria}?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ref
                                .read(
                                    masterPointChecklistPreventiveNotifierProvider
                                        .notifier)
                                .deleteMasterPointChecklistPreventive(
                                    masterData[index].id!);
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
  int get rowCount => masterData.length;

  @override
  int get selectedRowCount => 0;
}

class MasterPointChecklistPreventiveScreen extends ConsumerStatefulWidget {
  const MasterPointChecklistPreventiveScreen({super.key});

  @override
  ConsumerState<MasterPointChecklistPreventiveScreen> createState() =>
      _MasterPointChecklistPreventiveScreenState();
}

class _MasterPointChecklistPreventiveScreenState
    extends ConsumerState<MasterPointChecklistPreventiveScreen> {
  late List<MasterPointChecklistPreventive> filterData;
  bool _sortCategoryNameAsc = true;
  bool _sortUraianeAsc = true;
  bool _sortKriteriaNameAsc = true;
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void initState() {
    Future(() {
      ref
          .read(masterPointChecklistPreventiveNotifierProvider.notifier)
          .getAllMasterPointChecklistPreventive();
      ref
          .read(masterCategoryChecklistPreventivNotifierProvider.notifier)
          .getAllMasterCategoryChecklistPreventive();
    });
    super.initState();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  void sort(columnIndex) {
    setState(() {
      if (columnIndex == 0) {
        //categoryName
        if (_sortCategoryNameAsc == true) {
          _sortCategoryNameAsc = false;
          filterData.sort((a, b) => b
              .mcategorychecklistpreventive!.categoryName!
              .compareTo(a.mcategorychecklistpreventive!.categoryName!));
        } else {
          _sortCategoryNameAsc = true;
          filterData.sort((a, b) => a
              .mcategorychecklistpreventive!.categoryName!
              .compareTo(b.mcategorychecklistpreventive!.categoryName!));
        }
      } else if (columnIndex == 1) {
        //uraian
        if (_sortUraianeAsc == true) {
          _sortUraianeAsc = false;
          filterData.sort((a, b) => b.uraian!.compareTo(a.uraian!));
        } else {
          _sortUraianeAsc = true;
          filterData.sort((a, b) => a.uraian!.compareTo(b.uraian!));
        }
      } else if (columnIndex == 2) {
        //kriteria
        if (_sortKriteriaNameAsc == true) {
          _sortKriteriaNameAsc = false;
          filterData.sort((a, b) => b.kriteria!.compareTo(a.kriteria!));
        } else {
          _sortKriteriaNameAsc = true;
          filterData.sort((a, b) => a.kriteria!.compareTo(b.kriteria!));
        }
      }
    });
  }

  Widget tableMaster() {
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
                        var state = ref.watch(
                            masterPointChecklistPreventiveNotifierProvider);
                        if (state is MasterPointChecklistPreventiveLoaded) {
                          DataTableSource data =
                              MasterPointChecklistPreventivetData(
                                  ref: ref,
                                  context: context,
                                  masterData:
                                      state.masterPointChecklistPreventive);
                          filterData = state.masterPointChecklistPreventive;
                          return PaginatedDataTable(
                            columns: [
                              DataColumn(
                                label: const Text('Name Category'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Uraian'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Kriteria'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              const DataColumn(label: Text('Actions')),
                            ],
                            source: data,
                            // header:
                            //     const Text('Master Point Checklist Preventive'),
                            horizontalMargin: 10,
                            rowsPerPage: 10,
                            showCheckboxColumn: false,
                          );
                        } else if (state
                            is MasterPointChecklistPreventiveLoading) {
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
  Widget build(BuildContext context) {
    ref.listen(masterPointChecklistPreventiveNotifierProvider,
        (previous, next) {
      if (next is MasterPointChecklistPreventiveErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is MasterPointChecklistPreventiveDataChangeSuccess) {
        ref
            .read(masterPointChecklistPreventiveNotifierProvider.notifier)
            .getAllMasterPointChecklistPreventive();
      }
    });

    return PortalMasterLayout(
        body: ListView(
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
        const Header(
          title: 'Master Point Checklist Preventive',
          subMenu: 'submenu Master Point Checklist Preventive',
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
                              .read(
                                  masterPointChecklistPreventiveNotifierProvider
                                      .notifier)
                              .searchMasterPointChecklistPrev(
                                  value)), // onChanged return the value of the field
                          decoration: InputDecoration(
                              labelText: "Search Uraian",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                  child:
                                      DialogAddmasterPointChecklistPreventive());
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
                              .read(
                                  masterPointChecklistPreventiveNotifierProvider
                                      .notifier)
                              .getAllMasterPointChecklistPreventive();
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
                  tableMaster(),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
