import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_level/display_page.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyApp1(),
    );
  }
}

class MyApp1 extends StatefulWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  State<MyApp1> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  double _currentValue = 0;

  setEndPressed(double value) {
    setState(() {
      _currentValue = value;
    });
  }

  final DatabaseRef = FirebaseDatabase.instance.reference();
  final DatabaseReference ref = FirebaseDatabase.instance.ref("/test");
  late DatabaseReference dbRef;
  final setLevel = TextEditingController();
  late String string = '';
  late String volume = '';
  late String cm = '';
  late String cmSetpoint = '';

  void initState() {
    readDatabase();
    dbRef = FirebaseDatabase.instance.ref().child("setLevel");
    super.initState();
  }

  _buildAppBar() {
    return AppBar(
      title: const Text(
        'ระบบควบคุมระดับน้ำอัตโนมัติ',
      ),
    );
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    const roundTextStyle = TextStyle(fontSize: 16.0, color: Colors.white);
    return FloatingActionButton(
      child: Text(text, style: roundTextStyle),
      onPressed: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double myHeight = MediaQuery.of(context).size.height;
    final double myWidth = MediaQuery.of(context).size.width;
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: myHeight * 0.04,
                  left: myWidth * 0.08,
                  right: myWidth * 0.08,
                  bottom: myHeight * 0.01,
                ),
                child: Row(
                  children: [
                    Text(
                      'ระบบควบคุมระดับน้ำอัตโนมัติ',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: myHeight * 0.001,
                  left: myWidth * 0.08,
                ),
                child: Row(
                  children: [
                    Text(
                      'เป็นระบบที่ทำงานรักษาระดับได้เเบบอัตโนมัติโดยการสั่งการจากตู้ควบคุมเเละจากแอปพลิเคชันนี้',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.normal,
                        color: Colors.yellow[900],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Container(
                  height: myHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.05,
                          vertical: myHeight * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: myWidth * 0.03,
                                vertical: myHeight * 0.003,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: const Color.fromARGB(255, 193, 224, 247)
                                    .withOpacity(0.6),
                              ),
                              child: Center(
                                child: Text(
                                  'ระบบควบคุมน้ำเข้าถัง',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: myHeight * 0.04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myText(
                              'ระดับที่ต้องการ     :  ' +
                                  volume +
                                  '   L (ลิตร)',
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.05,
                          vertical: myHeight * 0.009,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '* ระบบควบคุมระดับน้ำเข้าถังหน่วยที่ใช่คือ ลิตร ',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: myWidth * 0.13,
                  vertical: myHeight * 0.02,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 192, 192, 192)
                        .withOpacity(0.6),
                  ),
                  child: ListTile(
                    title: ListTile(
                      leading: const Icon(Icons.settings_applications),
                      title: Center(
                        child: Text(
                          'Set Level',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Container(
                              child: AlertDialog(
                                title: const Text("ใส่ระดับน้ำที่ต้องการ"),
                                content: TextField(
                                  controller: setLevel,
                                  onChanged: (value) {},
                                  decoration: const InputDecoration(
                                    hintText: "กรุณาใส่ระดับน้ำที่ต้องการ",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("no"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      dbRef.push().set(setLevel.text);
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: myHeight * 0.1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                child: Container(
                  height: myHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.05,
                          vertical: myHeight * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: myWidth * 0.03,
                                vertical: myHeight * 0.005,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: const Color.fromARGB(255, 193, 224, 247)
                                    .withOpacity(0.6),
                              ),
                              child: Center(
                                child: Text(
                                  'ระบบควบคุมระดับน้ำในถัง',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: myHeight * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myText(
                              'ระดับที่มีในถัง   :  ' + cm + '  Cm (เซนติเมตร)',
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: myHeight * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myText(
                              ' :  ' + string + '   L (ลิตร)',
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.05,
                          vertical: myHeight * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '* ระบบควบคุมระดับน้ำในถังหน่วยที่ใช่คือ ลิตร เเละได้แปลงเป็น เซนติเมตร   ',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myText(String txt) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
      child: Text(
        txt,
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void readDatabase() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('/test/string');
    starCountRef.onValue.listen((event) {
      final sef1 = event.snapshot.value;
      DatabaseReference starCountRef2 =
          FirebaseDatabase.instance.ref('/test/Volume');
      starCountRef2.onValue.listen((event2) {
        final Duty = event2.snapshot.value;
        DatabaseReference starCountRef3 =
            FirebaseDatabase.instance.ref('/test/Cm');
        starCountRef3.onValue.listen((event3) {
          final data1 = event3.snapshot.value;
          setState(() {
            string = sef1.toString();
            volume = Duty.toString();
            cm = data1.toString();
          });
        });
      });
    });
  }
}
