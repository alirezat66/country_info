import 'package:country_info/features/country/data/models/continent_model.dart';
import 'package:country_info/features/country/domain/entities/continent.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContinentModel', () {
    test('should create ContinentModel with all properties', () {
      // arrange & act
      const model = ContinentModel(code: 'EU', name: 'Europe');

      // assert
      expect(model.code, 'EU');
      expect(model.name, 'Europe');
    });

    test('should create ContinentModel from JSON', () {
      // arrange
      final json = {'code': 'AS', 'name': 'Asia'};

      // act
      final model = ContinentModel.fromJson(json);

      // assert
      expect(model.code, 'AS');
      expect(model.name, 'Asia');
    });

    test('should convert ContinentModel to entity', () {
      // arrange
      const model = ContinentModel(code: 'NA', name: 'North America');

      // act
      final entity = model.toEntity();

      // assert
      expect(entity, isA<Continent>());
      expect(entity.code, 'NA');
      expect(entity.name, 'North America');
    });

    test('should convert to JSON', () {
      // arrange
      const model = ContinentModel(code: 'SA', name: 'South America');

      // act
      final json = model.toJson();

      // assert
      expect(json, {'code': 'SA', 'name': 'South America'});
    });

    test('should create equal models with same values', () {
      // arrange
      const model1 = ContinentModel(code: 'AF', name: 'Africa');
      const model2 = ContinentModel(code: 'AF', name: 'Africa');

      // assert
      expect(model1, model2);
      expect(model1.hashCode, model2.hashCode);
    });

    test('should create different models with different values', () {
      // arrange
      const model1 = ContinentModel(code: 'OC', name: 'Oceania');
      const model2 = ContinentModel(code: 'AN', name: 'Antarctica');

      // assert
      expect(model1, isNot(model2));
    });

    test('should handle empty strings in JSON', () {
      // arrange
      final json = {'code': '', 'name': ''};

      // act
      final model = ContinentModel.fromJson(json);

      // assert
      expect(model.code, '');
      expect(model.name, '');
    });

    test('should correctly map to entity with all fields', () {
      // arrange
      const model = ContinentModel(code: 'EU', name: 'Europe');

      // act
      final entity = model.toEntity();

      // assert
      expect(entity.code, model.code);
      expect(entity.name, model.name);
    });
  });
}
