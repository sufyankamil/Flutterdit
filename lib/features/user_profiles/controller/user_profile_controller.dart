import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/models/user_modal.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/utils.dart';
import '../../../providers/storage_repository.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/user_profile_repository.dart';

final userProfileControllerProvider =
StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);

  final storageRepository = ref.watch(storageRepositoryProvider);

  return UserProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;

  final Ref _ref;

  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final result = await _storageRepository.uploadFile(
        path: 'users/profile',
        file: profileFile,
        id: user.uid,
      );
      result.fold((l) => showSnackBar(context, l.message), (r) async {
        user = user.copyWith(photoUrl: r);
      });
    }
    if (bannerFile != null) {
      final result = await _storageRepository.uploadFile(
        path: 'users/banner',
        file: bannerFile,
        id: user.uid,
      );
      result.fold((l) => showSnackBar(context, l.message), (r) async {
        user = user.copyWith(banner: r);
      });
    }

    user = user.copyWith(name: name);

    final result = await _userProfileRepository.editProfile(user);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      showSnackBar(context, 'Profile edited successfully');
      Routemaster.of(context).pop();
    });
  }
}
