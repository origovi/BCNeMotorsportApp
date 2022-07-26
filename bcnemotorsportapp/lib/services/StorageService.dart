import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static Future<String> getImageUrl(String imageName) async {
    // /*TEMP*/ return null;
    if (imageName==null) return null;
    try {
      return await FirebaseStorage.instance.ref('profile').child(imageName).getDownloadURL();
    } catch(e) {
      // image not found
      return null;
    }
  }

  static Future<void> uploadProfileImage(PickedFile image, String name) async {
    UploadTask res = FirebaseStorage.instance.ref('profile').child(name).putData(await image.readAsBytes());
    await res.whenComplete((){});
  }
}