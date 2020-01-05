import 'dart:convert';
import 'dart:io';

import 'package:boostnote_mobile/business_logic/model/MarkdownNote.dart';
import 'package:boostnote_mobile/business_logic/model/Note.dart';
import 'package:boostnote_mobile/business_logic/model/SnippetNote.dart';
import 'package:boostnote_mobile/business_logic/repository/NoteRepository.dart';
import 'package:boostnote_mobile/business_logic/service/NoteService.dart';
import 'package:boostnote_mobile/data/entity/MarkdownNoteEntity.dart';
import 'package:boostnote_mobile/data/entity/SnippetNoteEntity.dart';
import 'package:boostnote_mobile/data/repositoryImpl/filesystem/Storage.dart';
import 'package:path_provider/path_provider.dart';

//TODO: Make functions async
class NoteRepositoryImpl extends NoteRepository {

  //Directory _directory;

/*
  NoteRepositoryImpl() {
     Storage().localPath.then((path) => print(path));
    Storage().readData().then((String value) {
      print('heyyyyyyyyyyyyyyy');
    });
    SimplePermissions.requestPermission(Permission. WriteExternalStorage).then(
      (permissionResult) {
      if (permissionResult == PermissionStatus.authorized){
      getApplicationDocumentsDirectory().then((directory) {
        print(_directory);
        _directory = directory;
     });
    }
   });

  }
  */
  Future<Directory> get directory async {
    final Directory dir = await getApplicationDocumentsDirectory();
    print('Application Directory: ' + dir.toString());
   
    Directory noteDirectory = Directory(dir.path + '/notes');
    bool dirExists = await noteDirectory.exists();
    if(!dirExists) {
     noteDirectory.createSync();
    }
  
    print('Note Directory: ' + noteDirectory.toString());
    return noteDirectory;
  }
  

  Future<String> get localPath async {
    final Directory dir = await directory;
    print('dir.path: ' + dir.path);
    return dir.path;
  }

  @override
  void delete(Note note) {
    print('delete');
    deleteById(note.id);
  }

  @override
  void deleteAll(List<Note> notes) {
    print('deleteAll');
    notes.forEach((note) => delete(note));
  }

  @override
  void deleteById(int id) async {
    print('deleteById');
    final List<Note> notes = await findAll();
    notes.add(NoteService().generateMarkdownNote());
    Note noteToBeRemoved = notes.firstWhere((note) => note.id == id, orElse: () => null);
    if(noteToBeRemoved != null) {
      String path = await localPath;
      File file = File(path + '/' + noteToBeRemoved.id.toString());
      file.exists().then((exists) {
        if(exists) {
          file.delete(); 
        }
      });
    }
  }

  @override
  Future<List<Note>> findAll() async {
    print('findAll');
    final Directory dir = await directory;

    dir.list().toList().then((List<FileSystemEntity> list) {
      List<String> paths = List();
      list.forEach((entity) => paths.add(entity.path));
      List<File> _files = List();
      paths.forEach((path) => _files.add(File(path)));
      List<Note> notes = List();
      print(_files.length.toString() + ' notes found');
      _files.forEach((file) async {
        String content = await file.readAsString();
        print('content: ' + content);
        notes.add(MarkdownNoteEntity.fromJson(jsonDecode(content)));   //TODO call fromJson()
      });
      return Future.value(notes);
    });
    return Future.value(List());
    
  }

  @override
  Future<Note> findById (int id) async {
    print('findById');
    final List<Note> notes = await findAll();
    return Future.value(notes.firstWhere((note) => note.id == id));
  }

  @override
  void save(Note note) async {

//TODO: Convertion is ugly
    if(note is MarkdownNote) {
      MarkdownNote markdownNote = note;
      note = MarkdownNoteEntity(
        id: note.id,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        folder: note.folder,
        title: note.title,
        tags: note.tags,
        isStarred: note.isStarred,
        isTrashed: note.isStarred,
        content: markdownNote.content
      );
    } else {

      List<CodeSnippetEntity> codeSnippetEntities = List();
      SnippetNote snippetNote = note;
      snippetNote.codeSnippets.forEach((codeSnippet) => codeSnippetEntities.add(
        CodeSnippetEntity(
          linesHighlighted: codeSnippet.linesHighlighted,
          name: codeSnippet.name,
          mode: codeSnippet.mode,
          content: codeSnippet.content
        )
      ));

      note = SnippetNoteEntity(
        id: note.id,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        folder: note.folder,
        title: note.title,
        tags: note.tags,
        isStarred: note.isStarred,
        isTrashed: note.isStarred,
        description: snippetNote.description,
        codeSnippets: codeSnippetEntities
      );
    }
    
    print('save');
    String path = await localPath;
    File file = File(path + '/' + note.id.toString());
    bool fileExists = await file.exists();
    if(fileExists) {
      print('File exists');
      print('json: ' + jsonEncode(note));
      file.writeAsString(jsonEncode(note));
    } else {
      //TODO: Set id somewhere
      print('File does not yet exist');
      print('-----------------------');
      file.create();
      if(note is MarkdownNoteEntity) {
        MarkdownNoteEntity markdownNoteEntity = note;
        print('json: ' + jsonEncode(markdownNoteEntity.toJson()));
        file.writeAsString(jsonEncode(markdownNoteEntity.toJson()));
      } else {
        SnippetNoteEntity snippetNoteEntity = note;
        print('json: ' + jsonEncode(snippetNoteEntity.toJson()));
        file.writeAsString(jsonEncode(snippetNoteEntity.toJson()));
      }
    } 
  }

  @override
  void saveAll(List<Note> notes) {
    print('saveAll');
    print(notes.length.toString() + ' notes to save');
    notes.forEach((note) => save(note));
  }
}