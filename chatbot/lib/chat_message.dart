import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  // Imouto ListView item
  List<Widget> otherMessage(context) {
    // Row with Avatar on the left and Column on the right
    return <Widget>[
      // Avatar
      Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 16, 0),
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage("assets/imouto.png"),
        ),
      ),
      // Column containing the name and text
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  // User ListView item
  List<Widget> myMessage(context) {
    // Row with Column on the left and Avatar on the right 
    return <Widget>[
      // Column containing the name and text
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
      // Avatar
      Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 8, 0),
        child: CircleAvatar(
          radius: 30.0,
          child: Text(
            this.name[0],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}