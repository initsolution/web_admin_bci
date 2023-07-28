import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:provider/provider.dart';

import '../../providers/user_data_provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Selector<UserDataProvider, String>(
            selector: (context, provider) => provider.username,
            builder: (context, value, child) {
              return Header(
                title: 'Employee',
                subMenu: 'submenu employee',
                userName: value,
              );
            },
          ),
          Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(50),
              1: FlexColumnWidth(),
              2: FixedColumnWidth(200),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              const TableRow(
                children: <Widget>[
                  SizedBox(
                    height: 25,
                    child: Center(
                      child: Text('No'),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: Center(
                      child: Text('Karyawan'),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    child: Center(
                      child: Text('Role'),
                    ),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                children: <Widget>[
                  Container(
                    height: 64,
                    width: 128,
                    color: Colors.purple,
                  ),
                  Container(
                    height: 32,
                    color: Colors.yellow,
                  ),
                  Center(
                    child: Container(
                      height: 32,
                      width: 32,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
