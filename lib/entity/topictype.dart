enum TopicType {
  undefined(displayName: "未設定", topic: "", sortNumber: 0),
  candidateAll(displayName: "通知_全体", topic: "notice_all", sortNumber: 1),
  candidateTokyo(displayName: "通知_東京", topic: "notice_tokyo", sortNumber: 2),
  candidateNagoya(displayName: "通知_名古屋", topic: "notice_nagoya", sortNumber: 4),
  candidateOsaka(displayName: "通知_大阪", topic: "notice_osaka", sortNumber: 8),
  candidateHiroshima(displayName: "通知_広島", topic: "notice_hiroshima", sortNumber: 16),
  candidateOkayama(displayName: "通知_岡山", topic: "notice_okayama", sortNumber: 32),
  candidateKyushu(displayName: "通知_九州", topic: "notice_kyushu", sortNumber: 64),
  ;

  final String displayName;
  final String topic;
  final int sortNumber;

  const TopicType({
    required this.displayName,
    required this.topic,
    required this.sortNumber,
  });
}

Map<String, dynamic>? getNotiTopicDetailsBySortNumber(int sortNumber) {
  TopicType? foundType = TopicType.values.firstWhere(
    (candiType) => candiType.sortNumber == sortNumber,
    orElse: () => TopicType.undefined, // Default case if not found
  );

  return {
    'displayName': foundType.displayName,
    'topic': foundType.topic,
    'sortNumber': foundType.sortNumber,
  };

// Return null if not found
}

List<Map<String, dynamic>> getNotiTopicOptions() {
  return TopicType.values
      .map((candidateType) => {
            'displayName': candidateType.displayName,
            'topic': candidateType.topic,
            'sortNumber': candidateType.sortNumber,
          })
      .toList()
    ..sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));
}