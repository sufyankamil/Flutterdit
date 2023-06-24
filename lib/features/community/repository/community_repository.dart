import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/common/constants.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/providers/type_defs.dart';

import '../../../providers/failure.dart';
import '../../../providers/providers.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return CommunityRepository(firestore: firestore);
});

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  FutureVoid createCommunity(Community community) async {
    try{
      var communityDoc = await _communities.doc(community.name).get();
      if(communityDoc.exists){
        throw 'Community with name ${community.name} already exists';
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  // get communities where user is a member
  Stream<List<Community>> getCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((snapshot) {
     List<Community> communities = [];
     for(var doc in snapshot.docs){
       communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
     }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    // snapshot is a stream of documents and we are converting it to a stream of community objects
    return _communities.doc(name).snapshots().map((snapshot) {
      return Community.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  CollectionReference get _communities => _firestore.collection(Constants.communitiesCollection);
}