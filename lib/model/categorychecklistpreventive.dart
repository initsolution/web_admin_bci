// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_web_ptb/model/pointchecklistpreventive.dart';

part 'categorychecklistpreventive.g.dart';

@JsonSerializable()
class CategoryChecklistPreventive {
  int? id;
  String? nama;
  String? keterangan;
  int? orderIndex;
  List<PointChecklistPreventive>? pointChecklistPreventive;
  CategoryChecklistPreventive({
    this.id,
    this.nama,
    this.keterangan,
    this.orderIndex,
    this.pointChecklistPreventive,
  });

  CategoryChecklistPreventive copyWith({
    int? id,
    String? nama,
    String? keterangan,
    int? orderIndex,
    List<PointChecklistPreventive>? pointChecklistPreventive,
  }) {
    return CategoryChecklistPreventive(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      keterangan: keterangan ?? this.keterangan,
      orderIndex: orderIndex ?? this.orderIndex,
      pointChecklistPreventive:
          pointChecklistPreventive ?? this.pointChecklistPreventive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'keterangan': keterangan,
      'orderIndex': orderIndex,
      'pointChecklistPreventive':
          pointChecklistPreventive?.map((x) => x?.toMap()).toList(),
    };
  }

  factory CategoryChecklistPreventive.fromMap(Map<String, dynamic> map) {
    return CategoryChecklistPreventive(
      id: map['id'] != null ? map['id'] as int : null,
      nama: map['nama'] != null ? map['nama'] as String : null,
      keterangan:
          map['keterangan'] != null ? map['keterangan'] as String : null,
      orderIndex: map['orderIndex'] != null ? map['orderIndex'] as int : null,
      pointChecklistPreventive: map['pointChecklistPreventive'] != null
          ? List<PointChecklistPreventive>.from(
              (map['pointChecklistPreventive'] as List<int>)
                  .map<PointChecklistPreventive?>(
                (x) =>
                    PointChecklistPreventive.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory CategoryChecklistPreventive.fromJson(Map<String, dynamic> json) =>
      _$CategoryChecklistPreventiveFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryChecklistPreventiveToJson(this);

  @override
  String toString() {
    return 'CategoryChecklistPreventive(id: $id, nama: $nama, keterangan: $keterangan, orderIndex: $orderIndex, pointChecklistPreventive: $pointChecklistPreventive)';
  }

  @override
  bool operator ==(covariant CategoryChecklistPreventive other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nama == nama &&
        other.keterangan == keterangan &&
        other.orderIndex == orderIndex &&
        listEquals(other.pointChecklistPreventive, pointChecklistPreventive);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama.hashCode ^
        keterangan.hashCode ^
        orderIndex.hashCode ^
        pointChecklistPreventive.hashCode;
  }
}
