// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_web_ptb/model/task.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset {
  int? id;
  String? category;
  String? description;
  String? url;
  bool? isPassed;
  String? note;
  String? section;
  int? orderIndex;
  Task? task;
  Asset({
    this.id,
    this.category,
    this.description,
    this.url,
    this.isPassed,
    this.note,
    this.section,
    this.orderIndex,
    this.task,
  });

  Asset copyWith({
    int? id,
    String? category,
    String? description,
    String? url,
    bool? isPassed,
    String? note,
    String? section,
    int? orderIndex,
    Task? task,
  }) {
    return Asset(
      id: id ?? this.id,
      category: category ?? this.category,
      description: description ?? this.description,
      url: url ?? this.url,
      isPassed: isPassed ?? this.isPassed,
      note: note ?? this.note,
      section: section ?? this.section,
      orderIndex: orderIndex ?? this.orderIndex,
      task: task ?? this.task,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'description': description,
      'url': url,
      'isPassed': isPassed,
      'note': note,
      'section': section,
      'orderIndex': orderIndex,
      'task': task?.toMap(),
    };
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'] != null ? map['id'] as int : null,
      category: map['category'] != null ? map['category'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      isPassed: map['isPassed'] != null ? map['isPassed'] as bool : null,
      note: map['note'] != null ? map['note'] as String : null,
      section: map['section'] != null ? map['section'] as String : null,
      orderIndex: map['orderIndex'] != null ? map['orderIndex'] as int : null,
      task: map['task'] != null
          ? Task.fromMap(map['task'] as Map<String, dynamic>)
          : null,
    );
  }

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  Map<String, dynamic> toJson() => _$AssetToJson(this);

  @override
  String toString() {
    return 'Asset(id : $id, category: $category, description: $description, url: $url, isPassed: $isPassed, note: $note, section: $section, orderIndex: $orderIndex, task: $task)';
  }

  @override
  bool operator ==(covariant Asset other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.category == category &&
        other.description == description &&
        other.url == url &&
        other.isPassed == isPassed &&
        other.note == note &&
        other.section == section &&
        other.orderIndex == orderIndex &&
        other.task == task;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        category.hashCode ^
        description.hashCode ^
        url.hashCode ^
        isPassed.hashCode ^
        note.hashCode ^
        section.hashCode ^
        orderIndex.hashCode ^
        task.hashCode;
  }
}
