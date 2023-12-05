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
import 'package:flutter_web_ptb/views/widgets/dialog_choose_image.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_detail_image.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:flutter_web_ptb/views/widgets/report_preventive_widget.dart';
import 'package:flutter_web_ptb/views/widgets/report_reguler_torque_widget.dart';
import 'package:flutter_web_ptb/views/widgets/report_reguler_verticality.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Header(
                        title: 'Data Task', subMenu: '${widget.task.status}'),
                    const SizedBox(width: 30),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(kDefaultPadding / 2),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('${widget.task.type}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
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
        } else if (state is AssetChangeDataSuccess) {
          Map<String, dynamic> header = {
            'filter': 'task.id||eq||${widget.task.id}',
            "join": [
              "task",
            ],
            'sort': 'orderIndex,ASC'
          };
          Future(() =>
              ref.read(assetNotifierProvider.notifier).getAllAsset(header));
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
                SizedBox(width: 400, child: Text('${widget.task.created_at}'))
              ],
            ),
          ],
        )
      ],
    );
  }

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
              IconButton(
                  onPressed: () async {
                    await launchUrlString(
                        'http://103.82.241.80:3000/task/downloadPdf/${widget.task.id}',
                        mode: LaunchMode.platformDefault);
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
          _buildReport(widget.task.type?.toLowerCase() ?? 'unknown'),
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
                                      child: Image.network(
                                        '$urlRepo/asset/getImage/${item.id}',
                                        fit: BoxFit.contain,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      )
                                      // ProgressiveImage.assetNetwork(
                                      //   fit: BoxFit.contain,
                                      //   blur: 0,
                                      //   placeholder:
                                      //       'assets/images/img_placeholder.jpg',
                                      //   thumbnail:
                                      //       'assets/images/img_placeholder.jpg',
                                      //   image:
                                      //       '$urlRepo/asset/getImage/${item.id}',
                                      //   height:
                                      //       MediaQuery.of(context).size.height *
                                      //           0.3,
                                      //   width: MediaQuery.of(context).size.width *
                                      //       0.3,
                                      // ),
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

  Widget _buildReport(String type) {
    if (type == 'preventive') {
      return ExpansionTile(
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(width: 1, color: Color.fromRGBO(13, 71, 161, 1))),
        collapsedBackgroundColor: Colors.blue[900],
        backgroundColor: Colors.blue[900],
        textColor: Colors.white,
        collapsedTextColor: Colors.white,
        maintainState: true,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        trailing: const Icon(Icons.arrow_drop_down),
        leading: SvgPicture.asset('assets/icons/ic_report_checklist.svg',
            width: 32, height: 32),
        title: const Text('Report Checklist'),
        children: [
          ReportPreventiveWidget(
            categoryChecklistPreventives: widget.task.categorychecklistprev!,
          ),
        ],
      );
    } else if (type == 'reguler') {
      return Column(
        children: [
          ExpansionTile(
            collapsedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(width: 1, color: Colors.blue)),
            collapsedBackgroundColor: Colors.blue,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            collapsedTextColor: Colors.white,
            maintainState: true,
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            trailing: const Icon(Icons.arrow_drop_down),
            leading: SvgPicture.asset('assets/icons/ic_report_torque.svg',
                width: 32, height: 32),
            title: const Text('Report Bolt Tightening Torque'),
            children: [
              ReportRegulerTorqueWidget(
                reportRegulerTorque: reportRegulerTorque!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ExpansionTile(
            collapsedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(width: 1, color: Colors.pink)),
            collapsedBackgroundColor: Colors.pink,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            collapsedTextColor: Colors.white,
            maintainState: true,
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            trailing: const Icon(Icons.arrow_drop_down),
            leading: SvgPicture.asset('assets/icons/ic_report_verticality.svg',
                width: 32, height: 32),
            title: const Text('Report Verticality'),
            children: [
              ReportRegulerVerticalityWidget(
                  reportRegulerVerticality:
                      widget.task.reportRegulerVerticality!),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}