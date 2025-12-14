import 'package:country_info/features/country/data/models/continent_model.dart';
import 'package:country_info/features/country/data/models/country_model.dart';
import 'package:country_info/features/country/data/models/language_model.dart';
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
      final json = {'code': 'CA', 'name': 'Canada', 'emoji': '🇨🇦'};

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
      const model = CountryModel(code: 'FR', name: 'France', emoji: '🇫🇷');

      // act
      final json = model.toJson();

      // assert
      expect(json['code'], 'FR');
      expect(json['name'], 'France');
      expect(json['emoji'], '🇫🇷');
    });

    test('should create equal models with same values', () {
      // arrange
      const model1 = CountryModel(code: 'DE', name: 'Germany', emoji: '🇩🇪');
      const model2 = CountryModel(code: 'DE', name: 'Germany', emoji: '🇩🇪');

      // assert
      expect(model1, model2);
      expect(model1.hashCode, model2.hashCode);
    });

    test('should create different models with different values', () {
      // arrange
      const model1 = CountryModel(code: 'IT', name: 'Italy', emoji: '🇮🇹');
      const model2 = CountryModel(code: 'ES', name: 'Spain', emoji: '🇪🇸');

      // assert
      expect(model1, isNot(model2));
    });

    test('should handle empty strings in JSON', () {
      // arrange
      final json = {'code': '', 'name': '', 'emoji': ''};

      // act
      final model = CountryModel.fromJson(json);

      // assert
      expect(model.code, '');
      expect(model.name, '');
      expect(model.emoji, '');
    });

    test('should create CountryModel with optional fields', () {
      // arrange & act
      const model = CountryModel(
        code: 'US',
        name: 'United States',
        emoji: '🇺🇸',
        capital: 'Washington, D.C.',
        currency: 'USD',
        phone: '1',
      );

      // assert
      expect(model.code, 'US');
      expect(model.name, 'United States');
      expect(model.emoji, '🇺🇸');
      expect(model.capital, 'Washington, D.C.');
      expect(model.currency, 'USD');
      expect(model.phone, '1');
    });

    test('should create CountryModel from JSON with optional fields', () {
      // arrange
      final json = {
        'code': 'CA',
        'name': 'Canada',
        'emoji': '🇨🇦',
        'capital': 'Ottawa',
        'currency': 'CAD',
        'phone': '1',
      };

      // act
      final model = CountryModel.fromJson(json);

      // assert
      expect(model.code, 'CA');
      expect(model.name, 'Canada');
      expect(model.emoji, '🇨🇦');
      expect(model.capital, 'Ottawa');
      expect(model.currency, 'CAD');
      expect(model.phone, '1');
    });

    test('should create CountryModel with continent', () {
      // arrange & act
      const model = CountryModel(
        code: 'FR',
        name: 'France',
        emoji: '🇫🇷',
        continent: ContinentModel(code: 'EU', name: 'Europe'),
      );

      // assert
      expect(model.code, 'FR');
      expect(model.continent, isNotNull);
      expect(model.continent?.code, 'EU');
      expect(model.continent?.name, 'Europe');
    });

    test('should create CountryModel from JSON with continent', () {
      // arrange
      final json = {
        'code': 'DE',
        'name': 'Germany',
        'emoji': '🇩🇪',
        'continent': {'code': 'EU', 'name': 'Europe'},
      };

      // act
      final model = CountryModel.fromJson(json);

      // assert
      expect(model.continent, isNotNull);
      expect(model.continent?.code, 'EU');
      expect(model.continent?.name, 'Europe');
    });

    test('should create CountryModel with languages', () {
      // arrange & act
      const model = CountryModel(
        code: 'BE',
        name: 'Belgium',
        emoji: '🇧🇪',
        languages: [
          LanguageModel(code: 'nl', name: 'Dutch'),
          LanguageModel(code: 'fr', name: 'French'),
          LanguageModel(code: 'de', name: 'German'),
        ],
      );

      // assert
      expect(model.languages.length, 3);
      expect(model.languages[0].code, 'nl');
      expect(model.languages[1].code, 'fr');
      expect(model.languages[2].code, 'de');
    });

    test('should create CountryModel from JSON with languages', () {
      // arrange
      final json = {
        'code': 'CH',
        'name': 'Switzerland',
        'emoji': '🇨🇭',
        'languages': [
          {'code': 'de', 'name': 'German'},
          {'code': 'fr', 'name': 'French'},
          {'code': 'it', 'name': 'Italian'},
        ],
      };

      // act
      final model = CountryModel.fromJson(json);

      // assert
      expect(model.languages.length, 3);
      expect(model.languages[0].code, 'de');
      expect(model.languages[1].code, 'fr');
      expect(model.languages[2].code, 'it');
    });

    test('should create CountryModel with empty languages list', () {
      // arrange & act
      const model = CountryModel(
        code: 'JP',
        name: 'Japan',
        emoji: '🇯🇵',
        languages: [],
      );

      // assert
      expect(model.languages, isEmpty);
    });

    test('should convert to entity with all optional fields', () {
      // arrange
      const model = CountryModel(
        code: 'GB',
        name: 'United Kingdom',
        emoji: '🇬🇧',
        capital: 'London',
        currency: 'GBP',
        phone: '44',
        continent: ContinentModel(code: 'EU', name: 'Europe'),
        languages: [LanguageModel(code: 'en', name: 'English')],
      );

      // act
      final entity = model.toEntity();

      // assert
      expect(entity, isA<Country>());
      expect(entity.code, 'GB');
      expect(entity.name, 'United Kingdom');
      expect(entity.emoji, '🇬🇧');
      expect(entity.capital, 'London');
      expect(entity.currency, 'GBP');
      expect(entity.phone, '44');
      expect(entity.continent, isNotNull);
      expect(entity.continent?.code, 'EU');
      expect(entity.languages.length, 1);
      expect(entity.languages[0].code, 'en');
    });

    test('should convert to entity with null optional fields', () {
      // arrange
      const model = CountryModel(
        code: 'US',
        name: 'United States',
        emoji: '🇺🇸',
      );

      // act
      final entity = model.toEntity();

      // assert
      expect(entity.capital, null);
      expect(entity.currency, null);
      expect(entity.phone, null);
      expect(entity.continent, null);
      expect(entity.languages, isEmpty);
    });

    test('should convert to JSON with all fields', () {
      // arrange
      const model = CountryModel(
        code: 'IT',
        name: 'Italy',
        emoji: '🇮🇹',
        capital: 'Rome',
        currency: 'EUR',
        phone: '39',
        continent: ContinentModel(code: 'EU', name: 'Europe'),
        languages: [LanguageModel(code: 'it', name: 'Italian')],
      );

      // act
      final json = model.toJson();

      // assert
      expect(json['code'], 'IT');
      expect(json['name'], 'Italy');
      expect(json['emoji'], '🇮🇹');
      expect(json['capital'], 'Rome');
      expect(json['currency'], 'EUR');
      expect(json['phone'], '39');
      expect(json['continent'], isNotNull);
      expect(json['languages'], isA<List>());
    });

    test('should handle complex nested data from JSON', () {
      // arrange
      final json = {
        'code': 'ES',
        'name': 'Spain',
        'emoji': '🇪🇸',
        'capital': 'Madrid',
        'currency': 'EUR',
        'phone': '34',
        'continent': {'code': 'EU', 'name': 'Europe'},
        'languages': [
          {'code': 'es', 'name': 'Spanish', 'native': 'Español', 'rtl': false},
        ],
      };

      // act
      final model = CountryModel.fromJson(json);
      final entity = model.toEntity();

      // assert
      expect(model.code, 'ES');
      expect(model.capital, 'Madrid');
      expect(model.continent?.code, 'EU');
      expect(model.languages[0].native, 'Español');
      expect(entity.continent?.name, 'Europe');
      expect(entity.languages[0].name, 'Spanish');
    });

    test('should handle multiple languages with all fields', () {
      // arrange
      final json = {
        'code': 'IN',
        'name': 'India',
        'emoji': '🇮🇳',
        'languages': [
          {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी', 'rtl': false},
          {'code': 'en', 'name': 'English', 'native': 'English', 'rtl': false},
        ],
      };

      // act
      final model = CountryModel.fromJson(json);
      final entity = model.toEntity();

      // assert
      expect(model.languages.length, 2);
      expect(entity.languages.length, 2);
      expect(entity.languages[0].name, 'Hindi');
      expect(entity.languages[1].name, 'English');
    });
  });
}
