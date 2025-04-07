import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Widget pour afficher une compétence
class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey[200],
    );
  }
}
