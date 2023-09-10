// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      createdDate: json['createdDate'] as String?,
      submitedDate: json['submitedDate'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      towerCategory: json['towerCategory'] as String?,
      makerEmployee: json['makerEmployee'] == null
          ? null
          : Employee.fromJson(json['makerEmployee'] as Map<String, dynamic>),
      verifierEmployee: json['verifierEmployee'] == null
          ? null
          : Employee.fromJson(json['verifierEmployee'] as Map<String, dynamic>),
      site: json['site'] == null
          ? null
          : Site.fromJson(json['site'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'createdDate': instance.createdDate,
      'submitedDate': instance.submitedDate,
      'status': instance.status,
      'type': instance.type,
      'towerCategory': instance.towerCategory,
      'makerEmployee': instance.makerEmployee,
      'verifierEmployee': instance.verifierEmployee,
      'site': instance.site,
    };
