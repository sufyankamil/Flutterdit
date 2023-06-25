import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/common/constants.dart';
import 'package:reddit/common/utils.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

import '../../../models/community_model.dart';
import '../../../theme/pallete.dart';

class EditCommunity extends ConsumerStatefulWidget {
  final String name;

  const EditCommunity({Key? key, required this.name}) : super(key: key);

  @override
  ConsumerState createState() => _EditCommunityState();
}

class _EditCommunityState extends ConsumerState<EditCommunity> {
  File? bannerImage;
  File? profileImage;

  void selectBannerImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        bannerImage = File(result.files.single.path!);
      });
    }
  }

  void selectProfileImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        profileImage = File(result.files.single.path!);
      });
    }
  }

  bool showText = false;

  @override
  void initState() {
    super.initState();
    // Set showText to true after a delay of 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showText = true;
      });
    });
  }

  // Function to save the the edited community
  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileImage,
          bannerFile: bannerImage,
          community: community,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: Pallete.darkModeAppTheme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text('Edit Community'),
              centerTitle: false,
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () => save(community),
                ),
              ],
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        bannerImage != null
                            ? Visibility(
                                visible: showText,
                                child: const Text(
                                  'Click on the image to change',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.left,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  dashPattern: const [8, 4],
                                  strokeCap: StrokeCap.round,
                                  color: Pallete.darkModeAppTheme.textTheme
                                      .bodyLarge!.color!,
                                  strokeWidth: 1,
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerImage != null
                                        ? Image.file(
                                            bannerImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : community.banner.isEmpty ||
                                                community.banner ==
                                                    Constants.bannerDefault
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
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileImage != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              FileImage(profileImage!),
                                          radius: 25,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(community.avatar),
                                          radius: 25,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text(error.toString()),
          ),
        );
  }
}
