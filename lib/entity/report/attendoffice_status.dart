enum AttendOfficeStatusType {
  undefined(displayName: "未設定", sortNumber: 0),
  candidate_01(displayName: "出社可", sortNumber: 1),
  candidate_02(displayName: "出社不可", sortNumber: 2),
  candidate_03(displayName: "出社済み", sortNumber: 3),
  ;

  final String displayName;
  final int sortNumber;

  const AttendOfficeStatusType({
    required this.displayName,
    required this.sortNumber
  });
}

Map<String, dynamic>? getAttendOfficeStatusTypeDetailsBySortNumber(int sortNumber) {
  AttendOfficeStatusType? foundType = AttendOfficeStatusType.values.firstWhere(
    (candiType) => candiType.sortNumber == sortNumber,
    orElse: () => AttendOfficeStatusType.undefined, // Default case if not found
  );

  return {
    'displayName': foundType.displayName,
    'sortNumber': foundType.sortNumber,
  };

// Return null if not found
}

List<Map<String, dynamic>> getAttendOfficeStatusTypeOptions() {
  return AttendOfficeStatusType.values
      .map((candidateType) => {
            'displayName': candidateType.displayName,
            'sortNumber': candidateType.sortNumber,
          })
      .toList()
    ..sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));
}