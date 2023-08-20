import 'package:equatable/equatable.dart';
import 'package:flutter_web_ptb/model/site.dart';

abstract class SiteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SiteInitial extends SiteState {}

class SiteLoading extends SiteState {}

class SiteLoaded extends SiteState {
  final List<Site> sites;
  SiteLoaded({required this.sites});

  @override
  List<Object?> get props => [sites];
}

class SiteLoadedEmpty extends SiteState {}

// ignore: must_be_immutable
class SiteErrorServer extends SiteState {
  String? message;
  int? statusCode;
  SiteErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class SiteDataChangeSuccess extends SiteState {}

