import 'package:firebase_chat_reply_example/widget/messages_widget.dart';
import 'package:firebase_chat_reply_example/widget/new_message_widget.dart';
import 'package:firebase_chat_reply_example/widget/profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:foundation/model/message.dart';
import 'package:foundation/model/user.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({
    @required this.user,
    Key key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final focusNode = FocusNode();
  Message replyMessage;

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.user.name),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(
                    idUser: widget.user.idUser,
                    onSwipedMessage: (message) {
                      replyToMessage(message);
                      focusNode.requestFocus();
                    },
                  ),
                ),
              ),
              NewMessageWidget(
                focusNode: focusNode,
                idUser: widget.user.idUser,
                onCancelReply: cancelReply,
                replyMessage: replyMessage,
              )
            ],
          ),
        ),
      );

  void replyToMessage(Message message) {
    setState(() {
      replyMessage = message;
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }
}
