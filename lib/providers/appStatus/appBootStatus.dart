// provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appBootStatus.g.dart';

@riverpod
class AppBootStatusNotifier extends _$AppBootStatusNotifier {
  @override
  bool build () {
    return false;
  }

  void update(bool bootStatus) {
    state = bootStatus;
  }
}
