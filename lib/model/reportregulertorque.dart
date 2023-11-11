// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'reportregulertorque.g.dart';

@JsonSerializable()
class ReportRegulerTorque {
  int? id;
  String? towerSegment;
  int? elevasi;
  String? boltSize;
  int? minimumTorque;
  int? qtyBolt;
  String? remark;
  int? orderIndex;
  ReportRegulerTorque({
    this.id,
    this.towerSegment,
    this.elevasi,
    this.boltSize,
    this.minimumTorque,
    this.qtyBolt,
    this.remark,
    this.orderIndex,
  });

  ReportRegulerTorque copyWith({
    int? id,
    String? towerSegment,
    int? elevasi,
    String? boltSize,
    int? minimumTorque,
    int? qtyBolt,
    String? remark,
    int? orderIndex,
  }) {
    return ReportRegulerTorque(
      id: id ?? this.id,
      towerSegment: towerSegment ?? this.towerSegment,
      elevasi: elevasi ?? this.elevasi,
      boltSize: boltSize ?? this.boltSize,
      minimumTorque: minimumTorque ?? this.minimumTorque,
      qtyBolt: qtyBolt ?? this.qtyBolt,
      remark: remark ?? this.remark,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'towerSegment': towerSegment,
      'elevasi': elevasi,
      'boltSize': boltSize,
      'minimumTorque': minimumTorque,
      'qtyBolt': qtyBolt,
      'remark': remark,
      'orderIndex': orderIndex,
    };
  }

  factory ReportRegulerTorque.fromMap(Map<String, dynamic> map) {
    return ReportRegulerTorque(
      id: map['id'] != null ? map['id'] as int : null,
      towerSegment:
          map['towerSegment'] != null ? map['towerSegment'] as String : null,
      elevasi: map['elevasi'] != null ? map['elevasi'] as int : null,
      boltSize: map['boltSize'] != null ? map['boltSize'] as String : null,
      minimumTorque:
          map['minimumTorque'] != null ? map['minimumTorque'] as int : null,
      qtyBolt: map['qtyBolt'] != null ? map['qtyBolt'] as int : null,
      remark: map['remark'] != null ? map['remark'] as String : null,
      orderIndex: map['orderIndex'] != null ? map['orderIndex'] as int : null,
    );
  }

  factory ReportRegulerTorque.fromJson(Map<String, dynamic> json) =>
      _$ReportRegulerTorqueFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRegulerTorqueToJson(this);

  @override
  String toString() {
    return 'ReportRegulerTorque(id: $id, towerSegment: $towerSegment, elevasi: $elevasi, boltSize: $boltSize, minimumTorque: $minimumTorque, qtyBolt: $qtyBolt, remark: $remark, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(covariant ReportRegulerTorque other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.towerSegment == towerSegment &&
        other.elevasi == elevasi &&
        other.boltSize == boltSize &&
        other.minimumTorque == minimumTorque &&
        other.qtyBolt == qtyBolt &&
        other.remark == remark &&
        other.orderIndex == orderIndex;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        towerSegment.hashCode ^
        elevasi.hashCode ^
        boltSize.hashCode ^
        minimumTorque.hashCode ^
        qtyBolt.hashCode ^
        remark.hashCode ^
        orderIndex.hashCode;
  }
}
