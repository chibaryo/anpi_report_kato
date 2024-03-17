import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/notification_provider.dart';
import '../../providers/firestore/userreport_provider.dart';
import '../../providers/geolocator/location_provider.dart';

class PostEnqueteScreen extends HookConsumerWidget {
  const PostEnqueteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final stepIndex = useState(0);
    final arrayLength = useState(0);
    final authState = ref.watch(firebaseAuthProvider);
    //
    final notifications = ref.watch(asyncNotificationNotifierProvider);
    //
    final messageController = useTextEditingController();
    final currentAddress = ref.watch(addressDataProvider);

    useEffect(() {
      debugPrint("###### currentAddress : ${currentAddress.toString()} #######");

      return () {};
    }, const []);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("回答"),
          backgroundColor: Colors.lime,
        ),
//        drawer: const NavContents(),
        body: 
            FormBuilder(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: stepIndex.value,
                onStepCancel: () {
                  if (stepIndex.value != 0) {
                    stepIndex.value -= 1;
                  }
                },
                onStepContinue: () {
              //            final isLastStep = stepIndex.value == getSteps().length -1;
                  if (stepIndex.value != 2) {
                    stepIndex.value += 1;
                  }
                },
                onStepTapped: (int index) {
                  stepIndex.value = index;
                },
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if(stepIndex.value > 0) TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text("戻る")
                      )
                      else if(arrayLength.value == 0) TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text("戻る")
                      )
                      else TextButton(
                        onPressed: () {},
                        child: const Text("戻る", style: TextStyle(color: Colors.grey),)
                      ),
                      if(stepIndex.value < 2 && arrayLength.value > 0) TextButton(
                        onPressed: details.onStepContinue,
                        child: const Text("次へ")
                      )
                      else TextButton(
                        onPressed: () {},
                        child: const Text("次へ", style: TextStyle(color: Colors.grey),)
                      ),
                    ],
                  );
                },
                steps: <Step>[
                  notifications.when(
                    data: (notis) {
                      final filteredNotis = notis.where((element) {
                        debugPrint(" element $element");
                        return !element.a_respondents.contains(authState.currentUser!.uid);
                      }).toList();
                      arrayLength.value = filteredNotis.length;
            
                      if (filteredNotis.isNotEmpty) {
                        return Step(
                          title: const Text("対象を選択"),
                          isActive: stepIndex.value == 0,
                          content: FormBuilderDropdown(
                            name: "issue_menu",
                            decoration: const InputDecoration(labelText: "選択してください"),
                            onChanged: (value) {
            
                            },
                            items: filteredNotis.map((menuItem) => DropdownMenuItem(
                              value: menuItem.notificationId,
                              child: Text(menuItem.notiTitle),
                            )).toList()
                          )
                        );
                      } else {
                        // Handle the case when `notis` is empty
                        return Step(
                          title: const Text("対象を選択"),
                          isActive: stepIndex.value == 0,
                          content: const Text("未回答の通知はありません"),
                        );
                      }
                    },
                    loading: () => Step(
                      title: const Text("Loading..."),
                      isActive: stepIndex.value == 0,
                      content: const Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) {
                      return Step(
                        title: const Text("Error"),
                        isActive: stepIndex.value == 0,
                        content: Center(child: Text("Error: ${error.toString()}")),
                      );
                    }
                  ),
                  Step(
                    title: const Text("出社の可否"),
                    isActive: stepIndex.value == 2,
                    content: Column(
                      children: [
                        FormBuilderRadioGroup(
                          name: "anpiStatus",
                          decoration: const InputDecoration(labelText: "怪我の有無を選択してください"),
                          orientation: OptionsOrientation.vertical,
                          options: const [
                            FormBuilderFieldOption(value: "無事", child: Text("無事")),
                            FormBuilderFieldOption(value: "怪我", child: Text("怪我")),
                            FormBuilderFieldOption(value: "その他", child: Text("その他")),
                          ],
                        ),                    
                        FormBuilderRadioGroup(
                          name: "gotoOfficeStatus",
                          decoration: const InputDecoration(labelText: "出社の可否を選択してください"),
                          orientation: OptionsOrientation.vertical,
                          options: const [
                            FormBuilderFieldOption(value: "出社可", child: Text("出社可")),
                            FormBuilderFieldOption(value: "出社不可", child: Text("出社不可")),
                            FormBuilderFieldOption(value: "出社済", child: Text("出社済")),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text("追加情報"),
                    isActive: stepIndex.value == 3,
                    content: Column(
                      children: <Widget>[
                        CustomTextFormField(
                          hintText: "メッセージ",
                          controller: messageController,
                          autofocus: true,
                          maxLines: 5,
                        ),
                        /* FormBuilderTextField(
                            name: "message",
                            decoration: const InputDecoration(labelText: "メッセージ"),
                            obscureText: false,
                            maxLines: 5,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ), */
                        FormBuilderCheckbox(
                          name: "isLocationPermitted",
                          title: const Text("位置情報を送信する"),
                          initialValue: false,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            var newId = const Uuid().v4();
              
                            formKey.currentState?.saveAndValidate();
                            debugPrint(formKey.currentState?.value.toString());
                            final issueMenu = formKey.currentState!.value["issue_menu"];
                            final anpiStatus = formKey.currentState!.value["anpiStatus"];
                            final gotoOfficeStatus = formKey.currentState!.value["gotoOfficeStatus"];
                            final message = messageController.text; //formKey.currentState!.value["message"];
                            final isLocationPermitted = formKey.currentState!.value["isLocationPermitted"];
              
                            try {
                              // Get current location from 
                              ref.read(asyncUserReportNotifierProvider.notifier)
                                .addUserReport(
                                  reportId: newId,
                                  issueId: issueMenu,
                                  uid: authState.currentUser!.uid,
                                  name: authState.currentUser!.displayName!,
                                  anpiStatus: anpiStatus,
                                  gotoOfficeStatus: gotoOfficeStatus,
                                  message: message ?? "",
                                  isLocationPermitted: isLocationPermitted,
                                  position:  [
                                    isLocationPermitted ? currentAddress[0] : "",
                                    isLocationPermitted ? currentAddress[1] : "",
                                    isLocationPermitted ? currentAddress[2] : "",
                                    isLocationPermitted ? currentAddress[3] : "",
                                  ]
                                  , //locationInfo,
                              ).then((value) {
                                // Also put uid to "notifications" > sub-"respondent" collection
                                FirebaseFirestore.instance
                                  .collection("notifications")
                                  .doc(issueMenu)
                                  .update({
                                    "a_respondents": FieldValue.arrayUnion([authState.currentUser!.uid])
                                }).then((value) {
                                  context.goNamed("HomeScreen");
                                });
                              });
                            } catch (err) {
                              throw Exception(err);
                            }
              
                          },
                          child: const Text("送信する")
                        )
                      ],
                    ),
                  ),
                ]
              ),
            ),
    );
  }
}
