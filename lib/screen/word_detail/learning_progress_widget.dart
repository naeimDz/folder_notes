import 'package:flutter/material.dart';
import 'custom_section.dart'; // Assuming _buildCustomCard is moved to this file

class LearningProgressWidget extends StatelessWidget {
  final String reviewStatus;
  final double masteryScore;

  const LearningProgressWidget({
    super.key,
    required this.reviewStatus,
    required this.masteryScore,
  });

  Widget _buildProgressIndicator(double value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: color.withOpacity(0.2),
        valueColor: AlwaysStoppedAnimation<Color>(color),
        minHeight: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomSection(
      title: "Learning Progress",
      backgroundColor: Colors.purple[50],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mastery Level",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reviewStatus,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quiz Accuracy",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "${masteryScore.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildProgressIndicator(
                masteryScore / 100.0,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
