import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Result screen that displays the AI-generated event poster
/// and AI-generated event planning suggestions.
class ResultScreen extends StatelessWidget {
  final Uint8List? imageBytes;
  final Map<String, dynamic>? suggestions;
  final String? imageError;
  final String? suggestionError;

  const ResultScreen({
    super.key,
    this.imageBytes,
    this.suggestions,
    this.imageError,
    this.suggestionError,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Plan Results'),
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
            // ── AI-Generated Poster Section ──
            _buildSectionHeader(
              'AI-Generated Event Poster',
              Icons.image,
            ),
            const SizedBox(height: 12),
            _buildPosterSection(),
            const SizedBox(height: 24),

            // ── AI-Generated Suggestions Section ──
            _buildSectionHeader(
              'AI Event Planning Suggestions',
              Icons.lightbulb,
            ),
            const SizedBox(height: 12),
            _buildSuggestionsSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Builds a styled section header.
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  /// Builds the poster display card.
  Widget _buildPosterSection() {
    if (imageError != null) {
      return Card(
        color: Colors.red.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Failed to generate poster',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                imageError!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (imageBytes == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No poster generated')),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            padding: const EdgeInsets.all(32),
            color: Colors.grey.shade200,
            child: const Column(
              children: [
                Icon(Icons.broken_image, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('Unable to display image'),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the suggestions display section.
  Widget _buildSuggestionsSection() {
    if (suggestionError != null) {
      return Card(
        color: Colors.red.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Failed to generate suggestions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                suggestionError!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (suggestions == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No suggestions generated')),
        ),
      );
    }

    final data = suggestions!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Event Title
        if (data['event_title'] != null)
          _buildInfoCard(
            'Event Title',
            Icons.title,
            data['event_title'].toString(),
          ),

        // Schedule / Timeline
        if (data['schedule'] != null)
          _buildScheduleCard(data['schedule'] as List<dynamic>),

        // Venue Setup
        if (data['venue_setup'] != null)
          _buildInfoCard(
            'Venue Setup',
            Icons.room_preferences,
            data['venue_setup'].toString(),
          ),

        // Budget Breakdown
        if (data['budget_breakdown'] != null)
          _buildBudgetCard(
            data['budget_breakdown'] as Map<String, dynamic>,
          ),

        // Suggested Activities
        if (data['suggested_activities'] != null)
          _buildListCard(
            'Suggested Activities',
            Icons.sports_esports,
            (data['suggested_activities'] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
          ),

        // Logistics Checklist
        if (data['logistics_checklist'] != null)
          _buildListCard(
            'Logistics Checklist',
            Icons.checklist,
            (data['logistics_checklist'] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
          ),

        // Tips
        if (data['tips'] != null)
          _buildInfoCard(
            'Tips',
            Icons.tips_and_updates,
            data['tips'].toString(),
          ),
      ],
    );
  }

  /// A simple card with a title and body text.
  Widget _buildInfoCard(String title, IconData icon, String body) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(body, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  /// A card that displays the schedule timeline.
  Widget _buildScheduleCard(List<dynamic> schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.schedule, color: Colors.deepPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Schedule / Timeline',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...schedule.map((item) {
              final entry = item as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        entry['time']?.toString() ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry['activity']?.toString() ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// A card that displays the budget breakdown.
  Widget _buildBudgetCard(Map<String, dynamic> budget) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance_wallet,
                    color: Colors.deepPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Budget Breakdown',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...budget.entries.map((entry) {
              // Format the key from snake_case to Title Case
              final label = entry.key
                  .replaceAll('_', ' ')
                  .split(' ')
                  .map((w) =>
                      w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
                  .join(' ');
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 14)),
                    Text(
                      'RM ${entry.value}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// A card that displays a list of items with bullet points.
  Widget _buildListCard(String title, IconData icon, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 14)),
                    Expanded(
                      child: Text(item, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
