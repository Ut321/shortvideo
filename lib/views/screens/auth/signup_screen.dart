import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shortvideo/controllers/auth_controllers.dart';

import '../../../constants.dart';
import '../../widgets/text_input_field.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    authController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up Page"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   'Short Video',
              //   style: TextStyle(
              //     fontSize: 35,
              //     color: buttonColor,
              //     fontWeight: FontWeight.w900,
              //   ),
              // ),
              // const Text(
              //   'Register',
              //   style: TextStyle(
              //     fontSize: 25,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              const SizedBox(
                height: 60,
              ),
              // Stack(
              //   children: [
              //     const CircleAvatar(
              //       radius: 64,
              //       backgroundImage: NetworkImage(
              //           'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
              //       backgroundColor: Colors.black,
              //     ),
              //     Positioned(
              //       bottom: -10,
              //       left: 80,
              //       child: IconButton(
              //         onPressed: () => authController.pickImage(),
              //         icon: const Icon(
              //           Icons.add_a_photo,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Stack(
                children: [
                  Obx(() {
                    return InkWell(
                      onTap: () {
                        authController.pickImage();
                      },
                      onLongPress: () {
                        if (authController.profilePhoto != null) {
                          _showDeleteDialog(context);
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black,
                        backgroundImage: authController.profilePhoto != null
                            ? FileImage(authController.profilePhoto!)
                            : NetworkImage(
                                'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-imag  e-png-png.png',
                              ) as ImageProvider,
                      ),
                    );
                  }),
                  Positioned(
                    bottom: -10,
                    left: 63,
                    child: IconButton(
                      onPressed: () => authController.pickImage(),
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _usernameController,
                  icon: Icons.person,
                  lableText: 'Username',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _emailController,
                  icon: Icons.email,
                  lableText: 'Email',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _passwordController,
                  icon: Icons.lock,
                  isObsure: true,
                  lableText: 'Password',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 40,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: InkWell(
                  onTap: () => authController.registerUser(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    authController.profilePhoto,
                  ),
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
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
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: buttonColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Image'),
          content:
              Text('Are you sure you want to delete your profile picture?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                authController.deleteImage();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
