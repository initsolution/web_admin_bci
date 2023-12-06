import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/masterasset.dart';
import 'package:flutter_web_ptb/providers/masterasset_state.dart';
import 'package:flutter_web_ptb/repository/masterasset_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

final masterAssetNotifierProvider =
    NotifierProvider<MasterAssetNotifier, MasterAssetState>(
  () {
    return MasterAssetNotifier(masterAssetRepo: MasterAssetRepo(Dio()));
  },
);

class MasterAssetNotifier extends Notifier<MasterAssetState> {
  final MasterAssetRepo masterAssetRepo;

  MasterAssetNotifier({required this.masterAssetRepo});

  List<MasterAsset>? masterAssets;
  @override
  MasterAssetState build() {
    return MasterAssetInitial();
  }

  getAllMasterAsset() async {
    state = MasterAssetLoading();
    Map<String, dynamic> header = {};
    final sharedPref = await SharedPreferences.getInstance();
    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      final HttpResponse data =
          await masterAssetRepo.getAllMasterAsset('Bearer $token', header);
      if (data.response.statusCode == 200) {
        // debugPrint('data emp : ${httpResponse.data}');
        masterAssets =
            (data.data as List).map((e) => MasterAsset.fromJson(e)).toList();
        if (masterAssets!.isEmpty) {
          state = MasterAssetLoadedEmpty();
        } else {
          state = MasterAssetLoaded(masterAssets: masterAssets!);
        }
      }
    } on DioException catch (error) {
      // debugPrint(error.response!.statusCode.toString());
      if (error.response!.statusCode == 401) {
        state = MasterAssetErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      }
    }
  }

  createOrEditMasterAsset(MasterAsset masterAsset, bool isEdit) async {
    state = MasterAssetLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    HttpResponse httpResponse;
    if (isEdit) {
      httpResponse = await masterAssetRepo.updateMasterAsset(
          masterAsset.id!, masterAsset, 'Bearer $token');
    } else {
      httpResponse =
          await masterAssetRepo.createMasterAsset(masterAsset, 'Bearer $token');
    }

    // if (DEBUG) debugPrint(httpResponse.response.statusCode.toString());
    if (httpResponse.response.statusCode == 201 ||
        httpResponse.response.statusCode == 200) {
      state = MasterAssetDataChangeSuccess();
    }
  }

  deleteMasterAsset(int id) async {
    state = MasterAssetLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    HttpResponse httpResponse =
        await masterAssetRepo.deleteMasterAsset(id, token);
    if (httpResponse.response.statusCode == 201 ||
        httpResponse.response.statusCode == 200) {
      state = MasterAssetDataChangeSuccess();
    }
  }

  searchMasterAsset(String search) async {
    state = MasterAssetLoading();
    List<MasterAsset> searchMasterAsset = masterAssets!
        .where((masterAsset) =>
            masterAsset.taskType!
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            masterAsset.section!.toLowerCase().contains(search.toLowerCase()) ||
            masterAsset.fabricator!
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            masterAsset.category!.toLowerCase().contains(search.toLowerCase()))
        .toList();
    state = MasterAssetLoaded(masterAssets: searchMasterAsset);
  }
}
