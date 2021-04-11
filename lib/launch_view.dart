import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class LaunchView extends StatefulWidget {
  LaunchView({Key key}) : super(key: key);

  @override
  _LaunchViewState createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> {

  final picker = ImagePicker();
  File _imageFile;

 @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }
  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImage(BuildContext context) async {
    String fileName = _imageFile.path;
    firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('$fileName');
    firebase_storage.UploadTask uploadTask =
        firebaseStorageRef.putFile(_imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Completed: $value"),
        );
  }
  Future deleteImage(BuildContext context) async {
    String fileName = _imageFile.path;
  firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('$fileName');
      await  firebaseStorageRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          photoAddContainer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              uploadImageButton(context),
              deleteImageButton(context),
            ],
          ),
        ],
      ),
    );
  }

  TextButton deleteImageButton(BuildContext context) {
    return TextButton(
                onPressed: () => deleteImage(context),
                child: Text(
                  "Delete Photo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ));
  }

  TextButton uploadImageButton(BuildContext context) {
    return TextButton(
            onPressed: () => uploadImage(context),
            child: Text(
              "Upload Photo",
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
            ),
          );
  }

  Container photoAddContainer() {
    return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 500,
            width: 500,
            child: _imageFile != null
                ? Image.file(_imageFile)
                : TextButton(onPressed: pickImage, child: Text("Photo Add",style: TextStyle(fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),)));
  }


}
