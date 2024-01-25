import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/tenant.dart';
import 'package:flutter_web_ptb/providers/tenant_provider.dart';
import 'package:flutter_web_ptb/providers/tenant_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/theme/theme_extensions/app_data_table_theme.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_tenant.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_edit_tenants.dart';
import 'package:flutter_web_ptb/views/widgets/header.dart';
import 'package:flutter_web_ptb/views/widgets/portal_master_layout/portal_master_layout.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// import '../../providers/user_data_provider.dart';

class TenantScreen extends ConsumerStatefulWidget {
  const TenantScreen({super.key});

  @override
  ConsumerState<TenantScreen> createState() => _TenantScreenState();
}

class _TenantScreenState extends ConsumerState<TenantScreen> {
  late List<Tenant> filterData;
  bool _sortKode = true;
  bool _sortNameAsc = true;
  final _dataTableHorizontalScrollController = ScrollController();

  void sort(columnIndex) {
    setState(() {
      if (columnIndex == 0) {
        //kodeTenant
        if (_sortKode == true) {
          _sortKode = false;
          filterData.sort((a, b) => b.kodeTenant!.compareTo(a.kodeTenant!));
        } else {
          _sortKode = true;
          filterData.sort((a, b) => a.kodeTenant!.compareTo(b.kodeTenant!));
        }
      } else if (columnIndex == 1) {
        //nama
        if (_sortNameAsc == true) {
          _sortNameAsc = false;
          filterData.sort((a, b) => b.name!.compareTo(a.name!));
        } else {
          _sortNameAsc = true;
          filterData.sort((a, b) => a.name!.compareTo(b.name!));
        }
      }
    });
  }

  Widget tableTenant() {
    final themeData = Theme.of(context);
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    return Theme(
      data: themeData.copyWith(
        cardTheme: appDataTableTheme.cardTheme,
        dataTableTheme: appDataTableTheme.dataTableThemeData,
      ),
      child: SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double dataTableWidth =
                  max(kScreenWidthMd, constraints.maxWidth);
              return Scrollbar(
                controller: _dataTableHorizontalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _dataTableHorizontalScrollController,
                  child: SizedBox(
                    width: dataTableWidth,
                    child: Consumer(
                      builder: (context, ref, child) {
                        var state = ref.watch(tenantNotifierProvider);
                        if (state is TenantLoaded) {
                          DataTableSource data = TenantData(
                              tenants: state.tenants, context: context);
                          filterData = state.tenants;
                          return PaginatedDataTable(
                            source: data,
                            columns: [
                              DataColumn(
                                label: const Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text('Kode'),
                                ),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              DataColumn(
                                label: const Text('Name'),
                                onSort: (columnIndex, _) {
                                  sort(columnIndex);
                                },
                              ),
                              const DataColumn(label: Text('Is Active')),
                              const DataColumn(
                                label: Text('Action'),
                              ),
                            ],
                            columnSpacing: 100,
                            horizontalMargin: 10,
                            rowsPerPage: 10,
                            showCheckboxColumn: false,
                          );
                        } else if (state is TenantLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  @override
  void initState() {
    Map<String, dynamic> params = {};
    Future(
        () => ref.read(tenantNotifierProvider.notifier).getAllTenant(params));
    super.initState();
  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    ref.listen(tenantNotifierProvider, (previous, next) {
      if (next is TenantErrorServer) {
        if (next.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login again')),
          );
          // context.read<UserDataProvider>().clearUserDataAsync();
          ref.read(userDataProvider.notifier).clearUserDataAsync();
          GoRouter.of(context).go(RouteUri.login);
        }
      } else if (next is TenantDataChangeSuccess) {
        Map<String, dynamic> params = {};
        ref.read(tenantNotifierProvider.notifier).getAllTenant(params);
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          const Header(
            title: 'Tenant',
            subMenu: 'submenu tenant',
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
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(child: DialogAddTenant());
                              },
                            ),
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            Map<String, dynamic> params = {};
                            ref
                                .read(tenantNotifierProvider.notifier)
                                .getAllTenant(params);
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.filter_list),
                        //   onPressed: () {},
                        // ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                        // IconButton(
                        //   icon: const Icon(Icons.search),
                        //   onPressed: () {},
                        // ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                        // IconButton(
                        //   icon: const Icon(Icons.more_vert),
                        //   onPressed: () {},
                        // ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    tableTenant(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TenantData extends DataTableSource {
  final List<Tenant> tenants;
  final BuildContext context;
  TenantData({required this.tenants, required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text(tenants[index].kodeTenant!),
      )),
      DataCell(Text(tenants[index].name!)),
      DataCell(Text(tenants[index].isActive == true ? 'Active' : 'Deactive')),
      DataCell(Row(
        children: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DialogEditTenant(
                    tenant: tenants[index],
                  );
                },
              );
            },
          ),
        ],
      ))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tenants.length;

  @override
  int get selectedRowCount => 0;
}
