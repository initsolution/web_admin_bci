// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/asset.dart';
import 'package:flutter_web_ptb/model/reportregulertorque.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/asset_provider.dart';
import 'package:flutter_web_ptb/providers/asset_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_choose_image.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_detail_image.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';

import 'package:progressive_image/progressive_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ResultAssetScreen extends ConsumerStatefulWidget {
  final Task task;
  const ResultAssetScreen({super.key, required this.task});

  @override
  ConsumerState<ResultAssetScreen> createState() => _ResultAssetScreenState();
}

class _ResultAssetScreenState extends ConsumerState<ResultAssetScreen> {
  bool confirmAll = false;
  // var anchor;
  // final pdf = pw.Document();
  List<ReportRegulerTorque>? reportRegulerTorque;
  @override
  Widget build(BuildContext context) {
    // var value = ref.watch(userDataProvider.select((value) => value.username));
    // ref.listen(
    //   assetNotifierProvider,
    //   (previous, next) {
    // if (next is AssetLoaded) {
    //   debugPrint('pass pdf');
    // List<Asset> assets = next.assets;
    // var groupedItems = groupBy(assets, (e) => e.category);
    // ref.read(asyncPdfProvider.notifier).createPDF(groupedItems);
    // }
    //   },
    // );
    return Consumer(
      builder: (context, ref, child) {
        var state = ref.watch(assetNotifierProvider);
        if (state is AssetLoaded) {
          List<Asset> assets = state.assets;
          var groupedItems = groupBy(assets, (e) => e.category);
          if (widget.task.type == 'Reguler') {
            reportRegulerTorque = widget.task.reportRegulerTorque!;
            reportRegulerTorque!
                .sort((a, b) => a.orderIndex!.compareTo(b.orderIndex!));
            // report reguler torque
            // report reguler verticality
          }

          return PortalMasterLayout(
            selectedMenuUri: RouteUri.asset,
            body: ListView(
              padding: const EdgeInsets.all(kDefaultPadding * 2),
              children: [
                Header(title: 'Data Task', subMenu: '${widget.task.status}'),
                const SizedBox(height: 20),
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTaskInfo(),
                        formAsset(groupedItems, assets),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          // return PortalMasterLayout(
          //   selectedMenuUri: RouteUri.asset,
          //   body: widget.task.type == 'Reguler'
          //       ?
          //       // reguler
          //       DefaultTabController(
          //           length: 3,
          //           child: Scaffold(
          //             body: Column(
          //               children: [
          //                 const TabBar(labelColor: Colors.blue, tabs: [
          //                   Tab(
          //                     text: 'REPORT TORQUE',
          //                   ),
          //                   Tab(
          //                     text: 'REPORT VERTICALITY',
          //                   ),
          //                   Tab(
          //                     text: 'PHOTOS',
          //                   ),
          //                 ]),
          //                 Expanded(
          //                   child: TabBarView(children: [
          //                     SizedBox(
          //                       child: ReportRegulerTorqueWidget(
          //                         reportRegulerTorque: reportRegulerTorque!,
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       child: ReportRegulerVerticalityWidget(
          //                           reportRegulerVerticality:
          //                               widget.task.reportRegulerVerticality!),
          //                     ),
          //                     SizedBox(
          //                       child: formAsset(groupedItems, assets),
          //                     ),
          //                   ]),
          //                 ),
          //               ],
          //             ),
          //           ))
          //       :
          //       //preventive
          //       DefaultTabController(
          //           length: 2,
          //           child: Scaffold(
          //             body: Column(
          //               children: [
          //                 const TabBar(labelColor: Colors.blue, tabs: [
          //                   Tab(
          //                     text: 'ASSET',
          //                   ),
          //                   Tab(
          //                     text: 'CEKLIST',
          //                   ),
          //                 ]),
          //                 Expanded(
          //                   child: TabBarView(children: [
          //                     SizedBox(
          //                       child: formAsset(groupedItems, assets),
          //                     ),
          //                     SizedBox(
          //                       child: ReportPreventiveWidget(
          //                         categoryChecklistPreventives:
          //                             widget.task.categorychecklistprev!,
          //                       ),
          //                     )
          //                   ]),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          // );
        } else if (state is AssetChangeDataSuccess) {
          Map<String, dynamic> params = {
            "join": [
              "site",
              "makerEmployee",
              "verifierEmployee",
              "categorychecklistprev",
              "categorychecklistprev.pointChecklistPreventive",
              "reportRegulerTorque",
              "reportRegulerVerticality",
              "reportRegulerVerticality.valueVerticality"
            ]
          };
          Future(
              () => ref.read(taskNotifierProvider.notifier).getAllTask(params));
          GoRouter.of(context).go(RouteUri.asset);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildTaskInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Site Id',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 400, child: Text('${widget.task.site?.id}'))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Site Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 400, child: Text('${widget.task.site?.name}'))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Site Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                    width: 400, child: Text('${widget.task.site?.address}'))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Region',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 400, child: Text('${widget.task.site?.region}'))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Province',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                    width: 400, child: Text('${widget.task.site?.province}'))
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Tenant',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: Text('${widget.task.site?.tenants}'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Tower Height',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                    width: 400, child: Text('${widget.task.site?.towerHeight}'))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Tower Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                    width: 400, child: Text('${widget.task.site?.towerType}'))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Fabricator',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                    width: 400, child: Text('${widget.task.site?.fabricator}'))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Create Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 400, child: Text('${widget.task.createdDate}'))
              ],
            ),
          ],
        )
      ],
    );
  }

  // savePDF(var pdf) async {
  //   debugPrint('start save');
  //   Uint8List pdfInBytes = await pdf.save();
  //   final blob = html.Blob([pdfInBytes], 'application/pdf');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   anchor = html.document.createElement('a') as html.AnchorElement
  //     ..href = url
  //     ..style.display = 'none'
  //     ..download = 'report_asset.pdf';
  //   html.document.body!.children.add(anchor);
  // }

  // createPDF(var groupedItems) async {
  //   debugPrint('create pdf');
  //   var asset = await tableRender(groupedItems);
  //   // List<pw.Widget> widgets = [];
  //   // widgets.add(pw.Table(border: pw.TableBorder.all(), children: [...asset]));
  //   // pdf.addPage(
  //   //   pw.MultiPage(
  //   //     pageFormat: PdfPageFormat.a4,
  //   //     build: (context) {
  //   //       // nanti di cari
  //   //       return [
  //   //         pw.Table(border: pw.TableBorder.all(), children: [...asset])
  //   //       ];
  //   //     },
  //   //   ),
  //   // );

  //   pdf.addPage(
  //     pw.MultiPage(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (pw.Context context) {
  //         return [
  //           pw.Table(border: pw.TableBorder.all(), children: [...asset])
  //         ];
  //       },
  //     ),
  //   );
  //   debugPrint('save to pdf');
  //   savePDF(pdf);
  // }

  // FutureOr<List<pw.TableRow>> tableRender(var groupedItems) async {
  //   List<pw.TableRow> dataRender = [];
  //   // debugPrint('table render : ${assets.length}');
  //   for (int i = 0; i < groupedItems.length; i++) {
  //     String? category = groupedItems.keys.elementAt(i);
  //     List itemsInCategory = groupedItems[category]!;
  //     // Asset item = assets[i];
  //     dataRender.add(pw.TableRow(children: [
  //       pw.Column(children: [pw.Text('$category')])
  //     ]));
  //     for (int j = 0; j < itemsInCategory.length; j += 2) {
  //       var response = await http.get(Uri.http(
  //           '103.82.241.80:3000', '/asset/getImage/${itemsInCategory[j].id}'));
  //       var gambarAsset = response.bodyBytes;
  //       dataRender.add(
  //         pw.TableRow(
  //           children: [
  //             pw.Column(children: [
  //               pw.SizedBox(
  //                 height: 144,
  //                 width: 192,
  //                 child: pw.Image(
  //                   pw.MemoryImage(gambarAsset.buffer.asUint8List()),
  //                   fit: pw.BoxFit.contain,
  //                 ),
  //               ),
  //               pw.Text(itemsInCategory[j].description!)
  //             ]),
  //             if (j + 1 < itemsInCategory.length)
  //               pw.Column(children: [
  //                 pw.SizedBox(
  //                   height: 144,
  //                   width: 192,
  //                   child: pw.Image(
  //                     pw.MemoryImage(gambarAsset.buffer.asUint8List()),
  //                     fit: pw.BoxFit.contain,
  //                   ),
  //                 ),
  //                 pw.Text(itemsInCategory[j + 1].description!)
  //               ])
  //           ],
  //         ),
  //       );
  //     }
  //   }
  //   return dataRender;
  // }

  // FutureOr<List<pw.TableRow>> tableRender(
  //     var groupedItems, List<Asset> assets) async {
  //   List<pw.TableRow> dataRender = [];
  //   for (int i = 0; i < groupedItems.length; i++) {
  //     String? category = groupedItems.keys.elementAt(i);
  //     debugPrint('table render $category');
  //     List itemsInCategory = groupedItems[category]!;
  //     pw.TableRow tableRow = pw.TableRow(children: [
  //       pw.Container(
  //           child:
  //               pw.Text(category ?? '', style: const pw.TextStyle(fontSize: 8)),
  //           padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
  //       pw.Container(
  //           child: pw.Text('', style: const pw.TextStyle(fontSize: 8)),
  //           padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3)),
  //     ]);
  //     dataRender.add(tableRow);
  //     debugPrint('in i : $i length ${dataRender.length}');
  //     int temp = 1;
  //     for (int j = 0; j < itemsInCategory.length; j++) {
  //       pw.TableRow tableRowIsi;
  //       Asset item = itemsInCategory[j];
  //       List<pw.Container> dataGambar = [];
  //       debugPrint('temp : $temp');
  //       if (temp > 2) {
  //         tableRowIsi = pw.TableRow(children: [...dataGambar]);
  //         dataRender.add(tableRowIsi);
  //         debugPrint('in i : $i in j: $j length ${dataRender.length}');
  //         if (j < itemsInCategory.length) {
  //           debugPrint(item.description!);
  //           dataGambar.add(pw.Container(
  //               child: pw.Column(children: [
  //             // pw.SizedBox(
  //             //   height: 30 * 0.75,
  //             //   width: 30 * 0.55,
  //             //   child: pw.Image(
  //             //     pw.MemoryImage(gambarAsset.buffer.asUint8List()),
  //             //     fit: pw.BoxFit.contain,
  //             //   ),
  //             // ),
  //             pw.Text(item.description!)
  //           ])));
  //         }
  //         temp = 1;
  //       } else {
  //         debugPrint(item.description!);
  //         // var response = await http.get(
  //         //     Uri.http('103.82.241.80:3000', '/asset/getImage/${item.id}'));
  //         // var gambarAsset = response.bodyBytes;

  //         dataGambar.add(pw.Container(
  //             child: pw.Column(children: [
  //           // pw.SizedBox(
  //           //   height: 30 * 0.75,
  //           //   width: 30 * 0.55,
  //           //   child: pw.Image(
  //           //     pw.MemoryImage(gambarAsset.buffer.asUint8List()),
  //           //     fit: pw.BoxFit.contain,
  //           //   ),
  //           // ),
  //           pw.Text(item.description!)
  //         ])));
  //         temp++;
  //       }
  //     }
  //   }
  //   return dataRender;
  // }

  Widget formAsset(var groupedItems, List<Asset> assets) {
    final themeData = Theme.of(context);

    // createPDF(groupedItems);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Consumer(
              //   builder: (context, ref, child) {
              //     final asyncPdf = ref.watch(asyncPdfProvider);
              //     return asyncPdf.when(
              //       data: (data) {
              //         debugPrint('data: ${data.toString()}');
              //         // if (data is PdfReady) {
              //           return IconButton(
              //               onPressed: () {
              //                 ref.read(asyncPdfProvider.notifier).anchorClick();
              //               },
              //               icon: const Icon(Icons.picture_as_pdf_rounded));
              //         // } else {
              //         //   return const Icon(Icons.picture_as_pdf_outlined);
              //         // }
              //       },
              //       error: (error, stackTrace) =>
              //           const Icon(Icons.picture_as_pdf_outlined),
              //       loading: () => const CircularProgressIndicator(),
              //     );
              //   },
              // ),

              // IconButton(
              //   icon: const Icon(Icons.picture_as_pdf_rounded),
              //   onPressed: () {
              //     // anchor.click();
              //   },
              // ),

              IconButton(
                  onPressed: () async {
                    await launchUrlString('http://103.82.241.80:3000/task/downloadPdf/${widget.task.id}', mode: LaunchMode.platformDefault);
                  },
                  icon: const Icon(Icons.print)),
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
                icon: const Icon(Icons.save_as_rounded),
                onPressed: () {
                  ref.read(assetNotifierProvider.notifier).updateStatusAsset();
                },
              ),
              const SizedBox(
                width: 30,
              ),
              Checkbox(
                  value: confirmAll,
                  onChanged: (value) {
                    ref
                        .read(assetNotifierProvider.notifier)
                        .setIsPassedAllDataAsset(value!);
                    confirmAll = value;
                    setState(() {});
                  }),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: groupedItems.length,
            itemBuilder: (BuildContext context, int index) {
              String? category = groupedItems.keys.elementAt(index);
              List itemsInCategory = groupedItems[category]!;

              // Return a widget representing the category and its items
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                margin: const EdgeInsets.symmetric(vertical: 10),
                // padding: ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category!,
                      style: themeData.textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      // scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 550,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: itemsInCategory.length,
                      itemBuilder: (BuildContext context, int index) {
                        Asset item = itemsInCategory[index];
                        // debugPrint('${item.toString()} \n');
                        // Return a widget representing the item
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 207, 216, 220)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DialogDetailImage(
                                              id: item.id!);
                                        }),
                                    child: ProgressiveImage.assetNetwork(
                                      fit: BoxFit.contain,
                                      blur: 0,
                                      placeholder:
                                          'assets/images/img_placeholder.jpg',
                                      thumbnail:
                                          'assets/images/img_thumbnail.jpg',
                                      image:
                                          '$urlRepo/asset/getImage/${item.id}',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton.icon(
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.lightBlue)),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return DialogChooseImage(
                                                          idSource: item.id!,
                                                          assets: assets);
                                                    });
                                              },
                                              icon: const Icon(
                                                Icons.photo_library_rounded,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                'Replace',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                          Checkbox(
                                            value: item.isPassed,
                                            onChanged: (value) {
                                              item.isPassed = value;
                                              ref
                                                  .read(assetNotifierProvider
                                                      .notifier)
                                                  .setDataAsset(item);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.description!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



// SliverList.builder(
//                   itemCount: groupedItems.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     String? category = groupedItems.keys.elementAt(index);
//                     List itemsInCategory = groupedItems[category]!;

//                     // Return a widget representing the category and its items
//                     return SliverToBoxAdapter(
//                       child: Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                           color: Colors.red,
//                         )),
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 30, horizontal: 80),
//                         // padding: ,
//                         child: Column(
//                           children: [
//                             Text(category!,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 25)),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             SliverGrid.builder(
//                               gridDelegate:
//                                   const SliverGridDelegateWithMaxCrossAxisExtent(
//                                       maxCrossAxisExtent: 800,
//                                       childAspectRatio: 3 / 2,
//                                       crossAxisSpacing: 20,
//                                       mainAxisSpacing: 20),
//                               itemCount: itemsInCategory.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 Asset item = itemsInCategory[index];
//                                 // debugPrint('${item.toString()} \n');
//                                 // Return a widget representing the item
//                                 return SliverToBoxAdapter(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                       color: Colors.green,
//                                     )),
//                                     padding: const EdgeInsets.all(10),
//                                     child: Column(
//                                       children: [
//                                         Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Checkbox(
//                                             value: item.isPassed,
//                                             onChanged: (value) {
//                                               item.isPassed = value;
//                                               ref
//                                                   .read(assetNotifierProvider
//                                                       .notifier)
//                                                   .setDataAsset(item);
//                                             },
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: MediaQuery.of(context)
//                                                   .size
//                                                   .height *
//                                               0.35,
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.3,
//                                           child: Image.network(
//                                             '$urlRepo/asset/getImage/${item.id}',
//                                             fit: BoxFit.fill,
//                                           ),
//                                         ),
//                                         Text(item.description!),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 )