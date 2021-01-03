import 'package:flutter/material.dart';
import 'package:flutter_todo_app/providers/db_provider.dart';

class ListItem extends StatefulWidget {
  const ListItem(this.id, this.title, this.done, {Key key}) : super(key: key);

  final int id;
  final String title;
  final bool done;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  /// Variable for toggle state of todo_item
  bool check = false;
  bool firstTime = true;


  /// Convert a color from Hex to Flutter type color
  ///
  /// EXAMPLE
  ///  IN: #ebeced
  ///  OUT: FFebeced16
  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      if(firstTime) {
        check = widget.done;
        firstTime = false;
      }
    });

    return Container(
      margin: new EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 17.0,
        bottom: 17,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: _colorFromHex('#ebeced').withOpacity(0.4),
            spreadRadius: 4,
            blurRadius: 2,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400
            ),
          ),

          Spacer(),

          SizedBox(
            height: 19.0,
            width: 20.0,
            child: IconButton(
              padding: new EdgeInsets.all(0.0),
              visualDensity: VisualDensity.compact,
              icon:  Icon(
                check ? Icons.check_circle_rounded : Icons.brightness_1_outlined,
                color: _colorFromHex('#53d2a4'),
                size: 26.0,
              ),
              onPressed: () {
                setState(() {
                  check = !check;
                });
                DBProvider.db.updateTodo(widget.id, !check);
              },
            ),
          ),
        ],
      ),
    );
  }
}
