// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportregulerverticality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportRegulerVerticality _$ReportRegulerVerticalityFromJson(
        Map<String, dynamic> json) =>
    ReportRegulerVerticality(
      id: json['id'] as int?,
      horizontalityAb: json['horizontalityAb'] as int?,
      horizontalityBc: json['horizontalityBc'] as int?,
      horizontalityCd: json['horizontalityCd'] as int?,
      horizontalityDa: json['horizontalityDa'] as int?,
      theodolite1: json['theodolite1'] as String?,
      theodolite2: json['theodolite2'] as String?,
      alatUkur: json['alatUkur'] as String?,
      toleransiKetegakan: json['toleransiKetegakan'] as int?,
      valueVerticality: (json['valueVerticality'] as List<dynamic>?)
          ?.map((e) => ValueVerticality.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportRegulerVerticalityToJson(
        ReportRegulerVerticality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'horizontalityAb': instance.horizontalityAb,
      'horizontalityBc': instance.horizontalityBc,
      'horizontalityCd': instance.horizontalityCd,
      'horizontalityDa': instance.horizontalityDa,
      'theodolite1': instance.theodolite1,
      'theodolite2': instance.theodolite2,
      'alatUkur': instance.alatUkur,
      'toleransiKetegakan': instance.toleransiKetegakan,
      'valueVerticality': instance.valueVerticality,
    };
