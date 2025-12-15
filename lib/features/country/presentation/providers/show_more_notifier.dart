import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_more_notifier.g.dart';

@riverpod
class ShowMore extends _$ShowMore {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void reset() {
    state = false;
  }
}
