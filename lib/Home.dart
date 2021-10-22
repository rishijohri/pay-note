// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Widget homePageList(BuildContext context) {
    return Padding(
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: homePageList(context),
            flex: 3,
          ),
          Container(
            child: Center(
              child: Text(
                'Cash Transactions',
                style:
                    GoogleFonts.amethysta(fontSize: 25, color: Colors.white70),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.redAccent,
                    color: Colors.orange,
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.red, width: 3)),
                    borderOnForeground: true,
                    child: Container(
                      child: Center(
                        child: Text(
                          'Spent',
                          softWrap: true,
                          style: GoogleFonts.amethysta(
                              fontSize: 25,
                              color: Colors.white,
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
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
                        side: BorderSide(width: 3, color: Colors.green)),
                    child: Container(
                      child: Center(
                        child: Text(
                          'Gained',
                          softWrap: true,
                          style: GoogleFonts.amethysta(
                              fontSize: 25,
                              color: Colors.white70,
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
