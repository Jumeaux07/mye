import 'package:flutter/material.dart';

// Widget pour afficher une expérience professionnelle
class ExperienceItem extends StatelessWidget {
  final String company;
  final String position;
  final String period;
  final String description;

  const ExperienceItem({
    required this.company,
    required this.position,
    required this.period,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          company,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          position,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 4),
        Text(
          period,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
