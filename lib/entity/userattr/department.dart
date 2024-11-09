enum DepartmentType {
  undefined(displayName: "未設定", sortNumber: 0),
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
  // Add
  candidate_18(displayName: "第一精錬課", sortNumber: 131072),
  candidate_19(displayName: "圧延課", sortNumber: 262144),
  candidate_20(displayName: "第二精錬課", sortNumber: 524288),
  candidate_21(displayName: "品質保証課", sortNumber: 1048576),
  candidate_22(displayName: "業務課", sortNumber: 2097152),
  candidate_23(displayName: "技能実習生", sortNumber: 4194304),
  // Add2
  candidate_24(displayName: "製造部", sortNumber: 8388608),
  // Add3
  candidate_25(displayName: "製造１部", sortNumber: 16777216),
  candidate_26(displayName: "製造２部", sortNumber: 33554432),
  candidate_27(displayName: "業務", sortNumber: 67108864),
  candidate_28(displayName: "製造", sortNumber: 134217728),
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
    // Omit "未設定" if the sortNumber is not zero
    if (department == DepartmentType.undefined && sortNumber != 0) {
      continue;  // Skip "未設定"
    }

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