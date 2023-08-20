// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Site _$SiteFromJson(Map<String, dynamic> json) => Site(
      id: json['id'] as String?,
      name: json['name'] as String?,
      tower_type: json['tower_type'] as String?,
      tower_height: json['tower_height'] as int?,
      fabricator: json['fabricator'] as String?,
      tenants: json['tenants'] as String?,
      kabupaten: json['kabupaten'] as String?,
      province: json['province'] as String?,
      address: json['address'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
    );

Map<String, dynamic> _$SiteToJson(Site instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tower_type': instance.tower_type,
      'tower_height': instance.tower_height,
      'fabricator': instance.fabricator,
      'tenants': instance.tenants,
      'kabupaten': instance.kabupaten,
      'province': instance.province,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
