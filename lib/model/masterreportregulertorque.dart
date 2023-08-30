import 'package:json_annotation/json_annotation.dart';

part 'masterreportregulertorque.g.dart';

@JsonSerializable()
class MasterReportRegulerTorque {
  int? id;
  String? fabricator;
  int? tower_height;
  String? tower_segment;
  int? elevasi;
  String? bolt_size;
  int? minimum_torque;
  int? qty_bolt;

  MasterReportRegulerTorque(
      {this.fabricator,
      this.tower_height,
      this.tower_segment,
      this.elevasi,
      this.bolt_size,
      this.minimum_torque,
      this.qty_bolt});

  factory MasterReportRegulerTorque.fromJson(Map<String, dynamic> json) =>
      _$MasterReportRegulerTorqueFromJson(json);

  Map<String, dynamic> toJson() => _$MasterReportRegulerTorqueToJson(this);
}
