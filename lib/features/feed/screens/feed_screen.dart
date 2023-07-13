import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/common/post_card.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final currentTheme = ref.watch(themeNotifierProvider);

    final isGuest = !user!.isAuthenticated;

    final isLoading = ref.watch(postControllerProvider);

    // function to fetch all post
    Future<void> refreshData() async {
      // Perform your asynchronous data fetching or refreshing logic

      ref.watch(userCommunitiesProvider);

      // Simulate a delay for demonstration purposes
      await Future.delayed(const Duration(seconds: 5));
    }

    return RefreshIndicator(
      color: Pallete.redColor,
      semanticsLabel: 'Refresh Feed',
      semanticsValue: 'Refresh Feed',
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () => refreshData(),
      child: ref.watch(userCommunitiesProvider).when(
            data: (communities) =>
                ref.watch(userPostsProvider(communities)).when(
                      data: (data) => data.isEmpty
                          ? isGuest
                              ? const Center(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'No Posts yet !',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Start following some communities',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'or sign in to see your feed',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'No Posts yet ! Start following some communities',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : isLoading
                              ? const Column(
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Loading Posts',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, int index) {
                                    final post = data[index];
                                    return PostCard(post: post);
                                  },
                                ),
                      loading: () => const Column(
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Loading Posts',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                      },
                    ),
            error: (Object error, StackTrace stackTrace) {
              return Column(
                children: [
                  Center(
                    child: Text('Oops! Something went wrong: $error'),
                  ),
                  const CircularProgressIndicator(),
                ],
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
    );
  }
}
