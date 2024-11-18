import 'package:flutter/material.dart';

// Widget pour afficher une compétence
class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[200],
    );
  }
}
