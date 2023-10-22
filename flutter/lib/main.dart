import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentNumber = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operand = "";
  bool _shouldClear = false;

  void _onButtonPressed(String text) {
    if (text == "C") {
      _clear();
    } else if (text == "+" || text == "-" || text == "x" || text == "/") {
      _performOperation(text);
    } else if (text == "=") {
      _calculate();
    } else {
      _updateOutput(text);
    }
  }

  void _clear() {
    _currentNumber = "";
    _num1 = 0;
    _num2 = 0;
    _operand = "";
    _output = "0";
    _shouldClear = false;
  }

  void _performOperation(String operand) {
    if (_shouldClear) {
      _clear();
    }
    _operand = operand;
    _num1 = double.parse(_currentNumber);
    _currentNumber = "";
  }

  void _calculate() {
    if (_operand.isNotEmpty && _currentNumber.isNotEmpty) {
      _num2 = double.parse(_currentNumber);
      double result = 0.0; // Initialize 'result' to avoid the error.

      switch (_operand) {
        case "+":
          result = _num1 + _num2;
          break;
        case "-":
          result = _num1 - _num2;
          break;
        case "x":
          result = _num1 * _num2;
          break;
        case "/":
          if (_num2 != 0) {
            result = _num1 / _num2;
          } else {
            _output = "Error";
            return;
          }
          break;
      }
      _output = result.toString();
      _operand = "";
      _shouldClear = true;
    }
  }

  void _updateOutput(String text) {
    if (_shouldClear) {
      _output = "0";
      _currentNumber = "";
      _shouldClear = false;
    }

    if (_currentNumber.length < 9) {
      _currentNumber += text;
      _output = _currentNumber;
    }
  }

  Widget _buildButton(String text, String imagePath) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _onButtonPressed(text);
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<List<Map<String, String>>> buttonRows = [
      [{"text": "7", "image": "assets/7.png"}, {"text": "8", "image": "assets/8.png"}, {"text": "9", "image": "assets/9.png"}, {"text": "+", "image": "assets/plus.png"}],
      [{"text": "4", "image": "assets/4.png"}, {"text": "5", "image": "assets/5.png"}, {"text": "6", "image": "assets/6.png"}, {"text": "-", "image": "assets/minus.png"}],
      [{"text": "1", "image": "assets/1.png"}, {"text": "2", "image": "assets/2.png"}, {"text": "3", "image": "assets/3.png"}, {"text": "x", "image": "assets/multiply.png"}],
      [{"text": "C", "image": "assets/clear.png"}, {"text": "0", "image": "assets/0.png"}, {"text": "=", "image": "assets/equals.png"}, {"text": "/", "image": "assets/divide.png"}],
    ];

    List<Widget> buttonGrid = buttonRows
        .map((row) => Row(
              children: row
                  .map((button) => _buildButton(button["text"]!, button["image"]!))
                  .toList(),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('GUI Calculator'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final aspectRatio = constraints.maxWidth / constraints.maxHeight;
          return Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                child: Text(
                  _output,
                  style: TextStyle(
                    fontSize: aspectRatio < 1 ? 36.0 : 48.0,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: buttonGrid,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
