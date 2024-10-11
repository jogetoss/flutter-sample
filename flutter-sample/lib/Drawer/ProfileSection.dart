import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/Auth/Login.dart';
import 'package:joget/Dashboard/Home.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Configuration/Profile.dart';
import 'package:joget/Utilities/Global.dart' as globals;

class ProfileSection extends StatefulWidget {
  Key? key;
  bool isApp;
  ProfileSection({
    this.key,
    required this.isApp,
  });
  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  bool isUserLoggedIn = false;
  String? fullName;
  String? email;
  setNameAndEmail() async {
    isUserLoggedIn = await getIsUserLoggedIn();
    if (isUserLoggedIn == true) {
      fullName = await getFullNameFromStorage();
      email = await getEmailFromStorage();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    setNameAndEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/joget_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            isUserLoggedIn == true && widget.isApp == false
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Profile(setNameAndEmail: setNameAndEmail)),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: HexColor(globals.tertiaryColor),
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(
                        Icons.person,
                        color: HexColor(globals.secondaryColor),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          textScaler: const TextScaler.linear(1.4),
          fullName ?? "Visitor",
          style: TextStyle(color: HexColor(globals.tertiaryColor)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(
          height: 5,
        ),
        isUserLoggedIn == true
            ? Text(
                email ?? "",
                style: TextStyle(color: HexColor(globals.tertiaryColor)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            : const SizedBox(),
        const SizedBox(
          height: 30,
        ),
        isUserLoggedIn == true && widget.isApp == false
            ? SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(
                          HexColor(globals.secondaryColor))),
                  onPressed: () async {
                    await clearStorage();
                    Navigator.pushReplacement(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  child: const Text(
                    'Logout',
                  ),
                ),
              )
            : isUserLoggedIn == false && widget.isApp == false
                ? SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(
                              HexColor(globals.secondaryColor))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login(setNameAndEmail: setNameAndEmail)),
                        );
                      },
                      child: const Text(
                        'Login',
                      ),
                    ),
                  )
                : const SizedBox()
      ],
    );
  }
}
