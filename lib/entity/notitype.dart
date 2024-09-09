enum NotiType {
  undefined(displayName: "未設定", sortNumber: 0),
  candidate_01(displayName: "アンケート", sortNumber: 1),
  candidate_02(displayName: "確認", sortNumber: 2),
//  candidate_03(displayName: "その他", sortNumber: 4),
  ;

  final String displayName;
  final int sortNumber;

  const NotiType({
    required this.displayName,
    required this.sortNumber
  });
}

Map<String, dynamic>? getNotiTypeDetailsBySortNumber(int sortNumber) {
  NotiType? foundType = NotiType.values.firstWhere(
    (candiType) => candiType.sortNumber == sortNumber,
    orElse: () => NotiType.undefined, // Default case if not found
  );

  return {
    'displayName': foundType.displayName,
    'sortNumber': foundType.sortNumber,
  };

// Return null if not found
}

List<Map<String, dynamic>> getNotiTypeOptions() {
  return NotiType.values
      .map((candidateType) => {
            'displayName': candidateType.displayName,
            'sortNumber': candidateType.sortNumber,
          })
      .toList()
    ..sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));
}