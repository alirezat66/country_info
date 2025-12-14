import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String code;
  final String name;
  final String emoji;

  const Country({required this.code, required this.name, required this.emoji});

  @override
  List<Object?> get props => [code, name, emoji];
}
