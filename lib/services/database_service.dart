import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/models/chat_model.dart';
import 'package:chatapp/models/message_model.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;

  CollectionReference<userProfile>? _usersCollection;
  CollectionReference? _chatsCollection;

  DatabaseService() {
    _setUpCollectionReferences();
    _authService = _getIt.get<AuthService>();
  }

  void _setUpCollectionReferences() {
    _usersCollection = _firebaseFirestore
        .collection('users')
        .withConverter<userProfile>(
            fromFirestore: (snapshots, _) =>
                userProfile.fromJson(snapshots.data()!),
            toFirestore: (userProfile, _) => userProfile.toJson());

    //chats
    _chatsCollection = _firebaseFirestore
        .collection('chats')
        .withConverter<Chat>(
            fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
            toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> createUserProfile({required userProfile userprofile}) async {
    await _usersCollection?.doc(userprofile.uid).set(userprofile);
  }

  //logged users burada
  Stream<QuerySnapshot<userProfile>> getUserProfiles() {
    return _usersCollection!
        .where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots();
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatId(uid1: uid1, uid2: uid2);
    final result = await _chatsCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);
    final chat = Chat(id: chatID, participants: [uid1, uid2], messages: []);

    await docRef?.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    String chatID = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatsCollection!.doc(chatID);

    try {
      await docRef.update({
        "messages": FieldValue.arrayUnion([
          message.toJson(),
        ])
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    String chatID = generateChatId(uid1: uid1, uid2: uid2);
    return _chatsCollection?.doc(chatID).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }
}
