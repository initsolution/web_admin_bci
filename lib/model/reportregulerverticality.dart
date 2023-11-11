// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_web_ptb/model/valueverticality.dart';
part 'reportregulerverticality.g.dart';

@JsonSerializable()
class ReportRegulerVerticality {
  int? id;
  int? horizontalityAb;
  int? horizontalityBc;
  int? horizontalityCd;
  int? horizontalityDa;
  String? theodolite1;
  String? theodolite2;
  String? alatUkur;
  int? toleransiKetegakan;
  List<ValueVerticality>? valueVerticality;
  ReportRegulerVerticality({
    this.id,
    this.horizontalityAb,
    this.horizontalityBc,
    this.horizontalityCd,
    this.horizontalityDa,
    this.theodolite1,
    this.theodolite2,
    this.alatUkur,
    this.toleransiKetegakan,
    this.valueVerticality,
  });

  ReportRegulerVerticality copyWith({
    int? id,
    int? horizontalityAb,
    int? horizontalityBc,
    int? horizontalityCd,
    int? horizontalityDa,
    String? theodolite1,
    String? theodolite2,
    String? alatUkur,
    int? toleransiKetegakan,
    List<ValueVerticality>? valueVerticality,
  }) {
    return ReportRegulerVerticality(
      id: id ?? this.id,
      horizontalityAb: horizontalityAb ?? this.horizontalityAb,
      horizontalityBc: horizontalityBc ?? this.horizontalityBc,
      horizontalityCd: horizontalityCd ?? this.horizontalityCd,
      horizontalityDa: horizontalityDa ?? this.horizontalityDa,
      theodolite1: theodolite1 ?? this.theodolite1,
      theodolite2: theodolite2 ?? this.theodolite2,
      alatUkur: alatUkur ?? this.alatUkur,
      toleransiKetegakan: toleransiKetegakan ?? this.toleransiKetegakan,
      valueVerticality: valueVerticality ?? this.valueVerticality,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'horizontalityAb': horizontalityAb,
      'horizontalityBc': horizontalityBc,
      'horizontalityCd': horizontalityCd,
      'horizontalityDa': horizontalityDa,
      'theodolite1': theodolite1,
      'theodolite2': theodolite2,
      'alatUkur': alatUkur,
      'toleransiKetegakan': toleransiKetegakan,
      'valueVerticality': valueVerticality?.map((x) => x?.toMap()).toList(),
    };
  }

  factory ReportRegulerVerticality.fromMap(Map<String, dynamic> map) {
    return ReportRegulerVerticality(
      id: map['id'] != null ? map['id'] as int : null,
      horizontalityAb:
          map['horizontalityAb'] != null ? map['horizontalityAb'] as int : null,
      horizontalityBc:
          map['horizontalityBc'] != null ? map['horizontalityBc'] as int : null,
      horizontalityCd:
          map['horizontalityCd'] != null ? map['horizontalityCd'] as int : null,
      horizontalityDa:
          map['horizontalityDa'] != null ? map['horizontalityDa'] as int : null,
      theodolite1:
          map['theodolite1'] != null ? map['theodolite1'] as String : null,
      theodolite2:
          map['theodolite2'] != null ? map['theodolite2'] as String : null,
      alatUkur: map['alatUkur'] != null ? map['alatUkur'] as String : null,
      toleransiKetegakan: map['toleransiKetegakan'] != null
          ? map['toleransiKetegakan'] as int
          : null,
      valueVerticality: map['valueVerticality'] != null
          ? List<ValueVerticality>.from(
              (map['valueVerticality'] as List<int>).map<ValueVerticality?>(
                (x) => ValueVerticality.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory ReportRegulerVerticality.fromJson(Map<String, dynamic> json) =>
      _$ReportRegulerVerticalityFromJson(json);

  Map<String, dynamic> toJson() => _$ReportRegulerVerticalityToJson(this);

  @override
  String toString() {
    return 'ReportRegulerVerticality(id: $id, horizontalityAb: $horizontalityAb, horizontalityBc: $horizontalityBc, horizontalityCd: $horizontalityCd, horizontalityDa: $horizontalityDa, theodolite1: $theodolite1, theodolite2: $theodolite2, alatUkur: $alatUkur, toleransiKetegakan: $toleransiKetegakan, valueVerticality: $valueVerticality)';
  }

  @override
  bool operator ==(covariant ReportRegulerVerticality other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.horizontalityAb == horizontalityAb &&
        other.horizontalityBc == horizontalityBc &&
        other.horizontalityCd == horizontalityCd &&
        other.horizontalityDa == horizontalityDa &&
        other.theodolite1 == theodolite1 &&
        other.theodolite2 == theodolite2 &&
        other.alatUkur == alatUkur &&
        other.toleransiKetegakan == toleransiKetegakan &&
        listEquals(other.valueVerticality, valueVerticality);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        horizontalityAb.hashCode ^
        horizontalityBc.hashCode ^
        horizontalityCd.hashCode ^
        horizontalityDa.hashCode ^
        theodolite1.hashCode ^
        theodolite2.hashCode ^
        alatUkur.hashCode ^
        toleransiKetegakan.hashCode ^
        valueVerticality.hashCode;
  }
}
