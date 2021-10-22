import 'dart:ui';

class TransactionMoney {
  final double money;
  final DateTime transDate;
  final String bank;
  final String method;
  final String recipient;
  int id;
  Color color;

  TransactionMoney(
    this.money,
    this.transDate,
    this.bank,
    this.method,
    this.recipient,
    this.id,
    this.color,
  );

  Map<String, dynamic> toMap() {
    return {
      'money': money,
      'date': transDate.toString(),
      'bank': bank,
      'method': method,
      'recipient': recipient,
      'id': id,
      'color': color.value
    };
  }
}
