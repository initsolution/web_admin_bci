// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'userdata.g.dart';


@JsonSerializable()
class UserData {
  String username;
  String token;
  UserData(this.username, this.token);
}