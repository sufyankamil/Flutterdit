import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/constants.dart';
import '../../../common/utils.dart';
import '../repository/community_repository.dart';

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
  );
});

// StreamProvider helps in cashing the data
final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;

  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _ref = ref,
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

  Stream<List<Community>> getCommunities() {
    final uid = _ref.read(userProvider)?.uid ?? '';
    return _communityRepository.getCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }
}