import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profiles/controller/user_profile_controller.dart';

import '../../../common/constants.dart';
import '../../../common/utils.dart';
import '../../../theme/pallete.dart';

class EditProfile extends ConsumerStatefulWidget {
  final String uid;

  const EditProfile({Key? key, required this.uid}) : super(key: key);

  @override
  ConsumerState createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  File? bannerImage;
  File? profileImage;
  late TextEditingController _nameController;

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
    _nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Function to save the the edited profile
  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          profileFile: profileImage,
          bannerFile: bannerImage,
          name: _nameController.text.trim(),
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor: currentTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Profile'),
              centerTitle: false,
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () => save(),
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
                                  color: currentTheme
                                      .textTheme.bodyLarge!.color!
                                      .withOpacity(0.5),
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
                                        : user.banner.isEmpty ||
                                                user.banner ==
                                                    Constants.bannerDefault
                                            ?  Center(
                                                child: Icon(
                                                  Icons.add_a_photo,
                                                  color: currentTheme
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                  size: 40,
                                                ),
                                              )
                                            : Image.network(
                                                user.banner,
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
                                              NetworkImage(user.photoUrl),
                                          radius: 25,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Name',
                            hintText: 'Enter the name of the community',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(17),
                          ),
                          // onChanged: (value) {
                          //   user = user.copyWith(name: value);
                          // },
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
