import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    // final isCreateButtonEnabled = communityNameController.text.isNotEmpty;

    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Community')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Community name')),
                    const SizedBox(
                      height: 12.0,
                    ),
                    TextFormField(
                      controller: communityNameController,
                      decoration: const InputDecoration(
                        labelText: 'Community Name',
                        hintText: 'Flutter',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      maxLength: 21,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a community name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    // isCreateButtonEnabled
                    //     ? const Text(
                    //         'Community names including capitalization cannot be changed.',
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 14,
                    //         ),
                    //       )
                    //     : const SizedBox.shrink(),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {});
                            createCommunity();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: const Text('Create Community',
                            style: TextStyle(fontSize: 16)))
                  ],
                ),
              ),
            ),
    );
  }
}
