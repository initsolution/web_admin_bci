// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';

part 'pointchecklistpreventive.g.dart';

@JsonSerializable()
class PointChecklistPreventive {
  int? id;
  String? uraian;
  String? kriteria;
  String? hasil;
  String? keterangan;
  int? orderIndex;
  bool? isChecklist;

  PointChecklistPreventive({
    this.id,
    this.uraian,
    this.kriteria,
    this.hasil,
    this.keterangan,
    this.orderIndex,
    this.isChecklist,
  });

  PointChecklistPreventive copyWith({
    int? id,
    String? uraian,
    String? kriteria,
    String? hasil,
    String? keterangan,
    int? orderIndex,
    bool? isChecklist,
  }) {
    return PointChecklistPreventive(
      id: id ?? this.id,
      uraian: uraian ?? this.uraian,
      kriteria: kriteria ?? this.kriteria,
      hasil: hasil ?? this.hasil,
      keterangan: keterangan ?? this.keterangan,
      orderIndex: orderIndex ?? this.orderIndex,
      isChecklist: isChecklist ?? this.isChecklist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uraian': uraian,
      'kriteria': kriteria,
      'hasil': hasil,
      'keterangan': keterangan,
      'orderIndex': orderIndex,
      'isChecklist': isChecklist,
    };
  }

  factory PointChecklistPreventive.fromMap(Map<String, dynamic> map) {
    return PointChecklistPreventive(
      id: map['id'] != null ? map['id'] as int : null,
      uraian: map['uraian'] != null ? map['uraian'] as String : null,
      kriteria: map['kriteria'] != null ? map['kriteria'] as String : null,
      hasil: map['hasil'] != null ? map['hasil'] as String : null,
      keterangan:
          map['keterangan'] != null ? map['keterangan'] as String : null,
      orderIndex: map['orderIndex'] != null ? map['orderIndex'] as int : null,
      isChecklist:
          map['isChecklist'] != null ? map['isChecklist'] as bool : null,
    );
  }

  factory PointChecklistPreventive.fromJson(Map<String, dynamic> json) =>
      _$PointChecklistPreventiveFromJson(json);

  Map<String, dynamic> toJson() => _$PointChecklistPreventiveToJson(this);

  @override
  String toString() {
    return 'PointChecklistPreventive(id: $id, uraian: $uraian, kriteria: $kriteria, hasil: $hasil, keterangan: $keterangan, orderIndex: $orderIndex, isChecklist: $isChecklist)';
  }

  @override
  bool operator ==(covariant PointChecklistPreventive other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uraian == uraian &&
        other.kriteria == kriteria &&
        other.hasil == hasil &&
        other.keterangan == keterangan &&
        other.orderIndex == orderIndex &&
        other.isChecklist == isChecklist;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uraian.hashCode ^
        kriteria.hashCode ^
        hasil.hashCode ^
        keterangan.hashCode ^
        orderIndex.hashCode ^
        isChecklist.hashCode;
  }
}
