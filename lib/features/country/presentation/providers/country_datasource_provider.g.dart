// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_datasource_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countryDataSource)
const countryDataSourceProvider = CountryDataSourceProvider._();

final class CountryDataSourceProvider
    extends
        $FunctionalProvider<
          CountryDataSource,
          CountryDataSource,
          CountryDataSource
        >
    with $Provider<CountryDataSource> {
  const CountryDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countryDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countryDataSourceHash();

  @$internal
  @override
  $ProviderElement<CountryDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CountryDataSource create(Ref ref) {
    return countryDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CountryDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CountryDataSource>(value),
    );
  }
}

String _$countryDataSourceHash() => r'efe7f11b9929f189aeefbcadabc716063bcc1d39';
