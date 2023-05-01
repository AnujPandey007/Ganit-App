import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ganit/pages/solution_page.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_expressions/math_expressions.dart';

import '../shared/constants.dart';
import '../shared/curve.dart';
import '../shared/customRoute.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool textScanning = false;
  XFile? imageFile;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: customButton("Solve", solution, width(context)*0.9),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: CustomPaint(
                      painter: HeaderPainter(),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: height(context)*0.35
                      )
                  )
              ),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height(context)*0.2,),
                  if (textScanning) const CircularProgressIndicator(),
                  if (!textScanning && imageFile == null)
                    Container(
                      width: width(context)*0.7,
                      height: height(context)*0.3,
                      decoration: BoxDecoration(
                          border: const Border(),
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey[300],
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.blueAccent,
                                blurRadius: 1.0,
                                offset: Offset(0, 5)
                            )
                          ]
                      ),
                      child: Center(
                        child: Icon(Icons.image, color: Colors.grey, size: 70,)
                      ),
                    ),
                  if (imageFile != null)
                    Container(
                        width: width(context)*0.7,
                        height: height(context)*0.3,
                        decoration: BoxDecoration(
                            border: const Border(),
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.grey[300],
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 1.0,
                                  offset: Offset(0, 5)
                              )
                            ]
                        ),
                        child: Image.file(File(imageFile!.path))
                    ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.grey,
                              shadowColor: Colors.grey[400],
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.grey,
                              shadowColor: Colors.grey[400],
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  Text(
                                    "Camera",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: const Border(),
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.blueAccent,
                                blurRadius: 1.0,
                                offset: Offset(0, 3)
                            )
                          ]
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          maxLines: 8,
                          keyboardType: TextInputType.multiline,
                          decoration: textInputDecoration.copyWith(
                            hintText: "Ask Here..",
                          ),
                          validator: (val) => (val==null||val.isEmpty) ? 'Please select the image or ask a question' : null,
                          controller: textEditingController,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void solution() {
    if(_formKey.currentState!.validate()){
      String equation = "3x^2 + 5x - 2 = 0";
      double? a, b, c, delta, root1, root2;
      String result = '';

      // extract the coefficients using regular expressions
      RegExp exp = RegExp(r'(-?\d+)x\^2\s*([+\-]\s*\d+)x\s*([+\-]\s*\d+)\s*=\s*0');
      Match match = exp.firstMatch(equation) as Match;
      a = double.parse(match.group(1)!);
      b = double.parse(match.group(2)!.replaceAll(' ', ''));
      c = double.parse(match.group(3)!.replaceAll(' ', ''));

      // display the quadratic equation to the user
      result += 'Step 1: The quadratic equation is:\n';
      result += '$a*x^2 + $b*x + $c = 0\n\n';

      // apply the quadratic formula
      delta = b*b- 4 * a* c;

      // display the discriminant to the user
      result += 'Step 2: The discriminant of the quadratic equation is:\n';
      result += 'delta = $b^2 - 4*$a*$c = $delta\n\n';

      if (delta < 0) {
        // no real roots
        result += 'Step 3: The equation has no real roots\n';
      } else if (delta == 0) {
        // one real root
        root1 = -b / (2 * a);
        result += 'Step 3: The equation has one real root:\n';
        result += 'x = -b / 2a = $root1\n';
      } else {
        // two real roots
        root1 = (-b + sqrt(delta)) / (2 * a);
        root2 = (-b - sqrt(delta)) / (2 * a);
        result += 'Step 3: The equation has two real roots:\n';
        result += 'x1 = (-$b + sqrt($delta)) / ${2*a} = $root1\n';
        result += 'x2 = (-$b - sqrt($delta)) / ${2*a} = $root2\n';
      }

      // display the final result to the user
      print(result);
      // Navigator.of(context).push(CustomRoute(page: SolutionPage(scannedText: textEditingController.text)));
      Navigator.of(context).push(CustomRoute(page: SolutionPage(scannedText: result)));
    }else{
      showMessage(context, "Please select the image or ask question");
    }
  }


  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      textEditingController.text = "Error occured while scanning";
      print(e);
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    textEditingController.text = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        textEditingController.text = textEditingController.text + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
