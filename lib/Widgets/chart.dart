import 'package:expenses_app/Models/Transaction.dart';
import './chart_bar.dart';
import 'package:flutter/material.dart ';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> list;

  Chart(this.list);

  List<Map<String, Object>> get groupedTransValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0;
      for (int i = 0; i < list.length; i++) {
        if (list[i].dateTime.day == weekDay.day &&
            list[i].dateTime.month == weekDay.month &&
            list[i].dateTime.year == weekDay.year) {
          totalSum += list[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransValues.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransValues);
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBars(
                label: data['day'],
                amountSpent: data['amount'],
                amountSpentPer: totalSpending == 0.0 ? 0.0:(data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
