import 'package:anpi_report_ios/providers/firestore/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';

import '../providers/firebaseauth/auth_provider.dart';
import '../repository/firebase/authrepo.dart';

final logger = Logger();

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(firebaseAuthProvider);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    //
    Auth auth = Auth();
    final authResult = useState("");

    useEffect(() {
      return () {};
    }, const []);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("ログイン"),
          backgroundColor: Colors.lime,
        ),
//        drawer: const NavContents(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Text(
                  'ログイン',
                  style: TextStyle(fontSize: 32.0),
                ),
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
                          name: "siteCode",
                          decoration: const InputDecoration(labelText: "会社コード"),
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
                        authResult.value != ""
                        ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(authResult.value, style: const TextStyle(color: Colors.red),),
                            ]
                          ),
                        )
                        : Container()
                        ,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo.shade300,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    formKey.currentState?.saveAndValidate();
                                    final siteCode = formKey.currentState!.value["siteCode"];
                                    if (int.tryParse(siteCode) == null) {
                                      authResult.value = "会社コードは数値で入力してください";
                                      return;
                                    }
                                    debugPrint("siteCode: $siteCode");
                                    final emailAddr = formKey.currentState!.value["emailAddr"];
                                    final passWord = formKey.currentState!.value["passWord"];
          
                                    // Sitecode
                                    ref.read(sitecodeProvider.notifier).state = int.parse(siteCode);
          
                                    auth.signIn(emailAddr, passWord).then((result) {
                                      if (result == "err:credential") {
                                        authResult.value = "メールアドレスまたはパスワードが違います";
                                      }
                                      if (result == "err:email") {
                                        authResult.value = "メールアドレスの書式が違います";
                                      }
                                      if (result == authState.currentUser?.uid) {
                                        // Show snackbar
                                        const snackBar = SnackBar(
                                          content: Text("ログイン成功")
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
          
                                        context.goNamed("HomeScreen");
                                      }
                                    });
                                  },
                                  child: const Text("ログイン")
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade300,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    context.pushNamed("SignupScreen");
                                  },
                                  child: const Text("アカウントのない方", style: TextStyle(fontSize: 12),)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
