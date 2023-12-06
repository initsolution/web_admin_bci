import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/mastercategorychecklistpreventive.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_provider.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

import '../widgets/dialog_add_mastercategorychecklistpreventive.dart';
// import 'package:provider/provider.dart';

// import '../../providers/user_data_provider.dart';

class MasterCategoryChecklistPreventiveScreen extends ConsumerStatefulWidget {
  const MasterCategoryChecklistPreventiveScreen({super.key});

  @override
  ConsumerState<MasterCategoryChecklistPreventiveScreen> createState() =>
      _MasterCategoryChecklistPreventiveScreenState();
}

class _MasterCategoryChecklistPreventiveScreenState
    extends ConsumerState<MasterCategoryChecklistPreventiveScreen> {
  late List<MasterCategoryChecklistPreventive> filterData;
  bool _sortCategoryNameAsc = true;
  final _dataTableHorizontalScrollController = ScrollController();

  void sort(columnIndex) {
    setState(() {
      if (columnIndex == 0) {
        //categoryName
        if (_sortCategoryNameAsc == true) {
          _sortCategoryNameAsc = false;
          filterData.sort((a, b) => b.categoryName!.compareTo(a.categoryName!));
        } else {
          _sortCategoryNameAsc = true;
          filterData.sort((a, b) => a.categoryName!.compareTo(b.categoryName!));
        }
      }
    });
  }

  Widget tableMasterAsset() {
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
                                masterCategoryChecklistPreventivNotifierProvider);
                            if (state
                                is MasterCategoryChecklistPreventiveLoaded) {
                              DataTableSource data =
                                  MasterCategoryChecklistPreventivetData(
                                      masterCategoryPrev:
                                          state.masterCategoryPrev,
                                      ref: ref,
                                      context: context);
                              filterData = state.masterCategoryPrev;
                              return PaginatedDataTable(
                                source: data,
                                // header: const Text(
                                //     'Master Category Checklist Preventive'),
                                columns: [
                                  DataColumn(
                                    label: const Text('Name'),
                                    onSort: (columnIndex, _) {
                                      sort(columnIndex);
                                    },
                                  ),
                                  const DataColumn(label: Text('Actions')),
                                ],
                                horizontalMargin: 25,
                                rowsPerPage: 10,
                                showCheckboxColumn: false,
                              );
                            } else if (state
                                is MasterCategoryChecklistPreventiveLoading) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return Container();
                          },
                        )),
                  ));
            },
          )),
    );
  }

  @override
  void initState() {
    Future(() => ref
        .read(masterCategoryChecklistPreventivNotifierProvider.notifier)
        .getAllMasterCategoryChecklistPreventive());
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
    ref.listen(masterCategoryChecklistPreventivNotifierProvider,
        (previous, next) {
      if (next is MasterCategoryChecklistPreventiveErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is MasterCategoryChecklistPreventiveDataChangeSuccess) {
        if (DEBUG) {
          debugPrint(
              'masuk MasterCategoryChecklistPreventiveDataChangeSuccess');
        }
        ref
            .read(masterCategoryChecklistPreventivNotifierProvider.notifier)
            .getAllMasterCategoryChecklistPreventive();
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const Header(
              title: 'Master Category Checklist Preventive',
              subMenu: 'submenu master category checklist preventive'),
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
                                    masterCategoryChecklistPreventivNotifierProvider
                                        .notifier)
                                .searchCategoryChecklistPrev(value)),
                            onSubmitted: (value) {
                              Future(() => ref
                                  .read(
                                      masterCategoryChecklistPreventivNotifierProvider
                                          .notifier)
                                  .searchCategoryChecklistPrev(value));
                            }, // onChanged return the value of the field
                            decoration: InputDecoration(
                                labelText: "Search Category",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                    child:
                                        DialogAddMasterCategoryChecklistPreventive());
                              },
                            ),
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
                                    masterCategoryChecklistPreventivNotifierProvider
                                        .notifier)
                                .getAllMasterCategoryChecklistPreventive();
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
                    tableMasterAsset(),
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

class MasterCategoryChecklistPreventivetData extends DataTableSource {
  final List<MasterCategoryChecklistPreventive> masterCategoryPrev;
  final BuildContext context;
  final WidgetRef ref;
  MasterCategoryChecklistPreventivetData(
      {required this.masterCategoryPrev,
      required this.context,
      required this.ref});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(masterCategoryPrev[index].categoryName!)),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SizedBox(
                      child: DialogAddMasterCategoryChecklistPreventive(
                    isEdit: true,
                    editMasterCategoryChecklistPreventive:
                        masterCategoryPrev[index],
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
                    title: const Text(
                        'Delete Master Category Checklist Preventive'),
                    content: Text(
                        'Do you want to delete ${masterCategoryPrev[index].categoryName}?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ref
                                .read(
                                    masterCategoryChecklistPreventivNotifierProvider
                                        .notifier)
                                .deleteMasterCategoryChecklistPreventive(
                                    masterCategoryPrev[index].id!);
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
  int get rowCount => masterCategoryPrev.length;

  @override
  int get selectedRowCount => 0;
}
