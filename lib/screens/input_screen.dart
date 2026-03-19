import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/image_generation_service.dart';
import '../services/suggestion_service.dart';
import 'result_screen.dart';

/// Input screen where users configure event parameters.
class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  // Controllers
  final TextEditingController _budgetController = TextEditingController();

  // Slider values
  double _duration = 2; // hours
  double _participants = 50;

  // Dropdown values
  String _selectedTheme = 'Tech Talk';
  String _selectedLocation = 'Hall';

  // Dropdown options
  final List<String> _themes = [
    'Tech Talk',
    'Gaming Night',
    'Charity Event',
    'Workshop',
    'Cultural Night',
  ];

  final List<String> _locations = [
    'Hall',
    'Classroom',
    'Outdoor Area',
    'Auditorium',
    'Lab',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  /// Builds the image generation prompt from event parameters.
  String _buildImagePrompt() {
    return 'Create a vibrant, professional event poster for a student '
        'campus event. Event theme: $_selectedTheme. '
        'Location: $_selectedLocation. '
        'Duration: ${_duration.round()} hours. '
        'Expected attendees: ${_participants.round()}. '
        'Budget: RM ${_budgetController.text}. '
        'The poster should be colorful, modern, and eye-catching with '
        'bold typography and relevant graphics. '
        'Do not include any text in the image.';
  }

  /// Builds the suggestion prompt from event parameters.
  String _buildSuggestionPrompt() {
    return '''You are an expert event planner for a university student committee.
Generate a detailed event planning suggestion in JSON format based on these parameters:

- Event Theme: $_selectedTheme
- Event Location: $_selectedLocation
- Event Duration: ${_duration.round()} hours
- Expected Participants: ${_participants.round()}
- Event Budget: RM ${_budgetController.text}

Return ONLY a valid JSON object with these keys:
{
  "event_title": "A creative title for the event",
  "schedule": [
    {"time": "start - end", "activity": "activity description"}
  ],
  "venue_setup": "Description of how to set up the venue",
  "budget_breakdown": {
    "venue": "amount",
    "food_and_beverages": "amount",
    "decorations": "amount",
    "marketing": "amount",
    "miscellaneous": "amount"
  },
  "suggested_activities": ["activity 1", "activity 2", "activity 3"],
  "logistics_checklist": ["item 1", "item 2", "item 3"],
  "tips": "Additional tips for the organiser"
}''';
  }

  /// Generates the poster and suggestions, then navigates to the result screen.
  Future<void> _generateEventPlan() async {
    // Validate budget input
    final budgetText = _budgetController.text.trim();
    if (budgetText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an event budget'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          margin: EdgeInsets.all(32),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Generating your event plan...',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Creating AI poster & suggestions',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Uint8List? imageBytes;
    Map<String, dynamic>? suggestions;
    String? imageError;
    String? suggestionError;

    // Run both AI calls in parallel
    await Future.wait([
      ImageGenerationService.generateImage(_buildImagePrompt())
          .then<void>((bytes) => imageBytes = bytes)
          .catchError((e) {
        imageError = e.toString();
      }),
      SuggestionService.generateSuggestions(_buildSuggestionPrompt())
          .then<void>((data) => suggestions = data)
          .catchError((e) {
        suggestionError = e.toString();
      }),
    ]);

    // Dismiss loading dialog
    if (mounted) {
      Navigator.of(context).pop();
    }

    setState(() => _isLoading = false);

    // Navigate to result screen
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imageBytes: imageBytes,
            suggestions: suggestions,
            imageError: imageError,
            suggestionError: suggestionError,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Planner AI'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card
            Card(
              color: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.event,
                      size: 48,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Configure Your Event',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Set the parameters below and let AI generate your event poster and planning suggestions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Event Duration Slider ---
            _buildSectionLabel('Event Duration', Icons.timer),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Text(
                      '${_duration.round()} hours',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Slider(
                      value: _duration,
                      min: 1,
                      max: 24,
                      divisions: 23,
                      label: '${_duration.round()} hours',
                      activeColor: Colors.deepPurple,
                      onChanged: (value) =>
                          setState(() => _duration = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Budget TextField ---
            _buildSectionLabel('Event Budget', Icons.attach_money),
            const SizedBox(height: 8),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter budget in RM',
                prefixText: 'RM ',
                prefixStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Participants Slider ---
            _buildSectionLabel('Expected Participants', Icons.people),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Text(
                      '${_participants.round()} people',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Slider(
                      value: _participants,
                      min: 10,
                      max: 1000,
                      divisions: 99,
                      label: '${_participants.round()}',
                      activeColor: Colors.deepPurple,
                      onChanged: (value) =>
                          setState(() => _participants = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Event Theme Dropdown ---
            _buildSectionLabel('Event Theme', Icons.palette),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              decoration: const InputDecoration(),
              items: _themes.map((theme) {
                return DropdownMenuItem(
                  value: theme,
                  child: Text(theme),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedTheme = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // --- Event Location Dropdown ---
            _buildSectionLabel('Event Location', Icons.location_on),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              decoration: const InputDecoration(),
              items: _locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLocation = value);
                }
              },
            ),
            const SizedBox(height: 32),

            // --- Generate Button ---
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _generateEventPlan,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isLoading ? 'Generating...' : 'Generate Event Plan',
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Builds a consistent section label with icon.
  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
