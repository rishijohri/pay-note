import 'dart:ui';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'Transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_color/random_color.dart';

Future<List<TransactionMoney>> machine() async {
  List<TransactionMoney> submit = [];
  var query = new SmsQuery();
  var msgs = await query.querySms(
    kinds: [SmsQueryKind.Inbox],
  );
  var prefs = await SharedPreferences.getInstance();
  int transID = prefs.getInt('verse') ?? 0;
  String useDate = prefs.getString('LastDate') ?? '2000-01-01';
  DateTime usableDate = DateTime.parse(useDate);
  List<String> getList = [] ;
  RandomColor _randomColor = RandomColor();
  List<Color> colorList = [] ;
  var transDatabase = await openDatabase(
      join(await getDatabasesPath(), 'TransactionStore.db'),
      onCreate: (db, ver) {
        return db.execute(
            "CREATE TABLE TransactionStore(money REAL, date TEXT, bank TEXT, method TEXT, getter TEXT, id INTEGER, color INTEGER)");
      },
      version: 1,
  );
  var mapping = await transDatabase.query('TransactionStore');
  if (mapping.isNotEmpty) {
    mapping.forEach((element) {
      if (!(getList.contains(element['getter']))) {
        getList.add(element['getter']);
        colorList.add(Color(element['color']));
      }
    });
  }

  msgs.retainWhere((element) {
    if (element.dateSent.difference(usableDate) > Duration(seconds: 1)) {
      return true;
    }
    return false;
  });
  var bow = [
    'debited',
    'paid',
  ];
  var masters = ['sbi',
    'paytm',
    'phonpe',
  ];

  // Message Processing Starts From Here
  msgs.forEach((element) {
    String address = element.address.toLowerCase().trim();
    String body = element.body.toLowerCase();
    List<String> sorts = body.split(' ');
    DateTime date = element.dateSent;
    masters.forEach((elemental) {
      if (address.contains(elemental)) {
        if (sorts.contains(bow[0]) || sorts.contains(bow[1])) {
          double num;
          String bodyUpdate = body.replaceAll('rs.', 'rs');
          bodyUpdate = bodyUpdate.replaceAll('inr', 'rs');
          bodyUpdate = bodyUpdate.replaceAll('rs', 'rs ');
          List<String> improvedSort = bodyUpdate.split(' ');
          improvedSort.remove('');
          int rs = improvedSort.indexOf('rs');
          if (!(improvedSort.contains('due')) &&
              !(improvedSort.contains('ignore')) &&
              !(improvedSort.contains('requested'))) {
            var tempo = improvedSort[rs + 1];
            if (tempo.contains(',')) {
              var quad = tempo.split(',');
              tempo = quad.join();
            }
            if (tempo[tempo.length - 1] == '.') {
              var duo = tempo.split('.');
              duo.removeLast();
              tempo = duo.join('.');
            }
            num = double.parse(tempo);
          } else {
            num = 0.0;
          }
          var mod = '';
          if (improvedSort.contains('to')) {
            int i = improvedSort.indexOf('to') + 1;
            var end = true;
            while (end) {
              if (improvedSort[i] == '.' ||
                  improvedSort[i] == 'on' ||
                  improvedSort[i] == 'at' ||
                  i >= (improvedSort.length - 1)) {
                end = false;
              } else {
                mod += improvedSort[i] + ' ';
                i++;
              }
            }
          } else {
            mod = 'unknown';
          }
          if (num != 0.0) {
            Color filler;
            if (getList.contains(mod)) {
              filler = colorList[getList.indexOf(mod)];
            } else {
              getList.add(mod);
              filler = _randomColor.randomColor();
              colorList.add(filler);
            }
            submit.add(TransactionMoney(
                num, date, elemental, elemental, mod, transID, filler));
            print('added a transaction with id'+transID.toString());
            transID++;

          }
        }
      }
    });
  });

  var maps = await transDatabase.query('TransactionStore');
  List<TransactionMoney> trList = [];
  if (maps.isNotEmpty) {
    trList = List.generate(maps.length, (i) {
      return TransactionMoney(
          maps[i]['money'],
          DateTime.parse(maps[i]['date']),
          maps[i]['bank'],
          maps[i]['method'],
          maps[i]['getter'],
          maps[i]['id'],
          Color(maps[i]['color']),
      );
    });
  }
  if (submit.isNotEmpty) {
    prefs.setInt('verse', transID + 1);
    prefs.setString('LastDate', submit[0].transDate.toString());
    submit.forEach((element) {
      trList.add(element);
      transDatabase.insert('TransactionStore', element.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
  if (trList.isNotEmpty ) {
    trList.sort((a, b) {
      return b.transDate.compareTo(a.transDate);
    });
  }
  return trList;
}
