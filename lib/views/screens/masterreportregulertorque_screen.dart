import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/masterreportregulertorque.dart';
import 'package:flutter_web_ptb/providers/masterreportregulertorque_provider.dart';
import 'package:flutter_web_ptb/providers/masterreportregulertorque_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
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
  Widget tableMasterReportRegulerTorque() {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Consumer(
          builder: (context, ref, child) {
            var state = ref.watch(masterReportRegulerTorqueNotifierProvider);
            if (state is MasterReportRegulerTorqueStateLoaded) {
              DataTableSource data = MasterReportRegulerTorqueData(
                  masterTorque: state.masterReportRegulerTorque);
              return Theme(
                data: ThemeData(
                    cardColor: Theme.of(context).cardColor,
                    textTheme: const TextTheme(
                        titleLarge: TextStyle(color: Colors.blue))),
                child: PaginatedDataTable(
                  source: data,
                  header: const Text('Master Report Reguler Torque'),
                  columns: const [
                    DataColumn(label: Text('Fabricator')),
                    DataColumn(label: Text('Tower Height')),
                    DataColumn(label: Text('Tower Segment')),
                    DataColumn(label: Text('Elevasi')),
                    DataColumn(label: Text('Bolt Size')),
                    DataColumn(label: Text('Minimum Torque')),
                    DataColumn(label: Text('Qty Bolt')),
                  ],
                  columnSpacing: 100,
                  horizontalMargin: 10,
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                ),
              );
            } else if (state is MasterReportRegulerTorqueStateLoading) {
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
          Header(
            title: 'Master Report Reguler Torque',
            subMenu: 'submenu master torque',
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
                                        DialogAddMasterReportRegulerTorque());
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
                                .read(masterReportRegulerTorqueNotifierProvider
                                    .notifier)
                                .getAllMasterReportRegulerTorqueRepo();
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
  MasterReportRegulerTorqueData({required this.masterTorque});

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
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => masterTorque.length;

  @override
  int get selectedRowCount => 0;
}
