// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/model/site.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  int? id;
  String? createdDate;
  String? submitedDate;
  String? verifiedDate;
  String? status;
  String? type;
  String? towerCategory;
  Employee? makerEmployee;
  Employee? verifierEmployee;
  Site? site;
  Task({
    this.id,
    this.createdDate,
    this.submitedDate,
    this.verifiedDate,
    this.status,
    this.type,
    this.towerCategory,
    this.makerEmployee,
    this.verifierEmployee,
    this.site,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    int? id,
    String? createdDate,
    String? submitedDate,
    String? verifiedDate,
    String? status,
    String? type,
    String? towerCategory,
    Employee? makerEmployee,
    Employee? verifierEmployee,
    Site? site,
  }) {
    return Task(
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      submitedDate: submitedDate ?? this.submitedDate,
      verifiedDate: verifiedDate ?? this.verifiedDate,
      status: status ?? this.status,
      type: type ?? this.type,
      towerCategory: towerCategory ?? this.towerCategory,
      makerEmployee: makerEmployee ?? this.makerEmployee,
      verifierEmployee: verifierEmployee ?? this.verifierEmployee,
      site: site ?? this.site,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdDate': createdDate,
      'submitedDate': submitedDate,
      'verifiedDate': verifiedDate,
      'status': status,
      'type': type,
      'towerCategory': towerCategory,
      'makerEmployee': makerEmployee?.toMap(),
      'verifierEmployee': verifierEmployee?.toMap(),
      'site': site?.toMap(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] != null ? map['id'] as int : 0,
      createdDate:
          map['createdDate'] != null ? map['createdDate'] as String : null,
      submitedDate:
          map['submitedDate'] != null ? map['submitedDate'] as String : null,
      verifiedDate:
          map['verifiedDate'] != null ? map['verifiedDate'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      towerCategory:
          map['towerCategory'] != null ? map['towerCategory'] as String : null,
      makerEmployee: map['makerEmployee'] != null
          ? Employee.fromMap(map['makerEmployee'] as Map<String, dynamic>)
          : null,
      verifierEmployee: map['verifierEmployee'] != null
          ? Employee.fromMap(map['verifierEmployee'] as Map<String, dynamic>)
          : null,
      site: map['site'] != null
          ? Site.fromMap(map['site'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, createdDate: $createdDate, submitedDate: $submitedDate, verifiedDate: $verifiedDate, status: $status, type: $type, towerCategory: $towerCategory, makerEmployee: $makerEmployee, verifierEmployee: $verifierEmployee, site: $site)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdDate == createdDate &&
        other.submitedDate == submitedDate &&
        other.verifiedDate == verifiedDate &&
        other.status == status &&
        other.type == type &&
        other.towerCategory == towerCategory &&
        other.makerEmployee == makerEmployee &&
        other.verifierEmployee == verifierEmployee &&
        other.site == site;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdDate.hashCode ^
        submitedDate.hashCode ^
        verifiedDate.hashCode ^
        status.hashCode ^
        type.hashCode ^
        towerCategory.hashCode ^
        makerEmployee.hashCode ^
        verifierEmployee.hashCode ^
        site.hashCode;
  }
}
