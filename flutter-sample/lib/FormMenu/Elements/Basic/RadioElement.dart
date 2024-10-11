import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class RadioElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  String value = "";
  List<String> options;
  RadioElement(
      {this.key, required this.id, required this.label, required this.options});

  @override
  State<RadioElement> createState() => _RadioElementState();
}

class _RadioElementState extends State<RadioElement> {
  String? selectedOption;
  List<String> items = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    items = widget.options;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlWidget(
          widget.label,
          textStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 150,
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SizedBox(
                      child: Transform.scale(
                        scale: 1.2,
                        child: Radio(
                          fillColor:
                              const MaterialStatePropertyAll(Colors.grey),
                          activeColor: Colors.grey,
                          value: items[index],
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        items[index],
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
