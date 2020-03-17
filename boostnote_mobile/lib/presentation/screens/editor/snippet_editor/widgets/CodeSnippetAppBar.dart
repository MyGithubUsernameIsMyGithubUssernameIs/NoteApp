import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/presentation/screens/editor/snippet_editor/widgets/OverflowButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CodeSnippetAppBar extends StatefulWidget implements PreferredSizeWidget{

  final Function() onNavigateBackCallback;
  final Function(String) selectedActionCallback;
  final Function(CodeSnippet) onSelectedSnippetChanged;

  SnippetNote note;
  CodeSnippet selectedCodeSnippet;

  CodeSnippetAppBar({@required this.note,@required this.selectedCodeSnippet, this.onNavigateBackCallback, this.selectedActionCallback, this.onSelectedSnippetChanged});

  @override
  _CodeSnippetAppBarState createState() => _CodeSnippetAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CodeSnippetAppBarState extends State<CodeSnippetAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).buttonColor), 
        onPressed: widget.onNavigateBackCallback
      ),
      actions: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5), 
              child: Icon(Icons.code)
            ),
            DropdownButton<CodeSnippet> (  
              value: widget.selectedCodeSnippet, 
              underline: Container(), 
              iconEnabledColor: Theme.of(context).buttonColor,
              style: TextStyle(fontSize: 16, color:  Theme.of(context).buttonColor, fontWeight: FontWeight.bold),
              selectedItemBuilder: (BuildContext context) {
                String snippetName = widget.selectedCodeSnippet.name.length > 10 ? widget.selectedCodeSnippet.name.substring(0,10) : widget.selectedCodeSnippet.name;
                Widget item = DropdownMenuItem<CodeSnippet>(
                  value: widget.selectedCodeSnippet,
                  child: Row(
                    children: <Widget>[
                      Text(snippetName + '    '),
                    ],
                  )
                );
                return <DropdownMenuItem<CodeSnippet>>[item];
              },
              items: widget.note.codeSnippets.map<DropdownMenuItem<CodeSnippet>>((codeSnippet) {
                Widget item = DropdownMenuItem<CodeSnippet>(
                  value: codeSnippet,
                  child: Row(
                    children: <Widget>[
                      Text(codeSnippet.name, style: TextStyle(fontSize: 16, color:  Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.delete), 
                        onPressed: () {
                           widget.note.codeSnippets.remove(codeSnippet);
                        })
                    ],
                  )
                );
                return item;
              }).toList(),
              onChanged: (CodeSnippet codeSnippet) => widget.onSelectedSnippetChanged(codeSnippet),
            ),
          ],
        ),
        OverflowButton(
          noteIsStarred: this.widget.note.isStarred, 
          selectedActionCallback: this.widget.selectedActionCallback
        )
      ]
    );
  }
}