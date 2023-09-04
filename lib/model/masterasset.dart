// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'masterasset.g.dart';

@JsonSerializable()
class MasterAsset {
  int? id;
  String? taskType;
  String? section;
  String? fabricator;
  int? towerHeight;
  String? category;
  String? description;
  MasterAsset({
    this.id,
    this.taskType,
    this.section,
    this.fabricator,
    this.towerHeight,
    this.category,
    this.description,
  });

  factory MasterAsset.fromJson(Map<String, dynamic> json) =>
      _$MasterAssetFromJson(json);

  Map<String, dynamic> toJson() => _$MasterAssetToJson(this);

  MasterAsset copyWith({
    int? id,
    String? taskType,
    String? section,
    String? fabricator,
    int? towerHeight,
    String? category,
    String? description,
  }) {
    return MasterAsset(
      id: id ?? this.id,
      taskType: taskType ?? this.taskType,
      section: section ?? this.section,
      fabricator: fabricator ?? this.fabricator,
      towerHeight: towerHeight ?? this.towerHeight,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'taskType': taskType,
      'section': section,
      'fabricator': fabricator,
      'towerHeight': towerHeight,
      'category': category,
      'description': description,
    };
  }

  factory MasterAsset.fromMap(Map<String, dynamic> map) {
    return MasterAsset(
      id: map['id'] != null ? map['id'] as int : null,
      taskType: map['taskType'] != null ? map['taskType'] as String : null,
      section: map['section'] != null ? map['section'] as String : null,
      fabricator: map['fabricator'] != null ? map['fabricator'] as String : null,
      towerHeight: map['towerHeight'] != null ? map['towerHeight'] as int : null,
      category: map['category'] != null ? map['category'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
    );
  }

  @override
  String toString() {
    return 'MasterAsset(id: $id, taskType: $taskType, section: $section, fabricator: $fabricator, towerHeight: $towerHeight, category: $category, description: $description)';
  }

  @override
  bool operator ==(covariant MasterAsset other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.taskType == taskType &&
      other.section == section &&
      other.fabricator == fabricator &&
      other.towerHeight == towerHeight &&
      other.category == category &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      taskType.hashCode ^
      section.hashCode ^
      fabricator.hashCode ^
      towerHeight.hashCode ^
      category.hashCode ^
      description.hashCode;
  }
}
