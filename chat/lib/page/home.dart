import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class home extends StatefulWidget {
  const home({super.key});
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<ChatUser> _typingUsers = <ChatUser>[];
  final Gemini _gemini = Gemini.instance;
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: "vishal", lastName: 'kumar');
  final ChatUser _geminiuser =
      ChatUser(id: '2', firstName: 'Golden', lastName: 'MIC');
  List<ChatMessage> _message = <ChatMessage>[];
  bool _isLoading = true;

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user's message to the chat
    setState(() {
      _message.insert(
        0,
        ChatMessage(user: _currentUser, text: text, createdAt: DateTime.now()),
      );
      _isLoading = true;
    });

    try {
      // Use the Gemini chat API to get a response
      final response = await _gemini.chat([
        Content(parts: [Part.text(text)], role: 'user'),
      ]);

      if (response?.output != null) {
        setState(() {
          _message.insert(
            0,
            ChatMessage(
              user: _geminiuser,
              text: response!.output ?? '',
              createdAt: DateTime.now(),
            ),
          );
        });
      }
    } catch (error) {
      print('Error occurred: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Optional: Remove back button
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Chat here",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: DashChat(
        messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.blue,
            containerColor: Colors.blue,
            textColor: Colors.white),
        currentUser: _currentUser,
        onSend: (ChatMessage m) {
          getresponse(m);
        },
        messages: _message,
        typingUsers: _typingUsers,
      ),
    );
  }

  Future<void> getresponse(ChatMessage m) async {
    setState(() {
      _sendMessage(m.text);
    });
  }
}
