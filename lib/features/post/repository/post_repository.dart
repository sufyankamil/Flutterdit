import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/common/constants.dart';
import 'package:reddit/providers/type_defs.dart';

import '../../../models/comment_model.dart';
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
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_post.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upVote(Post post, String userId) async {
    if (post.downVotes.contains(userId)) {
      _post.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.upVotes.contains(userId)) {
      _post.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _post.doc(post.id).update({
        'upVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downVote(Post post, String userId) async {
    if (post.upVotes.contains(userId)) {
      _post.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.downVotes.contains(userId)) {
      _post.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _post.doc(post.id).update({
        'downVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Post> getpostById(String id) {
    try {
      return _post.doc(id).snapshots().map(
            (event) => Post.fromMap(event.data() as Map<String, dynamic>),
          );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  FutureVoid addComments(Comments comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_post.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comments>> getComments(String postId) {
    try {
      return _comments
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .map((e) => Comments.fromMap(e.data() as Map<String, dynamic>))
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  CollectionReference get _post =>
      _firestore.collection(Constants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(Constants.commentsCollection);
}
