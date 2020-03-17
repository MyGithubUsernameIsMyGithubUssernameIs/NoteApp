import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/data/entity/FolderEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkdownNoteHeader extends StatefulWidget {

  final Function(FolderEntity) onFolderChangedCallback;
  final Function(String) onTitleChangedCallback;
  final Function() onInfoClickedCallback;
  final Function() onTagClickedCallback;

  List<FolderEntity> folders;
  FolderEntity selectedFolder;
  Note note;

  MarkdownNoteHeader({this.folders, this.selectedFolder, this.note, this.onFolderChangedCallback, this.onInfoClickedCallback, this.onTagClickedCallback, this.onTitleChangedCallback});

  @override
  State<StatefulWidget> createState() => _MarkdownNoteHeaderState();

}

class _MarkdownNoteHeaderState extends State<MarkdownNoteHeader> {

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = this.widget.note.title; 
    _textEditingController.addListener((){
      this.widget.onTitleChangedCallback(_textEditingController.text);
    });
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13),
      child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: _textEditingController,
              style: TextStyle(
                fontSize: 20, 
                color: Color(0xFF2E3235),
              ),
              maxLength: 100,
              decoration: null
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child:  Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5), 
                    child: Icon(Icons.folder_open, color: Color(0xFF2E3235),)
                  ),
                  Container(
                    width: 130,
                    child: DropdownButton<FolderEntity> (    //TODO FolderEntity
                      value: this.widget.selectedFolder, 
                      underline: Container(), 
                      iconEnabledColor: Colors.transparent,
                      style: TextStyle(fontSize: 16, color: Color(0xFF2E3235),),
                      items: this.widget.folders.map<DropdownMenuItem<FolderEntity>>((folder) => DropdownMenuItem<FolderEntity>(
                        value: folder,
                        child: Text(folder.name)
                      )).toList(),
                      onChanged: (folder) {
                          setState(() {
                            this.widget.selectedFolder = folder;
                          });
                          this.widget.onFolderChangedCallback(folder);
                        }
                    ),
                  )
                ],
              )
            ),
            Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.label_outline, color: Color(0xFF2E3235)), onPressed: this.widget.onTagClickedCallback),
              IconButton(icon: Icon(Icons.info_outline, color: Color(0xFF2E3235)), onPressed: this.widget.onInfoClickedCallback)
              ],
            ),
          ],
        ),
        FractionallySizedBox(
          widthFactor: 0.95,
          child: Container(
            height: 1,
            color: Colors.black12,
          ),
        )
      ],
    ),
    );
  }

}