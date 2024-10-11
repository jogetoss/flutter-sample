import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/UI/Loading.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Utilities/Global.dart' as globals;

class APIBuilderSettings extends StatefulWidget {
  Key? key;
  APIBuilderSettings({this.key});
  @override
  _APIBuilderSettingsState createState() => _APIBuilderSettingsState();
}

class _APIBuilderSettingsState extends State<APIBuilderSettings> {
  TextEditingController apiIdTextField = TextEditingController();
  TextEditingController apiKeyTextField = TextEditingController();
  bool loading = false;
  loadApiIdAndApiKey() async {
    String? apiId = await getApiIdFromStorage();
    String? apiKey = await getApiKeyFromStorage();
    if (apiId == null || apiKey == null) {
      apiIdTextField.text = "";
      apiKeyTextField.text = "";
    } else {
      apiIdTextField.text = apiId;
      apiKeyTextField.text = apiKey;
    }
    setState(() {});
  }

  storeApiIdAndApiKey(String apiId, String apiKey) {
    setApiIdAndApiKeyToStorage(apiId, apiKey);
  }

  @override
  void initState() {
    super.initState();
    loadApiIdAndApiKey();
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
                Icon(
                  size: 90,
                  Icons.settings,
                  color: HexColor(globals.primaryColor),
                ),
                const SizedBox(height: 20),
                Text(
                  textScaler: const TextScaler.linear(2.1),
                  "API Builder",
                  style: TextStyle(
                      color: HexColor(globals.primaryColor),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    TextField(
                      selectionControls:
                          CustomColorSelectionHandle(Colors.grey),
                      controller: apiIdTextField,
                      decoration: const InputDecoration(
                        labelText: 'api_id',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      selectionControls:
                          CustomColorSelectionHandle(Colors.grey),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: apiKeyTextField,
                      decoration: const InputDecoration(
                        labelText: 'api_key',
                      ),
                    ),
                  ],
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
                      storeApiIdAndApiKey(apiIdTextField.text.trim(),
                          apiKeyTextField.text.trim());
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: HexColor(globals.primaryColor),
                          content: const Text("Credentials saved"),
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
          loading ? Loading() : const SizedBox()
        ],
      )),
    );
  }
}
