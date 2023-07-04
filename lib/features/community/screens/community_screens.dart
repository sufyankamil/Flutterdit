import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/post_card.dart';
import '../../auth/controller/auth_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({Key? key, required this.name}) : super(key: key);

  void navigateToModerator(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, BuildContext context, Community community) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    expandedHeight: 200,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            community.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        community.members.contains(user.uid)
                            ? Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        NetworkImage(community.avatar),
                                  ),
                                  title: community.members.length > 1
                                      ? Text(
                                          '${community.name} - ${community.members.length} members')
                                      : Text(
                                          '${community.name} - ${community.members.length} member'),
                                  subtitle: Text(community.description),
                                  trailing:
                                      community.moderators.contains(user.uid)
                                          ? OutlinedButton(
                                              onPressed: () {
                                                navigateToModerator(context);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                side: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                              child: const Text('Moderator'),
                                            )
                                          : OutlinedButton(
                                              onPressed: () => joinCommunity(
                                                  ref, context, community),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                side: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                              child: const Text('Leave'),
                                            ),
                                ),
                              )
                            : Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          NetworkImage(community.avatar),
                                    ),
                                    title: community.members.length > 1
                                        ? Text(
                                            '${community.name} - ${community.members.length} members')
                                        : Text(
                                            '${community.name} - ${community.members.length} member'),
                                    subtitle: Text(community.description),
                                    trailing:
                                        community.moderators.contains(user.uid)
                                            ? OutlinedButton(
                                                onPressed: () {
                                                  navigateToModerator(context);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  side: const BorderSide(
                                                      color: Colors.white),
                                                ),
                                                child: const Text('Moderator'),
                                              )
                                            : OutlinedButton(
                                                onPressed: () => joinCommunity(
                                                    ref, context, community),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  side: const BorderSide(
                                                      color: Colors.white),
                                                ),
                                                child: Text(community.members
                                                        .contains(user.uid)
                                                    ? 'Joined'
                                                    : 'Join'),
                                              )),
                              ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.post_add),
                              label: const Text('Create Post'),
                            ),
                          ),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.chat),
                              label: const Text('Chat'),
                            ),
                          ),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.menu),
                              label: const Text('Menu'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getAllCommunityPostsProvider(name)).when(
                    data: (posts) => ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    ),
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
            ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
