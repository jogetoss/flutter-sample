import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  Key? key;
  int rowsPerPage;
  List<String> pages;
  Function changePagination;
  Pagination(
      {this.key,
      required this.rowsPerPage,
      required this.pages,
      required this.changePagination});
  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  int x = 0;
  @override
  void initState() {
    super.initState();
    x = widget.rowsPerPage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
        isDense: true,
        iconEnabledColor: Colors.grey,
        isExpanded: true,
        borderRadius: BorderRadius.circular(10),
        underline: Container(),
        padding: const EdgeInsets.all(15.0),
        hint: Text(
          style: const TextStyle(color: Colors.black),
          x.toString(),
        ),
        onChanged: (value) {
          setState(() {
            x = int.parse(value!);
          });
          widget.changePagination(int.parse(value!), 0);
        },
        items: widget.pages.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(
              val,
            ),
          );
        }).toList(),
      ),
    );
  }
}
