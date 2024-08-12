import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleModeNotifier extends StateNotifier<bool> {
  ToggleModeNotifier() : super(false);

  void toggleSelectingMode() {
    state = !state;
  }
}

final toggleModeProvider =
    StateNotifierProvider<ToggleModeNotifier, bool>((ref) {
  return ToggleModeNotifier();
});
