// login route
import 'package:flutter/material.dart';
import 'package:reddit/features/auth/screens/login.dart';
import 'package:reddit/features/community/screens/community_screens.dart';
import 'package:reddit/features/community/screens/create_community.dart';
import 'package:reddit/features/community/screens/edit_community_screen.dart';
import 'package:reddit/features/home/home_screen.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/mod_tools_screen.dart';

// login route
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: Home()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
  '/:name': (route) => MaterialPage(child: CommunityScreen(
    name: route.pathParameters['name']!,
  )),
  '/mod-tools/:name': (routeData) => MaterialPage(child: ModToolsScreen(
    name: routeData.pathParameters['name']!,
  )),
  '/edit-community/:name': (routeData) => MaterialPage(child: EditCommunity(
    name: routeData.pathParameters['name']!,
  )),
},);


// logout route
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: Login()),
},);