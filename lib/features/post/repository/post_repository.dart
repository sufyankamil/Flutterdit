import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/common/constants.dart';
import 'package:reddit/providers/type_defs.dart';

import '../../../models/post_model.dart';
import '../../../providers/failure.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(firestore: FirebaseFirestore.instance);
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  FutureVoid addPost(Post post) async{
    try{
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }


  CollectionReference get _post => _firestore.collection(Constants.postsCollection);



}