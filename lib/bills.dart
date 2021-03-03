import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Transaction.dart';
import 'machine.dart';

class BillsPage extends StatefulWidget {
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage>
    with SingleTickerProviderStateMixin {
  List<TransactionMoney> usableTransaction;
  final TransactionMoney testElement = TransactionMoney(
      500, DateTime.now(), 'Paytm', 'Paytm', 'Mother Dairy', 0, Colors.blue);
  List<TransactionMoney> testTransactions;
  ScrollController cylinderList = ScrollController(initialScrollOffset: 270);

  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    testTransactions = List.generate(50, (index) {
      return testElement;
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget billListTile(
      TransactionMoney data, List<TransactionMoney> specifics, bool allow) {
    return ListTile(
      isThreeLine: true,
      leading: Hero(
        tag: data,
        child: CircleAvatar(
          child: Text(
            data.getter[0],
            style: GoogleFonts.amethysta(
                fontSize: MediaQuery.of(context).size.width / 11,
                color: data.color.computeLuminance() < 0.2
                    ? Colors.white
                    : Colors.black),
          ),
          backgroundColor: data.color,
          minRadius: 1,
          maxRadius: 25,
        ),
      ),
      title: Text(
        data.getter,
        style: GoogleFonts.amethysta(color: data.color, fontSize: 19),
        textAlign: TextAlign.left,
        softWrap: false,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(5, 12, 0, 11),
        child: Text(
          'Using ' +
              data.method +
              '\n'
                  "On " +
              data.transDate.day.toString() +
              "/" +
              data.transDate.month.toString() +
              "/" +
              data.transDate.year.toString(),
          style: GoogleFonts.amethysta(fontSize: 15),
        ),
      ),
      trailing: Text(
        'Rs. ' + data.money.toString(),
        style: GoogleFonts.amethysta(fontSize: 20),
      ),
      onTap: () {
        if (allow) {
          Navigator.of(context)
              .push(PageRouteBuilder(pageBuilder: (BuildContext context, intro, outer) {
//            return individualTilePage(data, specifics);
            return DetailPage(
              data: data,
              specifics: specifics,
            );
          }));
        }
      },
    );
  }

  Widget animatedBillList(List<TransactionMoney> tr) {
    List<String> getters = [];
    tr.forEach((element) {
      if (!(getters.contains(element.getter))) {
        getters.add(element.getter);
      }
    });

    return AnimatedList(
      itemBuilder: (BuildContext context, index, animation) {
        var specGet = tr[index].getter;
        List<TransactionMoney> specifics = [];
        tr.forEach((element) {
          if (element.getter == specGet) {
            specifics.add(element);
          }
        });
        return SlideTransition(
          position:
              animation.drive(Tween(begin: Offset(1.5, 0), end: Offset(0, 0))),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: billListTile(tr[index], specifics, true),
              elevation: 4.0,
            ),
          ),
        );
      },
      initialItemCount: tr.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, snapshot) {
        List<TransactionMoney> transact = [];
        Widget result;
        if (snapshot.hasData) {
          transact = snapshot.data;
          print(transact);
//        result = Padding(
//          padding: const EdgeInsets.only(top: 5),
//          child: billList(transact),
//        );
          usableTransaction = snapshot.data;
          result = Padding(
            padding: const EdgeInsets.only(top: 25),
            child: animatedBillList(snapshot.data),
          );
        } else if (snapshot.hasError) {
          result = Center(
            child: Text(
              'Sorry we got a Problem :( ',
              style: GoogleFonts.amethysta(),
            ),
          );
        } else {
          result = Center(
            child: Text(
              'Wait Just A Moment',
              style: GoogleFonts.amethysta(fontSize: 25),
            ),
          );
        }
        return result;
      },
      future: machine(),
    );
  }
}

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  final TransactionMoney data;
  final List<TransactionMoney> specifics;

  const DetailPage({Key key, this.data, this.specifics}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  Widget tile(TransactionMoney info) {
    return ListTile(
      title: Text(
        info.getter,
        style: GoogleFonts.amethysta(color: widget.data.color, fontSize: 19),
        textAlign: TextAlign.left,
        softWrap: false,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(5, 12, 0, 11),
        child: Text(
          'Using ' +
              info.method +
              '\n'
                  "On " +
              info.transDate.day.toString() +
              "/" +
              info.transDate.month.toString() +
              "/" +
              info.transDate.year.toString(),
          style: GoogleFonts.amethysta(fontSize: 15),
        ),
      ),
      trailing: Text(
        'Rs. ' + info.money.toString(),
        style: GoogleFonts.amethysta(fontSize: 20),
      ),
    );
  }
  int currIndex = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          if (i == 0) {
            return Hero(
              tag: widget.data,
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                color: widget.data.color,
                child: Center(
                  child: Text(
                    widget.data.getter,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amethysta(
                        color: widget.data.color.computeLuminance() < 0.2
                            ? Colors.white
                            : Colors.black,
                        fontSize: 35),
                  ),
                ),
              ),
            );
          }
          return tile(widget.specifics[i - 1]);
        },
        itemCount: widget.specifics.length + 1,
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.monetization_on), title: Text('Total')),
        BottomNavigationBarItem(icon: Icon(Icons.assessment), title: Text('Analyse'))
      ],
        currentIndex: currIndex,
        selectedItemColor: widget.data.color,
        onTap: (i) {
        setState(() {
          currIndex = i;
        });
        },),
    );
  }
}

