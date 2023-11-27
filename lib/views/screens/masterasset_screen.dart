import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/masterasset.dart';
import 'package:flutter_web_ptb/providers/masterasset_provider.dart';
import 'package:flutter_web_ptb/providers/masterasset_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_masterasset.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import '../../providers/user_data_provider.dart';

class MasterAssetScreen extends ConsumerStatefulWidget {
  const MasterAssetScreen({super.key});

  @override
  ConsumerState<MasterAssetScreen> createState() => _MasterAssetScreenState();
}

class _MasterAssetScreenState extends ConsumerState<MasterAssetScreen> {
  late List<MasterAsset> filterData;
  bool _sortTaskTypeAsc = true;
  bool _sortSectionAsc = true;
  final _dataTableHorizontalScrollController = ScrollController();

  void sort(columnIndex) {
    setState(() {
      if (columnIndex == 0) {
        //taskType
        if (_sortTaskTypeAsc == true) {
          _sortTaskTypeAsc = false;
          filterData.sort((a, b) => b.taskType!.compareTo(a.taskType!));
        } else {
          _sortTaskTypeAsc = true;
          filterData.sort((a, b) => a.taskType!.compareTo(b.taskType!));
        }
      } else if (columnIndex == 1) {
        //section
        if (_sortSectionAsc == true) {
          _sortSectionAsc = false;
          filterData.sort((a, b) => b.section!.compareTo(a.section!));
        } else {
          _sortSectionAsc = true;
          filterData.sort((a, b) => a.section!.compareTo(b.section!));
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
                          var state = ref.watch(masterAssetNotifierProvider);
                          if (state is MasterAssetLoaded) {
                            DataTableSource data = MasterAssetData(
                                masterAssets: state.masterAssets);
                            filterData = state.masterAssets;
                            return PaginatedDataTable(
                              source: data,
                              header: const Text('Master Asset'),
                              columns: [
                                DataColumn(
                                  label: const Text(
                                    'Task Type',
                                  ),
                                  onSort: (columnIndex, _) {
                                    sort(columnIndex);
                                  },
                                ),
                                DataColumn(
                                  label: const Text('Section'),
                                  onSort: (columnIndex, _) {
                                    sort(columnIndex);
                                  },
                                ),
                                const DataColumn(label: Text('Fabricator')),
                                const DataColumn(label: Text('Tower Height')),
                                const DataColumn(label: Text('Category')),
                                const DataColumn(label: Text('Description')),
                              ],
                              horizontalMargin: 10,
                              rowsPerPage: 10,
                              showCheckboxColumn: false,
                            );
                          } else if (state is MasterAssetLoading) {
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
                  ));
            },
          )),
    );
  }

  @override
  void initState() {
    Future(() =>
        ref.read(masterAssetNotifierProvider.notifier).getAllMasterAsset());
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
    ref.listen(masterAssetNotifierProvider, (previous, next) {
      if (next is MasterAssetErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is MasterAssetDataChangeSuccess) {
        ref.read(masterAssetNotifierProvider.notifier).getAllMasterAsset();
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const Header(title: 'Master Asset', subMenu: 'submenu master asset'),
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
                                .read(masterAssetNotifierProvider.notifier)
                                .searchMasterAsset(
                                    value)), // onChanged return the value of the field
                            decoration: InputDecoration(
                                labelText: "Search Task Type",
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
                                return SizedBox(child: DialogAddMasterAsset());
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
                                .read(masterAssetNotifierProvider.notifier)
                                .getAllMasterAsset();
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {},
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                        const SizedBox(
                          width: 30,
                        ),
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

class MasterAssetData extends DataTableSource {
  final List<MasterAsset> masterAssets;
  MasterAssetData({required this.masterAssets});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(masterAssets[index].taskType!)),
      DataCell(Text(masterAssets[index].section!)),
      DataCell(Text(masterAssets[index].fabricator!)),
      DataCell(Text(masterAssets[index].towerHeight!.toString())),
      DataCell(Text(masterAssets[index].category!)),
      DataCell(Text(masterAssets[index].description!)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => masterAssets.length;

  @override
  int get selectedRowCount => 0;
}
