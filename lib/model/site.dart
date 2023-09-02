import 'package:json_annotation/json_annotation.dart';

part 'site.g.dart';

@JsonSerializable()
class Site {
  String? id;
  String? name;
  String? towerType;
  int? towerHeight;
  String? fabricator;
  String? tenants;
  String? kabupaten;
  String? province;
  String? address;
  String? longitude;
  String? latitude;

  Site({
    this.id,
    this.name,
    this.towerType,
    this.towerHeight,
    this.fabricator,
    this.tenants,
    this.kabupaten,
    this.province,
    this.address,
    this.longitude,
    this.latitude,
  });

  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);

  Map<String, dynamic> toJson() => _$SiteToJson(this);
}
