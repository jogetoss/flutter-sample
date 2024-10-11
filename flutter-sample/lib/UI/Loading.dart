import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  Key? key;
  Loading({this.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withOpacity(0.8),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Center(
            child: SizedBox(
                height: 60.0,
                width: 60.0,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 8.0))));
  }
}
