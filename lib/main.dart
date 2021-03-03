import 'package:flutter/material.dart';
import 'bills.dart';
import 'setting.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Transaction.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: "Hisabi",
    debugShowCheckedModeBanner: false,
    home: Skeleton(
      title: "Hisabi",
    ),
    theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.amber,
        accentColor: Colors.amber,
        textSelectionColor: Colors.black,
        scaffoldBackgroundColor: Colors.blueGrey),
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
  List<Widget> _currentPage = [HomePage(), BillsPage(), SettingsPage(),];
  List<TransactionMoney> transactionsMoney;
  bool firstTime = false;

  @override
  void initState() {
    super.initState();
    var query = new SmsQuery();
    var msgs = query.querySms(
      kinds: [SmsQueryKind.Inbox],
    );
    print(msgs);
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
            title: Text(
              'Home',
              style: GoogleFonts.amethysta(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            title: Text(
              'Bills',
              style: GoogleFonts.amethysta(),
            ),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.superpowers),
            title: Text(
              'More',
              style: GoogleFonts.amethysta(),
            ),
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
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Widget homePageList(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(top: 25, left: 6, right: 6),
        child: Card(
          color: Colors.white10,
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: LiquidCircularProgressIndicator(
                      value: 0.49,
                      center: Text(
                        '49%',
                        style: GoogleFonts.amethysta(
                            fontSize: 35, color: Colors.primaries[2]),
                      ),
                      backgroundColor: Colors.transparent,

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'expenditure this month',
                    style: GoogleFonts.amethysta(
                        fontSize: 20, color: Colors.white70),
                  ),
                )
              ],
            ),
          ),
          elevation: 5.0,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Expanded(
            child: homePageList(context),
            flex: 3,),
          Container(
            child: Center(
              child: Text(
                'Cash Transactions',
                style: GoogleFonts.amethysta(
                    fontSize: 25,
                    color: Colors.white70
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.redAccent,
                        color: Colors.orange,
                        shape: CircleBorder(
                            side: BorderSide(
                                color: Colors.red,
                                width: 3
                            )
                        ),
                        borderOnForeground: true,
                        child: Container(
                          child: Center(
                            child: Text(
                              'Spent',
                              softWrap: true,
                              style: GoogleFonts.amethysta(
                                  fontSize: 25,
                                  color: Colors.white,
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.greenAccent,
                        borderOnForeground: true,
                        color: Colors.lightGreen,
                        shape: CircleBorder(
                            side: BorderSide(
                                width: 3,
                                color: Colors.green
                            )
                        ),
                        child: Container(

                          child: Center(
                            child: Text(
                              'Gained',
                              softWrap: true,
                              style: GoogleFonts.amethysta(
                                  fontSize: 25,
                                  color: Colors.white70,
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          )
        ],
      ),
    );
  }
}