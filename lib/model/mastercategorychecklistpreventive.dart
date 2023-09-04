// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'mastercategorychecklistpreventive.g.dart';

@JsonSerializable()
class MasterCategoryChecklistPreventive {
  int? id;
  String? categoryName;
  MasterCategoryChecklistPreventive({
    this.id,
    this.categoryName,
  });

  @override
  String toString() => 'MasterCategoryChecklistPreventive(id: $id, categoryName: $categoryName)';

  factory MasterCategoryChecklistPreventive.fromJson(
          Map<String, dynamic> json) =>
      _$MasterCategoryChecklistPreventiveFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MasterCategoryChecklistPreventiveToJson(this);

  MasterCategoryChecklistPreventive copyWith({
    int? id,
    String? categoryName,
  }) {
    return MasterCategoryChecklistPreventive(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryName': categoryName,
    };
  }

  factory MasterCategoryChecklistPreventive.fromMap(Map<String, dynamic> map) {
    return MasterCategoryChecklistPreventive(
      id: map['id'] != null ? map['id'] as int : null,
      categoryName: map['categoryName'] != null ? map['categoryName'] as String : null,
    );
  }

  @override
  bool operator ==(covariant MasterCategoryChecklistPreventive other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.categoryName == categoryName;
  }

  @override
  int get hashCode => id.hashCode ^ categoryName.hashCode;
}
