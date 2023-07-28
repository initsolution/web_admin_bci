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
      is_active: json['is_active'] as int?,
      is_vendor: json['is_vendor'] as int?,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'nik': instance.nik,
      'name': instance.name,
      'email': instance.email,
      'hp': instance.hp,
      'role': instance.role,
      'password': instance.password,
      'is_active': instance.is_active,
      'is_vendor': instance.is_vendor,
    };
