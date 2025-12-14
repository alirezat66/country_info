import 'package:country_info/core/data/consts/const_queries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConstQueries', () {
    group('getCountriesQuery', () {
      test('should contain query keyword', () {
        // act
        final query = ConstQueries.getCountriesQuery;

        // assert
        expect(query, contains('query'));
      });

      test('should contain GetCountries operation name', () {
        // act
        final query = ConstQueries.getCountriesQuery;

        // assert
        expect(query, contains('GetCountries'));
      });

      test('should contain countries field', () {
        // act
        final query = ConstQueries.getCountriesQuery;

        // assert
        expect(query, contains('countries'));
      });

      test('should contain required fields: code, name, emoji', () {
        // act
        final query = ConstQueries.getCountriesQuery;

        // assert
        expect(query, contains('code'));
        expect(query, contains('name'));
        expect(query, contains('emoji'));
      });

      test('should be a valid GraphQL query structure', () {
        // act
        final query = ConstQueries.getCountriesQuery;

        // assert
        expect(query, contains('query GetCountries'));
        expect(query, contains('{'));
        expect(query, contains('}'));
      });

      test('should not contain variables', () {
        // act
        final query = ConstQueries.getCountriesQuery;

        // assert
        expect(query, isNot(contains('\$')));
        expect(query, isNot(contains('(')));
      });

      test('should be properly formatted', () {
        // act
        final query = ConstQueries.getCountriesQuery;

        // assert
        expect(query.trim(), startsWith('query'));
        expect(query.trim(), endsWith('}'));
      });
    });

    group('getCountryDetailsQuery', () {
      test('should contain query keyword', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('query'));
      });

      test('should contain GetCountryDetails operation name', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('GetCountryDetails'));
      });

      test('should contain country field', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('country'));
      });

      test('should contain variable definition for code', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('\$code'));
        expect(query, contains('ID!'));
      });

      test('should contain basic fields: code, name, emoji', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('code'));
        expect(query, contains('name'));
        expect(query, contains('emoji'));
      });

      test('should contain optional detail fields', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('capital'));
        expect(query, contains('currency'));
        expect(query, contains('phone'));
      });

      test('should contain continent nested object', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('continent'));
        expect(query, contains('continent {'));
      });

      test('should contain continent fields: code and name', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        final continentSection = query.substring(
          query.indexOf('continent {'),
          query.indexOf('}', query.indexOf('continent {')),
        );
        expect(continentSection, contains('code'));
        expect(continentSection, contains('name'));
      });

      test('should contain languages nested object', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('languages'));
        expect(query, contains('languages {'));
      });

      test('should contain language fields: code, name, native, rtl', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        final languagesSection = query.substring(
          query.indexOf('languages {'),
          query.indexOf('}', query.indexOf('languages {')),
        );
        expect(languagesSection, contains('code'));
        expect(languagesSection, contains('name'));
        expect(languagesSection, contains('native'));
        expect(languagesSection, contains('rtl'));
      });

      test('should pass code variable to country field', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('country(code: \$code)'));
      });

      test('should be a valid GraphQL query structure', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('query GetCountryDetails(\$code: ID!)'));
        expect(query, contains('{'));
        expect(query, contains('}'));
      });

      test('should be properly formatted', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query.trim(), startsWith('query'));
        expect(query.trim(), endsWith('}'));
      });

      test('should have required variable marked with exclamation', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(query, contains('ID!'));
      });

      test('should contain all expected fields in correct structure', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;

        // assert - verify nested structure
        final countryIndex = query.indexOf('country');
        final codeIndex = query.indexOf('code', countryIndex);
        expect(countryIndex, lessThan(codeIndex));
        expect(
          query.indexOf('continent {'),
          lessThan(query.indexOf('languages {')),
        );
      });
    });

    group('Query comparison', () {
      test(
        'getCountriesQuery should be different from getCountryDetailsQuery',
        () {
          // act
          final countriesQuery = ConstQueries.getCountriesQuery;
          final detailsQuery = ConstQueries.getCountryDetailsQuery;

          // assert
          expect(countriesQuery, isNot(equals(detailsQuery)));
        },
      );

      test('getCountriesQuery should not have variables', () {
        // act
        final countriesQuery = ConstQueries.getCountriesQuery;
        final detailsQuery = ConstQueries.getCountryDetailsQuery;

        // assert
        expect(countriesQuery, isNot(contains('\$')));
        expect(detailsQuery, contains('\$'));
      });

      test(
        'getCountryDetailsQuery should have more fields than getCountriesQuery',
        () {
          // act
          final countriesQuery = ConstQueries.getCountriesQuery;
          final detailsQuery = ConstQueries.getCountryDetailsQuery;

          // assert
          expect(detailsQuery.length, greaterThan(countriesQuery.length));
          expect(detailsQuery, contains('capital'));
          expect(countriesQuery, isNot(contains('capital')));
        },
      );

      test('both queries should use proper GraphQL syntax', () {
        // act
        final countriesQuery = ConstQueries.getCountriesQuery.trim();
        final detailsQuery = ConstQueries.getCountryDetailsQuery.trim();

        // assert
        expect(countriesQuery, startsWith('query'));
        expect(detailsQuery, startsWith('query'));
        expect(countriesQuery, contains('{'));
        expect(detailsQuery, contains('{'));
        expect(countriesQuery, contains('}'));
        expect(detailsQuery, contains('}'));
      });
    });

    group('Query validation', () {
      test('getCountriesQuery should have balanced braces', () {
        // act
        final query = ConstQueries.getCountriesQuery;
        final openBraces = '{'.allMatches(query).length;
        final closeBraces = '}'.allMatches(query).length;

        // assert
        expect(openBraces, equals(closeBraces));
      });

      test('getCountryDetailsQuery should have balanced braces', () {
        // act
        final query = ConstQueries.getCountryDetailsQuery;
        final openBraces = '{'.allMatches(query).length;
        final closeBraces = '}'.allMatches(query).length;

        // assert
        expect(openBraces, equals(closeBraces));
      });

      test('queries should not be empty', () {
        // act & assert
        expect(ConstQueries.getCountriesQuery, isNotEmpty);
        expect(ConstQueries.getCountryDetailsQuery, isNotEmpty);
      });

      test('queries should be constant strings', () {
        // act
        final query1 = ConstQueries.getCountriesQuery;
        final query2 = ConstQueries.getCountriesQuery;

        // assert
        expect(query1, equals(query2));
        expect(identical(query1, query2), true);
      });
    });
  });
}
