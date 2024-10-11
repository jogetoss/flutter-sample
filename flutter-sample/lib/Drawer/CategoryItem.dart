import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Utilities/Global.dart' as globals;
import 'package:expandable/expandable.dart';

class CategoryItem extends StatefulWidget {
  Key? key;
  Map<String, dynamic> categoryData;
  Function selectLabel;
  CategoryItem({
    this.key,
    required this.categoryData,
    required this.selectLabel,
  });
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  List<dynamic> menus = [];
  List<String> menuLabels = [];
  String mainMenuLabel = "";
  @override
  void initState() {
    super.initState();
    menus = widget.categoryData['menus'];
    for (var menu in menus) {
      menuLabels.add(extractInnerTextFromHtml(menu["properties"]["label"]));
    }
    mainMenuLabel =
        extractInnerTextFromHtml(widget.categoryData['properties']['label']);
  }

  ExpandableController expandableController = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return menus.length == 1
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            HexColor(globals.tertiaryColor)),
                        backgroundColor: MaterialStateProperty.all(
                            HexColor(globals.primaryColor)),
                      ),
                      onPressed: () {
                        for (var menu in menus) {
                          if (extractInnerTextFromHtml(
                                  menu["properties"]["label"]) ==
                              menuLabels[0]) {
                            widget.selectLabel(menu, true);
                          }
                        }
                        expandableController.toggle();
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor(globals.tertiaryColor)),
                              menuLabels[0],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ExpandableNotifier(
              controller: expandableController,
              child: Expandable(
                  theme: const ExpandableThemeData(
                    crossFadePoint: 0.0,
                  ),
                  collapsed: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            HexColor(globals.tertiaryColor)),
                        backgroundColor: MaterialStateProperty.all(
                            HexColor(globals.primaryColor)),
                      ),
                      onPressed: () => expandableController.toggle(),
                      child: Row(
                        children: [
                          Expanded(
                            child: mainMenuLabel == ""
                                ? Text(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    menuLabels[0],
                                  )
                                : Text(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    mainMenuLabel,
                                  ),
                          ),
                          ExpandableIcon(
                            theme: const ExpandableThemeData(
                              expandIcon: Icons.arrow_drop_down_sharp,
                              collapseIcon: Icons.arrow_drop_down_sharp,
                              iconColor: Colors.white,
                              iconSize: 22.0,
                              iconRotationAngle: 180 * 3.14 / 180,
                              iconPadding: EdgeInsets.only(right: 0),
                              hasIcon: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  expanded: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    HexColor(globals.tertiaryColor)),
                                backgroundColor: MaterialStateProperty.all(
                                    HexColor(globals.primaryColor)),
                              ),
                              onPressed: () {
                                expandableController.toggle();
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: mainMenuLabel == ""
                                        ? Text(
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            menuLabels[0],
                                          )
                                        : Text(
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            mainMenuLabel,
                                          ),
                                  ),
                                  ExpandableIcon(
                                    theme: const ExpandableThemeData(
                                      expandIcon: Icons.arrow_drop_down_sharp,
                                      collapseIcon: Icons.arrow_drop_down_sharp,
                                      iconColor: Colors.white,
                                      iconSize: 22.0,
                                      iconRotationAngle: 180 * 3.14 / 180,
                                      iconPadding: EdgeInsets.only(right: 0),
                                      hasIcon: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: menuLabels.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    alignment: Alignment.centerLeft,
                                    foregroundColor: MaterialStateProperty.all(
                                        HexColor(globals.primaryColor)),
                                    backgroundColor: MaterialStateProperty.all(
                                        HexColor(globals.tertiaryColor)),
                                  ),
                                  onPressed: () {
                                    for (var menu in menus) {
                                      if (extractInnerTextFromHtml(
                                              menu["properties"]["label"]) ==
                                          menuLabels[index]) {
                                        widget.selectLabel(menu, true);
                                      }
                                    }
                                    expandableController.toggle();
                                  },
                                  child: Text(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    menuLabels[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )),
            ),
          );
  }
}
