import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ganit/shared/curve.dart';
import '../services/apiServices.dart';
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
    return  FutureBuilder(
      future: getDataFromChatGPT(widget.scannedText),
      builder: (context, snapshot) {

        if (snapshot.data == null || snapshot.data.toString().isEmpty) {
          return const Scaffold(
            body: Center(
                child: CircularProgressIndicator()
            ),
          );
        }

        String solution = snapshot.data!["choices"][0]["message"]["content"];

        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Stack(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 15),
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
                      child: Text(solution, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18),),
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
      },
    );
  }

  Future<Map<String, dynamic>> getDataFromChatGPT(String userInput) async {
    String completions = dotenv.get('completions', fallback: "Error!");
    Map<String, dynamic> data = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "user",
          "content": userInput
        }
      ]
    };
    Map<String, dynamic> responseData = {};
    await ApiService().fetchPost(context, completions, data).then((response) {
      responseData = response;
    });
    return responseData;
  }


}
