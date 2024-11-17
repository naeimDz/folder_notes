import 'package:flutter/material.dart';
import 'package:my_lab/screen/add_word/widgets/step_container.dart';
import 'package:my_lab/screen/shared/widgets/build_text_field.dart';

class ThirdStepForm extends StatelessWidget {
  const ThirdStepForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StepContainer(
      stepIndex: 2,
      title: "Metadata",
      child: Column(
        children: [
          buildModernTextField(
            context,
            label: "Tags",
            hint: "Add keywords or categories related to the word",
            suffix: const Icon(Icons.tag_sharp),
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            context,
            label: "Synonyms",
            hint: "List words that have the same or similar meaning.",
          ),
          const SizedBox(height: 16),
          buildModernTextField(
            context,
            label: "Antonyms",
            hint: "List words that have the opposite meaning.",
          ),
        ],
      ),
    );
  }
}
