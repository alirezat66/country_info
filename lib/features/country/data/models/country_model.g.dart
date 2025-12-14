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
    );

Map<String, dynamic> _$CountryModelToJson(_CountryModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'emoji': instance.emoji,
    };
