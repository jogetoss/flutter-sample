import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:joget/Utilities/Functions.dart';

class RichTextEditorElement extends StatefulWidget {
  Key? key;
  RichTextEditorElement({this.key});

  @override
  State<RichTextEditorElement> createState() => _RichTextEditorElementState();
}

class _RichTextEditorElementState extends State<RichTextEditorElement> {
  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar.simple(
          configurations: QuillSimpleToolbarConfigurations(
            controller: _controller,
            sharedConfigurations: const QuillSharedConfigurations(
              locale: Locale('de'),
            ),
          ),
        ),
        QuillEditor.basic(
          configurations: QuillEditorConfigurations(
            minHeight: 300,
            maxHeight: 300,
            onTapDown: (details, p1) {
              return true;
            },
            textSelectionControls: CustomColorSelectionHandle(Colors.grey),
            controller: _controller,
            readOnly: false,
            padding: const EdgeInsets.all(8.0),
            placeholder: 'Enter your text here...',
          ),
        ),
        // SizedBox(height: 16.0),
        // ElevatedButton(
        //   onPressed: () {
        //     // Get the HTML representation of the content
        //     final htmlContent = _controller.document.toHtml();
        //   },
        //   child: Text('Print HTML Content'),
        // ),
      ],
    );
  }
}
