import 'package:equatable/equatable.dart';

/// Language entity
class Language extends Equatable {
  final String code;
  final String name;
  final String? native;
  final bool? rtl;

  const Language({
    required this.code,
    required this.name,
    this.native,
    this.rtl,
  });

  @override
  List<Object?> get props => [code, name, native, rtl];
}
