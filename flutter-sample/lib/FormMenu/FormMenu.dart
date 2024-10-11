import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:joget/FormMenu/Elements/AllElements.dart';
import 'package:joget/Utilities/API.dart';
import 'package:joget/UI/Loading.dart';
import 'package:joget/Utilities/Functions.dart';
import 'package:joget/Utilities/Global.dart' as globals;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:format_date/format_date.dart';
import 'package:joget/FormMenu/Validators/DefaultValidator.dart';

class FormMenu extends StatefulWidget {
  Key? key;
  String apiId;
  String processDefId;

  FormMenu({
    this.key,
    required this.apiId,
    required this.processDefId,
  });
  @override
  State<FormMenu> createState() => _FormMenuState();
}

class _FormMenuState extends State<FormMenu> {
  Map<String, dynamic> formDefinition = {};
  bool loading = false;
  List<Widget> formElements = [];
  String formId = "";
  bool submitLoading = false;

  // validateFormElement(String validatorClassName, String value){
  //   switch () {
  //         case 'org.joget.apps.form.lib.SelectBox':

  //           break;
  //         default:
  //       }
  // }

  List<ElementController> elementControllers = [];

  Column getSubmitButton() {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  submitLoading = true;
                });
                Map<String, String> allFields = {};
                Map<String, List<File>> fileFields = {};
                List<dynamic> formElements_dynamic = formElements;
                for (var i = 0; i < formElements_dynamic.length; i++) {
                  if (i != formElements_dynamic.length - 1) {
                    if (formElements_dynamic[i].className ==
                        "org.joget.apps.form.lib.FileUpload") {
                      fileFields[formElements_dynamic[i].id] =
                          formElements_dynamic[i].selectedFiles;
                    }
                    allFields[formElements_dynamic[i].id] =
                        formElements_dynamic[i].value;
                  }
                }
                allFields['modifiedBy'] = (await getUsernameFromStorage())!;
                allFields['createdBy'] = (await getUsernameFromStorage())!;
                allFields['createdByName'] = (await getFullNameFromStorage())!;
                allFields['modifiedByName'] = (await getFullNameFromStorage())!;

                for (var elementController in elementControllers) {
                  elementController.refresh();
                }

                bool cannotSubmit = false;
                List<dynamic> formElements_dynamic_2 = formElements;
                for (var i = 0; i < formElements_dynamic_2.length; i++) {
                  if (i != formElements_dynamic.length - 1) {
                    try {
                      if (formElements_dynamic_2[i].isValidationError == true) {
                        cannotSubmit = true;
                        setState(() {
                          submitLoading = false;
                        });
                        break;
                      }
                    } catch (e) {}
                  }
                }

                if (cannotSubmit == false) {
                  bool formSubmitted = await startProcess(fileFields, allFields,
                      widget.apiId, widget.processDefId, formId);
                  if (formSubmitted) {
                    setState(() {
                      submitLoading = false;
                    });
                  }
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: HexColor("#009265"),
                      content: const Text("Form submitted"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                foregroundColor:
                    MaterialStatePropertyAll(HexColor(globals.tertiaryColor)),
                backgroundColor:
                    MaterialStateProperty.all(HexColor(globals.primaryColor)),
              ),
              child: const Text("Submit")),
        ),
      ],
    );
  }

  int totalElements = 0;
  int elementsLoaded = 0;
  double linearProgressValue = 0.0;

  setupForm() async {
    setState(() {
      loading = true;
    });
    formId = await getFormId(widget.processDefId, widget.apiId);
    try {
      formDefinition = await downloadFormDefinition(widget.apiId, formId);
      List<dynamic> elements =
          formDefinition['elements'][0]['elements'][0]['elements'];
      totalElements = elements.length;
      String? username = await getUsernameFromStorage();
      String? password = await getPasswordFromStorage();
      await runJSpringSecurityCheck(username!, password!);
      for (var element in elements) {
        ElementController elementController = ElementController();
        elementControllers.add(elementController);
        dynamic validator;
        if (element['properties']['validator'] != null &&
            element['properties']['validator']['className'] != null) {
          if (element['properties']['validator']['className'] ==
              "org.joget.apps.form.lib.DefaultValidator") {
            validator = DefaultValidator(element['properties']['validator']);
          } else {
            validator = DefaultValidator(element['properties']['validator']);
          }
        }
        switch (element['className']) {
          case 'org.joget.apps.form.lib.SelectBox':
            String value;
            if (element['properties']['value'] != "") {
              value = await getHashValue(
                  element['properties']['value'], widget.apiId);
            } else {
              value = "";
            }
            List<dynamic> options = await getSelectBoxOptions(
                formId, element['properties']['id'], widget.apiId);
            formElements.add(SelectBoxElement(
                validator: validator,
                controllerElement: elementController,
                className: element['className'],
                id: element['properties']['id'],
                label: element['properties']['label'],
                value: value,
                options: options));
            break;
          case 'org.joget.apps.form.lib.TextField':
            String value;
            if (element['properties']['value'] != "") {
              value = await getHashValue(
                  element['properties']['value'], widget.apiId);
            } else {
              value = "";
            }
            formElements.add(TextFieldElement(
              validator: validator,
              controllerElement: elementController,
              className: element['className'],
              id: element['properties']['id'],
              label: element['properties']['label'],
              value: value,
            ));
            break;
          case 'org.joget.apps.form.lib.TextArea':
            String value;
            if (element['properties']['value'] != "") {
              value = await getHashValue(
                  element['properties']['value'], widget.apiId);
            } else {
              value = "";
            }
            formElements.add(TextAreaElement(
                validator: validator,
                controllerElement: elementController,
                className: element['className'],
                id: element['properties']['id'],
                label: element['properties']['label'],
                value: value));
            break;
          case 'org.joget.apps.form.lib.FileUpload':
            formElements.add(FileUploadElement(
                className: element['className'],
                id: element['properties']['id'],
                label: element['properties']['label']));
            break;
          case 'org.joget.apps.form.lib.HiddenField':
            String value;
            if (element['properties']['value'] != "") {
              value = await getHashValue(
                  element['properties']['value'], widget.apiId);
            } else {
              value = "";
            }
            formElements.add(HiddenFieldElement(
              className: element['className'],
              id: element['properties']['id'],
              value: value,
            ));
            break;
          case 'org.joget.apps.form.lib.DatePicker':
            String value;
            if (element['properties']['value'] != "") {
              value = await getHashValue(
                  element['properties']['value'], widget.apiId);
            } else {
              value = "";
            }
            formElements.add(DatePickerElement(
              // controllerElement: elementController,
              className: element['className'],
              id: element['properties']['id'],
              label: element['properties']['label'],
              value: value,
              format: element['properties']['format'],
              dataFormat: element['properties']['dataFormat'],
            ));
            break;
          // case 'org.joget.apps.form.lib.IdGeneratorField':
          //   break;
          // case 'org.joget.StarRatingField':
          //   formElements.add(StarRatingElement(
          //       className: element['className'],
          //       id: element['properties']['id'],
          //       label: element['properties']['label']));
          //   break;
          // case 'org.joget.marketplace.ColorPicker':
          //   String value;
          //   if (element['properties']['value'] != "") {
          //     value = await getHashValue(
          //         element['properties']['value'], widget.apiId);
          //   } else {
          //     value = "";
          //   }
          //   formElements.add(ColorPickerElement(
          //     className: element['className'],
          //     id: element['properties']['id'],
          //     label: element['properties']['label'],
          //     value: value,
          //   ));
          //   break;
          default:
        }
        setState(() {
          elementsLoaded++;
          linearProgressValue = elementsLoaded / totalElements;
        });
      }
      formElements.add(getSubmitButton());
    } catch (e) {
      return e;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setupForm();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: formElements
                    // children: [
                    //   ColorPickerElement(
                    //       className: "", id: "", label: "", value: "")
                    // ],
                    ),
              ),
            ),
            loading == true
                ? Container(
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(30),
                          backgroundColor: Colors.grey,
                          minHeight: 10,
                          color: HexColor(globals.primaryColor),
                          value: linearProgressValue,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        submitLoading == true ? Loading() : const SizedBox()
      ],
    );
  }
}
