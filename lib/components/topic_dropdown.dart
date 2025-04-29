import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/firestore/topic/topic.dart';
import '../repository/firebase/topic_repo.dart';

class TopicDropdown extends ConsumerWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const TopicDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
// Get repository from provider
    final topicRepository = ref.watch(topicRepositoryProvider);

// Get topics as Future
    final topicsFuture = topicRepository.getActiveTopics();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Topic>>(
        future: topicsFuture,
        builder: (context, snapshot) {
// Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

// Handle error state
          if (snapshot.hasError) {
            debugPrint('Error loading topics: ${snapshot.error}');
            return const Text('Error loading topics');
          }

// Handle data state
          final topics = snapshot.data ?? [];
          debugPrint('Loaded ${topics.length} topics');

          return DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text('未設定'),
              ),
              ...topics.map((topic) {
                debugPrint('Adding topic: ${topic.topic}');
                return DropdownMenuItem<String>(
                  value: topic.topic,
                  child: Text(topic.displayName),
                );
              }),
            ],
            decoration: const InputDecoration(
              labelText: '通知先トピックを選択',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'トピックを選択してください' : null,
          );
        },
      ),
    );
  }
}
