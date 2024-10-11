import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class FileUploadElement extends StatefulWidget {
  Key? key;
  String? className;
  String? id;
  String? label;
  String value = "";
  List<File> selectedFiles = [];
  FileUploadElement({
    this.key,
    required this.className,
    required this.id,
    required this.label,
  });
  @override
  State<FileUploadElement> createState() => _FileUploadElementState();
}

class _FileUploadElementState extends State<FileUploadElement> {
  List<File> selectedFiles = [];
  selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        selectedFiles = result.paths.map((path) => File(path!)).toList();
      });
      widget.selectedFiles = selectedFiles;
    }
  }

  getFileUploadButtonText() {
    if (selectedFiles.isEmpty) {
      return "Upload files";
    } else {
      int remainingFiles = selectedFiles.length - 1;
      if (remainingFiles != 0) {
        return "${selectedFiles[0].path.split('/').last} and $remainingFiles more";
      } else {
        return selectedFiles[0].path.split('/').last;
      }
    }
  }

  List<String> options = [
    '#16a085',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HtmlWidget(
          widget.label!,
          textStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onLongPress: () {
              if (selectedFiles.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                        builder: (context, refreshAlertDialog) {
                      return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                          content: selectedFiles.isNotEmpty
                              ? SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 10,
                                      ),
                                      itemCount: selectedFiles.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                      selectedFiles[index]
                                                          .path
                                                          .split('/')
                                                          .last,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.red),
                                                  ),
                                                  child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    refreshAlertDialog(() {
                                                      selectedFiles
                                                          .removeAt(index);
                                                    });
                                                    setState(() {});
                                                    widget.selectedFiles =
                                                        selectedFiles;
                                                  },
                                                )
                                              ],
                                            ));
                                      },
                                    ),
                                  ))
                              : const SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: Center(
                                      child: Text("No files",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey))),
                                ));
                    });
                  },
                );
              }
            },
            onPressed: selectFiles,
            style: ButtonStyle(
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.grey),
            ),
            child: Text(
              getFileUploadButtonText(),
              style: const TextStyle(),
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
