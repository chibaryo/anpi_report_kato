
import 'package:anpi_report_flutter/providers/firestore/templates/template_notifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/firestoreuser.dart';
import '../../../models/profile.dart';
import '../../../providers/bottomnav/bottomnav_provider.dart';
import '../../../providers/firebaseauth/auth_provider.dart';
import '../../../providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import '../../../providers/firestore/profile/profile_notifier.dart';

@RoutePage()
class TemplateAdminScreen extends HookConsumerWidget {
  const TemplateAdminScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moiUid = useState<String>("");
    final moiProfile = useState<Profile?>(null);
    final moiUser = useState<FirestoreUser?>(null);
    final isLoading = useState<bool>(true); // Track loading status

    final authAsyncValue = ref.watch(authStateChangesProvider);
    final asyncTemplates = ref.watch(streamTemplateNotifierProvider);
    final profileNotifier = ref.watch(streamProfileNotifierProvider.notifier);
    final userNotifier = ref.watch(streamUserNotifierProvider.notifier);

    useEffect(() {
      // Hide bottomnav
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      // Clean up: Show bottomnav again when leaving this screen
      return () {
      };
    }, []);

    useEffect(() {
      final user = authAsyncValue.asData?.value;
      if (user != null) {
        moiUid.value = user.uid;
        debugPrint("moiUid: ${moiUid.value}");

        // Get profile by uid
        profileNotifier.getProfileByUid(moiUid.value).then((profile) {
          moiProfile.value = profile;

          // Get user by uid
          userNotifier.getUserByUid(moiUid.value).then((firestoreUser) {
            moiUser.value = firestoreUser;
          });
        });
      }

      return () {};
    }, [authAsyncValue]);

    // Load templates from DB
    useEffect(() {

      isLoading.value = false;
    }, [asyncTemplates]);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (context.mounted) {
                //
                ref.read(bottomNavNotifierProvider.notifier).show();
                context.router.maybePop();
              }
            },
          ),
          centerTitle: true,
          title: const Text("Anpi"),
          backgroundColor: Colors.purple[300],
        ),
        body: isLoading.value
    ? const Center(child: CircularProgressIndicator())
    : switch (asyncTemplates) {
        AsyncData(:final value) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(
                    label: Text("Title")
                  ),
                  DataColumn(
                    label: Text("Body")
                  ),
                ],
                rows: value.map<DataRow>((template) {
                  // template is already a Template object
                  return DataRow(
                    onSelectChanged: (bool? selected) async {
                      if (selected != null && selected) {
                        // Add your navigation or selection logic here
                      }
                    },
                    cells: [
                      DataCell(Text(template.notiTitle)), // Access Template properties directly
                      DataCell(Text(template.notiBody)),
                    ]
                  );
                }).toList(),
              )
            ],
          ),
        ),
        AsyncError(:final error) => Center(child: Text('エラーが発生しました: ${error.toString()}')),
        _ => const Center(child: CircularProgressIndicator()),
      }
    );
  }
}
