import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shortvideo/views/screens/add_video_screen.dart';
import 'package:shortvideo/views/screens/profile_screen.dart';
import 'package:shortvideo/views/screens/video_screen.dart';
import 'controllers/auth_controllers.dart';

List pages = [
  VideoScreen(),
  const Text('Search Screen'),
  const AddVideoScreen(),
  const Text('Messages Screen'),
  ProfileScreen(uid: authController.user.uid)
];

// COLORS
const backgroundColor = Colors.black;
const buttonColor = Colors.purple;
const borderColor = Colors.grey;
// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
