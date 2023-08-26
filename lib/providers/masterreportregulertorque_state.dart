import 'package:equatable/equatable.dart';
import '../model/masterreportregulertorque.dart';

abstract class MasterReportRegulerTorqueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MasterReportRegulerTorqueStateInitial extends MasterReportRegulerTorqueState {}

class MasterReportRegulerTorqueStateLoading extends MasterReportRegulerTorqueState {}

class MasterReportRegulerTorqueStateLoaded extends MasterReportRegulerTorqueState {
  final List<MasterReportRegulerTorque> masterReportRegulerTorque;
  MasterReportRegulerTorqueStateLoaded({required this.masterReportRegulerTorque});

  @override
  List<Object?> get props => [masterReportRegulerTorque];
}

class MasterReportRegulerTorqueLoadedEmpty extends MasterReportRegulerTorqueState {}

// ignore: must_be_immutable
class MasterReportRegulerTorqueErrorServer extends MasterReportRegulerTorqueState {
  String? message;
  int? statusCode;
  MasterReportRegulerTorqueErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class MasterReportRegulerTorqueDataChangeSuccess extends MasterReportRegulerTorqueState {}

