import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class ImageHandler {
  Future<String?> convertImageToBase64(String? imagePath) async {
    if (imagePath == null) return null;
    try {
      // debugPrint('Converting image to base64: $imagePath');
      final bytes = await readImageAsBytes(imagePath);
      if (bytes == null) {
        throw Exception("Failed to load image");
      }
      final base64String = base64Encode(bytes);
      final mimeType = lookupMimeType(imagePath, headerBytes: bytes);
      debugPrint('MIME type: $mimeType');
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      debugPrint('Error in convertImageToBase64: $e');
      return 'Error';
    }
  }

  Future<Uint8List?> readImageAsBytes(String url) async {
    try {
      // debugPrint('Reading image as bytes from URL: $url');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        debugPrint('Failed to load image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
      return null;
    }
  }
}
