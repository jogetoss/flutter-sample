import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/Utilities/API.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/UI/Loading.dart';

class Profile extends StatefulWidget {
  Key? key;
  Function setNameAndEmail;
  Profile({this.key, required this.setNameAndEmail});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController usernameTextField = TextEditingController();
  TextEditingController firstNameTextField = TextEditingController();
  TextEditingController lastNameTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  String selectedTimeZone = "-12";
  bool loading = false;
  Map<String, dynamic>? userProfile;
  loadUserProfile() async {
    setState(() {
      loading = true;
    });
    userProfile = await getUserByUsername();
    usernameTextField.text = userProfile!['username'] ?? "";
    firstNameTextField.text = userProfile!['firstName'] ?? "";
    lastNameTextField.text = userProfile!['lastName'] ?? "";
    emailTextField.text = userProfile!['email'] ?? "";
    selectedTimeZone = userProfile!['timeZone'] ?? "";
    setState(() {
      loading = false;
    });
  }

  Future storeUserProfile() async {
    setState(() {
      loading = true;
    });
    Map<String, dynamic> updatedUserProfile = {
      "id": userProfile!['id'] ?? "",
      "firstName": firstNameTextField.text,
      "lastName": lastNameTextField.text,
      "email": emailTextField.text,
      "timeZone": selectedTimeZone,
    };
    await updateUser(updatedUserProfile);
    setState(() {
      loading = false;
    });
    widget.setNameAndEmail();
  }

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: HexColor("#009265"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textScaler: const TextScaler.linear(2.1),
                        "Profile",
                        style: TextStyle(
                          color: HexColor("#009265"),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    style: const TextStyle(color: Colors.grey),
                    selectionControls: CustomColorSelectionHandle(Colors.grey),
                    controller: usernameTextField,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    selectionControls: CustomColorSelectionHandle(Colors.grey),
                    controller: firstNameTextField,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    selectionControls: CustomColorSelectionHandle(Colors.grey),
                    controller: lastNameTextField,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    selectionControls: CustomColorSelectionHandle(Colors.grey),
                    controller: emailTextField,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    iconEnabledColor: Colors.grey,
                    isExpanded: true,
                    value: selectedTimeZone,
                    items: const [
                      DropdownMenuItem(
                        value: '0',
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.normal),
                            '(GMT  00:00) Casablanca, Dublin, Edinburgh, London, Lisbon, Monrovia'),
                      ),
                      DropdownMenuItem(
                        value: '-12',
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.normal),
                            '(GMT -12:00) Eniwetok, Kwajalein'),
                      ),
                      DropdownMenuItem(
                        value: '-10',
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.normal),
                            '(GMT -10:00) Hawaii'),
                      ),
                      DropdownMenuItem(
                        value: '-4',
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.normal),
                            '(GMT -04:00) Atlantic Time (Canada), Caracas, La Paz'),
                      ),
                      DropdownMenuItem(
                        value: '-9',
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.normal),
                            '(GMT -09:00) Alaska'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedTimeZone = value.toString();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Time Zone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(HexColor("#009265")),
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.white)),
                      onPressed: () async {
                        await storeUserProfile();
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: HexColor("#009265"),
                            content: const Text("Profile updated"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        'Save',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading == true ? Loading() : const SizedBox()
        ],
      ),
    );
  }
}
