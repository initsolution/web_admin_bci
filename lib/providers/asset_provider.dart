import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/asset.dart';
import 'package:flutter_web_ptb/providers/asset_state.dart';
import 'package:flutter_web_ptb/repository/asset_repo.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

int idSelected = -1;

final idSelectedAsset = StateProvider<int>((ref) => idSelected);
final assetNotifierProvider = NotifierProvider<AssetNotifier, AssetState>(
  () => AssetNotifier(assetRepo: AssetRepo(Dio())),
);

class AssetNotifier extends Notifier<AssetState> {
  final AssetRepo assetRepo;

  AssetNotifier({required this.assetRepo});

  List<Asset>? dataAsset;
  @override
  AssetState build() {
    return AssetInitial();
  }

  getAllAsset(Map<String, dynamic> header) async {
    state = AssetLoading();

    final sharedPref = await SharedPreferences.getInstance();

    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';

      final HttpResponse data =
          await assetRepo.getAllAsset('bearer $token', header);
      if (data.response.statusCode == 200) {
        // debugPrint(data.data);
        List<Asset> assets =
            (data.data as List).map((e) => Asset.fromJson(e)).toList();
        if (assets.isEmpty) {
          debugPrint('asset null');
          state = AssetLoadedEmpty();
        } else {
          debugPrint('asset not null');
          debugPrint(assets.toString());
          dataAsset = assets;
          state = AssetLoaded(assets: dataAsset!);
        }
      }
    } on DioException catch (error) {
      state = AssetErrorServer(
          message: error.message, statusCode: error.response!.statusCode);
    }
  }

  getTempAsset() async {
    state = AssetLoading();
    state = AssetLoaded(assets: dataAsset!);
  }

  setDataAsset(Asset asset) {
    state = AssetLoading();
    // bool found = dataAsset!.contains((dta) => dta.id == asset.id);
    // if (found) {
    dataAsset![dataAsset!.indexWhere((element) => element.id == asset.id)] =
        asset;
    // }
    state = AssetLoaded(assets: dataAsset!);
  }

  setIsPassedAllDataAsset(bool isPassed) {
    state = AssetLoading();
    List<Asset> temp = [];
    for (var element in dataAsset!) {
      element.isPassed = isPassed;
      temp.add(element);
    }
    dataAsset = temp;
    state = AssetLoaded(assets: dataAsset!);
  }

  updateStatusAsset(String? note) async {
    // state = AssetLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    HttpResponse response = await assetRepo
        .updateStatusAll(token, {'asset': dataAsset!, 'note': note});
    debugPrint('response : ${response.response.statusCode}');
    if (response.response.statusCode == 200) {
      state = AssetChangeDataSuccess();
    } else {
      state = AssetErrorServer(
          message: response.response.statusMessage,
          statusCode: response.response.statusCode);
    }
  }

  changeImage(int idSource, int idDestination) async {
    debugPrint('idsource : $idSource vs idDestination : $idDestination');
    if (idDestination != -1) {
      final sharedPref = await SharedPreferences.getInstance();
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      debugPrint(
          {'idSource': idSource, 'idDestination': idDestination}.toString());
      HttpResponse response = await assetRepo.changeImage(
          token, {'idSource': idSource, 'idDestination': idDestination});
      if (response.response.statusCode == 200) {
        state = AssetChangeDataSuccess();
      } else {
        state = AssetErrorServer(
            message: response.response.statusMessage,
            statusCode: response.response.statusCode);
      }
    } else {
      state = AssetChangeDataFailed(message: 'belum memilih gambar');
    }
    idSelected = -1;
  }

  changeImageFromLocal(int idAsset, List<int>? file, int idTask) async {
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    HttpResponse response =
        await assetRepo.changeImageFromLocal(file!, token, idTask, idAsset);
    if (response.response.statusCode == 200) {
      state = AssetChangeDataSuccess();
    } else {
      state = AssetErrorServer(
          message: response.response.statusMessage,
          statusCode: response.response.statusCode);
    }
  }
}
