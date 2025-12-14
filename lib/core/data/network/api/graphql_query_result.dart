import 'package:country_info/core/data/network/api/graphql_error.dart';

class GraphQLQueryResult {
  final Map<String, dynamic>? data;
  final List<GraphQLError>? errors;
  final bool hasErrors;
  final bool hasData;

  GraphQLQueryResult({this.data, this.errors})
    : hasErrors = errors != null && errors.isNotEmpty,
      hasData = data != null && data.isNotEmpty;

  bool get isEmpty => !hasData;
}

