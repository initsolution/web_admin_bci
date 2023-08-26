import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/masterasset.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'masterasset_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class MasterAssetRepo {
  factory MasterAssetRepo(Dio dio, {String baseUrl}) = _MasterAssetRepo;

  @GET('/masterasset')
  Future<HttpResponse<dynamic>> getAllMasterAsset(
      @Header('Authorization') String token, Map<String, dynamic>? header);

  @POST('/masterasset')
  Future<HttpResponse> createMasterAsset(
      @Body() MasterAsset asset, @Header('Authorization') String token);

  @PATCH('/masterasset/{id}')
  Future<HttpResponse> updateMasterAsset(@Path() int id, @Body() MasterAsset asset);
}