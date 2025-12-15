// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graphql_api_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(graphqlApiClient)
const graphqlApiClientProvider = GraphqlApiClientProvider._();

final class GraphqlApiClientProvider
    extends
        $FunctionalProvider<
          GraphQLApiClient,
          GraphQLApiClient,
          GraphQLApiClient
        >
    with $Provider<GraphQLApiClient> {
  const GraphqlApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphqlApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphqlApiClientHash();

  @$internal
  @override
  $ProviderElement<GraphQLApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraphQLApiClient create(Ref ref) {
    return graphqlApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphQLApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphQLApiClient>(value),
    );
  }
}

String _$graphqlApiClientHash() => r'201cd4c5af03c14ef9da0da54cc757fababc4682';
