import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joget/Utilities/Functions.dart';

class AIWritingAssistantElement extends StatefulWidget {
  Key? key;
  String id;
  String label;
  AIWritingAssistantElement({this.key, required this.id, required this.label});

  @override
  State<AIWritingAssistantElement> createState() =>
      _AIWritingAssistantElementState();
}

class _AIWritingAssistantElementState extends State<AIWritingAssistantElement> {
  TextEditingController controllerTextArea = TextEditingController();
  TextEditingController controllerPromptField = TextEditingController();

  bool isLoadingResult = false;

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
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            TextField(
              controller: controllerTextArea,
              selectionControls: CustomColorSelectionHandle(Colors.grey),
              onChanged: (value) {},
              maxLines: 10,
            ),
            isLoadingResult == true
                ? const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controllerPromptField,
          selectionControls: CustomColorSelectionHandle(Colors.grey),
          decoration: InputDecoration(
            suffixIcon: Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 10, right: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Icon(size: 20, Icons.arrow_upward),
                  onPressed: () {
                    setState(() {
                      controllerTextArea.text = "";
                      isLoadingResult = true; // Show loading indicator
                    });
                    // Simulate delay
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        isLoadingResult = false; // Hide loading indicator
                        controllerTextArea.text = "This is result";
                      });
                    });
                  },
                )),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
