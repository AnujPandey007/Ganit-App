import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

double height(context) {
  var myHeight = MediaQuery.of(context).size.height;
  return myHeight;
}

double width(context) {
  var myWidth = MediaQuery.of(context).size.width;
  return myWidth;
}

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  border: InputBorder.none,
  hintStyle: TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  ),
);

const textStyleForQuestionAndAnswer = TextStyle(
    fontSize: 13,
    fontFamily: 'Public Sans',
    color: Colors.black
);

void showMessage(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

Widget customButton(String buttonName, Function function, double width, Color color, Color textColor){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 2.0),
    child: MaterialButton(
        color: color,
        elevation: 0.0,
        highlightElevation: 0.0,
        highlightColor: Colors.blueAccent.shade200,
        height: 50.0,
        minWidth: width,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () async{
          await function();
        },
        child:  Text(
          buttonName,
          style: TextStyle(color: textColor),
        )
    ),
  );
}


Future<bool> askDialog(context, String message) async{
  return (await showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        title: Text(
          message,
          style: TextStyle(
              fontSize: 15.0
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            shape: StadiumBorder(),
            elevation: 1.0,
            color: Colors.white,
            child: Text(
              "Yes",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12
              ),
            ),
            splashColor: Colors.blue[100],
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context,true);
            },
          ),
          MaterialButton(
            shape: StadiumBorder(),
            elevation: 3.0,
            color: Colors.white,
            child: Text(
              "No",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12
              ),
            ),
            splashColor: Colors.blue[100],
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context,false);  //if its true then it will exit
            },
          ),
        ],
      )
  ))??false;
}

Widget cameraButton(String title, IconData icon, Function function) {
  return Container(
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
        if(title=="Camera"){
          function(ImageSource.camera);
        }else{
          function(ImageSource.gallery);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 5, horizontal: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[600]),
            )
          ],
        ),
      ),
    )
  );
}

Widget imageContainer(BuildContext context, Widget widget) {
  return Container(
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
    child: Center(child: widget)
  );
}
