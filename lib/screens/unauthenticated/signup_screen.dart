import 'package:anpi_report_ios/providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import 'package:anpi_report_ios/providers/firestore/profile/profile_notifier.dart';
import 'package:anpi_report_ios/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../models/deviceinfo.dart';
import '../../models/firestoreuser.dart';
import '../../models/profile.dart';
import '../../providers/firebaseauth/auth_provider.dart';
import '../../providers/firestore/deviceinfo/deviceinfo_notifier.dart';
import '../../repository/firebase/authrepo.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

@RoutePage()
class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const storage = FlutterSecureStorage();
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final AuthService authService = AuthService();
    final userNotifier = ref.watch(streamUserNotifierProvider.notifier);
    final deviceInfoNotifier = ref.watch(streamDeviceInfoNotifierProvider.notifier);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);


    ref.listen(streamAuthNotifierProvider, (previous, next) {
      // Check the current route
      final currentRoute = context.router.current.name;

      if (currentRoute == SignupRoute.name) {
        if (next.asData?.value != null) {
          context.router.replace(const AppHomeRoute());
        } else {
          context.router.replace(const SigninRoute());
        }
      }
    });

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Anpi"),
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
                          // Email
                          FormBuilderTextField(
                            name: "username",
                            decoration: const InputDecoration(labelText: "名前"),
                            obscureText: false,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.none,
                          ),
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                            ]),
                          ),
                          FormBuilderTextField(
                            name: "confirmPassword",
                            decoration: const InputDecoration(labelText: "パスワード（確認）"),
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                              (value) {
                                return FormBuilderValidators.equal<String>(
                                  formKey.currentState?.instantValue["password"] ?? '',
                                  errorText: 'パスワードが一致しません')(value);
                              },
                            ]),
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
                                    onPressed: () async {
                                      formKey.currentState?.saveAndValidate();
                                      //
                                      final displayName = formKey.currentState?.value["username"];
                                      final email = formKey.currentState!.value["email"];
                                      final password = formKey.currentState!.value["password"];

                                      // Do signup
                                      try {
                                        final result = await authService.createAccountByEmail(
                                          email,
                                          password
                                        );
                                        debugPrint("result: $result");

                                        // Retreive fcmToken from SecureStorage
                                        String? fcmToken = await storage.read(key: 'fcmToken');

                                        // Store userdata to Firestore "users"
                                        final newUser = FirestoreUser(
                                          username: displayName,
                                          email: email,
                                          password: password,
                                          isOnline: true,
                                          lastActive: DateTime.now(),
                                          accoutStatus: 1, // 1: Online
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        );

                                        await userNotifier.addUser(result!, newUser);

                                        // Store fcmToken to "deviceinfo" subcollection of each user
                                        final newDeviceInfo = DeviceInfo(
                                          fcmTokens: {
                                            "token": fcmToken,
                                            "updatedAt": DateTime.now(),
                                          },
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        );
                                        await deviceInfoNotifier.addDeviceInfo(result, newDeviceInfo);

                                        // Update displayName
                                        debugPrint(" #### Hppppp   ####");
                                        await authService.updateDisplayName(displayName);

                                        // Store new profile to Firestore "profiles"
                                        final newProfile = Profile(
                                          uid: result,
                                          avatarUrl: [],
                                          userAttr: {
                                            // officeLocation:
                                            // 0001 = 1 = 東京
                                            // 0010 = 2 = 名古屋
                                            // 0100 = 4 = 大阪
                                            // 0100 = 8 = 広島
                                            // 0100 = 16 = 岡山
                                            // 0100 = 32 = 九州
                                            "officeLocation": 1,
                                            // jobLevel:
                                            // 0001 = 1 = 社員
                                            // 0010 = 2 = 責任者
                                            // 0100 = 4 = 管理者
                                            "jobLevel": 1,
                                            // department:
                                            // Department	Bit Position	Binary Representation	Decimal Value
                                            // 代表取締役社長	0	00000000000000001	1
                                            // 常務取締役	1	00000000000000010	2
                                            // 取締役	2	00000000000000100	4
                                            // 監査室	3	00000000000001000	8
                                            // 営業1部	4	00000000000010000	16
                                            // 営業2部	5	00000000000100000	32
                                            // 営業3部	6	00000000001000000	64
                                            // 営業4部	7	00000000010000000	128
                                            // 物流グループ	8	00000000100000000	256
                                            // 経営企画部	9	00000001000000000	512
                                            // 総務部	10	00000010000000000	1024
                                            // 経理部	11	00000100000000000	2048
                                            // 岡山営業所	12	00001000000000000	4096
                                            // 九州営業所	13	00010000000000000	8192
                                            // 広島営業所	14	00100000000000000	16384
                                            // 大阪支店	15	01000000000000000	32768
                                            // 名古屋支店	16	10000000000000000	65536

                                            // You can query for users belonging to a specific department using bitwise operations, like:
                                            // department & 1 != 0 for 総務部
                                            // department & 2 != 0 for 物流グループ
                                            "department": 16+256, // 営業1部 && 物流グループ(t-anzaiさんみたいな人)
                                          },
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        );
                                        await profileNotifier.addProfile(result, newProfile);

                                        /* if (context.mounted) {
                                          context.router.replace(const RootRoute());
                                        } */
                                        // Reset form
//                                        formKey.currentState?.reset();

                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(e.toString()))
                                          );
                                        }
                                      }

                                    },
                                    child: const Text("アカウント作成"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Text("アカウントを持っている方："),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        context.router.pushNamed("SigninRoute");
                                      }
                                    },
                                    child: const Text("サインイン")
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
