import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/providers/failure.dart';
import 'package:reddit/providers/providers.dart';
import 'package:reddit/providers/type_defs.dart';

final storageRepositoryProvider = Provider((ref) => StorageRepository(
  firebaseStorage: ref.watch(storageProvider),
));

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> uploadFile({required String path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);

      UploadTask uploadTask = ref.putFile(file!);

      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? ''));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}