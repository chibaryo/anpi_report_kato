enum TopicType {
  undefined(displayName: "未設定", topic: "", sortNumber: 0, bitMaskNum: 0),
  candidateAll(displayName: "通知_全体", topic: "notice_all", sortNumber: 1, bitMaskNum: 1),
  candidateTokyo(displayName: "通知_東京", topic: "notice_tokyo", sortNumber: 2, bitMaskNum: 2),
  candidateNagoya(displayName: "通知_名古屋", topic: "notice_nagoya", sortNumber: 4, bitMaskNum: 4),
  candidateOsaka(displayName: "通知_大阪", topic: "notice_osaka", sortNumber: 8, bitMaskNum: 8),
  candidateHiroshima(displayName: "通知_広島", topic: "notice_hiroshima", sortNumber: 16, bitMaskNum: 16),
  candidateOkayama(displayName: "通知_岡山", topic: "notice_okayama", sortNumber: 32, bitMaskNum: 32),
  candidateKyushu(displayName: "通知_九州", topic: "notice_kyushu", sortNumber: 64, bitMaskNum: 64),
  //candidateTestAdm2024(displayName: "管理用テスト2024", topic: "test_adm_2024", sortNumber: 128, bitMaskNum: 128),
  candidateAdmOnly2025(displayName: "管理用テスト2025", topic: "adm_only_2025", sortNumber: 256, bitMaskNum: 256),
  ;

  final String displayName;
  final String topic;
  final int sortNumber;
  final int bitMaskNum;

  const TopicType({
    required this.displayName,
    required this.topic,
    required this.sortNumber,
    required this.bitMaskNum,
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

bool calcSubscriptionBitmask(String topicName, int bitmask) {
  // Find the TopicType corresponding to the topicName
  TopicType? foundType = TopicType.values.firstWhere(
    (topicType) => topicType.topic == topicName,
    orElse: () => TopicType.undefined, // Default case if not found
  );

  // If the topic is not found, return false
  if (foundType == TopicType.undefined) {
    return false;
  }

  // Check if the bitMaskNum is set in the bitmask
  return (bitmask & foundType.bitMaskNum) != 0;
}


List<Map<String, dynamic>> getTopicDetailsBySortNumber(int sortNumber) {
  List<Map<String, dynamic>> matchingTopics = [];

  for (var topic in TopicType.values) {
    // Omit "未設定" if the sortNumber is not zero
    if (topic == TopicType.undefined && sortNumber != 0) {
      continue;  // Skip "未設定"
    }

    // Use bitwise AND to check if the department is part of the sortNumber
    if ((sortNumber & topic.sortNumber) == topic.sortNumber) {
      matchingTopics.add({
        'displayName': topic.displayName,
        'sortNumber': topic.sortNumber,
      });
    }
  }

  // Sort by the original sortNumber for consistency
  matchingTopics.sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));

  return matchingTopics;
}