import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/country.dart';

part 'country_model.freezed.dart';
part 'country_model.g.dart';

/// Country model
@freezed
abstract class CountryModel with _$CountryModel {
  const CountryModel._();

  const factory CountryModel({
    required String code,
    required String name,
    required String emoji,
  }) = _CountryModel;

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Country toEntity() {
    return Country(code: code, name: name, emoji: emoji);
  }
}
