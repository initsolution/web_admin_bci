// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/asset_provider.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';
import 'package:flutter_web_ptb/providers/task_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  final _dataTableHorizontalScrollController = ScrollController();
  getDataToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    token = sharedPref.getString(StorageKeys.token) ?? '';
    employee = Employee.fromMap(JwtDecoder.decode(token)['employee']);
    debugPrint(employee.toString());
    await getTaskWithFilter();
  }

  getTaskWithFilter() async {
    debugPrint('getTaskWithFilter');
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
    Future(() => ref.read(statusTaskProvider.notifier).state = statusTask);
    dateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now());
    getDataToken();
    super.initState();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(taskNotifierProvider, (previous, next) {
      if (next is TaskErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is TaskDataChangeSuccess) {
        Future(
            () => ref.read(taskNotifierProvider.notifier).getAllTask(params));
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const Header(title: 'Verifikator', subMenu: 'Verifikasi maker'),
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
                margin: const EdgeInsets.only(top: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 400,
                          height: 40,
                          child: TextField(
                            onChanged: (value) => Future(() => ref
                                .read(taskNotifierProvider.notifier)
                                .searchTask(value)),
                            onSubmitted: (value) {
                              Future(() => ref
                                  .read(taskNotifierProvider.notifier)
                                  .searchTask(value));
                            }, // onChanged return the value of the field
                            decoration: InputDecoration(
                                labelText:
                                    "Search by Site Id, Site Name, Maker or Verifier",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        const Spacer(),
                        const Text('Status : '),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 150,
                          // height: 40,
                          child: getDropdownStatus(),
                        ),
                        const SizedBox(width: 30),
                        datePick(),
                        const SizedBox(width: 30),
                        IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            ref
                                .read(taskNotifierProvider.notifier)
                                .getAllTask(params);
                          },
                        ),
                        const SizedBox(width: 30),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: Color.fromARGB(255, 187, 201, 230)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    final themeData = Theme.of(context);
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    return Theme(
      data: themeData.copyWith(
        cardTheme: appDataTableTheme.cardTheme,
        dataTableTheme: appDataTableTheme.dataTableThemeData,
      ),
      child: Scrollbar(
        controller: _dataTableHorizontalScrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _dataTableHorizontalScrollController,
          child: SizedBox(
            width: window.screen?.width?.toDouble() ?? 1940,
            child: Consumer(
              builder: (context, ref, child) {
                var state = ref.watch(taskNotifierProvider);
                // debugPrint('reload state task : $state');
                // if (DEBUG) debugPrint('state : $state');
                if (state is TaskLoaded) {
                  debugPrint('TaskLoaded 2');
                  DataTableSource data = TaskData(
                    tasks: state.tasks,
                    context: context,
                    ref: ref,
                  );
                  return PaginatedDataTable(
                    source: data,
                    columns: const [
                      DataColumn(
                          label: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Task ID'),
                      )),
                      DataColumn(
                          label: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Site ID'),
                      )),
                      DataColumn(
                          label: SizedBox(width: 300, child: Text('Site'))),
                      DataColumn(label: Text('Maker')),
                      DataColumn(label: Text('Verifier')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Created Date')),
                      DataColumn(label: Text('Due Date')),
                      DataColumn(label: Text('Submitted Date')),
                      DataColumn(label: Text('Verified Date')),
                      DataColumn(label: Text('Detail')),
                      DataColumn(label: Text('Verifikasi')),
                      DataColumn(label: Text('Print')),
                    ],
                    columnSpacing: 20,
                    horizontalMargin: 20,
                    rowsPerPage: 10,
                    showCheckboxColumn: false,
                  );
                } else if (state is TaskLoading) {
                  debugPrint('TaskLoading');
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                debugPrint(state.toString());
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getDropdownStatus() {
    final String status = ref.watch(statusTaskProvider);
    return Consumer(builder: (_, WidgetRef ref, __) {
      return DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(40),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(40),
          // ),
        ),
        value: status.isNotEmpty ? status : null,
        onChanged: (value) {
          ref.read(taskNotifierProvider.notifier).filterStatus(value!);
          ref.read(statusTaskProvider.notifier).state = value;
        },
        items: listStatus.map<DropdownMenuItem<String>>((String value) {
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
  TaskData({
    required this.tasks,
    required this.context,
    required this.ref,
  });

  @override
  DataRow? getRow(int index) {
    Task task = tasks[index];
    // debugPrint(task.site?.name.toString());
    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SizedBox(width: 30, child: Text(task.id!.toString())),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(width: 60, child: Text(task.site!.id!.toString())),
      )),
      DataCell(Text(task.site!.name!)),
      DataCell(Text(task.makerEmployee!.name!)),
      DataCell(Text(task.verifierEmployee!.name!)),
      DataCell(
        GestureDetector(
            child: Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: getColorIcon(task.status),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Text(
                  task.status!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ))),
        onTap: task.status == 'rejected'
            ? () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Accepted Task'),
                      content: Text(
                          'Do you want to accepted ask  ${task.site!.id!}?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Task update = task;
                              update.status = 'accepted';
                              ref
                                  .read(taskNotifierProvider.notifier)
                                  .updateTask(update);
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
              }
            : null,
      ),
      DataCell(Text(task.type!)),
      DataCell(Text(tasks[index].created_at != ''
          ? DateFormat('dd-M-yyyy')
              .format(DateTime.parse(tasks[index].created_at!))
          : '')),
      DataCell(Text(tasks[index].dueDate != ''
          ? DateFormat('dd-M-yyyy')
              .format(DateTime.parse(tasks[index].dueDate!))
          : '')),
      DataCell(Text(tasks[index].submitedDate != ''
          ? DateFormat('dd-M-yyyy')
              .format(DateTime.parse(tasks[index].submitedDate!))
          : '')),
      DataCell(Text(tasks[index].verifiedDate != ''
          ? DateFormat('dd-M-yyyy')
              .format(DateTime.parse(tasks[index].verifiedDate!))
          : '')),
      DataCell(task.status != STATUS_TODO &&
              task.status != STATUS_EXPIRED &&
              task.status != STATUS_REJECTED
          ? TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Detail'),
              onPressed: () {
                Map<String, dynamic> header = {
                  'filter': 'task.id||eq||${task.id}',
                  "join": [
                    "task",
                  ],
                  'sort': 'orderIndex,ASC'
                };
                Future(() => ref
                    .read(assetNotifierProvider.notifier)
                    .getAllAsset(header));

                GoRouter.of(context).go(RouteUri.resultAsset, extra: task);
              },
            )
          : Container()),
      DataCell(task.status == STATUS_ACCEPTED
          ? const Center(
              child: Icon(
              Icons.verified_outlined,
              color: Colors.green,
            ))
          : Container()),
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          task.status != STATUS_ACCEPTED
              ? const Icon(Icons.print_disabled)
              : IconButton(
                  splashRadius: 20,
                  onPressed: () async {
                    await launchUrlString(
                        '$urlRepo/task/downloadPdf/${task.id}',
                        mode: LaunchMode.platformDefault);
                    // Map<String, dynamic> header = {
                    //   'filter': 'task.id||eq||${task.id}',
                    //   "join": [
                    //     "task",
                    //   ],
                    //   'sort': 'orderIndex,ASC'
                    // };
                    // ref.read(assetNotifierProvider.notifier).getAllAsset(header);
                    // downloadPDF(task);
                  },
                  icon: const Icon(Icons.print))
        ],
      ))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tasks.length;

  @override
  int get selectedRowCount => 0;

  getColorIcon(String? status) {
    switch (status) {
      case STATUS_TODO:
        return Colors.blue;
      case STATUS_REVIEW:
        return Colors.amber;
      case STATUS_ACCEPTED:
        return Colors.green;
      case STATUS_REJECTED:
        return Colors.red;
      case STATUS_EXPIRED:
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}
