// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
      id: json['id'] as int?,
      kodeTenant: json['kodeTenant'] as String?,
      name: json['name'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
      'id': instance.id,
      'kodeTenant': instance.kodeTenant,
      'name': instance.name,
      'isActive': instance.isActive,
    };
