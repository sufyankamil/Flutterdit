import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/models/post_model.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../features/auth/controller/auth_controller.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  void deletePost(WidgetRef ref, BuildContext context) {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upVotePost(post);
  }

  void downvotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downVotePost(post);
  }

  void navigateToUserProfile(BuildContext context) async {
    Routemaster.of(context).push('/profile/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) async {
    Routemaster.of(context).push('/${post.communityName}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';

    final isTypeText = post.type == 'text';

    final isTypeLink = post.type == 'link';

    final currentTheme = ref.watch(themeNotifierProvider);

    final user = ref.watch(userProvider)!;

    bool enableComment = false;

    isDelete() {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Delete Post'),
              content: const Text('Are you sure you want to delete this post?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    deletePost(ref, context);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          });
    }

    isReport() {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Report Post'),
              content: const Text('Are you sure you want to report this post?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                Builder(builder: (context) {
                  return TextButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        timeInSecForIosWeb: 4,
                        webBgColor: '#FF0000',
                        msg: 'Post Reported',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Report'),
                  );
                }),
              ],
            );
          });
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4)
                          .copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                          NetworkImage(post.communityProfile),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.communityName,
                                          style: TextStyle(
                                            color: currentTheme
                                                .textTheme.bodyLarge!.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              navigateToUserProfile(context),
                                          child: Text(
                                            post.username,
                                            style: TextStyle(
                                              color: currentTheme
                                                  .textTheme.bodyLarge!.color,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                color: currentTheme.drawerTheme.backgroundColor,
                                icon: Icon(
                                  Icons.more_vert,
                                  color:
                                      currentTheme.textTheme.bodyLarge!.color,
                                ),
                                itemBuilder: (context) => [
                                  if (post.uid == user.uid)
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  const PopupMenuItem(
                                    value: 'report',
                                    child: Text('Report'),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    isDelete();
                                  }
                                  if (value == 'report') {
                                    isReport();
                                  }
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              post.title,
                              style: TextStyle(
                                color: currentTheme.textTheme.bodyText1!.color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              // height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: AnyLinkPreview(
                                link: post.link ?? 'No Link Found',
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                showMultimedia: true,
                                bodyMaxLines: 3,
                                bodyTextOverflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => upvotePost(ref),
                                    icon: Icon(
                                      Icons.arrow_upward,
                                      color: post.upVotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : currentTheme
                                              .textTheme.bodyLarge!.color,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                                    style: TextStyle(
                                      color: currentTheme
                                          .textTheme.bodyLarge!.color,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => downvotePost(ref),
                                    icon: Icon(
                                      Icons.arrow_downward,
                                      color: post.downVotes.contains(user.uid)
                                          ? Pallete.blueColor
                                          : currentTheme
                                              .textTheme.bodyLarge!.color,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.share,
                                      color: currentTheme
                                          .textTheme.bodyLarge!.color,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      enableComment = true;
                                    },
                                    icon: const Icon(Icons.comment),
                                  ),
                                  Text(
                                    post.commentCount.toString() == '0'
                                        ? 'Comment'
                                        : post.commentCount.toString(),
                                    style: TextStyle(
                                      color: currentTheme
                                          .textTheme.bodyLarge!.color,
                                    ),
                                  ),
                                ],
                              ),
                              ref
                                  .watch(getCommunityByNameProvider(
                                      post.communityName))
                                  .when(
                                    data: (community) {
                                      if (community.moderators
                                          .contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () =>
                                              deletePost(ref, context),
                                          icon: const Icon(Icons
                                              .admin_panel_settings_outlined),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                    error: (error, stackTrace) =>
                                        const Text('Error'),
                                  ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
