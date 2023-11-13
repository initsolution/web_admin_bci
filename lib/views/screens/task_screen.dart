import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/site_provider.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';
import 'package:flutter_web_ptb/providers/task_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_task.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_delete_task.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final _dataTableHorizontalScrollController = ScrollController();
  Map<String, dynamic> params = {
    "join": [
      "site",
      "makerEmployee",
      "verifierEmployee",
      "categorychecklistprev",
      "categorychecklistprev.pointChecklistPreventive",
      "reportRegulerTorque",
      "reportRegulerVerticality",
      "reportRegulerVerticality.valueVerticality"
    ]
  };
  @override
  void initState() {
    Map<String, dynamic> params = {};
    params = {
      "join": [
        "site",
        "makerEmployee",
        "verifierEmployee",
        "categorychecklistprev",
        "categorychecklistprev.pointChecklistPreventive",
        "reportRegulerTorque",
        "reportRegulerVerticality",
        "reportRegulerVerticality.valueVerticality"
      ]
    };
    Future(() => ref.read(taskNotifierProvider.notifier).getAllTask(params));
    Future(() => ref.read(employeeNotifierProvider.notifier).getAllEmployee());
    Future(() => ref.read(siteNotifierProvider.notifier).getAllSite());
    super.initState();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var value = ref.watch(userDataProvider.select((value) => value.username));
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
          Header(
            title: 'Data Task',
            subMenu: 'All',
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(child: DialogAddTask());
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
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
                    tableTask(),
                  ],
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     anchor.click();
          //   },
          //   child: const Text('click me'),
          // ),
        ],
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
                        if (DEBUG) debugPrint('state : $state');
                        if (state is TaskLoaded) {
                          DataTableSource data =
                              TaskData(tasks: state.tasks, context: context);
                          return PaginatedDataTable(
                            source: data,
                            header: const Text('Task'),
                            columns: const [
                              DataColumn(label: Text('Site')),
                              DataColumn(label: Text('Maker')),
                              DataColumn(label: Text('Verifier')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Created Date')),
                              DataColumn(label: Text('Delete')),
                            ],
                            columnSpacing: 100,
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
}

class TaskData extends DataTableSource {
  final List<Task> tasks;
  final BuildContext context;
  TaskData({required this.tasks, required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(tasks[index].site!.name!)),
      DataCell(Text(tasks[index].makerEmployee!.name!)),
      DataCell(Text(tasks[index].verifierEmployee!.name!)),
      DataCell(Text(tasks[index].status!)),
      DataCell(Text(tasks[index].type!)),
      DataCell(Text(tasks[index].createdDate!)),
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
}
