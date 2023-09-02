import 'dart:io';
import 'dart:typed_data';

import 'package:aimedscribble/Models/UserModel.dart';
import 'package:aimedscribble/screens/auth/login.dart';
import 'package:aimedscribble/screens/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegisterController with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
  // final Reference referenceRoot = FirebaseStorage.instance.ref();
  // final Reference referenceDirImages = referenceRoot.child('images')
  String uniquName = DateTime.now().millisecondsSinceEpoch.toString();
  String? imageUrl;

  uploadImage(
    String username,
    String email,
    String phone,
    String password,
    String confirmPassword,
    Uint8List file,
    context,
  ) async {
    try {
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('/' + '$uniquName');
      final metaData =
          firebase_storage.SettableMetadata(contentType: 'images/jpg');
      uploadTask = ref.putData(file, metaData);
      await uploadTask.whenComplete(() => null);
      String imagePath = await ref.getDownloadURL();
      imageUrl = imagePath;
      notifyListeners();
      postDetailsToFirestore(
        username,
        email,
        phone,
        password,
        confirmPassword,
        imagePath,
        context,
      );
      print('upload image : ${imagePath}');
    } catch (e) {
      print('Error:: ${e.toString()}');
    }
  }

  void createAccount(
    String username,
    String email,
    String phone,
    String password,
    String confirmPassword,
    Uint8List file,
    context,
  ) async {
    EasyLoading.show(status: 'Please wait...');
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
          (value) => {
            uploadImage(
              username,
              email,
              phone,
              password,
              confirmPassword,
              file,
              context,
            ),
            EasyLoading.showSuccess('Registration successful!...'),
          },
        )
        .catchError((e) {
      print('Error:: ${e.toString()}');
    });
  }

  postDetailsToFirestore(
    String username,
    String email,
    String phone,
    String password,
    String confirmPassword,
    String imageUrl,
    context,
  ) async {
    var user = auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'confirm-password': confirmPassword,
      'image-path': imageUrl,
      'uid': user.uid,
    });

    print('---------------------START-------------------------');
    print('upload image names: ${imageUrl}');
    print(username);
    print(email);
    print(phone);
    print(password);
    print(confirmPassword);
    print(imageUrl);
    print(user.uid);
    print('----------------------END------------------------');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  //// login function
  ///
  void route(context) {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print('snapshot:: $documentSnapshot');
      print('snapshot exist:: ${documentSnapshot.exists}');
      if (documentSnapshot.exists) {
        print(' in if snapshot exist:: ${documentSnapshot.exists}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(context, email, password) async {
    try {
      // EasyLoading.show(status: 'Please wait...');
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('provider ID:: ${userCredential.additionalUserInfo!.providerId}');
      route(context);
      EasyLoading.showSuccess("Successful sign-in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No user found for that email.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red.shade400,
            action: SnackBarAction(
              label: 'dismiss',
              onPressed: () {},
            ),
          ),
        );
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Wrong password provided for that user.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'dismiss',
              onPressed: () {},
            ),
          ),
        );
        print('Wrong password provided for that user.');
      }
    }
  }
}
