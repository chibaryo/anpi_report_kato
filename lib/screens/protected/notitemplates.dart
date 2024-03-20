import 'dart:convert';

import 'package:anpi_report_ios/models/notitemplate.dart';
import 'package:anpi_report_ios/providers/firestore/notitemplate_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../providers/firestore/notification_provider.dart';
import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as screensettings;
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/user_provider.dart';
import '../../providers/firestore/userreport_provider.dart';

final logger = Logger();

class NotiTemplatesAdmin extends HookConsumerWidget {
  const NotiTemplatesAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseAuthProvider);
//    final firebaseUser = ref.watch(asyncFirebaseUserNotifierProvider);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    //
    final notiTemplatesStream = ref.watch(notiTemplateStreamProvider);
    //
    final notiTitleController = useTextEditingController();
    final notiBodyController = useTextEditingController();

    //
    Future<List<DataRow>> buildDataRows(List<NotiTemplate> templates) async {
      return Future.wait(templates.map<Future<DataRow>>((e) async {
        final docSnap = await FirebaseFirestore.instance
          .collection("notitemplates")
          .doc(e.notiTemplateId)
          .get();
        final data = docSnap.data();

        return DataRow(cells: <DataCell>[
          DataCell(Text(data!["notiTitle"])),
          DataCell(Text(data!["notiBody"])),
        ]);
      })).then((rows) => rows.toList());
    }

    //

    Widget buildNotifyAll() => screensettings.TextInputSettingsTile(
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
            await screensettings.Settings.setValue<String>("key-password", password,
//          authState.currentUser!.displayName!,
                notify: true);
          },
        );

    return screensettings.SimpleSettingsTile(
      title: "テンプレート管理",
      subtitle: "テンプレート作成、編集",
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
        child: const Icon(Icons.edit_document, color: Colors.white),
      ),
      child: screensettings.SettingsContainer(
        children: <Widget>[
          AppBar(
            centerTitle: true,
            title: const Text("テンプレート"),
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
                          title: const Text("テンプレート登録します"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FormBuilder(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
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
                                        try {
                                          // Save to Firestore : "notifications"
                                          ref.read(asyncNotiTemplateNotifierProvider.notifier).addNotiTemplate(
                                            notiTemplateId: newId,
                                            notiTitle: notiTitle,
                                            notiBody: notiBody,
                                            mode: "add",
                                          );
                                          // Clear form input
                                          notiTitleController.text = "";
                                          notiBodyController.text = "";
                                        } catch (err) {
                                          throw Exception(err);
                                        }
                                          context.pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  },
                  child: const Text("テンプレート追加"),
                ),
              ]),
              const Text("各行のタイトルをクリックして編集できます", style: TextStyle(color: Colors.red),),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("notitemplates").orderBy("createdAt", descending: false).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("Something went wrong.");
                  }
                  return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "タイトル",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "本文",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "削除",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: snapshot.data!.docs.map<DataRow>((DocumentSnapshot e) { 
                          final data = e.data()! as Map<String, dynamic>;
                          return DataRow(
                          cells: <DataCell>[
                            DataCell(
                              GestureDetector(
                                onTap: () {
                                  // e.id Edit
                                  // title
                                  notiTitleController.text = data["notiTitle"];
                                  notiBodyController.text = data["notiBody"];

                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("テンプレート編集します"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FormBuilder(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
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
                                        notiTitleController.text = "";
                                        notiBodyController.text = "";

                                        context.pop();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      child: const Text("送信"),
                                      onPressed: () async {
                                        formKey.currentState?.saveAndValidate();
                                        debugPrint(formKey.currentState?.value.toString());
                                        final notiTitle = notiTitleController.text;
                                        //final notiTitle = formKey.currentState!.value["notiTitle"];
                                        final notiBody = notiBodyController.text;
                                        // final notiBody = formKey.currentState!.value["notiBody"];
                                        try {
                                          // Save to Firestore : "notifications"
                                          ref.read(asyncNotiTemplateNotifierProvider.notifier).addNotiTemplate(
                                            notiTemplateId: e.id,
                                            notiTitle: notiTitle,
                                            notiBody: notiBody,
                                            mode: "edit",
                                          );
                                          // Clear form input
                                          notiTitleController.text = "";
                                          notiBodyController.text = "";
                                        } catch (err) {
                                          throw Exception(err);
                                        }
                                          context.pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    );

                                },
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 120.0),
                                  child: Text(
                                    data["notiTitle"],
                                    style: const TextStyle(color: Colors.brown),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 100.0),
                                child: Text(
                                  data["notiBody"],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () async {
                                  debugPrint("${e.id}");
                                  await FirebaseFirestore.instance
                                    .collection("notitemplates")
                                    .doc(e.id)
                                    .delete();
                                },
                                icon: const Icon(Icons.delete)
                              )
                            ),
                          ],
                          );}).toList()
                      ),
                    );
                }
              ),
/*              notiTemplatesStream.when(
                  data: (templates) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "タイトル",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "本文",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "削除",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: templates.map<DataRow>((e) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(e.notiTitle)),
                            DataCell(Text(e.notiBody)),
                            DataCell(
                              IconButton(
                                onPressed: () async {
                                  debugPrint("${e.toString()}");
                                },
                                icon: const Icon(Icons.delete)
                              )
                            ),
                          ],
                        )).toList()
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) {
                    debugPrint(error.toString());
                    return Center(child: Text('Error: $error'));
                  },
              ), */
//                    return Text(templates.toString());
/*                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "タイトル",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "本文",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                "削除",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: template.map<DataRow>((e) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(e.notiTitle)),
                            DataCell(Text(e.notiBody)),
                            DataCell(
                              IconButton(
                                onPressed: () async {
                                  debugPrint("${e.toString()}");
                                },
                                icon: const Icon(Icons.delete)
                              )
                            ),
                          ],
                        )).toList()
                      ),
                    ); */
            ],
          ),
        ],
      ),
    );
  }
}
