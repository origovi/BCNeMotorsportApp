import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> getImageUrl(String imageName) async {
    if (imageName==null) return null;
    try {
      return await FirebaseStorage.instance.ref('profile').child(imageName).getDownloadURL();
    } catch (e) {
      // image not found
      return null;
    }
  }
}