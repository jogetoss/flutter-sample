import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/Drawer/CategoryItem.dart';
import 'package:joget/Drawer/ProfileSection.dart';
import 'package:joget/Utilities/API.dart';
import 'package:joget/App/AppContent.dart';
import 'package:joget/UI/Loading.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Utilities/Global.dart' as globals;

class App extends StatefulWidget {
  Key? key;
  String apiId;
  String appName;
  App({this.key, required this.apiId, required this.appName});
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool categoriesLoaded = false;
  bool colorSchemeLoaded = false;
  List<CategoryItem> categories = [];
  AppContentController controllerAppContent = AppContentController();
  setColors(String rgbString) {
    List<List<int>> rgbList = [];
    List<String> hexList = [];
    List<String> rgbStrings = rgbString.split(';');
    for (String rgb in rgbStrings) {
      RegExp regex = RegExp(r'(\d+)');
      Iterable<Match> matches = regex.allMatches(rgb);
      List<int> rgbValues = [];
      for (Match match in matches) {
        rgbValues.add(int.parse(match.group(0)!));
      }
      rgbList.add(rgbValues);
    }
    for (List<int> rgb in rgbList) {
      String hex =
          '#${rgb.map((e) => e.toRadixString(16).padLeft(2, '0')).join()}';
      hexList.add(hex.toUpperCase());
    }
    globals.primaryColor = hexList[hexList.length - 1];
    globals.secondaryColor = hexList[hexList.length - 2];
    globals.tertiaryColor = hexList[hexList.length - 5];
  }

  Future<void> setCategories() async {
    List<dynamic> createdUserviews = await listCreatedUserviews(widget.apiId);
    Map<String, dynamic> userviewDefinition = await downloadUserviewDefinition(
        widget.apiId, createdUserviews[0]['id']);
    String dx8colorScheme = userviewDefinition['setting']['properties']['theme']
        ['properties']['dx8colorScheme'];
    if (mounted) {
      setColors(dx8colorScheme);
      setState(() {
        colorSchemeLoaded = true;
      });
    }
    List<dynamic> categoriesData = userviewDefinition['categories'];
    bool isUserLoggedIn = await getIsUserLoggedIn();
    bool isUserAdmin = await getIsUserAdmin();
    if (isUserLoggedIn == true && isUserAdmin == true) {
      for (var categoryData in categoriesData) {
        if (categoryData['properties']['permission'] == null ||
            categoryData['properties']['permission']['className'] ==
                'org.joget.apps.userview.lib.LoggedInUserPermission' ||
            categoryData['properties']['permission']['className'] ==
                'org.joget.plugin.enterprise.AdminUserviewPermission' ||
            categoryData['properties']['permission']['className'] == "") {
          if (categoryData['properties']['hide'] == null) {
            categories.add(CategoryItem(
              categoryData: categoryData,
              selectLabel: selectLabel,
            ));
          } else {
            if (categoryData['properties']['hide'] != 'yes') {
              categories.add(CategoryItem(
                categoryData: categoryData,
                selectLabel: selectLabel,
              ));
            }
          }
        }
      }
    } else if (isUserLoggedIn == true && isUserAdmin == false) {
      for (var categoryData in categoriesData) {
        if (categoryData['properties']['permission'] == null ||
            categoryData['properties']['permission']['className'] ==
                'org.joget.apps.userview.lib.LoggedInUserPermission' ||
            categoryData['properties']['permission']['className'] == "") {
          if (categoryData['properties']['hide'] == null) {
            categories.add(CategoryItem(
              categoryData: categoryData,
              selectLabel: selectLabel,
            ));
          } else {
            if (categoryData['properties']['hide'] != 'yes') {
              categories.add(CategoryItem(
                categoryData: categoryData,
                selectLabel: selectLabel,
              ));
            }
          }
        }
      }
    } else {
      for (var categoryData in categoriesData) {
        if (categoryData['properties']['permission'] == null ||
            categoryData['properties']['permission']['className'] ==
                'org.joget.plugin.enterprise.AnonymousUserviewPermission' ||
            categoryData['properties']['permission']['className'] == "") {
          if (categoryData['properties']['hide'] == null) {
            categories.add(CategoryItem(
              categoryData: categoryData,
              selectLabel: selectLabel,
            ));
          } else {
            if (categoryData['properties']['hide'] != 'yes') {
              categories.add(CategoryItem(
                categoryData: categoryData,
                selectLabel: selectLabel,
              ));
            }
          }
        }
      }
    }
    if (mounted) {
      setState(() {
        categoriesLoaded = true;
      });
      selectLabel(categories[0].categoryData['menus'][0], false);
    }
  }

  void selectLabel(Map<String, dynamic> a, bool b) {
    controllerAppContent.refreshAppContent(a);
    if (b == true) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    setCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            drawer: Drawer(
              backgroundColor: HexColor(globals.secondaryColor),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 20.0, bottom: 20.0),
                child: Column(
                  children: [
                    ProfileSection(isApp: true),
                    categoriesLoaded == true
                        ? Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: categories,
                                ),
                              ),
                            ),
                          )
                        : CircularProgressIndicator(
                            color: HexColor(globals.tertiaryColor),
                          ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              title: colorSchemeLoaded == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            widget.appName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: HexColor(globals.tertiaryColor)),
                            textScaler: const TextScaler.linear(0.7),
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
              iconTheme: IconThemeData(
                color: HexColor(globals.tertiaryColor),
              ),
              backgroundColor: HexColor(globals.primaryColor),
            ),
            body: AppContent(
              apiId: widget.apiId,
              controller: controllerAppContent,
            ),
          ),
        ),
        colorSchemeLoaded == false ? Loading() : const SizedBox()
      ],
    );
  }
}
