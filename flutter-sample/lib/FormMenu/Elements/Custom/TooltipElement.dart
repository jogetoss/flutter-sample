import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:expandable/expandable.dart';

class TooltipElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  String value = "";
  TooltipElement({this.key, required this.id, required this.label});

  @override
  State<TooltipElement> createState() => _TooltipElementState();
}

class _TooltipElementState extends State<TooltipElement> {
  ExpandableController expandableController = ExpandableController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HtmlWidget(
              widget.label,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (expandableController.expanded == true) {
                      expandableController.expanded = false;
                    } else {
                      expandableController.expanded = true;
                    }
                  });
                },
                child: Text("Open"))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ExpandableNotifier(
          controller: expandableController,
          // <-- Provides ExpandableController to its children
          child: Column(
            children: [
              Expandable(
                  theme: ExpandableThemeData(
                    crossFadePoint: 0.0,
                  ),
                  // <-- Driven by ExpandableController from ExpandableNotifier
                  collapsed: SizedBox(),
                  expanded: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("there is no rule..."),
                    ],
                  )),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
    ;
  }
}
