import 'package:flutter/material.dart';
import 'package:ganit/shared/curve.dart';
import 'package:share_plus/share_plus.dart';
import '../shared/constants.dart';

class SolutionPage extends StatelessWidget {
  final String answer;
  final String question;
  const SolutionPage({Key? key, required this.answer, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: Colors.blueAccent,
          child: customButton("Share", shareQuestionAndAnswer, width(context)*0.9, Colors.white, Colors.black)
      ),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: CustomPaint(
                  painter: HeaderPainter(),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: height(context)*0.3
                  )
              )
          ),
          Center(
            child: Container(
                height: height(context)*0.37,
                width: width(context)*0.9,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: const Border(),
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.blueAccent,
                          blurRadius: 1.0,
                          offset: Offset(0, 5)
                      )
                    ]
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Text(answer, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18),),
                    ),
                  ),
                )
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Align(
                alignment: Alignment.topLeft,
                child: CustomPaint(
                    painter: FooterPainter(),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: height(context)*0.2
                    )
                )
            ),
          ),
        ],
      ),
    );
  }

  void shareQuestionAndAnswer(){
    Share.share('Question:\n\n$question\n\n\n\nAnswer:\n\n$answer');
  }
}
