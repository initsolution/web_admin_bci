// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_web_ptb/model/categorychecklistpreventive.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/model/reportregulertorque.dart';
import 'package:flutter_web_ptb/model/reportregulerverticality.dart';
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
  List<CategoryChecklistPreventive>? categorychecklistprev;
  List<ReportRegulerTorque>? reportRegulerTorque;
  ReportRegulerVerticality? reportRegulerVerticality;
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
    this.categorychecklistprev,
    this.reportRegulerTorque,
    this.reportRegulerVerticality,
  });

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
    List<CategoryChecklistPreventive>? categorychecklistprev,
    List<ReportRegulerTorque>? reportRegulerTorque,
    ReportRegulerVerticality? reportRegulerVerticality,
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
      categorychecklistprev:
          categorychecklistprev ?? this.categorychecklistprev,
      reportRegulerTorque: reportRegulerTorque ?? this.reportRegulerTorque,
      reportRegulerVerticality:
          reportRegulerVerticality ?? this.reportRegulerVerticality,
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
      'categorychecklistprev':
          categorychecklistprev?.map((x) => x.toMap()).toList(),
      'reportRegulerTorque':
          reportRegulerTorque?.map((x) => x.toMap()).toList(),
      'reportRegulerVerticality': reportRegulerVerticality?.toMap(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] != null ? map['id'] as int : null,
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
      categorychecklistprev: map['categorychecklistprev'] != null
          ? List<CategoryChecklistPreventive>.from(
              (map['categorychecklistprev'] as List<int>)
                  .map<CategoryChecklistPreventive?>(
                (x) => CategoryChecklistPreventive.fromMap(
                    x as Map<String, dynamic>),
              ),
            )
          : null,
      reportRegulerTorque: map['reportRegulerTorque'] != null
          ? List<ReportRegulerTorque>.from(
              (map['reportRegulerTorque'] as List<int>)
                  .map<ReportRegulerTorque?>(
                (x) => ReportRegulerTorque.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      reportRegulerVerticality: map['reportRegulerVerticality'] != null
          ? ReportRegulerVerticality.fromMap(
              map['reportRegulerVerticality'] as Map<String, dynamic>)
          : null,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
  @override
  String toString() {
    return 'Task(id: $id, createdDate: $createdDate, submitedDate: $submitedDate, verifiedDate: $verifiedDate, status: $status, type: $type, towerCategory: $towerCategory, makerEmployee: $makerEmployee, verifierEmployee: $verifierEmployee, site: $site, categorychecklistprev: $categorychecklistprev, reportRegulerTorque: $reportRegulerTorque, reportRegulerVerticality: $reportRegulerVerticality)';
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
        other.site == site &&
        listEquals(other.categorychecklistprev, categorychecklistprev) &&
        listEquals(other.reportRegulerTorque, reportRegulerTorque) &&
        other.reportRegulerVerticality == reportRegulerVerticality;
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
        site.hashCode ^
        categorychecklistprev.hashCode ^
        reportRegulerTorque.hashCode ^
        reportRegulerVerticality.hashCode;
  }
}
