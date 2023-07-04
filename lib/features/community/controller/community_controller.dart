import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/providers/failure.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/constants.dart';
import '../../../common/utils.dart';
import '../../../models/post_model.dart';
import '../../../providers/storage_repository.dart';
import '../repository/community_repository.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);

  final storageRepository = ref.watch(storageRepositoryProvider);

  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getAllCommunityPostsProvider = StreamProvider.family<List<Post>, String>(
  (ref, name) {
    return ref
        .read(communityControllerProvider.notifier)
        .getCommunityPost(name);
  },
);

// StreamProvider helps in cashing the data
final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider =
    StreamProvider.family<List<Community>, String>((ref, String query) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;

  final Ref _ref;

  final StorageRepository _storageRepository;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      name: name,
      description: 'Community for $name',
      members: [uid],
      moderators: [uid],
      avatar: Constants.avatarDefault,
      banner: Constants.bannerDefault,
      id: name,
    );

    final result = await _communityRepository.createCommunity(community);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(Community community, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Either<Failure, void> result;
    if (community.members.contains(uid)) {
      result = await _communityRepository.leaveCommunity(community.name, uid);
    } else {
      result = await _communityRepository.joinCommunity(community.name, uid);
    }
    result.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(uid)) {
        showSnackBar(context, 'Community left successfully');
      } else {
        showSnackBar(context, 'Community joined successfully');
      }
    });
    state = false;
  }

  Stream<List<Community>> getCommunities() {
    final uid = _ref.read(userProvider)?.uid ?? '';
    return _communityRepository.getCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required Community community,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      final result = await _storageRepository.uploadFile(
        path: 'community/profile',
        file: profileFile,
        id: community.name,
      );
      result.fold((l) => showSnackBar(context, l.message), (r) async {
        community = community.copyWith(avatar: r);
      });
    }
    if (bannerFile != null) {
      final result = await _storageRepository.uploadFile(
        path: 'community/banner',
        file: bannerFile,
        id: community.name,
      );
      result.fold((l) => showSnackBar(context, l.message), (r) async {
        community = community.copyWith(banner: r);
      });
    }

    final result = await _communityRepository.editCommunity(community);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community edited successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    state = true;
    final result = await _communityRepository.addMods(communityName, uids);
    result.fold((l) => showSnackBar(context, l.message), (r) {
      Routemaster.of(context).pop();
      showSnackBar(context, 'Mods added successfully');
    });
    state = false;
  }

  Stream<List<Post>> getCommunityPost(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
