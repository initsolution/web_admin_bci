// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masterreportregulertorque.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterReportRegulerTorque _$MasterReportRegulerTorqueFromJson(
        Map<String, dynamic> json) =>
    MasterReportRegulerTorque(
      fabricator: json['fabricator'] as String?,
      tower_height: json['tower_height'] as int?,
      tower_segment: json['tower_segment'] as String?,
      elevasi: json['elevasi'] as int?,
      bolt_size: json['bolt_size'] as String?,
      minimum_torque: json['minimum_torque'] as int?,
      qty_bolt: json['qty_bolt'] as int?,
    )..id = json['id'] as int?;

Map<String, dynamic> _$MasterReportRegulerTorqueToJson(
        MasterReportRegulerTorque instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fabricator': instance.fabricator,
      'tower_height': instance.tower_height,
      'tower_segment': instance.tower_segment,
      'elevasi': instance.elevasi,
      'bolt_size': instance.bolt_size,
      'minimum_torque': instance.minimum_torque,
      'qty_bolt': instance.qty_bolt,
    };
