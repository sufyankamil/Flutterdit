import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/common/post_card.dart';
import 'package:reddit/features/post/controller/post_controller.dart';

import '../../../models/post_model.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          post: post,
          text: commentController.text.trim(),
        );
    setState(() {
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(postByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostCard(post: data),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onFieldSubmitted: (value) => addComment(data),
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment ...',
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        onPressed: commentController.text.isEmpty
                            ? null
                            : () => addComment(data),
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                  const Divider(),
                  ref.watch(commentsProvider(widget.postId)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final comment = data[index];
                                // const Divider();
                                return CommentCard(
                                  comemnt: comment,
                                );
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const CircularProgressIndicator(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const CircularProgressIndicator(),
          ),
    );
  }
}
