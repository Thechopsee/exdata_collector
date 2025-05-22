import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:background_remover/background_remover.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RemoveBackgroundPage extends StatefulWidget {
  @override
  _RemoveBackgroundPageState createState() => _RemoveBackgroundPageState();
}

class _RemoveBackgroundPageState extends State<RemoveBackgroundPage> {
  File? _originalImage;
  File? _imageWithoutBackground;
  bool _loading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _originalImage = File(pickedFile.path);
      _imageWithoutBackground = null;
    });

    await _removeBackground(File(pickedFile.path));
  }

  Future<void> _removeBackground(File imageFile) async {
    setState(() => _loading = true);

    try {
      final imageBytes = await imageFile.readAsBytes();
      final Uint8List resultBytes = await removeBackground(imageBytes: imageBytes);

      final tempDir = await getTemporaryDirectory();
      final fileName = path.basenameWithoutExtension(imageFile.path);
      final resultFile = File('${tempDir.path}/$fileName.png');
      await resultFile.writeAsBytes(resultBytes);

      setState(() {
        _imageWithoutBackground = resultFile;
      });
    } catch (e) {
      print("Chyba při odstraňování pozadí: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nepodařilo se odebrat pozadí')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Odebrání pozadí')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Vybrat obrázek'),
            ),
            SizedBox(height: 20),
            if (_loading) CircularProgressIndicator(),
            if (_originalImage != null) ...[
              SizedBox(height: 20),
              Text('Původní obrázek:'),
              Image.file(_originalImage!),
            ],
            if (_imageWithoutBackground != null) ...[
              SizedBox(height: 20),
              Text('Bez pozadí:'),
              Image.file(_imageWithoutBackground!),
            ],
          ],
        ),
      ),
    );
  }

}
