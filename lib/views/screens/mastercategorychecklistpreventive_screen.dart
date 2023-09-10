import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/mastercategorychecklistpreventive.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_provider.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
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
  Widget tableMasterAsset() {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Consumer(
          builder: (context, ref, child) {
            var state =
                ref.watch(masterCategoryChecklistPreventivNotifierProvider);
            if (state is MasterCategoryChecklistPreventiveLoaded) {
              DataTableSource data = MasterCategoryChecklistPreventivetData(
                  masterCategoryPrev: state.masterCategoryPrev);
              return Theme(
                data: ThemeData(
                    cardColor: Theme.of(context).cardColor,
                    textTheme: const TextTheme(
                        titleLarge: TextStyle(color: Colors.blue))),
                child: PaginatedDataTable(
                  source: data,
                  header: const Text('Master Category Checklist Preventive'),
                  columns: const [
                    DataColumn(label: Text('Name')),
                  ],
                  columnSpacing: 100,
                  horizontalMargin: 10,
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                ),
              );
            } else if (state is MasterCategoryChecklistPreventiveLoading) {
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
        if (DEBUG)
          debugPrint(
              'masuk MasterCategoryChecklistPreventiveDataChangeSuccess');
        ref
            .read(masterCategoryChecklistPreventivNotifierProvider.notifier)
            .getAllMasterCategoryChecklistPreventive();
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Header(
            title: 'Master Category Checklist Preventive',
            subMenu: 'submenu master category checklist preventive',
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

class MasterCategoryChecklistPreventivetData extends DataTableSource {
  final List<MasterCategoryChecklistPreventive> masterCategoryPrev;
  MasterCategoryChecklistPreventivetData({required this.masterCategoryPrev});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(masterCategoryPrev[index].categoryName!)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => masterCategoryPrev.length;

  @override
  int get selectedRowCount => 0;
}
