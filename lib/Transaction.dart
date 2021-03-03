import 'dart:ui';

class TransactionMoney {
  final double money;
  final DateTime transDate;
  final String bank;
  final String method;
  final String getter;
  final int id;
  final Color color;
  TransactionMoney(
      this.money,
      this.transDate,
      this.bank,
      this.method,
      this.getter,
      this.id,
      this.color,
      );
  Map<String, dynamic> toMap() {
    return {
      'money' : money,
      'date' : transDate.toString(),
      'bank' : bank,
      'method': method,
      'getter' : getter,
      'id': id,
      'color': color.value
    };
  }
}
