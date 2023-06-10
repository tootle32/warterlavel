import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Display extends StatefulWidget {
  const Display({Key? key}) : super(key: key);

  @override
  State<Display> createState() => _DisplayState();
  
}

class _DisplayState extends State<Display> {
  final NotificationsController = TextEditingController();
  final nameController = TextEditingController();
  
  late DatabaseReference dbRef;
  Query refQ = FirebaseDatabase.instance.ref().child('test');
  
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("Notifications");
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ระบบควบคุมระดับน้ำอัตโนมัติ"),
        ),
        drawer: Drawer(
            child: Container(
          color: Colors.deepPurple[100],
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                    child: Text(
                  'S E T T I N G',
                  style: TextStyle(fontSize: 35),
                )),
              ),
              ListTile(
                iconColor: Colors.transparent,
                title: ListTile(
                  leading: Icon(Icons.notification_add_outlined),
                  title: Text(
                    'Notifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            child: AlertDialog(
                              title: Text("ปัญหาที่พบ"),
                              content: TextField(
                                controller: NotificationsController,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                    hintText: "กรุณาใส่ปัญหาที่พบ"),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("no"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    dbRef
                                        .push()
                                        .set(NotificationsController.text);
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
              ListTile(
                iconColor: Colors.transparent,
                title: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    'Exit',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
              ),
              ListTile(
                iconColor: Colors.transparent,
                title: ListTile(
                  leading: Icon(Icons.more),
                  title: Text(
                    'More information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon: FlutterLogo(),
                      applicationLegalese: "Legalese information ...",
                      applicationName: "Flutter Mobile ",
                    );
                  },
                ),
              ),
            ],
          ),
        )));
  }
}
