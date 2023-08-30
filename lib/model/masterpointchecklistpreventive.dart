// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'mastercategorychecklistpreventive.dart';

part 'masterpointchecklistpreventive.g.dart';

@JsonSerializable()
class MasterPointChecklistPreventive {
  int? id;
  String? uraian;
  String? kriteria;
  MasterCategoryChecklistPreventive? mcategorychecklistpreventive;
  MasterPointChecklistPreventive(
      {this.uraian, this.kriteria, this.mcategorychecklistpreventive});

  @override
  String toString() {
    return 'MasterPointChecklistPreventive(id: $id, uraian: $uraian, kriteria: $kriteria, mcategorychecklistpreventive: $mcategorychecklistpreventive)';
  }

  factory MasterPointChecklistPreventive.fromJson(Map<String, dynamic> json) =>
      _$MasterPointChecklistPreventiveFromJson(json);

  Map<String, dynamic> toJson() => _$MasterPointChecklistPreventiveToJson(this);
}
