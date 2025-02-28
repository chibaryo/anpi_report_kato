import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qrtext_notifier.g.dart';

@riverpod
class QrTextNotifier extends _$QrTextNotifier {
  @override
  String build() => ""; // Initial progress is 0.0

  void updateQrText(String qrText) {
    state = qrText; // Update the progress value
  }
}