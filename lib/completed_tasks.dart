import 'package:flutter/material.dart';
import 'shared_configs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart' as Constants;

class CompletedPage extends StatefulWidget{
  @override
  _CompletedPageState createState() {
    // TODO: implement createState
    return _CompletedPageState();
  }
}
class _CompletedPageState extends State<CompletedPage>{
  List<String> _completed_tasks = new List();
  int _active_count = 0;
  int _completed_count = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  //load list of completed tasks on start
  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _completed_tasks = (prefs.getStringList(Constants.COMPLETED_TASKS_STORAGE)?? _completed_tasks);
      _active_count = (prefs.getStringList(Constants.ACTIVE_TASKS_STORAGE).length?? 0);
      _completed_count = _completed_tasks.length;
    });
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(Constants.COMPLETED_TASKS_STORAGE, _completed_tasks);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: getDrawer(context,_active_count,_completed_count),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
          title: Text("Completed"),
      ),
      body: _buildCompletedList(),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildCompletedList(){
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (context,i){
        return Dismissible(
          key: Key(_completed_tasks[i]),
          onDismissed: (direction) {
            setState(() {
              _completed_tasks.removeAt(i);
              _completed_count -=1;
            });
            _saveTasks();
          },
          child: Card(
            margin: const EdgeInsets.all(1.0),
            child: new ListTile(
              title: new Text(_completed_tasks[i]),
            ),
            color: Colors.blue[100],
          ),
        );
      },
      itemCount: _completed_tasks.length,
    );
  }
}