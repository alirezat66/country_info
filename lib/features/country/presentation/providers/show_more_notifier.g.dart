// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_more_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShowMore)
const showMoreProvider = ShowMoreProvider._();

final class ShowMoreProvider extends $NotifierProvider<ShowMore, bool> {
  const ShowMoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showMoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showMoreHash();

  @$internal
  @override
  ShowMore create() => ShowMore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showMoreHash() => r'6e3a57d0b389399d2ee47d14adadfc5ed83f3ac6';

abstract class _$ShowMore extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
