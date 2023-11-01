import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/asset.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'asset_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class AssetRepo {
  static const String base = '/asset';
  factory AssetRepo(Dio dio, {String baseUrl}) = _AssetRepo;

  @GET(base)
  Future<HttpResponse<dynamic>> getAllAsset(
      @Header('Authorization') String token,
      @Queries() Map<String, dynamic>? header);

  @PATCH('$base/updateStatusAll')
  Future<HttpResponse<dynamic>> updateStatusAll(
      @Header('Authorization') String token,
      @Body() Map<String, List<Asset>> data);

  @PATCH('$base/changeImage')
  Future<HttpResponse<dynamic>> changeImage(
      @Header('Authorization') String token, @Body() Map<String, dynamic> data);
}
