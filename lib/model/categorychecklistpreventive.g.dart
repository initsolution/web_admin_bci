// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorychecklistpreventive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryChecklistPreventive _$CategoryChecklistPreventiveFromJson(
        Map<String, dynamic> json) =>
    CategoryChecklistPreventive(
      id: json['id'] as int?,
      nama: json['nama'] as String?,
      keterangan: json['keterangan'] as String?,
      orderIndex: json['orderIndex'] as int?,
      pointChecklistPreventive:
          (json['pointChecklistPreventive'] as List<dynamic>?)
              ?.map((e) =>
                  PointChecklistPreventive.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$CategoryChecklistPreventiveToJson(
        CategoryChecklistPreventive instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'keterangan': instance.keterangan,
      'orderIndex': instance.orderIndex,
      'pointChecklistPreventive': instance.pointChecklistPreventive,
    };
