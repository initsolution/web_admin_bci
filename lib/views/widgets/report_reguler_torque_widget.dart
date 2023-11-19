import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/model/reportregulertorque.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

// ignore: must_be_immutable
class ReportRegulerTorqueWidget extends StatelessWidget {
  final List<ReportRegulerTorque> reportRegulerTorque;
  ReportRegulerTorqueWidget({super.key, required this.reportRegulerTorque});

  var anchor;
  final pdf = pw.Document();

  savePDF(var pdf) async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'report_reguler_torque.pdf';
    html.document.body!.children.add(anchor);
  }

  createPDF() async {
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Table(
            columnWidths: const {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(4),
              2: pw.FlexColumnWidth(3),
              3: pw.FlexColumnWidth(4),
              4: pw.FlexColumnWidth(4),
              5: pw.FlexColumnWidth(3),
              6: pw.FlexColumnWidth(4),
            },
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(children: [
                pw.Text('No',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center),
                pw.Text('Tower Segment/Section',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center),
                pw.Text('Elevasi (Mm)',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center),
                pw.Text('Bolt Size (Dia. Mm)',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center),
                pw.Text('Minimum Torque',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center),
                pw.Text('Qty Bolt',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center),
                pw.Text('Remarks',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center),
              ]),
              ...tableRender(),
            ]);
      },
    ));
    savePDF(pdf);
  }

  List<pw.TableRow> tableRender() {
    List<pw.TableRow> dataRender = [];
    for (var i = 0; i < reportRegulerTorque.length; i++) {
      ReportRegulerTorque report = reportRegulerTorque[i];
      pw.TableRow tableRow = pw.TableRow(children: [
        pw.Container(
            child: pw.Text('${i + 1}', style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text(report.towerSegment ?? '',
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text(report.elevasi.toString(),
                textAlign: pw.TextAlign.right,
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text(report.boltSize ?? '',
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text(report.minimumTorque.toString(),
                textAlign: pw.TextAlign.right,
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text(report.qtyBolt.toString(),
                textAlign: pw.TextAlign.right,
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text(report.remark ?? '',
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
      ]);
      dataRender.add(tableRow);
    }
    return dataRender;
  }

  @override
  Widget build(BuildContext context) {
    createPDF();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                anchor.click();
              },
              child: const Text('PDF')),
          Center(
            child: PaginatedDataTable(
                columnSpacing: 100,
                horizontalMargin: 10,
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
