// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
      kode: json['kode'] as String?,
      name: json['name'] as String?,
      is_active: json['is_active'] as bool?,
    );

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
      'kode': instance.kode,
      'name': instance.name,
      'is_active': instance.is_active,
    };
