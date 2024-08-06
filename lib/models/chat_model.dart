import 'package:chatapp/models/message_model.dart';

class Chat {
  String? id;
  List<String>? participants;
  List<Message>? messages;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['participants']);
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages?.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['participants'] = participants;
    if (messages != null) {
      data['messages'] = messages?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
