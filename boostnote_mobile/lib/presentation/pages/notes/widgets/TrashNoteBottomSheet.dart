import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/presentation/localization/app_localizations.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteNotifier.dart';
import 'package:boostnote_mobile/presentation/notifiers/NoteOverviewNotifier.dart';
import 'package:boostnote_mobile/presentation/pages/notes/widgets/NoteOverviewUpdater.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrashNoteBottomSheet extends StatefulWidget {
  @override
  _TrashNoteBottomSheetState createState() => _TrashNoteBottomSheetState();
}

class _TrashNoteBottomSheetState extends State<TrashNoteBottomSheet> {

  final NoteService _noteService = NoteService();
  NoteOverviewNotifier _noteOverviewNotifier;
  NoteNotifier _noteNotifier;

  @override
  Widget build(BuildContext context) {
    _initNotifiers(context);
    return _buildWidget(context);
  }

  void _initNotifiers(BuildContext context) {
    _noteOverviewNotifier = Provider.of<NoteOverviewNotifier>(context);
    _noteNotifier = Provider.of<NoteNotifier>(context);
  }

  Container _buildWidget(BuildContext context) {
     return Container(
      child: Wrap(
        children: <Widget>[
            new ListTile(
              leading: Icon(Icons.delete),
              title: Text(AppLocalizations.of(context).translate('trash'), style: Theme.of(context).textTheme.display1,),
              onTap: () {
                Navigator.of(context).pop();
                Note noteToTrash = _noteOverviewNotifier.selectedNote;
                _noteService.moveToTrash(noteToTrash);
                _noteOverviewNotifier.notes.remove(noteToTrash);
                NoteOverviewUpdater().update(_noteOverviewNotifier.notes, context);
                if(_noteNotifier.note == noteToTrash) _noteNotifier.note = null;
              }     
            ),
        ],
      ),
    );
  }
}

