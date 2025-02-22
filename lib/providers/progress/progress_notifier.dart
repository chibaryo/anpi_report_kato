import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'progress_notifier.g.dart';

@riverpod
class ProgressNotifier extends _$ProgressNotifier {
  @override
  double build() => 0.0; // Initial progress is 0.0

  void updateProgress(double progress) {
    state = progress; // Update the progress value
  }
}