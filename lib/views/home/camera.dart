import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import './image_detail.dart';
import '../../main.dart';
import '../../style.dart';


class CameraApp extends StatefulWidget {

  @override
  _CameraAppState createState() => _CameraAppState();
}


void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraAppState extends State<CameraApp> with WidgetsBindingObserver{

  CameraController controller;
  String imagePath;

  int cam = 0;
 
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        this.cam = 0;
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      
      body: Column(
        children: <Widget>[
           
       
          Container(
            padding: EdgeInsets.only(top: 80.0),
            child: _cameraPreviewWidget(),            
            decoration: BoxDecoration(
              color: Colors.black,
             ),
          ),

           SizedBox(height: 20.0,),
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              back(),
              _captureControlRowWidget(),
              toogleDirection(),
              //_thumbnailWidget(),
            ],
          ),       
        ],
      ),
      
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }


  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            imagePath == null ? Container() : SizedBox(
                    child: Image.file(File(imagePath)),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
       
    return RaisedButton(
      padding: EdgeInsets.all(20.0),
      child: const Icon(Icons.camera_alt),
      color: Colors.blue,
      shape: CircleBorder(),
      onPressed: controller != null &&
              controller.value.isInitialized &&
              !controller.value.isRecordingVideo
          ? onTakePictureButtonPressed
          : null,
    );
     
  }

  Widget toogleDirection(){
    int dir = this.cam == 0 ? 1 : 0;
    return RaisedButton(
      shape: CircleBorder(),
      padding: EdgeInsets.all(18.0),
      child: Icon(Icons.switch_camera,),
      onPressed: () {
        this.controller = CameraController(cameras[dir], ResolutionPreset.medium);
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            this.cam = dir;
          });
        });
      },
    );

  }

  Widget back(){
    return RaisedButton(
      shape: CircleBorder(),
      padding: EdgeInsets.all(18.0),
      child: Icon(Icons.arrow_back,),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }



  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }



  // CameraController controller;

  // @override
  // void initState() {
    
  //   super.initState();

  //   controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
  //   controller.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   });
  // }

  // @override
  // void dispose() {

  //   controller?.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   if (!controller.value.isInitialized) {
  //     return Container();
  //   }
  //   return Scaffold(

  //     backgroundColor: Colors.black,
  //     appBar: AppBar(
  //       title: Text("Photo"),
  //     ),

  //     body: AspectRatio(
  //       aspectRatio: controller.value.aspectRatio,
  //       child: CameraPreview(controller)),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  //     floatingActionButton: FloatingActionButton(
  //       child: Icon(Icons.camera),
  //       onPressed: () => _takePicturePressed(),
  //     ),
  //   );

  // }

  // void _takePicturePressed() {
  //   _takePicture().then((String filePath) {
  //     if (mounted) {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDetail(filePath)));
  //     }
  //   });
  // }
  
  // String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  // Future<String> _takePicture() async {
  //   if (!controller.value.isInitialized) {
  //     print("Controller is not initialized");
  //     return null;
  //   }
  //   final Directory extDir = await getApplicationDocumentsDirectory();
  //   final String photoDir = '${extDir.path}/Photos/image_test';
    
  //   await Directory(photoDir).create(recursive: true);
  //   final String filePath = '$photoDir/${timestamp()}.jpg';

  //   if (controller.value.isTakingPicture) {
  //     print("Currently already taking a picture");
  //     return null;
  //   }

  //   try {
  //     await controller.takePicture(filePath);
  //   } on CameraException catch (e) {
  //     print("camera exception occured: $e");
  //     return null;
  //   }

  //   return filePath;
  // }
}