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
      mcategorychecklistpreventive: json['mcategorychecklistpreventive'] == null
          ? null
          : MasterCategoryChecklistPreventive.fromJson(
              json['mcategorychecklistpreventive'] as Map<String, dynamic>),
    )..id = json['id'] as int?;

Map<String, dynamic> _$MasterPointChecklistPreventiveToJson(
        MasterPointChecklistPreventive instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uraian': instance.uraian,
      'kriteria': instance.kriteria,
      'mcategorychecklistpreventive': instance.mcategorychecklistpreventive,
    };
