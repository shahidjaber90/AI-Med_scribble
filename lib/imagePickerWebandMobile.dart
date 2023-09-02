import 'dart:io';
import 'package:aimedscribble/Controllers/RegisterController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadProductForm extends StatefulWidget {
  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  _selectImage() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    if (fileResult != null) {
      setState(() {
        webImage = fileResult.files.first.bytes!;
      });
    }
    print('select file:: $webImage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return LayoutBuilder(
              builder: (context, constraints) => constraints.maxWidth > 600
                  ? Container(
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return cartItemWidget(context, snapshot);
                        },
                      ),
                    )
                  : Container(
                      child: snapshot.data.docs.length > 0
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      mainAxisExtent: 0.02,
                                      crossAxisSpacing: 0.02),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return cartItemWidget(
                                    context, snapshot.data.docs[index]);
                              },
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: Text('no item found'),
                            )));
        
      }
  }
    ),
        //     Column(
        //   children: [
        //     // SizedBox(
        //     //     height: 300,
        //     //     child: Image(
        //     //       image: NetworkImage(
        //     //         'https://firebasestorage.googleapis.com/v0/b/ai-med-scribble-c6e43.appspot.com/o/images%2F1693611061811?alt=media&token=616ef0a6-33ba-405d-8b56-313f530fbfb2',
        //     //       ),
        //     //       fit: BoxFit.cover,
        //     //     )),
        //     // Card(
        //     //   child: SizedBox(
        //     //       height: 300,
        //     //       child: Image(
        //     //         image: NetworkImage(
        //     //           'https://firebasestorage.googleapis.com/v0/b/ai-med-scribble-c6e43.appspot.com/o/images%2F1693611061811?alt=media&token=616ef0a6-33ba-405d-8b56-313f530fbfb2',
        //     //         ),
        //     //         fit: BoxFit.cover,
        //     //       )),
        //     // ),
        //     // GestureDetector(
        //     //   onTap: () {
        //     //     // _pickImage();
        //     //     _selectImage();
        //     //   },
        //     //   child: Container(
        //     //       height: 150,
        //     //       width: 150,
        //     //       decoration: const BoxDecoration(
        //     //         shape: BoxShape.circle,
        //     //       ),
        //     //       child: _pickedImage == null
        //     //           ? Container(
        //     //               height: 150,
        //     //               width: 150,
        //     //               decoration: const BoxDecoration(
        //     //                 shape: BoxShape.circle,
        //     //               ),
        //     //               child: Image.asset(
        //     //                 'assets/image.png',
        //     //                 fit: BoxFit.cover,
        //     //               ),
        //     //             )
        //     //           : ClipRRect(
        //     //               borderRadius: BorderRadius.circular(150),
        //     //               child: kIsWeb
        //     //                   ? Image.memory(webImage, fit: BoxFit.fill)
        //     //                   : Image.file(_pickedImage!, fit: BoxFit.fill),
        //     //             )),
        //     // )
        //   ],
        // ),
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

//
Card cartItemWidget(
  BuildContext context,
  var snapshot,
) {
  return Card(
    child: Center(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(snapshot['itemImageUrl'][0]))),
          ),
          Container(
            child: Text('${snapshot['itemName']}'),
          )
        ],
      ),
    ),
  );
}
