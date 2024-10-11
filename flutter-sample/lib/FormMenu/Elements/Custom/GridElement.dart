import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joget/Utilities/Functions.dart';

class GridElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  List<String> columnNames;

  GridElement(
      {this.key,
      required this.id,
      required this.label,
      required this.columnNames});

  @override
  State<GridElement> createState() => _GridElementState();
}

class _GridElementState extends State<GridElement> {
  List<DataRow> rows = [];

  void _addRow() {
    setState(() {
      LocalKey rowKey = UniqueKey();
      List<DataCell> cells = [];
      for (int i = 0; i < widget.columnNames.length; i++) {
        cells.add(DataCell(
          TextField(
            selectionControls: CustomColorSelectionHandle(Colors.grey),
            decoration: const InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            controller: TextEditingController(),
          ),
        ));
      }
      cells.add(DataCell(
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            _deleteRow(rowKey);
          },
        ),
      ));
      rows.add(DataRow(
        key: rowKey,
        cells: cells,
      ));
    });
  }

  void _deleteRow(Key rowKey) {
    setState(() {
      rows.removeWhere((row) => row.key == rowKey);
    });
  }

  List<Map<String, String>> getTableData() {
    List<Map<String, String>> tableData = [];
    for (var row in rows) {
      Map<String, String> rowData = {};
      for (int i = 0; i < row.cells.length - 1; i++) {
        String cellData = (row.cells[i].child as TextField).controller!.text;
        rowData[widget.columnNames[i]] = cellData;
      }
      tableData.add(rowData);
    }
    return tableData;
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 210),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 1.0),
                    child: DataTable(
                      dataRowMaxHeight: 50,
                      headingRowHeight: 50,
                      border: TableBorder.all(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        width: 1.0,
                        color: Colors.grey,
                      ),
                      columns: [
                        for (var columnName in widget.columnNames)
                          DataColumn(
                              label: Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              columnName,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                        const DataColumn(label: Text('')),
                      ],
                      rows: rows,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton.filled(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                _addRow();
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
