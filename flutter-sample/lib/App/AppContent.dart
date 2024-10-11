import 'package:flutter/material.dart';
import 'package:joget/CrudMenu/CrudMenu.dart';
import 'package:joget/FormMenu/FormMenu.dart';
import 'package:joget/Utilities/Global.dart' as globals;

class AppContentController {
  late void Function(Map<String, dynamic>) refreshAppContent;
}

class AppContent extends StatefulWidget {
  Key? key;
  AppContentController controller;
  String apiId;

  AppContent({this.key, required this.apiId, required this.controller});
  @override
  _AppContentState createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  String content = "";
  CrudMenu? crudMenu;
  FormMenu? formMenu;
  @override
  void initState() {
    super.initState();
    widget.controller.refreshAppContent = refreshAppContent;
  }

  void initializeCrudMenu(Map<String, dynamic> b) {
    bool showDeleteButton = false;
    if (b["properties"]["list-showDeleteButton"] == "yes") {
      showDeleteButton = true;
    }
    bool showNewButton = false;
    if (b["properties"]["addFormId"] != "") {
      showNewButton = true;
    }
    crudMenu = CrudMenu(
      key: UniqueKey(),
      apiId: widget.apiId,
      datalistId: b["properties"]["datalistId"],
      showDeleteButton: showDeleteButton,
      showNewButton: showNewButton,
    );
  }

  void initializeFormMenu(Map<String, dynamic> b) {
    formMenu = FormMenu(
      key: UniqueKey(),
      apiId: widget.apiId,
      processDefId: b["properties"]["processDefId"],
    );
  }

  void refreshAppContent(Map<String, dynamic> b) async {
    if (b["className"] == "org.joget.plugin.enterprise.CrudMenu") {
      setState(() {
        content = "CrudMenu";
        initializeCrudMenu(b);
      });
    } else if (b["className"] == "org.joget.apps.userview.lib.RunProcess") {
      setState(() {
        content = "FormMenu";
        initializeFormMenu(b);
      });
    } else {
      setState(() {
        content = "XXX";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return content == "CrudMenu"
        ? crudMenu ?? const SizedBox()
        : content == "FormMenu"
            ? formMenu ?? const SizedBox()
            : const SizedBox();
  }
}
