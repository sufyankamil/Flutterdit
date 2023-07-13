import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils.dart';
import '../../../models/user_modal.dart';
import '../repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) => AuthController(
          authRepository: ref.watch(authRepositoryProvider),
          ref: ref,
        ));

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  authController.authStateChanges.listen((user) {
    if (user == null) {
      ref.read(userProvider.notifier).update((state) => null);
    }
  });
  return authController.authStateChanges;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading state

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  // void signInWithGoogle(BuildContext context, bool isFromLogin) async {
  //   state = true;
  //   final user = await _authRepository.signInWithGoogle(isFromLogin);
  //   state = false;
  //   user.fold(
  //     (l) => showSnackBar(context, l.message),
  //     (user) => _ref.read(userProvider.notifier).update((state) => user),
  //   );
  // }

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (user) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (user) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.logout();
  }
}
