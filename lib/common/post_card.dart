import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reddit/common/constants.dart';
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

  void upVotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upVotePost(post);
  }

  void downVotePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downVotePost(post);
  }

  void navigateToUserProfile(BuildContext context) async {
    Routemaster.of(context).push('/profile/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) async {
    Routemaster.of(context).push('/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/posts/${post.id}/comments');
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) {
    ref
        .read(postControllerProvider.notifier)
        .awardsPost(post: post, award: award, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';

    final isTypeText = post.type == 'text';

    final isTypeLink = post.type == 'link';

    final currentTheme = ref.watch(themeNotifierProvider);

    final user = ref.watch(userProvider)!;

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

    isGiftCard() {
      showDialog(
          context: context,
          builder: (dialogContex) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (user.awards.isNotEmpty) const Text('Give Award'),
                    user.awards.isNotEmpty
                        ? const SizedBox(height: 10)
                        : const SizedBox(),
                    if (user.awards.isEmpty)
                      const Text('You have no awards left to give',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          )),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: user.awards.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final award = user.awards[index];

                        return GestureDetector(
                          onTap: () {
                            awardPost(ref, award, context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(Constants.awards[award]!),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    isConfirmGift() {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Give Award'),
              content: const Text('Are you sure you want to give award?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    isGiftCard();
                  },
                  child: const Text('Give Award'),
                ),
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
                                  const PopupMenuItem(
                                    value: 'bookmark',
                                    child: Text('Bookmark'),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    isDelete();
                                  }
                                  if (value == 'report') {
                                    isReport();
                                  }
                                  if (value == 'bookmark') {
                                    Fluttertoast.showToast(
                                      timeInSecForIosWeb: 4,
                                      webBgColor: '#FF0000',
                                      msg: 'Post Bookmarked',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.greenAccent,
                                      textColor: Colors.black,
                                    );
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
                                color: currentTheme.textTheme.bodyLarge!.color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (post.awards.isNotEmpty) ...[
                            const SizedBox(height: 7),
                            SizedBox(
                              height: 30,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (context, index) {
                                  final award = post.awards[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(Constants.awards[award]!,
                                        height: 30, width: 30),
                                  );
                                },
                              ),
                            ),
                          ],
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
                                    onPressed: () => upVotePost(ref),
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
                                    onPressed: () => downVotePost(ref),
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
                                      Icons.send_outlined,
                                      color: currentTheme
                                          .textTheme.bodyLarge!.color,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => navigateToComments(context),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          navigateToComments(context),
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
                              ),
                              ref
                                  .watch(getCommunityByNameProvider(
                                      post.communityName))
                                  .when(
                                    data: (community) {
                                      if (community.moderators
                                          .contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () => isDelete(),
                                          icon: const Icon(Icons
                                              .admin_panel_settings_outlined),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                    error: (error, stackTrace) =>
                                        Text(error.toString()),
                                  ),
                              IconButton(
                                onPressed: () {
                                  isConfirmGift();
                                },
                                icon: const Icon(Icons.card_giftcard),
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
