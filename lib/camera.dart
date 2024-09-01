import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:typed_data'; // Needed for Uint8List
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Needed for kIsWeb
import 'package:camera/camera.dart'; // Camera package
import 'results.dart'; // Import the results.dart page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crop Disease Detector',
      theme: ThemeData(
        //primarySwatch: Colors.teal,
        backgroundColor: const Color.fromARGB(255, 40, 68, 20),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.orange),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.green),
          titleMedium: TextStyle(fontSize: 18.0, color: Colors.grey),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green, // Default color for other buttons
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 40, 68, 20),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _pickedFile;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  String _result = '';

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
        });

        _imageBytes = await pickedFile.readAsBytes();
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> _openCamera() async {
    await availableCameras().then((cameras) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            cameras: cameras,
            onImageCaptured: (XFile capturedImage) {
              setState(() {
                _pickedFile = capturedImage;
                capturedImage.readAsBytes().then((bytes) {
                  setState(() {
                    _imageBytes = bytes;
                  });
                });
              });
            },
          ),
        ),
      );
    }).catchError((e) {
      print('Error: $e');
    });
  }

  Future<void> _uploadImage() async {
    if (_pickedFile == null) return;

    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(result: _result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 68, 20),
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/logo3.jpg',
              height: 70,
              width: 75,
            ),
            const SizedBox(width: 10),
            /*const Text(
              'Cropspect',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),*/
          ],
        ),
        titleSpacing: 0,
      ),
      body: Stack(
        children: <Widget>[
          
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
         
          Positioned(
            left: 0,
            top: 0,
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(10, (index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 30),
                      width: 100,
                      height: 150,
                      child: AnimatedLeaf(color: Color.fromARGB(255, 2, 74, 4)),
                    );
                  }),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(10, (index) {
                    return Container(
                      margin: EdgeInsets.only(top: 30),
                      width: 100,
                      height: 150,
                      child:
                          AnimatedLeaf(color: Color.fromARGB(255, 8, 240, 66)),
                    );
                  }),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _imageBytes == null
                    ? Text('No image selected.',
                        style: Theme.of(context).textTheme.bodyLarge)
                    : Container(
                        width: 270,
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Pick Image from Gallery'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _openCamera,
                  child: const Text('Pick Image from Camera'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: const Text('Upload Image'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(
                        255, 45, 111, 63), // Custom color for "Submit" button
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _result,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function(XFile) onImageCaptured;

  const CameraScreen({
    Key? key,
    required this.cameras,
    required this.onImageCaptured,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    _cameraController = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController!.takePicture();
      widget.onImageCaptured(image);
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                Positioned(
                  bottom: 30,
                  left: MediaQuery.of(context).size.width * 0.5 - 30,
                  child: FloatingActionButton(
                    onPressed: _takePicture,
                    child: const Icon(Icons.camera),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class AnimatedLeaf extends StatefulWidget {
  final Color color;

  const AnimatedLeaf({Key? key, required this.color}) : super(key: key);

  @override
  _AnimatedLeafState createState() => _AnimatedLeafState();
}

class _AnimatedLeafState extends State<AnimatedLeaf>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late double randomDelay;

  @override
  void initState() {
    super.initState();
    randomDelay = math.Random().nextDouble() * 3;

    _animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Future.delayed(Duration(seconds: randomDelay.toInt()), () {
      _animationController.repeat();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _animation.value,
      child: Icon(Icons.local_florist, color: widget.color),
    );
  }
}
