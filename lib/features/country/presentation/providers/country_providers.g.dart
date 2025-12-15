// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countries)
const countriesProvider = CountriesProvider._();

final class CountriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Country>>,
          List<Country>,
          FutureOr<List<Country>>
        >
    with $FutureModifier<List<Country>>, $FutureProvider<List<Country>> {
  const CountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Country>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Country>> create(Ref ref) {
    return countries(ref);
  }
}

String _$countriesHash() => r'e0c67530280736f958553dc0e5e9f8a339e3e7b2';

@ProviderFor(countryDetails)
const countryDetailsProvider = CountryDetailsFamily._();

final class CountryDetailsProvider
    extends $FunctionalProvider<AsyncValue<Country>, Country, FutureOr<Country>>
    with $FutureModifier<Country>, $FutureProvider<Country> {
  const CountryDetailsProvider._({
    required CountryDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'countryDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$countryDetailsHash();

  @override
  String toString() {
    return r'countryDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Country> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Country> create(Ref ref) {
    final argument = this.argument as String;
    return countryDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CountryDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$countryDetailsHash() => r'cc30e8dc518801b79f9b0a15ca8663069f547129';

final class CountryDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Country>, String> {
  const CountryDetailsFamily._()
    : super(
        retry: null,
        name: r'countryDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CountryDetailsProvider call(String code) =>
      CountryDetailsProvider._(argument: code, from: this);

  @override
  String toString() => r'countryDetailsProvider';
}
