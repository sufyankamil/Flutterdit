import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/common/constants.dart';
import 'package:reddit/providers/type_defs.dart';

import '../../../models/community_model.dart';
import '../../../models/post_model.dart';
import '../../../providers/failure.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(firestore: FirebaseFirestore.instance);
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  FutureVoid addPost(Post post) async {
    try {
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // first repo => controller => provider(in controller top)
  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    try {
      return _post
          .where('communityName',
              whereIn: communities.map((e) => e.name).toList())
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
    // return _post
    //     .where('communityName',
    //         whereIn: communities.map((e) => e.name).toList())
    //     .orderBy('createdAt', descending: true)
    //     .snapshots()
    //     .map(
    //       (event) => event.docs
    //           .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
    //           .toList(),
    //     );
  }

  CollectionReference get _post =>
      _firestore.collection(Constants.postsCollection);
}
