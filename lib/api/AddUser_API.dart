import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../UrlHelper.dart';

class AddUser_API extends StatefulWidget {
  @override
  AddUser_APIState createState() => AddUser_APIState();
}

class AddUser_APIState extends State<AddUser_API> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController user_name = TextEditingController();
  TextEditingController user_contact = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_password = TextEditingController();

  PickedFile _imageFile = null;
  File _image = null;

  _getCamera()async{
    final _pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _imageFile = _pickedFile;
      _image = File(_imageFile.path);
    });
  }

  _gatGallery()async{
    final _pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = _pickedFile;
      _image = File(_imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api Add User"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),

                TextFormField(
                    controller: user_name,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                      hintText: "Enter Name",
                    )),
                SizedBox(
                  height: 15,
                ),

                TextFormField(
                    controller: user_contact,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Contact",
                      hintText: "Enter Contact",
                    )),
                SizedBox(
                  height: 15,
                ),

                TextFormField(
                    controller: user_email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "email",
                      hintText: "Enter email",
                    )),
                SizedBox(
                  height: 15,
                ),

                TextFormField(
                    controller: user_password,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Enter Password",
                    )),

                SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(400),
                    child: (_image!=null)
                        ?Image.file(_image,height: 150,width: 150,fit: BoxFit.cover,)
                        :Image.asset("Assets/Images/Upload_Your_Photo.jpg",height: 150,width: 150,fit: BoxFit.cover,),
                  ),
                ),

                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        child: Text("Camera"),
                        onPressed: (){
                          _getCamera();
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        child: Text("Gallery"),
                        onPressed: (){
                          _gatGallery();
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  onPressed: () async {
                    var User_name = user_name.text.toString();
                    var User_contact = user_contact.text.toString();
                    var User_email =
                        user_email.text.toString();
                    var User_password = user_password.text
                        .toString();

                    List<int> imageBytes = _image.readAsBytesSync();
                    String Base64Image = base64Encode(imageBytes);

                    Uri url = Uri.parse(UrlHelper.ADD_USER);
                    // var response = await http.get(url);

                    var response = await http.post(url, body: {
                      "User_name" : User_name,
                      "User_contact" : User_contact,
                      "User_email" : User_email,
                      "User_password" : User_password,
                      "image" :Base64Image,
                    });

                    user_name.text = "";
                    user_contact.text = "";
                    user_email.text = "";
                    user_password.text = "";

                    // 200 OK,400 NOT FOUND,500 SERVER
                    if(response.statusCode == 200)
                    {
                      var body = response.body.toString();
                      print("API Response : "+body);
                    }
                    else
                    {
                      print("Error API");
                    }

                  },
                  color: Colors.blue,
                  child: Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
