import 'package:flutter/material.dart';
import 'package:my_lab/providers/word_form_provider.dart';
import 'package:my_lab/screen/add_word/widgets/step_container.dart';
import 'package:my_lab/screen/shared/widgets/build_text_field.dart';

class SecondStepForm extends StatelessWidget {
  final WordFormState state;

  const SecondStepForm({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      stepIndex: 1,
      title: "Usage Details",
      child: Column(
        children: [
          buildModernTextField(
            context,
            label: 'Brief Definition',
            hint: 'Enter a concise definition',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            context,
            label: 'Example',
            hint: 'Enter an example sentence in English',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            context,
            label: "Usage Notes",
            hint:
                "Add additional notes about when, where, or how the word is typically used.",
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
