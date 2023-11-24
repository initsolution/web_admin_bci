import 'package:equatable/equatable.dart';

abstract class PdfState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PdfInitial extends PdfState {}

class PdfLoading extends PdfState {}

class PdfReady extends PdfState {}

class PdfDownloaded extends PdfState {}

class PdfErrorWithMessage extends PdfState {
  final String message;
  PdfErrorWithMessage({required this.message});

  @override
  List<Object?> get props => [message];
}
