import 'package:flutter/material.dart';
import 'package:joget/App/AppCard.dart';

class AppCardGrid extends StatefulWidget {
  Key? key;
  Function refreshHome;
  AppCardGrid({this.key, required this.refreshHome});

  @override
  _AppCardGridState createState() => _AppCardGridState();
}

class _AppCardGridState extends State<AppCardGrid> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int crossAxisCount = (constraints.maxWidth / 250).floor();
        List<Widget> boxes = [
          AppCard(
            imageUrl: "crm.png",
            refreshHome: widget.refreshHome,
            apiId: 'API-5bfff34e-d770-42c2-8eef-28b3b45ece63',
            appName: 'Customer Relationship Management',
          ),
          AppCard(
            imageUrl: "isr_icon.png",
            refreshHome: widget.refreshHome,
            apiId: 'API-9479bf51-4e81-47c8-8474-1b6a7c703d5c',
            appName: 'Internal Service Request',
          ),
        ];
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridView.count(
            crossAxisSpacing: 19,
            mainAxisSpacing: 19,
            crossAxisCount: crossAxisCount,
            children: List.generate(boxes.length, (index) {
              return boxes[index];
            }),
          ),
        );
      },
    );
  }
}
