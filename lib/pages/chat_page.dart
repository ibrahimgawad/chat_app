import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/models/message.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);
  static String id = "chat page";
  ScrollController _controller = ScrollController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.docs.runtimeType);

            List<Message> messagesList = [];

            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.formJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: kPrimaryColor,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          kLogo,
                          height: 60,
                        ),
                        Text("Chat"),
                      ]),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: _controller,
                          itemCount: messagesList.length,
                          itemBuilder: ((context, index) {
                            return messagesList[index].id == email
                                ? ChatBubble(
                                    message: messagesList[index],
                                  )
                                : ChatBubbleForFriend(
                                    message: messagesList[index]);
                          })),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (data) {
                          messages
                              .add({
                                kMessage: data,
                                kCreatedAt: DateTime.now(),
                                KId: email,
                              })
                              .then((value) => print("User Added is $value"))
                              .catchError((error) =>
                                  print("Failed to add user: $error"));
                          controller.clear();
                          _controller.animateTo(
                              _controller.position.minScrollExtent,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        decoration: InputDecoration(
                          hintText: "Send message",
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.send,
                                color: kPrimaryColor,
                              )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: kPrimaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ));
          } else {
            return Text("loading...");
          }
        });
  }
}
