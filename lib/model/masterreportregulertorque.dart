// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'masterreportregulertorque.g.dart';

@JsonSerializable()
class MasterReportRegulerTorque {
  int? id;
  String? fabricator;
  int? towerHeight;
  String? towerSegment;
  int? elevasi;
  String? boltSize;
  int? minimumTorque;
  int? qtyBolt;
  MasterReportRegulerTorque({
    this.id,
    this.fabricator,
    this.towerHeight,
    this.towerSegment,
    this.elevasi,
    this.boltSize,
    this.minimumTorque,
    this.qtyBolt,
  });

  factory MasterReportRegulerTorque.fromJson(Map<String, dynamic> json) =>
      _$MasterReportRegulerTorqueFromJson(json);

  Map<String, dynamic> toJson() => _$MasterReportRegulerTorqueToJson(this);

  MasterReportRegulerTorque copyWith({
    int? id,
    String? fabricator,
    int? towerHeight,
    String? towerSegment,
    int? elevasi,
    String? boltSize,
    int? minimumTorque,
    int? qtyBolt,
  }) {
    return MasterReportRegulerTorque(
      id: id ?? this.id,
      fabricator: fabricator ?? this.fabricator,
      towerHeight: towerHeight ?? this.towerHeight,
      towerSegment: towerSegment ?? this.towerSegment,
      elevasi: elevasi ?? this.elevasi,
      boltSize: boltSize ?? this.boltSize,
      minimumTorque: minimumTorque ?? this.minimumTorque,
      qtyBolt: qtyBolt ?? this.qtyBolt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fabricator': fabricator,
      'towerHeight': towerHeight,
      'towerSegment': towerSegment,
      'elevasi': elevasi,
      'boltSize': boltSize,
      'minimumTorque': minimumTorque,
      'qtyBolt': qtyBolt,
    };
  }

  factory MasterReportRegulerTorque.fromMap(Map<String, dynamic> map) {
    return MasterReportRegulerTorque(
      id: map['id'] != null ? map['id'] as int : null,
      fabricator: map['fabricator'] != null ? map['fabricator'] as String : null,
      towerHeight: map['towerHeight'] != null ? map['towerHeight'] as int : null,
      towerSegment: map['towerSegment'] != null ? map['towerSegment'] as String : null,
      elevasi: map['elevasi'] != null ? map['elevasi'] as int : null,
      boltSize: map['boltSize'] != null ? map['boltSize'] as String : null,
      minimumTorque: map['minimumTorque'] != null ? map['minimumTorque'] as int : null,
      qtyBolt: map['qtyBolt'] != null ? map['qtyBolt'] as int : null,
    );
  }
  
  @override
  String toString() {
    return 'MasterReportRegulerTorque(id: $id, fabricator: $fabricator, towerHeight: $towerHeight, towerSegment: $towerSegment, elevasi: $elevasi, boltSize: $boltSize, minimumTorque: $minimumTorque, qtyBolt: $qtyBolt)';
  }

  @override
  bool operator ==(covariant MasterReportRegulerTorque other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.fabricator == fabricator &&
      other.towerHeight == towerHeight &&
      other.towerSegment == towerSegment &&
      other.elevasi == elevasi &&
      other.boltSize == boltSize &&
      other.minimumTorque == minimumTorque &&
      other.qtyBolt == qtyBolt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      fabricator.hashCode ^
      towerHeight.hashCode ^
      towerSegment.hashCode ^
      elevasi.hashCode ^
      boltSize.hashCode ^
      minimumTorque.hashCode ^
      qtyBolt.hashCode;
  }
}
