import 'package:flutter/material.dart';

class SubscriptionPlan {
  final String name;
  final String price;
  final List<String> features;
  final Color color;
  final bool isPopular;

  SubscriptionPlan({
    required this.name,
    required this.price,
    required this.features,
    required this.color,
    this.isPopular = false,
  });
}
