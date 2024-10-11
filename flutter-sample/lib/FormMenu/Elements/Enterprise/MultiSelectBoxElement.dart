import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class MultiSelectBoxElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  MultiSelectBoxElement({this.key, required this.id, required this.label});

  @override
  State<MultiSelectBoxElement> createState() => _MultiSelectBoxElementState();
}

class Animal {
  final int? id;
  final String? name;

  Animal({
    this.id,
    this.name,
  });
}

class _MultiSelectBoxElementState extends State<MultiSelectBoxElement> {
  List<String> selectedOptions = [];

  static final List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];

  List<Animal> _selectedAnimals = [
    Animal(id: 1, name: "Lion"),
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
        MultiSelectDialogField(
          itemsTextStyle: const TextStyle(color: Colors.grey),
          selectedItemsTextStyle: const TextStyle(color: Colors.white),
          unselectedColor: Colors.transparent,
          selectedColor: Colors.grey,
          checkColor: Colors.red,
          backgroundColor: Colors.white,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          buttonIcon: const Icon(Icons.grid_view, color: Colors.grey),
          buttonText: const Text(""),
          separateSelectedItems: true,
          title: const SizedBox(),
          chipDisplay: MultiSelectChipDisplay(
            textStyle: const TextStyle(color: Colors.white),
            chipColor: Colors.grey,
            items: _selectedAnimals
                .map((e) => MultiSelectItem(e, e.name!))
                .toList(),
            onTap: (value) {
              setState(() {
                _selectedAnimals.remove(value);
              });
            },
          ),
          items: _animals.map((e) => MultiSelectItem(e, e.name!)).toList(),
          listType: MultiSelectListType.CHIP,
          onConfirm: (values) {
            setState(() {
              _selectedAnimals = values;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
