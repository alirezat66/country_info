import 'package:country_info/features/country/data/models/country_model.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryModel', () {
    test('should create CountryModel with all properties', () {
      // arrange & act
      const model = CountryModel(
        code: 'US',
        name: 'United States',
        emoji: '🇺🇸',
      );

      // assert
      expect(model.code, 'US');
      expect(model.name, 'United States');
      expect(model.emoji, '🇺🇸');
    });

    test('should create CountryModel from JSON', () {
      // arrange
      final json = {
        'code': 'CA',
        'name': 'Canada',
        'emoji': '🇨🇦',
      };

      // act
      final model = CountryModel.fromJson(json);

      // assert
      expect(model.code, 'CA');
      expect(model.name, 'Canada');
      expect(model.emoji, '🇨🇦');
    });

    test('should convert CountryModel to entity', () {
      // arrange
      const model = CountryModel(
        code: 'GB',
        name: 'United Kingdom',
        emoji: '🇬🇧',
      );

      // act
      final entity = model.toEntity();

      // assert
      expect(entity, isA<Country>());
      expect(entity.code, 'GB');
      expect(entity.name, 'United Kingdom');
      expect(entity.emoji, '🇬🇧');
    });

    test('should convert to JSON', () {
      // arrange
      const model = CountryModel(
        code: 'FR',
        name: 'France',
        emoji: '🇫🇷',
      );

      // act
      final json = model.toJson();

      // assert
      expect(json, {
        'code': 'FR',
        'name': 'France',
        'emoji': '🇫🇷',
      });
    });

    test('should create equal models with same values', () {
      // arrange
      const model1 = CountryModel(
        code: 'DE',
        name: 'Germany',
        emoji: '🇩🇪',
      );
      const model2 = CountryModel(
        code: 'DE',
        name: 'Germany',
        emoji: '🇩🇪',
      );

      // assert
      expect(model1, model2);
      expect(model1.hashCode, model2.hashCode);
    });

    test('should create different models with different values', () {
      // arrange
      const model1 = CountryModel(
        code: 'IT',
        name: 'Italy',
        emoji: '🇮🇹',
      );
      const model2 = CountryModel(
        code: 'ES',
        name: 'Spain',
        emoji: '🇪🇸',
      );

      // assert
      expect(model1, isNot(model2));
    });

    test('should handle empty strings in JSON', () {
      // arrange
      final json = {
        'code': '',
        'name': '',
        'emoji': '',
      };

      // act
      final model = CountryModel.fromJson(json);

      // assert
      expect(model.code, '');
      expect(model.name, '');
      expect(model.emoji, '');
    });
  });
}

