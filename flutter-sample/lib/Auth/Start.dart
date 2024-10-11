import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/Utilities/API.dart';
import 'package:joget/Dashboard/Home.dart';
import 'package:joget/Configuration/APIBuilderSettings.dart';
import 'package:joget/UI/Loading.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Utilities/Global.dart' as globals;

class Start extends StatefulWidget {
  Key? key;
  Start({this.key});
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  TextEditingController accountUrlTextField = TextEditingController();
  bool loading = false;
  loadAccountUrl() async {
    String? accountUrl = await getAccountUrlFromStorage();
    accountUrlTextField.text = accountUrl!;
  }

  @override
  void initState() {
    super.initState();
    loadAccountUrl();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => APIBuilderSettings()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: HexColor(globals.primaryColor),
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.settings,
                          color: HexColor(globals.tertiaryColor),
                        ),
                      ),
                    )
                  ],
                ),
                Column(children: [
                  SizedBox(
                    width: 90,
                    child: Image.asset('assets/images/joget_logo.png'),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    selectionControls: CustomColorSelectionHandle(Colors.grey),
                    controller: accountUrlTextField,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'Account URL',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              HexColor(globals.primaryColor)),
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.white)),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        bool accountUrlValid = await isAccountUrlValid(
                            accountUrlTextField.text.trim());
                        if (accountUrlValid) {
                          bool apiIdAndApiKeyValid =
                              await isApiIdAndApiKeyValid();
                          setState(() {
                            loading = false;
                          });
                          if (apiIdAndApiKeyValid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Home()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Invalid api_id or api_key"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Invalid account URL"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Start',
                      ),
                    ),
                  ),
                ]),
                const Row(
                  children: [],
                )
              ],
            ),
          ),
          loading == true ? Loading() : const SizedBox()
        ],
      )),
    );
  }
}
