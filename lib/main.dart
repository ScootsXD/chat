// @dart=2.9

import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

void main()
{
  runApp(DeimosDialogflowApp());
}

class DeimosDialogflowApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, 
      home: DeimosAppHome(),
    );
  }
}

class DeimosAppHome extends StatefulWidget
{
  @override
  _DeimosAppHomeState createState() => _DeimosAppHomeState();
}

class _DeimosAppHomeState extends State<DeimosAppHome>
{
  final TextEditingController _controller = TextEditingController();
  final DialogFlowtter _dialogFlowtter = DialogFlowtter();
   List<Map<String, dynamic>> messages = [];

  void sendMessage(String text) async
  {
    if (text.isEmpty) return;
    setState(()
    {
      Message userMessage = Message(text: DialogText(text: [text]));
      addMessage(userMessage, true);
    });

    QueryInput query = QueryInput(text: TextInput(text: text));

    DetectIntentResponse res = await _dialogFlowtter.detectIntent(
      queryInput: query,
    );

    if (res.message == null) return;

    setState(()
    {
      addMessage(res.message);
    });
  }

  void addMessage(Message message, [bool isUserMessage = false])
  {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: _MessagesList(
              messages: messages
            ),
          ), 
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
            color: Colors.blue,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: new InputDecoration.collapsed(
                      hintText: "Escribir aqui",
                      hintStyle: TextStyle(color: Colors.grey[50]),
                    ),
                    style: TextStyle(color: Colors.white),
                    controller: _controller,
                  ),
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.send),
                  onPressed: ()
                  {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesList extends StatelessWidget
{
  final List<Map<String, dynamic>> messages;

  const _MessagesList({
    Key key,
    this.messages = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return ListView.separated(
      itemCount: messages.length,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        var obj = messages[messages.length - 1 - i];
        return _MessageContainer(
          message: obj['message'],
          isUserMessage: obj['isUserMessage'],
        );
      },

      reverse: true,
    );
  }
}

class _MessageContainer extends StatelessWidget
{
  final Message message;
  final bool isUserMessage;

  const _MessageContainer({
    Key key,
    @required this.message,
    this.isUserMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Row(
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.blue : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            
            padding: const EdgeInsets.all(10),
            child: Text(
              message.text.text[0] ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}