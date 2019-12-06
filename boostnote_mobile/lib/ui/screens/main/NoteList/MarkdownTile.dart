
import 'package:boostnote_mobile/Converter/DateTimeConverter.dart';
import 'package:boostnote_mobile/data/model/MarkdownNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkdownTile extends StatelessWidget{
  
  DateTimeConverter dateTimeConverter = new DateTimeConverter();  //ugly
  final MarkdownNote note;
  MarkdownTile({this.note});

  @override
  Widget build(BuildContext context) => _buildItem(context);

  Widget _buildItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: <Widget>[
        buildHeaderRow(),
        buildBodyRow(),
        buildFooterRow()
        ],
      ),
    );
  }

  Widget buildHeaderRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: <Widget>[
          Icon(Icons.note, color: Colors.grey),
          Text(note.title, 
              maxLines: 1,
              style: TextStyle(fontSize: 28.0)),
        ],
      ),
      Text(dateTimeConverter.convertToReadableForm(note.updatedAt), style: TextStyle(fontSize: 18.0))
    ],
  );

  Widget buildBodyRow() => Text(
    note.content, 
    maxLines: 2,
    style: TextStyle(fontSize: 20.0)
  );

  Widget buildFooterRow() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(note.tags.toString(), 
          maxLines: 1,
          style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic)),
      Icon(Icons.star)
    ],
  );
}

