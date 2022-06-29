
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../UrlHelper.dart';

class AddProduct_API extends StatefulWidget
{
  @override
  AddProduct_APIState createState() => AddProduct_APIState();
}

class AddProduct_APIState extends State<AddProduct_API>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController product_name = TextEditingController();
  TextEditingController product_descrption = TextEditingController();
  TextEditingController product_rprice = TextEditingController();
  TextEditingController product_sprice = TextEditingController();

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
      appBar: AppBar(title: Text("API Add Product"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 5,),
                TextFormField(
                    controller: product_name,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                      hintText: "Enter Name",
                    )
                ),
                SizedBox(height: 15,),
                TextFormField(
                    controller: product_descrption,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                      hintText: "Enter Description",
                    )
                ),
                SizedBox(height: 15,),
                TextFormField(
                    controller: product_rprice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Retail Price",
                      hintText: "Enter Retail Price",
                    )
                ),
                SizedBox(height: 15,),
                TextFormField(
                    controller: product_sprice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Selling Price",
                      hintText: "Enter Selling Price",
                    )
                ),

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

                SizedBox(height: 15,),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Submit"),
                  onPressed: () async{
                    var name = product_name.text.toString();
                    var description = product_descrption.text.toString();
                    var rprice = product_rprice.text.toString(); // Retail Price (Mrp)
                    var sprice = product_sprice.text.toString(); // Selling Price (Discount Price)

                    List<int> imageBytes = _image.readAsBytesSync();
                    String base64Image = base64Encode(imageBytes);

                    Uri url = Uri.parse(UrlHelper.ADD_PRODUCT);
                    var response = await http.post(url,body: {
                      "name":name,
                      "description":description,
                      "rprice":rprice,
                      "sprice":sprice,
                      "image":base64Image
                    });

                    product_name.text = "";
                    product_descrption.text = "";
                    product_rprice.text = "";
                    product_sprice.text = "";


                    // 200 OK,400 NOT FOUND,500 SERVER

                    if(response.statusCode==200)
                      {
                        var body = response.body.toString();
                        print("API RESPONSE : "+body);
                      }
                    else
                      {
                        print("API ERROR");
                      }
                  },

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
