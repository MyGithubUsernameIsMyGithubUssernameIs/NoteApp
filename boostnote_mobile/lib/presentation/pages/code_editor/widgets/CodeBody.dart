import 'package:boostnote_mobile/presentation/notifiers/SnippetNotifier.dart';
import 'package:boostnote_mobile/presentation/themes/ThemeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:provider/provider.dart';
 
class CodeBody extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => CodeBodyState();
}
  
class CodeBodyState extends State<CodeBody> {

  SnippetNotifier _snippetNotifier;
  
  @override
  Widget build(BuildContext context) {
    _initNotifier(context);
    return _buildWidget();
  }

  void _initNotifier(BuildContext context) {
    _snippetNotifier = Provider.of<SnippetNotifier>(context);
  }

  Widget _buildWidget() {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = _snippetNotifier.selectedCodeSnippet.content;

    return _snippetNotifier.isEditMode 
    ? _buildBodyForEditMode(textEditingController) 
    : _buildBodyForPreviewMode();
  }

  Container _buildBodyForEditMode(TextEditingController textEditingController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: TextField(
        autofocus: true,
        autocorrect: true,
        style: Theme.of(context).textTheme.display1,
        controller: textEditingController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 30, //TODO anpassen an höhe
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none),
        onChanged: (String text) => _snippetNotifier.selectedCodeSnippet.content = text,
      ),
    );
  }

  Stack _buildBodyForPreviewMode() {
    return Stack(
    children: <Widget>[
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _snippetNotifier.isEditMode = !_snippetNotifier.isEditMode,
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            height: 800,   //TODO height auf bildschirm - header und appbar anpassen
          ),
        )
      ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _snippetNotifier.isEditMode = !_snippetNotifier.isEditMode,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          child: HighlightView(
            _snippetNotifier.selectedCodeSnippet.content,
            language: _snippetNotifier.selectedCodeSnippet.mode,
            theme: ThemeService().getEditorTheme(context),
            textStyle: TextStyle(
                        fontFamily: 'My awesome monospace font',
                        fontSize: 16,
                        color: Theme.of(context).textTheme.display1.color,
            )
          )
        )
      ),
    ],
  );
  }
}