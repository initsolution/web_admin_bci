// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/asset.dart';
import 'package:flutter_web_ptb/model/categorychecklistpreventive.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/model/pointchecklistpreventive.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/asset_provider.dart';
import 'package:flutter_web_ptb/providers/asset_state.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';
import 'package:flutter_web_ptb/providers/task_state.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AssetScreen extends ConsumerStatefulWidget {
  const AssetScreen({super.key});

  @override
  ConsumerState<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends ConsumerState<AssetScreen> {
  Map<String, dynamic> params = {};
  Map<String, dynamic> filter = {};
  String token = '';
  late Employee employee;
  late DateTimeRange dateRange;

  getDataToken() async {
    final sharedPref = await SharedPreferences.getInstance();
    token = sharedPref.getString(StorageKeys.token) ?? '';
    employee = Employee.fromMap(JwtDecoder.decode(token)['employee']);
    debugPrint(employee.toString());
    await getTaskWithFilter();
  }

  getTaskWithFilter() async {
    debugPrint('getTaskWithFilter');
    params = {
      "join": [
        'site',
        'makerEmployee',
        'verifierEmployee',
        'categorychecklistprev',
        'categorychecklistprev.pointChecklistPreventive',
        'reportRegulerTorque',
        'reportRegulerVerticality',
        'reportRegulerVerticality.valueVerticality'
      ],
      // 'filter': 'verifierEmployee.nik||eq||${employee.nik}',
      'sort': ['updated_at,DESC']
    };
    if (employee.role! == 'Verify') {
      filter = {
        'filter': [
          'verifierEmployee.nik||eq||${employee.nik}',
          'created_at||gte||${DateFormat('yyyy-MM-dd').format(dateRange.start)}',
          'created_at||lte||${DateFormat('yyyy-MM-dd').format(dateRange.end.add(const Duration(days: 1)))}',
        ]
      };
    } else {
      filter = {
        'filter': [
          'created_at||gte||${DateFormat('yyyy-MM-dd').format(dateRange.start)}',
          'created_at||lte||${DateFormat('yyyy-MM-dd').format(dateRange.end.add(const Duration(days: 1)))}',
        ]
      };
    }
    params.addAll(filter);

    Future(() => ref.read(taskNotifierProvider.notifier).getAllTask(params));
  }

  @override
  void initState() {
    Future(() => ref.read(statusTaskProvider.notifier).state = statusTask);
    dateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now());
    getDataToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const Header(title: 'Verifikator', subMenu: 'Verifikasi maker'),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                margin: const EdgeInsets.only(top: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 400,
                          height: 40,
                          child: TextField(
                            onChanged: (value) => Future(() => ref
                                .read(taskNotifierProvider.notifier)
                                .searchTask(value)),
                            onSubmitted: (value) {
                              Future(() => ref
                                  .read(taskNotifierProvider.notifier)
                                  .searchTask(value));
                            }, // onChanged return the value of the field
                            decoration: InputDecoration(
                                labelText:
                                    "Search by Site Name, Maker or Verifier",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                        ),
                        const Spacer(),
                        const Text('Status : '),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 150,
                          // height: 40,
                          child: getDropdownStatus(),
                        ),
                        const SizedBox(width: 30),
                        datePick(),
                        const SizedBox(width: 30),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            ref
                                .read(taskNotifierProvider.notifier)
                                .getAllTask(params);
                          },
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(child: tableTask())
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget datePick() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: Color.fromARGB(255, 187, 201, 230)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        showDateRangePicker(
                context: context,
                firstDate: DateTime(2022),
                lastDate: DateTime(2040),
                initialDateRange: dateRange,
                initialEntryMode: DatePickerEntryMode.calendarOnly)
            .then((value) {
          setState(() {
            if (value != null) dateRange = value;
            debugPrint(
                'periode : ${DateFormat('dd/MM/yyyy').format(dateRange.start)}  -  ${DateFormat('dd/MM/yyyy').format(dateRange.end)}');
          });
          getTaskWithFilter();
        });
      },
      icon: const Icon(
        Icons.calendar_month_rounded,
        color: Colors.white,
      ),
      label: Text(
        '${DateFormat('dd/MM/yyyy').format(dateRange.start)}  -  ${DateFormat('dd/MM/yyyy').format(dateRange.end)} ',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget tableTask() {
    final themeData = Theme.of(context);
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    return Theme(
      data: themeData.copyWith(
        cardTheme: appDataTableTheme.cardTheme,
        dataTableTheme: appDataTableTheme.dataTableThemeData,
      ),
      child: SizedBox(
          width: double.infinity,
          child: Consumer(
            builder: (context, ref, child) {
              var state = ref.watch(taskNotifierProvider);
              // debugPrint('reload state task : $state');
              // if (DEBUG) debugPrint('state : $state');
              if (state is TaskLoaded) {
                debugPrint('TaskLoaded 2');
                DataTableSource data =
                    TaskData(tasks: state.tasks, context: context, ref: ref);
                return PaginatedDataTable(
                  source: data,
                  columns: const [
                    DataColumn(
                        label: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text('ID'),
                    )),
                    DataColumn(label: Text('Site')),
                    DataColumn(label: Text('Maker')),
                    DataColumn(label: Text('Verifier')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Created Date')),
                    DataColumn(label: Text('Due Date')),
                    DataColumn(label: Text('Submitted Date')),
                    DataColumn(label: Text('Verified Date')),
                    DataColumn(label: Text('Detail')),
                    DataColumn(label: Text('Verifikasi')),
                    DataColumn(label: Text('Print')),
                  ],
                  columnSpacing: 70,
                  horizontalMargin: 20,
                  rowsPerPage: 10,
                  showCheckboxColumn: false,
                );
              } else if (state is TaskLoading) {
                debugPrint('TaskLoading');
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              debugPrint(state.toString());
              return Container();
            },
          )),
    );
  }

  Widget getDropdownStatus() {
    final String status = ref.watch(statusTaskProvider);
    return Consumer(builder: (_, WidgetRef ref, __) {
      return DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(40),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(40),
          // ),
        ),
        value: status.isNotEmpty ? status : null,
        onChanged: (value) {
          ref.read(taskNotifierProvider.notifier).filterStatus(value!);
          ref.read(statusTaskProvider.notifier).state = value;
        },
        items: listStatus.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    });
  }
}

class TaskData extends DataTableSource {
  final List<Task> tasks;
  final BuildContext context;
  final WidgetRef ref;
  TaskData({required this.tasks, required this.context, required this.ref});

  @override
  DataRow? getRow(int index) {
    Task task = tasks[index];
    // debugPrint(task.site?.name.toString());
    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text(task.id!.toString()),
      )),
      DataCell(Text(task.site!.name!)),
      DataCell(Text(task.makerEmployee!.name!)),
      DataCell(Text(task.verifierEmployee!.name!)),
      DataCell(Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: getColorIcon(task.status),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Text(
            task.status!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ))),
      DataCell(Text(task.type!)),
      DataCell(Text(tasks[index]
          .created_at!
          .substring(0, tasks[index].created_at!.indexOf('T')))),
      DataCell(Text(tasks[index].dueDate!)),
      DataCell(Text(tasks[index].submitedDate!)),
      DataCell(Text(tasks[index].verifiedDate!)),
      DataCell(task.status != STATUS_TODO
          ? TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Detail'),
              onPressed: () {
                Map<String, dynamic> header = {
                  'filter': 'task.id||eq||${task.id}',
                  "join": [
                    "task",
                  ],
                  'sort': 'orderIndex,ASC'
                };
                ref.read(assetNotifierProvider.notifier).getAllAsset(header);

                GoRouter.of(context).go(RouteUri.resultAsset, extra: task);
              },
            )
          : Container()),
      DataCell(task.status == STATUS_ACCEPTED
          ? const Icon(Icons.verified_outlined)
          : Container()),
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          task.status != STATUS_ACCEPTED
              ? const Icon(Icons.print_disabled)
              : IconButton(
                  splashRadius: 20,
                  onPressed: () async {
                    await launchUrlString(
                        '$urlRepo/task/downloadPdf/${task.id}',
                        mode: LaunchMode.platformDefault);
                    // Map<String, dynamic> header = {
                    //   'filter': 'task.id||eq||${task.id}',
                    //   "join": [
                    //     "task",
                    //   ],
                    //   'sort': 'orderIndex,ASC'
                    // };
                    // ref.read(assetNotifierProvider.notifier).getAllAsset(header);
                    // downloadPDF(task);
                  },
                  icon: const Icon(Icons.print))
        ],
      ))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tasks.length;

  @override
  int get selectedRowCount => 0;
  var anchor;
  final pdf = pw.Document();
  void downloadPDF(Task task) {
    if (task.type! == 'Preventive') {
      createPdfPreventive(task);
    }
  }

  savePDF(var filename) async {
    Uint8List pdfInBytes = await pdf.save();

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = '$filename.pdf';
    html.document.body!.children.add(anchor);

    anchor.click();
  }

  createPdfPreventive(Task task) async {
    var asset = await tableAssetRender(task);
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          tablePreventiveTorqueRender(task),
          tableAsset(asset),
        ];
      },
    ));

    savePDF('report_preventive');
  }

  tableAsset(List<pw.TableRow> asset) {
    return pw.Table(border: pw.TableBorder.all(), children: [...asset]);
  }

  FutureOr<List<pw.TableRow>> tableAssetRender(Task task) async {
    var state = ref.watch(assetNotifierProvider);
    List<pw.TableRow> dataRender = [];
    if (state is AssetLoaded) {
      List<Asset> assets = state.assets;
      var groupedItems = groupBy(assets, (e) => e.category);
      // if (task.type == 'Reguler') {
      //   reportRegulerTorque = task.reportRegulerTorque!;
      //   reportRegulerTorque!
      //       .sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));
      //   // report reguler torque
      //   // report reguler verticality
      // }

      for (int i = 0; i < groupedItems.length; i++) {
        String? category = groupedItems.keys.elementAt(i);
        List itemsInCategory = groupedItems[category]!;
        // Asset item = assets[i];
        dataRender.add(pw.TableRow(children: [
          pw.Column(children: [pw.Text('$category')])
        ]));
        for (int j = 0; j < itemsInCategory.length; j += 2) {
          var response = await http.get(Uri.http('103.82.241.80:3000',
              '/asset/getImage/${itemsInCategory[j].id}'));
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
    }

    // debugPrint('table render : ${assets.length}');

    return dataRender;
  }

  tablePreventiveTorqueRender(Task task) {
    return pw.Table(
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
          ...tableRenderPreventiveTorque(task.categorychecklistprev!),
        ]);
  }

  List<pw.TableRow> tableRenderPreventiveTorque(
      List<CategoryChecklistPreventive> categoryChecklistPreventives) {
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

  getColorIcon(String? status) {
    switch (status) {
      case STATUS_TODO:
        return Colors.blue;
      case STATUS_REVIEW:
        return Colors.amber;
      case STATUS_ACCEPTED:
        return Colors.green;
      case STATUS_REJECTED:
        return Colors.red;
      case STATUS_EXPIRED:
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}
