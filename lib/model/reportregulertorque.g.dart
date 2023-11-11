// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportregulertorque.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportRegulerTorque _$ReportRegulerTorqueFromJson(Map<String, dynamic> json) =>
    ReportRegulerTorque(
      id: json['id'] as int?,
      towerSegment: json['towerSegment'] as String?,
      elevasi: json['elevasi'] as int?,
      boltSize: json['boltSize'] as String?,
      minimumTorque: json['minimumTorque'] as int?,
      qtyBolt: json['qtyBolt'] as int?,
      remark: json['remark'] as String?,
      orderIndex: json['orderIndex'] as int?,
    );

Map<String, dynamic> _$ReportRegulerTorqueToJson(
        ReportRegulerTorque instance) =>
    <String, dynamic>{
      'id': instance.id,
      'towerSegment': instance.towerSegment,
      'elevasi': instance.elevasi,
      'boltSize': instance.boltSize,
      'minimumTorque': instance.minimumTorque,
      'qtyBolt': instance.qtyBolt,
      'remark': instance.remark,
      'orderIndex': instance.orderIndex,
    };
