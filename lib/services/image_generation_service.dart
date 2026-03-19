import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service for generating event poster images using Hugging Face
/// Stable Diffusion API.
class ImageGenerationService {
  static const String _apiToken = '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';
  static const String _modelUrl =
      'https://router.huggingface.co/hf-inference/models/stabilityai/stable-diffusion-xl-base-1.0';

  /// Generates an image from the given [prompt] using Stable Diffusion.
  ///
  /// Returns the raw image bytes as [Uint8List].
  /// Throws an [Exception] if the request fails.
  static Future<Uint8List> generateImage(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_modelUrl),
        headers: {
          'Authorization': 'Bearer $_apiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'inputs': prompt}),
      );

      if (response.statusCode == 200) {
        // The API returns raw image bytes on success
        return response.bodyBytes;
      } else {
        final errorBody = response.body;
        debugPrint('Image generation failed: $errorBody');
        throw Exception(
          'Failed to generate image (HTTP ${response.statusCode}): $errorBody',
        );
      }
    } catch (e) {
      debugPrint('Image generation error: $e');
      rethrow;
    }
  }
}
