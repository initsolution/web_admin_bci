import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/reportregulertorque.dart';

class ReportRegulerTorqueWidget extends StatelessWidget {
  final List<ReportRegulerTorque> reportRegulerTorque;
  const ReportRegulerTorqueWidget(
      {super.key, required this.reportRegulerTorque});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: Column(
        children: [
          Center(
            child: PaginatedDataTable(
                columnSpacing: 110,
                rowsPerPage: 10,
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Tower Segment/Section')),
                  DataColumn(label: Text('Elevasi (Mm)')),
                  DataColumn(label: Text('Bolt Size (Dia. Mm)')),
                  DataColumn(label: Text('Minimum Torque')),
                  DataColumn(label: Text('Qty Bolt')),
                  DataColumn(label: Text('Remarks')),
                ],
                source: ReportRegulerTorqueData(
                    reportRegulerTorques: reportRegulerTorque)),
          ),
        ],
      ),
    );
  }
}

class ReportRegulerTorqueData extends DataTableSource {
  final List<ReportRegulerTorque> reportRegulerTorques;
  ReportRegulerTorqueData({required this.reportRegulerTorques});
  @override
  DataRow? getRow(int index) {
    ReportRegulerTorque reportRegulerTorque = reportRegulerTorques[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(reportRegulerTorque.towerSegment!)),
      DataCell(Text(reportRegulerTorque.elevasi!.toString())),
      DataCell(Text(reportRegulerTorque.boltSize!)),
      DataCell(Text(reportRegulerTorque.minimumTorque!.toString())),
      DataCell(Text(reportRegulerTorque.qtyBolt!.toString())),
      DataCell(Text(reportRegulerTorque.remark!)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => reportRegulerTorques.length;

  @override
  int get selectedRowCount => 0;
}
