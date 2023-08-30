import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/mastercategorychecklistpreventive.dart';
import 'package:flutter_web_ptb/model/masterpointchecklistpreventive.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_provider.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_state.dart';
import 'package:flutter_web_ptb/providers/masterpointchecklistpreventive_provider.dart';
import 'package:flutter_web_ptb/providers/masterpointchecklistpreventive_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_masterpointchecklistpreventive.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

class MasterPointChecklistPreventivetData extends DataTableSource {
  final List<MasterPointChecklistPreventive> masterData;
  MasterPointChecklistPreventivetData({required this.masterData});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(masterData[index].mcategorychecklistpreventive!.name!)),
      DataCell(Text(masterData[index].uraian!)),
      DataCell(Text(masterData[index].kriteria!)),
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
  Widget tableMaster() {
    return Center(
      child: Consumer(builder: (context, ref, child) {
        var state = ref.watch(masterPointChecklistPreventiveNotifierProvider);
        if (state is MasterPointChecklistPreventiveLoaded) {
          DataTableSource data = MasterPointChecklistPreventivetData(
              masterData: state.masterPointChecklistPreventive);
          return PaginatedDataTable(
            columns: const [
              DataColumn(label: Text('Name Category')),
              DataColumn(label: Text('Uraian')),
              DataColumn(label: Text('Kriteria')),
            ],
            source: data,
            header: const Text('Master Point Checklist Preventive'),
            columnSpacing: 100,
            horizontalMargin: 10,
            rowsPerPage: 10,
            showCheckboxColumn: false,
          );
        } else if (state is MasterPointChecklistPreventiveLoading) {
          return const CircularProgressIndicator();
        }
        return Container();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var value = ref.watch(userDataProvider.select((value) => value.username));
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
      }
    });

    return PortalMasterLayout(
        body: ListView(
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
        Header(
            title: 'Master Point Checklist Preventive',
            subMenu: 'submenu Master Point Checklist Preventive',
            userName: value),
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
                      Consumer(builder: ((context, ref, child) {
                        late List<MasterCategoryChecklistPreventive>
                            dataCategoryChecklistPreventive;
                        var stateCategoryChecklistPreventive = ref.watch(
                            masterCategoryChecklistPreventivNotifierProvider);
                        if (stateCategoryChecklistPreventive
                            is MasterCategoryChecklistPreventiveLoaded) {
                          dataCategoryChecklistPreventive =
                              stateCategoryChecklistPreventive
                                  .masterCategoryPrev;
                        }
                        return IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            ref
                                .read(selectedCategoryChecklistPreventive
                                    .notifier)
                                .state = dataCategoryChecklistPreventive[0];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                    child:
                                        DialogAddmasterPointChecklistPreventive(
                                            dataCategoryChecklistPreventive:
                                                dataCategoryChecklistPreventive));
                              },
                            );
                          },
                        );
                      })),
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
                  Center(child: tableMaster())
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
