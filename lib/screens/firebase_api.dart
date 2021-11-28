import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(var clave, File image) {
    final ref = FirebaseStorage.instance.ref('productos/$clave');
    return ref.putFile(image);
  }
}
