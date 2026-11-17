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
  // Regions the earthquake server (wsocket) sends to. Bits 128 and 512 are taken, so these start at 1024
  // and must match app.topics on the server (db/data/003_add_regional_topics.sql in the web repo).
  candidateHokkaido(displayName: "通知_北海道", topic: "notice_hokkaido", sortNumber: 1024, bitMaskNum: 1024),
  candidateTohoku(displayName: "通知_東北", topic: "notice_tohoku", sortNumber: 2048, bitMaskNum: 2048),
  candidateKitakanto(displayName: "通知_北関東", topic: "notice_kitakanto", sortNumber: 4096, bitMaskNum: 4096),
  candidateHokuriku(displayName: "通知_北陸", topic: "notice_hokuriku", sortNumber: 8192, bitMaskNum: 8192),
  candidateKoshinetsu(displayName: "通知_甲信越", topic: "notice_koshinetsu", sortNumber: 16384, bitMaskNum: 16384),
  candidateChugoku(displayName: "通知_中国（岡山・広島以外）", topic: "notice_chugoku", sortNumber: 32768, bitMaskNum: 32768),
  candidateShikoku(displayName: "通知_四国", topic: "notice_shikoku", sortNumber: 65536, bitMaskNum: 65536),
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

/// Regions an employee can switch on, north to south. notice_all is always on and is not listed.
const List<TopicType> selectableRegionTopics = [
  TopicType.candidateHokkaido,
  TopicType.candidateTohoku,
  TopicType.candidateKitakanto,
  TopicType.candidateTokyo,
  TopicType.candidateHokuriku,
  TopicType.candidateKoshinetsu,
  TopicType.candidateNagoya,
  TopicType.candidateOsaka,
  TopicType.candidateOkayama,
  TopicType.candidateHiroshima,
  TopicType.candidateChugoku,
  TopicType.candidateShikoku,
  TopicType.candidateKyushu,
];

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