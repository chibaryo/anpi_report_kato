enum OfficeLocationStatusType {
  undefined(displayName: "未設定", sortNumber: 0),
  candidate_01(displayName: "東京", sortNumber: 1),
  candidate_02(displayName: "名古屋", sortNumber: 2),
  candidate_03(displayName: "大阪", sortNumber: 4),
  candidate_04(displayName: "広島", sortNumber: 8),
  candidate_05(displayName: "岡山", sortNumber: 16),
  candidate_06(displayName: "九州", sortNumber: 32),
  candidate_07(displayName: "栗橋工場", sortNumber: 64),
  candidate_08(displayName: "鹿島工場", sortNumber: 128),
  candidate_09(displayName: "岡山工場", sortNumber: 256),
  candidate_10(displayName: "九州工場", sortNumber: 512),
  candidate_11(displayName: "嬬恋工場", sortNumber: 1024),
  ;

  final String displayName;
  final int sortNumber;

  const OfficeLocationStatusType({
    required this.displayName,
    required this.sortNumber
  });
}

Map<String, dynamic>? getOfficeLocationStatusTypeDetailsBySortNumber(int sortNumber) {
  OfficeLocationStatusType? foundType = OfficeLocationStatusType.values.firstWhere(
    (candiType) => candiType.sortNumber == sortNumber,
    orElse: () => OfficeLocationStatusType.undefined, // Default case if not found
  );

  return {
    'displayName': foundType.displayName,
    'sortNumber': foundType.sortNumber,
  };

// Return null if not found
}

List<Map<String, dynamic>> getOfficeLocationStatusTypeOptions() {
  return OfficeLocationStatusType.values
      .map((candidateType) => {
            'displayName': candidateType.displayName,
            'sortNumber': candidateType.sortNumber,
          })
      .toList()
    ..sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));
}