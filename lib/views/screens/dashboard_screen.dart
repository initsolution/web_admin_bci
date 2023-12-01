import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/task_provider.dart';
import 'package:flutter_web_ptb/providers/task_state.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_button_theme.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_color_scheme.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/card_elements.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _dataTableHorizontalScrollController = ScrollController();
  Map<String, dynamic> params = {};
  late DateTimeRange dateRange;

  @override
  void initState() {
    dateRange = DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 30)),
        end: DateTime.now());
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
      'sort': ['updated_at,DESC'],
      'filter': [
        'created_at||gte||${DateFormat('yyyy-MM-dd').format(dateRange.start)}',
        'created_at||lte||${DateFormat('yyyy-MM-dd').format(dateRange.end.add(const Duration(days: 1)))}',
      ]
    };
    Future(() => ref.read(taskNotifierProvider.notifier).getAllTask(params));
    super.initState();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    // final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    final size = MediaQuery.of(context).size;

    final summaryCardCrossAxisCount = (size.width >= kScreenWidthLg ? 4 : 2);
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Header(
              title: 'Dashboard',
              subMenu:
                  'Periode ${DateFormat('dd/MM/yyyy').format(dateRange.start)}  -  ${DateFormat('dd/MM/yyyy').format(dateRange.end)} '),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final summaryCardWidth = ((constraints.maxWidth -
                        (kDefaultPadding * (summaryCardCrossAxisCount - 1))) /
                    summaryCardCrossAxisCount);

                return Consumer(builder: (context, ref, child) {
                  var state = ref.watch(taskNotifierProvider);
                  int totalTask = 0;
                  int totalVerified = 0;
                  int totalReview = 0;
                  int totalTodo = 0;
                  if (state is TaskLoaded) {
                    List<Task> tasks = state.tasks;
                    totalTask = tasks.length;
                    totalVerified = tasks
                        .where((element) =>
                            element.status!.toLowerCase() == 'verified')
                        .length;
                    totalReview = tasks
                        .where((element) =>
                            element.status!.toLowerCase() == 'review')
                        .length;
                    totalTodo = tasks
                        .where((element) =>
                            element.status!.toLowerCase() == 'todo')
                        .length;
                  }
                  return Wrap(
                    direction: Axis.horizontal,
                    spacing: kDefaultPadding,
                    runSpacing: kDefaultPadding,
                    children: [
                      SummaryCard(
                        title: 'Total Task',
                        value: '$totalTask',
                        icon: Icons.task,
                        backgroundColor: appColorScheme.info,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: 'Total To Do',
                        value: '$totalTodo',
                        icon: Icons.start_rounded,
                        backgroundColor: appColorScheme.error,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: 'Total Review',
                        value: '$totalReview',
                        icon: Icons.access_time,
                        backgroundColor: appColorScheme.warning,
                        textColor: appColorScheme.buttonTextBlack,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                      SummaryCard(
                        title: 'Total Verified',
                        value: '$totalVerified',
                        icon: Icons.verified,
                        backgroundColor: appColorScheme.success,
                        textColor: themeData.colorScheme.onPrimary,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                    ],
                  );
                });
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: kDefaultPadding),
          //   child: Card(
          //     clipBehavior: Clip.antiAlias,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const CardHeader(
          //           title: 'Recent Orders',
          //           showDivider: false,
          //         ),
          //         SizedBox(
          //           width: double.infinity,
          //           child: LayoutBuilder(
          //             builder: (context, constraints) {
          //               final double dataTableWidth =
          //                   max(kScreenWidthMd, constraints.maxWidth);

          //               return Scrollbar(
          //                 controller: _dataTableHorizontalScrollController,
          //                 thumbVisibility: true,
          //                 trackVisibility: true,
          //                 child: SingleChildScrollView(
          //                   scrollDirection: Axis.horizontal,
          //                   controller: _dataTableHorizontalScrollController,
          //                   child: SizedBox(
          //                     width: dataTableWidth,
          //                     child: Theme(
          //                       data: themeData.copyWith(
          //                         cardTheme: appDataTableTheme.cardTheme,
          //                         dataTableTheme:
          //                             appDataTableTheme.dataTableThemeData,
          //                       ),
          //                       child: DataTable(
          //                         showCheckboxColumn: false,
          //                         showBottomBorder: true,
          //                         columns: const [
          //                           DataColumn(
          //                               label: Text('No.'), numeric: true),
          //                           DataColumn(label: Text('Date')),
          //                           DataColumn(label: Text('Item')),
          //                           DataColumn(
          //                               label: Text('Price'), numeric: true),
          //                         ],
          //                         rows: List.generate(5, (index) {
          //                           return DataRow.byIndex(
          //                             index: index,
          //                             cells: [
          //                               DataCell(Text('#${index + 1}')),
          //                               const DataCell(Text('2022-06-30')),
          //                               DataCell(Text('Item ${index + 1}')),
          //                               DataCell(
          //                                   Text('${Random().nextInt(10000)}')),
          //                             ],
          //                           );
          //                         }),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: Padding(
          //             padding: const EdgeInsets.all(kDefaultPadding),
          //             child: SizedBox(
          //               height: 40.0,
          //               width: 120.0,
          //               child: ElevatedButton(
          //                 onPressed: () {},
          //                 style: themeData
          //                     .extension<AppButtonTheme>()!
          //                     .infoElevated,
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.min,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Padding(
          //                       padding: const EdgeInsets.only(
          //                           right: kDefaultPadding * 0.5),
          //                       child: Icon(
          //                         Icons.visibility_rounded,
          //                         size: (themeData
          //                                 .textTheme.labelLarge!.fontSize! +
          //                             4.0),
          //                       ),
          //                     ),
          //                     const Text('View All'),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // ElevatedButton(
          //   onPressed: () {
          //     GoRouter.of(context).go(RouteUri.detailDashboard);
          //   },
          //   child: const Text('Tekann'),
          // )
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double width;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 120.0,
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: backgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: kDefaultPadding * 0.5,
              right: kDefaultPadding * 0.5,
              child: Icon(
                icon,
                size: 80.0,
                color: iconColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: kDefaultPadding * 0.5),
                    child: Text(
                      value,
                      style: textTheme.headlineMedium!.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: textTheme.labelLarge!.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
