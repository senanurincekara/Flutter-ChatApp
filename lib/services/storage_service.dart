import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService();

  Future<String?> uploadUserPfp(
      {required File file, required String uid}) async {
    try {
      Reference fileRef = _firebaseStorage
          .ref('/users/pfps')
          .child('$uid${p.extension(file.path)}');

      UploadTask task = fileRef.putFile(file);

      TaskSnapshot snapshot = await task;

      if (snapshot.state == TaskState.success) {
        String downloadUrl = await fileRef.getDownloadURL();
        return downloadUrl;
      } else {
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  Future<String?> uploadImageToChat(
      {required File file, required String chatID}) async {
    try {
      Reference fileRef = _firebaseStorage.ref('/chats/$chatID').child(
          '${DateTime.now().toIso8601String()}${p.extension(file.path)}');

      UploadTask task = fileRef.putFile(file);

      TaskSnapshot snapshot = await task;

      if (snapshot.state == TaskState.success) {
        String downloadUrl = await fileRef.getDownloadURL();
        return downloadUrl;
      } else {
        return null;
      }
    } catch (e) {
      print('Error uploading chat img: $e');
      return null;
    }
  }
}
