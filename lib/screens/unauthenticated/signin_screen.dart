import 'dart:convert';

import 'package:anpi_report_flutter/providers/appStatus/isAlreadyQRAuthenticated.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../models/deviceinfo.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/deviceinfo/deviceinfo_notifier.dart';
import '../../providers/qrtext/qrtext_notifier.dart';
import '../../router/app_router.dart';
import 'package:local_auth/local_auth.dart';

const storage = FlutterSecureStorage();

@RoutePage()
class SigninScreen extends HookConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LocalAuthentication auth = LocalAuthentication();
    final authorized = useState<String>('未認証');
    final userHistory = useState<List<Map<String, dynamic>>>([]);
    final dialogFormKey = useMemoized(() => GlobalKey<FormBuilderState>());

    Future<void> openNoUserHistoryDialog(
      BuildContext context, WidgetRef ref) async {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("ユーザ選択"),
              content: const Text("ログイン履歴がありません"),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("戻る"),
                ),
              ],
            );
          }
        );
    }
    
    Future<void> openUserSelectDialog(
        BuildContext context, WidgetRef ref) async {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("ユーザ選択"),
              content: FormBuilder(
                key: dialogFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormBuilderRadioGroup(
                      decoration: const InputDecoration(
                        labelText: '選択してください',
                        border: InputBorder.none,
                      ),
                      name: 'selected_user', // Name of the field
                      options: userHistory.value.map((history) {
                        return FormBuilderFieldOption(
                          value:
                              jsonEncode(history), // Value of the radio button
                          child: Text(
                              history["email"]), // Title of the radio button
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    // Handle submission
                    dialogFormKey.currentState?.saveAndValidate();
                    final selectedUser =
                        dialogFormKey.currentState!.value['selected_user'];
                    final email = jsonDecode(selectedUser)["email"];
                    final password = jsonDecode(selectedUser)["password"];

                    // Login with the selected user account on Firebase
                    // Do signin
                    try {
                      final result = await ref
                          .read(firebaseAuthProvider)
                          .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                      // Set QR auth flag = yes
                      await storage.write(
                        key: "isAlreadyQRAuthenticated",
                        value: "yes",
                      );

                      final Map<String, String> currentUserAccount = {
                        "email": email,
                        "password": password,
                      };

                      // Check if currentChoice exists in history
                      // Check if already exists current email
                      final bool isEmailAlreadyExists = userHistory.value.any(
                        (history) =>
                            history["email"] == currentUserAccount["email"],
                      );
                      //
                      if (!isEmailAlreadyExists) {
                        userHistory.value.insert(0, currentUserAccount);

                        // 要素数を2以下にする
                        List<Map<String, dynamic>> resultUserHistory;
                        if (userHistory.value.length > 2) {
                          resultUserHistory = userHistory.value.sublist(0, 2);
                        } else {
                          resultUserHistory = userHistory.value;
                        }

                        await storage.write(
                            key: "userHistory",
                            value: jsonEncode(resultUserHistory));
                      }
                    } catch (e) {
                      // handle error
                    }
                  },
                  child: const Text("ログイン"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("キャンセル"),
                ),
              ],
            );
          });
    }

    Future<void> authenticate() async {
      bool authenticated = false;
      try {
        authenticated = await auth.authenticate(
          localizedReason: '生体認証でログインしてください',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        // if true
        if (authenticated) {
          // Check if securestorage have userHistory
          userHistory.value.clear();
          final userHistoryOnStorage = await storage.read(key: "userHistory");
          if (userHistoryOnStorage != null) {
            final List<dynamic> userHistoryDecoded =
                jsonDecode(userHistoryOnStorage);
            final List<Map<String, dynamic>> userHistoryList =
                userHistoryDecoded
                    .map((history) => history as Map<String, dynamic>)
                    .toList();

            debugPrint("userHistory on storage: ${userHistoryList.toString()}");
            userHistory.value.addAll(userHistoryList);

            // Open user select dialog
            if (context.mounted) {
              await openUserSelectDialog(context, ref);
            }
          } else {
            if (context.mounted) {
              await openNoUserHistoryDialog(context,ref);
            }
          }
        }
      } catch (e) {
        print(e);
      }

      authorized.value = authenticated ? '認証成功' : '認証失敗';
    }

    ref.listen(streamAuthNotifierProvider, (previous, next) {
      // Check the current route
      final currentRoute = context.router.current.name;

      if (currentRoute == SigninRoute.name) {
        if (next.asData?.value != null) {
          context.router.replace(const TabsRouterRoute());
          // context.router.replace(const AppHomeRoute());
        } else {
          return;
          //context.router.replace(const SigninRoute());
        }
      }
    });

    final isAlreadyQRAuthed =
        ref.watch(isAlreadyQRAuthenticatedNotifierProvider);

    final deviceInfoNotifier =
        ref.watch(streamDeviceInfoNotifierProvider.notifier);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final String targetCompanyCode = dotenv
        .get('COMPANYAUTHCODE'); //"eD8dzYgLNtF4HmmOB9OT3i7Y1G5wXyeeAn4unMBA";
    final tFieldCompanyCodeController = useTextEditingController();

    // Provider
    final qrTextProvider = ref.watch(qrTextNotifierProvider);

    final isValidCompanyCode = useListenableSelector(
        tFieldCompanyCodeController,
        () => tFieldCompanyCodeController.text == targetCompanyCode);

    useEffect(() {
      storage.read(key: 'isAlreadyQRAuthenticated').then((result) {
        if (result == "yes") {
          ref
              .read(isAlreadyQRAuthenticatedNotifierProvider.notifier)
              .updateFlag(true);
        }
      });

      return null;
    }, const []);

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
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (context.mounted) {
                        context.router.push(const ScanQRRoute());
                      }
                    },
                    child: const Text("QRスキャンする"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (isValidCompanyCode ||
                            qrTextProvider == targetCompanyCode ||
                            isAlreadyQRAuthed)
                        ? "認証QRスキャンOK"
                        : "認証QRをスキャンしてください",
                  ),
                  //Text((!isValidCompanyCode) || (qrTextProvider != targetCompanyCode) ? "認証QRをスキャンしてください" : "認証QRスキャンOK"),
                ),
                // bio
                //Text('生体認証状態: ${authorized.value}'),
                ElevatedButton(
                  onPressed: authenticate,
                  child: const Text('生体認証で自動ログインする'),
                ),
                // end bio
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
                            decoration:
                                const InputDecoration(labelText: "企業コード"),
                            obscureText: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            enabled: qrTextProvider == targetCompanyCode ||
                                    isAlreadyQRAuthed
                                ? false
                                : true,
                            validator: (value) {
                              if (qrTextProvider == targetCompanyCode ||
                                  isAlreadyQRAuthed) {
                                return null;
                              }

                              if (value == null || value.isEmpty) {
                                return "企業コードを入力してください";
                              }
                              if (value.length < 8) {
                                return "企業コードは8文字以上である必要があります";
                              }
                              if (value != targetCompanyCode) {
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
                            decoration:
                                const InputDecoration(labelText: "メールアドレス"),
                            obscureText: false,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                          ),
                          FormBuilderTextField(
                            name: "password",
                            decoration:
                                const InputDecoration(labelText: "パスワード"),
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
                                    onPressed: (isValidCompanyCode ||
                                            qrTextProvider ==
                                                targetCompanyCode ||
                                            isAlreadyQRAuthed)
                                        ? () async {
                                            // Retreive fcmToken from SecureStorage
                                            String? fcmToken = await storage
                                                .read(key: 'fcmToken');

                                            formKey.currentState
                                                ?.saveAndValidate();
                                            //
                                            //final companyCode = formKey.currentState!.value["companyCode"];
                                            final email = formKey
                                                .currentState!.value["email"];
                                            final password = formKey
                                                .currentState!
                                                .value["password"];

                                            // Do signin
                                            try {
                                              final result = await ref
                                                  .read(firebaseAuthProvider)
                                                  .signInWithEmailAndPassword(
                                                    email: email,
                                                    password: password,
                                                  );

                                              // Set QR auth flag = yes
                                              await storage.write(
                                                key: "isAlreadyQRAuthenticated",
                                                value: "yes",
                                              );

                                              final Map<String, String>
                                                  currentUserAccount = {
                                                "email": email,
                                                "password": password,
                                              };
                                              // Initiate userHistory.value
                                              userHistory.value.clear();
                                              final userHistoryOnStorage =
                                                  await storage.read(
                                                      key: "userHistory");
                                              if (userHistoryOnStorage !=
                                                  null) {
                                                final List<dynamic>
                                                    userHistoryDecoded =
                                                    jsonDecode(
                                                        userHistoryOnStorage);
                                                final List<Map<String, dynamic>>
                                                    userHistoryList =
                                                    userHistoryDecoded
                                                        .map((history) =>
                                                            history as Map<
                                                                String,
                                                                dynamic>)
                                                        .toList();

                                                debugPrint(
                                                    "userHistory on storage: ${userHistoryList.toString()}");
                                                userHistory.value
                                                    .addAll(userHistoryList);
                                              }
                                              // Check if already exists current email
                                              final bool isEmailAlreadyExists =
                                                  userHistory.value.any(
                                                (history) =>
                                                    history["email"] ==
                                                    currentUserAccount["email"],
                                              );
                                              //
                                              if (!isEmailAlreadyExists) {
                                                //
                                                userHistory.value.insert(
                                                    0, currentUserAccount);

                                                // 要素数を2以下にする
                                                List<Map<String, dynamic>>
                                                    resultUserHistory;
                                                if (userHistory.value.length >
                                                    2) {
                                                  resultUserHistory =
                                                      userHistory.value
                                                          .sublist(0, 2);
                                                } else {
                                                  resultUserHistory =
                                                      userHistory.value;
                                                }

                                                await storage.write(
                                                    key: "userHistory",
                                                    value: jsonEncode(
                                                        resultUserHistory));
                                              }

                                              // Update fcmToken in "deviceinfo"
                                              if (fcmToken != null) {
                                                // Check if already "deviceinfo" doc exists
                                                final resChkDoc =
                                                    await deviceInfoNotifier
                                                        .getDeviceInfoByUid(
                                                            result.user!.uid);
                                                if (resChkDoc != null) {
                                                  await deviceInfoNotifier
                                                      .updateFcmTokenInDeviceInfo(
                                                          result.user!.uid,
                                                          fcmToken);
                                                } else {
                                                  // Create a new subcollection doc
                                                  final newDeviceInfo =
                                                      DeviceInfo(
                                                    fcmTokens: {
                                                      "token": fcmToken,
                                                      "updatedAt":
                                                          DateTime.now(),
                                                    },
                                                    createdAt: DateTime.now(),
                                                    updatedAt: DateTime.now(),
                                                  );

                                                  await deviceInfoNotifier
                                                      .addDeviceInfo(
                                                          result.user!.uid,
                                                          newDeviceInfo);

                                                  // Show snackbar
                                                }
                                              }
                                              debugPrint("result: $result");
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            e.toString())));
                                              }
                                            }

/*                                        if (context.mounted) {
                                          context.router.push(const MypageRoute());
                                        }*/

                                            // Reset form
                                            formKey.currentState?.reset();
                                          }
                                        : null,
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
                                          context.router
                                              .push(const SignupRoute());
                                        }
                                      },
                                      child: const Text("サインアップ")),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        )));
  }
}
