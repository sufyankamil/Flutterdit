import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/models/comment_model.dart';

class CommentCard extends ConsumerWidget {
  final Comments comemnt;

  const CommentCard({Key? key, required this.comemnt}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(comemnt.profilePic),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comemnt.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comemnt.text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.reply),
            ),
            Text(
              'Reply',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        )
      ]),
    );
  }
}
