// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masterpointchecklistpreventive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterPointChecklistPreventive _$MasterPointChecklistPreventiveFromJson(
        Map<String, dynamic> json) =>
    MasterPointChecklistPreventive(
      uraian: json['uraian'] as String?,
      kriteria: json['kriteria'] as String?,
      mCategory: json['mCategory'] == null
          ? null
          : MasterCategoryChecklistPreventive.fromJson(
              json['mCategory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MasterPointChecklistPreventiveToJson(
        MasterPointChecklistPreventive instance) =>
    <String, dynamic>{
      'uraian': instance.uraian,
      'kriteria': instance.kriteria,
      'mCategory': instance.mCategory,
    };
