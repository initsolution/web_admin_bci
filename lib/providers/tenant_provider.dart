import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/tenant.dart';
import 'package:flutter_web_ptb/providers/tenant_state.dart';
import 'package:flutter_web_ptb/repository/tenant_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

bool isActive = false;

final tenantIsActiveProvider = StateProvider<bool>((ref) => isActive);

final tenantNotifierProvider = NotifierProvider<TenantNotifier, TenantState>(
  () {
    return TenantNotifier(tenantRepo: TenantRepo(Dio()));
  },
);

class TenantNotifier extends Notifier<TenantState> {
  final TenantRepo tenantRepo;

  TenantNotifier({required this.tenantRepo});

  @override
  TenantState build() {
    return TenantInitial();
  }

  getAllTenant(Map<String, dynamic> params) async {
    state = TenantLoading();
    Map<String, dynamic> header = params;
    final sharedPref = await SharedPreferences.getInstance();
    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      final HttpResponse data =
          await tenantRepo.getAllTenant('Bearer $token', header);
      if (data.response.statusCode == 200) {
        // debugPrint('data emp : ${httpResponse.data}');
        List<Tenant> tenants =
            (data.data as List).map((e) => Tenant.fromJson(e)).toList();
        if (tenants.isEmpty) {
          state = TenantLoadedEmpty();
        } else {
          state = TenantLoaded(tenants: tenants);
        }
      }
    } on DioException catch (error) {
      // debugPrint(error.response!.statusCode.toString());
      if (error.response!.statusCode == 401) {
        state = TenantErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      }
    }
  }

  createTenant(Tenant tenant) async {
    state = TenantLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    final httpResponse = await tenantRepo.createTenant(tenant, 'Bearer $token');
    if (DEBUG) debugPrint(httpResponse.data.toString());
    if (httpResponse.response.statusCode == 201) {
      state = TenantDataChangeSuccess();
    }
  }

  updateTenant(Tenant tenant) async {
    state = TenantLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    final httpResponse =
        await tenantRepo.updateTenant('Bearer $token', tenant.id!, tenant);
    if (DEBUG) debugPrint(httpResponse.data.toString());
    if (httpResponse.response.statusCode == 200) {
      state = TenantDataChangeSuccess();
    }
  }
}
