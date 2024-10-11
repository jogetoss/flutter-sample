import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/App/App.dart';
import 'package:joget/Utilities/Global.dart' as globals;

class AppCard extends StatefulWidget {
  Key? key;
  String appName;
  String apiId;
  Function refreshHome;
  String imageUrl;
  AppCard(
      {this.key,
      required this.appName,
      required this.apiId,
      required this.refreshHome,
      required this.imageUrl});
  @override
  _AppCardState createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    animation = Tween<double>(begin: 1.0, end: 0.9).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  startTapAnimation() async {
    await controller.forward();
    await controller.reverse();
  }

  String primaryColor = globals.primaryColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await startTapAnimation();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => App(
              appName: widget.appName,
              apiId: widget.apiId,
            ),
          ),
        ).then((value) {
          setState(() {
            globals.primaryColor = "#009265";
            globals.secondaryColor = "#03543D";
            globals.tertiaryColor = "#FFFFFF";
            primaryColor = globals.primaryColor;
          });
          widget.refreshHome;
        });
      },
      child: Transform.scale(
        scale: animation.value,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: HexColor(primaryColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  width: 120,
                  'assets/images/${widget.imageUrl}',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.white)))),
              const SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  widget.appName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
