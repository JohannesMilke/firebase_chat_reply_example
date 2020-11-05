import 'dart:async';

import 'package:firebase_functions_interop/firebase_functions_interop.dart'
    hide Message;
import 'package:foundation/model/message.dart';

import 'filter.dart';

class Messages {
  static void handle() {
    functions['createMessage'] = functions.firestore
        .document('chats/{idUser}/messages/{idMessage}')
        .onCreate(createMessage);
  }

  static FutureOr<void> createMessage(
      DocumentSnapshot snap, EventContext context) async {
    try {
      final firestore = snap.firestore;
      final message = Message.fromJson(snap.data.toMap());
      final messageText = message.message;

      final cleanedMessage = await getCleanedMessage(messageText);

      if (messageText == cleanedMessage) {
        /// Message doesn't contain bad words
      } else {
        /// Message contains bad words

        /// Update chat message
        final newMessage =
            '🤐 I got BANNED for life for saying... ${cleanedMessage}';
        final update = UpdateData.fromMap({MessageField.message: newMessage});
        await snap.reference.updateData(update);

        /// Ban user
        final refBanned =
            firestore.collection('banned').document(message.idUser);
        await refBanned.setData(DocumentData.fromMap({}));
      }
    } catch (e) {
      print('Error logged: ${e}');
    }
  }
}
