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
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  Map<String, dynamic> params = {};
  Map<String, dynamic> filter = {};
  String token = '';
  late Employee employee;
  late DateTimeRange dateRange;
  getDataToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    token = sharedPref.getString(StorageKeys.token) ?? '';
    employee = Employee.fromMap(JwtDecoder.decode(token)['employee']);
    debugPrint(employee.toString());
    await getTaskWithFilter();
  }

  getTaskWithFilter() async {
    params = {
      "join": [
        'site',
        'makerEmployee',
        'verifierEmployee',
        'categorychecklistprev',
        'categorychecklistprev.pointChecklistPreventive',
        'reportRegulerTorque',
        'reportRegulerVerticality',
        'reportRegulerVerticality.valueVerticality'
      ],
      // 'filter': 'verifierEmployee.nik||eq||${employee.nik}',
      'sort': ['updated_at,DESC']
    };
    if (employee.role! == 'Verify') {
      filter = {
        'filter': [
          'verifierEmployee.nik||eq||${employee.nik}',
          'created_at||gte||${DateFormat('yyyy-MM-dd').format(dateRange.start)}',
          'created_at||lte||${DateFormat('yyyy-MM-dd').format(dateRange.end.add(const Duration(days: 1)))}',
        ]
      };
    } else {
      filter = {
        'filter': [
          'created_at||gte||${DateFormat('yyyy-MM-dd').format(dateRange.start)}',
          'created_at||lte||${DateFormat('yyyy-MM-dd').format(dateRange.end.add(const Duration(days: 1)))}',
        ]
      };
    }
    params.addAll(filter);

    Future(() => ref.read(taskNotifierProvider.notifier).getAllTask(params));
  }

  @override
  void initState() {
    dateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now());
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: 150,
                          // height: 40,
                          child: getDropdownStatus(),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        datePick(),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        SizedBox(
                          width: 100,
                          // height: 40,
                          child: TextField(
                            onChanged: (value) => Future(() => ref
                                .read(taskNotifierProvider.notifier)
                                .searchTask(
                                    value)), // onChanged return the value of the field
                            decoration: InputDecoration(
                                labelText: "Search ...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
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

  Widget datePick() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        side: const BorderSide(color: Color.fromARGB(255, 187, 201, 230)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        showDateRangePicker(
                context: context,
                firstDate: DateTime(2022),
                lastDate: DateTime(2040),
                initialDateRange: dateRange,
                initialEntryMode: DatePickerEntryMode.calendarOnly)
            .then((value) {
          setState(() {
            if (value != null) dateRange = value;
            debugPrint(
                'periode : ${DateFormat('dd/MM/yyyy').format(dateRange.start)}  -  ${DateFormat('dd/MM/yyyy').format(dateRange.end)}');
          });
          getTaskWithFilter();
        });
      },
      icon: const Icon(
        Icons.calendar_month_rounded,
        color: Colors.white,
      ),
      label: Text(
        '${DateFormat('dd/MM/yyyy').format(dateRange.start)}  -  ${DateFormat('dd/MM/yyyy').format(dateRange.end)} ',
        style: const TextStyle(color: Colors.white),
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

  Widget getDropdownStatus() {
    List<String> dataStatus = ['All', 'Todo', 'Review', 'Verified'];
    final String status = ref.watch(statusTaskProvider);
    return Consumer(builder: (_, WidgetRef ref, __) {
      return DropdownButton(
        value: status.isNotEmpty ? status : null,
        onChanged: (value) {
          ref.read(taskNotifierProvider.notifier).filterStatus(value!);
          ref.read(statusTaskProvider.notifier).state = value;
        },
        items: dataStatus.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
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
      DataCell(task.status == 'todo'
          ? Container()
          : IconButton(
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
