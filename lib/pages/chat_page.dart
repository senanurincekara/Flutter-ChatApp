import 'dart:io';

import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:chatapp/services/image_serrvice.dart';
import 'package:chatapp/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final userProfile chatUser;

  const ChatPage({super.key, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late DatabaseService _databaseService;
  late MediaService _mediaService;
  late StorageService _storageService;

  ChatUser? currentUser, otherUser;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();

    currentUser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName,
    );

    otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name,
      profileImage: widget.chatUser.profilePicUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppbar(context, widget.chatUser.name!),
          SizedBox(height: 10),
          _chat(),
        ],
      ),
    );
  }

  Widget _chat() {
    return Flexible(
      flex: 1, // Adjust the flex value based on your layout needs
      child: Container(
        height: 650, // Set your desired height here
        width: MediaQuery.sizeOf(context).width - 40,
        decoration: BoxDecoration(
          color: Color.fromRGBO(249, 149, 176, 40 / 100),
          border: Border.all(color: Color(0xFF85486B)),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: StreamBuilder(
          stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
          builder: (context, snapshot) {
            Chat? chat = snapshot.data?.data();
            List<ChatMessage> messages = [];
            if (chat != null && chat.messages != null) {
              messages = _generateChatMessagesList(chat.messages!);
            }

            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30.0),
              child: DashChat(
                messageOptions: const MessageOptions(
                  showOtherUsersAvatar: true,
                  showTime: true,
                  containerColor: Color(0x66F995B0),
                  currentUserContainerColor: Color(0xFF85486B),
                ),
                inputOptions: InputOptions(
                  alwaysShowSend: false,
                  cursorStyle: CursorStyle(color: Colors.white),
                  trailing: [_mediaMessageButton()],
                  inputDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 28,
                      top: 10,
                      bottom: 10,
                    ),
                    hintText: "Message",
                    hintStyle: GoogleFonts.indieFlower(fontSize: 20),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFF85486B)),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
                currentUser: currentUser!,
                onSend: _sendMessage,
                messages: messages,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 4,
                left: 30,
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 80,
                  height: 70,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 175, 108, 146),
                        blurRadius: 0.9,
                        offset: Offset(0, 1),
                        spreadRadius: 0.05,
                      ),
                    ],
                    color: Colors.white,
                    border: Border.all(color: Color(0xFF85486B)),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Color(0xFF85486B),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.sizeOf(context).width - 150,
                bottom: 1,
                child: Image.asset(
                  "assets/images/homePageIcon.png",
                  width: 110,
                  height: 110,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias?.first.type == MediaType.image) {
        Message message = Message(
          senderID: chatMessage.user.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(chatMessage.createdAt),
        );
        await _databaseService.sendChatMessage(
          currentUser!.id,
          otherUser!.id,
          message,
        );
      }
    } else {
      Message message = Message(
        senderID: currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: Timestamp.fromDate(chatMessage.createdAt),
      );

      await _databaseService.sendChatMessage(
        currentUser!.id,
        otherUser!.id,
        message,
      );
    }
  }

  List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      if (m.messageType == MessageType.Image) {
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          createdAt: m.sentAt!.toDate(),
          medias: [
            ChatMedia(url: m.content!, fileName: "", type: MediaType.image),
          ],
        );
      } else {
        return ChatMessage(
          user: m.senderID == currentUser!.id ? currentUser! : otherUser!,
          createdAt: m.sentAt!.toDate(),
          text: m.content!,
        );
      }
    }).toList();
    chatMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        File? file = await _mediaService.getIamgeFromGallery();
        if (file != null) {
          String chatID =
              generateChatId(uid1: currentUser!.id, uid2: otherUser!.id);
          String? downloadURL = await _storageService.uploadImageToChat(
              file: file, chatID: chatID);
          if (downloadURL != null) {
            ChatMessage chatMessage = ChatMessage(
              user: currentUser!,
              createdAt: DateTime.now(),
              medias: [
                ChatMedia(
                    url: downloadURL, fileName: "", type: MediaType.image),
              ],
            );

            _sendMessage(chatMessage);
          }
        }
      },
      icon: Icon(
        Icons.image,
        color: Color(0xFF85486B),
        size: 40,
      ),
    );
  }
}
