// provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottomnav_provider.g.dart';

@riverpod
class BottomNavNotifier extends _$BottomNavNotifier {
  @override
  int build () {
    return 0;
  }

  void update(int index) {
    state = index;
  }
}
