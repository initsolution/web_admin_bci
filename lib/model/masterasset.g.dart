// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masterasset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasterAsset _$MasterAssetFromJson(Map<String, dynamic> json) => MasterAsset(
      tower_category: json['tower_category'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
    )..id = json['id'] as int?;

Map<String, dynamic> _$MasterAssetToJson(MasterAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tower_category': instance.tower_category,
      'category': instance.category,
      'description': instance.description,
    };
