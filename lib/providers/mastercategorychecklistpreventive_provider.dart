import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/mastercategorychecklistpreventive.dart';
import 'package:flutter_web_ptb/providers/mastercategorychecklistpreventive_state.dart';
import 'package:flutter_web_ptb/repository/mastercategorychecklistpreventive_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

final selectedCategoryChecklistPreventive =
    StateProvider<MasterCategoryChecklistPreventive>(
        (ref) => MasterCategoryChecklistPreventive(name: '-'));
final masterCategoryChecklistPreventivNotifierProvider = NotifierProvider<
    MasterCategoryChecklistPreventiveNotifier,
    MasterCategoryChecklistPreventiveState>(
  () {
    return MasterCategoryChecklistPreventiveNotifier(
        masterCategoryPrevRepo: MasterCategoryChecklistPreventiveRepo(Dio()));
  },
);

class MasterCategoryChecklistPreventiveNotifier
    extends Notifier<MasterCategoryChecklistPreventiveState> {
  final MasterCategoryChecklistPreventiveRepo masterCategoryPrevRepo;

  MasterCategoryChecklistPreventiveNotifier(
      {required this.masterCategoryPrevRepo});

  @override
  MasterCategoryChecklistPreventiveState build() {
    return MasterCategoryChecklistPreventiveInitial();
  }

  getAllMasterCategoryChecklistPreventive() async {
    state = MasterCategoryChecklistPreventiveLoading();
    Map<String, dynamic> header = {};
    final sharedPref = await SharedPreferences.getInstance();
    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      final HttpResponse data = await masterCategoryPrevRepo
          .getAllMasterCategoryChecklistPreventive('Bearer $token', header);
      if (data.response.statusCode == 200) {
        // debugPrint('data emp : ${httpResponse.data}');
        List<MasterCategoryChecklistPreventive> masterCategoryPrev =
            (data.data as List)
                .map((e) => MasterCategoryChecklistPreventive.fromJson(e))
                .toList();
        if (masterCategoryPrev.isEmpty) {
          state = MasterCategoryChecklistPreventiveLoadedEmpty();
        } else {
          state = MasterCategoryChecklistPreventiveLoaded(
              masterCategoryPrev: masterCategoryPrev);
        }
      }
    } on DioException catch (error) {
      // debugPrint(error.response!.statusCode.toString());
      if (error.response!.statusCode == 401) {
        state = MasterCategoryChecklistPreventiveErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      }
    }
  }

  createMasterCategoryChecklistPreventive(
      MasterCategoryChecklistPreventive masterCategoryPrev) async {
    state = MasterCategoryChecklistPreventiveLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    final httpResponse =
        await masterCategoryPrevRepo.createMasterCategoryChecklistPreventive(
            masterCategoryPrev, 'Bearer $token');
    if (DEBUG) debugPrint(httpResponse.data.toString());
    if (httpResponse.response.statusCode == 201) {
      state = MasterCategoryChecklistPreventiveDataChangeSuccess();
    }
  }
}
