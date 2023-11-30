import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_employee.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_filter_employee.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import '../../providers/user_data_provider.dart';

class EmployeeScreen extends ConsumerStatefulWidget {
  const EmployeeScreen({super.key});

  @override
  ConsumerState<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends ConsumerState<EmployeeScreen> {
  late List<Employee> filterData;
  bool _sortNik = true;
  bool _sortNameAsc = true;
  bool _sortEmailAsc = true;
  bool _sortHpAsc = true;
  final _dataTableHorizontalScrollController = ScrollController();

  void sort(columnIndex) {
    setState(() {
      if (columnIndex == 0) {
        //nik
        if (_sortNik == true) {
          _sortNik = false;
          filterData.sort((a, b) => b.nik!.compareTo(a.nik!));
        } else {
          _sortNik = true;
          filterData.sort((a, b) => a.nik!.compareTo(b.nik!));
        }
      } else if (columnIndex == 1) {
        //nama
        if (_sortNameAsc == true) {
          _sortNameAsc = false;
          filterData.sort((a, b) => b.name!.compareTo(a.name!));
        } else {
          _sortNameAsc = true;
          filterData.sort((a, b) => a.name!.compareTo(b.name!));
        }
      } else if (columnIndex == 2) {
        //email
        if (_sortEmailAsc == true) {
          _sortEmailAsc = false;
          filterData.sort((a, b) => b.email!.compareTo(a.email!));
        } else {
          _sortEmailAsc = true;
          filterData.sort((a, b) => a.email!.compareTo(b.email!));
        }
      } else if (columnIndex == 3) {
        //hp
        if (_sortHpAsc == true) {
          _sortHpAsc = false;
          filterData.sort((a, b) => b.hp!.compareTo(a.hp!));
        } else {
          _sortHpAsc = true;
          filterData.sort((a, b) => a.hp!.compareTo(b.hp!));
        }
      }
    });
  }

  Widget tableEmployee() {
    // var state = ref.watch(employeeNotifierProvider);
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
                          var state = ref.watch(employeeNotifierProvider);
                          if (state is EmployeeLoaded) {
                            filterData = state.employees;
                            DataTableSource data = EmployeeData(
                                employees: filterData,
                                context: context,
                                ref: ref);
                            return PaginatedDataTable(
                              // sortColumnIndex: 0,
                              source: data,
                              columns: [
                                DataColumn(
                                  label: const Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text('Nik'),
                                  ),
                                  onSort: (columnIndex, _) {
                                    sort(columnIndex);
                                  },
                                ),
                                DataColumn(
                                  label: const Text('Name'),
                                  onSort: (columnIndex, _) {
                                    sort(columnIndex);
                                  },
                                ),
                                DataColumn(
                                  label: const Text('Email'),
                                  onSort: (columnIndex, _) {
                                    sort(columnIndex);
                                  },
                                ),
                                DataColumn(
                                  label: const Text('Hp'),
                                  onSort: (columnIndex, _) {
                                    sort(columnIndex);
                                  },
                                ),
                                const DataColumn(
                                  label: Text('Status Aktif'),
                                ),
                                const DataColumn(
                                  label: Text('Status Karyawan'),
                                ),
                                const DataColumn(
                                  label: Text('Role'),
                                ),
                                const DataColumn(
                                  label: Text('Action'),
                                ),
                              ],
                              horizontalMargin: 10,
                              rowsPerPage: 10,
                              showCheckboxColumn: false,
                            );
                          } else if (state is EmployeeLoading) {
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
                  ));
            },
          )),
    );
  }

  @override
  void initState() {
    Future(() => ref.read(employeeNotifierProvider.notifier).getAllEmployee());
    super.initState();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    ref.listen(employeeNotifierProvider, (previous, next) {
      if (next is EmployeeErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is EmployeeDataChangeSuccess) {
        ref.read(employeeNotifierProvider.notifier).getAllEmployee();
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const Header(title: 'Employee', subMenu: 'submenu employee'),
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
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 400,
                          height: 40,
                          child: TextField(
                            onChanged: (value) => Future(() => ref
                                .read(employeeNotifierProvider.notifier)
                                .searchEmployee(
                                    value)), // onChanged return the value of the field
                            decoration: InputDecoration(
                              labelText: "Search Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(child: DialogAddEmployee());
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
                                .read(employeeNotifierProvider.notifier)
                                .getAllEmployee();
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    const DialogFilterEmployee());
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    tableEmployee(),
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

class EmployeeData extends DataTableSource {
  final List<Employee> employees;
  final BuildContext context;
  final WidgetRef ref;
  EmployeeData(
      {required this.employees, required this.context, required this.ref});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text(employees[index].nik!),
      )),
      DataCell(Text(employees[index].name!)),
      DataCell(Text(employees[index].email!)),
      DataCell(Text(employees[index].hp!)),
      DataCell(Text(employees[index].isActive == true ? 'Active' : 'Deactive')),
      DataCell(Text(employees[index].isVendor == true ? 'Vendor' : 'Internal')),
      DataCell(Text(employees[index].role!)),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SizedBox(
                      child: DialogAddEmployee(
                    isEdit: true,
                    editEmployee: employees[index],
                  ));
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Employee'),
                    content:
                        Text('Do you want to delete ${employees[index].name}?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ref
                                .read(employeeNotifierProvider.notifier)
                                .deleteEmployee(employees[index].nik!);
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
            },
          )
        ],
      ))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employees.length;

  @override
  int get selectedRowCount => 0;
}
