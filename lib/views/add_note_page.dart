import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/growth_log.dart';
import 'package:flutter_app/services/image_handler.dart';
import 'package:flutter_app/repositories/plant_repo.dart';
import 'package:flutter_app/repositories/growth_log_repo.dart';

class AddNotePage extends StatefulWidget {
  final String plantID;

  AddNotePage({required this.plantID});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final PlantRepository _plantRepository = PlantRepository();
  final GrowthLogRepository _growthLogRepository = GrowthLogRepository();

  final ImageHandler imageHandler = ImageHandler();
  File? _selectedImage;
  String? _selectedImageUrl;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          _selectedImageUrl = pickedFile.path;
        } else {
          _selectedImage = File(pickedFile.path);
        }
      });
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('選擇照片'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void _saveGrowthLog() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    FocusScope.of(context).unfocus();
    _nameController.clear();
    _descriptionController.clear();

    String? base64ImageUrl = await imageHandler.convertImageToBase64(
        kIsWeb ? _selectedImageUrl : _selectedImage?.path);

    if (name.trim().isEmpty || description.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('名稱和描述不能為空')));
      return;
    }

    if (base64ImageUrl == null) {
      final plant = await _plantRepository.getPlantByID(widget.plantID);
      base64ImageUrl = plant?.imageUrl;
    }

    final growthLog = GrowthLog(
      name: name,
      imageUrl: base64ImageUrl ?? '',
      description: description,
      timestamp: Timestamp.now(),
    );

    await _growthLogRepository.addGrowthLog(widget.plantID, growthLog);
    setState(() {
      _selectedImage = null;
      _selectedImageUrl = null; // Clear the picked image
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Add Growth Log',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            if (_selectedImage != null || _selectedImageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: kIsWeb
                    ? Image.network(_selectedImageUrl!)
                    : Image.file(_selectedImage!),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _showAttachmentOptions,
              child: Text(
                '附件',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 93, 176, 117),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveGrowthLog,
                child: Text(
                  '儲存',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 93, 176, 117),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
