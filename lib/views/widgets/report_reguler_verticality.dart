import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/reportregulerverticality.dart';
import 'package:flutter_web_ptb/model/valueverticality.dart';

class ReportRegulerVerticalityWidget extends StatelessWidget {
  final ReportRegulerVerticality reportRegulerVerticality;
  const ReportRegulerVerticalityWidget(
      {super.key, required this.reportRegulerVerticality});

  Widget horizontalityReport(double widthTitikFondasi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Horizontality',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                'Terhadap Titik Fondasi :',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'AB',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      const Text(
                        ':',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text(
                        '${reportRegulerVerticality.horizontalityAb}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      const Text(
                        'MM',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'BC',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      const Text(
                        ':',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text(
                        '${reportRegulerVerticality.horizontalityBc}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      const Text(
                        'MM',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'CD',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      const Text(
                        ':',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text(
                        '${reportRegulerVerticality.horizontalityCd}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      const Text(
                        'MM',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'DA',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      const Text(
                        ':',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      Text(
                        '${reportRegulerVerticality.horizontalityDa}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: widthTitikFondasi,
                      ),
                      const Text(
                        'MM',
                        style: TextStyle(fontSize: 16),
                      ),
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

  Widget theodoliteReport(double widthTitikFondasi) {
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
        const Text(
          '2. Verticality',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.grey[100],
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: Text(
                        'Theodolite 1 : ${reportRegulerVerticality.theodolite1}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Center(
                      child: theodoliteTable(
                          theodolite1, reportRegulerVerticality.theodolite1!),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.grey[100],
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: Text(
                        'Theodolite 2 : ${reportRegulerVerticality.theodolite2}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Center(
                      child: theodoliteTable(
                          theodolite2, reportRegulerVerticality.theodolite2!),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget theodoliteTable(
      List<ValueVerticality> valueVerticalities, String miringKe) {
    return SizedBox(
      width: 300,
      child: PaginatedDataTable(
          columnSpacing: 20,
          horizontalMargin: 10,
          rowsPerPage: 10,
          showCheckboxColumn: false,
          columns: [
            const DataColumn(label: Text('Section')),
            DataColumn(label: Text('Sisi $miringKe')),
            const DataColumn(label: Text('MM'))
          ],
          source: ValueVerticalityData(valueVerticalities: valueVerticalities)),
    );
  }

  Widget jenisAlat(double widthTitikFondasi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Jenis Alat Ukur Yang Digunakan :',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: kDefaultPadding / 2),
          child: Text(
            '${reportRegulerVerticality.alatUkur}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget toleransiKetegakan(double widthTitikFondasi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. Toleransi Ketegakan Menara :',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: kDefaultPadding / 2),
          child: Text(
            '${reportRegulerVerticality.toleransiKetegakan} MM',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthTitikFondasi = 10;
    // TextStyle headReport = themeData.textTheme.headlineMedium!;
    // TextStyle subHeadReport = themeData.textTheme.headlineSmall!;
    // TextStyle bodyReport = themeData.textTheme.bodyMedium!;
    debugPrint(reportRegulerVerticality.toString());
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          horizontalityReport(widthTitikFondasi),
          const SizedBox(
            height: 20,
          ),
          theodoliteReport(widthTitikFondasi),
          const SizedBox(
            height: 20,
          ),
          jenisAlat(widthTitikFondasi),
          const SizedBox(
            height: 20,
          ),
          toleransiKetegakan(widthTitikFondasi),
        ],
      ),
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
