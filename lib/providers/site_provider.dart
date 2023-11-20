import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:flutter_web_ptb/providers/site_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../repository/site_repo.dart';

int province = 0;
String kabupaten = "";
final provinceNotifierProvider = StateProvider<int>((ref) => province);
final kabupatenNotifierProvider = StateProvider<String>((ref) => kabupaten);

final siteNotifierProvider = NotifierProvider<SiteNotifier, SiteState>(
  () {
    return SiteNotifier(siteRepo: SiteRepo(Dio()));
  },
);

class SiteNotifier extends Notifier<SiteState> {
  final SiteRepo siteRepo;
  List<Site>? sites;
  SiteNotifier({required this.siteRepo});

  @override
  SiteState build() {
    return SiteInitial();
  }

  getAllSite(Map<String, dynamic>? header) async {
    state = SiteLoading();
    final sharedPref = await SharedPreferences.getInstance();
    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      final HttpResponse data =
          await siteRepo.getAllSite('Bearer $token', header);
      if (data.response.statusCode == 200) {
        // debugPrint('data emp : ${httpResponse.data}');
        sites = (data.data as List).map((e) => Site.fromJson(e)).toList();
        if (sites!.isEmpty) {
          state = SiteLoadedEmpty();
        } else {
          state = SiteLoaded(sites: sites!);
        }
      }
    } on DioException catch (error) {
      // debugPrint(error.response!.statusCode.toString());
      if (error.response!.statusCode == 401) {
        state = SiteErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      }
    }
  }

  createOrEditSite(Site site, bool isEdit) async {
    state = SiteLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    HttpResponse httpResponse;
    if (isEdit) {
      httpResponse = await siteRepo.updateSite(site.id!, site, 'Bearer $token');
    } else {
      httpResponse = await siteRepo.createSite(site, 'Bearer $token');
    }
    if (DEBUG) debugPrint(httpResponse.data.toString());
    if (httpResponse.response.statusCode == 201) {
      state = SiteDataChangeSuccess();
    }
  }

  searchSite(String search) async {
    state = SiteLoading();
    List<Site> searchSite = sites!
        .where(
            (site) => site.name!.toLowerCase().contains(search.toLowerCase()))
        .toList();
    state = SiteLoaded(sites: searchSite);
  }
}
