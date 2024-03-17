import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class RootScreen extends HookConsumerWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect(() {
      return () {};
    }, const []);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Root"),
          backgroundColor: Colors.lime,
        ),
//        drawer: const NavContents(),
        body: Center(
          child: Column(
            children: [
              const Text(
                'Root',
                style: TextStyle(fontSize: 32.0),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown.shade500,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            context.goNamed("LoginScreen");
                          },
                          child: const Text("ログイン")),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
