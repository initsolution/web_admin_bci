// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Site _$SiteFromJson(Map<String, dynamic> json) => Site(
      id: json['id'] as String?,
      name: json['name'] as String?,
      towerType: json['towerType'] as String?,
      towerHeight: json['towerHeight'] as int?,
      fabricator: json['fabricator'] as String?,
      tenants: json['tenants'] as String?,
      region: json['region'] as String?,
      province: json['province'] as String?,
      address: json['address'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
    );

Map<String, dynamic> _$SiteToJson(Site instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'towerType': instance.towerType,
      'towerHeight': instance.towerHeight,
      'fabricator': instance.fabricator,
      'tenants': instance.tenants,
      'region': instance.region,
      'province': instance.province,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
