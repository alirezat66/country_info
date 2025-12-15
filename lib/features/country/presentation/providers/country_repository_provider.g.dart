// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countriesRepository)
const countriesRepositoryProvider = CountriesRepositoryProvider._();

final class CountriesRepositoryProvider
    extends
        $FunctionalProvider<
          CountryRepository,
          CountryRepository,
          CountryRepository
        >
    with $Provider<CountryRepository> {
  const CountriesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countriesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countriesRepositoryHash();

  @$internal
  @override
  $ProviderElement<CountryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CountryRepository create(Ref ref) {
    return countriesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CountryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CountryRepository>(value),
    );
  }
}

String _$countriesRepositoryHash() =>
    r'e91f71e5268f12f5fb60e965ac48c417de9264eb';
