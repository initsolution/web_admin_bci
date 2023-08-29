import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/masterreportregulertorque.dart';
import 'package:flutter_web_ptb/providers/masterreportregulertorque_state.dart';
import 'package:flutter_web_ptb/repository/masterreportregulertorque_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';


final masterReportRegulerTorqueNotifierProvider = NotifierProvider<MasterReportRegulerTorqueNotifier, MasterReportRegulerTorqueState>(
  () {
    return MasterReportRegulerTorqueNotifier(masterReportRegulerTorqueRepo: MasterReportRegulerTorqueRepo(Dio()));
  },
);

class MasterReportRegulerTorqueNotifier extends Notifier<MasterReportRegulerTorqueState> {
  final MasterReportRegulerTorqueRepo masterReportRegulerTorqueRepo;

  MasterReportRegulerTorqueNotifier({required this.masterReportRegulerTorqueRepo});

  @override
  MasterReportRegulerTorqueState build() {
    return MasterReportRegulerTorqueStateInitial();
  }

  getAllMasterReportRegulerTorqueRepo() async {
    state = MasterReportRegulerTorqueStateLoading();
    Map<String, dynamic> header = {};
    final sharedPref = await SharedPreferences.getInstance();
    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      final HttpResponse data =
          await masterReportRegulerTorqueRepo.getAllMasterReportRegulerTorqueRepo('Bearer $token', header);
      if (data.response.statusCode == 200) {
        // debugPrint('data emp : ${httpResponse.data}');
        List<MasterReportRegulerTorque> masterReportRegulerTorque =
            (data.data as List).map((e) => MasterReportRegulerTorque.fromJson(e)).toList();
        if (masterReportRegulerTorque.isEmpty) {
          state = MasterReportRegulerTorqueLoadedEmpty();
        } else {
          state = MasterReportRegulerTorqueStateLoaded(masterReportRegulerTorque: masterReportRegulerTorque);
        }
      }
    } on DioException catch (error) {
      // debugPrint(error.response!.statusCode.toString());
      if (error.response!.statusCode == 401) {
        state = MasterReportRegulerTorqueErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      }
    }
  }

  createMasterReportRegulerTorqueRepo(MasterReportRegulerTorque masterReportRegulerTorque) async {
    state = MasterReportRegulerTorqueStateLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    final httpResponse = await masterReportRegulerTorqueRepo.createMasterReportRegulerTorqueRepo(masterReportRegulerTorque, 'Bearer $token');
    if (DEBUG) debugPrint(httpResponse.data.toString());
  }
}