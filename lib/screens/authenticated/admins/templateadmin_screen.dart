import 'package:anpi_report_flutter/models/template/template.dart';
import 'package:anpi_report_flutter/providers/firestore/templates/template_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/profile.dart';
import '../../../providers/api/me_api_provider.dart';
import '../../../providers/api/templates_api_provider.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';
import '../../../repository/betterauth/session_repository.dart';

@RoutePage()
class TemplateAdminScreen extends HookConsumerWidget {
  const TemplateAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final neonEnabled = SessionRepository.isNeonDataEnabled;
    final templatesApi = ref.watch(templatesApiRepositoryProvider);
    final moiProfile = useState<Profile?>(null);
    final isLoading = useState<bool>(true);

    final authAsyncValue = neonEnabled
        ? const AsyncValue.data(null)
        : ref.watch(authStateChangesProvider);
    final asyncTemplates = neonEnabled
        ? ref.watch(neonTemplatesProvider)
        : ref.watch(streamTemplateNotifierProvider);
    final templateNotifier = neonEnabled
        ? null
        : ref.watch(streamTemplateNotifierProvider.notifier);
    final profileNotifier = neonEnabled
        ? null
        : ref.watch(streamProfileNotifierProvider.notifier);
    final neonProfileAsync =
        neonEnabled ? ref.watch(neonMoiProfileProvider) : null;

    final tFieldTitleController = useTextEditingController();
    final tFieldBodyController = useTextEditingController();

    useEffect(() {
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });
      return () {};
    }, const []);

    useEffect(() {
      if (neonEnabled) {
        moiProfile.value = neonProfileAsync?.asData?.value;
        return () {};
      }
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        profileNotifier?.getProfileByUid(user.uid).then((profile) {
          moiProfile.value = profile;
        });
      }
      return () {};
    }, [authAsyncValue, neonEnabled, neonProfileAsync]);

    useEffect(() {
      isLoading.value = asyncTemplates.isLoading;
      return () {};
    }, [asyncTemplates]);

    Future<void> openTemplateDialog({
      String? templateId,
      String initialTitle = '',
      String initialBody = '',
    }) async {
      tFieldTitleController.text = initialTitle;
      tFieldBodyController.text = initialBody;
      final isEdit = templateId != null && templateId.isNotEmpty;

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(isEdit ? 'テンプレート編集' : 'テンプレート追加'),
            content: FormBuilder(
              key: GlobalKey<FormBuilderState>(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    hintText: 'タイトル',
                    controller: tFieldTitleController,
                    autofocus: true,
                  ),
                  CustomTextFormField(
                    hintText: '本文',
                    controller: tFieldBodyController,
                    autofocus: false,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('キャンセル'),
              ),
              if (isEdit && neonEnabled)
                TextButton(
                  onPressed: () async {
                    await templatesApi.deleteTemplate(templateId);
                    ref.invalidate(neonTemplatesProvider);
                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text(
                    '削除',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () async {
                  final notiTitle = tFieldTitleController.text;
                  final notiBody = tFieldBodyController.text;
                  if (neonEnabled) {
                    if (isEdit) {
                      await templatesApi.updateTemplate(templateId, {
                        'title': notiTitle,
                        'body': notiBody,
                        'payload': {
                          'notiTitle': notiTitle,
                          'notiBody': notiBody,
                        },
                      });
                    } else {
                      await templatesApi.createTemplate({
                        'title': notiTitle,
                        'body': notiBody,
                        'payload': {
                          'notiTitle': notiTitle,
                          'notiBody': notiBody,
                        },
                      });
                    }
                    ref.invalidate(neonTemplatesProvider);
                  } else {
                    await templateNotifier!.addTemplate(
                      Template(
                        notiTitle: notiTitle,
                        notiBody: notiBody,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    );
                  }
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
                child: const Text('保存'),
              ),
            ],
          );
        },
      );
    }

    final canManage =
        moiProfile.value != null && moiProfile.value!.userAttr['jobLevel'] == 4;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (context.mounted) {
              ref.read(bottomNavNotifierProvider.notifier).show();
              context.router.maybePop();
            }
          },
        ),
        centerTitle: true,
        title: const Text('テンプレート管理'),
        backgroundColor: Colors.purple[300],
        actions: canManage
            ? [
                IconButton(
                  onPressed: () async {
                    await openTemplateDialog();
                  },
                  icon: const Icon(Icons.add),
                ),
              ]
            : null,
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : switch (asyncTemplates) {
              AsyncData(:final value) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Body')),
                    ],
                    rows: value.map<DataRow>((item) {
                      final template = neonEnabled
                          ? (item as NeonTemplateView).template
                          : item as Template;
                      final id = neonEnabled
                          ? (item as NeonTemplateView).id
                          : '';
                      return DataRow(
                        onSelectChanged: canManage && neonEnabled
                            ? (selected) async {
                                if (selected == true) {
                                  await openTemplateDialog(
                                    templateId: id,
                                    initialTitle: template.notiTitle,
                                    initialBody: template.notiBody,
                                  );
                                }
                              }
                            : null,
                        cells: [
                          DataCell(Text(template.notiTitle)),
                          DataCell(Text(template.notiBody)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              AsyncError(:final error) =>
                Center(child: Text('エラーが発生しました: ${error.toString()}')),
              _ => const Center(child: CircularProgressIndicator()),
            },
    );
  }
}
