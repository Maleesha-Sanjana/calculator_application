import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:my_calculator/buttons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Modern gradient theme colors
  Color primaryGradientStart = Color(0xFF667eea);
  Color primaryGradientEnd = Color(0xFF764ba2);
  Color displayBackground = Color(0xFF1a1a2e);
  Color buttonBackground = Color(0xFF16213e);
  Color operatorButton = Color(0xFFe94560);
  Color numberButton = Color(0xFF0f3460);
  Color accentButton = Color(0xFFf39c12);

  var userQuestion = "";
  var userAnswer = "0";

  final List<String> buttons = [
    "AC",
    "CE",
    "%",
    "/",
    "9",
    "8",
    "7",
    "x",
    "6",
    "5",
    "4",
    "-",
    "3",
    "2",
    "1",
    "+",
    "0",
    ".",
    "DEL",
    "="
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryGradientStart, primaryGradientEnd],
          ),
        ),
        child: Column(
          children: [
            // Modern display section
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                color: displayBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 60, 20, 20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // App name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Calculator",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Icon(
                                Icons.calculate,
                                color: Colors.white54,
                                size: 20,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Expression display
                          Container(
                            height: 60,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                userQuestion.isEmpty ? "0" : userQuestion,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Result display
                          Container(
                            height: 80,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                userAnswer,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Modern button grid
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: buttons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildButton(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(int index) {
    String buttonText = buttons[index];
    Color buttonColor;
    Color textColor = Colors.white;

    // Determine button color based on type
    if (index == 0) {
      // AC button
      buttonColor = accentButton;
    } else if (index == 1) {
      // CE button
      buttonColor = Color(0xFF95a5a6);
    } else if (index == buttons.length - 2) {
      // DEL button
      buttonColor = Color(0xFF95a5a6);
    } else if (index == buttons.length - 1) {
      // = button
      buttonColor = operatorButton;
    } else if (['+', '-', 'x', '/', '%'].contains(buttonText)) {
      // Operator buttons
      buttonColor = operatorButton;
    } else {
      // Number buttons
      buttonColor = numberButton;
    }

    return MyButton(
      buttonColor: buttonColor,
      buttonText: buttonText,
      textColor: textColor,
      buttonTapped: () {
        setState(() {
          if (index == 0) {
            // AC - Clear all
            userQuestion = "";
            userAnswer = "0";
          } else if (index == 1) {
            // CE - Clear entry
            userQuestion = "";
            userAnswer = "0";
          } else if (index == buttons.length - 2) {
            // DEL - Delete last character
            if (userQuestion.isNotEmpty) {
              userQuestion = userQuestion.substring(0, userQuestion.length - 1);
              userAnswer = "0";
            }
          } else if (index == buttons.length - 1) {
            // = - Calculate result
            equalPressed();
          } else {
            // Number or operator
            userQuestion += buttonText;
          }
        });
      },
    );
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      // Format the result nicely
      if (eval == eval.toInt()) {
        userAnswer = eval.toInt().toString();
      } else {
        userAnswer = eval.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      userAnswer = "Error";
    }
  }
}
