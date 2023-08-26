import 'package:equatable/equatable.dart';
import 'package:flutter_web_ptb/model/masterasset.dart';

abstract class MasterAssetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MasterAssetInitial extends MasterAssetState {}

class MasterAssetLoading extends MasterAssetState {}

class MasterAssetLoaded extends MasterAssetState {
  final List<MasterAsset> masterAssets;
  MasterAssetLoaded({required this.masterAssets});

  @override
  List<Object?> get props => [masterAssets];
}

class MasterAssetLoadedEmpty extends MasterAssetState {}

// ignore: must_be_immutable
class MasterAssetErrorServer extends MasterAssetState {
  String? message;
  int? statusCode;
  MasterAssetErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class MasterAssetDataChangeSuccess extends MasterAssetState {}

