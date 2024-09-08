enum JobLevelStatusType {
  undefined(displayName: "未設定", sortNumber: 0),
  candidate_01(displayName: "社員", sortNumber: 1),
  candidate_02(displayName: "責任者", sortNumber: 2),
  candidate_03(displayName: "管理者", sortNumber: 4),
  ;

  final String displayName;
  final int sortNumber;

  const JobLevelStatusType({
    required this.displayName,
    required this.sortNumber
  });
}

Map<String, dynamic>? getJobLevelStatusTypeDetailsBySortNumber(int sortNumber) {
  JobLevelStatusType? foundType = JobLevelStatusType.values.firstWhere(
    (candiType) => candiType.sortNumber == sortNumber,
    orElse: () => JobLevelStatusType.undefined, // Default case if not found
  );

  return {
    'displayName': foundType.displayName,
    'sortNumber': foundType.sortNumber,
  };

// Return null if not found
}

List<Map<String, dynamic>> getJobLevelStatusTypeOptions() {
  return JobLevelStatusType.values
      .map((candidateType) => {
            'displayName': candidateType.displayName,
            'sortNumber': candidateType.sortNumber,
          })
      .toList()
    ..sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));
}