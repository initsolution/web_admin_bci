// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  String? nik;
  String? name;
  String? email;
  String? hp;
  String? role;
  String? password;
  int? is_active;
  int? is_vendor;
  Employee({
    this.nik,
    this.name,
    this.email,
    this.hp,
    this.role,
    this.password,
    this.is_active,
    this.is_vendor,
  });

  Employee copyWith({
    String? nik,
    String? name,
    String? email,
    String? hp,
    String? role,
    String? password,
    int? is_active,
    int? is_vendor,
  }) {
    return Employee(
      nik: nik ?? this.nik,
      name: name ?? this.name,
      email: email ?? this.email,
      hp: hp ?? this.hp,
      role: role ?? this.role,
      password: password ?? this.password,
      is_active: is_active ?? this.is_active,
      is_vendor: is_vendor ?? this.is_vendor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nik': nik,
      'name': name,
      'email': email,
      'hp': hp,
      'role': role,
      'password': password,
      'is_active': is_active,
      'is_vendor': is_vendor,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      nik: map['nik'] != null ? map['nik'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      hp: map['hp'] != null ? map['hp'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      is_active: map['is_active'] != null ? map['is_active'] as int : null,
      is_vendor: map['is_vendor'] != null ? map['is_vendor'] as int : null,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory Employee.fromJson(String source) =>
  //     Employee.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  String toString() {
    return 'Employee(nik: $nik, name: $name, email: $email, hp: $hp, role: $role, password: $password, is_active: $is_active, is_vendor: $is_vendor)';
  }

  @override
  bool operator ==(covariant Employee other) {
    if (identical(this, other)) return true;

    return other.nik == nik &&
        other.name == name &&
        other.email == email &&
        other.hp == hp &&
        other.role == role &&
        other.password == password &&
        other.is_active == is_active &&
        other.is_vendor == is_vendor;
  }

  @override
  int get hashCode {
    return nik.hashCode ^
        name.hashCode ^
        email.hashCode ^
        hp.hashCode ^
        role.hashCode ^
        password.hashCode ^
        is_active.hashCode ^
        is_vendor.hashCode;
  }
}
