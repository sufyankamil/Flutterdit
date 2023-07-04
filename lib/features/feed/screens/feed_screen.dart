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
            data: (data) => data.length == 0
                ? const Center(
                    child: Text(
                      'No Posts yet ! Start following some communities',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                  ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (err, stack) {
              return Column(
                children: [
                  Center(
                    child: Text(err.toString()),
                  ),
                  const CircularProgressIndicator(),
                ],
              );
            }),
        error: (Object error, StackTrace stackTrace) {
          return const Center(
            child: Text('Something went wrong !'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
