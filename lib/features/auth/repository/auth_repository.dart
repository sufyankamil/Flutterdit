import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/models/user_modal.dart';

import '../../../common/constants.dart';
import '../../../providers/failure.dart';
import '../../../providers/providers.dart';
import '../../../providers/type_defs.dart';

// authRepo is a provider that returns an instance of AuthRepository
final authRepositoryProvider = Provider((ref) => AuthRepository(
  firestore: ref.read(firestoreProvider),
  auth: ref.read(firebaseAuthProvider),
  googleSignIn: ref.read(googleSignInProvider),
));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection(Constants.usersCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async{
    try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final credential = GoogleAuthProvider.credential(
        accessToken: (await googleUser!.authentication).accessToken,
        idToken: (await googleUser.authentication).idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      UserModel user;

      if(userCredential.additionalUserInfo!.isNewUser){
        // create user in firestore
        user = UserModel(
          name: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
          photoUrl: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          lastSeen: DateTime.now().toString(),
          isAuthenticated: true, // user is not guest
          // emailVerified: false,
          karma: 0,
          awards: [],
        );
        print('new user');
        // print(user);
        await _users.doc(userCredential.user!.uid).set(user.toMap());

      } else {
        // get user from firestore
        print('user already exists');
        print(userCredential.user!);
        user = await getUserData(userCredential.user!.uid).first;
      }
      return right(user);
      // await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e.toString());
      return left(Failure(e.toString()));
    }
  }

  // Stream is used to listen to changes in the user's authentication state (persisted in local storage)
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) {
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}