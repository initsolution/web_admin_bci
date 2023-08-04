import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_provider.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
// import 'package:provider/provider.dart';

import '../../providers/user_data_provider.dart';

class EmployeeScreen extends ConsumerStatefulWidget {
  const EmployeeScreen({super.key});

  @override
  ConsumerState<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends ConsumerState<EmployeeScreen> {
  Widget tableEmployee() {
    // var state = ref.watch(employeeNotifierProvider);

    return Center(child: Consumer(
      builder: (context, ref, child) {
        var state = ref.watch(employeeNotifierProvider);
        if (state is EmployeeLoaded) {
          DataTableSource data = EmployeeData(employees: state.employees);
          return PaginatedDataTable(
            source: data,
            header: const Text('Employee'),
            columns: const [
              DataColumn(label: Text('Nik')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Hp')),
              DataColumn(label: Text('Status Aktif')),
              DataColumn(label: Text('Status Karyawan')),
            ],
            columnSpacing: 100,
            horizontalMargin: 10,
            rowsPerPage: 10,
            showCheckboxColumn: false,
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            'Employee Screen',
            style: themeData.textTheme.headlineMedium,
          ),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(child: tableEmployee()),
            ],
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
      DataCell(Text(employees[index].is_active == 1 ? 'Active' : 'Deactive')),
      DataCell(Text(employees[index].is_vendor == 1 ? 'Vendor' : 'Internal')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employees.length;

  @override
  int get selectedRowCount => 0;
}
