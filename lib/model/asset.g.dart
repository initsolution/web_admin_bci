// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      id: json['id'] as int?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      isPassed: json['isPassed'] as bool?,
      note: json['note'] as String?,
      section: json['section'] as String?,
      orderIndex: json['orderIndex'] as int?,
      task: json['task'] == null
          ? null
          : Task.fromJson(json['task'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'description': instance.description,
      'url': instance.url,
      'isPassed': instance.isPassed,
      'note': instance.note,
      'section': instance.section,
      'orderIndex': instance.orderIndex,
      'task': instance.task,
    };
