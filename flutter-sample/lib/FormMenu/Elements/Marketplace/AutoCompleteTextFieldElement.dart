import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joget/Utilities/Functions.dart';

class AutoCompleteTextFieldElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  AutoCompleteTextFieldElement({
    this.key,
    required this.id,
    required this.label,
  });

  @override
  State<AutoCompleteTextFieldElement> createState() =>
      _AutoCompleteTextFieldElementState();
}

class _AutoCompleteTextFieldElementState
    extends State<AutoCompleteTextFieldElement> {
  final List<String> options = [
    'Apple',
    'Apricot',
    'Avocado',
    'Almond',
    'Artichoke',
    'Grape',
    'Grapefruit',
    'Lemon',
    'Lettuce',
    'Lime',
    'Lychee',
    'Lavender',
    'Lemonade',
    'Linguine',
    'Lobster',
    'Lollipop',
    'Elderberry',
    'Eggplant',
    'Edamame',
    'Tomato',
  ];

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
        Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isNotEmpty) {
              if (textEditingValue.text.length > 1) {
                return options
                    .where((option) => option
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase()))
                    .toList();
              } else {
                return options
                    .where((option) =>
                        option.toLowerCase()[0] ==
                        textEditingValue.text.toLowerCase()[0])
                    .toList();
              }
            } else {
              return [];
            }
          },
          onSelected: (String selected) {},
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              selectionControls: CustomColorSelectionHandle(Colors.grey),
              controller: textEditingController,
              focusNode: focusNode,
            );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight:
                          options.length > 3 ? 3 * 57 : options.length * 57),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        shape: const Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
