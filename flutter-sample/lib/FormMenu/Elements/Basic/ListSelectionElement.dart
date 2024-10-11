import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ListSelectionElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  String value = "";
  List<String> options;
  ListSelectionElement(
      {this.key, required this.id, required this.label, required this.options});

  @override
  State<ListSelectionElement> createState() => _ListSelectionElementState();
}

class _ListSelectionElementState extends State<ListSelectionElement> {
  List<String> items = [];
  List<bool> checked = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    items = widget.options;
    checked = List<bool>.filled(items.length, false);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        items[index],
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      child: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(
                                width: 2.0, color: Colors.grey),
                          ),
                          activeColor: Colors.grey,
                          value: checked[index],
                          onChanged: (newValue) {
                            setState(() {
                              checked[index] = newValue!;
                            });
                          },
                        ),
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
