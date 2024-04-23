import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shortvideo/views/screens/auth/signup_screen.dart';
import 'package:shortvideo/views/widgets/text_input_field.dart';

import '../../../constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Short Video App',
              style: TextStyle(
                fontSize: 28,
                color: buttonColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            // const Text(
            //   'Login',
            //   style: TextStyle(
            //     fontSize: 23,
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),
            const SizedBox(
              height: 40,
            ),
            Container(
              // width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextInputField(
                controller: _emailController,
                icon: Icons.email,
                lableText: 'Email',
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              // width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextInputField(
                controller: _passwordController,
                lableText: 'Password',
                icon: Icons.lock,
                isObsure: true,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 65,
              height: 40,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: InkWell(
                onTap: () => authController.loginUser(
                  _emailController.text,
                  _passwordController.text,
                ),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignupScreen(),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: buttonColor),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForgotPasswordScreen(),
                ));
              },
              child: Text(
                'Forget password !',
                style: TextStyle(fontSize: 18, color: buttonColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                signInWithGoogle();
              },
              child: Text(
                'Sign in with Google !',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  attemptResetPassword(email, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter an email address")));
                }
              },
              child: const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}

void attemptResetPassword(String email, BuildContext context) async {
  final usersRef = firestore.collection('users');
  final querySnapshot = await usersRef.where('email', isEqualTo: email).get();

  if (querySnapshot.docs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No registered user found with that email")));
  } else {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reset link sent to your email")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send reset link")));
    }
  }
}

bool _isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

Future<User?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    final User? user = userCredential.user;

    // Check if user is not null and not anonymous
    if (user != null && !user.isAnonymous) {
      assert(await user.getIdToken() !=
          null); // This assertion is effectively redundant because getIdToken should always return a non-null value if user is not null

      final User? currentUser = firebaseAuth.currentUser;
      assert(user.uid ==
          currentUser?.uid); // Use null-aware access for currentUser

      print('signInWithGoogle succeeded: $user');

      return user;
    }
  }

  return null; // Return null if Google sign-in fails or user is anonymous
}
