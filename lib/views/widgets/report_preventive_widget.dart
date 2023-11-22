import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/model/categorychecklistpreventive.dart';
import 'package:flutter_web_ptb/model/pointchecklistpreventive.dart';
import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

// ignore: must_be_immutable
class ReportPreventiveWidget extends StatelessWidget {
  final List<CategoryChecklistPreventive> categoryChecklistPreventives;
  ReportPreventiveWidget(
      {super.key, required this.categoryChecklistPreventives});

  var anchor;
  final pdf = pw.Document();

  savePDF(var pdf) async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'report_preventive_torque.pdf';
    html.document.body!.children.add(anchor);
  }

  createPDF() async {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Table(
              columnWidths: const {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(6),
                2: pw.FlexColumnWidth(6),
                3: pw.FlexColumnWidth(1),
                4: pw.FlexColumnWidth(1),
                5: pw.FlexColumnWidth(1),
                6: pw.FlexColumnWidth(4),
              },
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(children: [
                  pw.Text('No',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                  pw.Text('Uraian',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                  pw.Text('Kriteria',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                  pw.Text('OK',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                  pw.Text('NOK',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                  pw.Text('NA',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                  pw.Text('Keterangan / Temuan',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center),
                ]),
                ...tableRenderPDF(),
              ])
        ];
      },
    ));
    savePDF(pdf);
  }

  List<pw.TableRow> tableRenderPDF() {
    List<CategoryChecklistPreventive> data = categoryChecklistPreventives
      ..sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));
    List<pw.TableRow> dataRender = [];
    for (var i = 0; i < data.length; i++) {
      CategoryChecklistPreventive categoryChecklistPreventive = data[i];
      pw.TableRow tableRow = pw.TableRow(children: [
        pw.Container(
            child: pw.Text('${i + 1}', style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text(categoryChecklistPreventive.nama ?? '',
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text('',
                textAlign: pw.TextAlign.right,
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text('', style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text('',
                textAlign: pw.TextAlign.right,
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text('',
                textAlign: pw.TextAlign.right,
                style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
        pw.Container(
            child: pw.Text('', style: const pw.TextStyle(fontSize: 8)),
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
      ]);
      dataRender.add(tableRow);
      List<PointChecklistPreventive> dataPoint = categoryChecklistPreventive
          .pointChecklistPreventive!
        ..sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));
      for (var j = 0; j < dataPoint.length; j++) {
        PointChecklistPreventive pointChecklistPreventive = dataPoint[j];
        pw.TableRow pointCheck = pw.TableRow(children: [
          pw.Container(
            child: pw.Center(child: pw.Text('${j + 1}')),
          ),
          pw.Container(
              child: pw.Center(
                  child: pw.Text('${pointChecklistPreventive.uraian}'))),
          pw.Container(
              child: pw.Center(
                  child: pw.Text('${pointChecklistPreventive.kriteria}'))),
          pw.Container(
              child: pointChecklistPreventive.hasil!.toUpperCase() != 'OK'
                  ? pw.Container()
                  : pw.Center(child: pw.Text('v'))),
          pw.Container(
              child: pointChecklistPreventive.hasil!.toUpperCase() != 'NOK'
                  ? pw.Container()
                  : pw.Center(child: pw.Text('v'))),
          pw.Container(
              child: pointChecklistPreventive.hasil!.toUpperCase() != 'NA'
                  ? pw.Container()
                  : pw.Center(child: pw.Text('v'))),
          pw.Container(
              child: pw.Text(pointChecklistPreventive.keterangan != null
                  ? '${pointChecklistPreventive.keterangan}'
                  : ''))
        ]);
        dataRender.add(pointCheck);
      }
    }

    return dataRender;
  }

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
    createPDF();
    return ListView(
      children: [
        ElevatedButton(
            onPressed: () {
              anchor.click();
            },
            child: const Text('PDF')),
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
