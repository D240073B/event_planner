import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_ai/firebase_ai.dart';

/// Service for generating event planning suggestions using
/// Firebase AI Logic (Gemini).
class SuggestionService {
  /// Generates event planning suggestions based on the given [prompt].
  ///
  /// Returns a [Map] containing structured suggestions parsed from
  /// the Gemini model's JSON response.
  static Future<Map<String, dynamic>> generateSuggestions(
    String prompt,
  ) async {
    try {
      // Get the generative model from Firebase AI
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
      );

      // Send the prompt and get the response
      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception('Empty response from AI model');
      }

      debugPrint('AI Response: $text');

      // Try to extract JSON from the response
      // The model may wrap the JSON in markdown code blocks
      String jsonString = text.trim();

      // Remove markdown code block markers if present
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      } else if (jsonString.startsWith('```')) {
        jsonString = jsonString.substring(3);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      jsonString = jsonString.trim();

      // Parse the JSON response
      final Map<String, dynamic> suggestions =
          jsonDecode(jsonString) as Map<String, dynamic>;
      return suggestions;
    } catch (e) {
      debugPrint('Suggestion generation error: $e');
      rethrow;
    }
  }
}
