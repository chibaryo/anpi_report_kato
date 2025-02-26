import 'package:anpi_report_flutter/entity/userattr/joblevel.dart';
import 'package:anpi_report_flutter/entity/userattr/office_location.dart';
import 'package:anpi_report_flutter/providers/firestore/firestoreuser/firestoreuser_notifier.dart';
import 'package:anpi_report_flutter/providers/firestore/profile/profile_notifier.dart';
import 'package:anpi_report_flutter/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../entity/userattr/department.dart';
import '../../models/deviceinfo.dart';
import '../../models/firestoreuser.dart';
import '../../models/profile.dart';
import '../../providers/firestore/deviceinfo/deviceinfo_notifier.dart';
import '../../repository/firebase/authrepo.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
//import 'package:dropdown_button2/dropdown_button2.dart';

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
    //
    final tFieldUserNameController = useTextEditingController();
/*    const targetCompanyCode = "C1040090==";
    final tFieldCompanyCodeController = useTextEditingController();
    final isValidCompanyCode = useListenableSelector(
      tFieldCompanyCodeController,
      () => tFieldCompanyCodeController.text == targetCompanyCode
    );
*/ 

    // ChoiceChip
    final selectedDepartments = useState<int>(DepartmentType.undefined.sortNumber); // Initially "未設定"
    final selectedOffice = useState<int>(OfficeLocationStatusType.undefined.sortNumber);
    final selectedJobLevel = useState<int>(JobLevelStatusType.undefined.sortNumber);

    const departmentOptions = DepartmentType.values;
    final isUndefinedSelected = useState<bool>(true); // Tracks if "undefined" is selected

    void toggleDepartmentSelection(DepartmentType department) {
      final sortNumber = department.sortNumber;

      if (sortNumber == DepartmentType.undefined.sortNumber) {
        // Toggle "undefined" state
        if (isUndefinedSelected.value) {
          selectedDepartments.value = 0;
          isUndefinedSelected.value = false;
        } else {
          selectedDepartments.value = 0;
          isUndefinedSelected.value = true;
        }
      } else {
        if (selectedDepartments.value & sortNumber == sortNumber) {
          // If already selected, unselect it
          selectedDepartments.value &= ~sortNumber;
        } else {
          // If "undefined" is currently selected, remove it
          if (isUndefinedSelected.value) {
            selectedDepartments.value = 0;
            isUndefinedSelected.value = false;
          }
          // Add the department to selection
          selectedDepartments.value |= sortNumber;
        }
      }

      // Ensure "undefined" is selected if no other departments are selected
      if (selectedDepartments.value == 0) {
        isUndefinedSelected.value = true;
      }
    }

    // Adjust the initial state to only select '未設定' at the start
/*    useEffect(() {
      selectedDepartments.value = DepartmentType.undefined.sortNumber;
      return null;
    }, []); */

/*
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
*/

// Helper method to get options for DropdownButton
List<DropdownMenuItem<int>> getJobLevelDropdownItems() {
  return JobLevelStatusType.values
      .map((location) => DropdownMenuItem<int>(
            value: location.sortNumber,
            child: Text(location.displayName),
          ))
      .toList();
}

// Helper method to get options for DropdownButton
List<DropdownMenuItem<int>> getOfficeLocationDropdownItems() {
  return OfficeLocationStatusType.values
      .map((location) => DropdownMenuItem<int>(
            value: location.sortNumber,
            child: Text(location.displayName),
          ))
      .toList();
}

// Helper function to get a list of selected departments
List<String> getSelectedDepartments(int selectedSum) {
  // Get a list of selected departments
  List<String> selectedDepartments = DepartmentType.values
      .where((department) => (selectedSum & department.sortNumber) == department.sortNumber)
      .map((department) => department.displayName)
      .toList();

  // If selectedSum includes departments other than "undefined", return those departments
  if (selectedSum != 0 && selectedDepartments.isNotEmpty) {
    return selectedDepartments.where((name) => name != '未設定').toList();
  }

  // If only "undefined" is selected or no other departments are selected, return "undefined" only
  return selectedDepartments.isEmpty ? ['未設定'] : selectedDepartments;
}

  Widget buildJobLevelDropDown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<int>(
        value: selectedJobLevel.value,
        onChanged: (int? newValue) {
          if (newValue != null) {
            selectedJobLevel.value = newValue;
            debugPrint("selectedJobLevel.value: ${selectedJobLevel.value}");
          }
        },
        items: getJobLevelDropdownItems(),
        decoration: const InputDecoration(
          labelText: 'Select jobLevel',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildOfficeLocationDropDown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<int>(
        value: selectedOffice.value,
        onChanged: (int? newValue) {
          if (newValue != null) {
            selectedOffice.value = newValue;
            debugPrint("selectedOffice.value: ${selectedOffice.value}");
          }
        },
        items: getOfficeLocationDropdownItems(),
        decoration: const InputDecoration(
          labelText: 'Select Office Location',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

    Widget buildDepsChoiceChips() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: departmentOptions.map((department) {
                  final isSelected = department.sortNumber == DepartmentType.undefined.sortNumber
                      ? isUndefinedSelected.value
                      : (selectedDepartments.value & department.sortNumber) == department.sortNumber;
        
                  return ChoiceChip(
                    label: Text(department.displayName),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      toggleDepartmentSelection(department);
                    },
                  );
                }).toList(),
          ),
      );
    }

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
/*                          FormBuilderTextField(
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
                          ), */
                          // Email
                          CustomTextFormField(
                            hintText: "名前",
                            controller: tFieldUserNameController,
                            autofocus: true,
                            padding: const EdgeInsets.all(8.0),
                            enabledBorder: const UnderlineInputBorder(),
                            autocorrect: false,
                            border: const UnderlineInputBorder(),
                            focusedBorder: const UnderlineInputBorder(),
                            validator: (String? value) => Validations.emptyValidation(value),
                          ),
                          FormBuilderTextField(
                            name: "email",
                            decoration: const InputDecoration(labelText: "メールアドレス"),
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
                          buildDepsChoiceChips(),
                          const SizedBox(height: 16),
                          Text('Selected department sum (bitwise): ${selectedDepartments.value}'),
                          Text('Selected Departments: ${getSelectedDepartments(selectedDepartments.value).join(", ")}'),
                          buildOfficeLocationDropDown(),
                          buildJobLevelDropDown(),
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
                                    //!isValidCompanyCode ? null :
                                    onPressed: () async {
                                      formKey.currentState?.saveAndValidate();
                                      //
                                      final displayName = tFieldUserNameController.text;
                                      //final displayName = formKey.currentState?.value["username"];
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
                                            "officeLocation": selectedOffice.value,
                                            "jobLevel": selectedJobLevel.value,
                                            "department": selectedDepartments.value,
                                          },
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                        );
                                        await profileNotifier.addProfile(result, newProfile);

                                        // Update cachestatus
                                        await FirebaseFirestore.instance
                                          .collection("cachestatus").doc("users").set({
                                            'updatedAt': DateTime.now(),
                                        });
                                        debugPrint("updated cache date");

                                        if (context.mounted) {
                                          context.router.replace(const TabsRouterRoute());
                                        }
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
