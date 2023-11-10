import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_employee.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme.dart';
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

    return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Consumer(
          builder: (context, ref, child) {
            var state = ref.watch(employeeNotifierProvider);
            if (state is EmployeeLoaded) {
              filterData = state.employees;
              DataTableSource data = EmployeeData(employees: filterData);
              return Theme(
                data: ThemeData(
                    cardColor: Theme.of(context).cardColor,
                    textTheme: const TextTheme(
                        titleLarge: TextStyle(color: Colors.blue))),
                child: PaginatedDataTable(
                  // sortColumnIndex: 0,
                  source: data,
                  header: const Text('Employee'),
                  columns: [
                    DataColumn(
                      label: const Text('Nik', style: tableHeader),
                      onSort: (columnIndex, _) {
                        sort(columnIndex);
                      },
                    ),
                    DataColumn(
                      label: const Text('Name', style: tableHeader),
                      onSort: (columnIndex, _) {
                        sort(columnIndex);
                      },
                    ),
                    DataColumn(
                      label: const Text('Email', style: tableHeader),
                      onSort: (columnIndex, _) {
                        sort(columnIndex);
                      },
                    ),
                    DataColumn(
                      label: const Text('Hp', style: tableHeader),
                      onSort: (columnIndex, _) {
                        sort(columnIndex);
                      },
                    ),
                    const DataColumn(
                      label: Text('Status Aktif', style: tableHeader),
                    ),
                    const DataColumn(
                      label: Text('Status Karyawan', style: tableHeader),
                    ),
                    const DataColumn(
                      label: Text('Role', style: tableHeader),
                    ),
                  ],
                  horizontalMargin: 10,
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                ),
              );
            } else if (state is EmployeeLoading) {
              return const CircularProgressIndicator();
            }
            return Container();
          },
        ));
  }

  @override
  void initState() {
    Future(()=> ref.read(employeeNotifierProvider.notifier).getAllEmployee());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    var value = ref.watch(userDataProvider.select((value) => value.username));
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
          Header(
            title: 'Employee',
            subMenu: 'submenu employee',
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
                    Center(child: tableEmployee())
                  ],
                ),
              ),
            ),
          ),
          // Table(
          //   border: TableBorder.all(),
          //   columnWidths: const <int, TableColumnWidth>{
          //     0: FixedColumnWidth(50),
          //     1: FlexColumnWidth(),
          //     2: FixedColumnWidth(200),
          //   },
          //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          //   children: <TableRow>[
          //     const TableRow(
          //       children: <Widget>[
          //         SizedBox(
          //           height: 25,
          //           child: Center(
          //             child: Text('No'),
          //           ),
          //         ),
          //         SizedBox(
          //           height: 25,
          //           child: Center(
          //             child: Text('Karyawan'),
          //           ),
          //         ),
          //         SizedBox(
          //           height: 25,
          //           child: Center(
          //             child: Text('Role'),
          //           ),
          //         ),
          //       ],
          //     ),
          //     TableRow(
          //       decoration: const BoxDecoration(
          //         color: Colors.grey,
          //       ),
          //       children: <Widget>[
          //         Container(
          //           height: 64,
          //           width: 128,
          //           color: Colors.purple,
          //         ),
          //         Container(
          //           height: 32,
          //           color: Colors.yellow,
          //         ),
          //         Center(
          //           child: Container(
          //             height: 32,
          //             width: 32,
          //             color: Colors.orange,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class EmployeeData extends DataTableSource {
  final List<Employee> employees;
  EmployeeData({required this.employees});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(employees[index].nik!)),
      DataCell(Text(employees[index].name!)),
      DataCell(Text(employees[index].email!)),
      DataCell(Text(employees[index].hp!)),
      DataCell(Text(employees[index].isActive == true ? 'Active' : 'Deactive')),
      DataCell(Text(employees[index].isVendor == true ? 'Vendor' : 'Internal')),
      DataCell(Text(employees[index].role!)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employees.length;

  @override
  int get selectedRowCount => 0;
}
