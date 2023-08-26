import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'mastercategorychecklistpreventive.g.dart';

@JsonSerializable()
class MasterCategoryChecklistPreventive {
  String? name;
  MasterCategoryChecklistPreventive({
    this.name,
  });

  factory MasterCategoryChecklistPreventive.fromJson(Map<String, dynamic> json) => _$MasterCategoryChecklistPreventiveFromJson(json);

  Map<String, dynamic> toJson() => _$MasterCategoryChecklistPreventiveToJson(this);
}
