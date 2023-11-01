// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  String? region;
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
    this.region,
    this.province,
    this.address,
    this.longitude,
    this.latitude,
  });

  factory Site.fromJson(Map<String, dynamic> json) => _$SiteFromJson(json);

  Map<String, dynamic> toJson() => _$SiteToJson(this);

  Site copyWith({
    String? id,
    String? name,
    String? towerType,
    int? towerHeight,
    String? fabricator,
    String? tenants,
    String? region,
    String? province,
    String? address,
    String? longitude,
    String? latitude,
  }) {
    return Site(
      id: id ?? this.id,
      name: name ?? this.name,
      towerType: towerType ?? this.towerType,
      towerHeight: towerHeight ?? this.towerHeight,
      fabricator: fabricator ?? this.fabricator,
      tenants: tenants ?? this.tenants,
      region: region ?? this.region,
      province: province ?? this.province,
      address: address ?? this.address,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'towerType': towerType,
      'towerHeight': towerHeight,
      'fabricator': fabricator,
      'tenants': tenants,
      'region': region,
      'province': province,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory Site.fromMap(Map<String, dynamic> map) {
    return Site(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      towerType: map['towerType'] != null ? map['towerType'] as String : null,
      towerHeight:
          map['towerHeight'] != null ? map['towerHeight'] as int : null,
      fabricator:
          map['fabricator'] != null ? map['fabricator'] as String : null,
      tenants: map['tenants'] != null ? map['tenants'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      province: map['province'] != null ? map['province'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as String : null,
    );
  }

  @override
  String toString() {
    return 'Site(id: $id, name: $name, towerType: $towerType, towerHeight: $towerHeight, fabricator: $fabricator, tenants: $tenants, region: $region, province: $province, address: $address, longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(covariant Site other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.towerType == towerType &&
        other.towerHeight == towerHeight &&
        other.fabricator == fabricator &&
        other.tenants == tenants &&
        other.region == region &&
        other.province == province &&
        other.address == address &&
        other.longitude == longitude &&
        other.latitude == latitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        towerType.hashCode ^
        towerHeight.hashCode ^
        fabricator.hashCode ^
        tenants.hashCode ^
        region.hashCode ^
        province.hashCode ^
        address.hashCode ^
        longitude.hashCode ^
        latitude.hashCode;
  }

  bool isEqual(Site site) {
    return id == site.id;
  }
}
