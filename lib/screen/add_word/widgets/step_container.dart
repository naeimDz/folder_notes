import 'package:flutter/material.dart';
import 'package:my_lab/providers/form_state_provider.dart';
import 'package:provider/provider.dart';

class StepContainer extends StatelessWidget {
  final int stepIndex;
  final String title;
  final Widget child;

  const StepContainer({
    required this.stepIndex,
    required this.title,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<FormStateProvider, (int, bool?)>(
      selector: (_, provider) => (
        provider.state.currentStep,
        provider.state.completedSteps[stepIndex] ?? false
      ),
      builder: (context, data, _) {
        final (currentStep, isCompleted) = data;
        final isCurrentStep = currentStep == stepIndex;

        final iconSize = MediaQuery.of(context).size.width * 0.08;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isCurrentStep
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStepIndicator(context, isCompleted, iconSize),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (currentStep == 0)
                Text(
                    "**Please complete all of the following fields to proceed."),
              if (currentStep != 0)
                Text(
                    "This step is optional. You can skip it or provide additional details."),
              const SizedBox(height: 16),
              if (isCurrentStep || isCompleted!)
                Expanded(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: child,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepIndicator(
      BuildContext context, bool? isCompleted, double size) {
    return Semantics(
      label: isCompleted == true ? 'Step completed' : 'Step ${stepIndex + 1}',
      child: isCompleted == true
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
              size: size,
            )
          : Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${stepIndex + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
