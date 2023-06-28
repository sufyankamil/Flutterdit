import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/common/post_card.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
        data: (communities) => ref.watch(userPostsProvider(communities)).when(
              data: (data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final post = data[index];
                  return PostCard(post: post);
                },
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) {
                if(kDebugMode) {
                  print(err);
                }
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
            ),
        error: (Object error, StackTrace stackTrace) {
          return const Center(
            child: Text('Something went wrong'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
