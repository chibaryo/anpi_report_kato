import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'themeswitcher_provider.g.dart';

@riverpod
class ThemeSwitcherData extends _$ThemeSwitcherData {
  @override
  bool build() {
     return true;
  }

  void setDarkMode(bool darkMode) {
    state = darkMode;
  }
}
