
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../UrlHelper.dart';
import 'UpdateProduct_API.dart';

class ViewProductModel_API extends StatefulWidget {
  @override
  ViewProductModel_APIState createState() => ViewProductModel_APIState();
}

class ViewProductModel_APIState extends State<ViewProductModel_API> {
  Future<List> data;

  Future<List> getdata() async {
    Uri url = Uri.parse(UrlHelper.VIEW_PRODUCT);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = response.body.toString();
      var json = jsonDecode(body);
      return json;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      data = getdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API View Product Model"),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            if (snapshots.data.length <= 0) {
              return Center(child: Text("No Data"));
            } else {
              return ListView.builder(
                itemCount: snapshots.data.length,
                itemBuilder: (context, position) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                    elevation: 5,
                    shadowColor: Colors.teal,
                    child: ListTile(
                      // leading: Image.network(UrlHelper.BASE_URL+"uploads/"+snapshots.data[position]["pimage"].toString()),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.network(
                          UrlHelper.BASE_URL +
                              "uploads/" +
                              snapshots.data[position]["pimage"].toString(),
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      ),

                      title: Text(snapshots.data[position]["pname"].toString()),
                      onTap: () {
                        AlertDialog alert = new AlertDialog(
                          title: Text("Delete"),
                          backgroundColor: Colors.blue.shade100,
                          contentPadding: EdgeInsets.all(10),
                          actions: [
                            RaisedButton(
                              child: Text("Edit"),
                              onPressed: () {
                                var pid = snapshots.data[position]["pid"].toString();
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => UpdateProduct_API(upid: pid)),
                                );
                              },
                            ),
                            RaisedButton(
                              child: Text("Yes"),
                              onPressed: () async {
                                var pid =
                                snapshots.data[position]["pid"].toString();

                                Uri url = Uri.parse(UrlHelper.DELETE_PRODUCT);
                                var response =
                                await http.post(url, body: {"pid": pid});
                                if (response.statusCode == 200) {
                                  var body = response.body.toString();
                                  var json = jsonDecode(body);
                                  if (json["status"] == "yes") {
                                    setState(() {
                                      data = getdata();
                                    });
                                  } else {
                                    print("Record Not Deleted");
                                  }
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                            RaisedButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                        showDialog(
                            context: context,
                            builder: (context) {
                              return alert;
                            });
                      },
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
