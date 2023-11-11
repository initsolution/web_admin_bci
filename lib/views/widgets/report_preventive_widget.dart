import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/model/categorychecklistpreventive.dart';
import 'package:flutter_web_ptb/model/pointchecklistpreventive.dart';

class ReportPreventiveWidget extends StatelessWidget {
  final List<CategoryChecklistPreventive> categoryChecklistPreventives;
  const ReportPreventiveWidget(
      {super.key, required this.categoryChecklistPreventives});

  List<TableRow> tableRender() {
    List<CategoryChecklistPreventive> data = categoryChecklistPreventives
      ..sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));
    // TableRow dataTableRowCategory = const TableRow();
    List<TableRow> dataTableRowCategory = [];
    // TableRow? dataTablePoint;
    // TableRow
    for (int i = 0; i < data.length; i++) {
      CategoryChecklistPreventive categoryChecklistPreventive = data[i];
      // dataTableRowCategory!.decoration BoxDecoration();
      TableRow dataCategory = TableRow(
          decoration: const BoxDecoration(color: Colors.green),
          children: [
            TableCell(
                child: Text('${categoryChecklistPreventive.orderIndex!}')),
            TableCell(child: Text(categoryChecklistPreventive.nama!)),
            const TableCell(child: Text('')),
            const TableCell(child: Text('')),
            const TableCell(child: Text('')),
            const TableCell(child: Text('')),
            const TableCell(child: Text('')),
          ]);
      dataTableRowCategory.add(dataCategory);
      // dataTableRowCategory
      //     .add(TableCell(child: Text('${categoryChecklistPreventive.orderIndex!}')));
      // dataTableRowCategory.add(TableCell(child: Text(categoryChecklistPreventive.nama!)));
      // dataTableRowCategory.add(const TableCell(child:  Text('-')));
      // dataTableRowCategory.add(const TableCell(child:  Text('-')));
      // dataTableRowCategory.add(const TableCell(child:  Text('-')));
      // dataTableRowCategory.add(const TableCell(child:  Text('-')));
      // dataTableRowCategory.add(const TableCell(child:  Text('-')));
      List<PointChecklistPreventive> dataPoint = categoryChecklistPreventive
          .pointChecklistPreventive!
        ..sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));
      for (int j = 0; j < dataPoint.length; j++) {
        PointChecklistPreventive pointChecklistPreventive = dataPoint[j];
        TableRow pointCheck = TableRow(children: [
          TableCell(
            child: Text('${pointChecklistPreventive.orderIndex}'),
          ),
          TableCell(child: Text('${pointChecklistPreventive.uraian}')),
          TableCell(child: Text('${pointChecklistPreventive.kriteria}')),
          TableCell(
              child: pointChecklistPreventive.hasil!.toUpperCase() != 'OK'
                  ? Container()
                  : const Icon(Icons.done)),
          TableCell(
              child: pointChecklistPreventive.hasil!.toUpperCase() != 'NOK'
                  ? Container()
                  : const Icon(Icons.done)),
          TableCell(
              child: pointChecklistPreventive.hasil!.toUpperCase() != 'NA'
                  ? Container()
                  : const Icon(Icons.done)),
          TableCell(
              child: Text(pointChecklistPreventive.keterangan != null
                  ? '${pointChecklistPreventive.keterangan}'
                  : ''))
        ]);

        dataTableRowCategory.add(pointCheck);
      }
    }
    return dataTableRowCategory;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('report preventive');
    debugPrint(categoryChecklistPreventives.toString());
    return ListView(
      children: [
        Table(
          children: [
            const TableRow(
              children: [
                Text('No'),
                Text('Uraian'),
                Text('Kriteria'),
                Text('OK'),
                Text('NOK'),
                Text('NA'),
                Text('Keterangan / Temuan')
              ],
            ),
            ...tableRender()
            // tableRender().isNotEmpty
            //     ? TableRow(children: tableRender())
            //     : const TableRow(
            //         children: [
            //           Text('No'),
            //           Text('Uraian'),
            //           Text('Kriteria'),
            //           Text('OK'),
            //           Text('NOK'),
            //           Text('NA'),
            //           Text('Keterangan / Temuan')
            //         ],
            //       ),
          ],
        ),
      ],
    );
    // return Table(
    //   children: [tableRender()!],
    // );
  }
}
