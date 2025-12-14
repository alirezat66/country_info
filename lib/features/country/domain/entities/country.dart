import 'package:equatable/equatable.dart';
import 'continent.dart';
import 'language.dart';

/// Country entity
class Country extends Equatable {
  final String code;
  final String name;
  final String emoji;
  final String? capital;
  final String? currency;
  final String? phone;
  final Continent? continent;
  final List<Language> languages;

  const Country({
    required this.code,
    required this.name,
    required this.emoji,
    this.capital,
    this.currency,
    this.phone,
    this.continent,
    this.languages = const [],
  });

  @override
  List<Object?> get props => [
    code,
    name,
    emoji,
    capital,
    currency,
    phone,
    continent,
    languages,
  ];
}
