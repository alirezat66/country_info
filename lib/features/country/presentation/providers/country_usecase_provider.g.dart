// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_usecase_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getCountries)
const getCountriesProvider = GetCountriesProvider._();

final class GetCountriesProvider
    extends $FunctionalProvider<GetCountries, GetCountries, GetCountries>
    with $Provider<GetCountries> {
  const GetCountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCountriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCountriesHash();

  @$internal
  @override
  $ProviderElement<GetCountries> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCountries create(Ref ref) {
    return getCountries(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCountries value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCountries>(value),
    );
  }
}

String _$getCountriesHash() => r'ec76fa8c346d4c3c3fa01b46d5afdab0179694d7';

@ProviderFor(getCountryDetails)
const getCountryDetailsProvider = GetCountryDetailsProvider._();

final class GetCountryDetailsProvider
    extends
        $FunctionalProvider<
          GetCountryDetails,
          GetCountryDetails,
          GetCountryDetails
        >
    with $Provider<GetCountryDetails> {
  const GetCountryDetailsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCountryDetailsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCountryDetailsHash();

  @$internal
  @override
  $ProviderElement<GetCountryDetails> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCountryDetails create(Ref ref) {
    return getCountryDetails(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCountryDetails value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCountryDetails>(value),
    );
  }
}

String _$getCountryDetailsHash() => r'b1ccb38c9a8d799886d7d79add5e0a891a9a4f95';
