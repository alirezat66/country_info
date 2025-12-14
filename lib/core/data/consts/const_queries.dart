class ConstQueries {
  static const String getCountriesQuery = '''
    query GetCountries {
      countries {
        code
        name
        emoji
      }
    }
  ''';

  static String getCountryDetailsQuery(String code) => '''
    query GetCountryDetails(\$code: ID!) {
      country(code: \$code) {
        code
        name
        emoji
        capital
        currency
        phone
        continent {
          code
          name
        }
        languages {
          code
          name
          native
          rtl
        }
      }
    }
  ''';
}
