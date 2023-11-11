// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int?,
      createdDate: json['createdDate'] as String?,
      submitedDate: json['submitedDate'] as String?,
      verifiedDate: json['verifiedDate'] as String?,
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
      categorychecklistprev: (json['categorychecklistprev'] as List<dynamic>?)
          ?.map((e) =>
              CategoryChecklistPreventive.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportRegulerTorque: (json['reportRegulerTorque'] as List<dynamic>?)
          ?.map((e) => ReportRegulerTorque.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportRegulerVerticality: json['reportRegulerVerticality'] == null
          ? null
          : ReportRegulerVerticality.fromJson(
              json['reportRegulerVerticality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'createdDate': instance.createdDate,
      'submitedDate': instance.submitedDate,
      'verifiedDate': instance.verifiedDate,
      'status': instance.status,
      'type': instance.type,
      'towerCategory': instance.towerCategory,
      'makerEmployee': instance.makerEmployee,
      'verifierEmployee': instance.verifierEmployee,
      'site': instance.site,
      'categorychecklistprev': instance.categorychecklistprev,
      'reportRegulerTorque': instance.reportRegulerTorque,
      'reportRegulerVerticality': instance.reportRegulerVerticality,
    };
