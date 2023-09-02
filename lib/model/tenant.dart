// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'tenant.g.dart';

@JsonSerializable()
class Tenant {
  int? id;
  String? kodeTenant;
  String? name;
  bool? isActive;
  Tenant({
    this.id,
    this.kodeTenant,
    this.name,
    this.isActive,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  Map<String, dynamic> toJson() => _$TenantToJson(this);

  Tenant copyWith({
    int? id,
    String? kodeTenant,
    String? name,
    bool? isActive,
  }) {
    return Tenant(
      id: id ?? this.id,
      kodeTenant: kodeTenant ?? this.kodeTenant,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'kodeTenant': kodeTenant,
      'name': name,
      'isActive': isActive,
    };
  }

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id'] != null ? map['id'] as int : null,
      kodeTenant: map['kodeTenant'] != null ? map['kodeTenant'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
    );
  }

  @override
  String toString() {
    return 'Tenant(id: $id, kodeTenant: $kodeTenant, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant Tenant other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.kodeTenant == kodeTenant &&
      other.name == name &&
      other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      kodeTenant.hashCode ^
      name.hashCode ^
      isActive.hashCode;
  }
}
