import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({Key? key, required this.name}) : super(key: key);

  void navigateToModerator(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
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
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                              title: community.members.length > 1
                                  ? Text(
                                      '${community.name} - ${community.members.length} members')
                                  : Text(
                                      '${community.name} - ${community.members.length} member'),
                              subtitle: Text(community.description),
                              trailing: community.moderators.contains(user.uid)
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
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      child: Text(
                                          community.members.contains(user.uid)
                                              ? 'Joined'
                                              : 'Join'),
                                    ),
                            ),
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
                body: Column(
                  children: [
                    Text(community.name),
                    Text(community.description),
                  ],
                )),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
    // return SafeArea(
    //   child: Scaffold(
    //     body: ref.watch(getCommunityByNameProvider(name)).when(
    //           data: (community) {
    //             NestedScrollView(
    //               headerSliverBuilder: (context, innerBoxIsScrolled) {
    //                 return [
    //                   SliverAppBar(
    //                     title: Text(community.name),
    //                     pinned: true,
    //                     floating: true,
    //                     snap: true,
    //                     expandedHeight: 200,
    //                     flexibleSpace: Stack(
    //                       children: [
    //                         Positioned.fill(
    //                           child: Image.network(
    //                             community.banner,
    //                             fit: BoxFit.cover,
    //                           ),
    //                         ),
    //                         Positioned(
    //                           bottom: 0,
    //                           left: 0,
    //                           right: 0,
    //                           child: Row(
    //                             children: [
    //                               const SizedBox(width: 16),
    //                               CircleAvatar(
    //                                 radius: 30,
    //                                 backgroundImage:
    //                                     NetworkImage(community.avatar),
    //                               ),
    //                               const SizedBox(width: 16),
    //                               Column(
    //                                 crossAxisAlignment: CrossAxisAlignment.start,
    //                                 children: [
    //                                   Text(
    //                                     community.name,
    //                                     style: Theme.of(context)
    //                                         .textTheme
    //                                         .titleLarge!
    //                                         .copyWith(color: Colors.white),
    //                                   ),
    //                                   Text(
    //                                     community.description,
    //                                     style: Theme.of(context)
    //                                         .textTheme
    //                                         .bodyMedium!
    //                                         .copyWith(color: Colors.white),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ];
    //               },
    //               body: const Text("community.description"),
    //             );
    //             return null;
    //           },
    //           loading: () => const Center(child: CircularProgressIndicator()),
    //           error: (error, stackTrace) => Text(error.toString()),
    //         ),
    //   ),
    // );
  }
}
