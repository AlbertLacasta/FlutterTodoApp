
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/todo_model.dart';
import 'package:flutter_todo_app/providers/db_provider.dart';
import 'package:flutter_todo_app/providers/todo_api_provider.dart';

import '../widgets/list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  /// convert hec color to Flutter Color
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  /// Global variables
  var isLoading = false;

  /// used key to re-render list
  var renderKey = 0;
  Future<List<Todo>> todos;

  final newTodoController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newTodoController.dispose();
    super.dispose();
  }

  /// Async function to get todo's on load component
  void _getTodos() async {
    setState(() {
      isLoading = true;
    });
    await TodoApiProvider().getAllTodos().then((value) => {
      setState(() {
        isLoading = false;
        todos = DBProvider.db.getAllTodos();
      })
    });
  }

  /// On mounted call custom function
  @override
  void initState() {
    _getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: _colorFromHex('#fcfdfe'),

     /******************************************************************
     * App Bar
     ******************************************************************/
      appBar: AppBar(
        backgroundColor: _colorFromHex('#fcfdfe'),
        elevation: 0.0,
        bottomOpacity: 0.0,

        /**********************************
         *  Toggle grid/list VIEW
         **********************************/
        leading: SizedBox(
          height: 19.0,
          width: 70.0,
          child: IconButton(
            padding: new EdgeInsets.all(0.0),
            visualDensity: VisualDensity.compact,
            icon:  Icon(
              Icons.dashboard_outlined  ,
              color:  _colorFromHex('#5099d9'),
              size: 28.0,
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
                ++renderKey;
                todos = TodoApiProvider().getAllTodos();
                isLoading = false;
              });
            },
          ),
        ),
        /**********************************
         *  Title
         **********************************/
        title: Text(
          'All Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w300
          )
        ),
        actions: <Widget>[
          /**********************************
           *  Delete todo's
           **********************************/
          SizedBox(
            height: 19.0,
            width: 70.0,
            child: IconButton(
              padding: new EdgeInsets.all(0.0),
              visualDensity: VisualDensity.compact,
              icon:  Icon(
                Icons.delete ,
                color: _colorFromHex('#53d2a4'),
                size: 26.0,
              ),
              onPressed: () {
                DBProvider.db.deleteAllTodos();
                setState(() {
                  isLoading = true;
                  ++renderKey;
                  todos = DBProvider.db.getAllTodos();
                  isLoading = false;
                });
              },
            ),
          ),
        ],
      ),

      /******************************************************************
       * TODOS list
       ******************************************************************/
      body:_buildTodoListView(),

      /******************************************************************
       * Bottom sheet (Add)
       ******************************************************************/
      floatingActionButton:
        Container(
          height: 80.0,
          width: 80.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(30.0),
                      height: 190,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 69.0,
                            child:
                              TextField(
                                controller: newTodoController,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter your todo',
                                ),
                              ),
                          ),
                          Row(
                            children: <Widget>[
                              /**********************************
                               *  Close
                               **********************************/
                              SizedBox(
                                height: 19.0,
                                width: 20.0,
                                child: IconButton(
                                  padding: new EdgeInsets.all(0.0),
                                  visualDensity: VisualDensity.compact,
                                  icon:  Icon(
                                     Icons.close,
                                    size: 26.0,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    newTodoController.text = "";
                                  },
                                ),
                              ),

                              Spacer(),

                              /**********************************
                               *  Add action
                               **********************************/
                              FlatButton(
                                color: Colors.transparent,
                                child: const Text('Add', style: TextStyle(color:  Colors.lightBlue),),
                                onPressed: () => {
                                  Navigator.pop(context),
                                  DBProvider.db.createTodo(new Todo( text: newTodoController.text, done: false)),
                                  newTodoController.text = "",
                                  setState(() {
                                    ++renderKey;
                                    todos = DBProvider.db.getAllTodos();
                                  }),
                                }
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              elevation: 7,
              child: Icon(Icons.add, size: 27.0),
              backgroundColor: _colorFromHex('#4c96d9'),
            ),
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }

  /******************************************************************
   * Builder todo list
   ******************************************************************/
  _buildTodoListView() {
    return FutureBuilder(
      key: ValueKey<int>(renderKey),
      future: todos,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(isLoading) {
          return Center(
            child: CircularProgressIndicator(
              value: null,
              strokeWidth: 4.0,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data.length == 0) {
          return Center(
            child: Text("You dont have any items"),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListItem(snapshot.data[index].id, snapshot.data[index].text, snapshot.data[index].done);
            },
          );
        }
      }
    );
  }
}
