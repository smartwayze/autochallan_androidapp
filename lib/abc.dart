import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';


class ModelPredictionPage extends StatefulWidget {
  final File imageFile;
  final String prediction;

  const ModelPredictionPage({required this.imageFile, required this.prediction, Key? key}) : super(key: key);

  @override
  State<ModelPredictionPage> createState() => _ModelPredictionPageState();
}

class _ModelPredictionPageState extends State<ModelPredictionPage> {
  String? uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    uploadImageToCloudinary(widget.imageFile);
  }
  Future<void> uploadImageToCloudinary(File imageFile) async {
    const cloudName = "dgunybibz";
    const uploadPreset = "chalaan_app_preset";

    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      final imageUrl = data['secure_url'];

      setState(() {
        uploadedImageUrl = imageUrl;
      });

      print("✅ Image uploaded");

      // Save to Firestore
      await FirebaseFirestore.instance.collection('uploaded_images').add({
        'url': imageUrl,
        'status': 'pending',
        'prediction': widget.prediction,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("✅ Image URL saved to Firestore");
    } else {
      print("❌ Failed to upload image. Status: ${response.statusCode}");
    }
  }
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Result")),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 450,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 7),
                    ),
                    child: Image.file(
                      widget.imageFile,
                      width: 350,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.prediction,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  if (uploadedImageUrl != null) ...[
                    SizedBox(height: 20),
                    Text("Image uploaded to Cloudinary!"),
                  ],
                ],
              ),
            ),

            // 👇 Bottom-right corner button
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CarDetectionScreen()));
                },
                child: Icon(Icons.arrow_forward),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      );
    }}
