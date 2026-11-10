import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/template/template.dart';
import '../../repository/api/templates_api_repository.dart';
import '../../repository/betterauth/session_repository.dart';

final templatesApiRepositoryProvider = Provider<TemplatesApiRepository>((ref) {
  return TemplatesApiRepository();
});

DateTime? _parseDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

Template _templateFromNeonRow(Map<String, dynamic> row) {
  final payload = row['payload'];
  final payloadMap =
      payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};
  return Template(
    notiTitle: row['title']?.toString() ??
        payloadMap['notiTitle']?.toString() ??
        '',
    notiBody:
        row['body']?.toString() ?? payloadMap['notiBody']?.toString() ?? '',
    createdAt: _parseDate(row['created_at']),
    updatedAt: _parseDate(row['updated_at']),
  );
}

final neonTemplatesProvider =
    FutureProvider.autoDispose<List<Template>>((ref) async {
  if (!SessionRepository.isNeonDataEnabled) {
    return const [];
  }
  final repository = ref.watch(templatesApiRepositoryProvider);
  final rows = await repository.listTemplates();
  return rows.map(_templateFromNeonRow).toList();
});
