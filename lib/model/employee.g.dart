// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      nik: json['nik'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      hp: json['hp'] as String?,
      role: json['role'] as String?,
      password: json['password'] as String?,
      isActive: json['isActive'] as bool?,
      isVendor: json['isVendor'] as bool?,
      urlEsign: json['urlEsign'] as String?,
      instansi: json['instansi'] as String?,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'nik': instance.nik,
      'name': instance.name,
      'email': instance.email,
      'hp': instance.hp,
      'role': instance.role,
      'password': instance.password,
      'isActive': instance.isActive,
      'isVendor': instance.isVendor,
      'urlEsign': instance.urlEsign,
      'instansi': instance.instansi,
    };
