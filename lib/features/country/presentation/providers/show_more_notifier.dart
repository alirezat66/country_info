import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShowMoreNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void reset() {
    state = false;
  }
}
