import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'results.dart';

Future<Map<String, dynamic>> predictImage(File imageFile) async {
  final url = 'http://192.168.1.39:52320/predict';  // Replace with your Flask server URL
var http;
  var request = http.MultipartRequest('POST', Uri.parse(url));
  
  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();
  var responseString = await response.stream.bytesToString();
  var result = jsonDecode(responseString);

  return result;
}

class CapturePage extends StatefulWidget {
  @override
  _CapturePageState createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  File? _image;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      var result = await predictImage(_image!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(result: result['message'] ?? 'Unknown result'),
        ),
      );
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(result: 'Error: $e'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Pick Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: _isUploading ? CircularProgressIndicator() : const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
