// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CountryModel _$CountryModelFromJson(Map<String, dynamic> json) =>
    _CountryModel(
      code: json['code'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      capital: json['capital'] as String?,
      currency: json['currency'] as String?,
      phone: json['phone'] as String?,
      continent: json['continent'] == null
          ? null
          : ContinentModel.fromJson(json['continent'] as Map<String, dynamic>),
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CountryModelToJson(_CountryModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'emoji': instance.emoji,
      'capital': instance.capital,
      'currency': instance.currency,
      'phone': instance.phone,
      'continent': instance.continent,
      'languages': instance.languages,
    };
