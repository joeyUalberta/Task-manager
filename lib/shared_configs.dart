import 'completed_tasks.dart';
import 'package:flutter/material.dart';
import 'main.dart';

Widget getDrawer(context, active_count, completed_count){
   return Drawer(
      child: ListView(
        //padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: Text("Active"),
            leading: Icon(Icons.folder),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => MyHomePage(),
              ));
            },
            trailing: Chip(
              backgroundColor: Colors.deepPurple,
              label: Text(active_count.toString(), style: TextStyle(color: Colors.white),),
            ),
          ),
          ListTile(
            title: Text("Completed"),
            leading: Icon(Icons.history),
            onTap: (){
              //Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => CompletedPage(),
              ));
            },
            trailing: Chip(
              backgroundColor: Colors.deepPurple,
              label: Text(completed_count.toString(), style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      )
  );
}
