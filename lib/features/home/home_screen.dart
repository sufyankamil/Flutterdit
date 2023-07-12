import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/common/constants.dart';
import 'package:reddit/features/home/delegates/search_community_delegate.dart';
import 'package:reddit/features/home/drawers/community_list_drawer.dart';
import 'package:reddit/features/home/drawers/profile_drawer.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../auth/controller/auth_controller.dart';

class Home extends ConsumerStatefulWidget {
  // final Object paymentIntent;
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void pushToHome() {
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    final currentTheme = ref.watch(themeNotifierProvider);

    // print(widget.paymentIntent);

    final isGuest = !user!.isAuthenticated;
    return MaterialApp(
      theme: currentTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text('Home'),
            centerTitle: false,
            leading: Builder(builder: (context) {
              return IconButton(
                onPressed: () => displayDrawer(context),
                icon: const Icon(Icons.menu),
              );
            }),
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: SearchCommunityDelegate(ref));
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () => pushToHome(),
                icon: const Icon(Icons.add),
              ),
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () => displayEndDrawer(context),
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                );
              }),
            ],
          ),
          drawer: const CommunityListDrawer(),
          endDrawer: isGuest ? null : const ProfileDrawer(),
          body: Constants.tabWidgets[_page],
          bottomNavigationBar: isGuest || kIsWeb
              ? const SizedBox.shrink()
              : Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: CupertinoTabBar(
                    activeColor: currentTheme.iconTheme.color,
                    // backgroundColor: currentTheme.backgroundColor,
                    backgroundColor: const Color(0x00ffffff),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add),
                        label: 'Add Post',
                      ),
                    ],
                    onTap: onPageChanged,
                    currentIndex: _page,
                  ),
                )),
    );
  }
}
