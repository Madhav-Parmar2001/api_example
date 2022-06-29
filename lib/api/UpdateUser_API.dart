import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../UrlHelper.dart';
import 'ViewUser_API.dart';

class UpdateUser_API extends StatefulWidget {

  var updateid = "";
  UpdateUser_API({this.updateid});

  @override
  UpdateUser_APIState createState() => UpdateUser_APIState();
}

class UpdateUser_APIState extends State<UpdateUser_API> {
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

  var user_imagename = "";
  getdata() async
  {
    Uri url = Uri.parse(UrlHelper.SINGLE_USER);
    var response = await http.post(url,body:{"pid":widget.updateid});
    if (response.statusCode == 200) {
      var body = response.body.toString();
      var json = jsonDecode(body);
      setState(() {
        user_name.text = json["pname"].toString();
        user_contact.text = json["pcontact"].toString();
        user_email.text = json["pemail"].toString();
        user_password.text = json["ppassword"].toString();
        user_imagename = json["pimage"].toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api Update User"),
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
                        :Image.network(UrlHelper.BASE_URL +
                        "uploads/" + user_imagename,height: 150,width: 150,fit: BoxFit.cover,),
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
                    var UserName = user_name.text.toString();
                    var UserContact = user_contact.text.toString();
                    var UserEmail =
                    user_email.text.toString();
                    var UserPassword = user_password.text
                        .toString();


                    String Base64Image = "";
                    if(_image==null)
                    {
                      Base64Image = "";
                    }
                    else
                    {
                      List<int> imageBytes = _image.readAsBytesSync();
                      Base64Image = base64Encode(imageBytes);
                    }

                    Uri url = Uri.parse(UrlHelper.UODATE_USER);
                    // var response = await http.get(url);

                    var response = await http.post(url, body: {
                      "User_name" : UserName,
                      "User_contact" : UserContact,
                      "User_email" : UserEmail,
                      "User_password" : UserPassword,
                      "image" : Base64Image,
                      "oldimage" : user_imagename,
                      "pid" : widget.updateid,
                    });

                    user_name.text = "";
                    user_contact.text = "";
                    user_email.text = "";
                    user_password.text = "";

                    // 200 OK,400 NOT FOUND,500 SERVER
                    if(response.statusCode == 200)
                    {
                      var body = response.body.toString();
                      var json = jsonDecode(body);
                      if(json["status"]=="yes")
                        {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ViewUser_API()),
                          );
                        }
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
