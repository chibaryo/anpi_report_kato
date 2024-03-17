import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isadmin_provider.g.dart';

@riverpod
class IsAdminData extends _$IsAdminData {
  @override
  bool build() {
    return false;
  }

  void updateState(bool isadmin) {
    state = isadmin;
  }
}
