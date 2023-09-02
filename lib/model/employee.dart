// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  bool? isActive;
  bool? isVendor;
  String? urlEsign;
  String? instansi;
  Employee({
    this.nik,
    this.name,
    this.email,
    this.hp,
    this.role,
    this.password,
    this.isActive,
    this.isVendor,
    this.urlEsign,
    this.instansi,
  });

  Employee copyWith({
    String? nik,
    String? name,
    String? email,
    String? hp,
    String? role,
    String? password,
    bool? isActive,
    bool? isVendor,
    String? urlEsign,
    String? instansi,
  }) {
    return Employee(
      nik: nik ?? this.nik,
      name: name ?? this.name,
      email: email ?? this.email,
      hp: hp ?? this.hp,
      role: role ?? this.role,
      password: password ?? this.password,
      isActive: isActive ?? this.isActive,
      isVendor: isVendor ?? this.isVendor,
      urlEsign: urlEsign ?? this.urlEsign,
      instansi: instansi ?? this.instansi,
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
      'isActive': isActive,
      'isVendor': isVendor,
      'urlEsign': urlEsign,
      'instansi': instansi,
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
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      isVendor: map['isVendor'] != null ? map['isVendor'] as bool : null,
      urlEsign: map['urlEsign'] != null ? map['urlEsign'] as String : null,
      instansi: map['instansi'] != null ? map['instansi'] as String : null,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory Employee.fromJson(String source) => Employee.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  @override
  String toString() {
    return 'Employee(nik: $nik, name: $name, email: $email, hp: $hp, role: $role, password: $password, isActive: $isActive, isVendor: $isVendor, urlEsign: $urlEsign, instansi: $instansi)';
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
        other.isActive == isActive &&
        other.isVendor == isVendor &&
        other.urlEsign == urlEsign &&
        other.instansi == instansi;
  }

  @override
  int get hashCode {
    return nik.hashCode ^
        name.hashCode ^
        email.hashCode ^
        hp.hashCode ^
        role.hashCode ^
        password.hashCode ^
        isActive.hashCode ^
        isVendor.hashCode ^
        urlEsign.hashCode ^
        instansi.hashCode;
  }
}
