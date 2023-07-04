import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/post/repository/post_repository.dart';
import 'package:reddit/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../common/utils.dart';
import '../../../models/community_model.dart';
import '../../../providers/storage_repository.dart';
import '../../auth/controller/auth_controller.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);

  final storageRepository = ref.watch(storageRepositoryProvider);

  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userPostsProvider = StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;

  final Ref _ref;

  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      description: description,
      communityName: selectedCommunity.name,
      communityProfile: selectedCommunity.avatar,
      createdAt: DateTime.now(),
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      awards: [],
    );

    final result = await _postRepository.addPost(post);
    state = false;
    result.fold(
      (failure) {
        showSnackBar(context, failure.message);
      },
      (success) {
        showSnackBar(context, 'Post created successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      description: link,
      communityName: selectedCommunity.name,
      communityProfile: selectedCommunity.avatar,
      createdAt: DateTime.now(),
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      awards: [],
    );

    final result = await _postRepository.addPost(post);
    state = false;
    result.fold(
      (failure) {
        showSnackBar(context, failure.message);
      },
      (success) {
        showSnackBar(context, 'Post created successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final imageResult = await _storageRepository.uploadFile(
      file: file!,
      path: 'post/${selectedCommunity.name}',
      id: postId,
    );

    imageResult.fold(
      (failure) {
        showSnackBar(context, failure.message);
      },
      (success) async {
        final Post post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfile: selectedCommunity.avatar,
          createdAt: DateTime.now(),
          upVotes: [],
          downVotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          awards: [],
          link: success,
          description: success,
        );

        final result = await _postRepository.addPost(post);
        state = false;
        result.fold(
          (failure) {
            showSnackBar(context, failure.message);
          },
          (success) {
            showSnackBar(context, 'Post created successfully');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if(communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    } else {
      return Stream.value([]);
    }
  }
}
