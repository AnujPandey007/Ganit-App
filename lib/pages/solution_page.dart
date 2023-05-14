import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ganit/shared/curve.dart';
import '../shared/constants.dart';

class SolutionPage extends StatefulWidget {
  final String scannedText;
  const SolutionPage({Key? key, required this.scannedText}) : super(key: key);

  @override
  State<SolutionPage> createState() => _SolutionPageState();
}

class _SolutionPageState extends State<SolutionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          Center(
            child: Container(
                // padding: const EdgeInsets.only(bottom: 15),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(widget.scannedText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18),),
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
                        height: height(context)*0.35
                    )
                )
            ),
          ),
        ],
      ),
    );
  }


}
