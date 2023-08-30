import 'package:json_annotation/json_annotation.dart';

part 'mastercategorychecklistpreventive.g.dart';

@JsonSerializable()
class MasterCategoryChecklistPreventive {
  int? id;
  String? name;
  MasterCategoryChecklistPreventive({
    this.id,
    this.name,
  });

  @override
  String toString() {
    return 'MasterCategoryChecklistPreventive(id: $id, name: $name)';
  }

  factory MasterCategoryChecklistPreventive.fromJson(
          Map<String, dynamic> json) =>
      _$MasterCategoryChecklistPreventiveFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MasterCategoryChecklistPreventiveToJson(this);
}
