// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'package:sms_advanced/sms_advanced.dart';

class FirstTime extends StatefulWidget {
  const FirstTime({Key key}) : super(key: key);

  @override
  _FirstTimeState createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTime> {
  @override
  void initState() {
    super.initState();
    var query = new SmsQuery();
    var msgs = query.querySms(kinds: [SmsQueryKind.Inbox]);
    print(msgs);
  }

  Future<int> firstCheck() async {
    var prefs = await SharedPreferences.getInstance();
    var first = prefs.getInt("first") ?? 0;
    if (first == 0) {
      await prefs.setInt("first", 0);
    }
    return first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Text("Welcome To HISABI",
                    style: GoogleFonts.aladin(fontSize: 45)),
              ),
            );
            break;
          case ConnectionState.done:
            if (snapshot.data == 1) {
              return Skeleton(
                title: "Hisabi",
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Welcome To HISABI",
                        style: GoogleFonts.aladin(fontSize: 35),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Skeleton(title: "Hisabi")));
                          },
                          child: Text("Lets Get Started"))
                    ],
                  ),
                ),
              );
              // return Center(
              //   child: Column(
              //     children: [Text("Welcome To HISABI"), ElevatedButton(onPressed: () {
              //       Navigator.push(context, MaterialPageRoute(builder: (context) => const Skeleton(title: "Hisabi")));
              //     }, child: Text("Lets Get Started"))],
              //   ),
              // );
            }
            break;
          default:
            return Center(child: Text("Waiting for App"));
        }
      },
      future: firstCheck(),
    );
  }
}
