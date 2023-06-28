import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/models/post_model.dart';
import 'package:reddit/theme/pallete.dart';

import '../features/auth/controller/auth_controller.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';

    final isTypeText = post.type == 'text';

    final isTypeLink = post.type == 'link';

    final currentTheme = ref.watch(themeNotifierProvider);

    final user = ref.watch(userProvider)!;

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
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        NetworkImage(post.communityProfile),
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
                                                .textTheme.bodyText1!.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          post.username,
                                          style: TextStyle(
                                            color: currentTheme
                                                .textTheme.bodyText1!.color,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: AnyLinkPreview(
                                link: post.link ?? 'No link found',
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
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_upward,
                                      color: post.upVotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : currentTheme
                                              .textTheme.bodyText1!.color,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                                    style: TextStyle(
                                      color: currentTheme
                                          .textTheme.bodyText1!.color,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_downward,
                                      color: post.downVotes.contains(user.uid)
                                          ? Pallete.blueColor
                                          : currentTheme
                                              .textTheme.bodyText1!.color,
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(
                                  //     Icons.comment,
                                  //     color: currentTheme
                                  //         .textTheme.bodyText1!.color,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   post.commentCount.toString(),
                                  //   style: TextStyle(
                                  //     color: currentTheme
                                  //         .textTheme.bodyText1!.color,
                                  //   ),
                                  // ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.share,
                                      color: currentTheme
                                          .textTheme.bodyText1!.color,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.comment),
                                  ),
                                  Text(
                                    post.commentCount.toString() == '0'
                                        ? 'Comment'
                                        : post.commentCount.toString(),
                                    style: TextStyle(
                                      color: currentTheme
                                          .textTheme.bodyText1!.color,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
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
