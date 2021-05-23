import 'package:expenses_app/Models/Transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "No transactions added yet !",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: constraints.maxHeight * 0.70,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, pos) {
              return Card(
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text('₹ ${transactions[pos].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[pos].title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat('dd MMMM, yyyy HH:mm')
                        .format(transactions[pos].dateTime),
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? TextButton.icon(
                          onPressed: () =>
                              deleteTransaction(transactions[pos].id),
                          icon: Icon(Icons.delete),
                          label: Text('Delete', style: TextStyle(color: Colors.amber),))
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.amber,
                          onPressed: () =>
                              deleteTransaction(transactions[pos].id),
                        ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
