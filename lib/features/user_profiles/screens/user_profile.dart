import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reddit/common/post_card.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';
import '../../post/controller/post_controller.dart';
import '../controller/user_profile_controller.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;

  const UserProfileScreen({Key? key, required this.uid}) : super(key: key);

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    // print(isEmailVerified);
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    expandedHeight: 250,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            user.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(
                              left: 30, bottom: 6, top: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: NetworkImage(user.photoUrl),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(left: 24, bottom: 36),
                          child: OutlinedButton(
                            onPressed: () => navigateToEditUser(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              isEmailVerified
                                  ? IconButton(
                                      icon: const FaIcon(
                                        FontAwesomeIcons.check,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {},
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '${user.karma}' ' Karma',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            thickness: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getAllUserPostsProvider(uid)).when(
                    data: (posts) => ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, int index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    ),
                    error: (error, stackTrace) {
                      return Text(error.toString());
                    },
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
