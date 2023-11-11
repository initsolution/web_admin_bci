// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
part 'valueverticality.g.dart';

@JsonSerializable()
class ValueVerticality {
  int? id;
  int? theodoliteIndex;
  int? section;
  String? miringKe;
  int? value;
  ValueVerticality({
    this.id,
    this.theodoliteIndex,
    this.section,
    this.miringKe,
    this.value,
  });

  ValueVerticality copyWith({
    int? id,
    int? theodoliteIndex,
    int? section,
    String? miringKe,
    int? value,
  }) {
    return ValueVerticality(
      id: id ?? this.id,
      theodoliteIndex: theodoliteIndex ?? this.theodoliteIndex,
      section: section ?? this.section,
      miringKe: miringKe ?? this.miringKe,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'theodoliteIndex': theodoliteIndex,
      'section': section,
      'miringKe': miringKe,
      'value': value,
    };
  }

  factory ValueVerticality.fromMap(Map<String, dynamic> map) {
    return ValueVerticality(
      id: map['id'] != null ? map['id'] as int : null,
      theodoliteIndex:
          map['theodoliteIndex'] != null ? map['theodoliteIndex'] as int : null,
      section: map['section'] != null ? map['section'] as int : null,
      miringKe: map['miringKe'] != null ? map['miringKe'] as String : null,
      value: map['value'] != null ? map['value'] as int : null,
    );
  }

  factory ValueVerticality.fromJson(Map<String, dynamic> json) =>
      _$ValueVerticalityFromJson(json);

  Map<String, dynamic> toJson() => _$ValueVerticalityToJson(this);
  @override
  String toString() {
    return 'ValueVerticality(id: $id, theodoliteIndex: $theodoliteIndex, section: $section, miringKe: $miringKe, value: $value)';
  }

  @override
  bool operator ==(covariant ValueVerticality other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.theodoliteIndex == theodoliteIndex &&
        other.section == section &&
        other.miringKe == miringKe &&
        other.value == value;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        theodoliteIndex.hashCode ^
        section.hashCode ^
        miringKe.hashCode ^
        value.hashCode;
  }
}
