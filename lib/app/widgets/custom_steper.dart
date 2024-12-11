import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  // Liste des vues/étapes
  final List<Widget> views;

  // Titres optionnels pour chaque étape
  final List<String>? stepTitles;

  // Callback pour suivre l'étape courante
  final ValueChanged<int>? onStepChanged;

  // Style de progression
  final StepperType stepperType;

  const CustomStepper({
    Key? key,
    required this.views,
    this.stepTitles,
    this.onStepChanged,
    this.stepperType = StepperType.horizontal,
  })  :
        // Validation que les titres correspondent au nombre de vues si fournis
        assert(stepTitles == null || stepTitles.length == views.length),
        super(key: key);

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  // Index de l'étape courante
  int _currentStep = 0;

  // Méthode pour aller à l'étape suivante
  void _nextStep() {
    if (_currentStep < widget.views.length - 1) {
      setState(() {
        _currentStep++;
      });
      widget.onStepChanged?.call(_currentStep);
    }
  }

  // Méthode pour revenir à l'étape précédente
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      widget.onStepChanged?.call(_currentStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: widget.stepperType,
      currentStep: _currentStep,

      // Construction des étapes
      steps: List.generate(widget.views.length, (index) {
        return Step(
          title: Text(widget.stepTitles?[index] ?? 'Étape ${index + 1}'),
          content: widget.views[index],
          state: _getStepState(index),
          isActive: _currentStep == index,
        );
      }),

      // Contrôles de navigation
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Row(
          children: <Widget>[
            // Bouton Suivant
            if (_currentStep < widget.views.length - 1)
              ElevatedButton(
                onPressed: _nextStep,
                child: const Text('Suivant'),
              ),

            // Bouton Précédent
            if (_currentStep > 0)
              TextButton(
                onPressed: _previousStep,
                child: const Text('Précédent'),
              ),

            // Bouton Terminer pour la dernière étape
            if (_currentStep == widget.views.length - 1)
              ElevatedButton(
                onPressed: () {
                  // Action de finalisation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processus terminé')),
                  );
                },
                child: const Text('Terminer'),
              ),
          ],
        );
      },
    );
  }

  // Déterminer l'état de chaque étape
  StepState _getStepState(int index) {
    if (_currentStep == index) {
      return StepState.editing;
    } else if (_currentStep > index) {
      return StepState.complete;
    } else {
      return StepState.disabled;
    }
  }
}
