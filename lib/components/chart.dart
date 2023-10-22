import 'dart:ffi';

import 'package:expenses/components/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, this.recentTransactions});

  final List<Transaction>? recentTransactions;

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;
      for (var i = 0; i < recentTransactions!.length; i++) {
        bool sameDay = recentTransactions![i].date.day == weekDay.day;
        bool sameMonth = recentTransactions![i].date.month == weekDay.month;
        bool sameYear = recentTransactions![i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransactions![i].value;
        }
      }

      return {'day': DateFormat().add_E().format(weekDay), 'value': totalSum};
    }).reversed.toList();
  }

  double get weekTotalValue {
    return groupedTransactions.fold(0, (sum, tr) {
      return sum + double.parse(tr['value'].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'].toString(),
                value: double.parse(tr['value'].toString()),
                percentage: weekTotalValue == 0
                    ? 0
                    : double.parse(tr['value'].toString()) / weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
