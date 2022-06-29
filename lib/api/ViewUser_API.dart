import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../UrlHelper.dart';
import 'UpdateUser_API.dart';

class ViewUser_API extends StatefulWidget {
  @override
  ViewUser_APIState createState() => ViewUser_APIState();
}

class ViewUser_APIState extends State<ViewUser_API> {
  Future<List> data;

  Future<List> getdata() async {
    Uri url = Uri.parse(UrlHelper.VIEW_USER);
    var response = await http.post(url);
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
    data = getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API View User "),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length <= 0) {
              return Center(
                child: Text("No Data Avilable"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, position) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                    elevation: 7,
                    shadowColor: Colors.pink,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.network(UrlHelper.BASE_URL +
                            "uploads/" +
                            snapshot.data[position]["pimage"].toString(),
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(snapshot.data[position]["pname"].toString()),
                      subtitle:
                          Text(snapshot.data[position]["pcontact"].toString()),

                      onLongPress: () {
                        AlertDialog alert = new AlertDialog(
                          title: Text("Delete"),
                          backgroundColor: Colors.blue.shade100,
                          contentPadding: EdgeInsets.all(10),
                          actions: [
                            RaisedButton(
                              child: Text("Edit"),
                              onPressed: () {
                                var pid =  snapshot.data[position]["pid"].toString();
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => UpdateUser_API(updateid : pid)),
                                );
                              },
                            ),

                            RaisedButton(
                              child: Text("Yes"),
                              onPressed: () async {
                                var pid =
                                    snapshot.data[position]["pid"].toString();
                                // print(""+pid);

                                Uri url = Uri.parse(UrlHelper.DELETE_USER);
                                var response =
                                    await http.post(url, body: {"pid": pid});
                                if (response.statusCode == 200) {
                                  var body = response.body.toString();
                                  var json = jsonDecode(body);
                                  if (json["status"] == "yes") {
                                    setState(() {
                                      data = getdata();
                                    });
                                  }
                                } else {
                                  print("Record Not Deleted");
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
