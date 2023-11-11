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
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:flutter_web_ptb/views/widgets/report_preventive_widget.dart';
import 'package:flutter_web_ptb/views/widgets/report_reguler_torque_widget.dart';
import 'package:flutter_web_ptb/views/widgets/report_reguler_verticality.dart';
import 'package:go_router/go_router.dart';

class ResultAssetScreen extends ConsumerStatefulWidget {
  final Task task;
  const ResultAssetScreen({super.key, required this.task});

  @override
  ConsumerState<ResultAssetScreen> createState() => _ResultAssetScreenState();
}

class _ResultAssetScreenState extends ConsumerState<ResultAssetScreen> {
  bool confirmAll = false;

  List<ReportRegulerTorque>? reportRegulerTorque;
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(assetNotifierProvider);
    // var value = ref.watch(userDataProvider.select((value) => value.username));

    if (state is AssetLoaded) {
      List<Asset> assets = state.assets;

      debugPrint('result asset');
      debugPrint(assets.toString());
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
          body: widget.task.type == 'Reguler'
              ?
              // reguler
              DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    body: Column(
                      children: [
                        const TabBar(labelColor: Colors.blue, tabs: [
                          Tab(
                            text: 'REPORT TORQUE',
                          ),
                          Tab(
                            text: 'REPORT VERTICALITY',
                          ),
                          Tab(
                            text: 'PHOTOS',
                          ),
                        ]),
                        Expanded(
                          child: TabBarView(children: [
                            SizedBox(
                              child: ReportRegulerTorqueWidget(
                                reportRegulerTorque: reportRegulerTorque!,
                              ),
                            ),
                            SizedBox(
                              child: ReportRegulerVerticalityWidget(
                                  reportRegulerVerticality:
                                      widget.task.reportRegulerVerticality!),
                            ),
                            SizedBox(
                              child: formAsset(groupedItems, assets),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ))
              :
              //preventive
              DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    body: Column(
                      children: [
                        const TabBar(labelColor: Colors.blue, tabs: [
                          Tab(
                            text: 'ASSET',
                          ),
                          Tab(
                            text: 'CEKLIST',
                          ),
                        ]),
                        Expanded(
                          child: TabBarView(children: [
                            SizedBox(
                              child: formAsset(groupedItems, assets),
                            ),
                            SizedBox(
                              child: ReportPreventiveWidget(
                                categoryChecklistPreventives:
                                    widget.task.categorychecklistprev!,
                              ),
                            )
                          ]),
                        ),
                      ],
                    ),
                  )));
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
      Future(() => ref.read(taskNotifierProvider.notifier).getAllTask(params));
      GoRouter.of(context).go(RouteUri.asset);
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget formAsset(var groupedItems, var assets) {
    return ListView(
      padding: const EdgeInsets.all(kDefaultPadding),
      children: [
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
                        icon: const Icon(Icons.refresh),
                        onPressed: () {},
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_box),
                        onPressed: () {
                          ref
                              .read(assetNotifierProvider.notifier)
                              .updateStatusAsset();
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
                          color: Colors.red,
                        )),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 50),
                        // padding: ,
                        child: Column(
                          children: [
                            Text(category!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25)),
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
                                    color: Colors.green,
                                  )),
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.change_circle),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return DialogChooseImage(
                                                            idSource: item.id!,
                                                            assets: assets);
                                                      });
                                                },
                                              )),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Checkbox(
                                              value: item.isPassed,
                                              onChanged: (value) {
                                                item.isPassed = value;
                                                ref
                                                    .read(assetNotifierProvider
                                                        .notifier)
                                                    .setDataAsset(item);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return DialogDetailImage(
                                                    id: item.id!);
                                              }),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.75,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            child: Image.network(
                                              '$urlRepo/asset/getImage/${item.id}',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(item.description!),
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
            ),
          ),
        ),
      ],
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