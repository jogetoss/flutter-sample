import 'package:flutter/material.dart';
import 'package:joget/Auth/Start.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Dashboard/Home.dart';
import 'package:joget/Utilities/Global.dart' as globals;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(Joget());
}

class Joget extends StatefulWidget {
  Key? key;
  Joget({this.key});
  @override
  State<Joget> createState() => _JogetState();
}

class _JogetState extends State<Joget> {
  bool isUserLoggedIn = false;
  checkIsUserLoggedIn() async {
    bool isUserLoggedIn = await getIsUserLoggedIn();
    setState(() {
      this.isUserLoggedIn = isUserLoggedIn;
    });
  }

  @override
  void initState() {
    super.initState();
    globals.primaryColor = "#009265";
    globals.secondaryColor = "#03543D";
    globals.tertiaryColor = "#FFFFFF";
    setApiIdAndApiKeyToStorage("API-0f6e9f1f-6e1d-4e9e-9bd2-fb34c67b2696",
        "cc232101f3cc4f6a842abb4b52461e0f");
    setAccountUrlToStorage("marshall1995.on.joget.cloud");
    checkIsUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            textStyle: const MaterialStatePropertyAll(
                TextStyle(fontWeight: FontWeight.bold)),
            overlayColor: const MaterialStatePropertyAll(
                Color.fromRGBO(158, 158, 158, 0.1)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            minimumSize: const MaterialStatePropertyAll(Size.zero),
            padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
          )),
          inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              contentPadding: const EdgeInsets.all(15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0)),
              labelStyle: const TextStyle(
                color: Colors.grey,
              )),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.grey,
            selectionColor: Color.fromRGBO(158, 158, 158, 0.5),
          )),
      debugShowCheckedModeBanner: false,
      home: isUserLoggedIn == true ? Home() : Start(),
    );
  }
}
