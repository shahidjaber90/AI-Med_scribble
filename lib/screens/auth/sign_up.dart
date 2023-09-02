import 'dart:io';
import 'dart:typed_data';

import 'package:aimedscribble/Controllers/RegisterController.dart';
import 'package:aimedscribble/screens/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../uitilities/FIrebaseServices.dart';
import '../../uitilities/colors.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/auth_icon_button.dart';
import '../../widgets/text_field_input.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseServices _firebaseServices = FirebaseServices();
  String selectFile = '';
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  _selectImage() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    if (fileResult != null) {
      setState(() {
        selectFile = fileResult.files.first.name;
        webImage = fileResult.files.first.bytes!;
      });
    }
    print('select file:: $selectFile');
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    // You can add more custom validation rules for the name if needed
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone is required';
    }
    // You can add more custom validation rules for the name if needed
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // void _handleRegistration() {
  //   if (_formKey.currentState!.validate()) {
  //     if (_passwordController.text != _confirmPasswordController.text) {
  //       Get.snackbar("Error", "Passwords do not match",
  //           backgroundColor: Colors.red);
  //       return; // Exit function if passwords don't match
  //     }
  //     _firebaseServices.Registration(
  //       _emailController,
  //       _passwordController,
  //       _nameController,
  //       _phoneController,
  //       selectedImage,
  //       context,
  //     );
  //   }
  // }

  final bool _isLoading = false;
  GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add GlobalKey for the Form

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<RegisterController>(
      builder: (context, value, child) => Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: textColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFieldInput(
                          validator: _validateName,
                          iconPath: "assets/email_perso.png",
                          hintText: 'Name',
                          textInputType: TextInputType.text,
                          textEditingController: _nameController,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFieldInput(
                          validator: _validateEmail,
                          iconPath: "assets/email_perso.png",
                          hintText: 'Email',
                          textInputType: TextInputType.text,
                          textEditingController: _emailController,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFieldInput(
                          validator: _validatePhone,
                          iconPath: "assets/phone.png",
                          hintText: 'Phone',
                          textInputType: TextInputType.text,
                          textEditingController: _phoneController,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFieldInput(
                          validator: _validatePassword,
                          iconPath: "assets/lock.png",
                          hintText: 'Password',
                          textInputType: TextInputType.text,
                          textEditingController: _passwordController,
                          isPass: true,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFieldInput(
                          validator:
                              _validateConfirmPassword, // Use the new validation function

                          iconPath: "assets/lock.png",
                          hintText: 'Confirm Password',
                          textInputType: TextInputType.text,
                          textEditingController: _confirmPasswordController,
                          isPass: true,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                            height: 60,
                            width: screenWidth,
                            child: AuthIconButton(
                              backgroundColor: Colors.white,
                              borderColor: text2Color,
                              textColor: text2Color,
                              text: 'Select Image',
                              function: _selectImage,
                              iconPath: "assets/image.png",
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                            height: 60,
                            width: screenWidth,
                            child: AuthButton(
                              backgroundColor: blueColor,
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              text: 'Sign Up',
                              function: () {
                                // RegisterController().uploadImage(webImage);
                                // print('image web:: $webImage');
                                value.createAccount(
                                  _nameController.text,
                                  _emailController.text,
                                  _phoneController.text,
                                  _passwordController.text,
                                  _confirmPasswordController.text,
                                  webImage,
                                  context,
                                );
                                print('image:: $_pickedImage');
                              },
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "or",
                            style: TextStyle(
                              color: text2Color,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "If you have an account ",
                              style: TextStyle(
                                color: text2Color,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ));
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: blueColor,
                                    fontSize: 13,
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        SizedBox(
                            height: 60,
                            width: screenWidth,
                            child: AuthIconButton(
                              backgroundColor: Colors.white,
                              borderColor: text2Color,
                              textColor: text2Color,
                              text: 'Sign up with Google',
                              function: () {},
                              iconPath: "assets/google.png",
                            )),
                        const SizedBox(
                          height: 35,
                        ),
                        SizedBox(
                            height: 60,
                            width: screenWidth,
                            child: AuthIconButton(
                              backgroundColor: Colors.white,
                              borderColor: text2Color,
                              textColor: text2Color,
                              text: 'Sign up with Microsoft',
                              function: () {},
                              iconPath: "assets/lmicrosoft.png",
                            )),
                        const SizedBox(
                          height: 35,
                        ),
                        SizedBox(
                            height: 60,
                            width: screenWidth,
                            child: AuthIconButton(
                              backgroundColor: Colors.white,
                              borderColor: text2Color,
                              textColor: text2Color,
                              text: 'Sign up with Apple',
                              function: () {},
                              iconPath: "assets/apple.png",
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Image.asset(
                "assets/bgImage.png",
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }
}
