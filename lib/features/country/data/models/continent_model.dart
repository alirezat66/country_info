import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/continent.dart';

part 'continent_model.freezed.dart';
part 'continent_model.g.dart';

/// Continent model
@freezed
abstract class ContinentModel with _$ContinentModel {
  const ContinentModel._();

  const factory ContinentModel({required String code, required String name}) =
      _ContinentModel;

  factory ContinentModel.fromJson(Map<String, dynamic> json) =>
      _$ContinentModelFromJson(json);

  Continent toEntity() {
    return Continent(code: code, name: name);
  }
}
