import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/reportregulerverticality.dart';
import 'package:flutter_web_ptb/model/valueverticality.dart';

class ReportRegulerVerticalityWidget extends StatelessWidget {
  final ReportRegulerVerticality reportRegulerVerticality;
  const ReportRegulerVerticalityWidget(
      {super.key, required this.reportRegulerVerticality});

  Widget horizontalityReport(TextStyle headReport, TextStyle subHeadReport,
      TextStyle bodyReport, double widthTitikFondasi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Horizontality',
          style: headReport,
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Terhadap Titik Fondasi :',
                style: subHeadReport,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'AB',
                        style: bodyReport,
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text(':', style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text('${reportRegulerVerticality.horizontalityAb}',
                          style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text('MM', style: bodyReport),
                    ],
                  ),
                  Row(
                    children: [
                      Text('BC', style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text(':', style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text('${reportRegulerVerticality.horizontalityBc}',
                          style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text('MM', style: bodyReport),
                    ],
                  ),
                  Row(
                    children: [
                      Text('CD', style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text(':', style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text('${reportRegulerVerticality.horizontalityCd}',
                          style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text('MM', style: bodyReport),
                    ],
                  ),
                  Row(
                    children: [
                      Text('DA', style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text(':', style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text('${reportRegulerVerticality.horizontalityDa}',
                          style: bodyReport),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text('MM', style: bodyReport),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget gambarMenara() {
    String ab = '';
    String bc = '';
    String cd = '';
    String da = '';
    double widthLocal = 50;
    double heightLocal = 20;
    double fontSize = 15;
    Color textColor = Colors.white;
    TextStyle textStyle = TextStyle(color: textColor, fontSize: fontSize);
    switch (reportRegulerVerticality.theodolite1) {
      case 'A-B':
        ab = '1';
        break;
      case 'B-C':
        bc = '1';
        break;
      case 'C-D':
        cd = '1';
        break;
      case 'D-A':
        da = '1';
        break;
      default:
    }
    // debugPrint('theodolite 1 : ${reportRegulerVerticality.theodolite1}');
    // debugPrint('ab : $ab, bc : $bc, cd : $cd, da: $da');
    switch (reportRegulerVerticality.theodolite2) {
      case 'A-B':
        ab = '2';
        break;
      case 'B-C':
        bc = '2';
        break;
      case 'C-D':
        cd = '2';
        break;
      case 'D-A':
        da = '2';
        break;
      default:
    }
    // debugPrint('theodolite 2 : ${reportRegulerVerticality.theodolite2}');
    // debugPrint('ab : $ab, bc : $bc, cd : $cd, da: $da');
    return SizedBox(
      width: 250,
      height: 200,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/tower.png',
              width: 100,
              height: 100,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: widthLocal,
              height: heightLocal,
              margin: const EdgeInsets.all(5),
              decoration:
                  BoxDecoration(border: Border.all(), color: Colors.black),
              child: Center(
                child: Text(
                  ab,
                  style: textStyle,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: widthLocal,
              height: heightLocal,
              margin: const EdgeInsets.all(5),
              decoration:
                  BoxDecoration(border: Border.all(), color: Colors.black),
              child: Center(
                child: Text(
                  bc,
                  style: textStyle,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: widthLocal,
              height: heightLocal,
              margin: const EdgeInsets.all(5),
              decoration:
                  BoxDecoration(border: Border.all(), color: Colors.black),
              child: Center(
                child: Text(
                  cd,
                  style: textStyle,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: widthLocal,
              height: heightLocal,
              margin: const EdgeInsets.all(5),
              decoration:
                  BoxDecoration(border: Border.all(), color: Colors.black),
              child: Center(
                child: Text(
                  da,
                  style: textStyle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget theodoliteReport(
    TextStyle headReport,
    TextStyle subHeadReport,
    TextStyle bodyReport,
    double widthTitikFondasi,
  ) {
    List<ValueVerticality> theodolite1 = reportRegulerVerticality
        .valueVerticality!
        .where((element) => element.theodoliteIndex == 1)
        .toList();
    List<ValueVerticality> theodolite2 = reportRegulerVerticality
        .valueVerticality!
        .where((element) => element.theodoliteIndex == 2)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. Verticality',
          style: headReport,
        ),
        const SizedBox(
          height: 20,
        ),
        // nanti gambar menara
        gambarMenara(),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Column(
              children: [
                Text(
                  'THEODOLITE 1 : ${reportRegulerVerticality.theodolite1}',
                  style: bodyReport,
                ),
                SizedBox(
                  width: 500,
                  child: theodoliteTable(
                      theodolite1, reportRegulerVerticality.theodolite1!),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'THEODOLITE 2 : ${reportRegulerVerticality.theodolite2}',
                  style: bodyReport,
                ),
                SizedBox(
                  width: 500,
                  child: theodoliteTable(
                      theodolite2, reportRegulerVerticality.theodolite2!),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget theodoliteTable(
      List<ValueVerticality> valueVerticalities, String miringKe) {
    return PaginatedDataTable(
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 10,
        showCheckboxColumn: false,
        columns: [
          const DataColumn(label: Text('Section')),
          DataColumn(label: Text('Sisi $miringKe')),
          const DataColumn(label: Text('MM'))
        ],
        source: ValueVerticalityData(valueVerticalities: valueVerticalities));
  }

  Widget jenisAlat(TextStyle headReport, TextStyle subHeadReport,
      TextStyle bodyReport, double widthTitikFondasi) {
    return Text(
      '3. Jenis Alat Ukur Yang Digunakan : ${reportRegulerVerticality.alatUkur}',
      style: headReport,
    );
  }

  Widget toleransiKetegakan(TextStyle headReport, TextStyle subHeadReport,
      TextStyle bodyReport, double widthTitikFondasi) {
    return Text(
      '4. Toleransi Ketegakan Menara : ${reportRegulerVerticality.toleransiKetegakan} MM',
      style: headReport,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    double widthTitikFondasi = 10;
    TextStyle headReport = themeData.textTheme.headlineMedium!;
    TextStyle subHeadReport = themeData.textTheme.headlineSmall!;
    TextStyle bodyReport = themeData.textTheme.bodyMedium!;
    return ListView(
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
        horizontalityReport(
            headReport, subHeadReport, bodyReport, widthTitikFondasi),
        const SizedBox(
          height: 20,
        ),
        theodoliteReport(
            headReport, subHeadReport, bodyReport, widthTitikFondasi),
        const SizedBox(
          height: 20,
        ),
        jenisAlat(headReport, subHeadReport, bodyReport, widthTitikFondasi),
        const SizedBox(
          height: 20,
        ),
        toleransiKetegakan(
            headReport, subHeadReport, bodyReport, widthTitikFondasi),
      ],
    );
  }
}

class ValueVerticalityData extends DataTableSource {
  final List<ValueVerticality> valueVerticalities;
  ValueVerticalityData({required this.valueVerticalities});

  @override
  DataRow? getRow(int index) {
    ValueVerticality valueVerticality = valueVerticalities[index];
    return DataRow(cells: [
      DataCell(Text('${valueVerticality.section!}')),
      DataCell(Text(valueVerticality.miringKe!)),
      DataCell(Text('${valueVerticality.value!}'))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => valueVerticalities.length;

  @override
  int get selectedRowCount => 0;
}