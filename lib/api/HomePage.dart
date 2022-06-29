
import 'package:flutter/material.dart';
import 'AddProduct_API.dart';
import 'AddUser_API.dart';
import 'ViewProducts_API.dart';
import 'ViewUser_API.dart';

class Api_HomePage extends StatefulWidget
{
  @override
  _Api_HomePageState createState() => _Api_HomePageState();
}

class _Api_HomePageState extends State<Api_HomePage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Home"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Welcome, Guest!"),
            accountEmail: Text("test@gmail.com"),
          ),
          ListTile(
            leading: Icon(Icons.arrow_forward_ios),
            title: Text("Add Product"),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddProduct_API(),)
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.arrow_forward_ios),
            title: Text("View Product"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ViewProduct_API(),)
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.arrow_forward_ios),
            title: Text("Add User"),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddUser_API(),)
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.arrow_forward_ios),
            title: Text("View User"),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ViewUser_API(),)
              );
            },
          ),
          Divider(),

        ],
      ),
    );
  }
}
