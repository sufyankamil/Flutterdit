import 'package:flutter/material.dart';

import '../features/feed/screens/feed_screen.dart';
import '../features/post/screens/add_post_screen.dart';

class Constants {
  Constants._privateConstructor();

  static final Constants _instance = Constants._privateConstructor();

  static Constants get instance => _instance;

  // Constants for SplashScreen
  static const String splashScreenImage = 'assets/images/logo.png';
  static const String splashScreenText =
      'Manage your tasks easily with Task Management App';
  static const String splashScreenRoute = '/task-page';
  static const String defaultRoute = '/';

  // Constants for LoginScreen
  static const String loginScreenRoute = '/login';
  static const String loginText = 'Login';
  static const String logoImage = 'assets/images/logo.png';
  static const loginEmote = 'assets/images/loginEmote.png';
  static const String googleImage = 'assets/images/google.png';
  static const String skipText = 'Skip';
  static const String diveInText = 'Dive in to the world of Reddit';
  static const String continueWithGoogle = 'Continue with Google';
  static const String defaultEmail = 'guest@gmail.com';

  // Constants for TaskPage
  static const String homeRoute = '/home';
  static const String taskRoute = '/task-page';
  static const String addTaskText = 'Add Task';
  static const String titleText = 'Title';
  static const String titleHint = 'Enter your title to add task';
  static const String noteText = 'Note';
  static const String noteHint = 'Enter your note';
  static const String dateText = 'Date';
  static const String startTimeText = 'Start Time';
  static const String endTimeText = 'End Time';
  static const String pickDateText = 'Pick Date';
  static const String pickTimeText = 'Pick Time';
  static const String pickEndTimeText = 'Pick End Time';
  static const String remind = 'Remind';
  static const String repeatText = 'Repeat';
  static const String colorText = 'Color';
  static const String createText = 'Create Task';
  static const String required = 'Required Field';
  static const String fieldsRequired = 'All fields are required';
  static const String taskCompleted = 'Task Completed';
  static const String taskDeleted = 'Delete Task';
  static const String cancel = 'Cancel';
  static const String taskDeletedMessage = 'Task deleted successfully';

  // Constants for HomePage
  static const noTask = 'No Task Found';
  static const String today = 'Today';
  static const String addTask = '+ Add Task';
  static const String appName = 'Task Management';

  // Constants for Edit Page
  static const edit = 'Edit Task';
  static const update = 'Update Task';

  // Repositories constants
  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  // firebase constants
  static const usersCollection = 'users';
  static const communitiesCollection = 'communities';
  static const postsCollection = 'posts';
  static const commentsCollection = 'comments';
  static const tabWidgets = [
    FeedScreen(),
    AddPost(),
  ];

  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}

  // Copyright (c) Sufyan Kamil. All rights reserved.
