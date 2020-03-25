import 'package:flutter/material.dart';
import 'package:random_task_picker/shared_configs.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart' as Constants;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task picker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Task Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _tasks = new List();
  int _active_count = 0;
  int _completed_count = 0;
  static const String _tasks_storage = 'tasks';
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  //load list of tasks on start
  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = (prefs.getStringList(_tasks_storage)?? _tasks);
      _active_count = _tasks.length;
      _completed_count = (prefs.getStringList(Constants.COMPLETED_TASKS_STORAGE).length?? 0);
    });
  }

  //store _tasks in localStorage
  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_tasks_storage, _tasks);
  }

  //update the completed_tasks list after a task is remvoed
  void _complete_task(String task) async {
    List<String> _completed_tasks = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _completed_tasks = (prefs.getStringList(Constants.COMPLETED_TASKS_STORAGE)?? _completed_tasks);
    _completed_tasks.insert(0, task);
    prefs.setStringList(Constants.COMPLETED_TASKS_STORAGE, _completed_tasks);
  }

  //this function create a popup, which allow user to create new tasks from text input
  Future<String> _createTaskDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("New task:"),
        content: TextField(
          controller: textController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Add"),
            //create task if input is added
            onPressed: (){
              final _task = textController.text.toString();
              if (_task != null && _task != "" && !_tasks.contains(_task)){
                setState(() {/**/
                  _tasks.add(_task[0].toUpperCase()+_task.substring(1));
                  _active_count +=1;
                });
                _saveTasks();
                Navigator.pop(context);
              }
            },
          )
        ],
      );
    }
    );
  }
  Future<String> _showRandomPopup(BuildContext context) {
    Random random = new Random();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Random Task: "+_tasks[random.nextInt(_tasks.length)]),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Close"),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: getDrawer(context,_active_count,_completed_count),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Active tasks",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if(_tasks.length>0){
                _showRandomPopup(context);
              }
            }
          )
        ]
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          _createTaskDialog(context);
        },
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildTaskList(){
    return ListView.builder(
        padding: const EdgeInsets.all(0.0),
        itemBuilder: (context,i){
          return Dismissible(
            key: Key(_tasks[i]),
            onDismissed: (direction) {
              setState(() {
                _complete_task(_tasks[i]);
                _tasks.removeAt(i);
                _active_count -=1;
                _completed_count +=1;
              });
              _saveTasks();
            },
            child: Card(
              margin: const EdgeInsets.all(1.0),
              child: new ListTile(
                title: new Text(_tasks[i]),
              ),
              color: Colors.blue[100],
            ),
          );
        },
        itemCount: _tasks.length,
    );
  }
}
