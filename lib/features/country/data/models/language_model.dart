import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/language.dart';

part 'language_model.freezed.dart';
part 'language_model.g.dart';

/// Language model
@freezed
abstract class LanguageModel with _$LanguageModel {
  const LanguageModel._();

  const factory LanguageModel({
    required String code,
    required String name,
    String? native,
    bool? rtl,
  }) = _LanguageModel;

  factory LanguageModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageModelFromJson(json);
  Language toEntity() {
    return Language(code: code, name: name, native: native, rtl: rtl);
  }
}
