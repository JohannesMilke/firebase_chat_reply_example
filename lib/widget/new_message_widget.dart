import 'package:firebase_chat_reply_example/api/firebase_api.dart';
import 'package:firebase_chat_reply_example/widget/reply_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foundation/model/message.dart';

class NewMessageWidget extends StatefulWidget {
  final FocusNode focusNode;
  final String idUser;
  final Message replyMessage;
  final VoidCallback onCancelReply;

  const NewMessageWidget({
    @required this.focusNode,
    @required this.idUser,
    @required this.replyMessage,
    @required this.onCancelReply,
    Key key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';

  static final inputTopRadius = Radius.circular(12);
  static final inputBottomRadius = Radius.circular(24);

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    widget.onCancelReply();

    try {
      await FirebaseApi.uploadMessage(
          widget.idUser, message, widget.replyMessage);
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('You have been banned for using bad words'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isReplying = widget.replyMessage != null;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                if (isReplying) buildReply(),
                TextField(
                  focusNode: widget.focusNode,
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topLeft: isReplying ? Radius.zero : inputBottomRadius,
                        topRight: isReplying ? Radius.zero : inputBottomRadius,
                        bottomLeft: inputBottomRadius,
                        bottomRight: inputBottomRadius,
                      ),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    message = value;
                  }),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: message.trim().isEmpty ? null : sendMessage,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReply() => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: inputTopRadius,
            topRight: inputTopRadius,
          ),
        ),
        child: ReplyMessageWidget(
          message: widget.replyMessage,
          onCancelReply: widget.onCancelReply,
        ),
      );
}
