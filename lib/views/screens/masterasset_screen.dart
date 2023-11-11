import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/masterasset.dart';
import 'package:flutter_web_ptb/providers/masterasset_provider.dart';
import 'package:flutter_web_ptb/providers/masterasset_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme.dart';
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
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Consumer(
          builder: (context, ref, child) {
            var state = ref.watch(masterAssetNotifierProvider);
            if (state is MasterAssetLoaded) {
              DataTableSource data =
                  MasterAssetData(masterAssets: state.masterAssets);
              filterData = state.masterAssets;
              return Theme(
                data: ThemeData(
                    cardColor: Theme.of(context).cardColor,
                    textTheme: const TextTheme(
                        titleLarge: TextStyle(color: Colors.blue))),
                child: PaginatedDataTable(
                  source: data,
                  header: const Text('Master Asset'),
                  columns: [
                    DataColumn(
                      label: const Text(
                        'Task Type',
                        style: tableHeader,
                      ),
                      onSort: (columnIndex, _) {
                        sort(columnIndex);
                      },
                    ),
                    DataColumn(
                      label: const Text('Section', style: tableHeader),
                      onSort: (columnIndex, _) {
                        sort(columnIndex);
                      },
                    ),
                    const DataColumn(
                        label: Text('Fabricator', style: tableHeader)),
                    const DataColumn(
                        label: Text('Tower Height', style: tableHeader)),
                    const DataColumn(
                        label: Text('Category', style: tableHeader)),
                    const DataColumn(
                        label: Text('Description', style: tableHeader)),
                  ],
                  horizontalMargin: 10,
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                ),
              );
            } else if (state is MasterAssetLoading) {
              return const CircularProgressIndicator();
            }
            return Container();
          },
        ));
  }

  @override
  void initState() {
    Future(() =>
        ref.read(masterAssetNotifierProvider.notifier).getAllMasterAsset());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    var value = ref.watch(userDataProvider.select((value) => value.username));
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
          Header(
            title: 'Master Asset',
            subMenu: 'submenu master asset',
            userName: value,
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
                          icon: const Icon(Icons.search),
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
                    Center(child: tableMasterAsset())
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
