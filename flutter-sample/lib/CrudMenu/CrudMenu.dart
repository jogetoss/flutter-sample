import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/Utilities/API.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/CrudMenu/Filters/TextFilter.dart';
import 'package:joget/CrudMenu/Filters/DropdownFilter.dart';
import 'package:joget/CrudMenu/Filters/Pagination.dart';
import 'package:joget/Utilities/Global.dart' as globals;

class CrudMenu extends StatefulWidget {
  final Key? key;
  String apiId;
  String datalistId;
  bool showDeleteButton;
  bool showNewButton;

  CrudMenu({
    this.key,
    required this.apiId,
    required this.datalistId,
    required this.showDeleteButton,
    required this.showNewButton,
  });
  @override
  State<CrudMenu> createState() => _CrudMenuState();
}

class _CrudMenuState extends State<CrudMenu> {
  bool loading = false;
  Map<String, dynamic> datalistDefinition = {};
  Map<String, dynamic> datalist = {};
  List<DataColumn> columns = [];
  List<DataRow> rows = [];
  int? sortColumnIndex;
  bool sortAscending = true;
  List<DataColumn> originalColumns = [];
  List<DataRow> originalRows = [];
  List<TextFilter> textFilters = [];
  List<DropdownFilter> dropdownFilters = [];
  List<Widget> combinedFilters = [];
  List<String> rowActions = [];
  List<String> actions = [];
  setupFilters() {
    textFilters.clear();
    dropdownFilters.clear();
    combinedFilters.clear();
    datalistDefinition['actions'].forEach((action) {
      actions.add(action['properties']['label']);
    });
    pages = datalistDefinition['pageSizeSelectorOptions'].split(',').toList();
    datalistDefinition['rowActions'].forEach((rowAction) {
      rowActions.add(rowAction['properties']['label']);
    });
    datalistDefinition['filters'].forEach((filter) {
      if (filter['type'] != null) {
        if (filter['type']['properties']['options'].toString() != '[]' &&
            filter['type']['properties']['options'] != null) {
          dropdownFilters.add(DropdownFilter(
              columnName: '',
              label: filter['name'],
              rawOptions: filter['type']['properties']['options']));
        } else {
          textFilters.add(TextFilter(columnName: '', label: filter['name']));
        }
      } else {
        textFilters.add(TextFilter(columnName: '', label: filter['name']));
      }
    });
    datalistDefinition['columns'].forEach((column) {
      for (int i = 0; i < dropdownFilters.length; i++) {
        if (dropdownFilters[i].label == column['name']) {
          dropdownFilters[i].columnName = column['label'];
        }
      }
      for (int i = 0; i < textFilters.length; i++) {
        if (textFilters[i].label == column['name']) {
          textFilters[i].columnName = column['label'];
        }
      }
    });
    combinedFilters.add(Pagination(
        rowsPerPage: rowsPerPage,
        pages: pages,
        changePagination: changePagination));
    combinedFilters.addAll(textFilters);
    combinedFilters.addAll(dropdownFilters);
    combinedFilters.add(SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () {
          Map<String, String> myMap = {};
          for (int i = 0; i < textFilters.length; i++) {
            myMap[textFilters[i].columnName] = textFilters[i].controller.text;
          }
          for (int i = 0; i < dropdownFilters.length; i++) {
            myMap[dropdownFilters[i].columnName] =
                dropdownFilters[i].selectedOption;
          }
          filterRows(myMap);
          _scaffoldKey.currentState!.closeEndDrawer();
        },
        style: ButtonStyle(
          foregroundColor:
              MaterialStatePropertyAll(HexColor(globals.tertiaryColor)),
          backgroundColor:
              MaterialStateProperty.all(HexColor(globals.secondaryColor)),
        ),
        child: const Text(
          'Show',
        ),
      ),
    ));
    setState(() {});
  }

  Future<void> putColumnsAndRows() async {
    columns.clear();
    rows.clear();
    datalistDefinition =
        await downloadDatalistDefinition(widget.apiId, widget.datalistId);
    datalist = await getListById(widget.apiId, widget.datalistId);
    setupFilters();
    datalistDefinition['columns'].forEach((column) {
      columns.add(DataColumn(
        label: Text(column['label']),
        onSort: (columnIndex, ascending) {
          if (column['sortable'] == 'true') {
            setState(() {
              if (sortColumnIndex == columnIndex) {
                sortAscending = !sortAscending;
              } else {
                sortColumnIndex = columnIndex;
                sortAscending = true;
              }
              sortRows(column['name']);
            });
          }
        },
      ));
    });
    for (int i = 0; i < rowActions.length; i++) {
      columns.add(const DataColumn(
        label: Text(''),
      ));
    }
    List<dynamic> records = datalist['data'];
    for (int i = 0; i < records.length; i++) {
      List<DataCell> cells = [];
      datalistDefinition['columns'].forEach((column) {
        cells.add(DataCell(
          Text(extractInnerTextFromHtml(records[i][column['name']].toString())),
        ));
      });
      for (var rowAction in rowActions) {
        cells.add(DataCell(
          TextButton(
            style: ButtonStyle(
              overlayColor:
                  const MaterialStatePropertyAll(Color.fromRGBO(0, 0, 0, 0.1)),
              foregroundColor:
                  MaterialStatePropertyAll(HexColor(globals.primaryColor)),
            ),
            child: Text(
              textScaler: const TextScaler.linear(1.0),
              rowAction,
            ),
            onPressed: () {},
          ),
        ));
      }
      rows.add(DataRow(
        cells: cells,
      ));
    }
    originalColumns = columns;
    originalRows = rows;
  }

  void sortRows(String columnName) {
    print("21");
    setState(() {
      rows.sort((a, b) {
        Widget cellValue = a.cells[sortColumnIndex!].child;
        Text d = cellValue as Text;
        String x = d.data!.toLowerCase();
        var aValue = x;
        cellValue = b.cells[sortColumnIndex!].child;
        d = cellValue as Text;
        x = d.data!.toLowerCase();
        var bValue = x;
        if (sortAscending) {
          return aValue.compareTo(bValue);
        } else {
          return bValue.compareTo(aValue);
        }
      });
    });
  }

  int currentPageIndex = 0;
  int rowsPerPage = 10;
  List<String> pages = [];
  changePagination(int a, int b) {
    setState(() {
      rowsPerPage = a;
      currentPageIndex = b;
    });
  }

  List<DataRow> getPaginatedRows() {
    int startIndex = currentPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    endIndex = endIndex > rows.length ? rows.length : endIndex;
    return rows.sublist(startIndex, endIndex);
  }

  String? selectedColumn;
  String keyword = '';

  filterRows(Map<String, String> columnKeywords) {
    List<String> dropdownColumns = [];
    for (int i = 0; i < dropdownFilters.length; i++) {
      dropdownColumns.add(dropdownFilters[i].columnName);
    }
    setState(() {
      rows = originalRows;
    });
    if (columnKeywords.isEmpty) {
      setState(() {
        rows = originalRows;
      });
    } else {
      List<DataRow> filteredRows = [];
      for (var row in rows) {
        bool shouldIncludeRow = true;
        columnKeywords.forEach((selectedColumn, keyword) {
          if (!dropdownColumns.contains(selectedColumn)) {
            Widget cellValue = row
                .cells[columns.indexWhere((column) {
              DataColumn a = column;
              Widget b = a.label;
              Text c = b as Text;
              if (c.data == selectedColumn) {
                return true;
              } else {
                return false;
              }
            })]
                .child;
            Text a = cellValue as Text;
            String x = a.data!.toLowerCase();
            String y = keyword.toLowerCase();
            if (!x.contains(y)) {
              shouldIncludeRow = false;
            }
          } else {
            Widget cellValue = row
                .cells[columns.indexWhere((column) {
              DataColumn a = column;
              Widget b = a.label;
              Text c = b as Text;
              if (c.data == selectedColumn) {
                return true;
              } else {
                return false;
              }
            })]
                .child;
            Text a = cellValue as Text;
            String x = a.data!.toLowerCase();
            String y = keyword.toLowerCase();
            if (y == "") {
            } else {
              if (x != y) {
                shouldIncludeRow = false;
              }
            }
          }
        });
        if (shouldIncludeRow) {
          filteredRows.add(row);
        }
      }
      setState(() {
        rows = filteredRows;
      });
    }
  }

  fooboo() async {
    setState(() {
      loading = true;
    });
    await putColumnsAndRows();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fooboo();
  }

  List<bool> selectedRows = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
          width: MediaQuery.sizeOf(context).width * 0.75,
          child: Column(
            children: [
              Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(15.0),
                  color: HexColor(globals.secondaryColor),
                  child: Row(
                    children: [
                      Text(
                        textScaler: const TextScaler.linear(1.4),
                        "Filter",
                        style:
                            TextStyle(color: HexColor(globals.tertiaryColor)),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: combinedFilters,
                  ),
                ),
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        widget.showNewButton
                            ? Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.all(12)),
                                      textStyle: const MaterialStatePropertyAll(
                                          TextStyle(
                                              fontWeight: FontWeight.normal)),
                                      foregroundColor: MaterialStatePropertyAll(
                                          HexColor(globals.tertiaryColor)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              HexColor(globals.primaryColor)),
                                    ),
                                    child: const Text("New"),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        Row(
                            children: actions.map((label) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                padding: const MaterialStatePropertyAll(
                                    EdgeInsets.all(12)),
                                textStyle: const MaterialStatePropertyAll(
                                    TextStyle(fontWeight: FontWeight.normal)),
                                foregroundColor: MaterialStatePropertyAll(
                                    HexColor(globals.tertiaryColor)),
                                backgroundColor: MaterialStateProperty.all(
                                    HexColor(globals.primaryColor)),
                              ),
                              child: Text(label),
                            ),
                          );
                        }).toList()),
                        widget.showDeleteButton
                            ? ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  padding: const MaterialStatePropertyAll(
                                      EdgeInsets.all(12)),
                                  textStyle: const MaterialStatePropertyAll(
                                      TextStyle(fontWeight: FontWeight.normal)),
                                  foregroundColor: MaterialStatePropertyAll(
                                      HexColor(globals.tertiaryColor)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                                child: const Text("Delete"),
                              )
                            : const SizedBox()
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: HexColor(globals.primaryColor),
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.filter_alt,
                          color: HexColor(globals.tertiaryColor),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          currentPageIndex = currentPageIndex > 0
                              ? currentPageIndex - 1
                              : currentPageIndex;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        '${currentPageIndex + 1}',
                        textScaler: const TextScaler.linear(1.4),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          currentPageIndex =
                              (currentPageIndex + 1) * rowsPerPage < rows.length
                                  ? currentPageIndex + 1
                                  : currentPageIndex;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: columns.isNotEmpty
                          ? Theme(
                              data: ThemeData(
                                  colorScheme: ColorScheme.light(
                                      primary: HexColor(globals.primaryColor),
                                      onPrimary:
                                          HexColor(globals.tertiaryColor))),
                              child: DataTable(
                                showCheckboxColumn: true,
                                sortColumnIndex: sortColumnIndex,
                                sortAscending: sortAscending,
                                columns: columns,
                                rows: getPaginatedRows().map((row) {
                                  int i = rows.indexOf(row);
                                  selectedRows.add(false);
                                  return DataRow(
                                    selected: selectedRows[i],
                                    onSelectChanged: (selected) {
                                      setState(() {
                                        selectedRows[i] = selected!;
                                      });
                                    },
                                    cells: row.cells,
                                  );
                                }).toList(),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
            loading == true
                ? Container(
                    color: Colors.white,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: HexColor(globals.primaryColor),
                    )),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
