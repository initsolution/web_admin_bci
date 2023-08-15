import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

class SiteScreen extends ConsumerStatefulWidget {
  const SiteScreen({super.key});

  @override
  ConsumerState<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends ConsumerState<SiteScreen> {
  final pdf = pw.Document();
  var anchor;

  @override
  void initState() {
    super.initState();
    createPDF();
  }

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'pdf.pdf';
    html.document.body!.children.add(anchor);
  }

  createPDF() async {
    //contoh1
    // final profileImage = pw.MemoryImage((await rootBundle.load('hospital_ic.png')).buffer.asUint8List(),);
    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) => pw.Column(
    //       children: [
    //         pw.Text('Hello World1', style: pw.TextStyle(fontSize: 40)),
    //         pw.Text('Hello World2', style: pw.TextStyle(fontSize: 40)),
    //         pw.Text('Hello World3', style: pw.TextStyle(fontSize: 40)),
    //         pw.Image(profileImage),
    //       ],
    //     ),
    //   ),
    // );

    //contoh2
    // var reportedItems = [
    //   ["A1", "B1", "C1", "D1"],
    //   ["A2", "B2", "C2", "D2"],
    //   ["A3", "B3", "C3", "D3"]
    // ];
    // pdf.addPage(
    //   pw.Page(
    //       build: (pw.Context context) => pw.Table(children: [
    //             for (var i = 0; i < reportedItems.length; i++)
    //               pw.TableRow(children: [
    //                 pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
    //                     mainAxisAlignment: pw.MainAxisAlignment.center,
    //                     children: [
    //                       pw.Text(reportedItems[i][0],
    //                           style: pw.TextStyle(fontSize: 6)),
    //                       pw.Divider(thickness: 1)
    //                     ]),
    //                 pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
    //                     mainAxisAlignment: pw.MainAxisAlignment.center,
    //                     children: [
    //                       pw.Text(reportedItems[i][1],
    //                           style: pw.TextStyle(fontSize: 6)),
    //                       pw.Divider(thickness: 1)
    //                     ]),
    //                 pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
    //                     mainAxisAlignment: pw.MainAxisAlignment.center,
    //                     children: [
    //                       pw.Text(reportedItems[i][2],
    //                           style: pw.TextStyle(fontSize: 6)),
    //                       pw.Divider(thickness: 1)
    //                     ]),
    //                 pw.Column(
    //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
    //                     mainAxisAlignment: pw.MainAxisAlignment.center,
    //                     children: [
    //                       pw.Text(reportedItems[i][3],
    //                           style: pw.TextStyle(fontSize: 6)),
    //                       pw.Divider(thickness: 1)
    //                     ])
    //               ])
    //           ])),
    // );

    //contoh3
    final profileImage = pw.MemoryImage(
      (await rootBundle.load('hospital_ic.png')).buffer.asUint8List(),
    );
    pdf.addPage(
      pw.Page(
          build: (pw.Context context) => pw.Container(
                height: 1280.0,
                width: 720.0,
                padding: const pw.EdgeInsets.all(10.0),
                child: pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text('PERIODIC MAINTENANCE TIGHTENING BOLT'),
                      pw.Text('Site ID'),
                      pw.Text('Site Name'),
                      pw.Row(children: [
                        pw.Column(children: [
                          pw.Text('Site Information'),
                          pw.Image(profileImage),
                        ]),
                        pw.Column(children: [
                          pw.Text('Site Information'),
                          pw.Image(profileImage),
                        ]),
                      ]),
                    ],
                  ),
                ),
              )),
    );
    savePDF();
  }

  @override
  Widget build(BuildContext context) {
    var value = ref.watch(userDataProvider.select((value) => value.username));
    final themeData = Theme.of(context);
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Header(
            title: 'Site Screen',
            subMenu: 'submenu site',
            userName: value,
          ),
          ElevatedButton(
              onPressed: () async {
                anchor.click();
              },
              child: const Text('click me'))
        ],
      ),
    );
  }
}
