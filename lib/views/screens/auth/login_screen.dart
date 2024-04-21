import 'package:flutter/material.dart';
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
          ],
        ),
      ),
    );
  }
}
