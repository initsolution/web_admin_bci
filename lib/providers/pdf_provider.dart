// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/model/asset.dart';
import 'package:flutter_web_ptb/providers/pdf_state.dart';
import 'package:pdf/pdf.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:http/http.dart' as http;

final asyncPdfProvider =
    AutoDisposeAsyncNotifierProvider<PdfProvider, PdfState>(
  () => PdfProvider(),
);

class PdfProvider extends AutoDisposeAsyncNotifier<PdfState> {
  final pdf = pw.Document();

  @override
  FutureOr<PdfState> build() {
    return PdfInitial();
  }

  FutureOr<List<pw.TableRow>> tableRender(
      Map<String?, List<Asset>> groupedItems) async {
    List<pw.TableRow> dataRender = [];
    // debugPrint('table render : ${assets.length}');
    for (int i = 0; i < groupedItems.length; i++) {
      String? category = groupedItems.keys.elementAt(i);
      List itemsInCategory = groupedItems[category]!;
      // Asset item = assets[i];
      dataRender.add(pw.TableRow(children: [
        pw.Column(children: [pw.Text('$category')])
      ]));
      for (int j = 0; j < itemsInCategory.length; j += 2) {
        var response = await http.get(Uri.http(
            '103.82.241.80:3000', '/asset/getImage/${itemsInCategory[j].id}'));
        var gambarAsset = response.bodyBytes;
        dataRender.add(
          pw.TableRow(
            children: [
              pw.Column(children: [
                pw.SizedBox(
                  height: 144,
                  width: 192,
                  child: pw.Image(
                    pw.MemoryImage(gambarAsset.buffer.asUint8List()),
                    fit: pw.BoxFit.contain,
                  ),
                ),
                pw.Text(itemsInCategory[j].description!)
              ]),
              if (j + 1 < itemsInCategory.length)
                pw.Column(children: [
                  pw.SizedBox(
                    height: 144,
                    width: 192,
                    child: pw.Image(
                      pw.MemoryImage(gambarAsset.buffer.asUint8List()),
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  pw.Text(itemsInCategory[j + 1].description!)
                ])
            ],
          ),
        );
      }
    }
    return dataRender;
  }

  Future<void> createPDF(Map<String?, List<Asset>> groupedItems) async {
    debugPrint('create pdf');
    state = const AsyncValue.loading();

    // List<pw.Widget> widgets = [];
    // widgets.add(pw.Table(border: pw.TableBorder.all(), children: [...asset]));
    // pdf.addPage(
    //   pw.MultiPage(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (context) {
    //       // nanti di cari
    //       return [
    //         pw.Table(border: pw.TableBorder.all(), children: [...asset])
    //       ];
    //     },
    //   ),
    // );

    debugPrint('save to pdf');
    state = await AsyncValue.guard(
      () async {
        debugPrint('table render to pdf');
        List<pw.TableRow> asset = await tableRender(groupedItems);
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return [
                pw.Table(border: pw.TableBorder.all(), children: [...asset])
              ];
            },
          ),
        );
        return await savePDF();
      },
    );
    // savePDF(pdf);
  }

  // ignore: prefer_typing_uninitialized_variables
  var anchor;

  Future<PdfState> savePDF() async {
    debugPrint('start save');
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'report_asset.pdf';
    html.document.body!.children.add(anchor);
    debugPrint('pdf ready to print!');
    return PdfReady();
  }

  Future<void> anchorClick() async {
    (anchor as html.AnchorElement).click();
  }
}
