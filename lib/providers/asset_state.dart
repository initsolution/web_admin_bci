import 'package:equatable/equatable.dart';
import 'package:flutter_web_ptb/model/asset.dart';

abstract class AssetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssetInitial extends AssetState {}

class AssetLoading extends AssetState {}

class AssetLoaded extends AssetState {
  final List<Asset> assets;

  AssetLoaded({required this.assets});

  @override
  List<Object?> get props => [assets];
}

class AssetLoadedEmpty extends AssetState {}

// ignore: must_be_immutable
class AssetErrorServer extends AssetState {
  String? message;
  int? statusCode;

  AssetErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class AssetChangeDataSuccess extends AssetState {}

// ignore: must_be_immutable
class AssetChangeDataFailed extends AssetState {
  String? message;

  AssetChangeDataFailed({this.message});

  @override
  List<Object?> get props => [message];
}
