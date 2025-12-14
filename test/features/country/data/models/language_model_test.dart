import 'package:country_info/features/country/data/models/language_model.dart';
import 'package:country_info/features/country/domain/entities/language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LanguageModel', () {
    test('should create LanguageModel with all properties', () {
      // arrange & act
      const model = LanguageModel(
        code: 'en',
        name: 'English',
        native: 'English',
        rtl: false,
      );

      // assert
      expect(model.code, 'en');
      expect(model.name, 'English');
      expect(model.native, 'English');
      expect(model.rtl, false);
    });

    test('should create LanguageModel with only required fields', () {
      // arrange & act
      const model = LanguageModel(code: 'es', name: 'Spanish');

      // assert
      expect(model.code, 'es');
      expect(model.name, 'Spanish');
      expect(model.native, null);
      expect(model.rtl, null);
    });

    test('should create LanguageModel from JSON with all fields', () {
      // arrange
      final json = {
        'code': 'ar',
        'name': 'Arabic',
        'native': 'العربية',
        'rtl': true,
      };

      // act
      final model = LanguageModel.fromJson(json);

      // assert
      expect(model.code, 'ar');
      expect(model.name, 'Arabic');
      expect(model.native, 'العربية');
      expect(model.rtl, true);
    });

    test('should create LanguageModel from JSON with optional fields null', () {
      // arrange
      final json = {'code': 'fr', 'name': 'French'};

      // act
      final model = LanguageModel.fromJson(json);

      // assert
      expect(model.code, 'fr');
      expect(model.name, 'French');
      expect(model.native, null);
      expect(model.rtl, null);
    });

    test('should convert LanguageModel to entity with all fields', () {
      // arrange
      const model = LanguageModel(
        code: 'de',
        name: 'German',
        native: 'Deutsch',
        rtl: false,
      );

      // act
      final entity = model.toEntity();

      // assert
      expect(entity, isA<Language>());
      expect(entity.code, 'de');
      expect(entity.name, 'German');
      expect(entity.native, 'Deutsch');
      expect(entity.rtl, false);
    });

    test(
      'should convert LanguageModel to entity with optional fields null',
      () {
        // arrange
        const model = LanguageModel(code: 'it', name: 'Italian');

        // act
        final entity = model.toEntity();

        // assert
        expect(entity, isA<Language>());
        expect(entity.code, 'it');
        expect(entity.name, 'Italian');
        expect(entity.native, null);
        expect(entity.rtl, null);
      },
    );

    test('should convert to JSON with all fields', () {
      // arrange
      const model = LanguageModel(
        code: 'ja',
        name: 'Japanese',
        native: '日本語',
        rtl: false,
      );

      // act
      final json = model.toJson();

      // assert
      expect(json, {
        'code': 'ja',
        'name': 'Japanese',
        'native': '日本語',
        'rtl': false,
      });
    });

    test('should convert to JSON with null optional fields', () {
      // arrange
      const model = LanguageModel(code: 'pt', name: 'Portuguese');

      // act
      final json = model.toJson();

      // assert
      expect(json['code'], 'pt');
      expect(json['name'], 'Portuguese');
      expect(json.containsKey('native'), true);
      expect(json.containsKey('rtl'), true);
    });

    test('should create equal models with same values', () {
      // arrange
      const model1 = LanguageModel(
        code: 'zh',
        name: 'Chinese',
        native: '中文',
        rtl: false,
      );
      const model2 = LanguageModel(
        code: 'zh',
        name: 'Chinese',
        native: '中文',
        rtl: false,
      );

      // assert
      expect(model1, model2);
      expect(model1.hashCode, model2.hashCode);
    });

    test('should create different models with different values', () {
      // arrange
      const model1 = LanguageModel(code: 'ko', name: 'Korean');
      const model2 = LanguageModel(code: 'ru', name: 'Russian');

      // assert
      expect(model1, isNot(model2));
    });

    test('should handle rtl true correctly', () {
      // arrange
      final json = {
        'code': 'he',
        'name': 'Hebrew',
        'native': 'עברית',
        'rtl': true,
      };

      // act
      final model = LanguageModel.fromJson(json);
      final entity = model.toEntity();

      // assert
      expect(model.rtl, true);
      expect(entity.rtl, true);
    });

    test('should handle rtl false correctly', () {
      // arrange
      final json = {'code': 'en', 'name': 'English', 'rtl': false};

      // act
      final model = LanguageModel.fromJson(json);
      final entity = model.toEntity();

      // assert
      expect(model.rtl, false);
      expect(entity.rtl, false);
    });

    test('should handle empty strings in JSON', () {
      // arrange
      final json = {'code': '', 'name': '', 'native': ''};

      // act
      final model = LanguageModel.fromJson(json);

      // assert
      expect(model.code, '');
      expect(model.name, '');
      expect(model.native, '');
    });
  });
}
