// login route
import 'package:flutter/material.dart';
import 'package:reddit/features/auth/screens/login.dart';
import 'package:reddit/features/home/home_screen.dart';
import 'package:routemaster/routemaster.dart';

// login route
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: Home()),
},);


// logout route
final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: Login()),
},);