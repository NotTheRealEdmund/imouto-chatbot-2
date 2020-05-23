import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Imouto Chatbot',
      theme:  ThemeData(
        primaryColor: Colors.blue,
      ),
      home: HomePageDialogflow(),
    );
  }
}

class HomePageDialogflow extends StatefulWidget {
  HomePageDialogflow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageDialogflow createState() => _HomePageDialogflow();
}

class _HomePageDialogflow extends State<HomePageDialogflow> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                  InputDecoration.collapsed(hintText: "Say something..."),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    ChatMessage message = ChatMessage(
      text: response.getMessage() ??
        CardDialogflow(response.getListMessage()[0]).title,
      name: "Imouto",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      name: "You",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Imouto"),
      ),
      body: Column(children: <Widget>[
        Flexible(
          child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}

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