import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'tenant.g.dart';

@JsonSerializable()
class Tenant {
  String? kode;
  String? name;
  bool? is_active;
  Tenant({
    this.kode,
    this.name,
    this.is_active
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  Map<String, dynamic> toJson() => _$TenantToJson(this);
}
