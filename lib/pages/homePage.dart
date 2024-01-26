import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/models/task.dart';
class HomePage extends StatefulWidget{
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage>{
  late double _dheight, _dwidth;
  String? _newTask; 
  Box? _box;
  _HomeState();

  @override
  Widget build(BuildContext context) {
    _dheight = MediaQuery.of(context).size.height;
    _dwidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:_dheight*0.10 ,
        title: const Text("To Do List",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          ),
        ),
        backgroundColor:const Color.fromRGBO(117, 106, 182, 1.0),
      ),
      body: _taskView(),
      floatingActionButton: _addTask(),
    );
  }
  Widget _taskView(){
    return FutureBuilder(future: Hive.openBox('tasks'), 
      builder: (BuildContext _context,AsyncSnapshot _snapshot) {
        if(_snapshot.hasData){
          _box = _snapshot.data;
          return _task();
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  Widget _task(){
    List tasks=_box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context,int _index){
        var task=Task.fromMap(tasks[_index]);
        return ListTile(
          title: Text(task.content,
          style: TextStyle(
            decoration: task.done ? TextDecoration.lineThrough : null
          ),
          ),
          subtitle: Text(task.samay.toString()),
          trailing: Icon(
            task.done ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
            color: const Color.fromRGBO(117, 106, 182, 1.0),
          ),
          onTap: () {
            task.done=!task.done;
            _box!.putAt(_index, task.tomap());
            setState(() {
              
            });
          },
          onLongPress: () {
            _box!.deleteAt(_index);
            setState(() {
              
            });
          },
        );
      });
  }
  Widget _addTask(){
    return FloatingActionButton(onPressed: _enterTask,
      backgroundColor:const Color.fromRGBO(117, 106,182, 1.0),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      
    );
  }

  void _enterTask(){
    showDialog(context: context, 
    builder: (BuildContext _context) {
      return AlertDialog(
        title: const Text("Add New Task :)"),
        content: TextField(
          onSubmitted: (_) {
            if(_newTask!=null){
              var _taskk=Task(content: _newTask!, samay: DateTime.now(), done: false);
              _box!.add(_taskk.tomap());
              setState(() {
                _newTask=null;
                Navigator.pop(context);
              });
            }
          },
          onChanged: (_value) {
            setState(() {
              _newTask=_value;
            });
          },
        ),
      );
    });
  }
}