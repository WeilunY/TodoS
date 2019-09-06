// import 'package:flutter/material.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'dart:io';

// class ImageDetail extends StatefulWidget {
//   ImageDetail(this.filePath);

//   final String filePath;

//   @override
//   _ImageDetailState createState() => new _ImageDetailState(filePath);
// }

// class _ImageDetailState extends State<ImageDetail> {
//   _ImageDetailState(this.filePath);

//   final String filePath;

//   String recognizedText = "Loading ...";

//   void _initializeVision() async {
//     // get image file
//     final File imageFile = File(filePath);

//     // create vision image from that file
//     final FirebaseVisionImage visionImage =
//         FirebaseVisionImage.fromFile(imageFile);

//     // create detector index
//     final TextRecognizer textRecognizer =
//         FirebaseVision.instance.textRecognizer();

//     // find text in image
//     final VisionText visionText =
//         await textRecognizer.processImage(visionImage);

//     String result = "";
        
//     for (TextBlock block in visionText.blocks) {
//       for (TextLine line in block.lines) {
//         {
//          result += line.text;
//         }
//       }
//     }

//     textRecognizer.close();

//     if (this.mounted) {
//       setState(() {
//         recognizedText = result;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _initializeVision();

//     return Scaffold(
//         appBar: AppBar(title: Text("Taken Photo")),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(top: 40.0),
//               child: new Container(
//                 height: 300,
//                 child: Center(child: Image.file(File(filePath))),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(40.0),
//               child: Text(
//                 "Extracted Text:",
//                 style: Theme.of(context).textTheme.headline,
//               ),
//             ),
//             Padding(
//                 padding: EdgeInsets.all(40.0),
//                 child: Text(
//                   recognizedText,
//                   style: Theme.of(context).textTheme.body1,
//                 )),
//           ],
//         ));
//   }
// }