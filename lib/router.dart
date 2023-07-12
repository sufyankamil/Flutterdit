// login route
import 'package:flutter/material.dart';
import 'package:reddit/common/splash.dart';
import 'package:reddit/features/auth/screens/login.dart';
import 'package:reddit/features/community/screens/add_mod_screen.dart';
import 'package:reddit/features/community/screens/community_screens.dart';
import 'package:reddit/features/community/screens/create_community.dart';
import 'package:reddit/features/community/screens/edit_community_screen.dart';
import 'package:reddit/features/home/home_screen.dart';
import 'package:reddit/features/post/screens/comments_screen.dart';
import 'package:reddit/features/post/screens/post_type_screen.dart';
import 'package:reddit/features/user_profiles/screens/edit_profile.dart';
import 'package:reddit/features/user_profiles/screens/user_profile.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/mod_tools_screen.dart';
import 'features/post/screens/add_post_screen.dart';
import 'features/premium/premium_subs.dart';

// login route
final loggedInRoute = RouteMap(
  routes: {
    '/': (route) => const MaterialPage(
        child: Home()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/:name': (route) => MaterialPage(
            child: CommunityScreen(
          name: route.pathParameters['name']!,
        )),
    '/mod-tools/:name': (routeData) => MaterialPage(
            child: ModToolsScreen(
          name: routeData.pathParameters['name']!,
        )),
    '/edit-community/:name': (routeData) => MaterialPage(
            child: EditCommunity(
          name: routeData.pathParameters['name']!,
        )),
    '/add-mods/:name': (routeData) => MaterialPage(
            child: AddModsScreen(
          name: routeData.pathParameters['name']!,
        )),
    '/profile/:uid': (routeData) => MaterialPage(
            child: UserProfileScreen(
          uid: routeData.pathParameters['uid']!,
          // paymentIntent: routeData.pathParameters['id']!,
        )),
    '/edit-profile/:uid': (routeData) => MaterialPage(
            child: EditProfile(
          uid: routeData.pathParameters['uid']!,
        )),
    '/add-post/:type': (routeData) => MaterialPage(
            child: AddPostType(
          type: routeData.pathParameters['type']!,
        )),
    '/posts/:postId/comments': (routeData) => MaterialPage(
            child: CommentScreen(
          postId: routeData.pathParameters['postId']!,
        )),
    '/add-post': (routeData) => const MaterialPage(child: AddPost()),
    '/subscribe': (routeData) => MaterialPage(child: RedditPremiumPage()),
  },
);

// logout route
final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: Login()),
  },
);

final initScreen = RouteMap(routes: {
  '/initScreen': (_) => const MaterialPage(child: SplashScreen()),
});

final splashRoute = RouteMap(
  routes: {
    '/add-post': (_) => const MaterialPage(child: SplashScreen()),
  },
);
