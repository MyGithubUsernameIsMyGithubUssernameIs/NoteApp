
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' ;
import 'package:markdown/markdown.dart';

/*import '../synatx_highlighter.dart';*/

class MarkdownPreview extends StatefulWidget {

  final String _text;
  final Function(String) launchUrlCallback;

  MarkdownPreview(this._text, this.launchUrlCallback); //TODO: Constructor

  @override
  State<StatefulWidget> createState() => MarkdownPreviewState();
  
}
  
class MarkdownPreviewState extends State<MarkdownPreview>{

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: MarkdownBody(
        data: this.widget._text,
        /*syntaxHighlighter: DartSyntaxHighlighter(SyntaxHighlighterStyle.darkThemeStyle()),*/
        styleSheet: MarkdownStyleSheet(p: TextStyle(color: Theme.of(context).textTheme.display1.color, fontSize: 16)),
        onTapLink: (String url){
          this.widget.launchUrlCallback(url);
        },
        extensionSet: ExtensionSet.gitHubFlavored,
        checkboxBuilder: (bool){
          return Checkbox(
            value: bool, 
            onChanged: null);
        },
        
      )
    )
  );
}
