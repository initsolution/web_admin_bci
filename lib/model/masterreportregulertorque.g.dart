// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masterreportregulertorque.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterReportRegulerTorque _$MasterReportRegulerTorqueFromJson(
        Map<String, dynamic> json) =>
    MasterReportRegulerTorque(
      id: json['id'] as int?,
      fabricator: json['fabricator'] as String?,
      towerHeight: json['towerHeight'] as int?,
      towerSegment: json['towerSegment'] as String?,
      elevasi: json['elevasi'] as int?,
      boltSize: json['boltSize'] as String?,
      minimumTorque: json['minimumTorque'] as int?,
      qtyBolt: json['qtyBolt'] as int?,
    );

Map<String, dynamic> _$MasterReportRegulerTorqueToJson(
        MasterReportRegulerTorque instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fabricator': instance.fabricator,
      'towerHeight': instance.towerHeight,
      'towerSegment': instance.towerSegment,
      'elevasi': instance.elevasi,
      'boltSize': instance.boltSize,
      'minimumTorque': instance.minimumTorque,
      'qtyBolt': instance.qtyBolt,
    };
