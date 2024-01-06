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
  String? dueDate;
  String? submitedDate;
  String? verifiedDate;
  String? notBefore;
  String? status;
  String? type;
  String? towerCategory;
  Employee? makerEmployee;
  Employee? verifierEmployee;
  Site? site;
  String? created_at;
  List<CategoryChecklistPreventive>? categorychecklistprev;
  List<ReportRegulerTorque>? reportRegulerTorque;
  ReportRegulerVerticality? reportRegulerVerticality;
  String? note;
  Task({
    this.id,
    this.dueDate,
    this.submitedDate,
    this.verifiedDate,
    this.notBefore,
    this.status,
    this.type,
    this.towerCategory,
    this.makerEmployee,
    this.verifierEmployee,
    this.site,
    this.created_at,
    this.categorychecklistprev,
    this.reportRegulerTorque,
    this.reportRegulerVerticality,
    this.note,
  });

  Task copyWith({
    int? id,
    String? dueDate,
    String? submitedDate,
    String? verifiedDate,
    String? notBefore,
    String? status,
    String? type,
    String? towerCategory,
    Employee? makerEmployee,
    Employee? verifierEmployee,
    Site? site,
    String? created_at,
    List<CategoryChecklistPreventive>? categorychecklistprev,
    List<ReportRegulerTorque>? reportRegulerTorque,
    ReportRegulerVerticality? reportRegulerVerticality,
    String? note,
  }) {
    return Task(
      id: id ?? this.id,
      dueDate: dueDate ?? this.dueDate,
      submitedDate: submitedDate ?? this.submitedDate,
      verifiedDate: verifiedDate ?? this.verifiedDate,
      notBefore: notBefore ?? this.notBefore,
      status: status ?? this.status,
      type: type ?? this.type,
      towerCategory: towerCategory ?? this.towerCategory,
      makerEmployee: makerEmployee ?? this.makerEmployee,
      verifierEmployee: verifierEmployee ?? this.verifierEmployee,
      site: site ?? this.site,
      created_at: created_at ?? this.created_at,
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
      'dueDate': dueDate,
      'submitedDate': submitedDate,
      'verifiedDate': verifiedDate,
      'notBefore': notBefore,
      'status': status,
      'type': type,
      'towerCategory': towerCategory,
      'makerEmployee': makerEmployee?.toMap(),
      'verifierEmployee': verifierEmployee?.toMap(),
      'site': site?.toMap(),
      'created_at': created_at,
      'categorychecklistprev':
          categorychecklistprev?.map((x) => x.toMap()).toList(),
      'reportRegulerTorque':
          reportRegulerTorque?.map((x) => x.toMap()).toList(),
      'reportRegulerVerticality': reportRegulerVerticality?.toMap(),
      'note': note,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] != null ? map['id'] as int : null,
      dueDate: map['dueDate'] != null ? map['dueDate'] as String : null,
      submitedDate:
          map['submitedDate'] != null ? map['submitedDate'] as String : null,
      verifiedDate:
          map['verifiedDate'] != null ? map['verifiedDate'] as String : null,
      notBefore: map['notBefore'] != null ? map['notBefore'] as String : null,
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
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
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
      note: map['note'] != null ? map['note'] as String : null,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  String toString() {
    return 'Task(id: $id, dueDate: $dueDate, submitedDate: $submitedDate, verifiedDate: $verifiedDate, notBefore: $notBefore, status: $status, type: $type, towerCategory: $towerCategory, makerEmployee: $makerEmployee, verifierEmployee: $verifierEmployee, site: $site, created_at: $created_at, categorychecklistprev: $categorychecklistprev, reportRegulerTorque: $reportRegulerTorque, reportRegulerVerticality: $reportRegulerVerticality, note: $note)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dueDate == dueDate &&
        other.submitedDate == submitedDate &&
        other.verifiedDate == verifiedDate &&
        other.notBefore == notBefore &&
        other.status == status &&
        other.type == type &&
        other.towerCategory == towerCategory &&
        other.makerEmployee == makerEmployee &&
        other.verifierEmployee == verifierEmployee &&
        other.site == site &&
        other.created_at == created_at &&
        listEquals(other.categorychecklistprev, categorychecklistprev) &&
        listEquals(other.reportRegulerTorque, reportRegulerTorque) &&
        other.reportRegulerVerticality == reportRegulerVerticality &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dueDate.hashCode ^
        submitedDate.hashCode ^
        verifiedDate.hashCode ^
        notBefore.hashCode ^
        status.hashCode ^
        type.hashCode ^
        towerCategory.hashCode ^
        makerEmployee.hashCode ^
        verifierEmployee.hashCode ^
        site.hashCode ^
        created_at.hashCode ^
        categorychecklistprev.hashCode ^
        reportRegulerTorque.hashCode ^
        reportRegulerVerticality.hashCode ^
        note.hashCode;
  }
}
