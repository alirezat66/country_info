import 'package:country_info/features/country/domain/entities/continent.dart';
import 'package:country_info/features/country/domain/entities/country.dart';
import 'package:country_info/features/country/domain/entities/country_mapper_ext.dart';
import 'package:country_info/features/country/domain/entities/language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryMapperExt', () {
    group('basicFields', () {
      test('should return map with basic fields', () {
        // arrange
        const country = Country(
          code: 'US',
          name: 'United States',
          emoji: '🇺🇸',
          capital: 'Washington, D.C.',
        );

        // act
        final fields = country.basicFields;

        // assert
        expect(fields, isA<Map<String, String>>());
        expect(fields['Flag'], '🇺🇸');
        expect(fields['Name'], 'United States');
        expect(fields['Code'], 'US');
        expect(fields['Capital'], 'Washington, D.C.');
        expect(fields.length, 4);
      });

      test('should handle null capital', () {
        // arrange
        const country = Country(code: 'XX', name: 'Test Country', emoji: '🏳️');

        // act
        final fields = country.basicFields;

        // assert
        expect(fields['Capital'], '');
      });

      test('should only include basic fields', () {
        // arrange
        const country = Country(
          code: 'FR',
          name: 'France',
          emoji: '🇫🇷',
          capital: 'Paris',
          currency: 'EUR',
          phone: '33',
          continent: Continent(code: 'EU', name: 'Europe'),
          languages: [Language(code: 'fr', name: 'French')],
        );

        // act
        final fields = country.basicFields;

        // assert
        expect(fields.containsKey('Currency'), false);
        expect(fields.containsKey('Phone'), false);
        expect(fields.containsKey('Continent Code'), false);
        expect(fields.containsKey('Languages'), false);
      });
    });

    group('extendedFields', () {
      test('should return map with all fields when all data present', () {
        // arrange
        const country = Country(
          code: 'DE',
          name: 'Germany',
          emoji: '🇩🇪',
          capital: 'Berlin',
          currency: 'EUR',
          phone: '49',
          continent: Continent(code: 'EU', name: 'Europe'),
          languages: [Language(code: 'de', name: 'German')],
        );

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields['Flag'], '🇩🇪');
        expect(fields['Name'], 'Germany');
        expect(fields['Code'], 'DE');
        expect(fields['Capital'], 'Berlin');
        expect(fields['Currency'], 'EUR');
        expect(fields['Phone'], '49');
        expect(fields['Continent Code'], 'EU');
        expect(fields['Continent Name'], 'Europe');
        expect(fields['Languages'], 'German');
      });

      test('should include basic fields', () {
        // arrange
        const country = Country(
          code: 'GB',
          name: 'United Kingdom',
          emoji: '🇬🇧',
          capital: 'London',
        );

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields['Flag'], '🇬🇧');
        expect(fields['Name'], 'United Kingdom');
        expect(fields['Code'], 'GB');
        expect(fields['Capital'], 'London');
      });

      test('should handle null currency with NA', () {
        // arrange
        const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields['Currency'], 'NA');
      });

      test('should handle null phone with AN', () {
        // arrange
        const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields['Phone'], 'AN');
      });

      test('should handle null continent', () {
        // arrange
        const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields['Continent Code'], 'NA');
        expect(fields.containsKey('Continent Name'), false);
      });

      test('should include continent name when continent present', () {
        // arrange
        const country = Country(
          code: 'IT',
          name: 'Italy',
          emoji: '🇮🇹',
          continent: Continent(code: 'EU', name: 'Europe'),
        );

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields['Continent Code'], 'EU');
        expect(fields['Continent Name'], 'Europe');
      });

      test('should handle empty languages list', () {
        // arrange
        const country = Country(
          code: 'XX',
          name: 'Test',
          emoji: '🏳️',
          languages: [],
        );

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields.containsKey('Languages'), false);
      });

      test('should format single language', () {
        // arrange
        const country = Country(
          code: 'FR',
          name: 'France',
          emoji: '🇫🇷',
          languages: [Language(code: 'fr', name: 'French')],
        );

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields['Languages'], 'French');
      });

      test('should format multiple languages with comma separation', () {
        // arrange
        const country = Country(
          code: 'BE',
          name: 'Belgium',
          emoji: '🇧🇪',
          languages: [
            Language(code: 'nl', name: 'Dutch'),
            Language(code: 'fr', name: 'French'),
            Language(code: 'de', name: 'German'),
          ],
        );

        // act
        final fields = country.extendedFields;

        // assert
        expect(fields['Languages'], 'Dutch, French, German');
      });
    });

    group('toDetailFields', () {
      test('should return basic fields when showMore is false', () {
        // arrange
        const country = Country(
          code: 'CA',
          name: 'Canada',
          emoji: '🇨🇦',
          capital: 'Ottawa',
          currency: 'CAD',
          phone: '1',
        );

        // act
        final fields = country.toDetailFields(showMore: false);

        // assert
        expect(fields.length, 4);
        expect(fields[0].key, 'Flag');
        expect(fields[0].value, '🇨🇦');
        expect(fields[1].key, 'Name');
        expect(fields[1].value, 'Canada');
        expect(fields[2].key, 'Code');
        expect(fields[2].value, 'CA');
        expect(fields[3].key, 'Capital');
        expect(fields[3].value, 'Ottawa');
      });

      test('should return extended fields when showMore is true', () {
        // arrange
        const country = Country(
          code: 'JP',
          name: 'Japan',
          emoji: '🇯🇵',
          capital: 'Tokyo',
          currency: 'JPY',
          phone: '81',
          continent: Continent(code: 'AS', name: 'Asia'),
          languages: [Language(code: 'ja', name: 'Japanese')],
        );

        // act
        final fields = country.toDetailFields(showMore: true);

        // assert
        expect(fields.length, greaterThan(4));
        expect(fields.any((f) => f.key == 'Currency'), true);
        expect(fields.any((f) => f.key == 'Phone'), true);
        expect(fields.any((f) => f.key == 'Continent Code'), true);
        expect(fields.any((f) => f.key == 'Continent Name'), true);
        expect(fields.any((f) => f.key == 'Languages'), true);
      });

      test('should maintain field order in basic fields', () {
        // arrange
        const country = Country(
          code: 'AU',
          name: 'Australia',
          emoji: '🇦🇺',
          capital: 'Canberra',
        );

        // act
        final fields = country.toDetailFields(showMore: false);

        // assert
        expect(fields[0].key, 'Flag');
        expect(fields[1].key, 'Name');
        expect(fields[2].key, 'Code');
        expect(fields[3].key, 'Capital');
      });

      test('should handle null capital in basic fields', () {
        // arrange
        const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

        // act
        final fields = country.toDetailFields(showMore: false);

        // assert
        expect(fields[3].key, 'Capital');
        expect(fields[3].value, '');
      });

      test('should handle null optional fields when showMore is true', () {
        // arrange
        const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

        // act
        final fields = country.toDetailFields(showMore: true);

        // assert
        final currencyField = fields.firstWhere((f) => f.key == 'Currency');
        final phoneField = fields.firstWhere((f) => f.key == 'Phone');
        expect(currencyField.value, '');
        expect(phoneField.value, '');
      });

      test(
        'should include continent fields when present and showMore true',
        () {
          // arrange
          const country = Country(
            code: 'BR',
            name: 'Brazil',
            emoji: '🇧🇷',
            continent: Continent(code: 'SA', name: 'South America'),
          );

          // act
          final fields = country.toDetailFields(showMore: true);

          // assert
          final continentCodeField = fields.firstWhere(
            (f) => f.key == 'Continent Code',
          );
          final continentNameField = fields.firstWhere(
            (f) => f.key == 'Continent Name',
          );
          expect(continentCodeField.value, 'SA');
          expect(continentNameField.value, 'South America');
        },
      );

      test('should not include continent name when continent is null', () {
        // arrange
        const country = Country(code: 'XX', name: 'Test', emoji: '🏳️');

        // act
        final fields = country.toDetailFields(showMore: true);

        // assert
        expect(fields.any((f) => f.key == 'Continent Name'), false);
      });

      test('should include languages when present and showMore true', () {
        // arrange
        const country = Country(
          code: 'CH',
          name: 'Switzerland',
          emoji: '🇨🇭',
          languages: [
            Language(code: 'de', name: 'German'),
            Language(code: 'fr', name: 'French'),
            Language(code: 'it', name: 'Italian'),
          ],
        );

        // act
        final fields = country.toDetailFields(showMore: true);

        // assert
        final languagesField = fields.firstWhere((f) => f.key == 'Languages');
        expect(languagesField.value, 'German, French, Italian');
      });

      test('should not include languages when list is empty', () {
        // arrange
        const country = Country(
          code: 'XX',
          name: 'Test',
          emoji: '🏳️',
          languages: [],
        );

        // act
        final fields = country.toDetailFields(showMore: true);

        // assert
        expect(fields.any((f) => f.key == 'Languages'), false);
      });

      test('should return list of MapEntry objects', () {
        // arrange
        const country = Country(code: 'NZ', name: 'New Zealand', emoji: '🇳🇿');

        // act
        final fields = country.toDetailFields(showMore: false);

        // assert
        expect(fields, isA<List<MapEntry<String, String>>>());
        expect(fields.first, isA<MapEntry<String, String>>());
      });
    });
  });
}
