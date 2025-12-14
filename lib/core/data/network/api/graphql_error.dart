class GraphQLError {
  final String message;
  final String? code;
  final Map<String, dynamic>? extensions;

  GraphQLError({required this.message, this.code, this.extensions});
}
