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
}
