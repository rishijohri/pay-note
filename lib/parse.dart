import 'dart:ui';
import 'package:flutter/material.dart';
import 'Transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_color/random_color.dart';
import 'package:sms_advanced/sms_advanced.dart';

TransactionMoney singleMsg(SmsMessage msg) {
  List banks = ['paytm', 'sbi', 'phonepe'];
  List payType = ['debited', 'paid'];
  List prepositions = ['.', 'from', 'at', 'on'];
  List flags = ['due', 'requested', 'ignore', 'failed'];
  var address = msg.address;
  address = address.toLowerCase();
  var body = msg.body;
  body = body.toLowerCase();
  DateTime msgDate = msg.dateSent;
  var bank = '';
  double money = -1;
  String recipient = "";
  banks.forEach((element) {
    if (address.contains(element)) {
      bank = element;
      payType.forEach((bodyElement) {
        if (body.contains(bodyElement)) {
          body = body.replaceAll('rs.', 'rs');
          body = body.replaceAll('inr', 'rs');
          body = body.replaceAll('rs', ' rs ');
          var bodyList = body.split(" ");
          while (bodyList.remove(" ") || bodyList.remove("")) {
            bodyList.remove(" ");
            bodyList.remove("");
          }
          int moneyIndex = bodyList.indexOf("rs");
          if (flags.any((item) => bodyList.contains(item))) {
            return null;
          }
          if (moneyIndex != -1) {
            moneyIndex += 1;
            String moneyString = bodyList[moneyIndex];
            moneyString = moneyString.split(',').join();
            if (moneyString.endsWith('.')) {
              var temp = moneyString.split('.');
              temp.removeLast();
              moneyString = temp.join('.');
            }
            money = double.parse(moneyString);
          } else
            return null;

          if (bodyList.contains('to')) {
            int recIndex = bodyList.indexOf('to') + 1;
            while (!(prepositions.contains(bodyList[recIndex]))) {
              recipient += " " + bodyList[recIndex];
              recIndex++;
              if (recIndex == bodyList.length - 1) {
                recipient = "";
                break;
              }
            }
          }
          if (recipient == "") recipient = 'unknown';
        }
      });
    }
  });
  if (bank == '' || money == -1) return null;
  List recList = recipient.split(" ");
  recList.removeWhere((element) => element == " ");
  if (recList.length >= 3) {
    recipient = recList[0] + " " + recList[1] + " " + recList[2];
  }
  return TransactionMoney(money, msgDate, bank, bank, recipient, null, null);
  // return TransactionMoney(10, DateTime.now(), 'bank', 'method', 'recipient', 5, Colors.white);
}

Future<List<TransactionMoney>> machine() async {
  List<TransactionMoney> newTransactions = [];
  var query = new SmsQuery();
  var msgs = await query.querySms(
    kinds: [SmsQueryKind.Inbox],
  );
  var prefs = await SharedPreferences.getInstance();
  int transID = prefs.getInt('verse') ?? 0;
  String beginDateStr = prefs.getString('LastDate') ?? '2000-01-01';
  DateTime beginDate = DateTime.parse(beginDateStr);
  List<String> recipientList = [];
  RandomColor _randomColor = RandomColor();
  List<Color> colorList = [];
  var transDatabase = await openDatabase(
    join(await getDatabasesPath(), 'TransactionStore.db'),
    onCreate: (db, ver) {
      return db.execute(
          "CREATE TABLE TransactionStore(money REAL, date TEXT, bank TEXT, method TEXT, recipient TEXT, id INTEGER, color INTEGER)");
    },
    version: 1,
  );
  var transactionTable = await transDatabase.query('TransactionStore');
  transactionTable.forEach((element) {
    if (!(recipientList.contains(element['recipient']))) {
      recipientList.add(element['recipient']);
      colorList.add(Color(element['color']));
    }
  });
  msgs.retainWhere((element) {
    if (element.dateSent.difference(beginDate) > Duration(seconds: 1)) {
      return true;
    }
    return false;
  });

  msgs.forEach((msg) {
    TransactionMoney parsedMsg = singleMsg(msg);
    if (parsedMsg != null) {
      if (recipientList.contains(parsedMsg.recipient)) {
        parsedMsg.color = colorList[recipientList.indexOf(parsedMsg.recipient)];
        parsedMsg.id = transID + 1;
        transID++;
        newTransactions.add(parsedMsg);
      } else {
        parsedMsg.color = _randomColor.randomColor();
        recipientList.add(parsedMsg.recipient);
        colorList.add(parsedMsg.color);
        parsedMsg.id = transID + 1;
        transID++;
      }
    }
  });
  print("chkpnt before adding ${transactionTable.length}");
  print(transID);
  print(beginDate);
  if (newTransactions.isNotEmpty) {
    await prefs.setInt('verse', transID);
    await prefs.setString('LastDate', newTransactions[0].transDate.toString());
    newTransactions.forEach((element) {
      transDatabase.insert('TransactionStore', element.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
  List<TransactionMoney> allTransactions = [];
  transactionTable = await transDatabase.query('TransactionStore');
  print("chkpnt fin ${transactionTable.length}");
  allTransactions = List.generate(transactionTable.length, (i) {
    return TransactionMoney(
      transactionTable[i]['money'],
      DateTime.parse(transactionTable[i]['date']),
      transactionTable[i]['bank'],
      transactionTable[i]['method'],
      transactionTable[i]['recipient'],
      transactionTable[i]['id'],
      Color(transactionTable[i]['color']),
    );
  });
  allTransactions.toSet().toList();
  if (allTransactions.isNotEmpty) {
    allTransactions.sort((a, b) {
      return b.transDate.compareTo(a.transDate);
    });
  }
  print(allTransactions.length);
  return allTransactions;
}
