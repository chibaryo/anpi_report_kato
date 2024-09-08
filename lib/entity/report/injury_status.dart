enum InjuryStatusType {
  undefined(displayName: "未設定", sortNumber: 0),
  candidate_01(displayName: "無事", sortNumber: 1),
  candidate_02(displayName: "怪我", sortNumber: 2),
  candidate_03(displayName: "その他", sortNumber: 3),
  ;

  final String displayName;
  final int sortNumber;

  const InjuryStatusType({
    required this.displayName,
    required this.sortNumber
  });
}

Map<String, dynamic>? getInjuryStatusTypeDetailsBySortNumber(int sortNumber) {
  InjuryStatusType? foundType = InjuryStatusType.values.firstWhere(
    (bloodType) => bloodType.sortNumber == sortNumber,
    orElse: () => InjuryStatusType.undefined, // Default case if not found
  );

  return {
    'displayName': foundType.displayName,
    'sortNumber': foundType.sortNumber,
  };

// Return null if not found
}

List<Map<String, dynamic>> getInjuryStatusTypeOptions() {
  return InjuryStatusType.values
      .map((candidateType) => {
            'displayName': candidateType.displayName,
            'sortNumber': candidateType.sortNumber,
          })
      .toList()
    ..sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));
}