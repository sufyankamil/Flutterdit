import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/common/constants.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

import '../../../theme/pallete.dart';

class EditCommunity extends ConsumerStatefulWidget {
  final String name;

  const EditCommunity({Key? key, required this.name}) : super(key: key);

  @override
  ConsumerState createState() => _EditCommunityState();
}

class _EditCommunityState extends ConsumerState<EditCommunity> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Community'),
              centerTitle: false,
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    // save community
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        DottedBorder(
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          dashPattern: const [8, 4],
                          strokeCap: StrokeCap.round,
                          color: Pallete.darkModeAppTheme.textTheme.bodyLarge!.color!,
                          strokeWidth: 1,
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: community.banner.isEmpty || community.banner == Constants.bannerDefault
                                ? const Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                : Image.network(
                                    community.banner,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 25,

                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) =>  Center(
            child: Text(error.toString()),
          ),
        );

  }
}
