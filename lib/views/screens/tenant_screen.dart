import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/app_router.dart';
import 'package:flutter_web_ptb/constants/dimens.dart';
import 'package:flutter_web_ptb/model/tenant.dart';
import 'package:flutter_web_ptb/providers/tenant_provider.dart';
import 'package:flutter_web_ptb/providers/tenant_state.dart';
import 'package:flutter_web_ptb/providers/userdata.provider.dart';
import 'package:flutter_web_ptb/views/widgets/dialog_add_tenant.dart';
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
  Widget tableTenant() {
    return Center(child: Consumer(
      builder: (context, ref, child) {
        var state = ref.watch(tenantNotifierProvider);
        if (state is TenantLoaded) {
          DataTableSource data = TenantData(tenants: state.tenants);
          return PaginatedDataTable(
            source: data,
            header: const Text('Tenant'),
            columns: const [
              DataColumn(label: Text('Kode')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Is Active')),
            ],
            columnSpacing: 100,
            horizontalMargin: 10,
            rowsPerPage: 10,
            showCheckboxColumn: false,
          );
        } else if (state is TenantLoading) {
          return const CircularProgressIndicator();
        }
        return Container();
      },
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    var value = ref.watch(userDataProvider.select((value) => value.username));
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
      }
    });
    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Header(
            title: 'Tenant',
            subMenu: 'submenu tenant',
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
                    Center(child: tableTenant())
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
  TenantData({required this.tenants});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(tenants[index].kode!)),
      DataCell(Text(tenants[index].name!)),
      DataCell(Text(tenants[index].is_active!.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tenants.length;

  @override
  int get selectedRowCount => 0;
}