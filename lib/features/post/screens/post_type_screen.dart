import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/responsive/responsive.dart';

import '../../../common/utils.dart';
import '../../../models/community_model.dart';
import '../../../theme/pallete.dart';
import '../../community/controller/community_controller.dart';

class AddPostType extends ConsumerStatefulWidget {
  final String type;

  const AddPostType({super.key, required this.type});

  @override
  ConsumerState createState() => _AddPostTypeState();
}

class _AddPostTypeState extends ConsumerState<AddPostType> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final linkController = TextEditingController();

  File? bannerImage;

  File? profileImage;

  List<Community> communities = [];

  Community? selectedCommunity;

  Uint8List? bannerWebFile;

  void selectBannerImage() async {
    final result = await pickImage();
    if (result != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = result.files.first.bytes;
        });
      }
      setState(() {
        bannerImage = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerImage != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            title: titleController.text.trim(),
            context: context,
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerImage!,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            title: titleController.text.trim(),
            context: context,
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        linkController.text.isNotEmpty &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            title: titleController.text.trim(),
            context: context,
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';

    final isTypeText = widget.type == 'text';

    final isTypeLink = widget.type == 'link';

    final currentTheme = ref.watch(themeNotifierProvider);

    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text('Add ${widget.type} post'),
          actions: [
            IconButton(
              onPressed: () => sharePost(),
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Responsive(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        maxLength: 30,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: 'Title',
                          hintText: 'Enter the title of your post',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isTypeImage)
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: DottedBorder(
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            dashPattern: const [8, 4],
                            strokeCap: StrokeCap.round,
                            color: currentTheme.textTheme.bodyLarge!.color!
                                .withOpacity(0.5),
                            strokeWidth: 1,
                            child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: bannerWebFile != null
                                    ? Image.memory(bannerWebFile!)
                                    : bannerImage != null
                                        ? Image.file(
                                            bannerImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.add_a_photo,
                                              color: currentTheme
                                                  .textTheme.bodyLarge!.color,
                                              size: 40,
                                            ),
                                          )),
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (isTypeText)
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Description',
                            hintText: 'Enter the description of your post',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      if (isTypeLink)
                        TextFormField(
                          controller: linkController,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Link',
                            hintText: 'Enter the link of your post',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select the community to post in',
                          style: TextStyle(
                            color: currentTheme.textTheme.bodyLarge!.color!
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ref.watch(userCommunitiesProvider).when(
                            data: (data) {
                              communities = data;
                              if (data.isEmpty) {
                                return const Center(
                                  child:
                                      Text('You are not part of any community'),
                                );
                              }

                              return DropdownButtonFormField(
                                style: TextStyle(
                                  color:
                                      currentTheme.textTheme.bodyLarge!.color,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor:
                                      currentTheme.scaffoldBackgroundColor,
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                disabledHint: const Text(
                                    'You are not part of any community'),
                                dropdownColor:
                                    currentTheme.scaffoldBackgroundColor,
                                hint: const Text('Select a community'),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a community';
                                  }
                                  return null;
                                },
                                padding: const EdgeInsets.all(12),
                                value: selectedCommunity ?? data[0],
                                items: data
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.name),
                                        ))
                                    .toList(),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                },
                                onChanged: (value) {
                                  setState(() {
                                    selectedCommunity = value as Community;
                                  });
                                },
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stackTrace) => Center(
                              child: Text(error.toString()),
                            ),
                          ),
                    ],
                  ),
                ),
              ));
  }
}
