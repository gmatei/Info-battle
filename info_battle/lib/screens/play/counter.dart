//@dart=2.9
library counter;

import 'package:flutter/material.dart';

typedef CounterChangeCallback = void Function(num value);

class Counter extends StatelessWidget {
  final CounterChangeCallback onChanged;

  Counter({
    Key key,
    @required num initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    @required this.decimalPlaces,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
  })  : selectedValue = initialValue,
        super(key: key);

  final num minValue;
  final num maxValue;
  final int decimalPlaces;
  num selectedValue;
  final num step;
  Color color;
  TextStyle textStyle;

  final double buttonSize;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
    }
  }

  @override
  Widget build(BuildContext context) {
    textStyle = textStyle ??
        TextStyle(
          fontSize: 20.0,
        );

    return Container(
      padding: EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: 'button2',
              onPressed: _decrementCounter,
              elevation: 2,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
              backgroundColor: color,
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            child: Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: textStyle),
          ),
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: 'button1',
              onPressed: _incrementCounter,
              elevation: 2,
              tooltip: 'Increment',
              child: Icon(Icons.add),
              backgroundColor: color,
            ),
          ),
        ],
      ),
    );
  }
}
