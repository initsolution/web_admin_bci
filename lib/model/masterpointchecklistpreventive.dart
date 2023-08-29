// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'mastercategorychecklistpreventive.dart';

part 'masterpointchecklistpreventive.g.dart';

@JsonSerializable()
class MasterPointChecklistPreventive {
  String? uraian;
  String? kriteria;
  MasterCategoryChecklistPreventive? mCategory;
  MasterPointChecklistPreventive({
    this.uraian,
    this.kriteria,
    this.mCategory
  });

  factory MasterPointChecklistPreventive.fromJson(Map<String, dynamic> json) => _$MasterPointChecklistPreventiveFromJson(json);

  Map<String, dynamic> toJson() => _$MasterPointChecklistPreventiveToJson(this);
}