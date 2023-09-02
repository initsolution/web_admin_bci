import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/providers/site_provider.dart';
import 'package:flutter_web_ptb/providers/site_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_site.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

import '../../providers/tenant_provider.dart';

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
    ref.listen(siteNotifierProvider, (previous, next) {
      if (next is SiteErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Header(
            title: 'Data Site',
            subMenu: 'All',
            userName: value,
          ),
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
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Map<String, dynamic> header = {
                              "filter": "is_active||eq||true"
                            };
                            ref
                                .read(tenantNotifierProvider.notifier)
                                .getAllTenant(header);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(child: DialogAddSite());
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {},
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {},
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(child: tableSite())
                  ],
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     anchor.click();
          //   },
          //   child: const Text('click me'),
          // ),
        ],
      ),
    );
  }

  Widget tableSite() {
    return Center(child: Consumer(
      builder: (context, ref, child) {
        var state = ref.watch(siteNotifierProvider);
        if (DEBUG) debugPrint('state : $state');
        if (state is SiteLoaded) {
          DataTableSource data = SiteData(sites: state.sites);
          return PaginatedDataTable(
            source: data,
            header: const Text('Site'),
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Tower Type')),
              DataColumn(label: Text('Tower Height')),
              DataColumn(label: Text('Fabricator')),
              DataColumn(label: Text('Tenants')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Regional')),
              DataColumn(label: Text('Province')),
              DataColumn(label: Text('Longitude')),
              DataColumn(label: Text('Latitude')),
            ],
            columnSpacing: 100,
            horizontalMargin: 10,
            rowsPerPage: 10,
            showCheckboxColumn: false,
          );
        } else if (state is SiteLoading) {
          return const CircularProgressIndicator();
        }
        return Container();
      },
    ));
  }
}

class SiteData extends DataTableSource {
  final List<Site> sites;
  SiteData({required this.sites});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(sites[index].id!)),
      DataCell(Text(sites[index].name!)),
      DataCell(Text(sites[index].tower_type!)),
      DataCell(Text(sites[index].tower_height!.toString())),
      DataCell(Text(sites[index].fabricator!.toString())),
      DataCell(Text(sites[index].tenants!.toString())),
      DataCell(Text(sites[index].address!.toString())),
      DataCell(Text(sites[index].kabupaten!.toString())),
      DataCell(Text(sites[index].province!.toString())),
      DataCell(Text(sites[index].longitude!.toString())),
      DataCell(Text(sites[index].latitude!.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => sites.length;

  @override
  int get selectedRowCount => 0;
}
