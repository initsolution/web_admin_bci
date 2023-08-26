import 'package:equatable/equatable.dart';
import 'package:flutter_web_ptb/model/tenant.dart';

abstract class TenantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TenantInitial extends TenantState {}

class TenantLoading extends TenantState {}

class TenantLoaded extends TenantState {
  final List<Tenant> tenants;
  TenantLoaded({required this.tenants});

  @override
  List<Object?> get props => [tenants];
}

class TenantLoadedEmpty extends TenantState {}

// ignore: must_be_immutable
class TenantErrorServer extends TenantState {
  String? message;
  int? statusCode;
  TenantErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class TenantDataChangeSuccess extends TenantState {}

