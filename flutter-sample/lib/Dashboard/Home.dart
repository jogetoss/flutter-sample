import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/Drawer/ProfileSection.dart';
import 'package:joget/App/AppCardGrid.dart';
import 'package:joget/Utilities/Global.dart' as globals;

class Home extends StatefulWidget {
  Key? key;
  Home({this.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String primaryColor = globals.primaryColor;
  String secondaryColor = globals.secondaryColor;

  @override
  void initState() {
    super.initState();
  }

  refreshHome() {
    setState(() {
      primaryColor = globals.primaryColor;
      secondaryColor = globals.secondaryColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: HexColor(secondaryColor),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 20.0, bottom: 20.0),
            child: Column(
              children: [
                ProfileSection(isApp: false),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: HexColor(primaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            children: [
              // Column(
              //   children: [
              //     Text(
              //       textScaler: TextScaler.linear(2.0),
              //       "Hello, Admin!",
              //       style: TextStyle(
              //         color: HexColor("#009265"),
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     SizedBox(
              //       height: 15,
              //     ),
              //     Badge(
              //       label: Text(
              //         "48",
              //       ),
              //       child: ElevatedButton(
              //         onPressed: () {},
              //         style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all(HexColor("#009265")),
              //           shape:
              //               MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10),
              //             ),
              //           ),
              //         ),
              //         child: const Icon(
              //           Icons.assignment,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: 40,
              //     ),
              //   ],
              // ),
              Expanded(
                child: AppCardGrid(
                  refreshHome: refreshHome,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
