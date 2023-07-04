import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/common/enums.dart';
import 'package:reddit/models/post_model.dart';
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

  Stream<List<Post>> getUserPosts(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  FutureVoid updateUserKarma(UserModel userModel) async {
    try {
      return right(_users.doc(userModel.uid).update(
        {'karma': userModel.karma},
      ));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(Constants.usersCollection);

  CollectionReference get _posts =>
      _firestore.collection(Constants.postsCollection);
}
