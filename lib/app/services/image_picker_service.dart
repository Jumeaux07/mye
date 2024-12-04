import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the device and convert it to base64
  Future<String?> pickImageAndConvertToBase64({
    ImageSource source = ImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int imageQuality = 70,
  }) async {
    try {
      // Pick image from the specified source
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality, // Compression quality (0-100)
      );

      // Check if an image was picked
      if (pickedFile == null) {
        return null;
      }

      // Read the image file
      File imageFile = File(pickedFile.path);

      // Convert image to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      return base64Image;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Safely display base64 image
  Widget displayBase64Image(String? base64String, {BoxFit? fit}) {
    if (base64String == null || base64String.isEmpty) {
      return Text('No image selected');
    }

    try {
      // Remove data URI prefix if present
      String cleanBase64 = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;

      // Ensure base64 string length is a multiple of 4
      cleanBase64 = _padBase64(cleanBase64);

      return Image.memory(
        base64Decode(cleanBase64),
        fit: fit ?? BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error displaying base64 image: $error');
          return Text('Invalid image');
        },
      );
    } catch (e) {
      print('Error processing base64 image: $e');
      return Text('Error loading image');
    }
  }

  /// Pad base64 string to ensure it's properly formatted
  String _padBase64(String base64) {
    String paddedBase64 = base64;
    int padLength = 4 - (paddedBase64.length % 4);
    if (padLength < 4) {
      paddedBase64 += ('=' * padLength);
    }
    return paddedBase64;
  }
}

// Example usage in a widget
class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  String? _base64Image;

  Future<void> _pickImage() async {
    final base64Image = await _imagePickerService.pickImageAndConvertToBase64();

    setState(() {
      _base64Image = base64Image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display picked image if available
            if (_base64Image != null)
              SizedBox(
                width: 200,
                height: 200,
                child: _imagePickerService.displayBase64Image(_base64Image),
              ),

            // Button to pick image
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
          ],
        ),
      ),
    );
  }
}
