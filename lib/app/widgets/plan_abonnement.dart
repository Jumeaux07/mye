import 'package:flutter/material.dart';

import 'soucription_plan.dart';

class SubscriptionView extends StatelessWidget {
  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      name: 'Gratuit',
      price: '0FCFA',
      color: Colors.grey.shade200,
      features: [
        'Fonctionnalités de base',
        'Messages limités',
        'Support par email',
      ],
    ),
    SubscriptionPlan(
      name: 'Premium',
      price: '9.99FCFA/mois',
      color: Colors.blue.shade100,
      isPopular: true,
      features: [
        'Fonctionnalités illimitées',
        'Messages illimités',
        'Support prioritaire',
        'Pas de publicités',
      ],
    ),
    SubscriptionPlan(
      name: 'Pro',
      price: '19.99FCFA/mois',
      color: Colors.purple.shade100,
      features: [
        'Tout Premium inclus',
        'Accès API',
        'Support dédié 24/7',
        'Statistiques avancées',
        'Personnalisation complète',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Abonnements'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            color: plan.color,
            child: Stack(
              children: [
                if (plan.isPopular)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Plus populaire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        plan.price,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      ...plan.features.map((feature) => Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text(feature),
                              ],
                            ),
                          )),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implémenter la logique d'abonnement
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Abonnement ${plan.name} sélectionné'),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Choisir ${plan.name}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
