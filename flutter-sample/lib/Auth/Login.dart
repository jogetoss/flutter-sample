import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/Utilities/API.dart';
import 'package:joget/UI/Loading.dart';
import 'package:joget/Utilities/Functions.dart';

class Login extends StatefulWidget {
  Key? key;
  Function setNameAndEmail;
  Login({this.key, required this.setNameAndEmail});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 90,
                  child: Image.asset('assets/images/joget_logo.png'),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    TextField(
                      selectionControls:
                          CustomColorSelectionHandle(Colors.grey),
                      controller: usernameTextField,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'Username',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      selectionControls:
                          CustomColorSelectionHandle(Colors.grey),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordTextField,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelText: 'Password',
                      ),
                    ),
                  ],
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
                      setState(() {
                        loading = true;
                      });
                      bool usernameAndPasswordValid =
                          await isUsernameAndPasswordValid(
                              usernameTextField.text.trim(),
                              passwordTextField.text.trim());
                      widget.setNameAndEmail();
                      setState(() {
                        loading = false;
                      });
                      if (usernameAndPasswordValid) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Invalid username or password"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Login',
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading ? Loading() : const SizedBox()
        ],
      )),
    );
  }
}
