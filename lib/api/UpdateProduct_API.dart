import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../UrlHelper.dart';
import 'ViewProducts_API.dart';

class UpdateProduct_API extends StatefulWidget
{
  var upid="";
  UpdateProduct_API({this.upid});
  @override
  UpdateProduct_APIState createState() => UpdateProduct_APIState();
}

class UpdateProduct_APIState extends State<UpdateProduct_API>
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

  var imagename="";


  getdata() async
  {
    Uri url = Uri.parse(UrlHelper.SINGLE_PRODUCT);
    var response = await http.post(url,body: {"pid":widget.upid});
    if (response.statusCode == 200) {
      var body = response.body.toString();
      var json = jsonDecode(body);
      setState(() {
        product_name.text = json["pname"].toString();
        product_descrption.text = json["pdescription"].toString();
        product_rprice.text = json["rprice"].toString();
        product_sprice.text = json["sprice"].toString();
        imagename= json["pimage"].toString();
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
      appBar: AppBar(title: Text("API Edit Product"),),
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
                        :Image.network(UrlHelper.BASE_URL +
                        "uploads/" + imagename,height: 150,width: 150,fit: BoxFit.cover,),
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
                  onPressed: () async{
                    var name = product_name.text.toString();
                    var description = product_descrption.text.toString();
                    var rprice = product_rprice.text.toString(); // Retail Price (Mrp)
                    var sprice = product_sprice.text.toString(); // Selling Price (Discount Price)


                    String base64Image="";

                    if(_image==null)
                      {
                        base64Image="";
                      }
                    else
                      {
                        List<int> imageBytes = _image.readAsBytesSync();
                        base64Image = base64Encode(imageBytes);
                      }

                    Uri url = Uri.parse(UrlHelper.UPDATE_PRODUCT);
                    var response = await http.post(url,body: {
                      "name":name,
                      "description":description,
                      "rprice":rprice,
                      "sprice":sprice,
                      "image":base64Image,
                      "oldimage":imagename,
                      "pid":widget.upid
                    });
                    // 200 OK,400 NOT FOUND,500 SERVER

                    if(response.statusCode==200)
                    {
                      var body = response.body.toString();
                      var json = jsonDecode(body);
                      if(json["status"]=="yes")
                        {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ViewProduct_API()),
                          );
                        }
                    }
                    else
                    {
                      print("API ERROR");
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
