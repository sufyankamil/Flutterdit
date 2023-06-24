import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/controller/auth_controller.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reddit Home'),
      ),
      body: Center(
        child: Text('Welcome ${user?.name ?? 'to Reddit Clone'}'),
      ),
    );
  }
}
