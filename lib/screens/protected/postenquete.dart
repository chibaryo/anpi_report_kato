import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/geolocator/location_provider.dart';

class PostEnqueteScreen extends HookConsumerWidget {
  const PostEnqueteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
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
        body: Container(
          child: const Text("foo"),
        ),
    );
  }
}
