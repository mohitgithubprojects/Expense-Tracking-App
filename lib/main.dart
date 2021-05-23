import 'package:expenses_app/Models/Transaction.dart';
import 'package:expenses_app/Widgets/chart.dart';
import 'package:expenses_app/Widgets/transactions_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'Widgets/add_transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  bodyText2: TextStyle(color: Colors.white)))),
      home: MyHomePage(title: 'Expenses App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _transactions = [];

  void _addTransaction(String title, double amt, DateTime date) {
    final newT = Transaction(
        id: date.toString() + amt.toString(),
        title: title,
        amount: amt,
        dateTime: date);
    setState(() {
      _transactions.add(newT);
    });
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddTransaction(_addTransaction);
        });
  }

  List<Transaction> get getRecentTrans {
    return _transactions.where((element) {
      return element.dateTime
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => showBottomSheet(context),
        ),
      ],
    );

    return isLandscape
        ? Scaffold(
            appBar: appBar,
            body: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Show Chart'),
                    Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      },
                    ),
                  ],
                ),
                _showChart
                    ? Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.75,
                        child: Chart(getRecentTrans))
                    : Container(
                        height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.75,
                        child:
                            TransactionList(_transactions, _deleteTransaction))
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => showBottomSheet(context),
              elevation: 15,
            ),
          )
        : Scaffold(
            appBar: appBar,
            body: Column(
              children: <Widget>[
                Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.25,
                    child: Chart(getRecentTrans)),
                Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.75,
                    child: TransactionList(_transactions, _deleteTransaction))
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => showBottomSheet(context),
              elevation: 15,
            ),
          );
  }
}
