import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/masterreportregulertorque.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'masterreportregulertorque_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class MasterReportRegulerTorqueRepo {
  factory MasterReportRegulerTorqueRepo(Dio dio, {String baseUrl}) = _MasterReportRegulerTorqueRepo;

  @GET('/masterreportregulertorque')
  Future<HttpResponse<dynamic>> getAllMasterReportRegulerTorqueRepo(
      @Header('Authorization') String token, Map<String, dynamic>? header);

  @POST('/masterreportregulertorque')
  Future<HttpResponse> createMasterReportRegulerTorqueRepo(
      @Body() MasterReportRegulerTorque masterReportRegulerTorque, @Header('Authorization') String token);

  @PATCH('/masterreportregulertorque/{id}')
  Future<HttpResponse> updateMasterReportRegulerTorqueRepo(@Path() int id, @Body() MasterReportRegulerTorque masterReportRegulerTorque);
}