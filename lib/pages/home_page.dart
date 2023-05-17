import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:ganit/pages/solution_page.dart';
import 'package:ganit/services/mathService.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../shared/constants.dart';
import '../shared/curve.dart';
import '../shared/customRoute.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? imageFile;
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  double lowerBound = 0;
  double upperBound = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: customButton("Solve", solution, width(context)*0.9, Colors.blueAccent, Colors.white),
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
                children: [
                  SizedBox(height: height(context)*0.15,),
                  if (imageFile == null)...[
                    imageContainer(context, const Icon(Icons.image, color: Colors.grey, size: 70,))
                  ]else...[
                    imageContainer(context, Image.file(File(imageFile!.path)))
                  ],
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cameraButton("Gallery", Icons.image, getImage),
                      cameraButton("Camera", Icons.camera_alt, getImage)
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  writeQuestion(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Center(
                          child: MaterialButton(
                            height: height(context)*0.04,
                              minWidth: 50,
                              color: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)
                              ),
                              onPressed: () {
                                  textEditingController.text += '∫';
                                  textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
                              },
                            child: const Text('∫', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Lower Bound:'),
                                GestureDetector(
                                    onTap: () => setState(() {
                                      lowerBound == 0 ? print('counter at 0') : lowerBound--;
                                    }),
                                    child: const Icon(Icons.remove)),
                                Text('$lowerBound'),
                                GestureDetector(
                                    onTap: () {setState(() {
                                      lowerBound++;
                                    });},
                                    child: const Icon(Icons.add)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Upper Bound:'),
                                GestureDetector(
                                    onTap: () => setState(() {
                                      upperBound == 0 ? print('counter at 0') : upperBound--;
                                    }),
                                    child: const Icon(Icons.remove)),
                                Text('$upperBound'),
                                GestureDetector(
                                    onTap: () {setState(() {
                                      upperBound++;
                                    });},
                                    child: const Icon(Icons.add)),
                              ],
                            ),
                          ],
                        ),
                      ],
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
      try{
        // String equation = "∫ x^2";
        // String equation = "4x-8=0";
        // String equation = "2x^2+5x-20=0";
        String equation = textEditingController.text;

        String result = "No Question";

        if(equation.contains('∫')){
          result = MathService.solveIntegration(equation.replaceAll("∫", "").replaceAll("dx", ""), lowerBound, upperBound);
        }else if(equation.contains('x') && !equation.contains('^')){
          result = MathService.solveLinear(equation);
        }else if(equation.contains('x^2')){
          result = MathService.solveQuadratic(equation);
        }else{
          result = textEditingController.text.interpret().toString();
        }
        Navigator.of(context).push(CustomRoute(page: SolutionPage(answer: result, question: textEditingController.text)));
      }catch(e){
        showMessage(context, "Error");
      }
    }else{
      showMessage(context, "Please select the image or ask question");
    }
  }

  void _cropImage(XFile picked) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
       uiSettings: [
         AndroidUiSettings(
             toolbarTitle: 'Cropper',
             toolbarColor: Colors.blueAccent,
             toolbarWidgetColor: Colors.white,
             initAspectRatio: CropAspectRatioPreset.original,
             lockAspectRatio: false),
       ],
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
      maxWidth: 800,
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = XFile(croppedFile.path);
      });
      getRecognisedText(InputImage.fromFilePath(imageFile!.path));
    }else{
      setState(() {
        imageFile = null;
        textEditingController.text = "Error occurred while scanning";
      });
    }
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
        });
        _cropImage(XFile(pickedImage.path));
      }
    } catch (e) {
      setState(() {
        imageFile = null;
        textEditingController.text = "Error occurred while scanning";
      });
    }
  }

  void getRecognisedText(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(image);
    textEditingController.text = recognizedText.text;
  }

  Widget writeQuestion() {
    return Padding(
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
    );
  }

}
