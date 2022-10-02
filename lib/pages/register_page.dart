import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/pages/chat_page.dart';

import '../helper/show_snack_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  static String id = "RegisterPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  bool isloading = false;

  GlobalKey<FormState> formKey = GlobalKey();

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
                    "REGISTER",
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
                        await registerUser();
                        Navigator.pushNamed(context, ChatPage.id,
                            arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBar(
                              context, "The password provided is too weak.");
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(context,
                              "The account already exists for that email.");
                        }
                      } catch (e) {
                        showSnackBar(context, e.toString());
                      }
                      setState(() {
                        isloading = false;
                      });
                    } else {}
                  },
                  text: "REGISTER"),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "already have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    child: Text(
                      "  Login,",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => Navigator.pop(context),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email!.trim(), password: password!);
  }
}
