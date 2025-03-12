import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isAlreadyQRAuthenticated.g.dart';

@riverpod
class IsAlreadyQRAuthenticatedNotifier extends _$IsAlreadyQRAuthenticatedNotifier {
  @override
  bool build() => false;

  void updateFlag(bool isFlag) {
    state = isFlag;
  }
}
