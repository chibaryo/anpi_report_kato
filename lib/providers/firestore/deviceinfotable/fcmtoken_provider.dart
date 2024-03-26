import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcmtoken_provider.g.dart';

@riverpod
class FcmTokenNotifier extends _$FcmTokenNotifier {
  @override
  String build () {
    return "";
  }

  void update(String token) {
    state = token;
  }
}
