
import 'dart:convert';

import 'package:anpi_report_flutter/providers/firestore/notification/notification_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/templates/template_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../../entity/notitype.dart';
import '../../../entity/topictype.dart';
import '../../../models/firestoreuser.dart';
import '../../../models/profile.dart';
import '../../../models/template/template.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';
import '../../../providers/sqlite/users/unansweredusers_sqlite_provider.dart';
import '../../../router/app_router.dart';

@RoutePage()
class NotiAdminRouterScreen extends AutoRouter {
  const NotiAdminRouterScreen({super.key});
}

@RoutePage()
class NotiAdminScreen extends HookConsumerWidget {
  const NotiAdminScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sqlUsersNotifier = ref.read(unansweredUsersSQLiteNotifierProvider.notifier);

    final asyncNotis = ref.watch(streamNotificationNotifierProvider);
    //final asyncTemplates = ref.watch(streamTemplateNotifierProvider);
    final authAsyncValue = ref.watch(authStateChangesProvider);
    final moiUid = useState<String>("");
    final moiProfile = useState<Profile?>(null);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);
    final notiStreamNotifier = ref.watch(streamNotificationNotifierProvider.notifier);

    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final tFieldTitleController = useTextEditingController();
    final tFieldBodyController = useTextEditingController();
    //
    final notiType = useState<int>(0);
    final selectedNotiType = useState<int>(NotiType.undefined.sortNumber);
    final selectedNotiTopic = useState<String>(TopicType.undefined.topic);

    // Helper method to get options for DropdownButton
    List<DropdownMenuItem<int>> getNotiTypeDropdownItems() {
      return NotiType.values
      .map((location) => DropdownMenuItem<int>(
            value: location.sortNumber,
            child: Text(location.displayName),
          ))
      .toList();
    }

    List<DropdownMenuItem<String>> getNotiTopicDropdownItems() {
      return TopicType.values
      .map((location) => DropdownMenuItem<String>(
            value: location.topic,
            child: Text(location.displayName),
          ))
      .toList();
    }

    void clearFormFields() {
      tFieldTitleController.text = "";
      tFieldBodyController.text = "";
      selectedNotiType.value = NotiType.undefined.sortNumber;
      selectedNotiTopic.value = TopicType.undefined.topic;
    }


    // FUnc defs
    Widget buildNotiTypeDropDown() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<int>(
          value: selectedNotiType.value,
          onChanged: (int? newValue) {
            if (newValue != null) {
              selectedNotiType.value = newValue;
              debugPrint("selectedNotiType.value: ${selectedNotiType.value}");
            }
          },
          items: getNotiTypeDropdownItems(),
          decoration: const InputDecoration(
            labelText: 'Select notiType',
            border: OutlineInputBorder(),
          ),
        ),
      );
    }

    Widget buildNotiTopicDropDown() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          value: selectedNotiTopic.value,
          onChanged: (String? newValue) {
            if (newValue != null) {
              selectedNotiTopic.value = newValue;
              debugPrint("selectedNotiTopic.value: ${selectedNotiTopic.value}");
            }
          },
          items: getNotiTopicDropdownItems(),
          decoration: const InputDecoration(
            labelText: 'Select topic...',
            border: OutlineInputBorder(),
          ),
        ),
      );
    }

    // End func defs
Future<void> openSendNotiDialog(BuildContext context, WidgetRef ref) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Consumer(
        builder: (context, ref, child) {
          Template? selectedTemplate;
          final asyncTemplates = ref.watch(streamTemplateNotifierProvider);

          return AlertDialog(
            title: const Text("通知を送信する"),
            content: switch (asyncTemplates) {
              AsyncData(:final value) => SingleChildScrollView(
                child: FormBuilder(
                  key: GlobalKey<FormBuilderState>(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomTextFormField(
                        hintText: "タイトル",
                        controller: tFieldTitleController,
                        autofocus: true,
                      ),
                      CustomTextFormField(
                        hintText: "本文",
                        controller: tFieldBodyController,
                        autofocus: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<Template>(
                          value: selectedTemplate,
                          onChanged: (Template? newValue) {
                            if (newValue != null) {
                              selectedTemplate = newValue;
                              // Reflect template data to controllers
                              tFieldTitleController.text = newValue.notiTitle;
                              tFieldBodyController.text = newValue.notiBody;
                            }
                          },
                          items: value.map((template) {
                            return DropdownMenuItem<Template>(
                              value: template,
                              child: Text(template.notiTitle),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'テンプレートを選択',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      // Notification Type Dropdown
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<int>(
                          value: selectedNotiType.value,
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                                selectedNotiType.value = newValue;
                              debugPrint("selectedNotiType: $selectedNotiType");
                            }
                          },
                          items: NotiType.values.map((location) {
                            return DropdownMenuItem<int>(
                              value: location.sortNumber,
                              child: Text(location.displayName),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: '通知タイプを選択',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      // Notification Topic Dropdown
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedNotiTopic.value,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                                selectedNotiTopic.value = newValue;
                                debugPrint("selectedNotiTopic: ${selectedNotiTopic.value}");
                            }
                          },
                          items: TopicType.values.map((location) {
                            return DropdownMenuItem<String>(
                              value: location.topic,
                              child: Text(location.displayName),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: '通知先トピックを選択',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),                      
                    ],
                  ),
                ),
              ),
              AsyncError(:final error) => Center(child: Text('エラー: ${error.toString()}')),
              _ => const Center(child: CircularProgressIndicator()), // Loading state
            },
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("キャンセル"),
              ),
              TextButton(
                onPressed: () async {
                        // Send notification using selectedTemplate
                        final notiTitle = tFieldTitleController.text;
                        final notiBody = tFieldBodyController.text;
                        final notiType = selectedNotiType.value;
                        final notiTopic = selectedNotiTopic.value;
                        var uuid = Uuid();
                        var newId = uuid.v4();

                        // POST to API
                        const String apiUrl = "https://anpi-fcm-2024-test.vercel.app/api/sendToTopic";
                        Uri url = Uri.parse(apiUrl);
                        Map<String, String> headers = {'Content-Type': 'application/json'};
                        String body = json.encode({
                          'title': notiTitle,
                          'body': notiBody,
                          'type': notiType,
                          'topic': notiTopic,
                          'notificationId': newId,
                        });
                        http.Response resp = await http.post(url, headers: headers, body: body);
                        
                        if (resp.statusCode == 200) {
                          debugPrint("### message sent ###");
                          // Ok, handle Firestore saving logic as well
                          if (context.mounted) {
                            Navigator.pop(dialogContext);
                            //context.router.maybePop(dialogContext);
                          }
                        } else {
                          // Handle errors
                        }

                      },
                child: const Text("送信"),
              ),
            ],
          );
        },
      );
    },
  );
}


    useEffect(() {
      // Hide bottomnav
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      // Clean up: Show bottomnav again when leaving this screen
      return () {
      };
    }, []);


    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");

        // Get profile by uid
        profileNotifier.getProfileByUid(moiUid.value).then((profile) {
          moiProfile.value = profile;
        });

      }

      return () {};
    }, [authAsyncValue]);    

    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (context.mounted) {
                  //
                  ref.read(bottomNavNotifierProvider.notifier).show();
                  context.router.back();
                }
              },
            ),
            title: const Text("通知管理"),
            centerTitle: true,
            foregroundColor: Colors.black,
            backgroundColor: Colors.purple[300],
            actions:
              (() {
                if (moiProfile.value != null && moiProfile.value!.userAttr["jobLevel"] >= 4) {
                  return <Widget>[
                    IconButton(
                      onPressed: () async {
                        await openSendNotiDialog(context, ref);
                      },
                      icon: const Icon(Icons.add)
                    ),
                  ];
                }
              })()
          ),
          body: switch(asyncNotis) {
            AsyncData(:final value) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: <Widget>[
                    // debug
                    // end debug
                    DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                          label:
                            moiProfile.value != null && moiProfile.value!.userAttr["jobLevel"] >= 4
                            ?
                            const Text("操作")
                            :
                            const Text(""),
                        ),
                        const DataColumn(
                          label: Text("日時"),
                        ),
                        const DataColumn(
                          label: Text("タイトル"),
                        ),
                        const DataColumn(
                          label: Text("本文"),
                        ),
                      ],
                      rows: asyncNotis.value.map<DataRow>((data) {
                        final rowRecord = data["noti"];
                        debugPrint("rowRecord: ${rowRecord.toString()}");
                                
                        return DataRow(
                          onSelectChanged: (bool? selected) async {
                            if (selected != null && selected) {
                              // Goto individual noti
                              context.router.push(NotiAdminDetailsRoute(notiId: rowRecord.notificationId));
                            }
                          },
                          cells: [
                          moiProfile.value != null && moiProfile.value!.userAttr["jobLevel"] >= 4
                          ?
                          DataCell(
                            TextButton(onPressed: () async {
                              // Show Del noti confirmation dialog
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("通知削除"),
                                    content: const Text("通知削除します。よろしいですか？"),
                                    actions: [
                                      TextButton(
                                        child: const Text("キャンセル"),
                                        onPressed: () async {
                                          if (context.mounted) {
                                            context.router.maybePop();
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("削除", style: TextStyle(color: Colors.red),),
                                        onPressed: () async {
                                          // Delete notification
                                          await notiStreamNotifier.deleteNotificationById(rowRecord.notificationId);
                                          // Close modal
                                          if (context.mounted) {
                                            context.router.maybePop();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }
                              );
                            }, child: const Text("削除", style: TextStyle(color: Colors.red),))
                            
                          )
                          :
                          const DataCell(Text(""))
                          ,
                          DataCell(Text(DateFormat('[M/d h:mm]').format(rowRecord.createdAt))),
                          DataCell(Text(rowRecord.notiTitle)),
                          DataCell(Text(rowRecord.notiBody)),
                        ]);
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
            AsyncError(:final error) => Center(child: Text('エラーが発生しました: ${error.toString()}')),
          _ => const Center(child: CircularProgressIndicator()),
        }
      ),
    );
  }
}
