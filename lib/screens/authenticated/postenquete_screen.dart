import 'package:anpi_report_flutter/providers/firebaseauth/auth_provider.dart';
import 'package:anpi_report_flutter/providers/firestore/notification/notification_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/userreport_notifier.dart';
import 'package:anpi_report_flutter/providers/geolocator/location_provider.dart';
import 'package:anpi_report_flutter/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/notification/notification.dart';
import '../../models/report/report.dart';
import '../../models/userreport.dart';
import '../../providers/bottomnav/bottomnav_provider.dart';
import '../../providers/firestore/notification/combined_notification_notifier.dart';

@RoutePage()
class PostEnqueteScreen extends HookConsumerWidget {
  final String notificationId;
  const PostEnqueteScreen({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNewReport = useState<bool>(true);
    final moiUid = useState<String>("");
    final moiReport = useState<UserReport?>(null);
    final isConfirmationChecked = useState<bool?>(false);
    final authAsyncValue = ref.watch(authStateChangesProvider);

    final currentNoti = useState<Noti?>(null);
    //
    final stepperCount = useState<int>(1);
    final injuryStatus = useState<int>(0);
    final attendOfficeStatus = useState<int>(0);
    final locationAddr = useState<String>("");
    final isChecked = useState<bool>(false);
    //
    final tFieldMessageController = useTextEditingController();
    // Provider watch
    final userReportNotifier = ref.watch(streamUserReportNotifierProvider.notifier);
    final notificationNotifier = ref.watch(streamNotificationNotifierProvider.notifier);

    // Hide the BottomNavBar when this screen is active
    useEffect(() {
      // Hide bottomnav
      Future.microtask(() {
        ref.read(bottomNavNotifierProvider.notifier).hide();
      });

      notificationNotifier.getNotificationByNotiId(notificationId).then((value) {
        currentNoti.value = value;
        debugPrint("currentNoti value: ${currentNoti.value}");

        // Get moiUid
        final user = authAsyncValue.asData?.value;
        if (user != null) {
          moiUid.value = user.uid;
          //debugPrint("moiUid: ${moiUid.value}");

          // Load injuryStatus
          userReportNotifier.getUserReportByUid(moiUid.value, notificationId).then((result) {
            if (result != null) {
              moiReport.value = result;
              //debugPrint("moiReport: ${moiReport.value}");
              // Apply moiReport.value to local states
              injuryStatus.value = moiReport.value!.reportContents["injuryStatus"] ?? 0;
              attendOfficeStatus.value = moiReport.value!.reportContents["attendOfficeStatus"] ?? 0;
              tFieldMessageController.text = moiReport.value!.reportContents["message"] ?? "";
              // Flag on
              isNewReport.value = false;
            }
          });

          // Load attendOfficeStatus
        }
      });

      // Clean up: Show bottomnav again when leaving this screen
      return () {
      };
    }, []);

    // Custom functions
    Future<void> getAddress() async {
      try {
        final address = await ref.read(geocodingControllerProvider.notifier).getCurrentAddress();
        locationAddr.value = "${address.prefecture}${address.city}${address.street}";
      } catch (err) {
        locationAddr.value = "Failed to get address: $err";
      }
    }

    // Custom Widgets
    Widget buildinjuryRadioCandidate(String label, int value) {
      return                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(label),
                          Radio(
                            value: value,
                            groupValue: injuryStatus.value,
                            onChanged: (value) {
                              injuryStatus.value = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
    }

    Widget buildattendOfficeRadioCandidate(String label, int value) {
      return                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(label),
                          Radio(
                            value: value,
                            groupValue: attendOfficeStatus.value,
                            onChanged: (value) {
                              attendOfficeStatus.value = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
    }

    Widget buildEnqueteWidget() {
      return SafeArea(
        child: Column(
                        children: [
      SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 4.0, // Adds shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding inside the card
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentNoti.value!.notiTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8), // Space for action buttons or metadata
                Text(currentNoti.value!.notiBody, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                const SizedBox(height: 12), // Space for action buttons or metadata
                // Enquete Contents
              ]
            ),
          )
        ),
      ),
      // Main slot
      Padding(
        padding: const EdgeInsets.all(8),
        child: (() {
          if (stepperCount.value == 1) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text("Page ${stepperCount.value.toString()} / 4"),
                  const Text("怪我の状態", style: TextStyle(fontSize: 24),),
                    
                  // Choice 1
                  buildinjuryRadioCandidate("無事", 1),
                  // Choice 2
                  buildinjuryRadioCandidate("怪我", 2),
                  // Choice 3
                  buildinjuryRadioCandidate("その他", 3),
                ],
              ),
            );
            //const Text("AAA", style: TextStyle(fontSize: 32),);
          } else if (stepperCount.value == 2) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text("Page ${stepperCount.value.toString()} / 4"),
                  const Text("出社の可否", style: TextStyle(fontSize: 24),),
                  // Choice 1
                  buildattendOfficeRadioCandidate("出社可", 1),
                  buildattendOfficeRadioCandidate("出社不可", 2),
                  buildattendOfficeRadioCandidate("出社済み", 3),
                ],
              )
            );
          } else if (stepperCount.value == 3) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text("Page ${stepperCount.value.toString()} / 4"),
                  const Text("メッセージを残す（任意）", style: TextStyle(fontSize: 24),),
                  CustomTextFormField(
                    hintText: "メッセージ",
                    controller: tFieldMessageController,
                    autofocus: true,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    enabledBorder: const UnderlineInputBorder(),
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(),
                    /* validator: (String? value) {
                  
                    }, */
                  )
                ],
              ),
            );
          } else if (stepperCount.value == 4) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text("Page ${stepperCount.value.toString()} / 4"),
                  const Text("位置情報の取得", style: TextStyle(fontSize: 24),),
                  isChecked.value ? Text("位置情報: ${locationAddr.value}") : const Text(""),

                  Material(
                    elevation: 10.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text("位置情報取得を許可する"),
                          Checkbox(
                            value: isChecked.value,
                            onChanged: (value) async {
                              isChecked.value = value!;
                                
                              if (isChecked.value) {
                                // When checkbox is checked, get current address
                                await getAddress();
                              } else {
                                locationAddr.value = "";
                              }
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            );
          }
        })(),
      ),
      // Page manipulation buttons (prev, next)
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: (() {
                if (stepperCount.value >= 2) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                    ),
                    onPressed: () {
                      if (stepperCount.value >= 2) {
                        stepperCount.value -= 1;
                      } else {
                        return;
                      }
                    },
                    child: const Text("前へ"),
                  );
                }
              })()
            ),
            const SizedBox(width: 16,),
            Container(
              child: (() {
                if (stepperCount.value <= 3) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                    ),
                    onPressed: () {
                      if (stepperCount.value <= 3) {
                        stepperCount.value += 1;
                      } else {
                        return;
                      }
                    },
                    child: const Text("次へ"),
                  );
                }
              })()
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: (() {
          if (stepperCount.value == 4) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[300],
                        foregroundColor: Colors.white,
                        elevation: 8,
                      ),
                      onPressed: isChecked.value && locationAddr.value == ""
                        ? null
                        : () async {
                        // Send report
                        //debugPrint("locationAddr: ${locationAddr.value.toString()}");
                          
                        if (isNewReport.value == true) {
                        // Build newReport
                        final DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(moiUid.value);
                        final DocumentReference profileRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(moiUid.value)
                          .collection("profiles")
                          .doc(moiUid.value);

                          final newreport = UserReport(
                            uid: moiUid.value,
                            notificationId: notificationId,
                            reportContents: {
                              "injuryStatus": injuryStatus.value,
                              "attendOfficeStatus": attendOfficeStatus.value,
                              "location": isChecked.value ? locationAddr.value : "",
                              "message": tFieldMessageController.text,
                              "isConfirmed": true,
                            },
                            userRef: userRef,
                            profileRef: profileRef,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          
                          await userReportNotifier.addUserReport(
                            notificationId,
                            moiUid.value,
                            newreport,
                          );
                        } else {
                          final updates = {
                            "uid": moiUid.value,
                            "reportContents": {
                              "injuryStatus": injuryStatus.value,
                              "attendOfficeStatus": attendOfficeStatus.value,
                              "location": isChecked.value ? locationAddr.value : "",
                              "message": tFieldMessageController.text,
                              "isConfirmed": true,
                            },
                            "updatedAt": DateTime.now(),
                          };
                          await userReportNotifier.updateUserReport(
                            notificationId,
                            moiUid.value,
                            updates,
                          );
                        }
                          
                          
                        // Go back to AppHome
                        if (context.mounted) {
                          ref.read(bottomNavNotifierProvider.notifier).show();
                          context.router.replaceAll([const AppHomeRoute()]);
                        }
                      },
                      child: // Wait until locationAddr if checked
                        const Text("送信") // kakuninn button?
                    ),
                  ),
                ],
              ),
            );
          }
        })(),
      )
                        ],
                      ),
                    );
    }

    Widget buildConfirmationWidget() {
      return SafeArea(
        child: Column(
                        children: [
      SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 4.0, // Adds shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding inside the card
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentNoti.value!.notiTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8), // Space for action buttons or metadata
                Text(currentNoti.value!.notiBody, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                const SizedBox(height: 12), // Space for action buttons or metadata
                // Enquete Contents
              ]
            ),
          )
        ),
      ),
      // Empty container for padding
      /* Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            child: const Text(""),
          ),
        ),
      ), */
      // Main slot
      (() {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("確認しました"),
                Checkbox(
                  value: isConfirmationChecked.value,
                  onChanged: (value) {
                    isConfirmationChecked.value = value;
                  }
                ),
              ],
            ),
          );
      })(),
      // Submit button
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[300],
                                foregroundColor: Colors.white,
                                elevation: 8,
                              ),
                onPressed: !isConfirmationChecked.value! ? null : () async {
                        if (isNewReport.value == true) {
                        // Build newReport
                        final DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(moiUid.value);
                        final DocumentReference profileRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(moiUid.value)
                          .collection("profiles")
                          .doc(moiUid.value);

                          final newreport = UserReport(
                            uid: moiUid.value,
                            notificationId: notificationId,
                            reportContents: {
                              "isConfirmed": isConfirmationChecked.value!,
                            },
                            userRef: userRef,
                            profileRef: profileRef,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
              
                          await userReportNotifier.addUserReport(
                            notificationId,
                            moiUid.value,
                            newreport,
                          );
                        } else {
                          final updates = {
                            "uid": moiUid.value,
                            "reportContents": {
                              "isConfirmed": isConfirmationChecked.value!,
                            },
                            "updatedAt": DateTime.now(),
                          };
                          await userReportNotifier.updateUserReport(
                            notificationId,
                            moiUid.value,
                            updates,
                          );
                        }
              
              
                        // Go back to AppHome
                        if (context.mounted) {
                          // Invalidate list
                          ref.read(bottomNavNotifierProvider.notifier).show();
                          ref.invalidate(streamNotificationCombinedNotifierProvider(moiUid.value));

                          context.router.replaceAll([const AppHomeRoute()]);
                        }
              
              }, child: const Text("送信")),
            ),
          ],
        ),
      ),
                        ],
                      ),
                    );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (context.mounted) {
                  //
                  ref.read(bottomNavNotifierProvider.notifier).show();
                  context.router.back();
                }
              },
            ),
            centerTitle: true,
            title: const Text("Anpi"),
            backgroundColor: Colors.purple[300],
          ),
          body: 
            currentNoti.value != null
            ?
            (() {
              if (currentNoti.value!.notiType == 1) {
                return buildEnqueteWidget();
              } else if (currentNoti.value!.notiType == 2) {
                return buildConfirmationWidget();
              }
            })()
            :
            const Center(
              child: CircularProgressIndicator(),
            ),
            // confirmation : notiType == 2
        ),
    );
  }
}
