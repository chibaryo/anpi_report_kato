import '../providers/firestore/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';

import '../providers/firebaseauth/auth_provider.dart';

final logger = Logger();

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({Key? key}) : super(key: key);

  popB(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final authState = ref.watch(firebaseAuthProvider);

    useEffect(() {
      return () {};
    }, const []);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("サインアップ"),
          backgroundColor: Colors.lime,
        ),
//        drawer: const NavContents(),
        body: Center(
          child: Column(
            children: [
              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: FormBuilder(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FormBuilderTextField(
                        name: "siteName",
                        decoration: const InputDecoration(labelText: "会社コード"),
                        obscureText: false,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: "userName",
                        decoration: const InputDecoration(labelText: "氏名"),
                        obscureText: false,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: "emailAddr",
                        decoration: const InputDecoration(labelText: "メールアドレス"),
                        obscureText: false,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: "passWord",
                        decoration: const InputDecoration(labelText: "パスワード"),
                        obscureText: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: "passWordConfirm",
                        decoration: const InputDecoration(labelText: "パスワード（確認）"),
                        obscureText: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          (value) {
                            final password = formKey.currentState?.value["passWord"];
                            if (value != password) {
                              return "パスワードが一致しません";
                            }
                            return null;
                          }
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade300,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            try {
                              formKey.currentState?.saveAndValidate();
                              debugPrint(formKey.currentState?.value.toString());
                              final userName = formKey.currentState!.value["userName"];
                              final emailAddr = formKey.currentState!.value["emailAddr"];
                              final passWord = formKey.currentState!.value["passWord"];

                              // Save user to Firestore
                              ref.read(asyncFirebaseUserNotifierProvider.notifier).addFirebaseUser(
                                name: userName,
                                email: emailAddr,
                                password: passWord,
                                imagepath: "",
                                isOnline: true,
                                isAdmin: false,
                              ).then((value) {
                                // Store fcmtoken to Firestore (empty)
                                FirebaseFirestore.instance
                                  .collection("tokens")
                                  .doc(authState.currentUser!.uid)
                                  .set({
                                    "fcmToken": "", //fcmToken
                                }).then((value) {
                                  // Show snackbar
                                  const snackBar = SnackBar(
                                    content: Text("アカウント登録しました")
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                  // Goto Home
                                  context.goNamed("HomeScreen");
                                });
                              });
                            } catch (err) {
                              throw Exception(err);
                            }
                          },
                          child: const Text("アカウント登録")
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(child: const Text("Back"), onPressed: (
              ) {
                popB(context);
              },)
            ],
          ),
        ));
  }
}
