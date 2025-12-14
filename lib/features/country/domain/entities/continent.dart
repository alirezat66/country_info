import 'package:equatable/equatable.dart';

/// Continent entity
class Continent extends Equatable {
  final String code;
  final String name;

  const Continent({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];
}
