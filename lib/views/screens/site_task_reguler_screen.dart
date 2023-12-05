// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';
import 'package:flutter_web_ptb/providers/task_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_task.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_delete_task.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/dimens.dart';

class SiteTaskRegulerScreen extends ConsumerStatefulWidget {
  final Site site;
  const SiteTaskRegulerScreen({super.key, required this.site});

  @override
  ConsumerState<SiteTaskRegulerScreen> createState() =>
      _SiteTaskRegulerScreenState();
}

class _SiteTaskRegulerScreenState extends ConsumerState<SiteTaskRegulerScreen> {
  late Map<String, dynamic> params;
  final _dataTableHorizontalScrollController = ScrollController();
  late DateTimeRange dateRange;
  Map<String, dynamic> filter = {};
  String token = '';
  late Employee employee;

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
          'site.id||eq||${widget.site.id}',
        ]
      };
    } else {
      filter = {
        'filter': [
          'created_at||gte||${DateFormat('yyyy-MM-dd').format(dateRange.start)}',
          'created_at||lte||${DateFormat('yyyy-MM-dd').format(dateRange.end.add(const Duration(days: 1)))}',
          'site.id||eq||${widget.site.id}',
        ]
      };
    }
    params.addAll(filter);

    Future(() => ref.read(taskNotifierProvider.notifier).getAllTask(params));
  }

  @override
  void initState() {
    // params = {
    //   "join": [
    //     "site",
    //     "makerEmployee",
    //     "verifierEmployee",
    //     "categorychecklistprev",
    //     "categorychecklistprev.pointChecklistPreventive",
    //     "reportRegulerTorque",
    //     "reportRegulerVerticality",
    //     "reportRegulerVerticality.valueVerticality"
    //   ],
    //   "filter": ["site.id||eq||${widget.site.id}"]
    // };
    dateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now());
    getDataToken();
    // Future(() => ref.read(taskNotifierProvider.notifier).getAllTask(params));
    Future(() => ref.read(employeeNotifierProvider.notifier).getAllEmployee());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        Header(
          title: 'List Task of ${widget.site.name}',
          subMenu: 'All',
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
                              .searchTask(
                                  value)), // onChanged return the value of the field
                          decoration: InputDecoration(
                              labelText: "Search ...",
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
                      const Text('Created Date : '),
                      const SizedBox(width: 10),
                      datePick(),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                  child: DialogAddTask(
                                selectedSite: widget.site,
                                isCanEditSite: false,
                              ));
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 30),
                      IconButton(
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
                  tableTask(),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
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
                        var state = ref.watch(taskNotifierProvider);
                        // if (DEBUG) debugPrint('state : $state');
                        if (state is TaskLoaded) {
                          DataTableSource data = SiteTaskData(
                              tasks: state.tasks, context: context);
                          return PaginatedDataTable(
                            source: data,
                            columns: const [
                              DataColumn(
                                  label: Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text('Site'),
                              )),
                              DataColumn(label: Text('Maker')),
                              DataColumn(label: Text('Verifier')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Created Date')),
                              DataColumn(label: Text('Due Date')),
                              DataColumn(label: Text('Submitted Date')),
                              DataColumn(label: Text('Verified Date')),
                              DataColumn(label: Text('Delete')),
                            ],
                            columnSpacing: 50,
                            horizontalMargin: 10,
                            rowsPerPage: 10,
                            showCheckboxColumn: false,
                          );
                        } else if (state is TaskLoading) {
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
                ),
              );
            },
          )),
    );
  }

  Widget getDropdownStatus() {
    List<String> dataStatus = ['All', 'Todo', 'Review', 'Verified'];
    final String status = ref.watch(statusTaskProvider);
    return Consumer(builder: (_, WidgetRef ref, __) {
      return DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
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

class SiteTaskData extends DataTableSource {
  final List<Task> tasks;
  final BuildContext context;
  SiteTaskData({required this.tasks, required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(tasks[index].site!.name!))),
      DataCell(Text(tasks[index].makerEmployee!.name!)),
      DataCell(Text(tasks[index].verifierEmployee!.name!)),
      DataCell(Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: getColorIcon(tasks[index].status!),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Text(
            tasks[index].status!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ))),
      // DataCell(Text(tasks[index].status!)),
      DataCell(Text(tasks[index].type!)),
      DataCell(Text(tasks[index]
          .created_at!
          .substring(0, tasks[index].created_at!.indexOf('T')))),
      DataCell(Text(tasks[index].dueDate!)),
      DataCell(Text(tasks[index].submitedDate!)),
      DataCell(Text(tasks[index].verifiedDate!)),
      DataCell(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return SizedBox(
                  child: DialogDeleteTask(
                task: tasks[index],
              ));
            },
          );
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

  getColorIcon(String? status) {
    switch (status) {
      case 'todo':
        return Colors.blue;
      case 'review':
        return Colors.amber;
      case 'verified':
        return Colors.green;
      case 'notverified':
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}