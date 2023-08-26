import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/masterasset.dart';
import 'package:flutter_web_ptb/providers/masterasset_provider.dart';
import 'package:flutter_web_ptb/providers/masterasset_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
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
  Widget tableMasterAsset() {
    return Center(child: Consumer(
      builder: (context, ref, child) {
        var state = ref.watch(masterAssetNotifierProvider);
        if (state is MasterAssetLoaded) {
          DataTableSource data = MasterAssetData(masterAssets: state.masterAssets);
          return PaginatedDataTable(
            source: data,
            header: const Text('Master Asset'),
            columns: const [
              DataColumn(label: Text('Tower Category')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Description')),
            ],
            columnSpacing: 100,
            horizontalMargin: 10,
            rowsPerPage: 10,
            showCheckboxColumn: false,
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
                          onPressed: () {},
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
      DataCell(Text(masterAssets[index].tower_category!)),
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
