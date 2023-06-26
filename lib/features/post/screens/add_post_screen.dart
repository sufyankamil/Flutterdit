import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/pallete.dart';

class AddPost extends ConsumerWidget {
  const AddPost({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
    // Navigator.of(context).pushNamed('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = 120;

    double iconSize = 50;

    final currentTheme = ref.watch(themeNotifierProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => navigateToType(context, 'image'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: currentTheme.backgroundColor,
              elevation: 17,
              child: Center(
                child: Icon(
                  Icons.image,
                  size: iconSize,
                ),

              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToType(context, 'text'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: currentTheme.backgroundColor,
              elevation: 17,
              child: Center(
                child: Icon(
                  Icons.text_fields,
                  size: iconSize,
                ),

              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToType(context, 'link'),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: currentTheme.backgroundColor,
              elevation: 17,
              child: Center(
                child: Icon(
                  Icons.link,
                  size: iconSize,
                ),


              ),
            ),
          ),
        ),
      ],
    );
  }
}