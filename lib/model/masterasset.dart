import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'masterasset.g.dart';

@JsonSerializable()
class MasterAsset {
  String? tower_category;
  String? category;
  String? description;
  MasterAsset({
    this.tower_category,
    this.category,
    this.description
  });

  factory MasterAsset.fromJson(Map<String, dynamic> json) => _$MasterAssetFromJson(json);

  Map<String, dynamic> toJson() => _$MasterAssetToJson(this);
}
