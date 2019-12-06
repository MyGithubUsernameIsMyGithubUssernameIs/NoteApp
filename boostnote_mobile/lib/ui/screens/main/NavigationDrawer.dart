 
 
 import 'package:boostnote_mobile/data/DummyDataGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => NavigationDrawerState();

}

class NavigationDrawerState extends State<NavigationDrawer> {

  DummyDataGenerator _generator = new DummyDataGenerator();

   @override
  Widget build(BuildContext context) {

     List<Widget> widgetList = buildWidgetList(context, _generator.folders);

    return Drawer(
      elevation: 20.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: widgetList
      ),
    );
  }

  List<Widget> buildWidgetList(BuildContext context, List<String> folders) {

      List<Widget> widgets = [
      Container(
          height: 90,
          child: DrawerHeader(
            child: new Text("Boostnote Mobile", style: TextStyle(color: Theme.of(context).accentColor),),
            decoration: new BoxDecoration(
                color: Theme.of(context).primaryColorLight
            )
        ),
      ),
      Container(color: Color(0x111EC38B),
        child:  ListTile(
            selected: true,
            leading: Icon(Icons.note, color: Color(0xFFF6F5F5)),
            title: Text('All Notes'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
      ),
      ListTile(
        leading: Icon(Icons.label, color: Color(0xFFF6F5F5)),
        title: Text('Tags'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.star, color: Color(0xFFF6F5F5)),
        title: Text('Starred'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete, color: Color(0xFFF6F5F5)),
        title: Text('Trash'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      Divider(
        height: 2.0,
        thickness: 2,
        color: Theme.of(context).accentColor,
      ),
      ListTile(
        leading: Icon(Icons.create_new_folder, color: Color(0xFFF6F5F5)),
        title: Text('Add Folder'),
        onTap: () {
          _createDialog(context);
        },
      ),
      Divider(
        height: 2.0,
        thickness: 2,
        color: Theme.of(context).accentColor,
      ),
      ListTile(
        leading: Icon(Icons.settings, color: Color(0xFFF6F5F5)),
        title: Text('Settings'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.info, color: Color(0xFFF6F5F5)),
        title: Text('About'),
        onTap: () {
          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
          );
          */
        },
      ),
    ];

    for(String folder in folders){
      widgets.insert(6, ListTile(
        leading: Icon(Icons.folder, color: Color(0xFFF6F5F5)),
        title: Text(folder),
        onTap: () {
          Navigator.pop(context);
        },
      ));
    }

    return widgets;
  }

  Future<String> _createDialog(BuildContext context) {
    TextEditingController controller = new TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Add Folder'),
        content: TextField(
          controller: controller,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Add'),
            onPressed: (){
              Navigator.of(context).pop();
              setState(() {
                _generator.saveFolder(controller.text);
              });
            }
          )
        ],
      );
    });
  }

}
 
  