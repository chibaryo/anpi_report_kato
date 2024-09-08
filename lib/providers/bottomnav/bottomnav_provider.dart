// provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottomnav_provider.g.dart';

@riverpod
class BottomNavNotifier extends _$BottomNavNotifier {
  @override
  bool build () {
    return true;
  }

  void show() {
    state = true;
  }
  void hide() {
    state = false;
  }
}