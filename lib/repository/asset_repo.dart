import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/asset.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

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

  @PATCH('$base/uploadImageFromLocal/{idAsset}')
  @MultiPart()
  Future<HttpResponse<dynamic>> changeImageFromLocal(
    @Part(contentType: 'image/jpg', fileName: 'asset', name: 'file')
    List<int> file,
    @Header('Authorization') String token,
    @Header('task-id') int taskIdHeader,
    @Path() int idAsset,
  );
}
