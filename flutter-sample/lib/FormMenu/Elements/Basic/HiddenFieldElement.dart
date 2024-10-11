import 'package:flutter/material.dart';

class HiddenFieldElement extends StatefulWidget {
  Key? key;
  String className;
  String id;
  String value;
  HiddenFieldElement({
    this.key,
    required this.className,
    required this.id,
    required this.value,
  });
  @override
  State<HiddenFieldElement> createState() => _HiddenFieldElementState();
}

class _HiddenFieldElementState extends State<HiddenFieldElement> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
