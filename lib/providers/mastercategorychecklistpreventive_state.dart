import 'package:equatable/equatable.dart';
import 'package:flutter_web_ptb/model/mastercategorychecklistpreventive.dart';
abstract class MasterCategoryChecklistPreventiveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MasterCategoryChecklistPreventiveInitial extends MasterCategoryChecklistPreventiveState {}

class MasterCategoryChecklistPreventiveLoading extends MasterCategoryChecklistPreventiveState {}

class MasterCategoryChecklistPreventiveLoaded extends MasterCategoryChecklistPreventiveState {
  final List<MasterCategoryChecklistPreventive> masterCategoryPrev;
  MasterCategoryChecklistPreventiveLoaded({required this.masterCategoryPrev});

  @override
  List<Object?> get props => [masterCategoryPrev];
}

class MasterCategoryChecklistPreventiveLoadedEmpty extends MasterCategoryChecklistPreventiveState {}

// ignore: must_be_immutable
class MasterCategoryChecklistPreventiveErrorServer extends MasterCategoryChecklistPreventiveState {
  String? message;
  int? statusCode;
  MasterCategoryChecklistPreventiveErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class MasterCategoryChecklistPreventiveDataChangeSuccess extends MasterCategoryChecklistPreventiveState {}

