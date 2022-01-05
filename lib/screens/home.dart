import 'package:api_practice_2/screens/authform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  bool hasaccountformed;
    
  Home({Key key, this.hasaccountformed}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  var firestoredata =
      FirebaseFirestore.instance.collection('nitin collection').snapshots();
  TextEditingController _mycontrollername;
  TextEditingController _mycontrollertype;

  TextEditingController _updatename;
  TextEditingController _updatetype;
  
  @override
  void initState() {
    super.initState();

    _mycontrollername = TextEditingController();
    _mycontrollertype = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Community Board",
              style: GoogleFonts.roboto(),
            ),
            actions: [
              InkWell(
                //after signing out we want ki
                //remove the left out details in the form

                onTap: () {
                  setState(() {
                    widget.hasaccountformed = false;
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AuthForm(
                                hasaccountformed: widget.hasaccountformed,
                              )));
                },
                child: Row(
                  children: [
                    Text('Signout ', style: GoogleFonts.adventPro()),
                    Icon(FontAwesome.sign_out),
                  ],
                ),
              )
            ],
            backgroundColor: Colors.purple),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Shimmer.fromColors(
                child: Text("C O M M U N I T Y  B O A R D",
                    style: GoogleFonts.adventPro(fontSize: 25)),
                baseColor: Colors.yellow,
                highlightColor: Colors.purple),
            Text("Your own pocket CRUD application",
                style: GoogleFonts.roboto(color: Colors.grey)),
            SizedBox(
              height: 10,
            ),
            Opacity(
              opacity: 0.7,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.create, size: 15),
                Icon(Icons.read_more, size: 15),
                Icon(Icons.update, size: 15),
                Icon(Icons.delete, size: 15)
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SizedBox(
                height: 1000,
                child: StreamBuilder(
                  stream: firestoredata,
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          //Convert Date-Time Time stamp to normal time
                          DateTime dateTime =
                              snapshot.data.docs[index]['timestamp'].toDate();
                          String d =
                              DateFormat.yMMMd().add_jm().format(dateTime);

                          //Get Docs Id
                          String docId = snapshot.data.docs[index].reference.id;

                          //update the update text editing controllers

                          return Card(
                            elevation: 5.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.all(10),
                                  title: Text(
                                    snapshot.data.docs[index]['name'],
                                    textScaleFactor: 1.3,
                                    style: GoogleFonts.roboto(),
                                  ),
                                  subtitle: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        snapshot.data.docs[index]['title'],
                                        style: GoogleFonts.adamina(),
                                      )),
                                  leading: Container(
                                      height: 200,
                                      width: 70,
                                      child: CircleAvatar(
                                        radius: 30,
                                        child: Text(helper(index).toString(),
                                            textScaleFactor: 1.5),
                                      )),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'nitin collection')
                                                  .doc(docId)
                                                  .delete();
                                            },
                                            child: Icon(FontAwesome.trash)),
                                        TextButton(
                                            onPressed: () {
                                              //OPEN A ALERT DIALOG WITH THE SAME DETAILS
                                              //AS PREVIOUSLY FILLED BY THE USER

                                              _updatename =
                                                  TextEditingController(
                                                      text: snapshot.data
                                                          .docs[index]['name']);

                                              _updatetype =
                                                  TextEditingController(
                                                      text: snapshot
                                                              .data.docs[index]
                                                          ['title']);

                                              AlertDialog _mybox = AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                actions: [
                                                  TextField(
                                                    autocorrect: true,
                                                    autofocus: true,
                                                    controller: _updatename,
                                                    decoration: InputDecoration(
                                                        labelText: "Name"),
                                                  ),
                                                  TextField(
                                                    autocorrect: true,
                                                    autofocus: true,
                                                    controller: _updatetype,
                                                    decoration: InputDecoration(
                                                        labelText: "type"),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Text("CANCEL")),
                                                      TextButton(
                                                          onPressed: () {
                                                            //for updation i need the id of the document to be updated
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'nitin collection')
                                                                .doc(docId)
                                                                .update({
                                                              "name":
                                                                  _updatename
                                                                      .text,
                                                              "title":
                                                                  _updatetype
                                                                      .text,
                                                              "timestamp":
                                                                  DateTime.now()
                                                            }).then((value) {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: Text("SAVE"))
                                                    ],
                                                  ),
                                                ],
                                                insetPadding:
                                                    EdgeInsets.all(15),
                                                actionsPadding:
                                                    EdgeInsets.all(15),
                                                title: Center(
                                                    child: Text("UPDATE")),
                                              );

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return _mybox;
                                                  });
                                            },
                                            child: Icon(FontAwesome.edit))
                                      ],
                                    ),
                                    Text(
                                      d,
                                      textScaleFactor: 1,
                                      style: GoogleFonts.adventPro(),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(FontAwesome.pencil),
            mini: true,
            backgroundColor: Colors.cyan,
            onPressed: () {
              AlertDialog _myalertdialog = AlertDialog(
                insetPadding: EdgeInsets.all(15),
                actionsPadding: EdgeInsets.all(15),
                actions: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      autocorrect: true,
                      autofocus: false,
                      controller: _mycontrollername,
                      decoration:
                          InputDecoration(hintText: "Name", labelText: "Name"),
                    ),
                  ),
                  TextField(
                    autocorrect: true,
                    autofocus: false,
                    controller: _mycontrollertype,
                    decoration:
                        InputDecoration(hintText: "type", labelText: "Type"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            _mycontrollername.clear();
                            _mycontrollertype.clear();
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            if (_mycontrollername.text.isNotEmpty &&
                                _mycontrollertype.text.isNotEmpty) {
                              FirebaseFirestore.instance
                                  .collection('nitin collection')
                                  .add({
                                "name": _mycontrollername.text,
                                "title": _mycontrollertype.text,
                                "timestamp": DateTime.now(),
                              }).then((value) {
                                _mycontrollername.clear();
                                _mycontrollertype.clear();
                                Navigator.pop(context);
                                print(value.id);
                              }).catchError((error) => {print(error)});
                            } else if (_mycontrollername.text.isEmpty &&
                                _mycontrollertype.text.isEmpty) {
                              SnackBar _mysnackbar = SnackBar(
                                  content:
                                      Text("You have not filled any details"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_mysnackbar);
                            } else if (_mycontrollername.text.isEmpty) {
                              SnackBar _mysnackbar = SnackBar(
                                  content: Text("Please Fill The Name"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_mysnackbar);
                            } else if (_mycontrollertype.text.isEmpty) {
                              SnackBar _mysnackbar = SnackBar(
                                  content: Text("Please Fill The Type"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_mysnackbar);
                            }
                          },
                          child: Text("Submit")),
                    ],
                  )
                ],
                contentPadding: EdgeInsets.all(20),
                title: Center(child: Text("Please fill the form")),
              );
              showDialog(
                  context: context,
                  builder: (BuildContext context) => _myalertdialog);
            }));
  }
}

int helper(int d) {
  int f = d;
  f++;
  return f;
}
