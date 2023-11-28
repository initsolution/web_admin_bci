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

bool isChecklist = true;

final isChecklistMasterPointChecklist =
    StateProvider<bool>((ref) => isChecklist);

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

  List<MasterPointChecklistPreventive>? masterPointChecklistPreventives;

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
        masterPointChecklistPreventives = (data.data as List)
            .map((e) => MasterPointChecklistPreventive.fromJson(e))
            .toList();
        if (masterPointChecklistPreventives!.isEmpty) {
          state = MasterPointChecklistPreventiveLoadedEmpty();
        } else {
          state = MasterPointChecklistPreventiveLoaded(
              masterPointChecklistPreventive: masterPointChecklistPreventives!);
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

  createOrEditMasterPointChecklistPreventive(
      MasterPointChecklistPreventive masterPointChecklistPreventive,
      bool isEdit) async {
    state = MasterPointChecklistPreventiveLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    HttpResponse httpResponse;
    if (isEdit) {
      httpResponse = await masterPointChecklistPreventiveRepo
          .updateMasterPointChecklistPreventive(
              masterPointChecklistPreventive.id!,
              masterPointChecklistPreventive,
              'Bearer $token');
    } else {
      httpResponse = await masterPointChecklistPreventiveRepo
          .createMasterPointChecklistPreventive(
              masterPointChecklistPreventive, 'Bearer $token');
    }

    if (httpResponse.response.statusCode == 201 ||
        httpResponse.response.statusCode == 200) {
      state = MasterPointChecklistPreventiveDataChangeSuccess();
    }
  }

  deleteMasterPointChecklistPreventive(int id) async {
    state = MasterPointChecklistPreventiveLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    HttpResponse httpResponse = await masterPointChecklistPreventiveRepo
        .deleteMasterPointChecklistPreventive(id, token);

    if (httpResponse.response.statusCode == 201 ||
        httpResponse.response.statusCode == 200) {
      state = MasterPointChecklistPreventiveDataChangeSuccess();
    }
  }

  searchMasterPointChecklistPrev(String search) async {
    state = MasterPointChecklistPreventiveLoading();
    List<MasterPointChecklistPreventive> searchMasterPointChecklistPrev =
        masterPointChecklistPreventives!
            .where(
                (e) => e.uraian!.toLowerCase().contains(search.toLowerCase()))
            .toList();
    state = MasterPointChecklistPreventiveLoaded(
        masterPointChecklistPreventive: searchMasterPointChecklistPrev);
  }
}
