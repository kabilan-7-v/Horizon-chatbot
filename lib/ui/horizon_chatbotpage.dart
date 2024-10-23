import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:horizon/service/gradienttext.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List _messages = [];
  bool isloading = false;
  String text = "";

  // Replace this with your actual API key

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _sendMessage() async {
    FocusScope.of(context).unfocus();

    setState(() {
      text = _controller.text;
    });
    _controller.clear();

    if (text != "") {
      setState(() {
        _messages.insert(0, {'text': text, 'sender': 'user', 'image': false});
      });
      setState(() {
        isloading = true;
      });

      String aiResponse = await _fetchGeminiAIResponse(text);

      setState(() {
        _messages
            .insert(0, {'text': aiResponse, 'sender': 'ai', "image": false});
      });
      setState(() {
        isloading = false;
      });
    }
  }

  static final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAfCKcnsK08BZ_ddwm2KPvuUdvzJ5lqBkA',
  );
  final chat = model.startChat(history: [
    Content.text('You are a Chat bot, your name is Horizon, helpful for user'
        "s request.")
  ]);

  _fetchGeminiAIResponse(String userInput) async {
    final response = await chat.sendMessage(
      Content.text(userInput),
    );
    return response.text ?? "Try again";
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 223, 190),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const GradientText(
          "Horizon ChatBot",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          gradient: LinearGradient(
              colors: [Color.fromRGBO(228, 212, 156, 1), Color(0xffad9c00)]),
        ),
        // title: Text(
        //   'Leviosa ChatBot',
        //   style:
        //       TextStyle(color: Colors.amber[600], fontWeight: FontWeight.bold),
        // ),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.asset("assets/Horizon-Thumbnail-1024x576 copy.png"),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = _messages[index]['sender'] == 'user';
                return _buildChatBubble(
                    _messages[index]['text']!, isUserMessage);
              },
            ),
          ),
          isloading == true
              ? Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(
                        12.0,
                      )),
                  child: Image.asset("assets/Ellipsis@1x-1.0s-200px-200px.gif"))
              : const SizedBox(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String message, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.amber[600] : Colors.black,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUserMessage ? Colors.black : Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 24, 23, 23)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.send, color: Colors.amber[600]),
              onPressed: () => _sendMessage()),
        ],
      ),
    );
  }
}
