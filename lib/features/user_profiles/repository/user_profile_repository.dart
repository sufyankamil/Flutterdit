import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/models/user_modal.dart';

import '../../../common/constants.dart';
import '../../../providers/failure.dart';
import '../../../providers/providers.dart';
import '../../../providers/type_defs.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserProfileRepository(firestore: firestore);
});


class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(Constants.usersCollection);
}