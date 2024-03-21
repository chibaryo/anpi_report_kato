import 'dart:convert';

import 'package:anpi_report_ios/models/notitemplate.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/firestore/notification_provider.dart';
import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/notitemplate_provider.dart';
import '../../providers/firestore/user_provider.dart';
import '../../providers/firestore/userreport_provider.dart';

final logger = Logger();

class NotificationAdmins extends HookConsumerWidget {
  const NotificationAdmins({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseAuthProvider);
//    final firebaseUser = ref.watch(asyncFirebaseUserNotifierProvider);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    //
    final reports = ref.watch(asyncUserReportNotifierProvider);

    final notiTemplatesStream = ref.watch(notiTemplateStreamProvider);
    //
    final notiTitleController = useTextEditingController();
    final notiBodyController = useTextEditingController();

    Widget buildNotifyAll() => TextInputSettingsTile(
          title: "パスワード変更",
          settingKey: "key-notifyall",
          obscureText: true,
          onChange: (password) async {
            await ref
                .read(asyncFirebaseUserNotifierProvider.notifier)
                .updateFirebaseUserPassword(
                  uid: authState.currentUser!.uid,
                  password: password,
                );
            await Settings.setValue<String>("key-password", password,
//          authState.currentUser!.displayName!,
                notify: true);
          },
        );

    return SimpleSettingsTile(
      title: "通知管理",
      subtitle: "通知送信,トピック設定",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
        child: const Icon(Icons.message, color: Colors.white),
      ),
      child: SettingsContainer(
        children: <Widget>[
          AppBar(
            centerTitle: true,
            title: const Text("通知"),
            backgroundColor: Colors.pink.shade600,
            foregroundColor: Colors.white,
          ),
          // Body
          Column(
            children: <Widget>[
              Row(children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          insetPadding: const EdgeInsets.all(2.0),
                          title: const Text("全体通知をします"),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FormBuilder(
                                  key: formKey,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      notiTemplatesStream.when(
                                        data: (templates) {
                                          return DropdownButtonFormField2<NotiTemplate>(
                                            isDense: true,
                                            decoration: const InputDecoration(
                                              labelText: "テンプレートを選択できます",
                                            ),
                                            items: templates.map<DropdownMenuItem<NotiTemplate>>((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: Text(e.notiTitle),
                                              );
                                            }).toList(),
                                            onChanged: (NotiTemplate? template) {
                                              notiTitleController.text = template!.notiTitle;
                                              notiBodyController.text = template.notiBody;
//                                              debugPrint("template: ${template.toString()}");
                                            },
                                          );
                                        },
                                        loading: () => const Center(child: CircularProgressIndicator()),
                                        error: (error, stackTrace) =>
                                          Center(child: Text('Error: $error')),
                                      ),
                                      CustomTextFormField(
                                        hintText: "タイトル",
                                        controller: notiTitleController,
                                        autofocus: true,
                                      ),
                            /*                                    FormBuilderTextField(
                                        name: "notiTitle",
                                        autofocus: true,
                                        decoration: const InputDecoration(hintText: "タイトル"),
                                        obscureText: false,
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                      ),*/
                                      CustomTextFormField(
                                        hintText: "本文",
                                        controller: notiBodyController,
                                        autofocus: true,
                                      ),
                            /*                                    FormBuilderTextField(
                                        name: "notiBody",
                                        autofocus: true,
                                        decoration: const InputDecoration(hintText: "本文"),
                                        obscureText: false,
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                        ]),
                                      ),*/
                                      
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        child: const Text("キャンセル"),
                                        onPressed: () async {
                                          context.pop();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        child: const Text("送信"),
                                        onPressed: () async {
                                          var newId = const Uuid().v4();
                                      
                                          formKey.currentState?.saveAndValidate();
                                          debugPrint(formKey.currentState?.value.toString());
                                          final notiTitle = notiTitleController.text;
                                          //final notiTitle = formKey.currentState!.value["notiTitle"];
                                          final notiBody = notiBodyController.text;
                                          // final notiBody = formKey.currentState!.value["notiBody"];
                                      
                                          // POST http
                                          Uri url = Uri.parse("https://fcm-noti-anpi.vercel.app/api/sendToTopic");
                                          Map<String, String> headers = {'Content-TYpe': 'application/json'};
                                          String body = json.encode({
                                            'title': notiTitle,
                                            'body': notiBody,
                                            'topic': 'notice_all',
                                          });
                                          http.post(url, headers: headers, body: body).then((http.Response resp) {
                                            if (resp.statusCode != 200) {
                                              debugPrint("# Error");
                                            } else {
                                              debugPrint("Status Code: ${resp.statusCode}");
                                              final contentBody = resp.body;
                                              debugPrint("contentBody: $contentBody");
                                            }
                                      
                                            try {
                                              // Save to Firestore : "notifications"
                                              ref.read(asyncNotificationNotifierProvider.notifier).addNotification(
                                                notificationId: newId,
                                                notiTitle: notiTitle,
                                                notiBody: notiBody
                                              );
                                            } catch (err) {
                                              throw Exception(err);
                                            }
                                            context.pop();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  },
                  child: const Text("全体通知"),
                ),
              ]),
              reports.when(
                data: (userreport) {
                  if (userreport.isNotEmpty) {
                    //return Text(userreport.toString());
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "名前",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "安否",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "出社",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "メッセージ",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "Location",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: userreport.map<DataRow>((e) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(e.name)),
                            DataCell(Text(e.anpiStatus)),
                            DataCell(Text(e.gotoOfficeStatus)),
                            DataCell(Text(e.message != "" ? e.message : "N/A")),
                            DataCell(Text(e.position.toString())),
                          ],
                        )).toList()
                      ),
                    );
                  } else {
                    return const Text("ユーザレポートがありません");
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) {
                  return Center(child: Text('Error: $error'));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
