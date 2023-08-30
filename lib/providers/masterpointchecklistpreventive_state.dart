import 'package:equatable/equatable.dart';
import 'package:flutter_web_ptb/model/masterpointchecklistpreventive.dart';

abstract class MasterPointChecklistPreventiveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MasterPointChecklistPreventiveInitial
    extends MasterPointChecklistPreventiveState {}

class MasterPointChecklistPreventiveLoading
    extends MasterPointChecklistPreventiveState {}

class MasterPointChecklistPreventiveLoaded
    extends MasterPointChecklistPreventiveState {
  final List<MasterPointChecklistPreventive> masterPointChecklistPreventive;
  MasterPointChecklistPreventiveLoaded(
      {required this.masterPointChecklistPreventive});

  @override
  List<Object?> get props => [masterPointChecklistPreventive];
}

class MasterPointChecklistPreventiveLoadedEmpty
    extends MasterPointChecklistPreventiveState {}

// ignore: must_be_immutable
class MasterPointChecklistPreventiveErrorServer
    extends MasterPointChecklistPreventiveState {
  String? message;
  int? statusCode;
  MasterPointChecklistPreventiveErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class MasterPointChecklistPreventiveDataChangeSuccess
    extends MasterPointChecklistPreventiveState {}
