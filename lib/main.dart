// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bills.dart';
import 'setting.dart';
import 'Home.dart';
import 'Transaction.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'FirstTime.dart';

void main() {
  runApp(MaterialApp(
    title: "Hisabi",
    debugShowCheckedModeBanner: false,
    home: FirstTime(),
    theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)
            .copyWith(secondary: Colors.amber),
        textSelectionTheme:
            TextSelectionThemeData(selectionColor: Colors.black)),
  ));
}

class Skeleton extends StatefulWidget {
  final String title;

  const Skeleton({Key key, this.title}) : super(key: key);

  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _currentIndex = 0;
  List<Widget> _currentPage = [
    HomePage(),
    BillsPage(),
    SettingsPage(),
  ];
  List<TransactionMoney> transactionsMoney;
  bool firstTime = false;

  @override
  void initState() {
    super.initState();
    // var query = new SmsQuery();
    // var msgs = query.querySms(
    //   kinds: [SmsQueryKind.Inbox],
    // );
    print("hi");
    // print(msgs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        fixedColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Bills',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.superpowers),
            label: 'More',
          )
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _currentPage,
      ),
    );
  }
}

//AnimatedSwitcher(
//duration: Duration(milliseconds: 500),
//child: _currentPage[_currentIndex],
//)
