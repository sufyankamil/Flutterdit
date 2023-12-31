import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  CollectionReference get _users =>
      _firestore.collection(Constants.usersCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        userCredential = await _auth.signInWithPopup(googleProvider);

        await _auth.setPersistence(Persistence.LOCAL);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        final credential = GoogleAuthProvider.credential(
          accessToken: (await googleUser!.authentication).accessToken,
          idToken: (await googleUser.authentication).idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }
      // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: (await googleUser!.authentication).accessToken,
      //   idToken: (await googleUser.authentication).idToken,
      // );

      // userCredential = await _auth.signInWithCredential(credential);

      UserModel user;

      if (userCredential.additionalUserInfo!.isNewUser) {
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
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til'
          ],
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

  // FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: (await googleUser!.authentication).accessToken,
  //       idToken: (await googleUser.authentication).idToken,
  //     );

  //     UserCredential userCredential;

  //     if (isFromLogin) {
  //       userCredential = await _auth.signInWithCredential(credential);
  //     } else {
  //       userCredential =
  //           await _auth.currentUser!.linkWithCredential(credential);
  //     }

  //     UserModel user;

  //     if (userCredential.additionalUserInfo!.isNewUser) {
  //       // create user in firestore
  //       user = UserModel(
  //         name: userCredential.user!.displayName!,
  //         email: userCredential.user!.email!,
  //         photoUrl: userCredential.user!.photoURL ?? Constants.avatarDefault,
  //         banner: Constants.bannerDefault,
  //         uid: userCredential.user!.uid,
  //         lastSeen: DateTime.now().toString(),
  //         isAuthenticated: true, // user is not guest
  //         // emailVerified: false,
  //         karma: 0,
  //         awards: [
  //           'awesomeAns',
  //           'gold',
  //           'platinum',
  //           'helpful',
  //           'plusone',
  //           'rocket',
  //           'thankyou',
  //           'til'
  //         ],
  //       );
  //       await _users.doc(userCredential.user!.uid).set(user.toMap());
  //     } else {
  //       user = await getUserData(userCredential.user!.uid).first;
  //     }
  //     return right(user);
  //     // await _auth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.message!, backgroundColor: Colors.red, timeInSecForIosWeb: 10);

  //     throw e.message!;
  //   } catch (e) {
  //     print(e.toString());
  //     return left(Failure(e.toString()));
  //   }
  // }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();

      UserModel user = UserModel(
        name: 'Guest',
        email: Constants.defaultEmail,
        photoUrl: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        lastSeen: DateTime.now().toString(),
        isAuthenticated: false, // user is not guest
        karma: 0,
        awards: [],
      );

      await _users.doc(userCredential.user!.uid).set(user.toMap());

      return right(user);
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
