import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/asset_provider.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';
import 'package:flutter_web_ptb/providers/task_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  Map<String, dynamic> params = {};

  String token = '';
  getDataToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    token = sharedPref.getString(StorageKeys.token) ?? '';
    Employee employee = Employee.fromMap(JwtDecoder.decode(token)['employee']);
    params = {
      "join": ['site', 'makerEmployee', 'verifierEmployee'],
      'filter': 'verifierEmployee.nik||eq||${employee.nik}',
      'sort': ['updated_at,DESC']
    };
  }

  @override
  void initState() {
    getDataToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var value = ref.watch(userDataProvider.select((value) => value.username));
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Header(
            title: 'Verifikator',
            subMenu: 'Verifikasi maker',
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
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            ref
                                .read(taskNotifierProvider.notifier)
                                .getAllTask(params);
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
                    Center(child: tableTask())
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableTask() {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Consumer(
          builder: (context, ref, child) {
            var state = ref.watch(taskNotifierProvider);
            // if (DEBUG) debugPrint('state : $state');
            if (state is TaskLoaded) {
              DataTableSource data =
                  TaskData(tasks: state.tasks, context: context, ref: ref);
              return Theme(
                data: ThemeData(
                    cardColor: Theme.of(context).cardColor,
                    textTheme: const TextTheme(
                        titleLarge: TextStyle(color: Colors.blue))),
                child: PaginatedDataTable(
                  source: data,
                  header: const Text('Data Task'),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Site')),
                    DataColumn(label: Text('Maker')),
                    DataColumn(label: Text('Verifier')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Created Date')),
                    DataColumn(label: Text('Verifikasi')),
                  ],
                  columnSpacing: 100,
                  horizontalMargin: 10,
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                ),
              );
            } else if (state is TaskLoading) {
              return const CircularProgressIndicator();
            }
            return Container();
          },
        ));
  }
}

class TaskData extends DataTableSource {
  final List<Task> tasks;
  final BuildContext context;
  final WidgetRef ref;
  TaskData({required this.tasks, required this.context, required this.ref});

  @override
  DataRow? getRow(int index) {
    Task task = tasks[index];
    debugPrint(task.toString());
    return DataRow(cells: [
      DataCell(Text(task.id!.toString())),
      DataCell(Text(task.site!.name!)),
      DataCell(Text(task.makerEmployee!.name!)),
      DataCell(Text(task.verifierEmployee!.name!)),
      DataCell(Text(task.status!)),
      DataCell(Text(task.type!)),
      DataCell(Text(task.createdDate!)),
      DataCell(IconButton(
        icon: const Icon(Icons.verified_outlined),
        onPressed: () {
          Map<String, dynamic> header = {
            'filter': 'task.id||eq||${task.id}',
            "join": [
              "task",
            ],
            'sort': 'orderIndex,ASC'
          };
          ref.read(assetNotifierProvider.notifier).getAllAsset(header);
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return const SizedBox(
          //         child: DialogAsset(),
          //       );
          //     });
          GoRouter.of(context).go(RouteUri.resultAsset, extra: task);
        },
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tasks.length;

  @override
  int get selectedRowCount => 0;
}
