enum DepartmentType {
  undefined(displayName: "未設定", sortNumber: -1),
  candidate_01(displayName: "代表取締役社長", sortNumber: 1),
  candidate_02(displayName: "常務取締役", sortNumber: 2),
  candidate_03(displayName: "取締役", sortNumber: 4),
  candidate_04(displayName: "監査室", sortNumber: 8),
  candidate_05(displayName: "営業1部", sortNumber: 16),
  candidate_06(displayName: "営業2部", sortNumber: 32),
  candidate_07(displayName: "営業3部", sortNumber: 64),
  candidate_08(displayName: "営業4部", sortNumber: 128),
  candidate_09(displayName: "物流グループ", sortNumber: 256),
  candidate_10(displayName: "経営企画部", sortNumber: 512),
  candidate_11(displayName: "総務部", sortNumber: 1024),
  candidate_12(displayName: "経理部", sortNumber: 2048),
  candidate_13(displayName: "岡山営業所", sortNumber: 4096),
  candidate_14(displayName: "九州営業所", sortNumber: 8192),
  candidate_15(displayName: "広島営業所", sortNumber: 16384),
  candidate_16(displayName: "大阪支店", sortNumber: 32768),
  candidate_17(displayName: "名古屋支店", sortNumber: 65536),
  ;

  final String displayName;
  final int sortNumber;

  const DepartmentType({
    required this.displayName,
    required this.sortNumber
  });
}

List<Map<String, dynamic>> getDepartmentTypeDetailsBySortNumber(int sortNumber) {
  List<Map<String, dynamic>> matchingDepartments = [];

  for (var department in DepartmentType.values) {
    // Use bitwise AND to check if the department is part of the sortNumber
    if ((sortNumber & department.sortNumber) == department.sortNumber) {
      matchingDepartments.add({
        'displayName': department.displayName,
        'sortNumber': department.sortNumber,
      });
    }
  }

  // Sort by the original sortNumber for consistency
  matchingDepartments.sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));

  return matchingDepartments;
}

List<Map<String, dynamic>> getDepartmentTypeOptions() {
  return DepartmentType.values
      .map((candidateType) => {
            'displayName': candidateType.displayName,
            'sortNumber': candidateType.sortNumber,
          })
      .toList()
    ..sort((a, b) => (a['sortNumber'] as int).compareTo(b['sortNumber'] as int));
}