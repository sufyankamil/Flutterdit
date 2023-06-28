import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/post/repository/post_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../models/community_model.dart';
import '../../../providers/storage_repository.dart';


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

  void shareText({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
}) async {
    state = true;
    String postId = Uuid().v4();
  }
}