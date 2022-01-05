import 'package:api_practice_2/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  bool hasaccountformed = false;
  AuthForm({Key key, this.hasaccountformed}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();

  var _email = '';
  var _password = '';
  var _username = '';

  bool _isloginpage = false;

  //initially we want to show the sign up page

  startauthentication() {
    final validity = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formkey.currentState.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final fireauth = FirebaseAuth.instance;
    UserCredential result;

    try {
      //if the person already has a account
      if (_isloginpage) {
        result = await fireauth.signInWithEmailAndPassword(
            email: email, password: password);
        setState(() {
          widget.hasaccountformed = true;
        });
      } else {
        result = await fireauth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = result.user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
        setState(() {
          widget.hasaccountformed = true;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication", style: GoogleFonts.roboto()),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
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
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.create, size: 15),
                            Icon(Icons.read_more, size: 15),
                            Icon(Icons.update, size: 15),
                            Icon(Icons.delete, size: 15)
                          ]),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Image(
                        height: 220,
                        image: AssetImage('assets/bg.JPG'),
                      ),
                    ),

                    //if we are not on the login page
                    //then show user name too
                    SizedBox(height: 30),
                    if (!_isloginpage)
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Incorrect username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value;
                          },
                          decoration: InputDecoration(
                              labelText: "Enter username",
                              labelStyle: GoogleFonts.roboto(),
                              prefixIcon: Icon(FontAwesome.user),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                  borderRadius: BorderRadius.circular(10)))),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Incorrect email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                        decoration: InputDecoration(
                            labelText: "Enter Email",
                            labelStyle: GoogleFonts.roboto(),
                            prefixIcon: Icon(FontAwesome.google),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius: BorderRadius.circular(10)))),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        key: ValueKey('password'),
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Incorrect password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                        decoration: InputDecoration(
                            labelText: "Enter Password",
                            labelStyle: GoogleFonts.roboto(),
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius: BorderRadius.circular(10)))),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        startauthentication();
                        //shift to Home screen
                        //if u login
                        if (widget.hasaccountformed) {
                          if (_isloginpage) {
                            Navigator.push(
                                context,
                                (MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Home())));
                          }
                          //i will make a account and take me to the login page now
                          //take me to the
                          else {
                            setState(() {
                              _isloginpage = true;
                            });
                          }
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          height: 40,
                          child: Text(!(_isloginpage) ? "SignUp" : "Login",
                              style: GoogleFonts.roboto(fontSize: 16))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            _isloginpage = !_isloginpage;
                          });
                        },
                        child: Text(
                            !(_isloginpage)
                                ? "already a member?"
                                : "not a member?",
                            style: GoogleFonts.roboto(color: Colors.blue)))
                  ],
                ))),
      ),
    );
  }
}
