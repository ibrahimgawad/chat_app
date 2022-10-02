import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/pages/register_page.dart';

import 'package:scholar_chat/widgets/custom_button.dart';
import 'package:scholar_chat/widgets/custom_text_field.dart';

import '../helper/show_snack_bar.dart';
import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  static String id = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  String? email, password;

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(children: [
              SizedBox(
                height: 65,
              ),
              Image.asset(
                kLogo,
                height: 120,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Scholar Chat",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: "Pacifico"),
                  ),
                ],
              ),
              SizedBox(
                height: 65,
              ),
              Row(
                children: [
                  Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              CustomTextField(
                  onChange: (data) {
                    email = data;
                  },
                  hintText: "Email"),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  obscureText: true,
                  onChange: (data) {
                    password = data;
                  },
                  hintText: "password"),
              SizedBox(
                height: 25,
              ),
              CustomButton(
                  ontap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isloading = true;
                      });

                      try {
                        print("hi");

                        await loginUser();
                        print("hi2");
                        Navigator.pushNamed(context, ChatPage.id,
                            arguments: email);
                        print("hello");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackBar(
                              context, 'No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(context,
                              'Wrong password provided for that user.');
                        }
                      } catch (e) {
                        print(e);
                        showSnackBar(context, e.toString());
                      }
                      setState(() {
                        isloading = false;
                      });
                    } else {}
                  },
                  text: "LOGIN"),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "don't have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RegisterPage.id);
                    },
                    child: Text(
                      "  Register,",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!.trim(), password: password!);
  }
}
