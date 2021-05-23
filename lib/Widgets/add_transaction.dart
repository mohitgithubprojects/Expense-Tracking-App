import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function function;

  AddTransaction(this.function);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addData(BuildContext context) {
    String title = _titleController.text;
    double amount = double.parse(_amountController.text);
    if (title.isEmpty || amount < 0 || _selectedDate==null) {
      return;
    }

    widget.function(title, amount, _selectedDate);
    Navigator.of(context).pop();
    _showToast(context, 'Transaction Successfully Added !');
  }

  void _datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.blue),
                  hintText: 'Enter transaction title',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2)),
                ),
                controller: _titleController,
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _addData(context),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.blue),
                  hintText: 'Enter transaction amount',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2)),
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _addData(context),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No date chosen !'
                          : DateFormat.yMMMEd().format(_selectedDate)),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      onPressed: _datePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () => _addData(context),
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
