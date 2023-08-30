import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/masterpointchecklistpreventive.dart';
import 'package:flutter_web_ptb/providers/masterpointchecklistpreventive_state.dart';
import 'package:flutter_web_ptb/repository/masterpointchecklistpreventive_repo.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final masterPointChecklistPreventiveNotifierProvider = NotifierProvider<
    MasterPointChecklistPreventiveNotifier,
    MasterPointChecklistPreventiveState>(
  () => MasterPointChecklistPreventiveNotifier(
      masterPointChecklistPreventiveRepo:
          MasterPointChecklistPreventiveRepo(Dio())),
);

class MasterPointChecklistPreventiveNotifier
    extends Notifier<MasterPointChecklistPreventiveState> {
  final MasterPointChecklistPreventiveRepo masterPointChecklistPreventiveRepo;

  MasterPointChecklistPreventiveNotifier(
      {required this.masterPointChecklistPreventiveRepo});

  @override
  MasterPointChecklistPreventiveState build() {
    return MasterPointChecklistPreventiveInitial();
  }

  getAllMasterPointChecklistPreventive() async {
    state = MasterPointChecklistPreventiveLoading();
    Map<String, dynamic> header = {'join': 'mcategorychecklistpreventive'};
    final sharedPref = await SharedPreferences.getInstance();

    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      final HttpResponse data = await masterPointChecklistPreventiveRepo
          .getAllMasterPointChecklistPreventive('Bearer $token', header);
      if (data.response.statusCode == 200) {
        List<MasterPointChecklistPreventive> masterPointChecklistPreventives =
            (data.data as List)
                .map((e) => MasterPointChecklistPreventive.fromJson(e))
                .toList();
        if (masterPointChecklistPreventives.isEmpty) {
          state = MasterPointChecklistPreventiveLoadedEmpty();
        } else {
          state = MasterPointChecklistPreventiveLoaded(
              masterPointChecklistPreventive: masterPointChecklistPreventives);
        }
      }
    } on DioException catch (error) {
      if (error.response!.statusCode == 401) {
        state = MasterPointChecklistPreventiveErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      }
    }
  }

  createMasterPointChecklistPreventive(
      MasterPointChecklistPreventive masterPointChecklistPreventive) async {
    state = MasterPointChecklistPreventiveLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    final httpResponse = await masterPointChecklistPreventiveRepo
        .createMasterPointChecklistPreventive(
            masterPointChecklistPreventive, 'Bearer $token');
    if (DEBUG) debugPrint(httpResponse.data.toString());
  }
}
