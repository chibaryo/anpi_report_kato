import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../models/deviceinfo.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/deviceinfo/deviceinfo_notifier.dart';
import '../../router/app_router.dart';

@RoutePage()
class SigninScreen extends HookConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(streamAuthNotifierProvider, (previous, next) {
      // Check the current route
      final currentRoute = context.router.current.name;

      if (currentRoute == SigninRoute.name) {
        if (next.asData?.value != null) {
          context.router.replace(const AppHomeRoute());
          // context.router.replace(const AppHomeRoute());
        } else {
          context.router.replace(const SigninRoute());
        }
      }
    });

    const storage = FlutterSecureStorage();
    final deviceInfoNotifier = ref.watch(streamDeviceInfoNotifierProvider.notifier);
    const targetCompanyCode = "C1040090==";
    final tFieldCompanyCodeController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final isValidCompanyCode = useListenableSelector(
      tFieldCompanyCodeController,
      () => tFieldCompanyCodeController.text == targetCompanyCode
    );
 

     return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("安否確認アプリ"),
          backgroundColor: Colors.purple[300],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FormBuilder(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FormBuilderTextField(
                            name: "companyCode",
                            controller: tFieldCompanyCodeController,
                            decoration: const InputDecoration(labelText: "企業コード"),
                            obscureText: false,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "企業コードを入力してください";
                              }
                              if (value.length < 8) {
                                return "企業コードは8文字以上である必要があります";
                              }
                              if (value != "C1040090==") {
                                return "企業コードが正しくありません";
                              }
                              return null;
                            },
/*                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]), */
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
                          ),
                          // Email
                          FormBuilderTextField(
                            name: "email",
                            decoration: const InputDecoration(labelText: "メールアドレス"),
                            obscureText: false,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                          ),
                          FormBuilderTextField(
                            name: "password",
                            decoration: const InputDecoration(labelText: "パスワード"),
                            obscureText: true,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo[300],
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: !isValidCompanyCode ? null : () async {
                                      // Retreive fcmToken from SecureStorage
                                      String? fcmToken = await storage.read(key: 'fcmToken');

                                      formKey.currentState?.saveAndValidate();
                                      //
                                      final companyCode = formKey.currentState!.value["companyCode"];
                                      final email = formKey.currentState!.value["email"];
                                      final password = formKey.currentState!.value["password"];

                                      // Do signin
                                      try {
                                        final result = await ref.read(firebaseAuthProvider)
                                        .signInWithEmailAndPassword(
                                          email: email,
                                          password: password,
                                        );

                                        // Update fcmToken in "deviceinfo"
                                        if (fcmToken != null) {
                                          // Check if already "deviceinfo" doc exists
                                          final resChkDoc = await deviceInfoNotifier.getDeviceInfoByUid(result.user!.uid);
                                          if (resChkDoc != null) {
                                            print("#### update fcmToken #####");
                                            await deviceInfoNotifier.updateFcmTokenInDeviceInfo(result.user!.uid, fcmToken);
                                          } else {
                                            // Create a new subcollection doc
                                            print("#### create entry for fcmToken #####");
                                            final newDeviceInfo = DeviceInfo(
                                              fcmTokens: {
                                                "token": fcmToken,
                                                "updatedAt": DateTime.now(),
                                              },
                                              createdAt: DateTime.now(),
                                              updatedAt: DateTime.now(),
                                            );

                                            await deviceInfoNotifier.addDeviceInfo(result.user!.uid, newDeviceInfo);

                                            // Show snackbar

                                          }
                                        }
                                        debugPrint("result: $result");
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(e.toString()))
                                          );
                                        }                                        
                                      }

/*                                        if (context.mounted) {
                                          context.router.push(const MypageRoute());
                                        }*/

                                      // Reset form
                                      formKey.currentState?.reset();
                                    },
                                    child: const Text("サインイン"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Text("アカウントを持っていない方："),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        context.router.push(const SignupRoute());
                                    }
                                    },
                                    child: const Text("サインアップ")
                                    ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          )
        )
    );
  }
}
